local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.7.9"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    "Spec Icon options for the Game Menu skin",

    "* Bug fixes",

    "* Profile updates",
    "Update default Gradient mode textures to " .. F.String.ToxiUI("'- ToxiUI'"),
    "Update OmniCD textures to " .. F.String.ToxiUI("'- ToxiUI'"),

    "* Documentation",
    "Update descriptions and naming of " .. F.String.Menu.Skins() .. " section",

    "* Settings refactoring",

    "* Development improvements",
  },
}
