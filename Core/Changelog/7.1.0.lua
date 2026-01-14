local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.1.0"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    "Support for The Burning Crusade Anniversary" --
      .. F.String.Sublist("Credits to roo7cause for initial PR")
      .. F.String.Sublist("Most fixes are just aligning TBC code with Vanilla code"),

    "* Bug fixes",

    "* Profile updates",

    "* Documentation",
    F.String.MinElv("14.06"),

    "* Settings refactoring",

    "* Development improvements",
  },
}
