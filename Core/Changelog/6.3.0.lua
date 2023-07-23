local TXUI, F, E, I, V, P, G = unpack(select(2, ...))

TXUI.Changelog["6.3.0"] = {
  HOTFIX = false,
  CHANGES = {
    "* ToxiUI",
    F.String.Good("NEW: ") .. "UnitFrame Class Icons",
    F.String.Good("NEW: ") .. "Combat icon for Player UnitFrame " .. F.String.Class("(icons8.com)", "ROGUE"),
  },
  CHANGES_CLASSIC = {
    "Release ToxiUI Classic",
  },
}
