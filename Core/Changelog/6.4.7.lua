local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.4.7"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    "Random tips in Game Menu",
    "Level tag for UnitFrames with " .. TXUI.Title .. " colors" .. F.String.Sublist("Hides for units that are at max level"),
    TXUI.Title .. " Master Looter icon",
    TXUI.Title .. " Main Tank icon",
    TXUI.Title .. " Main Assist icon",
    "Separate " .. F.String.Details() .. " profiles for One Window and Two Windows",
    "Add Spellbook Frame to " .. F.String.Scaling(),

    "* Bug fixes",
    TXUI.Title .. ": Power tag not changing when toggling Dark theme",

    "* Profile updates",
    TXUI.Title --
      .. ": Reposition "
      .. F.String.ToxiUI("ToxiUIWAAnchor")
      .. " to align with Resources Above Icons option"
      .. F.String.Sublist("WeakAuras Guide on the Website has been appropriately updated too"),

    F.String.ElvUI() .. ": Increase Background Fade alpha from 40% to 60%",
    F.String.ElvUI() --
      .. ": Add the "
      .. TXUI.Title
      .. " level tag to these UnitFrames:"
      .. F.String.Sublist("Player")
      .. F.String.Sublist("Target")
      .. F.String.Sublist("Party"),
    F.String.ElvUI()
      .. ": Updates to Party UnitFrames in Healer layout:" --
      .. F.String.Sublist("Fix fonts for level and power")
      .. F.String.Sublist("Give more breathing room for debuffs & buffs")
      .. F.String.Sublist("Move Power text to the right side")
      .. F.String.Sublist("Move the frames down"),
    F.String.ElvUI() --
      .. ": Updates to Main Tank & Main Assist UnitFrames:"
      .. F.String.Sublist("Change fonts to match Raid UnitFrames")
      .. F.String.Sublist("Move them up to align with chat top corner"),
    F.String.ElvUI() .. ": Update Pet & Stance bars visibility to match " .. F.String.ElvUI() .. " defaults",
    F.String.ElvUI() .. ": Update Pet ActionBar size to 4:3 ratio",

    F.String.WarpDeplete() .. ": Move frame up towards the minimap",

    "* Documentation",
    "Add additional info to Gradient theme description",
    "Increase minimum required " .. F.String.ElvUI() .. " version to 13.46",
    "Update Credits section",
    "Update Open Installer button text",

    "* Settings refactoring",

    "* Development improvements",
  },
}
