local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local GR = TXUI:GetModule("ThemesGradients")

local select = select
local UnitClass = UnitClass
local UnitIsCharmed = UnitIsCharmed
local UnitIsConnected = UnitIsConnected
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitIsEnemy = UnitIsEnemy
local UnitIsPlayer = UnitIsPlayer
local UnitIsTapDenied = UnitIsTapDenied
local UnitPlayerControlled = UnitPlayerControlled
local UnitReaction = UnitReaction
local UnitTreatAsPlayerForDisplay = UnitTreatAsPlayerForDisplay

function GR:GetHealthColor(frame, unit)
  local isPlayer = UnitIsPlayer(unit) or (TXUI.IsRetail and UnitTreatAsPlayerForDisplay(unit))

  if isPlayer and not UnitIsConnected(unit) then
    return "specialColorMap", "DISCONNECTED"
  elseif frame.unitDead == true then
    return "specialColorMap", "DEAD"
  elseif isPlayer and (not UnitIsDeadOrGhost(unit)) and (UnitIsCharmed(unit)) and UnitIsEnemy("player", unit) then
    return "reactionColorMap", "BAD"
  elseif not UnitPlayerControlled(unit) and UnitIsTapDenied(unit) then
    return "specialColorMap", "TAPPED"
  elseif isPlayer then
    return "classColorMap", select(2, UnitClass(unit))
  else
    local reaction = UnitReaction(unit, "player")
    if reaction then
      if reaction > 4 then
        return "reactionColorMap", "GOOD"
      elseif reaction > 3 then
        return "reactionColorMap", "NEUTRAL"
      else
        return "reactionColorMap", "BAD"
      end
    end
  end
end

function GR:PostUpdateHealthColor(frame, unit, eR, eG, eB)
  if not self.isEnabled or not self.db or not self.db.enabled then return end
  if not unit then return end

  -- Health values are secret in Midnight, use fixed percentage
  local valueChanged = frame.currentPercent == nil
  if valueChanged then frame.currentPercent = 1 end

  local colorChanged = false
  local unitDead = unit and UnitIsDeadOrGhost(unit)
  if unitDead ~= frame.unitDead then
    colorChanged = true
    frame.unitDead = unitDead
  end

  local colorFunc = F.Event.GenerateClosure(self.GetHealthColor, self, frame, unit)
  self:SetGradientColors(frame, valueChanged, eR, eG, eB, colorChanged, colorFunc)
end
