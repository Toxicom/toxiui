local TXUI, F, E, I, V, P, G = unpack(select(2, ...))

TXUI.Changelog["6.1.2"] = {
  HOTFIX = true,
  CHANGES = {
    "* ToxiUI",
    "Fix Gradient Mode's Dead unit color",
    F.String.Good("NEW: ") .. "Evoker spec icons. Credits to " .. F.String.Class("Nawuko", "MONK"),
    "WunderBar: Add Valdrakken & Tol Barad portals for mages",
    "WunderBar: Change default background",
    "Armory: Update enchant slots for Dragonflight",
    F.String.Good("NEW: ") .. "Armory: Socket warning for neck slot. Credits to " .. F.String.Epic("Ryada"),
    "VehicleBar: Fix taint that would happen during combat while mounting. Credits to " .. F.String.Epic("Ryada"),

    "* ElvUI",
    "Movers: Move the Dragon Riding Vigor bar to the bottom",
    "Minimap: Hide tracking icon",
    "Minimap: Increase size of LFG eye",
    "Reposition and update the Focus frame",

    "* Plater",
    "Update interrupt cast color mod",
    "Update M+ colored mobs mod",
  },
}
