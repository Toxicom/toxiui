local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.5.7"] = {
  HOTFIX = true,
  CHANGES = {
    "* Bug fixes",
    "Improve ColorModifiers logic",

    "* Profile updates",
    "Update Plater mods",

    "* Documentation",
    "Increase minimum required " .. F.String.ElvUI() .. " version to 13.59",
    "Add Stone of the Hearth to WunderBar Hearthstones",
  },
}
