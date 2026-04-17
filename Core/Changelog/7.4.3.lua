local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.4.3"] = {
  HOTFIX = true,
  RELEASE_DATE = "Apr 18, 2026",
  CHANGES = {
    "* Enhancements",
    "Vehicle Bar buttons will respect " .. F.String.ElvUI() .. "'s Pick Up Action Key" .. F.String.Sublist("SHIFT by default"),
    F.String.Retail() .. F.String.CDM() .. ": Remove dynamic adjustment of class bar spacing",

    "* Profile updates",
    F.String.ElvUI() .. " Unitframes: Update leader icon position for horizontal party unitframes",
  },
}
