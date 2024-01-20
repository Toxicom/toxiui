local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.5.1"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",
    "Remove "
      .. TXUI.Title
      .. " Blizzard Fonts feature" --
      .. F.String.Sublist("This feature is now available in " .. F.String.ElvUI() .. " since version 13.48"),

    "* New features",
    "New " --
      .. F.String.FastGradientHex("Styles", "#ff26a8", "#a10355")
      .. " tab in "
      .. TXUI.Title
      .. " Settings"
      .. F.String.Sublist("Classic & WeakAuras ActionBars styles")
      .. F.String.Sublist("New & Old UnitFrames styles"),
    "Show ActionBars when Player is in Vehicle or DragonRiding" --
      .. F.String.Sublist("Currently in testing")
      .. F.String.Sublist("Priest Mind Control does not work yet"),
    "Smart Power tag for to display mana in full value" --
      .. F.String.Sublist("Enabled on Classic ActionBars style layout"),
    "Add new options to " --
      .. F.String.Scaling()
      .. ":"
      .. F.String.Sublist("Vendor (Merchant) Frame")
      .. F.String.Sublist("Gossip Frame")
      .. F.String.Sublist("Mailbox Frame")
      .. F.String.Sublist("Profession Frame (Classic Era & Wrath only)")
      .. F.String.Sublist("Class Trainer Frame (Classic Era & Wrath only)")
      .. F.String.Sublist("Quest Frame"),

    "* Bug fixes",
    "Fix bug with user having Shadow & Light installed previously",

    "* Profile updates",
    "Update WunderBar's default shown currencies for Dragonflight",
    "Update Totem bar for Wrath:" .. F.String.Sublist("Move it above ActionBar 1") .. F.String.Sublist("Apply 4:3 ratio sizing"),
    "Enable Target UnitFrame Range Fader for Healer layout",
    "Improve Healer layout's Party frames" --
      .. F.String.Sublist("Move Level text down")
      .. F.String.Sublist("Disable Class Icon"),
    "Add Hearthstone of the Flame to WunderBar's Hearthstone Module",
    "Update Armory's Item Level coloring for 10.2",

    "* Documentation",
    "Increase minimum required " .. F.String.ElvUI() .. " version to 13.53",
    "Update TOC for Season of Discovery",
    "Rename all cases of 'Action Bars' to 'ActionBars' to be more in-line with " .. F.String.ElvUI() .. " naming convention",
    "Add " .. F.String.Eltreum() .. " to credits section",

    "* Settings refactoring",
    "Move " --
      .. F.String.FastGradientHex("Miscellaneous", "#b085f5", "#4d2c91")
      .. " -> "
      .. F.String.Class("Others")
      .. " to "
      .. F.String.FastGradientHex("Skins", "#ff77a9", "#b4004e")
      .. " -> "
      .. F.String.Class("ElvUI"),

    "* Development improvements",
    "Refactor " .. TXUI.Title .. " Installer's pagination to be more future-proof and easier to change/control",
  },
}
