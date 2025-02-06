local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.7.1"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",
    "ActionBars and UnitFrames styles no longer persist through installations",

    "* New features",
    "Option to change Unitframe textures in Gradient mode" .. F.String.Sublist(F.String.Menu.Themes() .. " -> Gradient Mode -> Settings"),
    "Allow changing Details textures in Gradient mode",
    F.String.Menu.Armory() .. " Attributes updates:" .. F.String.Sublist("Option to abbreviate and shorten label") .. F.String.Sublist(
      "Attribute icons! " .. F.String.ConvertGlyph(59728)
    ),
    "Controls for Gradient mode's Saturation Boost" .. F.String.Sublist(F.String.Menu.Themes() .. " -> Gradient Mode -> Settings"),

    "* Bug fixes",
    "Fix " .. TXUI.Title .. " icon's in WunderBar tooltip",
    "Remove " .. F.String.BigWigs() .. " call on Private profile update",

    "* Profile updates",
    "Update default ilvl font for " .. F.String.Menu.Armory() .. " in |cffe35f00Cataclysm|r",

    "* Documentation",
    F.String.MinElv("13.70"),

    "* Development improvements",
    "Clean up unused code",
    "Remove AceConfigHelper library, since " .. F.String.ElvUI() .. " provides it",
    "Display a clear message to the user when " .. F.String.ElvUI() .. " does not meet minimum required version",
  },
}
