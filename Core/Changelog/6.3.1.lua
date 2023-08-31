local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.3.1"] = {
  HOTFIX = true,
  CHANGES = {
    "* ToxiUI",
    F.String.Good("NEW: ") .. "WarpDeplete profile in the installer",
    F.String.Good("NEW: ") .. "OmniCD profile in the installer",
    F.String.Good("NEW: ") .. "Add an option to WunderBar's visibility - Resting & Mouseover",
    F.String.Good("NEW: ")
      .. "Additional Scaling feature! "
      .. TXUI.Title
      .. " Settings -> "
      .. F.String.FastGradientHex("Miscellaneous", "#b085f5", "#4d2c91")
      .. " -> "
      .. F.String.Class("Other"),
    "Change default WunderBar's accent color to class color",
    "Disable VehicleBar by default",
    "* ElvUI",
    F.String.Good("NEW: ") .. "Class colored indicators for cooldown text. Credits to " .. F.String.Color("Nalar", "561c75"),
    "Increase the padding between ActionBars",
    "Reduce buff/debuff font sizes",
    "Fix UnitFrame buff/debuff font & font size",
    "Revert combat font to M900",
    "Fix debuff timer font",
    "Primary font for actionbars",
    "Increase buttons per row for minimap bar",
    "* Details",
    "Fix details missing fonts",
  },

  CHANGES_WRATH = {
    F.String.Good("NEW: ") .. F.String.WrathArmory() .. " settings will be applied on core install",
    "Add link to " .. F.String.WrathArmory() .. " in " .. TXUI.Title .. " Armory settings",
    "Fix Specialization icons for Assassination Rogue and Holy Priest",
  },
}
