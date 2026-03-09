local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.4.1"] = {
  HOTFIX = true,
  CHANGES = {
    "* Bug fixes",
    TXUI.Title .. ": Fix gathering professions not showing on WunderBar in " .. F.String.ToxiUI("Wrath") .. " & " .. F.String.Class("Vanilla", "ROGUE"),
    TXUI.Title .. ": Fix missing Group Finder button of WunderBar's MicroMenu in " .. F.String.ToxiUI("Wrath"),
    TXUI.Title .. ": Fix WunderBar's SpecSwitch in " .. F.String.ToxiUI("Wrath"),
    TXUI.Title .. ": Fix Armory error due to " .. F.String.ElvUI() .. " 13.41",
    F.String.Details() .. ": Fix Deaths window gradient name in dark mode",

    "* Profile updates",
    TXUI.Title .. ": Add Path of the Naaru hearthstone toy to WunderBar",
    TXUI.Title .. ": Reduce default Dark Mode's transparency alpha",
    F.String.Details() .. ": Disable " .. F.String.Class("Show 'Real Time' DPS"),
    F.String.ElvUI() .. ": Fix castbar strata level for all unitframes",
    F.String.OmniCD() .. ": Change status bar font",

    "* Documentation",
    "Format changelog section headings with icons and gradient text",
    "Change changelog's format" .. F.String.Sublist("No more numbers") .. F.String.Sublist("Allows us to indent lists like this ;)"),
    F.String.MinElv("13.41"),
  },
}
