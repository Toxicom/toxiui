local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.4.5"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",

    "* Bug fixes",
    TXUI.Title .. ": Remove empty gap in `/tx status`",

    "* Profile updates",
    F.String.NameplateSCT() .. ": Enable small hits for Wrath & Classic",

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
  },
}
