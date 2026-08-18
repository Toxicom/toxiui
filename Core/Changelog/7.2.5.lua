local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.2.5"] = {
  HOTFIX = true,
  RELEASE_DATE = "Feb 7, 2026",
  CHANGES = {
    "* Enhancements",
    "Simplify the 'Import Existing' function",

    "* Bug fixes",
    "Don't process movers after importing existing profile",

    "* Profile updates",
    F.String.ElvUI() .. ": Add " .. F.String.ToxiUI("[tx:classification]") .. " tag to Enemy NPC Nameplates" .. F.String.Sublist(
      "We use the Level field for it, since there's no custom texts option for Nameplates"
    ),
  },
}
