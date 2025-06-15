local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.9.5"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

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

    "* Settings refactoring",
    "Add " .. TXUI.Title .. " category to ElvUI movers dropdown filters",

    "* Development improvements",
  },
}
