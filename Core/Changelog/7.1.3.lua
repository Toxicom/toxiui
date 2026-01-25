local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.1.3"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",
    "Remove Gradient Mode" .. F.String.Sublist("Gradient Mode might return in a future release, uncertain for now."),
    "Remove and refactor a lot of the Text Tags",

    "* New features",
    "Animations plugin" --
      .. F.String.Sublist("Animate the opening of Blizzard frames")
      .. F.String.Sublist("Enabled by default")
      .. F.String.Sublist("Can be configured per-frame in Animations settings")
      .. F.String.Sublist(TXUI.Title .. " Settings -> Plugins -> Animations"),
    "Smooth Bars toggles section" .. F.String.Sublist("Skins -> ElvUI -> Smooth Bars"),

    "* Bug fixes",
    "Fixed Dark Mode's transparency issue with class color backdrop",
    "Fixed Dark Mode's transparency issues with changed ElvUI structure",
    "Potentially fix SpecSwitch icons not showing for Classic versions",

    "* Profile updates",
    TXUI.Title .. ": Updated Dark Mode profile, is now closer to gradient mode profile",
    F.String.ElvUI() .. ": Updated profile for new cooldown settings",
    F.String.ElvUI() .. ": Updated which text tags are being used",
    F.String.ElvUI() .. ": Use 3:2 aspect ratio for action bars and auras instead of 4:3",

    "* Documentation",
    F.String.MinElv("14.07"),
    "Update Random Tips",
    "Update for Midnight 12.0.0",

    "* Settings refactoring",

    "* Development improvements",
    "Stabler installer Turbo Mode",
  },
}
