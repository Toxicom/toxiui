local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.5.2"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    "Add option to toggle the ActionBars Fade visibility when in a Vehicle or DragonRiding"
      .. F.String.Sublist(F.String.FastGradientHex("Skins", "#ff77a9", "#b4004e") .. " -> " .. F.String.Class("ElvUI") .. " -> " .. F.String.Class("ActionBars Fade", "ROGUE")),

    "* Bug fixes",

    "* Profile updates",

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
  },
}
