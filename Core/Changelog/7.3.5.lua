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

    "* Enhancements",

    "* Bug fixes",

    "* Profile updates",

    "* Documentation",

    "* Settings refactoring",
    "Remove Details section from Class Icons settings",

    "* Development improvements",
  },
}
