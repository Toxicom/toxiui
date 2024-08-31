local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.8.1"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    "Option to open Professions Frame via " .. F.String.Menu.WunderBar() .. " MicroMenu",
    "Hearthstone module right-click opens Tome of Teleportation if that AddOn is enabled",

    "* Bug fixes",

    "* Profile updates",
    "Update Plater mods",

    "* Documentation",
    "Revert the 1600 height custom scale",
    "Update current season to " .. F.String.ToxiUI("tww1") .. F.String.Sublist("This affects the Hearthstone Seasonal M+ Portals list"),
    "Add TWW Season 1 portals to " --
      .. F.String.Menu.WunderBar()
      .. " Hearthstone module"
      .. F.String.Sublist("IDs are taken from Wowhead beta, so they might change when M+ releases"),
    "Covenant hearthstones now have a prefix in the hearthstone select dropdown",

    "* Settings refactoring",

    "* Development improvements",
  },
}
