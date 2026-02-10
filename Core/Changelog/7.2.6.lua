local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.2.6"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    F.String.Menu.Performance() .. " tab in " .. TXUI.Title .. " settings",
    F.String.Retail() .. "Anchoring section in " .. F.String.CDM(),

    "* Enhancements",
    F.String.Retail() .. "Display percentage mana for " .. F.String.Class("Arcane Mages", "MAGE") .. " with the " .. F.String.ToxiUI("[tx:power]") .. " tag",
    "Try displaying class icon when spec icon is not available for both " .. F.String.ToxiUI("[tx:classicon]") .. " tags" .. F.String.Sublist(
      "This is most noticeable in follower dungeons"
    ),

    "* Bug fixes",
    F.String.Retail() .. "Potentially fix Damage Meter Skin taint when opening damage breakdown",
    F.String.Retail() .. "Floor the dynamic bar width value for the " .. F.String.CDM(),

    "* Profile updates",

    "* Documentation",
    F.String.Retail() .. "Enable " .. TXUI.Title .. " for 12.0.1 without testing, in case it works and NA can enjoy launch",

    "* Settings refactoring",
    "Update " .. TXUI.Title .. " " .. F.String.ElvUI() .. " Skin description",
    "Update " .. F.String.CDM() .. " description",

    "* Development improvements",
  },
}
