local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.8.3"] = {
  HOTFIX = true,
  CHANGES = {
    "* New features",
    "Add Friends frame to " .. F.String.Scaling(),

    "* Bug fixes",
    "Band-aid fix for " .. F.String.Menu.WunderBar() .. " Profession flyout's Herbalism icon freaking out",
    "Fix Dark Mode Gradient Names requirements erroring out",

    "* Documentation",
    "Replace Wooly Mammoth with Traveler's Tundra Mammoth in " .. F.String.Menu.WunderBar() .. " Durability module",
  },
}
