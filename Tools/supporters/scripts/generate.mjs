// Generates Core/InternalSupporters.lua from Discord registrations + current Patreon-managed Discord roles.
//
// Online (GitHub workflow):
//   EXPORT_URL=https://.../export EXPORT_TOKEN=... DISCORD_BOT_TOKEN=... GUILD_ID=... TIER_ROLES='{"LEGENDARY":"..",...}'
//   node generate.mjs [--summary summary.md] [--discord discord.txt]
//
// Offline (local dry run / tests):
//   TIER_ROLES='...' node generate.mjs --export-file export.json --roles-file roles.json [--out path.lua]
//   roles.json: { "<discord user id>": ["<role id>", ...] | null }   (null = left the server)

import { readFile, writeFile } from "node:fs/promises";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import { parseArgs } from "node:util";
import { isValidName } from "../worker/src/decode.js";
import { sanitizeDisplayName } from "../worker/src/index.js";

const TIERS = ["LEGENDARY", "EPIC", "RARE"];
const TIER_LABELS = { LEGENDARY: "Legendary", EPIC: "Epic", RARE: "Rare" };
const FLAVOR_ORDER = ["RETAIL", "CLASSIC", "ANNIVERSARY", "CLASSIC_ERA", "FOREVER"];

const ROOT = resolve(dirname(fileURLToPath(import.meta.url)), "../../..");
const DATA_FILE = resolve(ROOT, "Core/InternalData.lua");
const DEFAULT_OUT = resolve(ROOT, "Core/InternalSupporters.lua");

const { values: args } = parseArgs({
  options: {
    "export-file": { type: "string" },
    "roles-file": { type: "string" },
    out: { type: "string", default: DEFAULT_OUT },
    summary: { type: "string" },
    discord: { type: "string" },
  },
});

function fail(msg) {
  console.error(`::error::${msg}`);
  process.exit(1);
}

const env = process.env;
if (!env.TIER_ROLES) fail("TIER_ROLES is not set");
const tierRoles = JSON.parse(env.TIER_ROLES);

// ---------------------------------------------------------------------------------------------------------------------
// Inputs

async function loadExport() {
  if (args["export-file"]) return JSON.parse(await readFile(args["export-file"], "utf8"));
  if (!env.EXPORT_URL || !env.EXPORT_TOKEN) fail("EXPORT_URL / EXPORT_TOKEN are not set");

  const res = await fetch(env.EXPORT_URL, { headers: { Authorization: `Bearer ${env.EXPORT_TOKEN}` } });
  if (!res.ok) fail(`Export request failed: ${res.status} ${await res.text()}`);
  return res.json();
}

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

/** @returns {Promise<string[] | null>} role IDs, or null if the user is no longer in the server */
async function fetchRoles(userId, rolesFile) {
  if (rolesFile) return userId in rolesFile ? rolesFile[userId] : null;

  for (let attempt = 0; attempt < 5; attempt++) {
    const res = await fetch(`https://discord.com/api/v10/guilds/${env.GUILD_ID}/members/${userId}`, {
      headers: { Authorization: `Bot ${env.DISCORD_BOT_TOKEN}` },
    });
    if (res.ok) return (await res.json()).roles;
    if (res.status === 404) return null;
    if (res.status === 429) {
      const { retry_after } = await res.json();
      await sleep(Math.ceil((retry_after || 1) * 1000));
      continue;
    }
    // Never guess on API errors: a Discord outage must not drop everyone's badge
    fail(`Discord member lookup failed for ${userId}: ${res.status} ${await res.text()}`);
  }
  fail(`Discord kept rate limiting the lookup for ${userId}`);
}

function tierOf(roles) {
  if (!roles) return null;
  const owned = new Set(roles);
  return TIERS.find((t) => tierRoles[t] && owned.has(tierRoles[t])) || null;
}

async function loadDeveloperNames() {
  const src = await readFile(DATA_FILE, "utf8");
  const start = src.indexOf("[I.Enum.ContributorType.DEV]");
  const end = src.indexOf("[I.Enum.ContributorType.", start + 1);
  if (start < 0 || end < 0) fail("Could not find the DEV section in Core/InternalData.lua");
  return new Set([...src.slice(start, end).matchAll(/\["([^"]+)"\]\s*=\s*true/g)].map((m) => m[1]));
}

/** Previous generated file -> Map(display name -> tier), for the change summary */
async function loadPrevious(path) {
  const prev = new Map();
  let src;
  try {
    src = await readFile(path, "utf8");
  } catch {
    return prev;
  }
  let tier = null;
  for (const line of src.split("\n")) {
    const t = line.match(/^ {2}\[I\.Enum\.ContributorType\.(\w+)\] = \{/);
    if (t) tier = t[1];
    const p = line.match(/^ {4}\["((?:[^"\\]|\\.)*)"\] = \{/);
    if (p && tier) prev.set(p[1].replace(/\\(.)/g, "$1"), tier);
  }
  return prev;
}

// ---------------------------------------------------------------------------------------------------------------------
// Lua output (must pass `stylua --check` with the repo's .stylua.toml)

const luaString = (s) => `"${String(s).replace(/[\p{C}]/gu, "").replace(/\\/g, "\\\\").replace(/"/g, '\\"')}"`;

function realmOf(name, flavor) {
  return flavor === "FOREVER" ? null : name.slice(name.indexOf("-") + 1);
}

function renderFlavor(flavor, names) {
  const sorted = [...names].sort((a, b) => {
    const ra = realmOf(a, flavor) || "";
    const rb = realmOf(b, flavor) || "";
    return ra === rb ? a.localeCompare(b) : ra.localeCompare(rb);
  });

  const lines = [`      [I.Enum.Flavor.${flavor}] = {`];
  let lastRealm;
  for (const name of sorted) {
    const realm = realmOf(name, flavor);
    if (realm && realm !== lastRealm) {
      if (lastRealm !== undefined) lines.push("");
      lines.push(`        -- ${realm}`);
    }
    lastRealm = realm;
    lines.push(`        [${luaString(name)}] = true,`);
  }
  lines.push("      },");
  return lines;
}

function renderLua(byTier) {
  const out = [
    "-- AUTO-GENERATED by Tools/supporters/scripts/generate.mjs - do not edit by hand, changes will be overwritten.",
    "-- Supporters register themselves in Discord with /supporter register; the weekly sync opens a PR with updates.",
    "-- Developers, beta testers and honorary entries stay hand-written in InternalData.lua.",
    "local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))",
    "",
    "local supporters = {",
  ];

  TIERS.forEach((tier, i) => {
    const people = byTier[tier];
    if (i > 0) out.push("");
    if (people.length === 0) {
      out.push(`  [I.Enum.ContributorType.${tier}] = {},`);
      return;
    }
    out.push(`  [I.Enum.ContributorType.${tier}] = {`);
    people.forEach((person, j) => {
      if (j > 0) out.push("");
      out.push(`    [${luaString(person.display)}] = {`);
      const flavors = FLAVOR_ORDER.filter((f) => person.characters[f]?.length);
      flavors.forEach((flavor, k) => {
        if (k > 0) out.push("");
        out.push(...renderFlavor(flavor, person.characters[flavor]));
      });
      out.push("    },");
    });
    out.push("  },");
  });

  out.push(
    "}",
    "",
    "-- Merge into the hand-written list; entries with the same display name are combined",
    "for tier, people in pairs(supporters) do",
    "  local target = I.Data.Contributor[tier]",
    "  for person, flavors in pairs(people) do",
    "    target[person] = target[person] or {}",
    "    for flavor, names in pairs(flavors) do",
    "      target[person][flavor] = target[person][flavor] or {}",
    "      for name in pairs(names) do",
    "        target[person][flavor][name] = true",
    "      end",
    "    end",
    "  end",
    "end",
    ""
  );
  return out.join("\n");
}

// ---------------------------------------------------------------------------------------------------------------------

const rolesFile = args["roles-file"] ? JSON.parse(await readFile(args["roles-file"], "utf8")) : null;
if (!rolesFile && (!env.DISCORD_BOT_TOKEN || !env.GUILD_ID)) fail("DISCORD_BOT_TOKEN / GUILD_ID are not set");

const [{ users }, devNames, previous] = await Promise.all([loadExport(), loadDeveloperNames(), loadPrevious(args.out)]);

const byTier = Object.fromEntries(TIERS.map((t) => [t, []]));
const inactive = []; // { display, reason }
const skipped = []; // { display, name, reason }
const usedDisplayNames = new Set();
const current = new Map(); // display -> tier

for (const user of users) {
  // Re-sanitize in case the stored name predates a sanitizer change
  user.display = sanitizeDisplayName(user.display) || "Supporter";
  const roles = await fetchRoles(user.id, rolesFile);
  const tier = tierOf(roles);
  if (!tier) {
    inactive.push({ display: user.display, reason: roles ? "no supporter role" : "left the Discord server" });
    continue;
  }

  const characters = {};
  let count = 0;
  for (const [flavor, names] of Object.entries(user.characters)) {
    if (!FLAVOR_ORDER.includes(flavor)) continue;
    const kept = [];
    for (const name of names) {
      if (devNames.has(name)) skipped.push({ display: user.display, name, reason: "developer character" });
      else if (!isValidName(name, flavor)) skipped.push({ display: user.display, name, reason: "invalid name" });
      else kept.push(name);
    }
    if (kept.length) characters[flavor] = kept;
    count += kept.length;
  }
  if (count === 0) {
    inactive.push({ display: user.display, reason: "no valid characters" });
    continue;
  }

  // Display names are table keys in the addon, so they must be unique
  let display = user.display;
  for (let n = 2; usedDisplayNames.has(display.toLowerCase()); n++) display = `${user.display} ${n}`;
  usedDisplayNames.add(display.toLowerCase());

  byTier[tier].push({ display, characters, count });
  current.set(display, tier);
}

for (const tier of TIERS) byTier[tier].sort((a, b) => a.display.toLowerCase().localeCompare(b.display.toLowerCase()));

await writeFile(args.out, renderLua(byTier));

// ---------------------------------------------------------------------------------------------------------------------
// Summary

const added = [...current].filter(([d]) => !previous.has(d)).map(([d, t]) => `${d} (${TIER_LABELS[t]})`);
const removed = [...previous].filter(([d]) => !current.has(d)).map(([d, t]) => {
  const why = inactive.find((i) => i.display === d)?.reason || "unregistered or renamed";
  return `${d} (was ${TIER_LABELS[t] || t}) - ${why}`;
});
const changed = [...current].filter(([d, t]) => previous.has(d) && previous.get(d) !== t).map(([d, t]) => `${d}: ${TIER_LABELS[previous.get(d)]} → ${TIER_LABELS[t]}`);

const totals = TIERS.map((t) => `${byTier[t].length} ${TIER_LABELS[t]}`).join(" · ");
const charTotal = TIERS.reduce((sum, t) => sum + byTier[t].reduce((s, p) => s + p.count, 0), 0);

const md = ["## Supporter sync", "", `**Active supporters:** ${totals} (${charTotal} characters)`, ""];
const section = (title, items) => items.length && md.push(`### ${title}`, "", ...items.map((i) => `- ${i}`), "");
section("➕ Added", added);
section("➖ Removed", removed);
section("🔁 Tier changed", changed);
section(
  "Registered but not active",
  inactive.map((i) => `${i.display} - ${i.reason}`)
);
section(
  "Skipped characters",
  skipped.map((s) => `${s.name} (${s.display}) - ${s.reason}`)
);
if (!added.length && !removed.length && !changed.length) md.push("_No supporter changes since the last sync._", "");

const mdText = md.join("\n");
console.log(mdText);
if (args.summary) await writeFile(args.summary, mdText);

if (args.discord) {
  const parts = [];
  if (added.length) parts.push(`➕ ${added.join(", ")}`);
  if (removed.length) parts.push(`➖ ${removed.join(", ")}`);
  if (changed.length) parts.push(`🔁 ${changed.join(", ")}`);
  await writeFile(args.discord, parts.length ? `**Supporter sync** (${totals})\n${parts.join("\n")}` : "");
}
