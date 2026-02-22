local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.3.2"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    "Due to popular demand, revert the removal of " .. TXUI.Title .. " " .. F.String.ElvUI() .. " skin" .. F.String.Sublist(
      "Do be aware that it's known to bug out and there currently will not be much effort into fixing it"
    ),
    F.String.Retail() .. "Option to hide floating player entry on the Damage Meter" .. F.String.Sublist("Enabled by default") .. F.String.Sublist("Credits to " .. F.String.Kryo()),
    "Option to delete a character from Played data",
    F.String.Menu.WunderBar() .. " Hearthstone: Replace secondary Hearthstone right-click with a flyout for Additional Teleports" .. F.String.Sublist(
      "All Additional Teleports are now enabled by default"
    ),

    "* Enhancements",
    "Update "
      .. F.String.GradientString()
      .. " colors for classes except for "
      .. F.String.Class("Hunter", "HUNTER")
      .. ", "
      .. F.String.Class("Shaman", "SHAMAN")
      .. " and "
      .. F.String.Class("Rogue", "ROGUE"),
    "Add borders to the played graph bars for the Game Menu Skin",
    F.String.Retail() .. "Enable the Cooldown Manager in Blizzard settings if " .. F.String.CDM() .. " is enabled",

    "* Bug fixes",
    "Fix flyout buttons retaining cooldown state when reused across different flyout menus",
    F.String.Retail() .. "Skip anchoring and centering for the " .. F.String.CDM() .. " if a viewer's orientation is vertical",
    F.String.Retail() .. "Hide the debuff border for " .. F.String.CDM() .. " icons if centering is enabled" .. F.String.Sublist(
      "This is a bandaid fix, hopefully ElvUI fixes it properly in the future"
    ),
    "Fix Class Bar position after updating if Power Bar is disabled",

    "* Profile updates",
    F.String.ElvUI() .. ": Nudge raid frames to the left" .. F.String.Sublist(
      "Now that they're bigger due to the requirement to fit buffs and debuffs inside of it, have to save space"
    ),

    "* Documentation",
    "Add " .. F.String.Kryo() .. " to contributors list",

    "* Settings refactoring",
    F.String.Retail() .. "Add notes to the " .. F.String.CDM() .. " for horizontal orientation",
    "Sort " .. F.String.GradientString() .. " mode's classes in settings",

    "* Development improvements",
  },
}
