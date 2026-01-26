local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.2.1"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",

    "* Bug fixes",

    "* Profile updates",
    TXUI.Title .. ": Use 3:2 aspect ratio for Vehicle Bar buttons",
    TXUI.Title .. ": Display soul shards for tx:power tag on Retail",
    F.String.ElvUI() .. ": Fix position of Class Bar for Retail",
    F.String.ElvUI() .. ": Use raw power tag instead of percentage for player power bar",

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
  },
}
