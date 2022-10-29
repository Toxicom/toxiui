local TXUI, F, E, I, V, P, G = unpack(select(2, ...))

TXUI.Changelog["6.0.1"] = {
  HOTFIX = true,
  DYNAMIC = function()
    if F.IsContributor() then return {
      F.String.Legendary("LEGENDARY: ") .. "Added Dragonflight's rested indicator to WunderBar's Time module",
    } end
  end,
  CHANGES = {
    "* General",
    " Font adjustments",
    " Fixed visibility states for Pet Action Bar & Stance Bar",

    "* Plater",
    " Enabled stacking of similar auras",
    " Updated mods & scripts",

    "* WunderBar",
    " General: Flyouts now show the tooltip of the hovered spell",
    " Hearthstone: Fix mage portal flyouts",
    " DataBar: Replace ElvUI experience tooltip with our own",
  },
}
