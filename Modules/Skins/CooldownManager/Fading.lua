local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local CM = TXUI:GetModule("CooldownManager")

local _G = _G
local pairs = pairs

function CM:SetCooldownFramesVisibility(enabled)
  for _, frameName in pairs(self.frameNames) do
    local frame = _G[frameName]
    if frame then
      if enabled then
        frame:Show()
      else
        frame:Hide()
      end
    end
  end
end

function CM:SetParent()
  if not self.Initialized then return end
  if not self.db or not self.db.fading then return end

  local playerFrame = _G["ElvUF_Player"]
  if not playerFrame then return end

  -- Set parent of cooldown manager frames to player unitframe
  -- This makes them fade together with the player frame
  -- Position is not affected since SetPoint is relative to their anchor, not their parent
  for _, frameName in pairs(self.frameNames) do
    local frame = _G[frameName]
    if frame and frame:GetParent() ~= playerFrame then
      frame:SetParent(playerFrame)
      frame:SetFrameStrata("MEDIUM")
    end
  end
end

function CM:DisableFading()
  if not self._originalParents then return end

  for frameName, parent in pairs(self._originalParents) do
    local frame = _G[frameName]
    if frame and parent then frame:SetParent(parent) end
  end
  self._originalParents = nil

  -- Ensure all frames are visible after restoring parent
  self:SetCooldownFramesVisibility(true)
end

function CM:EnableFading()
  if not self.Initialized then return end

  local playerFrame = _G["ElvUF_Player"]
  if not playerFrame then return end

  -- Store original parents before re-parenting so DisableFading can restore them
  if not self._originalParents then
    self._originalParents = {}
    for _, frameName in pairs(self.frameNames) do
      local frame = _G[frameName]
      if frame then self._originalParents[frameName] = frame:GetParent() end
    end
  end

  -- Set parent initially
  self:SetParent()

  -- Re-apply parent on zone changes since cooldown manager may reset it
  F.Event.RegisterFrameEventAndCallback("PLAYER_ENTERING_WORLD", self.SetParent, self)
  F.Event.RegisterFrameEventAndCallback("ZONE_CHANGED_NEW_AREA", self.SetParent, self)

  -- Hook SetAlpha to also toggle visibility when fading
  if not self:IsHooked(playerFrame, "SetAlpha") then self:SecureHook(playerFrame, "SetAlpha", function(_, alpha)
    self:SetCooldownFramesVisibility(alpha > 0.1)
  end) end
end

function CM:EnableFadingAfterUnitsLoaded()
  -- Get Frameworks
  local uf = E:GetModule("UnitFrames")

  -- Enable after units are loaded
  if uf.unitstoload ~= nil then
    self:SecureHook(uf, "LoadUnits", "EnableFading")
  else
    self:EnableFading()
  end
end
