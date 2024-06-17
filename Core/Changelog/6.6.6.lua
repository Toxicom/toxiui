local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.6.6"] = {
  HOTFIX = true,
  CHANGES = {
    "* New features",
    F.String.Scaling() .. " for Item Upgrade & Catalyst UIs",
    F.String.Scaling() .. " for Auction House",
    F.String.Scaling() .. " option to increase Transmog frame width" .. F.String.Sublist("Retail only"),
    "Add " .. F.String.Scaling() .. " button to Reset section",
    "Abbreviate Level text option in " .. F.String.Menu.Armory(),
    F.String.ToxiUI("Hide Frames") .. " module" .. F.String.Sublist(F.String.Menu.Plugins() .. " -> " .. F.String.Class("Hide Frames")) .. F.String.Sublist(
      "Currently only has the Loot Frame (Retail only)"
    ),
    TXUI.Title .. " Health Tag option to display full health value instead of percentage" .. F.String.Sublist("Disabled by default") .. F.String.Sublist("Styles -> UnitFrame"),

    "* Bug fixes",
    "Show Missing Belt enchant in " .. F.String.Menu.Armory(),
    "Remove 'Missing' text in " .. F.String.Menu.Armory() .. " for Pandaria Remix",

    "* Profile updates",
    "Fix Raid 2 not seeing 6th group",

    "* Documentation",
    "Update Disenchant exlude list for Deconstruct",
    "Increase max level in Cata",
    F.String.MinElv("13.65"),
  },
}
