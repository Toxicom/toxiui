local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.2.3"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    "tx:classicon:reverse tag",

    "* Bug fixes",

    "* Profile updates",
    F.String.ElvUI() .. ": Use the new reverse class icon tag for Target and Focus UnitFrames.",
    F.String.ElvUI() .. ": Adjust Target Marker Icon size and position for Player, Target, Focus, Party, Boss, and Arena UnitFrames.",

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
  },
}
