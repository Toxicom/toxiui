local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.1.3"] = {
  HOTFIX = true,
  CHANGES = {
    "* Profile updates",
    "Perhaps better handling for those very big UW screens.",
    "Move World Map coordinates to bottom right.",
    "Increase default options window size.",
    "Change Raid frame's name font to '" .. F.String.ToxiUI("Title Raid") .. "'.",
    "Reduce the max length of Raid frame's name string.",
    "Disable Target color on Plater's " .. F.String.ToxiUI("M+ Colored Mobs") .. " mod.",

    "* Bug fixes",
    "Fix raid frames visibility.",
    "Fixes for Wrath Ulduar patch API changes",

    "* Documentation",
    "Add '" .. F.String.ToxiUI("Title Raid") .. "' to Fonts module.",
    "Add descriptions to each font in the Fonts module.",
  },
}
