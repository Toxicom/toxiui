local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.7.9"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",
    "For resolutions above 1440p, set a 0.65 UI scale to avoid non-sensical 4K resolution issues",

    "* New features",
    "Spec Icon options for the Game Menu skin",
    "Add more attribute icons to " .. F.String.Menu.Armory(),

    "* Bug fixes",
    "Fix duplicating " .. F.String.Menu.Armory() .. " attribute icons",

    "* Profile updates",
    "Update default Gradient mode textures to " .. F.String.ToxiUI("'- ToxiUI'"),
    "Update OmniCD textures to " .. F.String.ToxiUI("'- ToxiUI'"),

    "* Documentation",
    "Update descriptions and naming of " .. F.String.Menu.Skins() .. " section",
    "Add " .. F.String.Rare("Dieman") .. " to the contributors",

    "* Settings refactoring",
    "Require UI reload when disabling ActionBars Fade to properly unhook everything",
    "Disable ActionBars Fade if " .. F.String.ToxiUI("ElvUI_ActionBarBuddy") .. " is enabled",

    "* Development improvements",
    "Add extra information to using " .. TXUI.Title .. " commands without having a proper " .. TXUI.Title .. " profile",
  },
}
