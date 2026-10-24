local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.5.7"] = {
  HOTFIX = true,
  RELEASE_DATE = "",
  CHANGES = {
    "* Breaking changes",

    "* New features",

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
    "Fixed " .. F.String.ToxiUI("[tx:health]") .. " tags never showing Dead, Ghost or Offline status",
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
    F.String.ElvUI() .. " Unitframes: Keep Player & Pet frames visible in Mythic+ like every other instance difficulty",

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
  },
}
