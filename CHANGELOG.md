# ToxiUI v7.6.0-beta.2 - 2026-10-29

**Full Changelog**: <https://github.com/Toxicom/toxiui/compare/v7.5.6...v7.6.0-beta.2>

## ‼️ Breaking Changes

- Removed BigWigs support
  - The BigWigs profile, `/tx profile bw` command and the BigWigs pull timer skin are gone

## 🚀 New Features

- [Retail] **WunderBar** MicroMenu: Show your character stats in the Character button tooltip
  - Item level, primary stat, secondary stats and tertiary stats you have
  - Can be toggled in MicroMenu settings
- [Retail] New **WunderBar** module: Weekly
  - Shows your keystone, Mythic+ rating or Great Vault progress
  - Shows Vault Ready while last week's Great Vault rewards are waiting to be claimed
  - Tooltip with Great Vault rewards, this week's runs, coffer keys and dungeon scores
  - Left click toggles the Great Vault, Shift-Left links your keystone
  - Right click teleports to your keystone's dungeon, Shift-Right opens the season teleports
- [Retail] **WunderBar** DataBar: New House Favor mode
  - Tooltip with house level, favor, next level unlocks, neighborhood endeavor, decor storage and teleport cooldown
  - Left click toggles the Housing Dashboard, Right click teleports home, Shift-Left toggles the House Editor at home
  - Auto mode now shows house favor while you're at your house or plot
- [Retail] **WunderBar** MicroMenu: Right click the Housing button to teleport home, or return from a visit
- [Retail] Cooldown Manager: Color Buff Bar viewer bars with your Gradient Mode class colors
  - Can be toggled in the Cooldown Manager settings, requires Gradient Mode
- Gradient Mode: Gradients for your class bar (combo points, holy power, chi, runes, essence and more)
  - Every resource has its own customizable colors in the Bars tab, combo points default to ElvUI's colors

## ✨ Enhancements

- Gradient Mode: Fewer unit API calls per health update
- Reduced memory churn of the internal event system by reusing callback lists between events
- Options pages & changelogs are now built when the ElvUI config is first opened instead of on every login
- ElvUI Theme: Shadows now follow their frame's level & strata through per-frame hooks
  - Previously every frame level/strata change of every frame in the game went through ToxiUI
- `[tx:name]` & `[tx:health:percent:nosign]` tags no longer update on every frame when you change targets
- [Retail] VehicleBar: Vigor bar timers now only run while the bar is visible
- [Retail] Cooldown Manager: Keybinds no longer rescan all action bars & restyle their text on every cooldown update
- **WunderBar**: ElvUI stat datatexts (Haste, Crit, Speed, etc.) now only update on your own aura & stat changes
  - Previously they updated on aura changes of every raid member and nameplate
- **WunderBar**: ElvUI datatexts skip text processing when their text hasn't changed
- **WunderBar** DataBar: Coalesce quest log updates and ignore non-reputation combat text
- **WunderBar** Flyouts: Stop cooldown timers when the flyout closes
- Animations: Reuse colors for the RGB animation instead of creating new ones every frame

## 🐛 Bug Fixes

- Additional Scaling: Fixed load-on-demand frames (Collections, Auction House, Inspect, Professions, etc.) not being scaled until the slider was changed
- [Mists] Fixed Objective Frame position not being applied by the profile
- Armory: Fixed conflict detection with Shadow & Light Inspect/Stats and Eltruism Classic Armory
- Minimap Coordinates: Fixed coordinates not updating when moving along only one axis
- Fixed Dead & Offline Icons still reacting to setting changes after being disabled
- **WunderBar** Hearthstone: Fixed a potential error when a teleport spell has no cooldown info
- [Retail] Fixed potential secret value errors in name tags, Vehicle Bar vigor segments, Role Icons, Raid Info Frame and Armory stats
- [Retail] Cooldown Manager: Fixed icon centering no longer following buffs appearing mid-combat after changing any Cooldown Manager setting until a reload
- Gradient Mode & Dark Mode: Fixed color setting changes refreshing group frames with a stale unit
- Fixed old profile conversions modifying the default Saturation Boost settings and possibly skipping custom text renames

## 🧩 Profile Updates

- [Retail] ElvUI Unitframes: Use ElvUI's default aura filters
  - Removed aura filter settings that ElvUI no longer uses since its Midnight aura rework
- ElvUI Unitframes: Keep Player & Pet frames visible in Mythic+ like every other instance difficulty

## 📘 Documentation

- [Retail] Update currencies for Midnight Season 2

## ♻️ Settings Refactoring

- Gradient Mode: More compact color settings, two columns and fewer tabs
  - The preview bar now shows the colors with Saturation Boost applied
- The ToxiUI logo in the options is now only shown on the General page
