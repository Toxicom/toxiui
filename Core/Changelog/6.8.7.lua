local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.8.7"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",

    "* Bug fixes",
    "Fix IDs for season 1 M+ portals",
    "Enable repair mount for Cata",
    "Fix BugGrabber disabling for " .. TXUI.Title .. " Debug mode",
    "Change " --
      .. F.String.Menu.Armory()
      .. " Missing Socket option's description to update dynamically each time it shows up"
      .. F.String.Sublist("This should fix missing information on first load of the game")
      .. F.String.Sublist("If the item name is still not showing, re-hover the checkbox to show an updated description"),

    "* Profile updates",
    F.String.Plater() .. ": Add Wither to manual debuff tracking",

    "* Documentation",
    "Add " .. F.String.ToxiUI("Notorious Thread's Hearthstone") .. " to " .. F.String.Menu.WunderBar(),
    "Update contributors list",

    "* Settings refactoring",

    "* Development improvements",
  },
}
