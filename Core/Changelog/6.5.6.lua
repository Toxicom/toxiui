local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.5.6"] = {
  HOTFIX = true,
  CHANGES = {
    "* Bug fixes",
    "Prevent WunderBar erroring out on first initial load",
    "Add additional safety check for missing config info in Loadout names",

    "* Settings refactoring",
    "Increase installer frame's scale for first-time installations",

    "* Development improvements",
    "New helper function for safely using DevTool",
  },
}
