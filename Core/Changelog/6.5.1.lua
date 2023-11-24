local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.5.1"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    "Show ActionBars when Player is in Vehicle or DragonRiding" --
      .. F.String.Sublist("Currently in testing")
      .. F.String.Sublist("Priest Mind Control does not work yet"),

    "* Bug fixes",

    "* Profile updates",
    "Update WunderBar's default shown currencies for Dragonflight",
    "Update Totem bar for Wrath:" .. F.String.Sublist("Move it above ActionBar 1") .. F.String.Sublist("Apply 4:3 ratio sizing"),

    "* Documentation",
    "Increase minimum required " .. F.String.ElvUI() .. " version to 13.52",

    "* Settings refactoring",

    "* Development improvements",
  },
}
