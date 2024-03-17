local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.5.8"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",
    "Your selected Hearthstone in WunderBar is now randomized" --
      .. F.String.Sublist("See " .. F.String.Class("New features", "MONK") .. " section")
      .. F.String.Sublist("Can disable this in Hearthstone settings"),

    "* New features",
    "Option for random Hearthstone toy in WunderBar" --
      .. F.String.Sublist("Enabled by default"),

    "* Bug fixes",

    "* Profile updates",

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
  },
}
