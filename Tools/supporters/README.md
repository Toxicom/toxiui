# Supporter badges

Patreon supporters register their own characters for a badge. Nobody edits `InternalData.lua` by hand for them.

```
In game:   /tx export names                 -> copy the string
Discord:   /supporter register code:<paste> -> stored by the Worker (needs a Patreon role)
Weekly:    GitHub "Sync supporters"         -> checks current roles, regenerates Core/InternalSupporters.lua, opens a PR
Release:   merge the PR                     -> badges ship
```

- **Who gets a badge** comes from Patreon's Discord role integration at sync time. A lapsed supporter loses the role, drops out at the next sync, and comes back automatically if they resubscribe. Their registration is kept.
- **Tier**: the highest of their Legendary/Epic/Rare roles.
- **One export per game version.** Running `/supporter register` again for the same version replaces that version's list.
- **Hand-written entries stay in `InternalData.lua`**: developers, beta testers and honorary supporters (e.g. people who contributed art). The generated file merges into those tables.
- **Safeguards**: developer characters are never given a supporter badge, a character can only be claimed by one person, display names are stripped of WoW escape codes, and a Discord API error fails the sync instead of dropping everyone.

Commands (all replies are only visible to the user):

| Command | |
|---|---|
| `/supporter register code:<string>` | Register characters from `/tx export names` |
| `/supporter list` | Show registered characters and current supporter status |
| `/supporter remove version:<version>` | Remove a game version's characters, or all |

## Layout

| Path | |
|---|---|
| `worker/` | Cloudflare Worker: Discord command endpoint + `/export` for the sync |
| `scripts/register-commands.mjs` | One-time: registers `/supporter` in the Discord server |
| `scripts/generate.mjs` | Sync: builds `Core/InternalSupporters.lua` (also runs offline, see header) |
| `test/` | `npm test` from `worker/` |
| `.github/workflows/supporters_sync.yml` | Weekly + manual sync that opens the PR |

Everything here is free: Cloudflare Workers + D1 free tier, no domain needed. `Tools/*` is excluded from the packaged addon.

## One-time setup

### 1. Discord application

1. https://discord.com/developers/applications → **New Application** (e.g. "ToxiUI").
2. **General Information**: copy the **Application ID** and **Public Key**.
3. **Bot**: **Reset Token** → copy the **bot token**. No privileged intents are needed.
4. **OAuth2 → URL Generator**: scopes `bot` + `applications.commands`, no permissions. Open the URL and add it to the ToxiUI server.
5. In Discord, enable **Settings → Advanced → Developer Mode**. Right-click the server → **Copy Server ID**, then right-click each Patreon tier role → **Copy Role ID**.

### 2. Cloudflare Worker

```sh
cd Tools/supporters/worker
npm install
npx wrangler login                          # free Cloudflare account
npx wrangler d1 create toxiui-supporters    # copy the database_id into wrangler.toml
```

Fill in `wrangler.toml`: `GUILD_ID`, `TIER_ROLES` and `database_id`. These IDs aren't secret. Then:

```sh
npm run db:init
npx wrangler secret put DISCORD_PUBLIC_KEY  # from step 1.2
npx wrangler secret put EXPORT_TOKEN        # any long random string, keep it for step 4
npm run deploy                              # prints https://toxiui-supporters.<you>.workers.dev
```

The first deploy of a brand-new Worker may fail with `This Worker does not exist on your account [code: 10007]` after "Uploaded". This is a Cloudflare race on first creation. Don't delete anything; wait ~30s and run `npm run deploy` again until `https://toxiui-supporters.<you>.workers.dev/` answers `Not found` (our Worker) instead of `error code: 1042`. If you're setting secrets for the first time, run `secret put` after the Worker is live.

### 3. Connect Discord to the Worker

1. Developer Portal → **General Information → Interactions Endpoint URL** = `https://toxiui-supporters.<you>.workers.dev/interactions` → Save. Discord sends a test request, so the Worker must be deployed first.
2. Register the command. Copy `Tools/supporters/.env.example` to `.env` (gitignored), fill it in, then:
   ```sh
   cd Tools/supporters
   node --env-file=.env scripts/register-commands.mjs
   ```

### 4. GitHub

Repo **Settings → Secrets and variables → Actions**:

| Secrets | |
|---|---|
| `SUPPORTERS_EXPORT_URL` | `https://toxiui-supporters.<you>.workers.dev/export` |
| `SUPPORTERS_EXPORT_TOKEN` | The `EXPORT_TOKEN` from step 2 |
| `SUPPORTERS_DISCORD_BOT_TOKEN` | Bot token from step 1.3 |
| `SUPPORTERS_WEBHOOK_URL` | Optional: a **private** staff channel webhook for sync summaries |

| Variables | |
|---|---|
| `SUPPORTERS_GUILD_ID` | Server ID |
| `SUPPORTERS_TIER_ROLES` | Same JSON as in `wrangler.toml` |

Also enable **Settings → Actions → General → Allow GitHub Actions to create and approve pull requests**.

Test it with **Actions → Sync supporters → Run workflow** after registering yourself with a test role.

## Moving over from the hand-written list

1. Announce `/supporter register` with a cutoff date.
2. Until the cutoff, the old LEGENDARY/EPIC/RARE entries in `InternalData.lua` keep working alongside new registrations. Entries with the same display name are merged.
3. After the cutoff, delete the Patreon entries from `InternalData.lua`, keeping honorary ones.

## Maintenance

- **Someone claims a character that isn't theirs**: `npx wrangler d1 execute toxiui-supporters --remote --command "DELETE FROM characters WHERE name = 'Name-Realm'"`
- **Change a credits display name**: `... --command "UPDATE users SET display_name = 'New' WHERE user_id = '<discord id>'"`. It's normally taken from their server nickname at registration.
- **Changing the command definitions**: re-run `register-commands.mjs`.
