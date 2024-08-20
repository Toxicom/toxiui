local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["5.2.1"] = {
  HOTFIX = true,
  CHANGES = {
    "* Bug fixes",
    F.String.Menu.Armory() .. ": Fixed an error with non-english clients",

    "* Profile updates",
    F.String.WindTools() .. ": Enable BlizzMoveFrames module",

    "* Settings refactoring",
    "ActionBarFade: Changed description for the module",
  },
}
