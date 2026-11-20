local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.6.3"] = {
  HOTFIX = true,
  RELEASE_DATE = "",
  CHANGES = {
    "* Breaking changes",

    "* New features",
    F.String.Forever() .. F.String.Menu.WunderBar() .. ": Achievements button in the MicroMenu now opens the Legacy system" .. F.String.Sublist(
      "Credits to bifferz for initial PR"
    ),

    "* Enhancements",

    "* Bug fixes",

    "* Profile updates",

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
    "Supporter badges are now self-service: Patreon supporters register their characters with " .. F.String.ToxiUI("/supporter register") .. " in Discord" .. F.String.Sublist(
      "Use " .. F.String.ToxiUI("/tx export names") .. " in game to get your registration code"
    ) .. F.String.Sublist("The old hand-maintained supporter list has been retired, please register to keep your badge"),
  },
}
