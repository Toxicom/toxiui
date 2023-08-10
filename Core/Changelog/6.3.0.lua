local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.3.0"] = {
  HOTFIX = false,
  CHANGES = {
    "* ToxiUI",
    F.String.Good("NEW: ") .. "UnitFrame Class Icons",
    F.String.Good("NEW: ") .. "Stylized icons " .. F.String.Class("(icons8.com)", "ROGUE") .. " for Dead and Disconnected state to match UnitFrame class icons",
    F.String.Good("NEW: ") .. "Combat icon for Player UnitFrame " .. F.String.Class("(icons8.com)", "ROGUE"),
    F.String.Class("ElvUI: ", "SHAMAN") .. "Change Player Castbar Strate level so it's below Combat Icon",
    F.String.RandomClassColor("FadePersist: ") .. "Properly disable the module when ElvUI ActionBars are disabled",
    F.String.RandomClassColor("VehicleBar: ") .. "Properly disable the module when ElvUI ActionBars are disabled",
    F.String.RandomClassColor("Armory: ") .. "Possibly fix a bug with item level coloring based on achievement status",
  },
  CHANGES_CLASSIC = {
    "Release ToxiUI Classic",
  },
}
