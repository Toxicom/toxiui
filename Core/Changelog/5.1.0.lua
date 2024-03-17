local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["5.1.0"] = {
  CHANGES = {
    "* New features",
    "|cffff0000[BETA]|r Support for LDB a.k.a LibDataBroker",
    "SpecSwitch: Now has more options to display specs in different ways",
    "Currency: Old Gold module with more options and the ability to display currencies",
    "Durability: Now has an option to show ItemLevel next to durability (and inside the Tooltip)",
    "Hearthstone: Now cycles between cooldowns if more than 1 hearthstone is on cooldown",
    "Hearthstone: Allow showing additional cooldowns in the Tooltip via Options",
    "MicroMenu: Allow displaying Blizzard MicroMenu Tooltips; Button names are now localized",
    "Time: Allows you to cycle information in an additional info text",
    "Volume: New module in the style of XIV, replaces ElvUI Volume",
    "DataBar: New module in the style of XIV for Experience and Reputation",
    "Support for custom background textures",
    "Proper support for cyrillic characters",
    "Reset Button in Options, also added '/tx reset' command",
    "Added a Status Dialog accessed by '/tx status'",

    "* Bug fixes",
    "MicroMenu: Some buttons are now accessible during combat",
    "Durability: Reworked tooltip to prevent ElvUI error",
    "2 Lua fixes for WB",
    "Fixed WA Icon Skin issue with Transparent Icons",
    "WunderBar now activates on other Characters when the same Profile is used",

    "* Profile updates",
    "Black dead backdrop",
    "Red dead backdrop for Dark Mode",
    "Moved the Lady Inerva widget",
    "Separate Transparent backdrop module for Dark Mode",

    "* Settings refactoring",
    "Updated Installer dialog",
  },
}
