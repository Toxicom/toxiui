local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.9.9"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",
    "Disable " .. TXUI.Title .. " " .. F.String.Menu.Armory() .. " for Mists of Pandaria: Classic",

    "* Bug fixes",
    "Fix updated E:CropRatio function",

    "* Profile updates",
    F.String.Plater() .. ": Update interrupt color mod",
    F.String.Plater() .. ": Update NPC colors" .. F.String.Sublist("No longer using Continuity's M+ Mod") .. F.String.Sublist("Instead using Fatpala's Reloe color scheme"),

    "* Documentation",
    F.String.MinElv("13.95"),
    F.String.Menu.WunderBar() .. ": Update M+ Portals for TWW S3",

    "* Development improvements",
    "Simplify logic for checking loaded addons",
  },
}
