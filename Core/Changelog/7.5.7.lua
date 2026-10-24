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
    F.String.ElvUI() .. " Theme: Shadows now follow their frame's level & strata through per-frame hooks" .. F.String.Sublist(
      "Previously every frame level/strata change of every frame in the game went through " .. TXUI.Title
    ),
    F.String.ToxiUI("[tx:name]") .. " & " .. F.String.ToxiUI("[tx:health:percent:nosign]") .. " tags no longer update on every frame when you change targets",
    F.String.Menu.WunderBar() .. ": " .. F.String.ElvUI() .. " stat datatexts (Haste, Crit, Speed, etc.) now only update on your own aura & stat changes" .. F.String.Sublist(
      "Previously they updated on aura changes of every raid member and nameplate"
    ),

    "* Bug fixes",
    "Fixed " .. F.String.ToxiUI("[tx:health]") .. " tags never showing Dead, Ghost or Offline status",
    F.String.Classic() .. "Fixed Objective Frame position not being applied by the profile",
    "Armory: Fixed conflict detection with Shadow & Light Inspect/Stats and Eltruism Classic Armory",
    "Minimap Coordinates: Fixed coordinates not updating when moving along only one axis",
    "Fixed Dead & Offline Icons still reacting to setting changes after being disabled",
    F.String.Menu.WunderBar() .. " Hearthstone: Fixed a potential error when a teleport spell has no cooldown info",
    F.String.Retail() .. "Fixed potential secret value errors in name tags, Vehicle Bar vigor segments, Role Icons, Raid Info Frame and Armory stats",
    F.String.GradientMode() .. " & Dark Mode: Fixed color setting changes refreshing group frames with a stale unit",

    "* Profile updates",
    F.String.ElvUI() .. " Unitframes: Keep Player & Pet frames visible in Mythic+ like every other instance difficulty",

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
  },
}
