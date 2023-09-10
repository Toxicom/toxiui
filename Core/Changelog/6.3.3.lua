local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.3.3"] = {
  HOTFIX = true,
  CHANGES = {
    "* New features",
    "Enable features that were previously enabled only for contributors: " .. F.String.Legendary("Gradient Mode Saturation Boost") .. ", " .. F.String.Legendary(
      "WunderBar's RGB background"
    ) .. " and " .. F.String.Legendary("WunderBar Time module's resting animation"),

    "* Profile updates",
    "Update Plater health text to match new unitframe style",
    "Class color for currently selected chat tab",
    "Update Gradient theme's Energy colors to match Luxthos WA",
    "Update Gradient theme's Mana colors to match Luxthos WA",
    "Move Rest Icon to accomodate space for Party Leader icon",
    "Move Party Leader icon above unitframe name",

    "* Documentation",
    "Refactor old changelogs to follow new format",
    "Update changelog template to new format",
  },
}
