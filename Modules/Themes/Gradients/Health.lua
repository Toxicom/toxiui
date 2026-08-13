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
  -- Some UnitIs*/UnitReaction results can be secret depending on unit/context (e.g. targettarget);
  -- guard every boolean test since Lua errors on truthy-testing a secret value directly
  local unitIsPlayer = UnitIsPlayer(unit)
  local treatAsPlayer = TXUI.IsRetail and UnitTreatAsPlayerForDisplay(unit)
  local isPlayer = (E:NotSecretValue(unitIsPlayer) and unitIsPlayer)
    or (E:NotSecretValue(treatAsPlayer) and treatAsPlayer)

  local isConnected = UnitIsConnected(unit)
  local isDeadOrGhost = UnitIsDeadOrGhost(unit)
  local isCharmed = UnitIsCharmed(unit)
  local isEnemy = UnitIsEnemy("player", unit)
  local playerControlled = UnitPlayerControlled(unit)
  local tapDenied = UnitIsTapDenied(unit)

  if isPlayer and E:NotSecretValue(isConnected) and not isConnected then
    return "specialColorMap", "DISCONNECTED"
  elseif frame.unitDead == true then
    return "specialColorMap", "DEAD"
  elseif isPlayer
    and E:NotSecretValue(isDeadOrGhost) and not isDeadOrGhost
    and E:NotSecretValue(isCharmed) and isCharmed
    and E:NotSecretValue(isEnemy) and isEnemy then
    return "reactionColorMap", "BAD"
  elseif E:NotSecretValue(playerControlled) and not playerControlled
    and E:NotSecretValue(tapDenied) and tapDenied then
    return "specialColorMap", "TAPPED"
  elseif isPlayer then
    local classToken = select(2, UnitClass(unit))
    if E:NotSecretValue(classToken) then
      return "classColorMap", classToken
    end
  else
    local reaction = UnitReaction(unit, "player")
    if E:NotSecretValue(reaction) and reaction then
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

  local colorMap, colorEntry = self:GetHealthColor(frame, unit)
  self:SetGradientColors(frame, valueChanged, eR, eG, eB, colorChanged, colorMap, colorEntry)
end
