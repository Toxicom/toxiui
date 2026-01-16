local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.1.3"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    "Animations plugin"
      .. F.String.Warning(" [Retail only]") --
      .. F.String.Sublist("Animate the opening of Blizzard frames")
      .. F.String.Sublist("Enabled by default")
      .. F.String.Sublist("Can be configured per-frame in Animations settings")
      .. F.String.Sublist(TXUI.Title .. " Settings -> Plugins -> Animations"),

    "* Bug fixes",

    "* Profile updates",

    "* Documentation",
    F.String.MinElv("14.07"),

    "* Settings refactoring",

    "* Development improvements",
  },
}
