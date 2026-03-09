local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["5.3.2"] = {
  HOTFIX = true,
  CHANGES = {
    "* Bug fixes",
    "WunderBar: Fix LUA error",
    "AFK: Fix LUA error",

    "* Profile updates",
    F.String.WindTools() .. ": Disable Blizzard and ElvUI Skins by default, since we provide our own",
    F.String.ElvUI() .. ": Enable transparent actionbars",
    F.String.ElvUI() .. ": Enable Parchment Remover",
    F.String.Menu.Armory() .. ": Increase the default alpha % for background",
  },
}
