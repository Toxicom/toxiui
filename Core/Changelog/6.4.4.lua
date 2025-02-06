local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.4.4"] = {
  HOTFIX = true,
  CHANGES = {
    "* Bug fixes",
    TXUI.Title .. ": Fix WunderBar LFG in " .. F.String.ToxiUI("Wrath"),
    TXUI.Title .. ": Fix WunderBar Hearthstone toys in " .. F.String.ToxiUI("Wrath"),

    "* Profile updates",
    TXUI.Title .. ": Double UI scale for 2054 height screens",
    TXUI.Title .. ": Enable Dark Mode's transparency by default",
    F.String.ElvUI() .. ": Use 'Shadow Outline' for fonts instead of 'Outline'",
    F.String.ElvUI()
      .. ": Use 4:3 aspect ratio for:" --
      .. F.String.Sublist("ActionBars")
      .. F.String.Sublist("UnitFrame Buffs")
      .. F.String.Sublist("UnitFrame Debuffs"),
    F.String.ElvUI()
      .. ": Add profile options for the "
      .. F.String.Class("Ratio Minimap Auras")
      .. " plugin by "
      .. F.String.Class("Repooc", "DRUID") --
      .. F.String.Sublist("With this plugin you can achieve 4:3 ratio buffs & debuffs, exciting!"),
    F.String.ElvUI() .. ": Center duration text for UnitFrame buffs & debuffs",

    "* Documentation",
    F.String.MinElv("13.45"),

    "* Development improvements",
    "Create a doubleResolutionScale table for easier tracking of 4k resolutions",
    "Remove tukui information from .toc files since we can no longer host there",
  },
}
