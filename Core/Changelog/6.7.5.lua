local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.7.5"] = {
  HOTFIX = true,
  CHANGES = {
    "* Bug fixes",
    "Update skyriding logic",
    "Fix Hearthstone timer in " .. F.String.Menu.WunderBar(),
    "Fix Spellbook in " .. F.String.Menu.WunderBar() .. " MicroMenu",
    "Fix Talents in " .. F.String.Menu.WunderBar() .. " MicroMenu",

    "* Documentation",
    F.String.MinElv("13.72"),

    "* Settings refactoring",
    "Re-enable " .. F.String.ElvUI() .. " theme",

    "* Development improvements",
    "Update deprecated functions",
  },
}
