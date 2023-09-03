local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.3.2"] = {
  HOTFIX = true,
  CHANGES = {
    "* New features",
    "Add " .. F.String.Class("Collections Journal") .. ", " .. F.String.Class("Wardrobe Frame") .. ", " .. F.String.Class("Dressing Room") .. " and " .. F.String.Class(
      "Inspect Frame"
    ) .. " scaling to " .. F.String.ToxiUI("Additional Scaling") .. " module",
    "Add Background Fade for Game Menu. Customize it in " .. F.String.FastGradientHex("Skins", "#ff77a9", "#b4004e") .. " -> " .. F.String.Class("ElvUI"),

    "* Bug fixes",
    "Force Priest class color in ElvUI",
    "Add OmniCD check in installer dialog",
    "Fix VehicleBar options missing",

    "* Profile updates",
    "Move TopCenterWidget down",
    "Enable Spell Icon inside ElvUI castbars",
    "Enable Spell Icon inside Plater castbars",
    "Increase height of Plater nameplate's health",

    "* Settings refactoring",
    "Move " .. TXUI.Title .. " Game Menu Button settings to " .. F.String.FastGradientHex("Skins", "#ff77a9", "#b4004e") .. " -> " .. F.String.Class("ElvUI"),

    "* Development Improvements",
    "Refactor Additional Scaling feature, it now has it's own separate tab in " .. F.String.FastGradientHex("Miscellaneous", "#b085f5", "#4d2c91"),
  },
}
