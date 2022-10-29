local TXUI, F, E, I, V, P, G = unpack(select(2, ...))

TXUI.Changelog["6.0.0"] = {
  HOTFIX = false,
  CHANGES = {
    "* General",
    " New Material design icons",
    " Pixel Perfect scaling on all resolutions, all elements/fonts scale automatically",
    " Change outgoing damage font",
    " Move Player's Cast Bar under the Player UnitFrame",
    " Improved performance for Gradient themes and Details Skins",
    " Enable Power fader for player UF",
    " Adjust all ElvUI anchors for a cleaner layout",
    " Improved UI responsiveness when changing " .. TXUI.Title .. " settings",
    " Changed default font and various font sizes",

    "* WeakAuras",
    " Fix Action Glow being below the border when " .. TXUI.Title .. " WeakAuras Skin is used",
    " Fix rare WeakAuras bug due to WA API change",

    "* WunderBar",
    " General: Option to always disable tooltips and hover animations",
    " General: Performance improvements for Durability, SpecSwitch and Professions modules",
    " Hearthstone: Add missing teleports for Orgrimmar and Stormwind",
    " Professions & Hearthstone: New animated flyout",
  },

  CHANGES_RETAIL = {
    " WunderBar: Covenant Hearthstones are now chosen dynamically, just in time for Dragonflight!",
  },

  CHANGES_WRATH = {
    " First Release, please report all bugs in " .. F.String.Good("Discord's #forum channel"),
    " Deconstruct & Armory: Not available currently",
    " Known Issue: DataBar tooltip currently broken in " .. F.String.ElvUI("ElvUI"),
  },
}
