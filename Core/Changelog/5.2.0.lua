local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["5.2.0"] = {
  CHANGES = {
    "* New features",
    F.String.Menu.Armory() .. ": Character Sheet module stylised for " .. TXUI.Title,
    "VehicleBar: A Fork of the S&L Vehicle Bar",
    "MiniMapCoords: Display Coordinates on the Minimap",
    "RoleIcons: New module for custom Role Icons with updated icons",
    "RoleIcons: " .. TXUI.Title .. "icons in chat",
    "Badges: " .. TXUI.Title .. "Chat badges for special people :3",
    "Changelog: Ability to see more versions of changelog via dropdown menu",
    "GameMenuButton: Add button in the Game Menu (ESC) for " .. TXUI.Title,
    "Icons: Dead & Offline icon indicators",
    "Plater: Added M+ Colored Mobs mod",
    "Deconstruct: Button in your bags for easy disenchanting, prospecting, milling",
    "ActionBarFade: ElvUI Keybind mode will now force display action bars",
    "ActionBarFade: Now has different modes to change the hide/show behavior",
    "DarkMode: Added configurable alpha value for the background transparency",
    "GradientMode: New dynamic Gradient system, you can now customize the colors to your liking",
    "Chat: Message for new " .. TXUI.Title .. "updates available",
    "AFKMode: Player will now perform random emotes",
    "AFKMode: Added option to disable camera turning",
    "Icon Color Option: Enables you to customize Icon Color seperate from Font Color",
    "Guild: Right-click functionality",
    "Durability: Show average/equipped ilvl on durability tooltip",
    "Profession: Can now display secondary professions",
    "Hearthstone: Vulpera Racial and Necrolord Soulbind added",
    "Hearthstone: Class-only teleports via Shift-click",
    "Hearthstone: Functionality for Mage portals via Shift-click",

    "* Bug fixes",
    "Time: Fix midnight for 12-hr format",

    "* Profile updates",
    F.String.ElvUI("ElvUI") .. ": BNet Toast moved",
    F.String.ElvUI("ElvUI") .. ": Minimap button bar reduced spacing",
    F.String.ElvUI("ElvUI") .. ": Enabled Contact list when sending mail",
    F.String.ElvUI("ElvUI") .. ": Fixed an issue with Debuffs anchoring in the wrong place",
    F.String.ElvUI("ElvUI") .. ": Removed Outline from Castbar text",
    "Plater: Removed Outline from Castbar text",
    "BigWigs: Visual changes to fit more with the whole " .. TXUI.Title .. "theme",

    "* Documentation",

    "* Settings refactoring",
    "Options: Restructured " .. TXUI.Title .. "options for easier navigation",
    "Information: Re-structure Credits, add more people to Credits",

    "* Development improvements",
    "Internal: Animation Library Forked, all animations changed to new API",
  },
}
