local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.7.0"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    TXUI.Title
      .. " Specialization icons for UnitFrames & Details!"
      .. F.String.Sublist("UnitFrame icons are available only for Retail due to API constraints")
      .. F.String.Sublist("Change in " .. TXUI.Title .. " -> " .. F.String.Menu.Skins() .. " -> " .. F.String.Class("Class ") .. "Icons"),
    "New " .. TXUI.Title .. " Specialization icons for " .. F.String.Class("Enhancement Shaman", "SHAMAN") .. " and " .. F.String.Class("Outlaw Rogue", "ROGUE"),
    "Update " .. F.String.Menu.Armory() .. " decorative line options" .. F.String.Sublist("Add line height option") .. F.String.Sublist(
      "Add " .. F.String.Class("Gradient Class color") .. " option"
    ),
    "Vehicle Bar updates:" --
      .. F.String.Sublist("Display 8 buttons instead of 7")
      .. F.String.Sublist("Increase button size")
      .. F.String.Sublist("Display keybindings")
      .. F.String.Sublist("Keybindings respect the Color Modifiers setting")
      .. F.String.Sublist("Remove stuck animation of moving up")
      .. F.String.Sublist("Add option to change button width")
      .. F.String.Sublist("Add a Vigor (Skyriding) bar"),
    "Redesigned AFK screen",

    "* Bug fixes",
    "Improve fallback colors for F.Color.SetGradient",
    "Update " .. TXUI.Title .. " class icon on spec change",

    "* Profile updates",
    "Update default Hunter's shift color",
    "Update " .. F.String.BigWigs() .. " Bars positions" .. F.String.Sublist("Resolutions other than 2560x1440 might need re-adjustments"),

    "* Documentation",
    F.String.MinElv("13.67"),

    "* Settings refactoring",
    "Class Icons now have their own dedicated tab" .. F.String.Sublist(TXUI.Title .. " -> " .. F.String.Menu.Skins() .. " -> " .. F.String.Class("Class ") .. "Icons"),
    "Rename Miscellaneous tab to " .. F.String.Menu.Plugins(),

    "* Development improvements",
    "Add string functions for " .. TXUI.Title .. " settings menu names",
    "Remove Priest color overrides" .. F.String.Sublist("It never worked correctly and caused more issues than benefits"),
    "Use the new " .. F.String.BigWigs() .. " profile API",
  },
}