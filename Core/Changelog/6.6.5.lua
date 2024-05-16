local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.6.5"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",

    "* Bug fixes",
    "Remove season property from some mage portals",
    "Fix Armory's missing enchants showing too early",

    "* Profile updates",
    "Reduce deconstruct's label font size",
    F.String.ElvUI()
      .. " Castbar changes" --
      .. F.String.Sublist("Change font to Primary")
      .. F.String.Sublist("Reduce height to match smaller font")
      .. F.String.Sublist("Enable class colors for cast bar"),
    "Change " .. F.String.Plater() .. " Castbar to match " .. F.String.ElvUI(),

    "* Documentation",
    "Update Dragonflight Season 4 Mythic+ portals for WunderBar",

    "* Settings refactoring",

    "* Development improvements",
  },
}
