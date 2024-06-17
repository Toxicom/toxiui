local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.5.5"] = {
  HOTFIX = true,
  CHANGES = {
    "* New features",
    "Display Loadout name in WunderBar's " .. F.String.ToxiUI("SpecSwitch") .. " module" .. F.String.Sublist("Retail only"),
    F.String.Class("Color")
      .. " Modifier keys; Credits and huge shoutouts to these people:" --
      .. F.String.Sublist(F.String.Eltreum() .. " from EltruismUI")
      .. F.String.Sublist(F.String.Class("Repooc", "DRUID"))
      .. F.String.Sublist(F.String.ElvUI() .. " community"),
    "Mythic+ Portals in WunderBar's Hearthstone module!" --
      .. F.String.Sublist("Thanks Ikrekot & DreadMesh for carry"),
    "Option to show only current season's M+ portals in flyout",
    "New Available Tags for "
      .. TXUI.Title
      .. " Names - UPPERCASE" --
      .. F.String.Sublist("Currently not used anywhere"),
    "Add new styles for the class icon tag" --
      .. F.String.Sublist(F.String.Menu.Skins() .. " -> " .. F.String.ElvUI())
      .. F.String.Sublist("Taken from " .. F.String.Ugg() .. " with their consent")
      .. F.String.Sublist("Must mention " .. F.String.Color("Laev", "9db8eb") .. " here because he caused chaos :--)"),
    "New level tag with difficulty colors. By default set for target & party frames." --
      .. F.String.Sublist("[tx:level:difficulty]"),

    "* Bug fixes",
    "Fix WunderBar's Profession flyouts",

    "* Profile updates",
    "Use the new " .. F.String.ToxiUI("[tx:level:difficulty]") .. " tag for Party & Target frames",

    "* Documentation",
    "Add a lot of missing Hearthstone data to WunderBar" --
      .. F.String.Sublist("Credits to Morrivar"),
    F.String.MinElv("13.58"),
    "Update " .. TXUI.Title .. " contributor names",

    "* Settings refactoring",
    "Update " .. TXUI.Title .. " font's " .. F.String.ToxiUI("[ ]") .. " symbols so they're not confused with " .. F.String.ToxiUI("( )"),

    "* Development improvements",
    "Add check for item type portals for WunderBar's Hearthstone module",
  },
}
