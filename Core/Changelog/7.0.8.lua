local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.0.8"] = {
  HOTFIX = true,
  CHANGES = {
    "* Bug fixes",
    "Fix " .. F.String.Menu.WunderBar() .. " MicroMenu error in non-retail versions",
  },
}
