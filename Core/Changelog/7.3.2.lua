local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.3.2"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",

    "* Enhancements",

    "* Bug fixes",
    F.String.Retail() .. "Skip anchoring and centering for the " .. F.String.CDM() .. " if a viewer's orientation is vertical",

    "* Profile updates",
    F.String.ElvUI() .. ": Nudge raid frames to the left" .. F.String.Sublist(
      "Now that they're bigger due to the requirement to fit buffs and debuffs inside of it, have to save space"
    ),

    "* Documentation",

    "* Settings refactoring",
    F.String.Retail() .. "Add notes to the " .. F.String.CDM() .. " for horizontal orientation",
    "Sort " .. F.String.GradientString() .. " mode's classes in settings",

    "* Development improvements",
  },
}
