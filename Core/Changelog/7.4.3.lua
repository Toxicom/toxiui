local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.4.3"] = {
  HOTFIX = true,
  RELEASE_DATE = "",
  CHANGES = {
    "* Breaking changes",

    "* New features",

    "* Enhancements",
    "Vehicle Bar buttons will respect " .. F.String.ElvUI() .. "'s Pick Up Action Key" .. F.String.Sublist("SHIFT by default"),
    F.String.Retail() .. F.String.CDM() .. ": Remove dynamic adjustment of class bar spacing",

    "* Bug fixes",

    "* Profile updates",
    F.String.ElvUI() .. " Unitframes: Update leader icon position for horizontal party unitframes",

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
  },
}
