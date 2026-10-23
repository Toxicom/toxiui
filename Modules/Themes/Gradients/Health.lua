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

-- Runs on every health tick, so unit API calls are only made when the branch needs them
function GR:GetHealthColor(frame, unit)
  -- Some UnitIs*/UnitReaction results can be secret depending on unit/context (e.g. targettarget);
  -- guard every boolean test since Lua errors on truthy-testing a secret value directly
  local isPlayer = UnitIsPlayer(unit)
  isPlayer = E:NotSecretValue(isPlayer) and isPlayer

  if not isPlayer and TXUI.IsRetail then
    local treatAsPlayer = UnitTreatAsPlayerForDisplay(unit)
    isPlayer = E:NotSecretValue(treatAsPlayer) and treatAsPlayer
  end

  if isPlayer then
    local isConnected = UnitIsConnected(unit)
    if E:NotSecretValue(isConnected) and not isConnected then return "specialColorMap", "DISCONNECTED" end
  end

  -- frame.unitDead is set from UnitIsDeadOrGhost right before this is called
  if frame.unitDead == true then return "specialColorMap", "DEAD" end

  if isPlayer then
    local isCharmed = UnitIsCharmed(unit)
    if E:NotSecretValue(isCharmed) and isCharmed then
      local isEnemy = UnitIsEnemy("player", unit)
      if E:NotSecretValue(isEnemy) and isEnemy then return "reactionColorMap", "BAD" end
    end
  end

  local playerControlled = UnitPlayerControlled(unit)
  if E:NotSecretValue(playerControlled) and not playerControlled then
    local tapDenied = UnitIsTapDenied(unit)
    if E:NotSecretValue(tapDenied) and tapDenied then return "specialColorMap", "TAPPED" end
  end

  if isPlayer then
    local classToken = select(2, UnitClass(unit))
    if E:NotSecretValue(classToken) then return "classColorMap", classToken end
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
  local unitDead = UnitIsDeadOrGhost(unit)
  if E:IsSecretValue(unitDead) then unitDead = nil end
  if unitDead ~= frame.unitDead then
    colorChanged = true
    frame.unitDead = unitDead
  end

  local colorMap, colorEntry = self:GetHealthColor(frame, unit)
  self:SetGradientColors(frame, valueChanged, eR, eG, eB, colorChanged, colorMap, colorEntry)
end
