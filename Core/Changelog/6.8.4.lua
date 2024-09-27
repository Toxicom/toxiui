local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.8.4"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",
    "Remove UnitFrame " .. F.String.Menu.Styles(),

    "* New features",
    F.String.Menu.WunderBar() .. " can now be positioned at the top >.>" .. F.String.Sublist("Credits to arturogutierrez"),

    "* Bug fixes",
    "Fix currency sorting issue where currencies would go under the wrong expansion header",

    "* Profile updates",
    F.String.BigWigs() .. ": Update Nameplate icons to match rest of " .. TXUI.Title,
    F.String.Plater() .. ": Enable mod to help tanks with treants and elementals taunting",
    F.String.ElvUI()
      .. ": Add current health text tags to some UnitFrames:"
      .. F.String.Sublist("Player")
      .. F.String.Sublist("Target")
      .. F.String.Sublist("Focus")
      .. F.String.Sublist("Boss"),

    "* Documentation",
    "Update default repair mount to the Yak",
    "Update contributors list",
    "Add BugSack & BugGrabber to Debug mode",
    F.String.MinElv("13.78"),
    "Update version for Classic Era",
    "Display the name of the item that can add sockets in " .. F.String.Menu.Armory() .. "'s Missing Sockets description tooltip",

    "* Settings refactoring",
    "Add more information for Gradient mode's Health Color tags setting",
    "Add extra information to " .. TXUI.Title .. " " .. F.String.ElvUI() .. " skin",

    "* Development improvements",
    "Register AnyDown or AnyUp for WunderBar's buttons based on the CVar",
    "Rename mage portals function for consistency",
    "Move Repair Mounts to the Internal table",
    "Show default Vigor Bar if Blizz API freaks out and doesn't load ours",
    "Update Profession module to use C_Spell namespace if it's available" .. F.String.Sublist("This fixes broken professions module on Classic Era"),
  },
}
