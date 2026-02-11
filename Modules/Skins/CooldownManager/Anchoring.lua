local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local CM = TXUI:GetModule("CooldownManager")

local _G = _G
local InCombatLockdown = InCombatLockdown

function CM:SetAnchors()
  if not self.Initialized then return end
  if InCombatLockdown() then return end
  if not self.db or not self.db.anchors then return end

  local anchors = self.db.anchors
  local essential = _G[self.frameNames.essential]
  local utility = _G[self.frameNames.utility]
  local buff = _G[self.frameNames.buff]
  local powerBar = _G["ElvUF_Player_PowerBar"]
  local classBar = _G["ElvUF_Player_ClassBar"]

  -- Anchor EssentialCooldownViewer to bottom of power bar
  if anchors.essential.enabled and essential and powerBar and E.db.unitframe.units.player.power.enable then
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
    local buffBar = _G[self.frameNames.buffBar]
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
end

function CM:DisableAnchoring()
  if not self.Initialized then return end

  F.Event.UnregisterFrameEventAndCallback("PLAYER_ENTERING_WORLD", self, "CM_Anchors")
  F.Event.UnregisterFrameEventAndCallback("ZONE_CHANGED_NEW_AREA", self, "CM_Anchors")
end
