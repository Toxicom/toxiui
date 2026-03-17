local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.3.0"] = {
  HOTFIX = true,
  RELEASE_DATE = "Feb 16, 2026",
  CHANGES = {
    "* New features",
    "Add player-only tags for " .. F.String.ToxiUI("[tx:classicon]"),
    "Preview bars in " .. TXUI.Title .. " " .. F.String.GradientString() .. " mode settings",
    F.String.Retail() .. "Centered icons options for " .. F.String.CDM(),

    "* Enhancements",
    "Add disclaimer text to " .. TXUI.Title .. " Profile Updater",
    "Update default " --
      .. F.String.GradientString()
      .. " color for "
      .. F.String.Class("Priest", "PRIEST")
      .. F.String.Sublist("Old values:")
      .. F.String.Sublist("LEFT: " .. F.String.Color("#D1D1D1", "d1d1d1"))
      .. F.String.Sublist("RIGHT: " .. F.String.Color("#FFFFFF", "ffffff")),
    "Update default " --
      .. F.String.GradientString()
      .. " color for "
      .. F.String.Class("Demon Hunter", "DEMONHUNTER")
      .. F.String.Sublist("Old values:")
      .. F.String.Sublist("LEFT: " .. F.String.Color("#B3008A", "b3008a"))
      .. F.String.Sublist("RIGHT: " .. F.String.Color("#BA00F5", "ba00f5")),
    F.String.Retail() .. "Add " .. F.String.ToxiUI("Trader’s Gilded Brutosaur") .. " to " .. F.String.Menu.WunderBar() .. "'s Durability module",

    "* Profile updates",
    F.String.ElvUI() .. ": Disable additional powers for Druid",
    F.String.ElvUI() .. ": Use player-only class icon tag for Target UnitFrame",
  },
}
