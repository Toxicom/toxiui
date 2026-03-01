local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.3.4"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",

    "* Enhancements",

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

    "* Development improvements",
  },
}
