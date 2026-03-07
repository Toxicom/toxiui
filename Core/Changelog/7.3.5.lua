local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.3.5"] = {
  HOTFIX = true,
  CHANGES = {
    "* New features",
    "Class Icons style setting now controls all spec/class icon displays globally",
    "Class Icons can be previewed in the options",
    F.String.Retail() .. F.String.CDM() .. ": Option to align Buff Bar Viewer bars to the bottom of the viewer frame",
    F.String.Retail() .. "Option to change spec icon for Damage Meter skin",
    F.String.Retail() .. F.String.CDM() .. ": Option to automatically disable " .. F.String.ToxiUI("ElvUI Class Bar") .. " per specialization",
    F.String.Retail() .. F.String.CDM() .. ": Option to automatically disable " .. F.String.ToxiUI("ElvUI Power Bar") .. " per specialization",
    F.String.Retail() .. "New " .. F.String.ToxiUI("[tx:power:classbar]") .. " tag: displays power value only when the Player Power Bar is disabled",

    "* Enhancements",
    "Show diff for fonts in Profile Updater",
    "Class-only icon displays (Played graph, spec fallbacks) respect the selected class icon style",
    F.String.Retail() .. "Allow opening " .. F.String.ToxiUI("/cdm") .. " in combat",

    "* Profile updates",
    F.String.ElvUI() .. ": Update fonts for Cooldown Manager text (name, duration, count)",
    F.String.ElvUI() .. ": Update nameplate auras fonts",
    F.String.ElvUI() .. ": " .. F.String.ToxiUI("ClassBarMover") .. " is now always positioned above the Power Bar, regardless of power bar state",
    F.String.ElvUI() .. ": Set Max Overflow back to 0",
    F.String.ElvUI() .. ": Adjust nameplate quest icon fonts",
    F.String.ElvUI() .. ": Disable automated friendly nameplates",
    F.String.WindTools() .. ": Update objective tracker fonts",

    "* Documentation",
    F.String.Retail() .. F.String.Menu.WunderBar() .. ": Add Wormhole Generator: Quel'thalas to Hearthstone module",
    F.String.MinElv("15.08"),

    "* Settings refactoring",
    "Remove Details section from Class Icons settings",
    "Remove per-feature spec icon style selectors (Game Menu, AFK, Damage Meter) in favor of global Class Icons setting",
    "Reduce logo size in " .. TXUI.Title .. " options",
    "Rename " .. TXUI.Title .. " " .. F.String.ElvUI("ElvUI") .. " Skin to " .. F.String.Silver("Shadows & Grain Background"),
    F.String.Retail() .. F.String.CDM() .. ": Add navigation buttons to related " .. F.String.ElvUI() .. " and " .. F.String.WindTools() .. " Cooldown Manager settings panels",
    F.String.Retail() .. F.String.CDM() .. ": Refactor settings into tabs for less scrolling",

    "* Development improvements",
    "Simplify unitframe font config",
    "Extract "
      .. F.String.ToxiUI("I.ClassOrder")
      .. " and "
      .. F.String.ToxiUI("I.ClassSpecOrder")
      .. " to "
      .. F.String.ToxiUI("InternalSpecs.lua")
      .. " for shared use across options modules",
  },
}
