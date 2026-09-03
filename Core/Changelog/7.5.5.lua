local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.5.5"] = {
  HOTFIX = true,
  RELEASE_DATE = "",
  CHANGES = {
    "* Breaking changes",

    "* New features",

    "* Enhancements",
    F.String.Retail() .. "Added a max length setting to truncate long loadout names in " .. F.String.Menu.WunderBar(),

    "* Bug fixes",
    F.String.Retail() .. "Fixed error on health bar backdrop/color updates due to secrets in Dark Mode",
    F.String.Retail() --
      .. "Damage Meter: Follow the new Blizzard session window layout"
      .. F.String.Sublist("Spell breakdown and floating player entry now use GetSourceWindow / GetLocalPlayerEntry")
      .. F.String.Sublist("Credits to DakJaniels"),

    "* Profile updates",

    "* Documentation",
    F.String.MinElv("15.26"),

    "* Settings refactoring",

    "* Development improvements",
  },
}
