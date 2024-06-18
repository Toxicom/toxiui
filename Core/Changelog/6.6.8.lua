local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.6.8"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    TXUI.Title
      .. " Specialization icons for UnitFrames & Details!"
      .. F.String.Sublist("UnitFrame icons are available only for Retail due to API constraints")
      .. F.String.Sublist("Change in " .. TXUI.Title .. " -> " .. F.String.Menu.Skins() .. " -> " .. F.String.Class("Class ") .. "Icons"),
    "Add Line Height option for " .. F.String.Menu.Armory() .. " decorative lines",
    "Add " .. F.String.Class("Gradient Class color") .. " option for " .. F.String.Menu.Armory() .. " decorative lines",
    "Vehicle Bar updates:" --
      .. F.String.Sublist("Display 8 buttons instead of 7")
      .. F.String.Sublist("Increase button size")
      .. F.String.Sublist("Display keybindings")
      .. F.String.Sublist("Keybindings respect the Color Modifiers setting"),

    "* Bug fixes",

    "* Profile updates",

    "* Documentation",

    "* Settings refactoring",
    "Class Icons now have their own dedicated tab" .. F.String.Sublist(TXUI.Title .. " -> " .. F.String.Menu.Skins() .. " -> " .. F.String.Class("Class ") .. "Icons"),

    "* Development improvements",
    "Add string functions for " .. TXUI.Title .. " settings menu names",
  },
}
