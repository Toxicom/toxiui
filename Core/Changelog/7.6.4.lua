local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.6.4"] = {
  HOTFIX = true,
  RELEASE_DATE = "Nov 23, 2026",
  CHANGES = {
    "* Bug fixes",
    "Friendly Nameplates no longer have a max width as their names aren't secret",
    F.String.Forever() .. "SpecSwitch & " .. F.String.Menu.Armory() .. " now show your class icon instead of the default icon",
    "Fix Status Report, Profile Updater and Landing Page buttons using the default WoW font",
  },
}
