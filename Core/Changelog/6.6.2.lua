local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.6.2"] = {
  HOTFIX = true,
  CHANGES = {
    "* New features",
    "Enabled "
      .. F.String.Menu.Armory()
      .. " for Cataclysm Classic " --
      .. F.String.Error("[BETA]")
      .. F.String.Sublist("Very early testing phase")
      .. F.String.Sublist("Some features missing and not sure if will be brought back")
      .. F.String.Sublist("Might disable again if we find something critical that I can't fix :("),
    "Auto open attributes window when opening armory" --
      .. F.String.Sublist("For Cataclysm Classic"),
    "Add backdrop to WunderBar's Mage portals flyout",
    "During layout installation, if a bag addon is detected, disable " --
      .. F.String.ElvUI()
      .. " bags module"
      .. F.String.Sublist("Bag AddOns we look for:")
      .. F.String.Sublist("Bagnon, BetterBags, Baggins, Sorted, Inventorian, Baganator, ArkInventory, OneBag3, Combuctor"),

    "* Bug fixes",
    "Attempt to fix moving action bars",
    "Fix WunderBar's SpecSwitch to accurately show dual spec",
    "Fix typo in " .. F.String.Menu.Armory(),
    "Paladin spec icons not showing",
    "Enable Adventure Guide in WunderBar for Cataclysm Classic",
    "Add missing enchant to head slot for Retail " .. F.String.Menu.Armory(),
    "Stance Bar was lost on Classic style ActionBars",

    "* Profile updates",
    "Remove happiness from pet frame for non-vanilla versions",
    "Increase backdrop fade transparency to 80",
    "Enable by default Awakened Crests in WunderBar currency module",
    "Blacklist certain Warrior debuffs on Plater" --
      .. F.String.Sublist("Trauma & Blood Frenzy"),

    "* Documentation",
    F.String.MinElv("13.64"),
    "Update Luxthos WA link for Cataclysm Classic",
    "Update for Patch 10.2.7",
  },
}
