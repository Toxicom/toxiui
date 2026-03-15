local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.3.7"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    "Individual update option in Profile Updater",
    F.String.Retail() .. "Option to enable Damage Meter reset on new instances",
    F.String.Retail() .. F.String.Menu.WunderBar() .. " Hearthstone: Option to select random hearthstone pool",
    F.String.Retail() .. "Add " .. F.String.ToxiUI("/em") .. " chat command to open Edit Mode",

    "* Enhancements",
    "Update diff display in Profile Updater",
    F.String.Retail() .. F.String.CDM() .. ": Hopefully improve code for when entering Edit Mode",

    "* Bug fixes",
    F.String.Era() .. F.String.Anniversary() .. F.String.Classic() .. "Incorrect class icon showing on Game Menu Skin",
    F.String.Retail() .. F.String.CDM() .. ": Fix essential anchoring being disabled if only one of the class/power bars is disabled",

    "* Profile updates",
    F.String.ElvUI() .. " Fonts: Update world/pvp (sub)zone texts",
    F.String.ElvUI() .. " Fonts: Use correct settings for raid and tank unitframes",
    F.String.ElvUI() .. " Nameplates: Enable classification colors, only in instances",

    "* Documentation",
    F.String.Retail() .. F.String.CDM() .. ": Add " .. F.String.Class("Frost Mage", "MAGE") .. " by default to Power Bar Overrides" .. F.String.Sublist(
      "ElvUI 15.09 now shows icicles as class bar, so we can hide power bar"
    ),

    "* Settings refactoring",
    F.String.Retail() .. F.String.CDM() .. ": Display only current class specs in the overrides tab" .. F.String.Sublist("Option to display all specs is available"),
    F.String.Retail() .. "Simplify the settings of Damage Meter skin",
    "Add " .. F.String.ToxiUI("Commands") .. " tab in General " .. TXUI.Title .. " settings",
    "Display " .. TXUI.Title .. " badges in the Credits section",

    "* Development improvements",
    "Rename TitleRaid to TitleBold internally",
  },
}
