local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.1.0"] = {
  HOTFIX = false,
  CHANGES = {
    "* New features",
    "Font changing feature " .. F.String.Error("[EXPERIMENTAL]"),
    "New Details skin with icons, in collaboration with Redtuzk" .. F.String.Error("UI"),
    F.String.Legendary("LEGENDARY: ") .. "Saturation Boost feature for Gradient Mode",
    F.String.Legendary("LEGENDARY: ") .. "Re-designed the chat badges. Colors now match supporter tier",
    F.String.Legendary("LEGENDARY: ") .. "Epic Supporters now have their own unique badge, no longer shared with Rare tier",

    "* Bug fixes",
    "Lots of fixes for Dragonflight " .. F.String.Error("[Please report bugs on GitHub or Discord!]"),
    "Installer: Fixed BigWigs profiles for " .. F.String.ToxiUI("Wrath"),

    "* Profile updates",
    "Movers: Move tooltip to accomodate space for new Details",
    "Tooltip: Change health bar height",
    "BigWigs: Update to match Details",
    "DBM: Update to match Details " .. F.String.Error("(Deprecating DBM soon)"),

    "* Settings refactoring",
    "Refactored whole options window",

    "* Development improvements",
    "Gradient Mode rewritten, better performance",
  },
}
