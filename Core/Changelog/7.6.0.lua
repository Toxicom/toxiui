local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.6.0"] = {
  HOTFIX = true,
  RELEASE_DATE = "Mon TBD, 2026",
  CHANGES = {
    "* Breaking changes",
    "Removed BigWigs support" .. F.String.Sublist("The BigWigs profile, " .. F.String.ToxiUI("/tx profile bw") .. " command and the BigWigs pull timer skin are gone"),

    "* New features",
    F.String.Retail() .. F.String.Menu.WunderBar() .. " MicroMenu: Show your character stats in the Character button tooltip" .. F.String.Sublist(
      "Item level, primary stat, secondary stats and tertiary stats you have"
    ) .. F.String.Sublist("Can be toggled in MicroMenu settings"),
    F.String.Retail()
      .. "New "
      .. F.String.Menu.WunderBar()
      .. " module: Weekly"
      .. F.String.Sublist("Shows your keystone, Mythic+ rating or Great Vault progress")
      .. F.String.Sublist("Tooltip with Great Vault rewards, this week's runs, coffer keys and dungeon scores")
      .. F.String.Sublist("Left click toggles the Great Vault, Shift-Left links your keystone")
      .. F.String.Sublist("Right click teleports to your keystone's dungeon, Shift-Right opens the season teleports"),
    F.String.Retail() .. F.String.Menu.WunderBar() .. " DataBar: New House Favor mode" .. F.String.Sublist(
      "Tooltip with house level, favor, next level unlocks, neighborhood endeavor, decor storage and teleport cooldown"
    ) .. F.String.Sublist("Left click toggles the Housing Dashboard, Right click teleports home, Shift-Left toggles the House Editor at home") .. F.String.Sublist(
      "Auto mode now shows house favor while you're at your house or plot"
    ),
    F.String.Retail() .. F.String.Menu.WunderBar() .. " MicroMenu: Right click the Housing button to teleport home, or return from a visit",
    F.String.Retail() .. F.String.CDM() .. ": Color Buff Bar viewer bars with your " .. F.String.GradientMode() .. " class colors" .. F.String.Sublist(
      "Can be toggled in the " .. F.String.CDM() .. " settings, requires " .. F.String.GradientMode()
    ),
    F.String.GradientMode() .. ": Gradients for your class bar (combo points, holy power, chi, runes, essence and more)" .. F.String.Sublist(
      "Every resource has its own customizable colors in the Bars tab, combo points default to " .. F.String.ElvUI() .. "'s colors"
    ),

    "* Enhancements",
    F.String.GradientMode() .. ": Fewer unit API calls per health update",
    "Reduced memory churn of the internal event system by reusing callback lists between events",
    "Options pages & changelogs are now built when the " .. F.String.ElvUI() .. " config is first opened instead of on every login",
    F.String.ElvUI() .. " Theme: Shadows now follow their frame's level & strata through per-frame hooks" .. F.String.Sublist(
      "Previously every frame level/strata change of every frame in the game went through " .. TXUI.Title
    ),
    F.String.ToxiUI("[tx:name]") .. " & " .. F.String.ToxiUI("[tx:health:percent:nosign]") .. " tags no longer update on every frame when you change targets",
    F.String.Retail() .. "VehicleBar: Vigor bar timers now only run while the bar is visible",
    F.String.Retail() .. F.String.CDM() .. ": Keybinds no longer rescan all action bars & restyle their text on every cooldown update",
    F.String.Menu.WunderBar() .. ": " .. F.String.ElvUI() .. " stat datatexts (Haste, Crit, Speed, etc.) now only update on your own aura & stat changes" .. F.String.Sublist(
      "Previously they updated on aura changes of every raid member and nameplate"
    ),
    F.String.Menu.WunderBar() .. ": " .. F.String.ElvUI() .. " datatexts skip text processing when their text hasn't changed",
    F.String.Menu.WunderBar() .. " DataBar: Coalesce quest log updates and ignore non-reputation combat text",
    F.String.Menu.WunderBar() .. " Flyouts: Stop cooldown timers when the flyout closes",
    "Animations: Reuse colors for the RGB animation instead of creating new ones every frame",

    "* Bug fixes",
    "Additional Scaling: Fixed load-on-demand frames (Collections, Auction House, Inspect, Professions, etc.) not being scaled until the slider was changed",
    F.String.Classic() .. "Fixed Objective Frame position not being applied by the profile",
    "Armory: Fixed conflict detection with Shadow & Light Inspect/Stats and Eltruism Classic Armory",
    "Minimap Coordinates: Fixed coordinates not updating when moving along only one axis",
    "Fixed Dead & Offline Icons still reacting to setting changes after being disabled",
    F.String.Menu.WunderBar() .. " Hearthstone: Fixed a potential error when a teleport spell has no cooldown info",
    F.String.Retail() .. "Fixed potential secret value errors in name tags, Vehicle Bar vigor segments, Role Icons, Raid Info Frame and Armory stats",
    F.String.Retail()
      .. F.String.CDM()
      .. ": Fixed icon centering no longer following buffs appearing mid-combat after changing any "
      .. F.String.CDM()
      .. " setting until a reload",
    F.String.GradientMode() .. " & Dark Mode: Fixed color setting changes refreshing group frames with a stale unit",
    "Fixed old profile conversions modifying the default Saturation Boost settings and possibly skipping custom text renames",

    "* Profile updates",
    F.String.Retail() .. F.String.ElvUI() .. " Unitframes: Use " .. F.String.ElvUI() .. "'s default aura filters" .. F.String.Sublist(
      "Removed aura filter settings that " .. F.String.ElvUI() .. " no longer uses since its Midnight aura rework"
    ),
    F.String.ElvUI() .. " Unitframes: Keep Player & Pet frames visible in Mythic+ like every other instance difficulty",

    "* Documentation",
    F.String.Retail() .. "Update currencies for Midnight Season 2",

    "* Settings refactoring",
    F.String.GradientMode() .. ": More compact color settings, two columns and fewer tabs" .. F.String.Sublist(
      "The preview bar now shows the colors with Saturation Boost applied"
    ),
    "The " .. TXUI.Title .. " logo in the options is now only shown on the General page",

    "* Development improvements",
  },
}
