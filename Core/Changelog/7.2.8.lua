local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.2.8"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",
    "Remove " .. F.String.OmniCD(),

    "* New features",

    "* Enhancements",

    "* Bug fixes",

    "* Profile updates",
    F.String.ElvUI() .. ": Setup unitframe buff filters to match ElvUI defaults" .. F.String.Sublist(
      "You should already have these, this is in case people re-run the installer to reset them"
    ),
    F.String.ElvUI() .. ": Adjust Party unitframe buffs and debuffs position, sizing, texts",
    F.String.ElvUI() .. ": Adjust Raid (1, 2, 3) unitframe buffs and debuffs position, sizing, texts",
    F.String.ElvUI() .. ": Add custom names to Raid unitframes",

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
  },
}
