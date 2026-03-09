local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.7.0"] = {
  HOTFIX = true,
  CHANGES = {
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
    "New split name tags" .. F.String.Sublist("See Available Tags"),

    "* Bug fixes",
    "Improve fallback colors for F.Color.SetGradient",
    "Update " .. TXUI.Title .. " class icon on spec change",
    "Fix broken " .. F.String.OmniCD() .. " installer",
    "Fix squashed icons in " .. F.String.Menu.WunderBar() .. " flyouts",
    "Fix " .. F.String.Details() .. " version in " .. F.String.ToxiUI("/tx status"),
    "Fix SpecSwitch module in |cff2eda00Vanilla|r",

    "* Profile updates",
    "Update default Hunter's shift color",
    "Update " .. F.String.BigWigs() .. " Bars positions" .. F.String.Sublist("Resolutions other than 2560x1440 might need re-adjustments"),
    "Update font for inspect item level",
    "Update default " .. F.String.Menu.Armory() .. " profile",
    "Update " .. F.String.Plater() .. " mods",
    "Set Spec Stylized icons as default for Retail",
    "Update " .. F.String.Details() .. " default selected icons",

    "* Documentation",
    F.String.MinElv("13.69"),
    "Update version for Vanilla",

    "* Settings refactoring",
    "Class Icons now have their own dedicated tab" .. F.String.Sublist(TXUI.Title .. " -> " .. F.String.Menu.Skins() .. " -> " .. F.String.Class("Class ") .. "Icons"),
    "Rename Miscellaneous tab to " .. F.String.Menu.Plugins(),

    "* Development improvements",
    "Add string functions for " .. TXUI.Title .. " settings menu names",
    "Remove Priest color overrides" .. F.String.Sublist("It never worked correctly and caused more issues than benefits"),
    "Use the new " .. F.String.BigWigs() .. " profile API",
    "Disable " .. F.String.Menu.Armory() .. " if " .. F.String.ElvUI() .. " Character Frame Skin is disabled",
    "Add a custom scale table for weird resolutions",
  },
}
