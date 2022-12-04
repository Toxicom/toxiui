local TXUI, F, E, I, V, P, G = unpack(select(2, ...))

TXUI.Changelog["6.1.2"] = {
  HOTFIX = true,
  CHANGES = {
    "* ToxiUI",
    "Fix Gradient Mode's Dead unit color",
    F.String.Good .. "New: " .. "Evoker spec icons. Credits to " .. F.String.Class("Nawuko", "MONK"),
    "WunderBar: Add Valdrakken & Tol Barad portals for mages",
    "WunderBar: Change default background",

    "* ElvUI",
    "Movers: Move the Dragon Riding Vigor bar to the bottom",
    "Minimap: Hide tracking icon",
    "Minimap: Increase size of LFG eye",

    "* Plater",
    "Update interrupt cast color mod",
  },
}
