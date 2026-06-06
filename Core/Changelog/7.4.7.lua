local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.4.7"] = {
  HOTFIX = true,
  RELEASE_DATE = "",
  CHANGES = {
    "* Breaking changes",

    "* New features",

    "* Enhancements",

    "* Bug fixes",

    "* Profile updates",

    "* Documentation",
    F.String.Classic() .. "Update .toc for 5.5.4",
    F.String.MinElv("15.16"),

    "* Settings refactoring",

    "* Development improvements",
  },
}
