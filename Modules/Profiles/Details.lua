local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local PF = TXUI:GetModule("Profiles")

function PF:Details(twoWindows)
  local profile = twoWindows and PF.ImportStrings.DetailsTwo or PF.ImportStrings.DetailsOne
  -- Import new profile
  Details:EraseProfile(I.ProfileNames.Default)
  Details:ImportProfile(I.DevDetailsProfile or profile, I.ProfileNames.Default)

  -- Apply privates, not needed cause done already
  -- self:Details_Private()
end

function PF:Details_Private()
  if not Details then return end

  -- Apply installed profile
  if I.ProfileNames.Default ~= Details:GetCurrentProfileName() then Details:ApplyProfile(I.ProfileNames.Default) end
end
