local TXUI, F, E, I, V, P, G = unpack(select(2, ...))

TXUI.Changelog["6.1.3"] = {
  HOTFIX = true,
  CHANGES = {
    "* ToxiUI",
    "Perhaps better handling for those very big UW screens.",
    "Add '" .. F.String.ToxiUI("Title Secondary") .. "' to Fonts module.",
    "Add descriptions to each font in the Fonts module.",
    "* ElvUI",
    "Move World Map coordinates to bottom right.",
    "Increase default options window size.",
    "Fix raid frames visibility.",
    "Change Raid frame's name font to '" .. F.String.ToxiUI("Title Secondary") .. "'.",
    "Reduce the max length of Raid frame's name string.",
    "* Plater",
    "Disable Target color on the M+ Colored Mobs mod.",
  },

  CHANGES_WRATH = {
    "Fixes for Wrath Ulduar patch API changes",
  },
}
