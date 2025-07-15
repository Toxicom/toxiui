local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.9.8"] = {
  HOTFIX = true,
  CHANGES = {
    "* Bug fixes",
    "Fix the '" .. TXUI.Title .. " White' Role Icons throwing an error",
    "Hide " .. F.String.Menu.WunderBar() .. " in Pet Battles for Mists of Pandaria Classic",
  },
}
