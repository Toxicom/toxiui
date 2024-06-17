local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.3.0"] = {
  HOTFIX = false,
  CHANGES = {
    "* Breaking changes",
    F.String.Error("Warning: ") .. "Removed most cases of '" .. F.String.ToxiUI("- Steelfish") .. "' font and replaced them with Primary font.",
    F.String.Error("Warning: ") .. "Removed '" .. F.String.ToxiUI("Futura") .. "' and most of '" .. F.String.ToxiUI("Montserrat") .. "' font variants",

    "* New features",
    "Release ToxiUI Vanilla",
    "UnitFrame Class Icons",
    "Stylized icons " .. F.String.Class("(icons8.com)", "ROGUE") .. " for Dead and Disconnected state to match UnitFrame class icons",
    "Combat icon for Player UnitFrame " .. F.String.Class("(icons8.com)", "ROGUE"),
    "UnitFrame style in the installer",
    "Primary font",
    "The installer now has images! Let's see how quickly they get outdated ;)",

    "* Profile updates",
    "Enable instance difficulty fader for Player & Pet UnitFrames",
    "Customize widget skinning with a new '" .. F.String.ToxiUI("- Tx Fade") .. "' texture & enabled class colors",
    "Enable the ElvUI theme skin from " .. TXUI.Title .. " (was disabled by default previously)",
    "Properly disable the " .. TXUI.Title .. F.String.ToxiUI(" FadePersist") .. " module when ElvUI ActionBars are disabled",
    "Properly disable the " .. TXUI.Title .. F.String.ToxiUI(" VehicleBar") .. " module when ElvUI ActionBars are disabled",
    "Change Player Castbar Strata level so it's below Combat Icon",
    "Update " .. F.String.ToxiUI("Interrupt not ready Cast Color") .. " mod for Plater",

    "* Bug fixes",
    "Fix " .. TXUI.Title .. F.String.Menu.Armory() .. " module's item level colors bug",
    "Add missing Augmentation Evoker data & icons. Credits to " .. F.String.WunderUI(),

    "* Development improvements",
    "Refactor icons to use unicode decimal instead of glyph. Credits to " .. F.String.WunderUI(),
  },
}
