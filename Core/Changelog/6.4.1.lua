local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.4.1"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",

    "* Bug fixes",
    TXUI.Title .. ": Fix gathering professions not showing on WunderBar in Wrath & Classic",

    "* Profile updates",
    TXUI.Title .. ": Add Path of the Naaru hearthstone toy to WunderBar",
    TXUI.Title .. ": Reduce default Dark Mode's transparency alpha",
    F.String.Details() .. ": Disable " .. F.String.Class("Show 'Real Time' DPS"),
    F.String.ElvUI() .. ": Fix castbar strata level for all unitframes",

    "* Documentation",
    "Format changelog section headings with icons and gradient text",
    "Change changelog's format" .. F.String.Sublist("No more numbers") .. F.String.Sublist("Allows us to indent lists like this ;)"),

    "* Settings refactoring",

    "* Development improvements",
  },
}
