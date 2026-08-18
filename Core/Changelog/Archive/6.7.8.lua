local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.7.8"] = {
  HOTFIX = true,
  CHANGES = {
    "* New features",
    "Add Korean glyphs to fonts used in ToxiUI" .. F.String.Sublist("Credits to bbingr"),
    F.String.Class("Class") .. " background option in " .. F.String.Menu.Armory(),
    "Show labels option for Mythic+ flyout in " .. F.String.Menu.WunderBar(),
    "Option to hide camera controls in " .. F.String.Menu.Armory(),
    "Option to reposition sockets in " .. F.String.Menu.Armory(),
    "Increase action bars keybind width to match the button width"
      .. F.String.Sublist("Currently this option is tied to the ColorModifiers setting with no option to individually disable it."),
    "Add more options to " .. F.String.Menu.Armory() .. " attribute icon",

    "* Bug fixes",
    "Fix error with Game Menu skin when background fade is disabled",
    "Fix Spellbook scaling for Retail",
    "Fix ActionBars ColorModifiers for UTF8 characters",
    "Fix VehicleBar Keybinds ColorModifier for UTF8 characters",
    "Fix Split name tag for UTF8 characters",
    "Fix Dark Mode toggle updating movers",
    "Hopefully fix Skyriding Bar's wrong width",
    "Display Specialization icon in Game Menu no matter which font is selected",
    "Display Attribute icon in " .. F.String.Menu.Armory() .. " no matter which font is selected",
    "Disable icons in the changelog if font isn't " .. F.String.ToxiUI("'- ToxiUI'"),

    "* Profile updates",
    F.String.ElvUI() .. ": Update the Player's Power bar to match Target" .. F.String.Sublist("It is still disabled by default"),

    "* Documentation",
    F.String.MinElv("13.74"),

    "* Settings refactoring",
    "Move Talents frame scaling to Classic only",
    "Rename " .. F.String.Class("MiniMapCoords") .. " to " .. F.String.Class("Minimap Coordinates"),
  },
}
