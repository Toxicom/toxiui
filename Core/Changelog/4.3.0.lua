local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["4.3.0"] = {
  CHANGES = {
    "* New features",
    "Added another button to the WeakAuras section of installer to remind you to get Skin All Icons WeakAuras",
    "Disabled Plater pop-up showing up during installation",
    "Added option to toggle XIV gradient fade",

    "* Bug fixes",
    "Healer layout",
    "Chat font size fixed",
    "BigWigs no longer overwrites your Statistics",

    "* Profile updates",
    "Changed the coloring of ToxiUI to reflect the logo",
    "Misc. coloring changes throughout the whole ToxiUI AddOn",
    "General font size 14 -> 15",
    "Tooltip font size 13 -> 14",
    "Tooltip health font changed",
    "Minimap button bar now shows 2 buttons per row to avoid overlap with Raid Markers",
    "Changed item level font in " .. F.String.Menu.Armory(),
    "Disabled target castbar icon",
    "Update Objective Tracker" --
      .. F.String.Sublist("Header font size reduced to 22")
      .. F.String.Sublist("Title font size reduced to 17")
      .. F.String.Sublist("Info font size reduced to 15")
      .. F.String.Sublist("Removed outline from title"),
    "Changed BigWigs DPS layout",
    "Changed DBM DPS layout",
    "Gap between Details windows",
    "Auto-hide Details title buttons",
    "Misc. Details changes",

    "* Settings refactoring",
    "Fixed spelling mistakes",
  },
}
