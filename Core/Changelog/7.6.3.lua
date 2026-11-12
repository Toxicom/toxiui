local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.6.3"] = {
  HOTFIX = true,
  RELEASE_DATE = "",
  CHANGES = {
    "* Breaking changes",

    "* New features",
    F.String.Forever() .. F.String.Menu.WunderBar() .. ": Achievements button in the MicroMenu now opens the Legacy system" .. F.String.Sublist(
      "Credits to bifferz for initial PR"
    ),

    "* Enhancements",

    "* Bug fixes",

    "* Profile updates",

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
  },
}
