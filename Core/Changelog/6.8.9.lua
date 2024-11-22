local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.8.9"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",
    "Change the name of all custom texts that " .. TXUI.Title .. " uses" .. F.String.Sublist("We did an automatic database conversion so nothing should break"),

    "* New features",

    "* Bug fixes",

    "* Profile updates",

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
  },
}
