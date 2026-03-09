local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.0.1"] = {
  HOTFIX = true,
  CHANGES = {
    "* New features",
    "WunderBar Flyouts now show the tooltip of the hovered spell",
    "Replace ElvUI experience tooltip with our own on WunderBar's DataBar module",
    F.String.Legendary("LEGENDARY: ") .. "Added Dragonflight's rested indicator to WunderBar's Time module",

    "* Bug fixes",
    "Fixed visibility states for Pet Action Bar & Stance Bar",
    "Fix mage portal flyouts for WunderBar's Hearthstone module",

    "* Profile updates",
    "Font adjustments",
    "Enabled stacking of similar auras for Plater",
    "Updated mods & scripts for Plater",
  },
}
