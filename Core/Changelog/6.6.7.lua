local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.6.7"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",

    "* Bug fixes",
    "Fix Incandescent Essence enchant in Armory" --
      .. F.String.Sublist("Had to disable gradient text on enchant strings")
      .. F.String.Sublist("Now has option for class color or default green"),
    "Improve logic for class color",

    "* Profile updates",
    "Fix Raid UnitFrames overlapping" --
      .. F.String.Sublist("Change Growth direction for Horizontal layout")
      .. F.String.Sublist("Change Raid 3 frame size to match other raid frames"),

    "* Documentation",
    F.String.MinElv("13.66"),

    "* Settings refactoring",

    "* Development improvements",
  },
}
