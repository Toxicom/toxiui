local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.7.3"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    "Add options to remove the Changelog and Random Tips from AFK module",

    "* Bug fixes",
    "Remove texture restrictions from " .. F.String.Details() .. " in Dark Mode",
    "Improve Skyriding Bar performance",

    "* Profile updates",

    "* Documentation",
    "Update " .. TXUI.Title .. " contributors",
    F.String.MinElv("13.71"),
    "Update " .. F.String.Luxthos() .. " link for War Within",

    "* Settings refactoring",

    "* Development improvements",
  },
}
