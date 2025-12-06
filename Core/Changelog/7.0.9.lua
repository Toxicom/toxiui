local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.0.9"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    "Add " .. F.String.ToxiUI("Teleport Home") .. " functions to Hearthstone and MicroMenu modules in " .. F.String.Menu.WunderBar() .. F.String.Sublist(
      "Currently, the \"Return To Previous Location\" functionality is being tainted, so it's not possible to implement."
    ),

    "* Bug fixes",
    "Remove right-click from SpecSwitch module in Classic Era",

    "* Profile updates",

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
  },
}
