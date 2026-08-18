local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local GR = TXUI:GetModule("ThemesGradients")

local ALTERNATE_POWER_INDEX = _G.Enum.PowerType.Alternate or 10
local select = select
local UnitPowerType = UnitPowerType

function GR:GetPowerColor(frame, unit)
  if frame.displayType == ALTERNATE_POWER_INDEX then return "powerColorMap", "ALT_POWER" end
  local powerKey = select(2, UnitPowerType(unit))
  return "powerColorMap", powerKey
end

function GR:PostUpdatePowerColor(frame, unit, eR, eG, eB)
  if not self.isEnabled or not self.db or not self.db.enabled then return end
  if not unit then return end

  -- Power values are secret in Midnight, use fixed percentage
  local valueChanged = frame.currentPercent == nil
  if valueChanged then frame.currentPercent = 1 end

  local colorMap, colorEntry = self:GetPowerColor(frame, unit)
  self:SetGradientColors(frame, valueChanged, eR, eG, eB, false, colorMap, colorEntry)
end
