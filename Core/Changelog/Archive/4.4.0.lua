local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["4.4.0"] = {
  CHANGES = {
    "* New features",
    "WeakAuras progress bars now automatically have borders on them!",

    "* Bug fixes",
    "Fixes to XIV Databar not showing after leaving combat",

    "* Profile updates",
    "DBM/BW changes for positioning",
    "Changes to Party and Raid frames",
    "Other misc. changes",

    "* Development improvements",
    "Will now detect if user is using the correct private profile and offer to update it if not",
    "Installer no longer removes profiles other than 'Default' from XIV Databar",
    "We no longer need Skin All Icons WeakAura, added a warning if you still have it",
  },
}
