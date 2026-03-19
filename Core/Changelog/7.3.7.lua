local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.3.7"] = {
  HOTFIX = true,
  RELEASE_DATE = "Mar TBD, 2026",
  CHANGES = {
    "* Breaking changes",
    "Remove action bar styles" .. F.String.Sublist("Buggy code that never worked correctly") .. F.String.Sublist("With individual Profile Updater, no longer that useful"),
    "Remove " .. F.String.ToxiUI("ThemeThreatGlow") .. " module" .. F.String.Sublist("Caused taint errors spamming in combat"),

    "* New features",
    "Individual update option in Profile Updater",
    F.String.Retail() .. "Option to enable Damage Meter reset on new instances",
    F.String.Retail() .. F.String.Menu.WunderBar() .. " Hearthstone: Option to select random hearthstone pool",
    F.String.Retail() .. "Add " .. F.String.ToxiUI("/em") .. " chat command to open Edit Mode",
    F.String.Retail() .. F.String.CDM() .. ": Option to sync buff bars to player unitframe",

    "* Enhancements",
    "Update diff display in Profile Updater",
    F.String.Retail() .. F.String.CDM() .. ": Hopefully improve code for when entering Edit Mode",
    F.String.Retail() .. "Profile Updater: Do not display unitframe bar width updates if " .. F.String.CDM() .. " dynamic width is enabled",
    F.String.Menu.WunderBar() .. " Time: Add tooltip information",
    F.String.Menu.WunderBar() .. " Time: Add middle-click to reload UI",

    "* Bug fixes",
    F.String.Era() .. F.String.Anniversary() .. F.String.Classic() .. "Incorrect class icon showing on Game Menu Skin",
    F.String.Retail() .. F.String.CDM() .. ": Fix essential anchoring being disabled if only one of the class/power bars is disabled",
    F.String.Retail() .. "Disable " .. F.String.CDM() .. " when enabling classic action bar style",
    "Fix nameplate text tags not being in the profile",

    "* Profile updates",
    F.String.ElvUI() .. " Fonts: Update world/pvp (sub)zone texts",
    F.String.ElvUI() .. " Fonts: Use correct settings for raid and tank unitframes",
    F.String.ElvUI() .. " Nameplates: Enable classification colors, only in instances",
    F.String.ElvUI() .. " Unitframes & Nameplates: Update filters to match " .. F.String.ElvUI() .. " defaults",

    "* Documentation",
    F.String.Retail() .. F.String.CDM() .. ": Add " .. F.String.Class("Frost Mage", "MAGE") .. " by default to Power Bar Overrides" .. F.String.Sublist(
      "ElvUI 15.09 now shows icicles as class bar, so we can hide power bar"
    ),
    F.String.Retail() .. F.String.CDM() .. ": Enable all submodules by default" .. F.String.Sublist("Main module is still disabled by default"),

    "* Settings refactoring",
    F.String.Retail() .. F.String.CDM() .. ": Display only current class specs in the overrides tab" .. F.String.Sublist("Option to display all specs is available"),
    F.String.Retail() .. F.String.CDM() .. ": Tidy up keybind settings",
    F.String.Retail() .. F.String.CDM() .. ": Refactor dynamic width settings to accomodate new options",
    F.String.Retail() .. "Simplify the settings of Damage Meter skin",
    "Add " .. F.String.ToxiUI("Commands") .. " tab in General " .. TXUI.Title .. " settings",
    "Display " .. TXUI.Title .. " badges in the Credits section",
    "Allow font scale slider to go from -5 to 5" .. F.String.Sublist("Previously it was -3 to 3"),
    "Add release dates to in-game changelogs from v7.0.0 upwards",

    "* Development improvements",
    "Rename TitleRaid to TitleBold internally",
  },
}
