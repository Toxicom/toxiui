local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.4.3"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    "Add new option to "
      .. F.String.ToxiUI("Additional Scaling")
      .. " module" -- comment to stop auto-formatting
      .. F.String.Sublist(F.String.Class("Talents Window") .. " (Wrath & Classic only)"),

    "* Bug fixes",
    TXUI.Title .. ": Removed the need to forceload addons when adjusting scale through " .. F.String.ToxiUI("Additional Scaling"),
    TXUI.Title .. ": Removed the need to reload when adjusting scale through " .. F.String.ToxiUI("Additional Scaling"),

    "* Profile updates",
    TXUI.Title .. ": " .. F.String.ToxiUI("WunderBar") .. " > Add the DataBar (EXP and Rep bar) to be enabled in the base profile",

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
  },
}
