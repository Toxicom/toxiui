local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local CM = TXUI:NewModule("CooldownManager", "AceHook-3.0")

local _G = _G

local frameNames = {
  "EssentialCooldownViewer",
  "UtilityCooldownViewer",
}

function CM:SetCooldownFramesVisibility(enabled)
  for _, frameName in ipairs(frameNames) do
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
  local playerFrame = _G["ElvUF_Player"]
  if not playerFrame then return end

  -- Set parent of cooldown manager frames to player unitframe
  -- This makes them fade together with the player frame
  -- Position is not affected since SetPoint is relative to their anchor, not their parent
  for _, frameName in ipairs(frameNames) do
    local frame = _G[frameName]
    if frame and frame:GetParent() ~= playerFrame then
      frame:SetParent(playerFrame)
      frame:SetFrameStrata("MEDIUM")
    end
  end
end

function CM:Disable()
  if not self.Initialized then return end

  self:UnhookAll()

  F.Event.UnregisterFrameEventAndCallback("PLAYER_ENTERING_WORLD", self)
  F.Event.UnregisterFrameEventAndCallback("ZONE_CHANGED_NEW_AREA", self)
end

function CM:Enable()
  if not self.Initialized then return end

  local playerFrame = _G["ElvUF_Player"]
  if not playerFrame then return end

  -- Set parent initially
  self:SetParent()

  -- Re-apply parent on zone changes since cooldown manager may reset it
  F.Event.RegisterFrameEventAndCallback("PLAYER_ENTERING_WORLD", self.SetParent, self)
  F.Event.RegisterFrameEventAndCallback("ZONE_CHANGED_NEW_AREA", self.SetParent, self)

  -- Hook SetAlpha to also toggle visibility when fading
  if not self:IsHooked(playerFrame, "SetAlpha") then
    self:SecureHook(playerFrame, "SetAlpha", function(_, alpha)
      self:SetCooldownFramesVisibility(alpha > 0.1)
    end)
  end
end

function CM:EnableAfterUnitsLoaded()
  -- Get Frameworks
  local uf = E:GetModule("UnitFrames")

  -- Enable after units are loaded
  if uf.unitstoload ~= nil then
    self:SecureHook(uf, "LoadUnits", "Enable")
  else
    self:Enable()
  end
end

function CM:DatabaseUpdate()
  -- Set db
  self.db = F.GetDBFromPath("TXUI.addons.cooldownManager")

  F.Event.ContinueOutOfCombat(function()
    -- Disable only out of combat
    self:Disable()

    -- Enable only out of combat
    if TXUI:HasRequirements(I.Requirements.CooldownManager) and (self.db and self.db.fading) then
      self:EnableAfterUnitsLoaded()
    end
  end)
end

function CM:Initialize()
  -- Don't init second time
  if self.Initialized then return end

  -- Register for updates
  F.Event.RegisterOnceCallback("TXUI.InitializedSafe", F.Event.GenerateClosure(self.DatabaseUpdate, self))
  F.Event.RegisterCallback("TXUI.DatabaseUpdate", self.DatabaseUpdate, self)
  F.Event.RegisterCallback("CooldownManager.DatabaseUpdate", self.DatabaseUpdate, self)

  -- We are done, hooray!
  self.Initialized = true
end

if TXUI.IsRetail then TXUI:RegisterModule(CM:GetName()) end
