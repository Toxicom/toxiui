local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local CM = TXUI:NewModule("CooldownManager", "AceHook-3.0")

local _G = _G

CM.frameNames = {
  essential = "EssentialCooldownViewer",
  utility = "UtilityCooldownViewer",
  buff = "BuffIconCooldownViewer",
  buffBar = "BuffBarCooldownViewer",
}

function CM:OnCooldownManagerChanged()
  self:SetAnchors()
  self:SetParent()
end

function CM:Disable()
  if not self.Initialized then return end

  self:UnhookAll()
  self:DisableDynamicBarsWidth()
  self:DisableAnchoring()

  F.Event.UnregisterFrameEventAndCallback("PLAYER_ENTERING_WORLD", self)
  F.Event.UnregisterFrameEventAndCallback("ZONE_CHANGED_NEW_AREA", self)

  if _G.EventRegistry then
    _G.EventRegistry:UnregisterCallback("CooldownViewerSettings.OnDataChanged", self)
    _G.EventRegistry:UnregisterCallback("EditMode.Exit", self)
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

    -- Re-apply all features on settings change or edit mode exit since they reset frames
    if _G.EventRegistry then
      _G.EventRegistry:RegisterCallback("CooldownViewerSettings.OnDataChanged", self.OnCooldownManagerChanged, self)
      _G.EventRegistry:RegisterCallback("EditMode.Exit", self.OnCooldownManagerChanged, self)
    end
  end)
end

function CM:Initialize()
  -- Don't init second time
  if self.Initialized then return end

  self.essentialViewer = _G[self.frameNames.essential]

  -- Register for updates
  F.Event.RegisterOnceCallback("TXUI.InitializedSafe", F.Event.GenerateClosure(self.DatabaseUpdate, self))
  F.Event.RegisterCallback("TXUI.DatabaseUpdate", self.DatabaseUpdate, self)
  F.Event.RegisterCallback("CooldownManager.DatabaseUpdate", self.DatabaseUpdate, self)

  -- We are done, hooray!
  self.Initialized = true
end

if TXUI.IsRetail then TXUI:RegisterModule(CM:GetName()) end
