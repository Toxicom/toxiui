local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.0.9"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    "Bring back Skyriding Bar for "
      .. TXUI.Title
      .. " Vehicle Bar"
      .. F.String.Sublist("Now uses spell charges from Skyward Ascent instead of the old vigor bar")
      .. F.String.Sublist("Displays current spell charges with smooth animations")
      .. F.String.Sublist("Configurable textures for Normal, Gradient and Dark modes")
      .. F.String.Sublist("Custom gradient color options (defaults to class color gradient)")
      .. F.String.Sublist("Speed Text has more customization options"),
    "Difficulty display and Total player count in Raid Info Frame",

    "* Bug fixes",
    "Remove right-click from SpecSwitch module in Classic Era",
    "Potentially fix disappearing Vehicle Bar empty buttons",
    "Add InCombatLockdown protection for Additional Scaling modules",

    "* Profile updates",
    F.String.ElvUI() .. ": Adjust Raid 1 visibility state",

    "* Documentation",
    "Update for Mists of Pandaria 5.5.3",
    F.String.MinElv("14.05"),

    "* Settings refactoring",

    "* Development improvements",
  },
}
