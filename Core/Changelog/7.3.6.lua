local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.3.6"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",

    "* Enhancements",

    "* Bug fixes",
    "Fix racial spells not showing icon in hearthstone's additional flyout",

    "* Profile updates",
    "Set " .. F.String.ToxiUI("nameplateOccludedAlphaMult") .. " CVar to 0.8",
    F.String.ElvUI() .. ": Add nameplates castbar width/height settings to profile" .. F.String.Sublist("Previously it was using ElvUI default, so nothing changes."),

    "* Documentation",
    F.String.Retail() .. "Add Haranir Rootwalking to hearthstone module",
    F.String.Retail() .. "Track Voidlight Marl instead of Resonance Crystals by default",

    "* Settings refactoring",
    "Changelog: Category headers now render in uppercase",
    "Changelog: Update prefixes for in-game changelog entries" .. F.String.Sublist("Main list items are now using a bullet") .. F.String.Sublist(
      "Sub list items are now using a chevron"
    ),

    "* Development improvements",
    "Changelog: Remove unused " .. F.String.ToxiUI("DYNAMIC") .. " changelog field support",
    "Changelog: Archive all versions before v7.0.0" .. F.String.Sublist("This should reduce the addon size"),
  },
}
