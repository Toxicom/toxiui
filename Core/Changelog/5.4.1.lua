local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["5.4.1"] = {
  HOTFIX = true,
  CHANGES = {
    "* Bug fixes",
    " Fix " .. F.String.WindTools() .. " LUA error during installer",
  },
}
