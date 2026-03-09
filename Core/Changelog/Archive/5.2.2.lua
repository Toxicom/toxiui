local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["5.2.2"] = {
  HOTFIX = true,
  CHANGES = {
    "* Bug fixes",
    "GameMenu: Disabling the module now actually disables the button",
    F.String.Menu.Armory() .. ": Now displays missing enchant string for dual-wield",
    "Deconstruct: Fixed LUA error if ElvUI bags are disabled",
    "WunderBar: Fixed a bug related to changing profiles or disabling/enabling WB",
  },
}
