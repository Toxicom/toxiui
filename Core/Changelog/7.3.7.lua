local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.3.7"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    "Individual update option in Profile Updater",

    "* Enhancements",
    "Update diff display in Profile Updater",

    "* Bug fixes",

    "* Profile updates",
    F.String.ElvUI() .. ": Update world/pvp (sub)zone texts",

    "* Documentation",

    "* Settings refactoring",
    F.String.Retail() .. F.String.CDM() .. ": Display only current class specs in the overrides tab" .. F.String.Sublist("Option to display all specs is available"),

    "* Development improvements",
    "Rename TitleRaid to TitleBold internally",
  },
}
