local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["5.3.2"] = {
  HOTFIX = true,
  CHANGES = {
    "* General",
    F.String.ElvUI(" WindTools") .. ": Disable Blizzard and ElvUI Skins by default, since we provide our own",
    F.String.ElvUI(" ElvUI") .. ": Enable transparent actionbars",
    F.String.ElvUI(" ElvUI") .. ": Enable Parchment Remover",
    " Armory: Increase the default alpha % for background",
    " WunderBar: Fix LUA error",
    " AFK: Fix LUA error",
  },
}
