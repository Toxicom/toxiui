local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.8.7"] = {
  HOTFIX = true,
  CHANGES = {
    "* Bug fixes",
    "Fix IDs for season 1 M+ portals",
    "Enable repair mount for Cata",
    "Fix BugGrabber disabling for " .. TXUI.Title .. " Debug mode",
    "Change " --
      .. F.String.Menu.Armory()
      .. " Missing Socket option's description to update dynamically each time it shows up"
      .. F.String.Sublist("This should fix missing information on first load of the game")
      .. F.String.Sublist("If the item name is still not showing, re-hover the checkbox to show an updated description"),
    "Fix Blizzard store error in classic era",

    "* Profile updates",
    F.String.Plater() .. ": Add Wither to manual debuff tracking",
    F.String.ElvUI() --
      .. ": Reposition party & arena frames for Ultrawide"
      .. F.String.Sublist("The frames are now offset from the center, so they should match closer to the original design for ultrawide.")
      .. F.String.Sublist("The position on 16:9 screens should generally be the same"),
    F.String.OmniCD() .. ": Correct extra bars positions for Ultrawide",

    "* Documentation",
    "Add " .. F.String.ToxiUI("Notorious Thread's Hearthstone") .. " to " .. F.String.Menu.WunderBar(),
    "Added " .. F.String.ToxiUI("Wormhole Generator: Khaz Algar") .. " to " .. F.String.Menu.WunderBar() .. " hearthstones" .. F.String.Sublist("Credits to Kryonyx"),
    "Update contributors list",

    "* Development improvements",
    "Add a " .. F.String.ToxiUI("F.CalculateUltrawideOffset()") .. " function to improve ultrawide support",
  },
}
