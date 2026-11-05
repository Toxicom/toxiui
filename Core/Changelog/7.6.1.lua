local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.6.1"] = {
  HOTFIX = true,
  RELEASE_DATE = "",
  CHANGES = {
    "* Breaking changes",

    "* New features",
    F.String.Forever() .. F.String.Menu.Armory() .. " support" .. F.String.Sublist("Styles the Forever character sheet, its stats list and the ranged slot"),

    "* Enhancements",

    "* Bug fixes",
    "Additional Scaling: Fixed an error when opening the Collections window in combat",
    F.String.Era() .. F.String.Anniversary() .. F.String.Forever() .. F.String.GradientMode() .. ": Power colors were missing from the settings",
    F.String.Forever()
      .. "Support for first & last character names"
      .. F.String.Sublist(
        "Gold, played time, the " .. F.String.ToxiUI("AFK") .. " screen & " .. F.String.ToxiUI("Game Menu") .. " now use your full name and no longer show internal realm names"
      ),

    "* Profile updates",

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
  },
}
