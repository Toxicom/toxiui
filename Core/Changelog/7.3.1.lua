local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.3.1"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    "Total time played information shown in " .. TXUI.Title .. " Game Menu Skin" .. F.String.Sublist("Credits to " .. F.String.Kryo()),

    "* Enhancements",
    "Set 0.65 UI scale for non-standard resolutions",

    "* Bug fixes",

    "* Profile updates",

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
    "Refactor Game Menu Skin as it's own module with subfolder structure",
  },
}
