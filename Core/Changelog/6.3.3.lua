local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.3.3"] = {
  HOTFIX = true,
  CHANGES = {
    "* New features",
    "Enable features that were previously enabled only for contributors: " .. F.String.Legendary("Gradient Mode Saturation Boost") .. ", " .. F.String.Legendary(
      "WunderBar's RGB background"
    ) .. " and " .. F.String.Legendary("WunderBar Time module's resting animation"),

    "* Profile updates",
    "Move leader icon for party & player",
    "Update Plater health text to match new unitframe style",

    "* Documentation",
    "Refactor old changelogs to follow new format",
  },
}
