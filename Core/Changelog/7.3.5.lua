local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.3.5"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",
    "Remove specialization icons:" --
      .. F.String.Sublist("ToxiSpecColored")
      .. F.String.Sublist("ToxiSpecColoredStroke")
      .. F.String.Sublist("ToxiSpecWhite")
      .. F.String.Sublist("ToxiSpecWhiteStroke"),

    "* New features",
    F.String.Retail() .. "Option to change spec icon for Damage Meter skin",

    "* Enhancements",

    "* Bug fixes",

    "* Profile updates",
    F.String.ElvUI() .. "Update nameplate auras fonts",

    "* Documentation",

    "* Settings refactoring",
    "Remove Details section from Class Icons settings",

    "* Development improvements",
    "Simplify unitframe font config",
  },
}
