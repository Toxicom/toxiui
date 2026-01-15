local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.1.2"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",

    "* Bug fixes",
    "Remove duplicate event registration for gradient updates",
    "Fix " .. F.String.Menu.WunderBar() .. " DataBar reputation mode",

    "* Profile updates",
    F.String.ElvUI() .. ": Disable Objective Tracker Auto Hide",
    F.String.Plater() .. ": Disable the new Unit Type coloring",

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
    "Refactor " .. F.String.Menu.WunderBar() .. " DataBar module to use safe API calls" .. F.String.Sublist(
      "Whenever non-retail versions introduce Retail features, they should just work without breaking the module."
    ),
  },
}
