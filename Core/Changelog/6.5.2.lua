local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.5.2"] = {
  HOTFIX = true,
  CHANGES = {
    "* New features",
    "Add option to toggle the ActionBars Fade visibility when in a Vehicle or DragonRiding"
      .. F.String.Sublist(F.String.Menu.Skins() .. " -> " .. F.String.Class("ElvUI") .. " -> " .. F.String.Class("ActionBars Fade", "ROGUE")),
    "Add Right Click option to WunderBar's " --
      .. F.String.ToxiUI("Durability Module")
      .. " to summon "
      .. F.String.Class("Grand Expedition Yak")
      .. F.String.Sublist("Retail only")
      .. F.String.Sublist("Must have the mount learned"),

    "* Bug fixes",
    "Fix Target UnitFrame fonts",

    "* Profile updates",
    "Apply ToxiUI fonts to Guild Bank",
    "Update " .. F.String.ToxiUI("M+ Colored Mobs") .. " mod for Plater",

    "* Documentation",
    F.String.MinElv("13.55"),
    "Update for 10.2.5",

    "* Settings refactoring",
    "Update WeakAuras Style description to correctly direct users to new location of ActionBars Fade",
  },
}
