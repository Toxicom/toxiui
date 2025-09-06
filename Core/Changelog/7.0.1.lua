local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.0.1"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",

    "* Bug fixes",

    "* Profile updates",
    F.String.Plater() .. ": Update npc colors for season 3",

    "* Documentation",
    "Add Cosmic Hearthstone to " .. F.String.Menu.WunderBar(),
    F.String.MinElv("13.97"),

    "* Settings refactoring",

    "* Development improvements",
  },
}
