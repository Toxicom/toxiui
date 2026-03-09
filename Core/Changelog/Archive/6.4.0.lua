local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.4.0"] = {
  HOTFIX = false,
  CHANGES = {
    "* Breaking changes",
    "Refactor " .. TXUI.Title .. " tags, so previous profiles will most likely be broken." .. F.String.Sublist(
      "See new tags in " .. F.String.Class("Available Tags") .. ", they are prefixed with " .. TXUI.Title
    ),

    "* New features",
    "Enable features that were previously enabled only for contributors:"
      .. F.String.Sublist(F.String.Legendary("Gradient Mode Saturation Boost")) -- comment to stop auto-formatting
      .. F.String.Sublist(F.String.Legendary("WunderBar's RGB background")) -- comment to stop auto-formatting
      .. F.String.Sublist(F.String.Legendary("WunderBar Time module's resting animation")),
    F.String.NameplateSCT() .. " " .. TXUI.Title .. " profile",
    "Changing images in installer dialog" .. F.String.Sublist("Example in Additional Addons step of installer"),
    "Custom ElvUI tag for power" .. F.String.Sublist("Same as before, but hides when power is 0"),
    "Create separate profiles for " .. F.String.OmniCD() .. " depending on " .. F.String.ToxiUI("DPS/Tank") .. " or " .. F.String.Class("Healer", "MONK") .. " layout selected",
    F.String.GradientString() .. F.String.Class(" class color") .. " font options for " .. TXUI.Title .. " " .. F.String.Menu.Armory(),
    F.String.GradientString() .. " UnitFrame text tags in Dark Mode" .. F.String.Sublist("Credits to " .. F.String.Eltreum() .. " and " .. F.String.ElvUI("ElvUI discord")),
    F.String.GradientString() .. " Details texts in Dark Mode" .. F.String.Sublist("Disabled by default") .. F.String.Sublist(
      "Enable in " .. F.String.Menu.Themes() .. " -> Dark Mode -> " .. F.String.Class("Gradient name")
    ),
    "Add new option to open " .. TXUI.Title .. " changelog by right-clicking WunderBar MicroMenu's " .. TXUI.Title .. " icon",

    "* Bug fixes",
    TXUI.Title .. ": Fix party leader icon in RDF dungeons",

    "* Profile updates",
    F.String.Plater() .. ": Update health text to match new unitframe style",
    TXUI.Title .. ": Update " .. F.String.GradientString() .. " theme's Energy colors to match Luxthos WA",
    TXUI.Title .. ": Update " .. F.String.GradientString() .. " theme's Mana colors to match Luxthos WA",
    F.String.ElvUI("ElvUI: ") .. F.String.Class("Class color") .. " for chat tabs",
    F.String.ElvUI() .. ": Move Rest Icon to accomodate space for Party Leader icon",
    F.String.ElvUI() .. ": Move Party Leader icon above unitframe name",
    F.String.ElvUI() .. ": Use new " .. TXUI.Title .. " power tag",
    F.String.ElvUI() .. ": Change value color to " .. F.String.Class("class color"),
    F.String.ElvUI() .. ": Increase party frames vertical spacing",
    F.String.ElvUI() .. ": Reduce unitframe buff/debuff font size",
    F.String.ElvUI() .. ": Disable party indicator for player unitframe",
    F.String.BigWigs() .. ": Reduce messages font size",
    F.String.Details() .. ": Enable " .. F.String.Class("Dynamic Overall Damage"),
    F.String.Details() .. ": Enable " .. F.String.Class("Show 'Real Time' DPS"),
    F.String.Details() .. ": Enable Augmentation Evoker predictions and calculations",

    "* Documentation",
    "Refactor old changelogs to follow new format",
    "Update changelog template to new format",

    "* Development improvements",
    "Custom install function to position installer buttons based on availability",
    "Refactor custom tags to use ElvUI functions",
  },
}
