// ToxiUI supporter registration, running as a Cloudflare Worker.
//
//   POST /interactions  Discord slash command endpoint (/supporter register|list|remove)
//   GET  /export        Registered characters as JSON, for the GitHub sync workflow (Bearer EXPORT_TOKEN)
//
// The Worker only stores who registered which characters. Whether someone is still a supporter (and at which
// tier) is decided at sync time from their current Patreon-managed Discord roles, so lapsed members drop out
// automatically and come back without re-registering.

import { decodeExport, DecodeError, FLAVOR_LABELS } from "./decode.js";

export const TIERS = ["LEGENDARY", "EPIC", "RARE"]; // highest first
const TIER_LABELS = { LEGENDARY: "Legendary", EPIC: "Epic", RARE: "Rare" };

const EPHEMERAL = 64;
const MAX_REPLY = 1900;

export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    if (request.method === "POST" && url.pathname === "/interactions") return handleInteraction(request, env);
    if (request.method === "GET" && url.pathname === "/export") return handleExport(request, env);
    return new Response("Not found", { status: 404 });
  },
};

// ---------------------------------------------------------------------------------------------------------------------
// Discord

function hexToBytes(hex) {
  const out = new Uint8Array(hex.length / 2);
  for (let i = 0; i < out.length; i++) out[i] = parseInt(hex.substr(i * 2, 2), 16);
  return out;
}

async function verifyDiscordRequest(request, env) {
  const signature = request.headers.get("X-Signature-Ed25519");
  const timestamp = request.headers.get("X-Signature-Timestamp");
  const body = await request.text();
  if (!signature || !timestamp || !/^[0-9a-f]{128}$/i.test(signature)) return null;

  const key = await crypto.subtle.importKey("raw", hexToBytes(env.DISCORD_PUBLIC_KEY), { name: "Ed25519" }, false, ["verify"]);
  const valid = await crypto.subtle.verify("Ed25519", key, hexToBytes(signature), new TextEncoder().encode(timestamp + body));
  return valid ? body : null;
}

const json = (data, status = 200) => new Response(JSON.stringify(data), { status, headers: { "Content-Type": "application/json" } });

const reply = (content) => json({ type: 4, data: { content: truncate(content), flags: EPHEMERAL, allowed_mentions: { parse: [] } } });

function truncate(text) {
  return text.length > MAX_REPLY ? text.slice(0, MAX_REPLY) + "\n…" : text;
}

async function handleInteraction(request, env) {
  const body = await verifyDiscordRequest(request, env);
  if (!body) return new Response("Invalid request signature", { status: 401 });

  const interaction = JSON.parse(body);
  if (interaction.type === 1) return json({ type: 1 }); // PING
  if (interaction.type !== 2) return reply("Unsupported interaction.");

  const started = Date.now();
  const sub = interaction.data?.options?.[0]?.name;
  try {
    const content = await handleCommand(interaction, env);
    console.log(`supporter ${sub} ok in ${Date.now() - started}ms`);
    return reply(content);
  } catch (err) {
    console.error(`supporter ${sub} failed after ${Date.now() - started}ms`, err?.stack || err);
    return reply("❌ Something went wrong on our side. Please try again in a minute, or ping Toxi if it keeps happening.");
  }
}

export function getTier(roles, env) {
  const tierRoles = JSON.parse(env.TIER_ROLES);
  const owned = new Set(roles || []);
  return TIERS.find((tier) => tierRoles[tier] && owned.has(tierRoles[tier])) || null;
}

// First candidate that still has something left after sanitizing (e.g. a nickname that is only emoji falls back)
function displayNameOf(member) {
  for (const candidate of [member.nick, member.user.global_name, member.user.username]) {
    const clean = candidate ? sanitizeDisplayName(candidate) : "";
    if (clean) return clean;
  }
  return "Supporter";
}

// Display names end up in a Lua string and in WoW UI text. Keep only letters, marks, digits, punctuation and spaces:
// WoW fonts can't render emoji/symbols, and `|` starts WoW escape sequences.
export function sanitizeDisplayName(name) {
  return String(name)
    .replace(/[^\p{L}\p{M}\p{N}\p{P}\p{Zs}]|[|\\"]/gu, "")
    .replace(/\s+/g, " ")
    .trim()
    .slice(0, 32);
}

/** Returns the reply text. Exported for local testing. */
export async function handleCommand(interaction, env) {
  if (interaction.data?.name !== "supporter") return "Unknown command.";
  if (!interaction.member || interaction.guild_id !== env.GUILD_ID) return "Please use this command in the ToxiUI Discord server.";

  const sub = interaction.data.options?.[0];
  const options = Object.fromEntries((sub?.options || []).map((o) => [o.name, o.value]));
  const userId = interaction.member.user.id;
  const tier = getTier(interaction.member.roles, env);

  switch (sub?.name) {
    case "register":
      return register(env, userId, displayNameOf(interaction.member), tier, options.code);
    case "list":
      return list(env, userId, tier);
    case "remove":
      return remove(env, userId, options.version);
    default:
      return "Unknown subcommand.";
  }
}

async function register(env, userId, displayName, tier, code) {
  if (!tier) {
    return [
      "Badges are for **Patreon supporters**. If you're subscribed, make sure your Patreon account is linked to Discord",
      "(Patreon → Settings → Connected apps) so you get your supporter role, then try again.",
    ].join(" ");
  }

  let decoded;
  try {
    decoded = await decodeExport(code);
  } catch (err) {
    if (err instanceof DecodeError) return `❌ ${err.message}`;
    throw err;
  }
  const { flavor, names, invalid } = decoded;

  // Characters already claimed by someone else stay with the first claimant
  const { results: taken } = await env.DB.prepare("SELECT name FROM characters WHERE flavor = ?1 AND user_id != ?2").bind(flavor, userId).all();
  const takenSet = new Set(taken.map((r) => r.name));
  const accepted = names.filter((n) => !takenSet.has(n));
  const conflicts = names.filter((n) => takenSet.has(n));

  const now = new Date().toISOString();
  const statements = [
    env.DB.prepare(
      "INSERT INTO users (user_id, display_name, registered_at, updated_at) VALUES (?1, ?2, ?3, ?3) " +
        "ON CONFLICT(user_id) DO UPDATE SET display_name = excluded.display_name, updated_at = excluded.updated_at"
    ).bind(userId, displayName, now),
    // Re-registering a version replaces that version's list, so deleted/renamed characters get cleaned up
    env.DB.prepare("DELETE FROM characters WHERE user_id = ?1 AND flavor = ?2").bind(userId, flavor),
    ...accepted.map((name) => env.DB.prepare("INSERT OR IGNORE INTO characters (flavor, name, user_id) VALUES (?1, ?2, ?3)").bind(flavor, name, userId)),
  ];
  await env.DB.batch(statements);

  const lines = [
    `✅ Registered **${accepted.length}** ${FLAVOR_LABELS[flavor]} character${accepted.length === 1 ? "" : "s"} as **${TIER_LABELS[tier]} Supporter** (shown as **${displayName}** in the credits).`,
    "Your badge will appear from the next ToxiUI release. Run this again any time to update your list for this game version.",
  ];
  if (conflicts.length) lines.push(`⚠️ Already registered by someone else, skipped: ${conflicts.join(", ")}. Contact Toxi if these are yours.`);
  if (invalid.length) lines.push(`⚠️ Not a valid character name, skipped: ${invalid.join(", ")}`);
  lines.push("", `Characters: ${accepted.join(", ")}`);
  return lines.join("\n");
}

async function list(env, userId, tier) {
  const { results } = await env.DB.prepare("SELECT flavor, name FROM characters WHERE user_id = ?1 ORDER BY flavor, name").bind(userId).all();
  if (results.length === 0) return "You have no registered characters. Use `/tx export names` in game, then `/supporter register`.";

  const byFlavor = {};
  for (const { flavor, name } of results) (byFlavor[flavor] ||= []).push(name);

  const status = tier
    ? `Current tier: **${TIER_LABELS[tier]} Supporter**`
    : "⚠️ You currently have no Patreon supporter role, so your characters won't get a badge in the next release.";

  return [status, "", ...Object.entries(byFlavor).map(([flavor, names]) => `**${FLAVOR_LABELS[flavor] || flavor}** (${names.length}): ${names.join(", ")}`)].join("\n");
}

async function remove(env, userId, version) {
  if (version === "ALL") {
    await env.DB.batch([
      env.DB.prepare("DELETE FROM characters WHERE user_id = ?1").bind(userId),
      env.DB.prepare("DELETE FROM users WHERE user_id = ?1").bind(userId),
    ]);
    return "🗑️ Removed all your registered characters.";
  }

  if (!FLAVOR_LABELS[version]) return "Unknown game version.";
  const result = await env.DB.prepare("DELETE FROM characters WHERE user_id = ?1 AND flavor = ?2").bind(userId, version).run();
  return `🗑️ Removed ${result.meta.changes} ${FLAVOR_LABELS[version]} character${result.meta.changes === 1 ? "" : "s"}.`;
}

// ---------------------------------------------------------------------------------------------------------------------
// Export for the sync workflow

async function tokenMatches(provided, expected) {
  if (!provided || !expected) return false;
  const enc = new TextEncoder();
  const [a, b] = await Promise.all([crypto.subtle.digest("SHA-256", enc.encode(provided)), crypto.subtle.digest("SHA-256", enc.encode(expected))]);
  return crypto.subtle.timingSafeEqual(a, b);
}

async function handleExport(request, env) {
  const auth = request.headers.get("Authorization") || "";
  if (!(await tokenMatches(auth.replace(/^Bearer /, ""), env.EXPORT_TOKEN))) return new Response("Unauthorized", { status: 401 });

  const [{ results: users }, { results: chars }] = await env.DB.batch([
    env.DB.prepare("SELECT user_id, display_name, registered_at, updated_at FROM users ORDER BY registered_at"),
    env.DB.prepare("SELECT user_id, flavor, name FROM characters ORDER BY flavor, name"),
  ]);

  const byUser = new Map(users.map((u) => [u.user_id, { id: u.user_id, display: u.display_name, registered: u.registered_at, updated: u.updated_at, characters: {} }]));
  for (const { user_id, flavor, name } of chars) {
    const user = byUser.get(user_id);
    if (user) (user.characters[flavor] ||= []).push(name);
  }

  return json({ users: [...byUser.values()] });
}
