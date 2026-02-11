local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.2.6"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    F.String.Menu.Performance() .. " tab in " .. TXUI.Title .. " settings",
    F.String.Retail() .. "Anchoring section in " .. F.String.CDM(),
    F.String.Retail() .. "Add option to sync Player Castbar width in " .. F.String.CDM(),
    F.String.Retail() --
      .. "Disabling Dynamic Width options in "
      .. F.String.CDM()
      .. " will restore previous width"
      .. F.String.Sublist("Will not save previous width if enabled before this update"),
    F.String.Retail() .. "Add Cooldown Manager slash commands to toggle settings" .. F.String.Sublist("/cd") .. F.String.Sublist("/cdm") .. F.String.Sublist("/wa"),

    "* Enhancements",
    F.String.Retail() .. "Display percentage mana for " .. F.String.Class("Arcane Mages", "MAGE") .. " with the " .. F.String.ToxiUI("[tx:power]") .. " tag",
    "Try displaying class icon when spec icon is not available for both " .. F.String.ToxiUI("[tx:classicon]") .. " tags" .. F.String.Sublist(
      "This is most noticeable in follower dungeons"
    ),

    "* Bug fixes",
    F.String.Retail() .. "Potentially fix Damage Meter Skin taint when opening damage breakdown",
    F.String.Retail() .. "Floor the dynamic bar width value for the " .. F.String.CDM(),
    F.String.Retail() .. "Improve fading logic for " .. F.String.CDM(),
    F.String.Retail() .. "Do not try to change Damage Meter icon if it has a spell ID",
    F.String.Retail() .. "Fix Damage Meter Skin's header fading due to " .. F.String.ElvUI() .. " changes",

    "* Profile updates",

    "* Documentation",
    F.String.Retail() .. "Update for patch 12.0.1",
    F.String.MinElv("15.05"),

    "* Settings refactoring",
    "Update " .. TXUI.Title .. " " .. F.String.ElvUI() .. " Skin description",
    "Update " .. F.String.CDM() .. " description",

    "* Development improvements",
    F.String.Retail() .. "Refactor " .. F.String.CDM() .. " for better structure",
  },
}
