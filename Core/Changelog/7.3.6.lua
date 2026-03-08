local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.3.6"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",

    "* Enhancements",

    "* Bug fixes",

    "* Profile updates",
    F.String.ElvUI() .. ": Add nameplates castbar width/height settings to profile" .. F.String.Sublist("Previously it was using ElvUI default, so nothing changes."),

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
  },
}
