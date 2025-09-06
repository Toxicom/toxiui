local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.0.1"] = {
  HOTFIX = true,
  CHANGES = {
    "* Bug fixes",
    "Potentially fix " .. F.String.Menu.WunderBar() .. "'s SpecSwitch taint error" .. F.String.Sublist("Credits to dsypher2"),

    "* Profile updates",
    F.String.Plater() .. ": Update npc colors for season 3",

    "* Documentation",
    "Add Cosmic Hearthstone to " .. F.String.Menu.WunderBar(),
    F.String.MinElv("13.97"),
  },
}
