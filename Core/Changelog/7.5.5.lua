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

    "* Profile updates",

    "* Documentation",
    F.String.MinElv("15.25"),

    "* Settings refactoring",

    "* Development improvements",
  },
}
