local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.3.1"] = {
  HOTFIX = true,
  CHANGES = {
    "* ToxiUI",
    F.String.Good("NEW: ") .. "WarpDeplete profile in the installer",
    F.String.Good("NEW: ") .. "OmniCD profile in the installer",
    F.String.Good("NEW: ") .. "Add an option to WunderBar's visibility - Resting & Mouseover",
    "Change default WunderBar's accent color to class color",
    "Disable VehicleBar by default",
    "* ElvUI",
    "Increase the padding between ActionBars",
    "Reduce buff/debuff font sizes",
    "Revert combat font to M900",
    "Fix debuff timer font",
    "Primary font for actionbars",
  },
}
