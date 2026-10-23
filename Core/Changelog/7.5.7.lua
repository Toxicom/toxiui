local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.5.7"] = {
  HOTFIX = true,
  RELEASE_DATE = "",
  CHANGES = {
    "* Breaking changes",

    "* New features",

    "* Enhancements",

    "* Bug fixes",
    "Fixed " .. F.String.ToxiUI("[tx:health]") .. " tags never showing Dead, Ghost or Offline status",
    F.String.Classic() .. "Fixed Objective Frame position not being applied by the profile",
    "Armory: Fixed conflict detection with Shadow & Light Inspect/Stats and Eltruism Classic Armory",
    "Minimap Coordinates: Fixed coordinates not updating when moving along only one axis",
    "Fixed Dead & Offline Icons still reacting to setting changes after being disabled",

    "* Profile updates",
    F.String.ElvUI() .. " Unitframes: Keep Player & Pet frames visible in Mythic+ like every other instance difficulty",

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
  },
}
