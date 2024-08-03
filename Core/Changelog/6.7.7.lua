local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.7.7"] = {
  HOTFIX = true,
  CHANGES = {
    "* New features",
    "Display Warbank money in Currency module for " .. F.String.Menu.WunderBar(),

    "* Bug fixes",
    "Again update Skyriding logic",
    "Fix Professions flyout tooltip not showing",

    "* Documentation",
    "Add The Innkeeper's daughter hearthstone to Cataclysm",
    "Add Jaina's Locket portal to Cataclysm",

    "* Settings refactoring",
    "Prefix Mythic+ portals with " .. F.String.Class("Mythic:", "DEMONHUNTER") .. " in " .. F.String.Menu.WunderBar() .. " Hearthstone select",
    "Sort Hearthstones alphabetically in " .. F.String.Menu.WunderBar() .. " Hearthstone select",
    "Fix incorrect option label in " .. F.String.Menu.WunderBar() .. " settings",
  },
}
