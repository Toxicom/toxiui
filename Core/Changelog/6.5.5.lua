local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.5.5"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    "Display Loadout name in WunderBar's " .. F.String.ToxiUI("SpecSwitch") .. " module" .. F.String.Sublist("Retail only"),
    F.String.Class("Color")
      .. " Modifier keys; Credits and huge shoutouts to these people:" --
      .. F.String.Sublist(F.String.Eltreum() .. " from EltruismUI")
      .. F.String.Sublist(F.String.Class("Repooc", "DRUID"))
      .. F.String.Sublist(F.String.ElvUI() .. " community"),

    "* Bug fixes",

    "* Profile updates",

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
  },
}
