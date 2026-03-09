local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["5.0.0"] = {
  CHANGES = {
    "* New features",
    "|cff2684ffAFK Mode|r",
    "|cffb6f030Font Scaling|r",
    "|cffd4fff9WunderBar|r",
    "New rest icon by |cffff7c0aReleaf|r",
    "New combat icon by |cffff7c0aReleaf|r",
    "New Party role icons by " .. TXUI.Title,
    "New Party Dead icon by " .. TXUI.Title,
    "New Party Disconnected icon by " .. TXUI.Title,

    "* Bug fixes",
    "Fix conflict between Dark Mode and |cffff97f6G|r|cfff8b0f2ra|r|cfff5c6f1di|r|cfff3d9f1en|r|cffffeafdt|r Mode",
    "Fix a bug with WA icon skinning",
    "Force disable Parchment Remover",
    "Fix Pet/ToT frames anchors after toggling Dark Mode",
    "Fixed castbar alignment on 1440p",

    "* Profile updates",
    "Disable AddOnSkins embed settings",
    "Raid Frame changes across both layouts",
    "Fixes for ActionBars fonts",
    "Changed Absorb color",
    "More buffs show up, prioritise others' buffs",
    "Changed Disconnected unitframe color",
    "Fix Bag Items font",
    "Reverted Chat to how it was before v4.3.5",
    "Disable Chat Link in " .. F.String.WindTools(),
    "MM:SS Threshold increased to 5min",
    "Macro text enabled for Bar 1",
    "Blizz UI Widgets moved",
    "Arena frame tweaks",
    "Enabled Dead backdrop",
    "Fixed Quest tracker fonts",
    "Smaller Plater font size",
    "Changes to BW & DBM DPS layout",

    "* Development improvements",
    "Force /reload after closing installer with changes made",
  },
}
