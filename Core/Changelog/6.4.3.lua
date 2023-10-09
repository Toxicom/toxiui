local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.4.3"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    "Add new option to "
      .. F.String.ToxiUI("Additional Scaling")
      .. " module" -- comment to stop auto-formatting
      .. F.String.Sublist(F.String.Class("Talents Frame") .. " (Wrath & Classic only)"),
    "Add option to disable whole " .. F.String.ToxiUI("Additional Scaling") .. " module",

    "* Bug fixes",
    TXUI.Title .. ": Remove the need to force-load AddOns when adjusting scale through " .. F.String.ToxiUI("Additional Scaling"),
    TXUI.Title .. ": Remove the need to reload when adjusting scale through " .. F.String.ToxiUI("Additional Scaling"),

    "* Profile updates",

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
  },
}
