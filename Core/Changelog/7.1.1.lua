local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.1.1"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",
    TXUI.Title .. " " .. F.String.ElvUI() .. " Skin Theme disabled by default",

    "* New features",

    "* Bug fixes",
    "Improve initialization performance by deferring non-critical module setups."
      .. F.String.Sublist("This code was always applied for Retail, now it's applied for all versions."),

    "* Profile updates",
    "Move WTRaidMarkersBarAnchor mover position when Chattynator is enabled.",

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
  },
}
