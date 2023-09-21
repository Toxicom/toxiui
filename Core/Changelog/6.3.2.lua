local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.3.2"] = {
  HOTFIX = true,
  CHANGES = {
    "* New features",
    "Add new options to "
      .. F.String.ToxiUI("Additional Scaling")
      .. " module"
      .. F.String.Sublist(F.String.Class("Collections Journal")) -- comment to stop auto-formatting
      .. F.String.Sublist(F.String.Class("Wardrobe Frame")) -- comment to stop auto-formatting
      .. F.String.Sublist(F.String.Class("Dressing Room")) -- comment to stop auto-formatting
      .. F.String.Sublist(F.String.Class("Inspect Frame")), -- comment to stop auto-formatting
    "Add Background Fade for Game Menu" .. F.String.Sublist("Customize it in " .. F.String.FastGradientHex("Skins", "#ff77a9", "#b4004e") .. " -> " .. F.String.Class("ElvUI")),
    "Add " .. TXUI.Title .. " group Leader icon" .. F.String.Sublist(
      "Customize it in " .. F.String.FastGradientHex("Skins", "#ff77a9", "#b4004e") .. " -> " .. F.String.Class("ElvUI")
    ),

    "* Bug fixes",
    F.String.ElvUI() .. ": Force Priest class color",
    TXUI.Title .. ": Add OmniCD check in installer dialog",
    TXUI.Title .. ": Fix VehicleBar options missing",
    TXUI.Title .. ": Fix ClassIcon error",

    "* Profile updates",
    F.String.Plater() .. ": Enable Spell Icon inside castbars",
    F.String.ElvUI() .. ": Move TopCenterWidget down",
    F.String.ElvUI() .. ": Enable Spell Icon inside castbars",
    F.String.ElvUI() .. ": Sort raid members by group for Raid 1 & Raid 2",
    F.String.ElvUI() .. ": Increase raid group spacing for Raid 1 & Raid 2",
    F.String.ElvUI() .. ": Enable Power bar for Target frame",

    "* Documentation",
    "Increase version number for " .. F.String.Class("10.1.7"),
    "Increase minimum required " .. F.String.Class("ElvUI", "SHAMAN") .. " version to " .. F.String.Class("13.40"),

    "* Settings refactoring",
    "Move " .. TXUI.Title .. " Game Menu Button settings to " .. F.String.FastGradientHex("Skins", "#ff77a9", "#b4004e") .. " -> " .. F.String.Class("ElvUI"),

    "* Development Improvements",
    "Refactor Additional Scaling feature, it now has it's own separate tab in " .. F.String.FastGradientHex("Miscellaneous", "#b085f5", "#4d2c91"),
    "Make the '" .. F.String.ToxiUI("/tx install") .. "' command actually open the installer",
    "Add alias to open " .. TXUI.Title .. " Installer - '" .. F.String.ToxiUI("/tx i") .. "'",
  },
}
