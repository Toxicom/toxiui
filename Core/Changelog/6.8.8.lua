local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.8.8"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",

    "* Bug fixes",
    "If " .. F.String.Menu.WunderBar() .. " is set to mouseover and you have a flyout open, it will no longer fade out until you close the flyout",
    "Having a " .. F.String.Menu.WunderBar() .. " flyout open will close it when entering combat",
    "Add a second Siege of Boralus M+ portal ID for different Horde & Alliance portals" .. F.String.Sublist("Credits to mdpaquin"),
    "Potential fix for AFK mode",

    "* Profile updates",
    F.String.ElvUI() .. ": Change party/arena offset to use dynamic calculation" .. F.String.Sublist("This should revert the position to previous for non-ultrawide users"),

    "* Documentation",
    "Update for patch 11.0.5",
    F.String.MinElv("13.81"),

    "* Settings refactoring",

    "* Development improvements",
    "Update to new " .. F.String.BigWigs() .. " API for profile importing",
  },
}
