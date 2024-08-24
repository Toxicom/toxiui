local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.8.0"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",

    "* Bug fixes",

    "* Profile updates",

    "* Documentation",

    "* Settings refactoring",
    "Allow matching any part of the string with the " .. TXUI.Title .. " split tag",
    "Remove first time scale increase from " .. TXUI.Title .. " installer",
    "Increase width of " .. F.String.Menu.WunderBar() .. " Module Positions dropdowns",

    "* Development improvements",
  },
}
