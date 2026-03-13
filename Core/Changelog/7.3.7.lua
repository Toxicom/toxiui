local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.3.7"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    "Individual update option in Profile Updater",
    F.String.Retail() .. "Option to enable Damage Meter reset on new instances",

    "* Enhancements",
    "Update diff display in Profile Updater",
    F.String.Retail() .. F.String.CDM() .. ": Hopefully improve code for when entering Edit Mode",

    "* Bug fixes",
    F.String.Era() .. F.String.Anniversary() .. F.String.Classic() .. "Incorrect class icon showing on Game Menu Skin",

    "* Profile updates",
    F.String.ElvUI() .. ": Update world/pvp (sub)zone texts",

    "* Documentation",
    F.String.Retail() .. F.String.CDM() .. ": Add " .. F.String.Class("Frost Mage", "MAGE") .. " by default to Power Bar Overrides" .. F.String.Sublist(
      "ElvUI 15.09 now shows icicles as class bar, so we can hide power bar"
    ),

    "* Settings refactoring",
    F.String.Retail() .. F.String.CDM() .. ": Display only current class specs in the overrides tab" .. F.String.Sublist("Option to display all specs is available"),
    F.String.Retail() .. "Simplify the settings of Damage Meter skin",

    "* Development improvements",
    "Rename TitleRaid to TitleBold internally",
  },
}
