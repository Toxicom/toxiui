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
    "Show ActionBars when Player is in Vehicle or DragonRiding" --
      .. F.String.Sublist("Currently in testing")
      .. F.String.Sublist("Priest Mind Control does not work yet"),
    F.String.ToxiUI("Classic Era") .. " only Profile with visible ActionBars",
    "Smart Power tag for Classic to display mana in full value",

    "* Bug fixes",

    "* Profile updates",
    "Update WunderBar's default shown currencies for Dragonflight",
    "Update Totem bar for Wrath:" .. F.String.Sublist("Move it above ActionBar 1") .. F.String.Sublist("Apply 4:3 ratio sizing"),

    "* Documentation",
    "Increase minimum required " .. F.String.ElvUI() .. " version to 13.53",
    "Update TOC for Season of Discovery",

    "* Settings refactoring",

    "* Development improvements",
  },
}
