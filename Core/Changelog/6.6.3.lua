local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.6.3"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    "Configuration options for WunderBar Flyouts" --
      .. F.String.Sublist(TXUI.Title .. " settings -> WunderBar -> General"),

    "* Bug fixes",
    "Adjust WunderBar's Flyout height" --
      .. F.String.Sublist("If there are less than 8 items in a column, the backdrop will adjust to the proper size"),

    "* Profile updates",

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
  },
}
