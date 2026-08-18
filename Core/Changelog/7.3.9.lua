local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.3.9"] = {
  HOTFIX = true,
  RELEASE_DATE = "Mar 23, 2026",
  CHANGES = {
    "* New features",
    TXUI.Title .. " Landing pages" .. F.String.Sublist("Will show a landing page on fresh install for some instructions") .. F.String.Sublist(
      "Will show a landing page on addon update to remind about the Profile Updater feature"
    ),

    "* Enhancements",
    F.String.Retail() .. F.String.CDM() .. ": Round up bar width to potentially have better pixel perfect alignment",

    "* Profile updates",
    F.String.ElvUI() .. " Unitframes: Update raid frames design",

    "* Documentation",
    F.String.Retail() .. "Armory: Adjust which slots require enchants/sockets for Midnight",
  },
}
