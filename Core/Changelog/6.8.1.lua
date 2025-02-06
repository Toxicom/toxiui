local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.8.1"] = {
  HOTFIX = true,
  CHANGES = {
    "* New features",
    "Option to open Professions Frame via " .. F.String.Menu.WunderBar() .. " MicroMenu",
    "Hearthstone module right-click toggles Tome of Teleportation if that AddOn is enabled",
    "Dynamic tooltip for " .. F.String.Menu.WunderBar() .. " Currency" .. F.String.Sublist("Credits to ") .. F.String.Color("Jake", "0070de"),
    F.String.Scaling() .. " for Retail Professions frame",
    "Right-clicking the " .. TXUI.Title .. " VehicleBar Mover will open it's settings",

    "* Bug fixes",
    "Temporarily remove LibOpenRaid to fix spec icons not updating",
    "Improve ActionBar Fade 'Show in Vehicles' option for Skyriding",

    "* Profile updates",
    F.String.Plater() .. ": Update mods",
    F.String.Plater() .. ": Add more debuffs to manual tracking",
    F.String.WindTools() .. ": Reduce map event tracker font scale",
    F.String.WindTools() .. ": Enable Extra Items Bar for Quest items, Openable items & Delve items",
    F.String.ElvUI() .. ": Clean-up and adjust some movers",

    "* Documentation",
    "Revert the 1600 height custom scale",
    "Update current season to " .. F.String.ToxiUI("tww1") .. F.String.Sublist("This affects the Hearthstone Seasonal M+ Portals list"),
    "Add TWW Season 1 portals to " --
      .. F.String.Menu.WunderBar()
      .. " Hearthstone module"
      .. F.String.Sublist("IDs are taken from Wowhead beta, so they might change when M+ releases"),
    "Covenant hearthstones now have a prefix in the hearthstone select dropdown",
    "Show more AddOns in " .. F.String.Menu.WunderBar() .. " MicroMenu " .. TXUI.Title .. " button tooltip",

    "* Settings refactoring",
    "Simplify the Game Menu Skin options, since we no longer add the button to the menu",
    "Add extra information to the ActionBar Fade module",
  },
}
