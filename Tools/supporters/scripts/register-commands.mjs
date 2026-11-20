// Registers the /supporter slash command in the ToxiUI Discord server. Run once, and again after changing the command.
//
//   cd Tools/supporters && node --env-file=.env scripts/register-commands.mjs   (see .env.example)

const { DISCORD_APP_ID, DISCORD_BOT_TOKEN, GUILD_ID } = process.env;
if (!DISCORD_APP_ID || !DISCORD_BOT_TOKEN || !GUILD_ID) {
  console.error("Set DISCORD_APP_ID, DISCORD_BOT_TOKEN and GUILD_ID");
  process.exit(1);
}

const versions = [
  { name: "Retail", value: "RETAIL" },
  { name: "Classic", value: "CLASSIC" },
  { name: "Anniversary", value: "ANNIVERSARY" },
  { name: "Classic Era", value: "CLASSIC_ERA" },
  { name: "Forever", value: "FOREVER" },
  { name: "All versions", value: "ALL" },
];

const commands = [
  {
    name: "supporter",
    description: "ToxiUI supporter badges",
    contexts: [0], // server only
    options: [
      {
        type: 1,
        name: "register",
        description: "Register your characters for a supporter badge",
        options: [{ type: 3, name: "code", description: "The string from /tx export names (once per game version)", required: true, max_length: 6000 }],
      },
      { type: 1, name: "list", description: "Show your registered characters and supporter status" },
      {
        type: 1,
        name: "remove",
        description: "Remove your registered characters",
        options: [{ type: 3, name: "version", description: "Which game version to remove", required: true, choices: versions }],
      },
    ],
  },
];

const res = await fetch(`https://discord.com/api/v10/applications/${DISCORD_APP_ID}/guilds/${GUILD_ID}/commands`, {
  method: "PUT",
  headers: { Authorization: `Bot ${DISCORD_BOT_TOKEN}`, "Content-Type": "application/json" },
  body: JSON.stringify(commands),
});

if (!res.ok) {
  console.error(`Failed: ${res.status}`, await res.text());
  process.exit(1);
}
console.log("Registered:", (await res.json()).map((c) => `/${c.name}`).join(", "));
