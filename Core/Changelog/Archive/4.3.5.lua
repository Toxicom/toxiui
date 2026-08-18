local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["4.3.5"] = {
  CHANGES = {
    "* Bug fixes",
    "Vehicle Exit button won't get lost in another planet",
    "Fixed an issue with UI scale",

    "* Profile updates",
    "Disabled some announcements in " .. F.String.WindTools(),
    "Moved Right Chat to be above Left Chat (still testing this)",
    "Moved Battle.net toast",
    "Moved Durability frame",
    "Moved Tank/Assist frames",
    "Moved Focus frame for DPS",
    "Moved Alternative power for DPS",
    "Moved Alternative power for Healer",
    "Moved Party Frames for DPS because of Right Chat",
    "Moved Raid Frames for DPS because of Right Chat",
    "Moved Top container frames",
    "Disabled XIV skin if AddOn is not loaded",
    "Updated the URL of the Welcome message",
  },
}
