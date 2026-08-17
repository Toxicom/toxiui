local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local GR = TXUI:GetModule("ThemesGradients")

local select = select
local UnitCanAttack = UnitCanAttack
local UnitClass = UnitClass
local UnitIsPlayer = UnitIsPlayer

function GR:GetCastbarColor(frame, unit, castFailed)
  if not self.isEnabled or not self.db or not self.db.enabled then return end
  if unit == "vehicle" then unit = "player" end

  local notInterruptible = E:NotSecretValue(frame.notInterruptible) and frame.notInterruptible
  local isPlayer = unit and UnitIsPlayer(unit)
  local canAttack = unit and unit ~= "player" and UnitCanAttack("player", unit)
  local useClassColor, colorEntry

  if castFailed then
    colorEntry = "INTERRUPTED"
  elseif notInterruptible and unit and ((E:NotSecretValue(isPlayer) and isPlayer) or (E:NotSecretValue(canAttack) and canAttack)) then
    colorEntry = "NOINTERRUPT"
  elseif frame.classColorFallback and unit and E:NotSecretValue(isPlayer) and isPlayer then
    local classToken = select(2, UnitClass(unit))
    if E:NotSecretValue(classToken) then
      colorEntry = classToken
      useClassColor = true
    else
      colorEntry = "DEFAULT"
    end
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
  if not frame.__owner.unit and not frame.__unit then return end

  local unit = frame.__unit or frame.__owner.unit
  if unit == "vehicle" then unit = "player" end

  local customColor = frame.db and frame.db.castbar and frame.db.castbar.customColor
  local custom = customColor and customColor.enable and customColor
  frame.classColorFallback = (custom and custom.useClassColor) or (not custom and self.uf.db.colors.castClassColor)

  -- Cast duration and bar color are secret in Midnight — use fixed percentage and skip bar color comparison
  local valueChanged = frame.currentPercent == nil
  if valueChanged then frame.currentPercent = 1 end

  local colorMap, colorEntry = self:GetCastbarColor(frame, unit, castFailed)
  self:SetGradientColors(frame, valueChanged, nil, nil, nil, true, colorMap, colorEntry)
end
