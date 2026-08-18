local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["4.2.0"] = {
  CHANGES = {
    "* New features",
    "Changelog now features several versions for comparing",
    "Added warning to installer if you have SharedMedia: " .. TXUI.Title,
    "Added ToxiUI + version to the top of ElvUI panel",

    "* Bug fixes",
    "Fixed Details not properly applying profile",
    "Pet and ToT frames now position correctly on all resolutions",

    "* Profile updates",
    "Removed the 1px border from ToxiUI texture",
    "Changed login message link",
    "Made Player castbar shorter",
    "Moved Player castbar 1px to right",
    "Slight positioning/size adjustments for Details",
    "XIV Databar color now has Gradient fade (need to change alpha to see the change)",

    "* Development improvements",
    "Changes to Plater import logic (similar to Details)",
  },
}
