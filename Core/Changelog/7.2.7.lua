local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.2.7"] = {
  HOTFIX = true,
  RELEASE_DATE = "Feb 11, 2026",
  CHANGES = {
    "* New features",
    F.String.Retail() .. F.String.CDM() .. " Keybinds",

    "* Enhancements",
    F.String.Retail() .. "Disable " .. F.String.CDM() .. " by default",

    "* Bug fixes",
    F.String.Retail() .. "Do not anchor " .. F.String.CDM() .. " essentials when power bar is disabled",

    "* Development improvements",
    "Rename all internal cases of referencing game versions",
  },
}
