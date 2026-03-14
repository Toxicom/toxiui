local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local GR = TXUI:GetModule("ThemesGradients")

local select = select
local UnitClass = UnitClass
local UnitIsPlayer = UnitIsPlayer

function GR:GetCastbarColor(frame, unit, castFailed)
  if not self.isEnabled or not self.db or not self.db.enabled then return end
  if unit == "vehicle" then unit = "player" end

  local useClassColor, colorEntry

  if castFailed then
    colorEntry = "INTERRUPTED"
  elseif frame.classColorFallback and (unit and UnitIsPlayer(unit)) then
    colorEntry = select(2, UnitClass(unit))
    useClassColor = true
  else
    colorEntry = "DEFAULT"
  end

  local colorMap = useClassColor and "classColorMap" or "castColorMap"
  if useClassColor and self.db[colorMap][I.Enum.GradientMode.Color.NORMAL][colorEntry] == nil then
    colorEntry = "DEFAULT"
    colorMap = "castColorMap"
  end

  return colorMap, colorEntry
end

function GR:PostUpdateCastColor(frame, castFailed)
  if not self.isEnabled or not self.db or not self.db.enabled then return end
  if not frame.__owner.unit and not frame.unit then return end

  local eR, eG, eB = frame:GetStatusBarColor()
  local unit = frame.unit or frame.__owner.unit
  if unit == "vehicle" then unit = "player" end

  local customColor = frame.db and frame.db.castbar and frame.db.castbar.customColor
  local custom = customColor and customColor.enable and customColor
  frame.classColorFallback = (custom and custom.useClassColor) or (not custom and self.uf.db.colors.castClassColor)

  -- Cast duration is secret in Midnight, use fixed percentage
  local valueChanged = frame.currentPercent == nil
  if valueChanged then frame.currentPercent = 1 end

  local colorFunc = F.Event.GenerateClosure(self.GetCastbarColor, self, frame, unit, castFailed)
  self:SetGradientColors(frame, valueChanged, eR, eG, eB, false, colorFunc)
end
