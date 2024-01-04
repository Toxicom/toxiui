local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.5.2"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    "Add option to toggle the ActionBars Fade visibility when in a Vehicle or DragonRiding"
      .. F.String.Sublist(F.String.FastGradientHex("Skins", "#ff77a9", "#b4004e") .. " -> " .. F.String.Class("ElvUI") .. " -> " .. F.String.Class("ActionBars Fade", "ROGUE")),
    "Add Right Click option to WunderBar's " --
      .. F.String.ToxiUI("Durability Module")
      .. " to summon "
      .. F.String.Class("Grand Expedition Yak")
      .. F.String.Sublist("Retail only")
      .. F.String.Sublist("Must have the mount learned"),

    "* Bug fixes",

    "* Profile updates",
    "Apply ToxiUI fonts to Guild Bank",

    "* Documentation",
    "Increase minimum required " .. F.String.ElvUI() .. " version to 13.54",

    "* Settings refactoring",
    "Update WeakAuras Style description to correctly direct users to new location of ActionBars Fade",

    "* Development improvements",
  },
}
