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
    F.String.ElvUI() --
      .. ": Match UnitFrame Class Resources colors to the ones we have in Gradient mode"
      .. F.String.Sublist("Previously in Dark & Normal modes the resource colors were default"),

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
  },
}
