local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.9.0"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",
    "Change the name of all custom texts that " .. TXUI.Title .. " uses" .. F.String.Sublist("We did an automatic database conversion so nothing should break"),
    "If you're experiencing issues due to some custom texts not being converted properly, follow these steps:"
      .. F.String.Sublist("Logout from your character")
      .. F.String.Sublist("Open this file in your WoW directory: WTF/Account/<ACCOUNT_ID>/SavedVariables/ElvUI.lua")
      .. F.String.Sublist("Find a line that says " .. F.String.ToxiUI("[\"lastDBConversion\"] = \"6.9.0\""))
      .. F.String.Sublist("Change 6.9.0 to 6.8.8")
      .. F.String.Sublist("Save the file & log back in to your character")
      .. F.String.Sublist("This should have triggered the database conversion one more time"),
    "Remove "
      .. F.String.ToxiUI("- Steelfish")
      .. " font" --
      .. F.String.Sublist("We haven't used that font since 6.3.0")
      .. F.String.Sublist("If you're still using it, add it yourself via SharedMedia"),
    "Remove Korean glyphs from our fonts" --
      .. F.String.Sublist("This is a decision I've been thinking about for a long time, sorry fellow Korean players")
      .. F.String.Sublist("Korean glyphs made the font files huge which impacted loading times severely")
      .. F.String.Sublist("You can find old font files in GitHub"),
    "No longer set " .. F.String.ToxiUI("Classic ActionBars Style") .. " on Classic Era version during the " .. TXUI.Title .. " installer, since Luxthos now has WeakAuras",

    "* New features",
    "Collections in Game Menu Skin" .. F.String.Sublist("Retail only"),
    "Updated "
      .. F.String.Plater()
      .. " design" --
      .. F.String.Sublist("Reduced height of health & cast bars")
      .. F.String.Sublist("Changed fonts to ToxiUI")
      .. F.String.Sublist("Reduced health font size")
      .. F.String.Sublist("Reduced hover target alpha")
      .. F.String.Sublist("Change bar texture")
      .. F.String.Sublist("Enable guild name for friendly player nameplates")
      .. F.String.Sublist("Fixed scaling issue"),

    "* Profile updates",
    F.String.Plater() .. ": Add " .. F.String.Class("Barbed Shot", "HUNTER") .. " to manual buff tracking",
    F.String.Plater() .. ": Add " .. F.String.Class("Explosive Shot", "HUNTER") .. " to manual buff tracking",
    F.String.ElvUI() .. ": Make Shamans blue for Classic Era",

    "* Documentation",
    "Update links to " .. TXUI.Title .. " WeakAuras guide",
    "Update for Patch 11.0.7",
    "Update for Patch 4.4.1",
    "Update for Patch 1.15.6",
    F.String.MinElv("13.83"),

    "* Settings refactoring",
    "Allow Gradient mode's background brightness to go to 0",
    "Add links to " .. F.String.Luxthos() .. " WeakAuras in the installer for Classic Era",
  },
}
