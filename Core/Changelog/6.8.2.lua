local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.8.2"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",
    F.String.Menu.WunderBar() .. " Flyout settings are reset due to database changes",

    "* New features",
    "Option to select repair mount for " .. F.String.Menu.WunderBar() .. " Durability module",
    "Sort the color-coded TWW currencies" --
      .. F.String.Sublist("Crests")
      .. F.String.Sublist("Valorstones")
      .. F.String.Sublist("Coffer keys"),
    F.String.Menu.WunderBar()
      .. " Flyouts now have more options"
      .. F.String.Sublist("Padding")
      .. F.String.Sublist("Spacing")
      .. F.String.Sublist("Slot Size")
      .. F.String.Sublist("Font & Font Size"),
    "More options for "
      .. F.String.Menu.WunderBar()
      .. " Profession module" --
      .. F.String.Sublist("Abbreviate Names")
      .. F.String.Sublist("Name Length limit"),
    "Cooking Fire button in " .. F.String.Menu.WunderBar() .. " Profession flyout",

    "* Bug fixes",
    "Remove outdated S&L database entry",

    "* Profile updates",
    F.String.ElvUI() .. ": Disable Weekly Rewards skin",

    "* Documentation",
    F.String.MinElv("13.77"),
    "Game Menu Skin improvements" --
      .. F.String.Sublist("Increase the width for Random Tips text")
      .. F.String.Sublist("Random tips now update each time you open the Game Menu")
      .. F.String.Sublist("Add more Random Tips"),
    "Update M+ labels to match R.IO",
    "Add labels to Mage portals",

    "* Settings refactoring",
    "Improve Game Menu Skin options" --
      .. F.String.Sublist("Background Color now has an Alpha slider")
      .. F.String.Sublist("Class Color and Background Color options no longer require a reload"),
    F.String.Menu.WunderBar() .. " Flyout settings are no longer specific to it's backdrop",
    "Add a new line before portals toggles in Hearthstone settings",
    "Separate Mythic+ and Mage portal labels for " .. F.String.Menu.WunderBar() .. " Hearthstone module",

    "* Development improvements",
    "Improve calculations for " .. F.String.Menu.WunderBar() .. " Flyouts",
  },
}
