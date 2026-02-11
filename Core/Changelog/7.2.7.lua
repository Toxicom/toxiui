local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.2.7"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",

    "* Enhancements",

    "* Bug fixes",
    F.String.Retail() .. "Disable " .. F.String.CDM() .. " Castbar sync by default",

    "* Profile updates",

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
    "Rename all internal cases of referencing game versions",
  },
}
