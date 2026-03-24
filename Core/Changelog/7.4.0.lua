local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.4.0"] = {
  HOTFIX = true,
  RELEASE_DATE = "Mar TBD, 2026",
  CHANGES = {
    "* Breaking changes",

    "* New features",

    "* Enhancements",
    "Profile Updater: Display color differences as a single HEX unit instead of separate R G B units",
    F.String.Retail() .. F.String.CDM() .. ": Slightly stabler code due to using built-in Blizzard API instead of self made stuff",
    "Gradient mode: Cache some function closures for potentially better performance",

    "* Bug fixes",
    "Gradient mode: Safer castbar coloring code",

    "* Profile updates",
    F.String.ElvUI() .. " Movers: Move raid frames",
    F.String.ElvUI() .. " Unitframes: Re-position and re-size private auras for raid frames",
    F.String.ElvUI() .. " Unitframes: Re-position buffs and role icon for party frames",
    F.String.Retail() .. F.String.CDM() .. ": Update keybind frame level to avoid situations where it's behind power bar",

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
  },
}
