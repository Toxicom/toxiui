local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.4.0"] = {
  HOTFIX = false,
  CHANGES = {
    "* Breaking changes",
    "Refactor "
      .. TXUI.Title
      .. " tags, so previous profiles will most likely be broken. See new tags in "
      .. F.String.Class("Available Tags")
      .. " - they are prefixed with "
      .. TXUI.Title,

    "* New features",
    "Enable features that were previously enabled only for contributors: " .. F.String.Legendary("Gradient Mode Saturation Boost") .. ", " .. F.String.Legendary(
      "WunderBar's RGB background"
    ) .. " and " .. F.String.Legendary("WunderBar Time module's resting animation"),
    "NameplateSCT " .. TXUI.Title .. " profile",
    "Changing images in installer dialog",
    "Custom ElvUI tag for power - same as before, but hides when power is 0",
    "Gradient UnitFrame text tags in Dark Mode. Credits to " .. F.String.RandomClassColor("Eltreum") .. " and " .. F.String.Class("ElvUI discord", "SHAMAN"),
    "Create separate profiles for OmniCD depending on " .. F.String.ToxiUI("DPS/Tank") .. " or " .. F.String.Class("Healer", "MONK") .. " layout selected",
    F.String.GradientString() .. F.String.Class(" class color") .. " font options for " .. TXUI.Title .. " Armory",
    "Details "
      .. F.String.GradientString()
      .. " texts, disabled by default. Enable in "
      .. F.String.FastGradientHex("Themes", "#73e8ff", "#0086c3")
      .. " -> |cffbdbdbdDark Mode|r -> "
      .. F.String.Class("Gradient name"),
    "Add new option to open " .. TXUI.Title .. " changelog by right-clicking WunderBar MicroMenu's " .. TXUI.Title .. " icon",

    "* Bug fixes",
    "Fix party leader icon in RDF dungeons",

    "* Profile updates",
    "Update Plater health text to match new unitframe style",
    F.String.Class("Class color") .. " for chat tabs",
    "Update " .. F.String.GradientString() .. " theme's Energy colors to match Luxthos WA",
    "Update " .. F.String.GradientString() .. " theme's Mana colors to match Luxthos WA",
    "Move Rest Icon to accomodate space for Party Leader icon",
    "Move Party Leader icon above unitframe name",
    "Use new " .. TXUI.Title .. " power tag",
    "Change ElvUI's value color to " .. F.String.Class("class color"),
    "Increase party frames vertical spacing",
    "Reduce unitframe buff/debuff font size",
    "Disable party indicator for player unitframe",
    "Reduce BigWigs messages font size",
    "Enable " .. F.String.Class("Dynamic Overall Damage") .. " for Details",
    "Enable " .. F.String.Class("Show 'Real Time' DPS") .. " for Details",
    "Enable Augmentation Evoker predictions and calculations for Details",

    "* Documentation",
    "Refactor old changelogs to follow new format",
    "Update changelog template to new format",

    "* Development improvements",
    "Custom install function to position installer buttons based on availability",
    "Refactor custom tags to use ElvUI functions",
  },
}
