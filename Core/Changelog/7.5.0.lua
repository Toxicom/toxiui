local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.5.0"] = {
  HOTFIX = true,
  RELEASE_DATE = "",
  CHANGES = {
    "* Breaking changes",

    "* New features",
    "Add " .. F.String.Menu.WunderBar() .. " Durability module's middle-click to summon an Auction House mount" .. F.String.Sublist("Credits to bifferz"),

    "* Enhancements",

    "* Bug fixes",
    "Replace old usage of E:UpdateAll()",
    "Fix " .. F.String.Menu.WunderBar() .. " DataBar's max level check erroring after a recent API change" .. F.String.Sublist(
      "Falls back to the old API on Classic/Anniversary where the new one isn't available"
    ),

    "* Profile updates",

    "* Documentation",
    F.String.MinElv("15.21"),

    "* Settings refactoring",

    "* Development improvements",
    "Fix the `/tx dev export names` command" .. F.String.Sublist("Rewrite to use CBOR encoding instead of AceSerializer/LibDeflate") .. F.String.Sublist("Credits to Tibs"),
  },
}
