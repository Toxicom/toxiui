local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.5.5"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    "Display Loadout name in WunderBar's " .. F.String.ToxiUI("SpecSwitch") .. " module" .. F.String.Sublist("Retail only"),
    "Mythic+ Portals in WunderBar's Hearthstone module!" --
      .. F.String.Sublist("Thanks Ikrekot for carry")
      .. F.String.Sublist("Thanks DreadMesh for carry"),

    "* Bug fixes",

    "* Profile updates",

    "* Documentation",
    "Add a lot of missing Hearthstone data to WunderBar" --
      .. F.String.Sublist("Credits to Morrivar"),

    "* Settings refactoring",

    "* Development improvements",
    "Add check for item type portals for WunderBar's Hearthstone module",
  },
}
