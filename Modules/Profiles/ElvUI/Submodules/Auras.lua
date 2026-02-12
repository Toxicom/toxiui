local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local PF = TXUI:GetModule("Profiles")

local buffs = {
  size = F.Dpi(38),
  fadeThreshold = 3,
  maxWraps = 2,
  wrapAfter = 18,
  seperateOwn = -1,
  growthDirection = "RIGHT_DOWN",

  keepSizeRatio = false,
  height = F.Dpi(25),
}

local debuffs = {
  size = F.Dpi(48),
  growthDirection = "RIGHT_DOWN",

  keepSizeRatio = false,
  height = F.Dpi(32),
}

function PF:ApplyAuras(pf)
  F.Table.Crush(pf.auras.buffs, buffs)
  F.Table.Crush(pf.auras.debuffs, debuffs)
end
