local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.9.4"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",
    "Remove " .. F.String.Menu.Performance() .. " tab" .. F.String.Sublist("Blizzard locked the profiler CVar"),

    "* New features",
    "M+ Keystone displayed in Game Menu Skin" .. F.String.Sublist("Credits to Kryonyx"),
    "M+ Latest runs displayed in Game Menu Skin" .. F.String.Sublist("Credits to Kryonyx"),
    "M+ Score displayed in Game Menu Skin",

    "* Bug fixes",
    "Improve safety checks for F.Color.SetGradient",
    "Improve safety checks for F.Color.UpdateGradient",
    "Force close Flyout frame after loading screen",
    "Force close Flyout frame on slot click",

    "* Documentation",
    "Add Explosive Hearthstone to " .. F.String.Menu.WunderBar(),
    F.String.MinElv("13.90"),
    "Update for Retail 11.1.5",
    "Update for Classic Era 1.15.7",
    "Update for Classic 4.4.2",

    "* Settings refactoring",
    "Refactor Game Menu Skin settings" .. F.String.Sublist("It is still in the " .. F.String.Menu.Skins() .. " tab, but separate from the ElvUI tab"),
    "Refactor Action Bars Skin settings" .. F.String.Sublist("It is still in the " .. F.String.Menu.Skins() .. " tab, but separate from the ElvUI tab"),
    "Remove most NewSign icons" .. F.String.Sublist("The icon dictates what to display when clicking ElvUI's 'Whats New' button in the top-right"),
    "Update some descriptions to be more clear",
  },
}
