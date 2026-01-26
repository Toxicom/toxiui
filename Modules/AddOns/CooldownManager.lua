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

function CM:SyncBarsWidth()
  local essentialViewer = _G["EssentialCooldownViewer"]
  if not essentialViewer then return end

  local width = essentialViewer:GetWidth()
  if not width or width <= 0 then return end

  -- Update ElvUI player power and classbar detached width
  local playerDB = E.db.unitframe.units.player
  if playerDB then
    if playerDB.power then playerDB.power.detachedWidth = width end
    if playerDB.classbar then playerDB.classbar.detachedWidth = width end

    -- Update the unitframe to apply changes
    local uf = E:GetModule("UnitFrames")
    if uf and uf.CreateAndUpdateUF then uf:CreateAndUpdateUF("player") end
  end
end

function CM:EnableDynamicBarsWidth()
  if not self.Initialized then return end

  -- Sync initially
  self:SyncBarsWidth()

  -- Register for CooldownViewerSettings changes via EventRegistry
  if EventRegistry then
    EventRegistry:RegisterCallback("CooldownViewerSettings.OnDataChanged", self.SyncBarsWidth, self)
    self.dynamicBarsWidthRegistered = true
  end
end

function CM:DisableDynamicBarsWidth()
  if not self.Initialized then return end

  -- Unregister from EventRegistry
  if EventRegistry and self.dynamicBarsWidthRegistered then
    EventRegistry:UnregisterCallback("CooldownViewerSettings.OnDataChanged", self)
    self.dynamicBarsWidthRegistered = false
  end
end

function CM:Disable()
  if not self.Initialized then return end

  self:UnhookAll()
  self:DisableDynamicBarsWidth()

  F.Event.UnregisterFrameEventAndCallback("PLAYER_ENTERING_WORLD", self)
  F.Event.UnregisterFrameEventAndCallback("ZONE_CHANGED_NEW_AREA", self)
end

function CM:EnableFading()
  if not self.Initialized then return end

  local playerFrame = _G["ElvUF_Player"]
  if not playerFrame then return end

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

function CM:DatabaseUpdate()
  -- Set db
  self.db = F.GetDBFromPath("TXUI.addons.cooldownManager")

  F.Event.ContinueOutOfCombat(function()
    -- Disable only out of combat
    self:Disable()

    -- Check requirements
    if not TXUI:HasRequirements(I.Requirements.CooldownManager) then return end
    if not self.db then return end

    -- Enable fading if enabled
    if self.db.fading then self:EnableFadingAfterUnitsLoaded() end

    -- Enable dynamic bars width if enabled
    if self.db.dynamicBarsWidth then self:EnableDynamicBarsWidth() end
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
