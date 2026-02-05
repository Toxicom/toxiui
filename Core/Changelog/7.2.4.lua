local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.2.4"] = {
  HOTFIX = true,
  CHANGES = {
    "* New features",
    "Replace the "
      .. TXUI.Title
      .. " installer's Turbo Mode with Import Existing, where it finds existing profiles and suggests using the newest one" --
      .. F.String.Sublist("This should make setting up alts easier")
      .. F.String.Sublist("Please note that this feature does not include any other addon profiles, only the ElvUI profiles"),

    "* Enhancements",
    F.String.Retail() .. "Display mana percentage for healers in " .. F.String.ToxiUI("[tx:power]") .. " tag",

    "* Documentation",
    "Add " .. F.String.Epic("evilknivel") .. " to the contributors list",
    "Add " .. F.String.Epic("Exodus") .. " to the contributors list",

    "* Settings refactoring",
    "Add more spacing between changelog categories for improved readability",

    "* Development improvements",
    "Create table for Retail Specialization IDs for easier referencing",
  },
}
