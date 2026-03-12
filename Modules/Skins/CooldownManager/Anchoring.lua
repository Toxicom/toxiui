local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local CM = TXUI:GetModule("CooldownManager")

local _G = _G
-- local InCombatLockdown = InCombatLockdown

function CM:SetAnchors()
  if not self.Initialized then return end
  -- if InCombatLockdown() then return end
  if not self.db or not self.db.anchors then return end

  self._inEditMode = false
  self._settingAnchors = true

  local anchors = self.db.anchors
  local essential = _G[self.frameNames.essential]
  local utility = _G[self.frameNames.utility]
  local buff = _G[self.frameNames.buff]
  local buffBar = _G[self.frameNames.buffBar]
  local healthBar = _G["ElvUF_Player_HealthBar"]
  local powerBar = _G["ElvUF_Player_PowerBar"]
  local classBar = _G["ElvUF_Player_ClassBar"]
  if E.myclass == "DEATHKNIGHT" then classBar = _G["ElvUF_Player_Runes"] end
  if E.myclass == "MONK" and E.myspecID == I.Specs.Monk.Brewmaster then classBar = _G["ElvUF_Player_Stagger"] end
  local powerBarAvailable = powerBar and powerBar:IsShown() and E.db.unitframe.units.player.power.enable
  local classBarAvailable = classBar and classBar:IsShown() and E.db.unitframe.units.player.classbar.enable

  -- Anchor EssentialCooldownViewer to bottom of power bar, fallback to class bar
  if anchors.essential.enabled and essential and essential.orientationSetting ~= 1 then
    local anchor = (powerBarAvailable and powerBar) or (classBarAvailable and classBar)
    if anchor then essential:SetPointOverride("TOP", anchor, "BOTTOM", 0, anchors.essential.yOffset) end
  end

  -- Anchor UtilityCooldownViewer to bottom of EssentialCooldownViewer
  if anchors.utility.enabled and utility and essential and utility.orientationSetting ~= 1 then utility:SetPointOverride("TOP", essential, "BOTTOM", 0, anchors.utility.yOffset) end

  -- Anchor BuffIconCooldownViewer to top of class bar, fallback to power bar
  if anchors.buff.enabled and buff and buff.orientationSetting ~= 1 then
    local anchor = (classBarAvailable and classBar) or (powerBarAvailable and powerBar)
    if anchor then buff:SetPointOverride("BOTTOM", anchor, "TOP", 0, anchors.buff.yOffset) end
  end

  -- Anchor BuffBarCooldownViewer to top of health bar
  if anchors.buffBar.enabled and buffBar and healthBar then buffBar:SetPointOverride("BOTTOM", healthBar, "TOP", 0, anchors.buffBar.yOffset) end

  self._settingAnchors = false
end

function CM:RestoreAnchors()
  if not self._savedAnchors then return end
  -- _inEditMode = true guards the anchor lock, so SetPoint won't re-trigger SetAnchors
  for frameName, anchor in pairs(self._savedAnchors) do
    local f = _G[frameName]
    if f then
      f:ClearAllPointsOverride()
      f:ClearAllPoints()
      f:SetPoint(anchor[1], anchor[2], anchor[3], anchor[4], anchor[5])
    end
  end
end

function CM:HookAnchorLock(frame)
  if not frame then return end

  self:SecureHook(frame, "SetPoint", function()
    if self._settingAnchors then return end
    if self._inEditMode then return end
    -- if InCombatLockdown() then return end

    self:SetAnchors()
  end)
end

function CM:SetupAnchorLocks()
  if not self.db or not self.db.anchors then return end

  local anchors = self.db.anchors

  if anchors.essential.enabled then self:HookAnchorLock(_G[self.frameNames.essential]) end
  if anchors.utility.enabled then self:HookAnchorLock(_G[self.frameNames.utility]) end
  if anchors.buff.enabled then self:HookAnchorLock(_G[self.frameNames.buff]) end
  if anchors.buffBar.enabled then self:HookAnchorLock(_G[self.frameNames.buffBar]) end
end

function CM:SaveAnchors()
  if not self.db or not self.db.anchors then return end
  local anchors = self.db.anchors
  self._savedAnchors = {}
  local toSave = {
    anchors.essential.enabled and self.frameNames.essential,
    anchors.utility.enabled and self.frameNames.utility,
    anchors.buff.enabled and self.frameNames.buff,
    anchors.buffBar.enabled and self.frameNames.buffBar,
  }
  for _, frameName in pairs(toSave) do
    if frameName then
      local f = _G[frameName]
      if f then
        local p, r, rp, x, y = f:GetPoint(1)
        if p then self._savedAnchors[frameName] = { p, r, rp, x, y } end
      end
    end
  end
end

function CM:EnableAnchoring()
  if not self.Initialized then return end

  -- Save current anchors before overriding so Edit Mode can restore them
  self:SaveAnchors()

  -- Apply anchors initially
  self:SetAnchors()

  -- Lock anchors via SetPoint hooks to prevent external resets
  self:SetupAnchorLocks()

  -- Re-apply on zone changes since cooldown manager may reset positions
  F.Event.RegisterFrameEventAndCallback("PLAYER_ENTERING_WORLD", self.SetAnchors, self, "CM_Anchors")
  F.Event.RegisterFrameEventAndCallback("ZONE_CHANGED_NEW_AREA", self.SetAnchors, self, "CM_Anchors")
end

function CM:DisableAnchoring()
  if not self.Initialized then return end

  self._savedAnchors = nil

  F.Event.UnregisterFrameEventAndCallback("PLAYER_ENTERING_WORLD", self, "CM_Anchors")
  F.Event.UnregisterFrameEventAndCallback("ZONE_CHANGED_NEW_AREA", self, "CM_Anchors")
end
