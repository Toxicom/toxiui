local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.4.0"] = {
  HOTFIX = true,
  RELEASE_DATE = "Mar 25, 2026",
  CHANGES = {
    "* Breaking changes",
    F.String.Retail()
      .. "Damage Meter: Remove the option for header fade"
      .. F.String.Sublist("This functionality exists in WindTools (and is most likely better), no reason to maintain it")
      .. F.String.Sublist(
        "The only downside is that settings for it are stored in the private profile, so you will have to re-apply this for every character, if you're using separate private profiles"
      ),

    "* Enhancements",
    "Profile Updater: Display color differences as a single HEX unit instead of separate R G B units",
    "Profile Updater: Add open & close animations",
    F.String.Retail() .. F.String.CDM() .. ": Slightly stabler code due to using built-in Blizzard API instead of self made stuff",
    F.String.Retail() .. F.String.CDM() .. ": Update keybind frame level to avoid situations where it's behind power bar",
    F.String.GradientMode() .. ": Cache some function closures for potentially better performance",
    "Landing Page: Show profile updater button in update landing page",
    "Landing Page: Display images for both landing pages",

    "* Bug fixes",
    F.String.GradientMode() .. ": Safer castbar coloring code",
    F.String.Menu.WunderBar() .. " Flyouts: Grow flyouts right when the module is in a left slot",
    F.String.Menu.WunderBar() .. " Hearthstone: Fix re-enabling additional teleports",

    "* Profile updates",
    F.String.ElvUI() .. " Movers: Move raid frames",
    F.String.ElvUI() .. " Movers: Adjust action bars positions",
    F.String.ElvUI() .. " Unitframes: Re-position and re-size private auras for raid frames",
    F.String.ElvUI() .. " Unitframes: Re-position buffs and role icon for party frames",
    F.String.ElvUI() .. " Action Bars: Adjust buttons per row and button spacing",
    F.String.WindTools() .. ": Change Damage Meter texture to KMT47",
    F.String.WindTools() .. ": Setup Damage Meter fading options",

    "* Documentation",
    F.String.MinElv("15.10"),
  },
}
