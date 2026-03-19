local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.3.8"] = {
  HOTFIX = true,
  RELEASE_DATE = "",
  CHANGES = {
    "* Breaking changes",

    "* New features",

    "* Enhancements",

    "* Bug fixes",
    F.String.Retail() .. F.String.CDM() .. ": Disable dynamic castbar width by default" .. F.String.Sublist("Got enabled by accident"),
    F.String.Retail() .. F.String.CDM() .. ": Remove buff bar dynamic width option" .. F.String.Sublist("Taint city, not worth it"),

    "* Profile updates",

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
  },
}
