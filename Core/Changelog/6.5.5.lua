local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.5.5"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    "Display Loadout name in WunderBar's " .. F.String.ToxiUI("SpecSwitch") .. " module" .. F.String.Sublist("Retail only"),
    F.String.Class("Color")
      .. " Modifier keys; Credits and huge shoutouts to these people:" --
      .. F.String.Sublist(F.String.Eltreum() .. " from EltruismUI")
      .. F.String.Sublist(F.String.Class("Repooc", "DRUID"))
      .. F.String.Sublist(F.String.ElvUI() .. " community"),
    "Mythic+ Portals in WunderBar's Hearthstone module!" --
      .. F.String.Sublist("Thanks Ikrekot for carry")
      .. F.String.Sublist("Thanks DreadMesh for carry"),
    "Option to show only current season's M+ portals in flyout",
    "New Available Tags for "
      .. TXUI.Title
      .. " Names - uppercase" --
      .. F.String.Sublist("Currently not used anywhere"),

    "* Bug fixes",
    "Fix missing tooltip on WunderBar's profession flyouts",

    "* Profile updates",

    "* Documentation",
    "Add a lot of missing Hearthstone data to WunderBar" --
      .. F.String.Sublist("Credits to Morrivar"),

    "* Settings refactoring",

    "* Development improvements",
    "Add check for item type portals for WunderBar's Hearthstone module",
  },
}
