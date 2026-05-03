local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.4.5"] = {
  HOTFIX = true,
  RELEASE_DATE = "",
  CHANGES = {
    "* Breaking changes",
    "Remove " .. F.String.Details() .. " Gradient and Dark mode skinning",

    "* New features",

    "* Enhancements",

    "* Bug fixes",
    F.String.Retail() .. "UnitSpeed is now secret in combat - do not display speed in vigor bar during combat",

    "* Profile updates",

    "* Documentation",
    F.String.MinElv("15.13"),

    "* Settings refactoring",

    "* Development improvements",
  },
}
