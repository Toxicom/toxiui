// Run from Tools/supporters/worker: npm test   (Node 22.5+, uses the built-in node:sqlite as a stand-in for D1)
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { DatabaseSync } from "node:sqlite";
import { test } from "node:test";
import { decodeExport } from "../worker/src/decode.js";
import { handleCommand, sanitizeDisplayName } from "../worker/src/index.js";

// Real `/tx export names` output from Retail (36 characters)
const RETAIL_EXPORT =
  "dZKxboMwEECHfkvHfERUNVNRVEJZ0clcihXwVWegST4rEzvflL1wUSXb165PD3O+5+m5KOhsRzohb3IY0RlG398PK/XEZlMAM7rMtu29XGEDDM5yyEVm+MQQyrm+J+6U2hG5SH2BdlF5nsIR8lW9YmQK89apI1sypxB+iNhATd/qWiPZOoTvxTydrf3bS69/HNjS4NWgOJIeypomFGUlDg1TRHcD8+U4LK5aFPagYDO4PoT7qspei221e9uW+7yqnh4WtZd/cqSjG9KJJH26EEkcwfn2+Fy9nIZ6BSV7+vM1ZipKzBR+QWz+Fu4geg1lhstb8uBqjIrmB0G6siwqgD8=";

// Minimal D1 shim over node:sqlite
function createD1() {
  const db = new DatabaseSync(":memory:");
  db.exec(readFileSync(new URL("../worker/schema.sql", import.meta.url), "utf8"));
  const stmt = (sql, params = []) => ({
    bind: (...p) => stmt(sql, p),
    all: async () => ({ results: db.prepare(sql).all(...params) }),
    run: async () => ({ meta: { changes: Number(db.prepare(sql).run(...params).changes) } }),
    _exec: () => (/^\s*SELECT/i.test(sql) ? { results: db.prepare(sql).all(...params) } : { meta: db.prepare(sql).run(...params) }),
  });
  return {
    prepare: (sql) => stmt(sql),
    batch: async (stmts) => {
      db.exec("BEGIN");
      try {
        const out = stmts.map((s) => s._exec());
        db.exec("COMMIT");
        return out;
      } catch (e) {
        db.exec("ROLLBACK");
        throw e;
      }
    },
  };
}

const env = () => ({ DB: createD1(), GUILD_ID: "guild", TIER_ROLES: JSON.stringify({ LEGENDARY: "r-leg", EPIC: "r-epic", RARE: "r-rare" }) });

const cmd = (sub, options, { id = "u1", roles = ["r-rare"], nick = "Aspry", guild = "guild" } = {}) => ({
  type: 2,
  guild_id: guild,
  member: { nick, roles, user: { id, username: "aspry_", global_name: null } },
  data: { name: "supporter", options: [{ name: sub, options: Object.entries(options).map(([name, value]) => ({ name, value })) }] },
});

test("decodes a real export", async () => {
  const { flavor, names, invalid } = await decodeExport(RETAIL_EXPORT);
  assert.equal(flavor, "RETAIL");
  assert.equal(names.length, 36);
  assert.deepEqual(invalid, []);
  assert.ok(names.includes("Calistrø-Ravencrest"));
});

test("register, list, re-register, remove", async () => {
  const e = env();
  const reg = await handleCommand(cmd("register", { code: RETAIL_EXPORT }), e);
  assert.match(reg, /Registered \*\*36\*\* Retail characters as \*\*Rare Supporter\*\*/);

  const listed = await handleCommand(cmd("list", {}), e);
  assert.match(listed, /Rare Supporter/);
  assert.match(listed, /\*\*Retail\*\* \(36\)/);

  // Re-registering replaces, not duplicates
  await handleCommand(cmd("register", { code: RETAIL_EXPORT }), e);
  assert.match(await handleCommand(cmd("list", {}), e), /\(36\)/);

  assert.match(await handleCommand(cmd("remove", { version: "RETAIL" }), e), /Removed 36 Retail characters/);
  assert.match(await handleCommand(cmd("list", {}), e), /no registered characters/);
});

test("non-supporters cannot register but can list/remove", async () => {
  const e = env();
  assert.match(await handleCommand(cmd("register", { code: RETAIL_EXPORT }, { roles: ["other"] }), e), /Patreon supporters/);
  assert.match(await handleCommand(cmd("remove", { version: "ALL" }, { roles: [] }), e), /Removed all/);
});

test("highest tier wins", async () => {
  const e = env();
  assert.match(await handleCommand(cmd("register", { code: RETAIL_EXPORT }, { roles: ["r-rare", "r-leg"] }), e), /Legendary Supporter/);
});

test("characters claimed by someone else are skipped", async () => {
  const e = env();
  await handleCommand(cmd("register", { code: RETAIL_EXPORT }, { id: "u1" }), e);
  const second = await handleCommand(cmd("register", { code: RETAIL_EXPORT }, { id: "u2", nick: "Thief" }), e);
  assert.match(second, /Registered \*\*0\*\*/);
  assert.match(second, /Already registered by someone else/);
});

test("rejects garbage and wrong server", async () => {
  const e = env();
  assert.match(await handleCommand(cmd("register", { code: "not an export" }), e), /❌/);
  assert.match(await handleCommand(cmd("list", {}, { guild: "elsewhere" }), e), /ToxiUI Discord server/);
});

test("display names are made safe for Lua and WoW UI text", () => {
  assert.equal(sanitizeDisplayName('|cffff0000Evil|r "x"\\'), "cffff0000Evilr x");
  assert.equal(sanitizeDisplayName("\u0000\u0007"), "");
  assert.equal(sanitizeDisplayName("Toxi⭐"), "Toxi");
  assert.equal(sanitizeDisplayName("🔥 Cassièl 🔥"), "Cassièl");
  assert.equal(sanitizeDisplayName("Mr. O'Neil-Smith"), "Mr. O'Neil-Smith");
});

test("emoji-only nickname falls back to the next name", async () => {
  const e = env();
  const res = await handleCommand(cmd("register", { code: RETAIL_EXPORT }, { nick: "⭐⭐" }), e);
  assert.match(res, /shown as \*\*aspry_\*\*/);
});
