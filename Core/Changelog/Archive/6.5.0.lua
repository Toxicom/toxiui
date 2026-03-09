local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.5.0"] = {
  HOTFIX = false,
  CHANGES = {
    "* New features",
    "Random tips in Game Menu",
    "Level tag for UnitFrames with " .. TXUI.Title .. " colors" .. F.String.Sublist("Hides for units that are at max level"),
    TXUI.Title .. " Master Looter icon",
    TXUI.Title .. " Main Tank icon",
    TXUI.Title .. " Main Assist icon",
    "Separate " .. F.String.Details() .. " profiles for One Window and Two Windows",
    "Add Spellbook Frame to " .. F.String.Scaling(),
    "Show Spec icon in Game Menu",
    TXUI.Title
      .. " Classification tag" --
      .. F.String.Sublist("Displays a silver or gold star for elites & rares"),

    "* Bug fixes",
    TXUI.Title .. ": Power tag not changing when toggling Dark theme",

    "* Profile updates",
    TXUI.Title --
      .. ": Reposition "
      .. F.String.ToxiUI("ToxiUIWAAnchor")
      .. " to align with Resources Above Icons option"
      .. F.String.Sublist("WeakAuras Guide on the Website has been appropriately updated too"),
    TXUI.Title .. ": Add War Within Hearthstone to WunderBar",

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
    F.String.ElvUI() .. ": Disable ActionBars HH:MM threshold",
    F.String.ElvUI() .. ": Fix missing font shadows",
    F.String.ElvUI() .. ": Add custom glow to ActionBars using " .. TXUI.Title .. " colors",

    F.String.WindTools() .. ": Fix missing font shadows",
    F.String.WindTools() .. ": Use class color for quest header font",

    F.String.WarpDeplete() .. ": Move frame up towards the minimap",

    "* Documentation",
    "Add additional info to Gradient theme description",
    F.String.MinElv("13.47"),
    "Update for World of Warcraft 10.2",
    "Update Icons font",

    "* Settings refactoring",
    "Update Credits section",
    "Update " .. F.String.ToxiUI("Open Installer") .. " button text",
    "Add " .. F.String.Class("Status Report", "MONK") .. " button to General settings",
    "Refactor the "
      .. F.String.Menu.Skins()
      .. " options:" --
      .. F.String.Sublist("Update descriptions to be more accurate")
      .. F.String.Sublist("Split existing options to a new Group Icons tab")
      .. F.String.Sublist("Split existing options to a new Raid Role Icons tab"),
    "Update " --
      .. F.String.Menu.WunderBar()
      .. " settings:"
      .. F.String.Sublist("Update descriptions be more accurate and informative")
      .. F.String.Sublist("Rename Modules -> Module Positions")
      .. F.String.Sublist("Rename SubModules -> Module Settings"),

    "* Development improvements",
    "Update " --
      .. TXUI.Title
      .. " Status Report window ("
      .. F.String.ToxiUI("/tx status")
      .. ")"
      .. F.String.Sublist("Add Dark Mode Gradient Names")
      .. F.String.Sublist("Add Details Gradient Text"),
    "Add extra check to " .. F.String.ToxiUI("F.AlmostEqual"),
  },
}
