local TXUI, F, E, I, V, P, G = unpack(select(2, ...))

TXUI.Changelog["6.2.0"] = {
  HOTFIX = true,
  CHANGES = {
    "* ToxiUI",
    "Fix scaling at 5k resolution. Credits to " .. F.String.Class("Nikipe", "MAGE"),
    "Armory: Update API variable used for weapon item class. Credits to " .. F.String.Beta("Stiimo"),
    "WunderBar: Fix DataText's tooltips by creating virtual frames. Credits to " .. F.String.Beta("Stiimo") .. " & " .. F.String.Class("ElvUI WindTools", "SHAMAN"),
    "Misc: Add IconTexture to the AddOns window",
    "Misc: Update for patch 10.1",
  },
}
