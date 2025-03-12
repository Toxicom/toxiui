local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.9.1"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    F.String.ToxiUI("[tx:health:current:shortvalue:absorb]") .. " tag" .. F.String.Sublist("Check Available Tags for more information"),

    "* Bug fixes",

    "* Profile updates",
    TXUI.Title .. ": Enable Time module's resting animation by default",
    F.String.Plater() .. ": Add " .. F.String.Class("Black Arrow", "HUNTER") .. " to manual buff  tracking",
    F.String.Plater() .. ": Remove Hide Nameplates script",
    F.String.ElvUI() .. ": Use the new absorb tag for " .. F.String.ToxiUI("toxiui:health-small") .. " custom texts",
    F.String.ElvUI() .. ": Reduce minimap location text font size",

    "* Documentation",
    "Update for Patch 11.0",
    F.String.MinElv("13.85"),
    "Update colored currencies for season 2 of TWW",
    "Update default displayed currencies",
    "Add " .. TXUI.Title .. " under " .. F.String.ElvUI() .. " group in the AddOns list",
    "Update M+ S2 portals for " .. F.String.Menu.WunderBar(),

    "* Settings refactoring",
    "Bring back the old " .. F.String.Plater() .. " profile" .. F.String.Sublist("Do note that it will never be updated"),

    "* Development improvements",
    "Extract import strings for Details & Plater to a separate file for easier managing",
  },
}
