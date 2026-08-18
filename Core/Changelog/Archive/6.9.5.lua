local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.9.5"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",
    "Scale 4k resolutions to 150% instead of 200% to mimic 1440p layout",

    "* New features",
    "Raid Info Frame",

    "* Bug fixes",
    "Update Pets collection text in Game Menu Skin when opening the menu",

    "* Profile updates",
    F.String.Plater() --
      .. ": Add these auras to manual tracking:"
      .. F.String.Sublist(F.String.Class("Chains of Ice", "DEATHKNIGHT"))
      .. F.String.Sublist(F.String.Class("Reaper's Mark", "DEATHKNIGHT"))
      .. F.String.Sublist(F.String.Class("Sigil of Flame", "DEMONHUNTER"))
      .. F.String.Sublist(F.String.Class("Fiery Brand", "DEMONHUNTER")),
    F.String.Plater() .. ": Add " .. F.String.Class("Sigil of Silence", "DEMONHUNTER") .. " to Special Auras tracking",

    "* Documentation",
    F.String.MinElv("13.91"),
    "Update for Patch 11.1.7",

    "* Settings refactoring",
    "Add " .. TXUI.Title .. " category to ElvUI movers dropdown filters",
    "Add " .. F.String.ToxiUI("ToxiUI Perfect Scale") .. " to Status Report window, indicating what UI scale the " .. TXUI.Title .. " installer would set",
  },
}
