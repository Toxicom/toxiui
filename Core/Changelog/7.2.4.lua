local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.2.4"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    "Replace the " .. TXUI.Title .. " installer's Turbo Mode with Import Existing, where it finds existing profiles and suggests using the newest one",

    "* Bug fixes",

    "* Profile updates",

    "* Documentation",
    "Add " .. F.String.Epic("evilknivel") .. " to the contributors list",

    "* Settings refactoring",

    "* Development improvements",
  },
}
