local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.0.7"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",
    "Remove the " .. TXUI.Title .. " Vigor Bar & Speed Text" .. F.String.Sublist("Vigor no longer exists, instead skyriding spells have charges with cooldown"),

    "* New features",

    "* Bug fixes",
    "Half-baked patch fixes for Classic Era",

    "* Profile updates",

    "* Documentation",
    "Update .toc for Classic Era patch 1.15.8",
    "Update .toc for Mists of Pandaria patch 5.5.2",
    "Update .toc for The War Within patch 11.2.7",
    F.String.MinElv("14.03"),

    "* Settings refactoring",

    "* Development improvements",
  },
}
