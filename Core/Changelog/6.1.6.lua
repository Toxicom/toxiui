local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.1.6"] = {
  HOTFIX = true,
  CHANGES = {
    "* Bug fixes",
    "Details: Fix 'Deaths' window LUA error (still needs a fix for class icons). Credits to " .. F.String.Class("shrift", "DEATHKNIGHT"),

    "* Development improvements",
    "Installer: Change installer so it's more in line with other plugins",
  },
}
