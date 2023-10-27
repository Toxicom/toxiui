local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.4.7"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    "Random tips in Game Menu",
    "Level tag for UnitFrames with " .. TXUI.Title .. " colors" .. F.String.Sublist("Hides for units that are at max level"),
    TXUI.Title .. " Master Looter icon",

    "* Bug fixes",
    TXUI.Title .. ": Power tag not changing when toggling Dark theme",

    "* Profile updates",
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

    F.String.WarpDeplete() .. ": Move frame up towards the minimap",

    "* Documentation",
    "Add additional info to Gradient theme description",
    "Increase minimum required " .. F.String.ElvUI() .. " version to 13.46",

    "* Settings refactoring",

    "* Development improvements",
  },
}
