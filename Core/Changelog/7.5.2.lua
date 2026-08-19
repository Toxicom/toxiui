local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.5.2"] = {
  HOTFIX = true,
  RELEASE_DATE = "Aug 19, 2026",
  CHANGES = {
    "* Bug fixes",
    F.String.Retail() .. "Fixed error being raised on class icon tag due to secrets.",

    "* Profile updates",
    "Remove ElvUI filters from profile" .. F.String.Sublist("ElvUI rewrote entire filter system, need to give it time to play around with") .. F.String.Sublist(
      "In the meantime, rely on ElvUI defaults"
    ),

    "* Documentation",
    F.String.MinElv("15.23"),
    F.String.Retail() .. "Update M+ S2 portals for " .. F.String.Menu.WunderBar(),
  },
}
