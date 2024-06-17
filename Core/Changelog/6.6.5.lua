local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.6.5"] = {
  HOTFIX = true,
  CHANGES = {
    "* Bug fixes",
    "Remove season property from some mage portals",
    "Fix " .. F.String.Menu.Armory() .. "'s missing enchants showing too early",
    "Fix " .. F.String.Menu.Armory() .. "'s neck slot missing sockets showing on Cataclysm Classic",

    "* Profile updates",
    "Reduce deconstruct's label font size",
    F.String.ElvUI()
      .. " Castbar changes" --
      .. F.String.Sublist("Change font to Primary")
      .. F.String.Sublist("Reduce height to match smaller font")
      .. F.String.Sublist("Enable class colors for cast bar"),
    "Change " .. F.String.Plater() .. " Castbar to match " .. F.String.ElvUI(),
    "Update fonts used" --
      .. F.String.Sublist("Primary instead of TitleRaid in most cases"),
    "Update Armory default fonts",
    "Update default ToxiUI icons" --
      .. F.String.Sublist("Material styles for role & group icons")
      .. F.String.Sublist("Previous icons still available"),
    "Disable OmniCD in raid by default",

    "* Documentation",
    "Update Dragonflight Season 4 Mythic+ portals for WunderBar",
  },
}
