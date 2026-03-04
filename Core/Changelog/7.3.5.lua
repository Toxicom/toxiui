local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.3.5"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    F.String.Retail() .. "Option to change spec icon for Damage Meter skin",
    "Class Icons style setting now controls all spec/class icon displays globally",

    "* Enhancements",
    "Show diff for fonts in Profile Updater",
    "Class-only icon displays (Played graph, spec fallbacks) respect the selected class icon style",

    "* Bug fixes",

    "* Profile updates",
    F.String.ElvUI() .. "Update nameplate auras fonts",

    "* Documentation",
    F.String.Retail() .. F.String.Menu.WunderBar() .. ": Add Wormhole Generator: Quel'thalas to Hearthstone module",
    F.String.MinElv("15.08"),

    "* Settings refactoring",
    "Remove Details section from Class Icons settings",
    "Remove per-feature spec icon style selectors (Game Menu, AFK, Damage Meter) in favor of global Class Icons setting",

    "* Development improvements",
    "Simplify unitframe font config",
  },
}
