local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.5.6"] = {
  HOTFIX = true,
  RELEASE_DATE = "Oct 14, 2026",
  CHANGES = {
    "* New features",
    F.String.Retail() .. "VehicleBar: Added option to hide the Vehicle Bar while Skyriding",

    "* Bug fixes",
    F.String.Retail() .. "Fixed Hearthstone data error caused by removed item API globals",
    F.String.ElvUI() .. " Unitframes: Fixed " .. TXUI.Title .. " Raid Leader icon being reset to the default icon",
    F.String.Retail() .. "Fixed name tag error spam in Delves due to secret class values",
    "Fixed Dead Icons error when a party frame has no unit",
    F.String.Retail() .. "Fixed potential secret value error on " .. F.String.Menu.WunderBar() .. " flyout item cooldowns",
    F.String.Retail() .. "Cooldown Manager: Fixed random secret value errors caused by fading toggling viewer visibility",
    "AFK Mode: Fixed player model not showing and texts overlapping after changing settings",

    "* Documentation",
    F.String.Retail() .. "Update for patch 12.1.5",
  },
}
