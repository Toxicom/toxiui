local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.4.2"] = {
  HOTFIX = true,
  RELEASE_DATE = "",
  CHANGES = {
    "* Breaking changes",

    "* New features",
    "Add option to switch between vertical and horizontal layouts in the profile updater",

    "* Enhancements",
    F.String.Retail() .. F.String.Menu.WunderBar() .. " Hearthstone: Remove restrictions around Covenant hearthstones" .. F.String.Sublist(
      "They can be used regardless of which covenant your character is in"
    ),

    "* Bug fixes",
    "Remove duplicate nameplate object in fonts config",

    "* Profile updates",
    F.String.ElvUI() .. " Unitframes: Update horizontal party unitframes",

    "* Documentation",

    "* Settings refactoring",
    "Update Vertical and Horizontal layout images in the installer",

    "* Development improvements",
  },
}
