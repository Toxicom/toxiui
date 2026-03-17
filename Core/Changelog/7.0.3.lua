local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.0.3"] = {
  HOTFIX = true,
  RELEASE_DATE = "Sep 26, 2025",
  CHANGES = {
    "* New features",
    "Add options to toggle Keybind & Macro texts on Vehicle Bar buttons",

    "* Profile updates",
    "Update ElvUI filter names to account for 14.00 changes",
    "Disable new \"Custom\" auras on Target UnitFrame"
      .. F.String.Sublist("The same information is already provided via Plater's \"Buff Special\", so repeated information seems redundant."),

    "* Documentation",
    "Update .toc for Mists of Pandaria Classic",
    F.String.MinElv("14.00"),
  },
}
