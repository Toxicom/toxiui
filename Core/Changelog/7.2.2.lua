local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.2.2"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    "Cooldown Manager fading option",
    "Cooldown Manager dynamic bars width option",

    "* Bug fixes",
    "Fix CDM style yeeting the power bar",
    "Add Stonard and Theramore portals to TBC " .. F.String.Menu.WunderBar() .. " Hearthstone module",

    "* Profile updates",

    "* Documentation",

    "* Settings refactoring",
    "Update " .. TXUI.Title .. " installer description for profile step to highlight risk of overwriting existing profile",

    "* Development improvements",
  },
}
