local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.2.1"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",
    F.String.Error("Removed") .. " Deadly Boss Mods",

    "* New features",
    "Misc: Add " .. TXUI.Title .. " Addon Compartment. Credits to " .. F.String.Class("Knuffelpanda", "MONK"),
    "Add support for BigWigs on 3440x1440 resolution",
    "Add support for BigWigs on 1920x1080 resolution" .. F.String.Error("[DPS Only for now]"),

    "* Bug fixes",
    "WunderBar: Fixed Time module by populating its virtual frame with animation-related dummy functions. Credits to " .. F.String.Beta("Stiimo"),

    "* Documentation",
    "Installer: Changed dialog's information for a better UX",
  },
}
