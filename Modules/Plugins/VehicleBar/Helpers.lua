local TXUI, F, E, I, V, P, G, L = unpack((select(2, ...)))
local VB = TXUI:GetModule("VehicleBar")

function VB:IsVigorAvailable()
  -- Check if player has the skyriding spell AND currently has vigor charges available
  if not F.IsSkyriding() then return false end

  -- If we can get spell charge info, we're actively skyriding
  local chargeInfo = C_Spell.GetSpellCharges(I.Constants.SKYWARD_ASCENT_SPELL_ID)
  return chargeInfo ~= nil
end

function VB:GetSpellChargeInfo()
  local chargeInfo = C_Spell.GetSpellCharges(I.Constants.SKYWARD_ASCENT_SPELL_ID)
  return chargeInfo
end

function VB:ColorSpeedText(msg)
  local thrillActive = C_UnitAuras.GetPlayerAuraBySpellID(I.Constants.THRILL_OF_THE_SKIES_SPELL_ID)
  if thrillActive then
    local r, g, b = self.vdb.thrillColor.r, self.vdb.thrillColor.g, self.vdb.thrillColor.b
    return F.String.Color(msg, F.String.FastRGB(r, g, b))
  else
    return msg
  end
end
