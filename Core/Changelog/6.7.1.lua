local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.7.1"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",
    "ActionBars and UnitFrames styles no longer persist through installations",

    "* New features",

    "* Bug fixes",
    "Allow changing textures in Gradient mode",
    "Fix " .. TXUI.Title .. " icon's in WunderBar tooltip",

    "* Profile updates",
    "Update default ilvl font for " .. F.String.Menu.Armory() .. " in |cffe35f00Cataclysm|r",

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
    "Clean up unused code",
  },
}
