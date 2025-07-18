local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.9.9"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",

    "* Bug fixes",

    "* Profile updates",
    F.String.Plater() .. ": Update interrupt color mod",

    "* Documentation",
    F.String.MinElv("13.94"),

    "* Settings refactoring",

    "* Development improvements",
    "Simplify logic for checking loaded addons",
  },
}
