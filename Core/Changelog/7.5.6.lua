local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.5.6"] = {
  HOTFIX = true,
  RELEASE_DATE = "",
  CHANGES = {
    "* Breaking changes",

    "* New features",

    "* Enhancements",

    "* Bug fixes",
    F.String.Retail() .. "Fixed Hearthstone data error caused by removed item API globals",
    F.String.ElvUI() .. " Unitframes: Fixed " .. TXUI.Title .. " Raid Leader icon being reset to the default icon",
    F.String.Retail() .. "Fixed name tag error spam in Delves due to secret class values",
    "Fixed Dead Icons error when a party frame has no unit",

    "* Profile updates",

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
  },
}
