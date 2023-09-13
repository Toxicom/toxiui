local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.3.3"] = {
  HOTFIX = true,
  CHANGES = {
    "* New features",
    "Enable features that were previously enabled only for contributors: " .. F.String.Legendary("Gradient Mode Saturation Boost") .. ", " .. F.String.Legendary(
      "WunderBar's RGB background"
    ) .. " and " .. F.String.Legendary("WunderBar Time module's resting animation"),
    "NameplateSCT " .. TXUI.Title .. " profile",
    "Changing images in installer dialog",
    "Custom ElvUI tag for power - same as before, but hides when power is 0",
    "Gradient UnitFrame text tags in Dark Mode. Credits to " .. F.String.RandomClassColor("Eltreum") .. " and " .. F.String.Class("ElvUI discord", "SHAMAN"),

    "* Profile updates",
    "Update Plater health text to match new unitframe style",
    "Class color for currently selected chat tab",
    "Update Gradient theme's Energy colors to match Luxthos WA",
    "Update Gradient theme's Mana colors to match Luxthos WA",
    "Move Rest Icon to accomodate space for Party Leader icon",
    "Move Party Leader icon above unitframe name",
    "Use new " .. TXUI.Title .. " power tag",
    "Change ElvUI's value color to " .. F.String.Class("class color"),
    "Increase party frames vertical spacing",
    "Reduce unitframe buff/debuff font size",

    "* Documentation",
    "Refactor old changelogs to follow new format",
    "Update changelog template to new format",

    "* Development improvements",
    "Custom install function to position installer buttons based on availability",
    "Refactor custom tags to use ElvUI functions",
  },
}
