local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.7.3"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",
    "Remove " .. TXUI.Title .. " Game Menu (ESC) button",
    "Disable ElvUI Theme Skin for " .. TXUI.Title .. F.String.Sublist("Known issue, not game breaking so disabling until I can fix it"),

    "* New features",
    "Add options to remove the Changelog and Random Tips from AFK module",

    "* Bug fixes",
    "Remove texture restrictions from " .. F.String.Details() .. " in Dark Mode",
    "Improve Skyriding Bar performance",
    "Fix new Spellbook for " .. F.String.Scaling(),
    "Fix WunderBar DataBar errors",
    "Fix Spec Icon erroring out when " .. F.String.Details() .. " is disabled",
    "Fix CharacterStatsPane strata level",
    "Fix Action Bar fading when opening spellbook or macros",

    "* Profile updates",

    "* Documentation",
    "Update " .. TXUI.Title .. " contributors",
    F.String.MinElv("13.71"),
    "Update " .. F.String.Luxthos() .. " link for War Within",

    "* Settings refactoring",

    "* Development improvements",
  },
}
