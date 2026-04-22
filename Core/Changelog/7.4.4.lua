local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.4.4"] = {
  HOTFIX = true,
  RELEASE_DATE = "Mon TBD, 2026",
  CHANGES = {
    "* Breaking changes",

    "* New features",

    "* Enhancements",

    "* Bug fixes",
    "SetFont() errors",

    "* Profile updates",

    "* Documentation",
    F.String.Retail() .. "Update for patch 12.0.5",

    "* Settings refactoring",

    "* Development improvements",
    F.String.Menu.Performance() .. ": Gradient mode health/power/castbar color updates no longer allocate a closure per tick",
    F.String.Menu.Performance() .. ": Unit tags pre-compute class/reaction color prefixes at init instead of rebuilding per tick",
    F.String.Menu.Performance() .. ": Replace per-frame OnUpdate with on-demand flush for deferred events",
    F.String.Menu.WunderBar() .. " SecureFlyOut: Replace per-frame cooldown updates with a 0.5s ticker",
    "Vehicle Bar Vigor Bar: Replace per-frame animation with a 0.05s ticker",
  },
}
