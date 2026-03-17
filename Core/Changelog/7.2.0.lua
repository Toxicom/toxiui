local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.2.0"] = {
  HOTFIX = false,
  RELEASE_DATE = "Jan 25, 2026",
  CHANGES = {
    "* Breaking changes",
    "Remove Gradient Mode" .. F.String.Sublist("Gradient Mode might return in a future release, uncertain for now."),
    "Remove and refactor a lot of the Text Tags",
    "This patch is major, therefore you will be forced to run the installer again",
    "Remove " .. F.String.Plater() .. " profile" .. F.String.Sublist(
      "With scripting and modding being limited by Blizzard, we no longer see the upside of using Plater vs ElvUI Nameplates."
    ),
    "Remove WeakAuraAnchor module and related code",
    "Remove all mentions of WeakAuras" .. F.String.Sublist("RIP"),

    "* New features",
    "Animations plugin" --
      .. F.String.Sublist("Animate the opening of Blizzard frames")
      .. F.String.Sublist("Enabled by default")
      .. F.String.Sublist("Can be configured per-frame in Animations settings")
      .. F.String.Sublist(TXUI.Title .. " Settings -> Plugins -> Animations"),
    "Smooth Bars toggles section" .. F.String.Sublist("Skins -> ElvUI -> Smooth Bars"),
    "Profile for " .. F.String.ElvUI() .. " Nameplates",

    "* Bug fixes",
    "Fixed Dark Mode's transparency issue with class color backdrop",
    "Fixed Dark Mode's transparency issues with changed ElvUI structure",
    "Potentially fix SpecSwitch icons not showing for Classic versions",

    "* Profile updates",
    TXUI.Title .. ": Updated Dark Mode profile, is now closer to gradient mode profile",
    F.String.ElvUI() .. ": Updated profile for new cooldown settings",
    F.String.ElvUI() .. ": Updated which text tags are being used",
    F.String.ElvUI() .. ": Use 3:2 aspect ratio for action bars and auras instead of 4:3",
    F.String.ElvUI() .. ": UnitFrame Class backdrop for Dark Mode",
    F.String.ElvUI() .. ": By default show Power & Class bars with new position" .. F.String.Sublist(
      "Classic action bars style now no longer repositions power & class bars, as they are now in the same position by default."
    ),

    "* Documentation",
    F.String.MinElv("15.00"),
    "Update Random Tips",
    "Update for Midnight 12.0.0",

    "* Development improvements",
    "Stabler installer Turbo Mode",
  },
}
