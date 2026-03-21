local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.3.9"] = {
  HOTFIX = true,
  RELEASE_DATE = "",
  CHANGES = {
    "* Breaking changes",

    "* New features",
    TXUI.Title .. " Landing pages" .. F.String.Sublist("Will show a landing page on fresh install for some instructions") .. F.String.Sublist(
      "Will show a landing page on addon update to remind about the Profile Updater feature"
    ),

    "* Enhancements",
    F.String.Retail() .. "Adjust which armory slots require enchants/sockets for Midnight",

    "* Bug fixes",

    "* Profile updates",

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
  },
}
