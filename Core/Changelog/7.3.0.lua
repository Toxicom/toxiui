local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.3.0"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    "Add player-only tags for " .. F.String.ToxiUI("[tx:classicon]"),
    "Preview bars in " .. TXUI.Title .. " " .. F.String.GradientString() .. " mode settings",

    "* Enhancements",
    "Add disclaimer text to " .. TXUI.Title .. " Profile Updater",
    "Update default " .. F.String.GradientString() .. " color for Priest" .. F.String.Sublist("Old values:") .. F.String.Sublist("From: #d1d1d1") .. F.String.Sublist(
      "To: #ffffff"
    ),

    "* Bug fixes",

    "* Profile updates",

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
  },
}
