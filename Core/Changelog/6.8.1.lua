local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.8.1"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",

    "* Bug fixes",

    "* Profile updates",
    "Update Plater mods",

    "* Documentation",
    "Revert the 1600 height custom scale",
    "Update current season to " .. F.String.ToxiUI("tww1") .. F.String.Sublist("This affects the Hearthstone Seasonal M+ Portals list"),
    "Covenant hearthstones now have a prefix in the hearthstone select dropdown",

    "* Settings refactoring",

    "* Development improvements",
  },
}
