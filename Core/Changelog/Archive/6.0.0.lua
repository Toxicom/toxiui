local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.0.0"] = {
  HOTFIX = false,
  CHANGES = {
    "* Breaking changes",
    "Changed default font and various font sizes",

    "* New features",
    "New Material design icons",
    "Pixel Perfect scaling on all resolutions, all elements/fonts scale automatically",
    "WunderBar Option to always disable tooltips and hover animations",
    "Professions & Hearthstone: New animated flyout",
    "WunderBar: Covenant Hearthstones are now chosen dynamically, just in time for Dragonflight!",
    "First Wrath Release, please report all bugs in "
      .. F.String.Good("GitHub") --
      .. F.String.Sublist("Deconstruct & " .. F.String.Menu.Armory() .. ": Not available currently")
      .. F.String.Sublist("Known Issue: DataBar tooltip currently broken in " .. F.String.ElvUI("ElvUI")),

    "* Bug fixes",
    "Fix Action Glow being below the border when " .. TXUI.Title .. "WeakAuras Skin is used",
    "Fix rare WeakAuras bug due to WA API change",

    "* Profile updates",
    "Change outgoing damage font",
    "Move Player's Cast Bar under the Player UnitFrame",
    "Enable Power fader for player UF",
    "Adjust all ElvUI anchors for a cleaner layout",

    "* Documentation",
    "Add missing teleports for Orgrimmar and Stormwind",

    "* Development improvements",
    "Improved performance for Gradient themes and Details Skins",
    "Improved UI responsiveness when changing " .. TXUI.Title .. "settings",
    "WunderBar Performance improvements for Durability, SpecSwitch and Professions modules",
  },
}
