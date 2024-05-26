local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.6.6"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    F.String.Scaling() .. " for Item Upgrade & Catalyst UIs",
    F.String.Scaling() .. " for Auction House",
    F.String.Scaling() .. " option to increase Transmog frame width" .. F.String.Sublist("Retail only"),
    "Add " .. F.String.Scaling() .. " button to Reset section",
    "Abbreviate Level text option in Armory",
    F.String.ToxiUI("Hide Frames")
      .. " module" --
      .. F.String.Sublist(F.String.FastGradientHex("Miscellaneous", "#b085f5", "#4d2c91") .. " -> " .. F.String.Class("Hide Frames"))
      .. F.String.Sublist("Currently only has the Loot Frame (Retail only)"),

    "* Bug fixes",
    "Show Missing Belt enchant in Armory",
    "Remove 'Missing' text in Armory for Pandaria Remix",

    "* Profile updates",
    "Fix Raid 2 not seeing 6th group",

    "* Documentation",
    "Update Disenchant exlude list for Deconstruct",
    "Increase max level in Cata",

    "* Settings refactoring",

    "* Development improvements",
    F.String.MinElv("13.65"),
  },
}
