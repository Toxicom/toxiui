local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.3.4"] = {
  HOTFIX = true,
  RELEASE_DATE = "Mar 1, 2026",
  CHANGES = {
    "* New features",
    F.String.Menu.WunderBar() .. ": Option to adjust group spacing for flyouts",

    "* Enhancements",
    F.String.Menu.WunderBar() .. ": Change flyout slots to be 3:2 aspect ratio instead of 4:3",

    "* Bug fixes",
    F.String.Retail() .. "Hide mana text for " .. F.String.Class("Balance Druids", "DRUID"),

    "* Profile updates",
    F.String.ElvUI() .. ": Disable source text for nameplate buffs",
    F.String.ElvUI() .. ": Adjust cdm charge count color",
    F.String.ElvUI() .. ": Set heal prediction max overflow to 100%",

    "* Documentation",
    F.String.MinElv("15.07"),
    F.String.Retail() .. "Update currencies for Midnight Season 1",
    F.String.Retail() .. F.String.Menu.WunderBar() .. ": Add Personal Key to the Arcantina",

    "* Settings refactoring",
    F.String.Menu.WunderBar() .. ": Clean up and organize flyout settings",
  },
}
