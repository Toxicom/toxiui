local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.6.8"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    TXUI.Title
      .. " Specialization icons for UnitFrames & Details!"
      .. F.String.Sublist("UnitFrame icons are available only for Retail due to API constraints")
      .. F.String.Sublist("Change in " .. TXUI.Title .. " -> " .. F.String.FastGradientHex("Skins", "#ff77a9", "#b4004e") .. " -> " .. F.String.ElvUI()),

    "* Bug fixes",

    "* Profile updates",
    "Update ClassIcon fonts for UnitFrames to accomodate the Spec Icons"
      .. F.String.Sublist("If you don't want to run installer for this, just change all the !ClassIcon font sizes to 24~"),

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
  },
}
