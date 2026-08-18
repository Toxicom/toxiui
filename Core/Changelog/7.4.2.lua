local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.4.2"] = {
  HOTFIX = true,
  RELEASE_DATE = "Apr 07, 2026",
  CHANGES = {
    "* New features",
    "Add option to switch between vertical and horizontal layouts in the profile updater",

    "* Enhancements",
    F.String.Retail() .. F.String.Menu.WunderBar() .. " Hearthstone: Remove restrictions around Covenant hearthstones" .. F.String.Sublist(
      "They can be used regardless of which covenant your character is in"
    ),
    F.String.Retail() .. F.String.CDM() .. ": Dynamic class bar width now also adjusts spacing value",

    "* Bug fixes",
    "Remove duplicate nameplate object in fonts config",
    F.String.Retail() .. "Add Skyreach as current season portal" .. F.String.Sublist("For some reason there are 2 skyreach portals"),

    "* Profile updates",
    F.String.ElvUI() .. " Unitframes: Update horizontal party unitframes",
    F.String.ElvUI() .. " Unitframes: Set player class bar to spaced with spacing of 2",
    F.String.ElvUI() .. " Nameplates: Enable 'Skip Good Color' so that classification colors do not get overriden" .. F.String.Sublist("Requires " .. F.String.ElvUI() .. " 15.11"),

    "* Documentation",
    F.String.Retail() .. F.String.Menu.WunderBar() .. " Hearthstone: Add Preyseeker's, Corewarden's, and Lightcalled hearthstones",
    F.String.Retail() .. F.String.Menu.WunderBar() .. " Hearthstone: Rename M+ portal labels to match Raider.IO",
    F.String.MinElv("15.11"),

    "* Settings refactoring",
    "Update Vertical and Horizontal layout images in the installer",
    F.String.Menu.WunderBar() .. " Hearthstone: Re-organize module settings",
  },
}
