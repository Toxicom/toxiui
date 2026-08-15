local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.5.2"] = {
  HOTFIX = true,
  RELEASE_DATE = "",
  CHANGES = {
    "* Breaking changes",

    "* New features",

    "* Enhancements",

    "* Bug fixes",

    "* Profile updates",

    "* Documentation",
    F.String.MinElv("15.22"),
   F.String.Retail() ..  "Update M+ S2 portals for " .. F.String.Menu.WunderBar(),

    "* Settings refactoring",

    "* Development improvements",
  },
}
