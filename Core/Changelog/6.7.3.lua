local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.7.3"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",
    "Disable Game Menu Button for " .. TXUI.Title .. F.String.Sublist("Known issue, not game breaking so disabling until I can fix it"),

    "* New features",
    "Add options to remove the Changelog and Random Tips from AFK module",

    "* Bug fixes",
    "Remove texture restrictions from " .. F.String.Details() .. " in Dark Mode",
    "Improve Skyriding Bar performance",
    "Fix new Spellbook for " .. F.String.Scaling(),
    "Fix WunderBar DataBar errors",

    "* Profile updates",

    "* Documentation",
    "Update " .. TXUI.Title .. " contributors",
    F.String.MinElv("13.71"),
    "Update " .. F.String.Luxthos() .. " link for War Within",

    "* Settings refactoring",

    "* Development improvements",
  },
}
