local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.0.4"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",

    "* Bug fixes",
    "Fix " .. F.String.Plater() .. " NPC Colors not importing correctly",

    "* Profile updates",

    "* Documentation",
    F.String.MinElv("14.02"),
    "Update .toc for Patch 11.2.5",

    "* Settings refactoring",

    "* Development improvements",
    "Refactor code on how we import a " .. F.String.Plater() .. " profile",
  },
}
