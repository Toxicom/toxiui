local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.2.3"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    "tx:classicon:reverse tag",

    "* Bug fixes",

    "* Profile updates",
    F.String.ElvUI() .. ": Use the new reverse class icon tag for Target and Focus UnitFrames",
    F.String.ElvUI() .. ": Adjust Target Marker Icon size and position for Player, Target, Focus, Party, Boss, and Arena UnitFrames",
    F.String.ElvUI() .. ": Adjust Arena/Boss/Party UnitFrame size, spacing and text positions",
    F.String.ElvUI() .. ": Remove Arena UnitFrame's PvP Spec Icon",
    F.String.ElvUI() .. ": Add class icon tag to Arena UnitFrames",

    "* Documentation",
    "Re-enable Gradient Mode by default",

    "* Settings refactoring",

    "* Development improvements",
  },
}
