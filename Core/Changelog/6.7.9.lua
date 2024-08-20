local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.7.9"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    "Spec Icon options for the Game Menu skin",
    "Spec Icon options for the AFK skin",
    "Add more attribute icons to " .. F.String.Menu.Armory(),
    "Ability to open Mobile Warbank via " .. F.String.Menu.WunderBar() .. " Currency module" .. F.String.Sublist("Cooldown text in the tooltip updates only when tooltip shows up"),
    F.String.Scaling() .. " for Group Finder frame",

    "* Bug fixes",
    "Fix duplicating " .. F.String.Menu.Armory() .. " attribute icons",

    "* Profile updates",
    "Update default Gradient mode textures to " .. F.String.ToxiUI("'- ToxiUI'"),
    "Update OmniCD textures to " .. F.String.ToxiUI("'- ToxiUI'"),
    "Disable Spec & Race icons for tooltips in " .. F.String.WindTools(),

    "* Documentation",
    "Update descriptions and naming of " .. F.String.Menu.Skins() .. " section",
    "Add " .. F.String.Rare("Dieman") .. " to the contributors",
    "Change default secondary hearthstone to Dalaran's Hearthstone in " .. F.String.Menu.WunderBar(),

    "* Settings refactoring",
    "Require UI reload when disabling ActionBars Fade to properly unhook everything",
    "Disable ActionBars Fade if " .. F.String.ToxiUI("ElvUI_ActionBarBuddy") .. " is enabled",
    "Disable " .. F.String.Scaling() .. " if EltruismUI is enabled",
    "Update changelog with new " .. F.String.WindTools() .. " string",
    "Update small logo" .. F.String.Sublist("Visible in AddOns selection window"),

    "* Development improvements",
    "Add extra information to using " .. TXUI.Title .. " commands without having a proper " .. TXUI.Title .. " profile",
    "Force 1440p UI scale for 1600 height resolution (1440p 16:10)",
  },
}
