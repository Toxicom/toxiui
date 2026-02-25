local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.3.2"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    "Due to popular demand, revert the removal of " .. TXUI.Title .. " " .. F.String.ElvUI() .. " skin" .. F.String.Sublist(
      "Do be aware that it's known to bug out and there currently will not be much effort into fixing it"
    ),
    "Option to delete a character from Played data",
    F.String.Menu.WunderBar() .. " Hearthstone: Replace secondary Hearthstone right-click with a flyout for Additional Teleports" .. F.String.Sublist(
      "All Additional Teleports are now enabled by default"
    ),
    F.String.Menu.WunderBar() .. " Hearthstone: Add raid teleports to M+ flyout",
    F.String.Retail() .. "Add minimum width slider to bars sync functionality of " .. F.String.CDM(),
    F.String.Retail() .. "Option to hide floating player entry on the Damage Meter" .. F.String.Sublist("Enabled by default") .. F.String.Sublist("Credits to " .. F.String.Kryo()),

    "* Enhancements",
    "Update "
      .. F.String.GradientString()
      .. " colors for classes except for "
      .. F.String.Class("Hunter", "HUNTER")
      .. ", "
      .. F.String.Class("Shaman", "SHAMAN")
      .. " and "
      .. F.String.Class("Rogue", "ROGUE"),
    "Update " .. F.String.GradientString() .. " colors for " .. F.String.Class("Priest", "PRIEST") .. F.String.Sublist(
      "Previous color had a blue tint to it which resulted in the backdrop being dark blue, which looked very wrong"
    ),
    "Add borders to the played graph bars for the Game Menu Skin",
    F.String.Retail() .. "Enable the Cooldown Manager in Blizzard settings if " .. F.String.CDM() .. " is enabled",
    F.String.Retail() .. "Display Essence on " .. F.String.ToxiUI("[tx:power]") .. " tag for " .. F.String.Class("Evokers", "EVOKER"),
    F.String.Retail() .. "Reverse " .. F.String.GradientString() .. " direction for Damage Meter gradients",
    F.String.Retail() .. "Hide mana text for feral & guardian druids in human form",

    "* Bug fixes",
    "Fix flyout buttons retaining cooldown state when reused across different flyout menus",
    "Fix Class Bar position after updating if Power Bar is disabled",
    F.String.Menu.WunderBar() .. " MicroMenu: Block talent and spell icons from clicks in combat",
    "Fix missing requirement strings in Status Report window",
    "Vehicle Bar gradient colors should update dynamically",
    "Do not register played time events for Game Menu Skin if the feature is disabled in settings",
    "Do not request time played if it had already been requested by another addon to avoid duplicate chat messages",
    F.String.Retail() .. "Protect " .. F.String.Menu.WunderBar() .. " currency tooltip in combat",
    F.String.Retail() .. "Skip anchoring and centering for the " .. F.String.CDM() .. " if a viewer's orientation is vertical",
    F.String.Retail() .. "Hide the debuff border for " .. F.String.CDM() .. " icons if centering is enabled" .. F.String.Sublist(
      "This is a bandaid fix, hopefully ElvUI fixes it properly in the future"
    ),
    F.String.Retail() .. "Update keybinds for " .. F.String.CDM() .. " when changing shapeshift forms",
    F.String.Retail() .. "Buff icons position for DK and Brewmaster Monk fixed in " .. F.String.CDM(),

    "* Profile updates",
    F.String.ElvUI() .. ": Nudge raid frames to the left" .. F.String.Sublist(
      "Now that they're bigger due to the requirement to fit buffs and debuffs inside of it, have to save space"
    ),
    F.String.ElvUI() .. "Adjust spacing for player, target, focus unitframes auras",

    "* Documentation",
    "Add " .. F.String.Kryo() .. " to contributors list",
    F.String.MinElv("15.06"),
    F.String.Retail() .. F.String.Menu.WunderBar() .. " Hearthstone: Update data adding some missing spells and toys, including Midnight ones",

    "* Settings refactoring",
    F.String.Retail() .. "Add notes to the " .. F.String.CDM() .. " for horizontal orientation",
    "Sort " .. F.String.GradientString() .. " mode's classes in settings",

    "* Development improvements",
  },
}
