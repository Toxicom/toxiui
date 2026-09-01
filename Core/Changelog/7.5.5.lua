local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.5.5"] = {
  HOTFIX = true,
  RELEASE_DATE = "",
  CHANGES = {
    "* Breaking changes",

    "* New features",

    "* Enhancements",

    "* Bug fixes",
    F.String.Retail() --
      .. "Damage Meter: Follow the new Blizzard session window layout"
      .. F.String.Sublist("Spell breakdown and floating player entry now use GetSourceWindow / GetLocalPlayerEntry")
      .. F.String.Sublist("Credits to DakJaniels"),

    "* Profile updates",

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
  },
}
