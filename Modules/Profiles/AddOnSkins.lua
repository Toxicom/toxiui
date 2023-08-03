local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local PF = TXUI:GetModule("Profiles")

local _G = _G
local unpack = unpack

function PF:AddOnSkins()
  if not _G.AddOnSkins then return end

  -- Get AddOnSkins AddOn
  local addOnSkins = unpack(_G.AddOnSkins)

  -- Set or create new profile
  addOnSkins.data:SetProfile(I.ProfileNames.Default)

  -- General
  addOnSkins.db["Shadows"] = false

  -- Embed
  addOnSkins.db["EmbedBackdrop"] = false
  addOnSkins.db["EmbedBackdropTransparent"] = false
  addOnSkins.db["EmbedOoC"] = false
  addOnSkins.db["EmbedRightChat"] = false
  addOnSkins.db["EmbedSystem"] = false
  addOnSkins.db["EmbedSystemDual"] = false
  addOnSkins.db["EmbedSystemMessage"] = false

  -- Other AddOns
  addOnSkins.db["BigWigs"] = false -- Not needed
  addOnSkins.db["Details"] = false -- Done ourself
  addOnSkins.db["BugSack"] = false -- Done in WT

  -- Apply privates, not needed cause done already
  -- self:AddOnSkins_Private()
end

function PF:AddOnSkins_Private()
  if not _G.AddOnSkins then return end

  -- Get AddOnSkins AddOn
  local addOnSkins = unpack(_G.AddOnSkins)

  -- Set or create new profile
  addOnSkins.data:SetProfile(I.ProfileNames.Default)
end
