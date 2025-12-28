local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.0.9"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    "Add " .. F.String.ToxiUI("Teleport Home") .. " functions to Hearthstone and MicroMenu modules in " .. F.String.Menu.WunderBar() .. F.String.Sublist(
      "Currently, the \"Return To Previous Location\" functionality is being tainted, so it's not possible to implement."
    ),
    "Bring back Skyriding Bar for "
      .. TXUI.Title
      .. " Vehicle Bar"
      .. F.String.Sublist("Now uses spell charges from Skyward Ascent instead of the old vigor bar")
      .. F.String.Sublist("Displays current spell charges with smooth animations")
      .. F.String.Sublist("Configurable textures for Normal, Gradient and Dark modes")
      .. F.String.Sublist("Custom gradient color options (defaults to class color gradient)"),

    "* Bug fixes",
    "Remove right-click from SpecSwitch module in Classic Era",

    "* Profile updates",

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
  },
}
