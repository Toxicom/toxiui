local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local CM = TXUI:NewModule("CooldownManager", "AceHook-3.0")

local _G = _G
local essentialViewer

local frameNames = {
  "EssentialCooldownViewer",
  "UtilityCooldownViewer",
  "BuffIconCooldownViewer",
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
  if not essentialViewer then return end

  local width = essentialViewer:GetWidth()
  if not width or width <= 0 then return end

  -- For when EssentialCooldownViewer is too small or no spells etc.
  if width <= 100 then width = F.Dpi(292) end -- default width

  -- Skip if width hasn't changed
  if self.cachedBarsWidth == width then return end
  self.cachedBarsWidth = width

  -- Update ElvUI player power and classbar detached width
  local playerDB = E.db.unitframe.units.player
  if playerDB then
    if playerDB.power then playerDB.power.detachedWidth = width end
    if playerDB.classbar then playerDB.classbar.detachedWidth = width end

    -- Update the unitframe to apply changes (must be out of combat to avoid taint)
    F.Event.ContinueOutOfCombat(function()
      local uf = E:GetModule("UnitFrames")
      if uf and uf.CreateAndUpdateUF then uf:CreateAndUpdateUF("player") end
    end)
  end
end

function CM:EnableDynamicBarsWidth()
  if not self.Initialized then return end

  if not essentialViewer then return end

  -- Hook OnSizeChanged to sync whenever frame width changes
  if not self:IsHooked(essentialViewer, "OnSizeChanged") then self:SecureHookScript(essentialViewer, "OnSizeChanged", "SyncBarsWidth") end
end

function CM:DisableDynamicBarsWidth()
  if not self.Initialized then return end

  self.cachedBarsWidth = nil

  if essentialViewer and self:IsHooked(essentialViewer, "OnSizeChanged") then self:Unhook(essentialViewer, "OnSizeChanged") end
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

  essentialViewer = _G["EssentialCooldownViewer"]

  -- Register for updates
  F.Event.RegisterOnceCallback("TXUI.InitializedSafe", F.Event.GenerateClosure(self.DatabaseUpdate, self))
  F.Event.RegisterCallback("TXUI.DatabaseUpdate", self.DatabaseUpdate, self)
  F.Event.RegisterCallback("CooldownManager.DatabaseUpdate", self.DatabaseUpdate, self)

  -- We are done, hooray!
  self.Initialized = true
end

if TXUI.IsRetail then TXUI:RegisterModule(CM:GetName()) end
