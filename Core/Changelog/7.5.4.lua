local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.5.4"] = {
  HOTFIX = true,
  RELEASE_DATE = "",
  CHANGES = {
    "* Breaking changes",

    "* New features",

    "* Enhancements",

    "* Bug fixes",
    F.String.Retail() .. "Potentially fix Armory's nil string error",

    "* Profile updates",

    "* Documentation",
    F.String.MinElv("15.25"),

    "* Settings refactoring",

    "* Development improvements",
  },
}
