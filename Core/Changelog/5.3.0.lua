local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["5.3.0"] = {
  CHANGES = {
    "* New features",
    "Custom Theme for " .. F.String.ElvUI("ElvUI") .. F.String.Error("[BETA]"),
    F.String.Menu.Armory() .. ": Option to abbreviate enchant strings",
    F.String.Menu.Armory() .. ": Option to change colors",
    F.String.Menu.Armory() .. ": Options to position Header text",
    "VehicleBar: Added mover anchor",
    "Icon Skin: Option to change the shape for WeakAuras",
    "Time: Format options added",
    "MicroMenu: Retail-only filter for Social button",

    "* Bug fixes",
    "WunderBar now auto-hides during Pet Battles",

    "* Profile updates",
    F.String.WindTools() .. ": Enabled Raid Marker bar",
    "Plater: Cast Bar colors for Interrupt",
  },
}
