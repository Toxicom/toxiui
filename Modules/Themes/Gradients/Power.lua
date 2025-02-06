local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local GR = TXUI:GetModule("ThemesGradients")

local abs = math.abs
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

  -- should be updated outside
  frame.fadeMode = I.Enum.GradientMode.Mode[I.Enum.GradientMode.Mode.HORIZONTAL]
  frame.fadeDirection = I.Enum.GradientMode.Direction.LEFT

  local valuePercentage = frame.cur and ((frame.cur - frame.min) / (frame.max - frame.min)) or 0
  local valueChanged = frame.currentPercent == nil or (abs(frame.currentPercent - valuePercentage) > 0.05)
  if valueChanged then frame.currentPercent = valuePercentage end

  local colorFunc = F.Event.GenerateClosure(self.GetPowerColor, self, frame, unit)
  self:SetGradientColors(frame, valueChanged, eR, eG, eB, false, colorFunc)
end
