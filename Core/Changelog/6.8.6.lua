local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.8.6"] = {
  HOTFIX = true,
  CHANGES = {
    "* Bug fixes",
    "Fix Dark Mode",

    "* Documentation",
    "Remove some addons from debug mode" .. F.String.Sublist(TXUI.Title .. " did not interact with those addons directly, so the less clutter during debugging the better"),
  },
}
