local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.1.2"] = {
  HOTFIX = true,
  CHANGES = {
    "* New features",
    "Evoker spec icons. Credits to " .. F.String.WunderUI(),
    F.String.Menu.Armory() .. ": Socket warning for neck slot. Credits to " .. F.String.Epic("Ryada"),

    "* Bug fixes",
    "Fix Gradient Mode's Dead unit color",
    F.String.Menu.Armory() .. ": Update enchant slots for Dragonflight",
    "VehicleBar: Fix taint that would happen during combat while mounting. Credits to " .. F.String.Epic("Ryada"),

    "* Profile updates",
    "WunderBar: Add Valdrakken & Tol Barad portals for mages",
    "WunderBar: Change default background",
    "Movers: Move the Dragon Riding Vigor bar to the bottom",
    "Minimap: Hide tracking icon",
    "Minimap: Increase size of LFG eye",
    "Reposition and update the Focus frame",
    "Update Plater's " .. F.String.ToxiUI("Interrupt cast color") .. " mod",
    "Update Plater's " .. F.String.ToxiUI("M+ colored mobs") .. " mod",
  },
}
