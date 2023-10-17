local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.4.5"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",

    "* Bug fixes",
    TXUI.Title .. ": Remove empty gap in `/tx status`",
    TXUI.Title .. ": Add fail-safety check for " .. F.String.Details() .. " in " .. F.String.GradientString() .. " mode",

    "* Profile updates",
    TXUI.Title .. ": Disable 'Details Gradient Text' toggle in Dark Mode if " .. F.String.Details() .. " is disabled or not using " .. TXUI.Title .. " profile",
    F.String.NameplateSCT() .. ": Enable small hits for Wrath & Classic",

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
  },
}
