local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.6.5"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",

    "* Bug fixes",

    "* Profile updates",
    "Reduce deconstruct's label font size",
    "Castbar changes" --
      .. F.String.Sublist("Change font to Primary")
      .. F.String.Sublist("Reduce height to match smaller font")
      .. F.String.Sublist("Enable class colors for cast bar"),

    "* Documentation",
    "Update Dragonflight Season 4 Mythic+ portals for WunderBar",

    "* Settings refactoring",

    "* Development improvements",
  },
}
