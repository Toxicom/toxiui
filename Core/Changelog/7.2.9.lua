local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.2.9"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    TXUI.Title .. " Profile Updater" .. F.String.Sublist("/tx update; /tx u"),

    "* Enhancements",
    F.String.Retail() .. "Decouple Damage Meter Skin from " .. F.String.ElvUI() .. F.String.Sublist(
      "You can now enjoy default blizzard damage meter with ToxiUI icons and gradients"
    ),
    F.String.Retail() .. "Disable " .. F.String.CDM() .. " if ArcUI is enabled",

    "* Bug fixes",
    F.String.Retail() .. "Fix disappearing gradients in dungeons for Damage Meter Skin",

    "* Profile updates",
    F.String.ElvUI() .. ": Enable environment conditions for Nameplates",
    F.String.Retail() .. F.String.WindTools() .. ": Enable Objective Tracker skin",

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
  },
}
