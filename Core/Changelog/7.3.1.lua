local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.3.1"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    "Total time played information shown in " .. TXUI.Title .. " Game Menu Skin" .. F.String.Sublist("Credits to " .. F.String.Kryo()),
    "Add " .. F.String.ToxiUI("KMT47") .. " statusbar texture" .. F.String.Sublist("Credits to kringel"),

    "* Enhancements",
    "Set 0.65 UI scale for non-standard resolutions",
    "Update default " --
      .. F.String.GradientString()
      .. " color for "
      .. F.String.Class("Paladin", "PALADIN")
      .. F.String.Sublist("Old values:")
      .. F.String.Sublist("To: #f58cba"),
    "Update default " --
      .. F.String.GradientString()
      .. " color for "
      .. F.String.Class("Mage", "MAGE")
      .. F.String.Sublist("Old values:")
      .. F.String.Sublist("To: #33c7fc"),
    "Bring back Gradient Mode to " .. TXUI.Title .. " Status Report window",
    "Re-designed Status Report window",
    "Add a global toggle for the " .. F.String.CDM() .. F.String.Sublist("You will need to re-enable the CDM skin, as it's off by default"),
    "Allow updating " .. F.String.CDM() .. " options without requiring a reload of the UI",

    "* Bug fixes",
    F.String.Retail() .. "Improve anchoring and keybinds logic of " .. F.String.CDM(),
    F.String.Retail() .. F.String.Anniversary() .. "Fix error when disabling " .. F.String.GradientString() .. " mode",
    F.String.Retail() .. "Fix an icon indexing issue with " .. F.String.CDM() .. F.String.Sublist("Credits to " .. F.String.Kryo()),

    "* Profile updates",
    F.String.Retail() .. F.String.WindTools() .. ": Enable and update the Cooldown Viewer skin",

    "* Documentation",

    "* Settings refactoring",
    "Update description of " .. TXUI.Title .. " " .. F.String.ElvUI() .. " Skin",

    "* Development improvements",
    "Refactor Game Menu Skin as it's own module with subfolder structure",
    "Refactor code for Status Report, makes it easier to add/remove lines and sections",
  },
}
