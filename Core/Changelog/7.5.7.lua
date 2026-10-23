local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.5.7"] = {
  HOTFIX = true,
  RELEASE_DATE = "",
  CHANGES = {
    "* Breaking changes",

    "* New features",

    "* Enhancements",

    "* Bug fixes",
    "Fixed " .. F.String.ToxiUI("[tx:health]") .. " tags never showing Dead, Ghost or Offline status",

    "* Profile updates",

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
  },
}
