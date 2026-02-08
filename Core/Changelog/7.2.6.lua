local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.2.6"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    F.String.Menu.Performance() .. " tab in " .. TXUI.Title .. " settings",

    "* Enhancements",
    F.String.Retail() .. "Display percentage mana for " .. F.String.Class("Arcane Mages", "MAGE") .. " with the " .. F.String.ToxiUI("[tx:power]") .. " tag",
    "Try displaying class icon when spec icon is not available for both " .. F.String.ToxiUI("[tx:classicon]") .. " tags" .. F.String.Sublist(
      "This is most noticeable in follower dungeons"
    ),

    "* Bug fixes",

    "* Profile updates",

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
  },
}
