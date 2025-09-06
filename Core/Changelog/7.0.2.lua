local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.0.2"] = {
  HOTFIX = true,
  CHANGES = {
    "* Bug fixes",
    F.String.Plater() .. ": Fix EncodingUtil issue in Classic",

    "* Documentation",
    "Add P.O.S.T. Master's Express Hearthstone to " .. F.String.Menu.WunderBar(),
  },
}
