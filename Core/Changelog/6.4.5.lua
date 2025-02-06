local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.4.5"] = {
  HOTFIX = true,
  CHANGES = {
    "* New features",
    "Show player information in the Game Menu overlay" .. F.String.Sublist("Can disable in " .. F.String.Menu.Skins() .. " -> " .. F.String.ElvUI()),

    "* Bug fixes",
    TXUI.Title .. ": Remove empty gap in `/tx status`",
    TXUI.Title .. ": Add fail-safety check for " .. F.String.Details() .. " in " .. F.String.GradientString() .. " mode",
    TXUI.Title .. ": Fix Blacksmithing icon not showing in WunderBar in " .. F.String.ToxiUI("Wrath"),
    TXUI.Title .. ": Fix Primary fonts not applying 'Shadow Outline' style",

    "* Profile updates",
    TXUI.Title .. ": Disable 'Details Gradient Text' toggle in Dark Mode if " .. F.String.Details() .. " is disabled or not using " .. TXUI.Title .. " profile",
    TXUI.Title .. ": Update AFK screen's timer text",
    TXUI.Title .. ": Enable Details Gradient Text by default",
    F.String.NameplateSCT() .. ": Enable small hits for Wrath & Vanilla",
    F.String.ElvUI() --
      .. ": Match UnitFrame Class Resources colors to the ones we have in Gradient mode"
      .. F.String.Sublist("Previously in Dark & Normal modes the resource colors were default"),
    F.String.ElvUI() .. ": Increase shown Player Buffs number from 18 to 36",
    F.String.ElvUI() --
      .. ": Update chat settings"
      .. F.String.Sublist("Remove tab selector")
      .. F.String.Sublist("Change tab font to primary")
      .. F.String.Sublist("Change font outlines to 'Shadow Outline'")
      .. F.String.Sublist("Reduce scroll messages to 1")
      .. F.String.Sublist("Increase Scroll Down interval to 2 minutes"),
    F.String.ElvUI() --
      .. ": Update Loot Roll settings"
      .. F.String.Sublist("Move it to right-center part of the screen")
      .. F.String.Sublist("Increase buttons size")
      .. F.String.Sublist("Move the roll buttons to the left")
      .. F.String.Sublist("Change texture in gradient mode"),
  },
}
