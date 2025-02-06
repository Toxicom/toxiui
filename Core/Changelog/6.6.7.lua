local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.6.7"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",
    "Remove " .. F.String.ToxiUI("[tx:group:raid]") .. " tag" .. F.String.Sublist("It was buggy and not used anywhere"),

    "* New features",
    "Decorative lines in " .. F.String.Menu.Armory(),
    "Random names & class icons in UnitFrame preview" --
      .. F.String.Sublist("Requires at least ElvUI 13.67"),

    "* Bug fixes",
    "Fix Incandescent Essence enchant in "
      .. F.String.Menu.Armory() --
      .. F.String.Sublist("Had to disable gradient text on enchant strings")
      .. F.String.Sublist("Now has option for class color or default green"),
    "Improve logic for class color",

    "* Profile updates",
    "Fix Raid UnitFrames overlapping" --
      .. F.String.Sublist("Change Growth direction for Horizontal layout")
      .. F.String.Sublist("Change Raid 3 frame size to match other raid frames"),

    "* Documentation",
    F.String.MinElv("13.66"),

    "* Development improvements",
    "Refactor Raid Frames profile" --
      .. F.String.Sublist("Raid frames are now identical except for visibility field"),
  },
}
