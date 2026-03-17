local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.2.2"] = {
  HOTFIX = true,
  RELEASE_DATE = "Jan 29, 2026",
  CHANGES = {
    "* Breaking changes",
    "Remove Wardrobe frame from Animations and Scaling modules" .. F.String.Sublist("It's already covered by the Collections Journal frame"),

    "* New features",
    F.String.Retail() .. F.String.CDM() .. " fading option",
    F.String.Retail() .. F.String.CDM() .. " dynamic bars width option",
    "Bring back " .. TXUI.Title .. " Gradient Mode" .. F.String.Error(" [WIP]"),

    "* Bug fixes",
    "Fix CDM Action Bars Style yeeting the power bar",
    "Crop Vehicle Bar buttons so they're not squished",

    "* Profile updates",
    F.String.Retail()
      .. TXUI.Title
      .. ": Edit shown power text for certain classes and specs."
      .. F.String.Sublist("This change does not require you to re-run the installer")
      .. F.String.Sublist("Hide Frost and Fire Mage power text")
      .. F.String.Sublist("Hide Enhancement Shaman power text")
      .. F.String.Sublist("Display Holy Power for Paladins"),
    F.String.Retail() .. F.String.ElvUI() .. ": Style CDM cooldown text",
    F.String.ElvUI() .. ": Use responsive values for Nameplate settings" .. F.String.Sublist(
      "This means that for resolutions other than 0.5333333 the nameplates should have better sizing"
    ),

    "* Documentation",
    "Add " .. F.String.Rare("Liue") .. " to contributors list",
    F.String.MinElv("15.02"),
    F.String.Anniversary() .. "Add Naaru's Embrace Hearthstone to " .. F.String.Menu.WunderBar() .. " Hearthstone module",
    F.String.Anniversary() .. "Add Stonard and Theramore portals to " .. F.String.Menu.WunderBar() .. " Hearthstone module",

    "* Settings refactoring",
    "Update " .. TXUI.Title .. " installer description for profile step to highlight risk of overwriting existing profile",

    "* Development improvements",
    "Defer gradient mode initialization to the next frame after initial load" --
      .. F.String.Sublist("This should help avoid 'script ran too long' issues")
      .. F.String.Sublist("This does cause a micro-stutter on load, but it's better than the module breaking entirely"),
  },
}
