local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.6.2"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    "Enabled Armory for Cataclysm Classic " --
      .. F.String.Error("[BETA]")
      .. F.String.Sublist("Very early testing phase")
      .. F.String.Sublist("Some features missing and not sure if will be brought back")
      .. F.String.Sublist("Might disable again if we find something critical that I can't fix :("),
    "Auto open attributes window when opening armory" --
      .. F.String.Sublist("For Cataclysm Classic"),

    "* Bug fixes",
    "Attempt to fix moving action bars",
    "Fix WunderBar's SpecSwitch to accurately show dual spec",
    "Fix typo in Armory",
    "Paladin spec icons not showing",
    "Enable Adventure Guide in WunderBar for Cataclysm Classic",
    "Add missing enchant to head slot for Retail Armory",
    "Stance Bar was lost on Classic style ActionBars",

    "* Profile updates",
    "Remove happiness from pet frame for non-vanilla versions",
    "Increase backdrop fade transparency to 80",

    "* Documentation",
    F.String.MinElv("13.63"),
    "Update Luxthos WA link for Cataclysm Classic",

    "* Settings refactoring",

    "* Development improvements",
  },
}
