local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.9.1"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",

    "* Bug fixes",

    "* Profile updates",
    F.String.Plater() .. ": Add " .. F.String.Class("Black Arrow", "HUNTER") .. " to manual buff  tracking",

    "* Documentation",
    "Update for Patch 11.0",
    F.String.MinElv("13.85"),
    "Update colored currencies for season 2 of TWW",
    "Update default displayed currencies",
    "Add " .. TXUI.Title .. " under " .. F.String.ElvUI() .. " group in the AddOns list",

    "* Settings refactoring",

    "* Development improvements",
  },
}
