local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["5.3.3"] = {
  HOTFIX = true,
  CHANGES = {
    "* Profile updates",
    F.String.ElvUI("ElvUI") .. ": Fix Target buffs growth direction",
  },
}
