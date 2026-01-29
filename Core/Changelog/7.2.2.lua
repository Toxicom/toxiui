local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.2.2"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",
    "Remove Wardrobe frame from Animations and Scaling modules" .. F.String.Sublist("It's already covered by the Collections Journal frame."),

    "* New features",
    F.String.Retail() .. "Cooldown Manager fading option",
    F.String.Retail() .. "Cooldown Manager dynamic bars width option",

    "* Bug fixes",
    "Fix CDM Action Bars Style yeeting the power bar",
    F.String.Anniversary() .. "Add Stonard and Theramore portals to " .. F.String.Menu.WunderBar() .. " Hearthstone module",
    "Crop Vehicle Bar buttons so they're not squished",

    "* Profile updates",
    F.String.Retail() .. TXUI.Title .. ": Do not display mana text for Frost and Fire Mages in Midnight",
    F.String.Retail() .. F.String.ElvUI() .. ": Style CDM cooldown text",

    "* Documentation",
    "Add " .. F.String.Rare("Liue") .. " to contributors list",
    F.String.MinElv("15.02"),

    "* Settings refactoring",
    "Update " .. TXUI.Title .. " installer description for profile step to highlight risk of overwriting existing profile",

    "* Development improvements",
  },
}
