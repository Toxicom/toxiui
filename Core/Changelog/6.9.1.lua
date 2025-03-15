local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.9.1"] = {
  HOTFIX = true,
  CHANGES = {
    "* New features",
    F.String.ToxiUI("[tx:health:current:shortvalue:absorb]") .. " tag" .. F.String.Sublist("Check Available Tags for more information"),

    "* Profile updates",
    TXUI.Title .. ": Enable Time module's resting animation by default",
    F.String.Plater() .. ": Add " .. F.String.Class("Black Arrow", "HUNTER") .. " to manual buff tracking",
    F.String.Plater() .. ": Add " .. F.String.Class("Haunt", "WARLOCK") .. " to manual buff tracking",
    F.String.Plater() .. ": Remove Hide Nameplates script",
    F.String.Plater() .. ": Update Buff visuals" .. F.String.Sublist("Now it should match more closely to what we have for ElvUI UnitFrame debuffs for consistency"),
    F.String.Plater() .. ": Increase update interval to default 0.25" .. F.String.Sublist("Should increase performance with lots of nameplates on the screen"),
    F.String.Plater() .. ": Hide Blizzard Health Bars" .. F.String.Sublist("Can be re-enabled in /plater -> General"),
    F.String.Plater() .. ": Auto-enable friendly nameplates in dungeons" .. F.String.Sublist("Can be disabled in /plater -> Auto"),
    F.String.Plater() .. ": Add pandemic pixel glow script" .. F.String.Sublist("Not all debuffs are added") .. F.String.Sublist(
      "Can add debuffs in /plater -> Scripting -> Pandemic Glow (Pixel)"
    ),
    F.String.Plater() .. ": Disable Boss Mods icons on nameplates",
    F.String.ElvUI() .. ": Use the new absorb tag for " .. F.String.ToxiUI("toxiui:health-small") .. " custom texts",
    F.String.ElvUI() .. ": Reduce minimap location text font size",
    F.String.ElvUI() .. ": Update Blizzard nameplate fonts to " .. TXUI.Title,
    F.String.ElvUI() .. ": Reduce Chat Bubble font size",

    "* Documentation",
    "Update for Patch 11.1.0",
    F.String.MinElv("13.87"),
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
