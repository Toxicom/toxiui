local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.4.7"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    "Random tips in Game Menu",
    "Level tag for UnitFrames with " .. TXUI.Title .. " colors" .. F.String.Sublist("Hides for units that are at max level"),

    "* Bug fixes",

    "* Profile updates",
    F.String.ElvUI() .. ": Increase Background Fade alpha from 40% to 60%",

    "* Documentation",
    "Add additional info to Gradient theme description",
    "Increase minimum required " .. F.String.ElvUI() .. " version to 13.46",

    "* Settings refactoring",

    "* Development improvements",
  },
}
