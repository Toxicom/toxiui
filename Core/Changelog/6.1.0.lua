local TXUI, F, E, I, V, P, G = unpack(select(2, ...))

TXUI.Changelog["6.1.0"] = {
  HOTFIX = false,
  DYNAMIC = function()
    if F.IsContributor() then
      return {
        F.String.Legendary("LEGENDARY: ") .. "Saturation Boost feature for Gradient Mode",
        F.String.Legendary("LEGENDARY: ") .. "Re-designed the chat badges. Colors now match supporter tier",
        F.String.Legendary("LEGENDARY: ") .. "Epic Supporters now have their own unique badge, no longer shared with Rare tier",
      }
    end
  end,
  CHANGES = {
    "* ToxiUI",
    F.String.Good("New: ") .. "Refactored whole options window",
    F.String.Good("New: ") .. "Font changing feature " .. F.String.Error("[EXPERIMENTAL]"),
    "Gradient Mode rewritten, better performance",
    "Lots of fixes for Dragonflight " .. F.String.Error("[Please report bugs on GitHub or Discord!]"),

    "* ElvUI",
    "Movers: Move tooltip to accomodate space for new Details",
    "Tooltip: Change health bar height",

    "* Details",
    F.String.Good("New: ") .. "Skin with icons, in collaboration with Redtuzk" .. F.String.Error("UI"),

    "* Boss Mods",
    "BigWigs: Update to match Details",
    "DBM: Update to match Details " .. F.String.Error("(Deprecating DBM soon)"),
  },

  CHANGES_WRATH = {
    "Installer: Fixed BigWigs profiles",
  },
}
