local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.7.3"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",
    "Remove " .. TXUI.Title .. " Game Menu (ESC) button",

    "* New features",
    "Add options to remove the Changelog and Random Tips from AFK module",

    "* Bug fixes",
    "Remove texture restrictions from " .. F.String.Details() .. " in Dark Mode",
    "Improve Skyriding Bar performance",
    "Fix new Spellbook for " .. F.String.Scaling(),
    "Fix " .. F.String.Menu.WunderBar() .. " DataBar errors",
    "Fix Spec Icon erroring out when " .. F.String.Details() .. " is disabled",
    "Fix CharacterStatsPane strata level",
    "Fix Action Bar fading when opening spellbook or macros",
    "Fix " .. F.String.ElvUI() .. " theme skin",

    "* Documentation",
    "Update " .. TXUI.Title .. " contributors",
    F.String.MinElv("13.71"),
    "Update " .. F.String.Luxthos() .. " link for War Within",
  },
}
