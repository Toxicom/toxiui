local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.5.5"] = {
  HOTFIX = true,
  RELEASE_DATE = "",
  CHANGES = {
    "* Breaking changes",

    "* New features",

    "* Enhancements",

    "* Bug fixes",
    F.String.Retail() .. "Damage Meter: Follow the new Blizzard session window layout" .. F.String.Sublist(
      "Spell breakdown and floating player entry now use GetSourceWindow / GetLocalPlayerEntry"
    ),

    "* Profile updates",
    F.String.WindTools() .. ": Keep the Damage Meter header visible by default" .. F.String.Sublist(
      "Header fade is handled by WindTools 4.21; mouseover is still available in WindTools settings"
    ),

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
  },
}
