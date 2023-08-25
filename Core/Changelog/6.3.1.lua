local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.3.1"] = {
  HOTFIX = true,
  CHANGES = {
    "* ToxiUI",
    F.String.Good("NEW: ") .. "WarpDeplete profile in the installer",
    F.String.Good("NEW: ") .. "OmniCD profile in the installer",
    F.String.Good("NEW: ") .. "Add an option to WunderBar's visibility - Resting & Mouseover",
    "* ElvUI",
    "Increase the padding between ActionBars",
    "Reduce buff/debuff font sizes",
    "Revert combat font to M900",
  },
}
