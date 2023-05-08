local TXUI, F, E, I, V, P, G = unpack(select(2, ...))

TXUI.Changelog["6.2.1"] = {
  HOTFIX = true,
  CHANGES = {
    "* ToxiUI",
    "WunderBar: Fixed Time module by populating its virtual frame with animation-related dummy functions. Credits to " .. F.String.Beta("Stiimo"),
    "Installer: Changed dialog's information for a better UX",
    "Misc: Add ToxiUI Addon Compartment. Credits to " .. F.String.Class("Knuffelpanda", "MONK"),
    "* BigWigs",
    "Add support for 3440x1440",
    "Add support for 1920x1080 " .. F.String.Error("[DPS Only for now]"),
    "* DBM",
    F.String.Error("Removed") .. " Deadly Boss Mods",
  },
}
