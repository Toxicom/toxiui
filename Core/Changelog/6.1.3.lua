local TXUI, F, E, I, V, P, G = unpack(select(2, ...))

TXUI.Changelog["6.1.3"] = {
  HOTFIX = true,
  CHANGES = {
    "* ToxiUI",
    F.String.Good("[NEW] ") .. "Add our own " .. F.String.ToxiUI("!keys") .. " command. Credits to " .. F.String.Class("Nawuko", "MONK"),
    "Perhaps better handling for those very big UW screens",
    "* ElvUI",
    "Move World Map coordinates to bottom right",
    "Increase default options window size",
    "* Plater",
    "Disable Target color on the M+ Colored Mobs mod",
  },
}
