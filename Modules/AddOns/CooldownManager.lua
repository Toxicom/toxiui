local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local CM = TXUI:NewModule("CooldownManager", "AceHook-3.0")

local _G = _G
local essentialViewer
local InCombatLockdown = InCombatLockdown
local floor = math.floor
local pairs = pairs

local frameNames = {
  essential = "EssentialCooldownViewer",
  utility = "UtilityCooldownViewer",
  buff = "BuffIconCooldownViewer",
  buffBar = "BuffBarCooldownViewer",
}

function CM:SetCooldownFramesVisibility(enabled)
  for _, frameName in pairs(frameNames) do
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
  for _, frameName in pairs(frameNames) do
    local frame = _G[frameName]
    if frame and frame:GetParent() ~= playerFrame then
      frame:SetParent(playerFrame)
      frame:SetFrameStrata("MEDIUM")
    end
  end
end

function CM:SyncBarsWidth()
  if not essentialViewer then return end
  if InCombatLockdown() then return end

  local width = floor(essentialViewer:GetWidth() + 0.5)
  -- sometimes the width comes as fucking 1.003003002 etc. so make sure it's bigger than one button atleast
  if not width or width <= 30 then return end

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

function CM:SetAnchors()
  if not self.Initialized then return end
  if InCombatLockdown() then return end
  if not self.db or not self.db.anchors then return end

  local anchors = self.db.anchors
  local essential = _G[frameNames.essential]
  local utility = _G[frameNames.utility]
  local buff = _G[frameNames.buff]
  local powerBar = _G["ElvUF_Player_PowerBar"]
  local classBar = _G["ElvUF_Player_ClassBar"]

  -- Anchor EssentialCooldownViewer to bottom of power bar
  if anchors.essential.enabled and essential and powerBar then
    essential:ClearAllPoints()
    essential:SetPoint("TOP", powerBar, "BOTTOM", 0, anchors.essential.yOffset)
  end

  -- Anchor UtilityCooldownViewer to bottom of EssentialCooldownViewer
  if anchors.utility.enabled and utility and essential then
    utility:ClearAllPoints()
    utility:SetPoint("TOP", essential, "BOTTOM", 0, anchors.utility.yOffset)
  end

  -- Anchor BuffIconCooldownViewer to top of class bar, fallback to power bar
  if anchors.buff.enabled and buff then
    local anchor = (classBar and classBar:IsShown() and classBar) or powerBar
    if anchor then
      buff:ClearAllPoints()
      buff:SetPoint("BOTTOM", anchor, "TOP", 0, anchors.buff.yOffset)
    end
  end

  -- Anchor BuffBarCooldownViewer to top of health bar
  if anchors.buffBar.enabled then
    local buffBar = _G[frameNames.buffBar]
    local healthBar = _G["ElvUF_Player_HealthBar"]
    if buffBar and healthBar then
      buffBar:ClearAllPoints()
      buffBar:SetPoint("BOTTOM", healthBar, "TOP", 0, anchors.buffBar.yOffset)
    end
  end
end

function CM:EnableAnchoring()
  if not self.Initialized then return end

  -- Apply anchors initially
  self:SetAnchors()

  -- Re-apply on zone changes since cooldown manager may reset positions
  F.Event.RegisterFrameEventAndCallback("PLAYER_ENTERING_WORLD", self.SetAnchors, self, "CM_Anchors")
  F.Event.RegisterFrameEventAndCallback("ZONE_CHANGED_NEW_AREA", self.SetAnchors, self, "CM_Anchors")

  -- Re-apply after exiting Edit Mode or cooldown settings change since they reset frame positions
  if _G.EventRegistry then
    _G.EventRegistry:RegisterCallback("EditMode.Exit", self.SetAnchors, self)
    _G.EventRegistry:RegisterCallback("CooldownViewerSettings.OnDataChanged", self.SetAnchors, self)
  end
end

function CM:DisableAnchoring()
  if not self.Initialized then return end

  F.Event.UnregisterFrameEventAndCallback("PLAYER_ENTERING_WORLD", self, "CM_Anchors")
  F.Event.UnregisterFrameEventAndCallback("ZONE_CHANGED_NEW_AREA", self, "CM_Anchors")

  if _G.EventRegistry then
    _G.EventRegistry:UnregisterCallback("EditMode.Exit", self)
    _G.EventRegistry:UnregisterCallback("CooldownViewerSettings.OnDataChanged", self)
  end
end

function CM:Disable()
  if not self.Initialized then return end

  self:UnhookAll()
  self:DisableDynamicBarsWidth()
  self:DisableAnchoring()

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

    -- Enable anchoring if any anchor is enabled
    if self.db.anchors then
      local a = self.db.anchors
      if a.essential.enabled or a.utility.enabled or a.buff.enabled or a.buffBar.enabled then self:EnableAnchoring() end
    end
  end)
end

function CM:Initialize()
  -- Don't init second time
  if self.Initialized then return end

  essentialViewer = _G[frameNames.essential]

  -- Register for updates
  F.Event.RegisterOnceCallback("TXUI.InitializedSafe", F.Event.GenerateClosure(self.DatabaseUpdate, self))
  F.Event.RegisterCallback("TXUI.DatabaseUpdate", self.DatabaseUpdate, self)
  F.Event.RegisterCallback("CooldownManager.DatabaseUpdate", self.DatabaseUpdate, self)

  -- We are done, hooray!
  self.Initialized = true
end

if TXUI.IsRetail then TXUI:RegisterModule(CM:GetName()) end
