local TXUI, F, E, I = unpack((select(2, ...)))
local VB = TXUI:NewModule("VehicleBar", "AceHook-3.0")

-- Globals
local CreateFrame = CreateFrame
local format = string.format

local InCombatLockdown = InCombatLockdown
local ipairs = ipairs
local RegisterStateDriver = RegisterStateDriver
local UnregisterStateDriver = UnregisterStateDriver

function VB:OnShowEvent()
  self:StopAllAnimations()

  if self:IsVigorAvailable() then
    -- Hide the Default Vigor Bar
    local defaultVigorBar = _G["UIWidgetPowerBarContainerFrame"]
    if defaultVigorBar then defaultVigorBar:Hide() end
    self:UpdateVigorSegments()
  end

  local animationsAllowed = self.db.animations and (not InCombatLockdown()) and not self.combatLock

  if animationsAllowed then
    for i, button in ipairs(self.bar.buttons) do
      self:SetupButtonAnim(button, i)
    end

    if self:IsVigorAvailable() and self.vigorBar and self.vigorBar.segments then
      for i, segment in ipairs(self.vigorBar.segments) do
        self:SetupButtonAnim(segment, i)
      end

      self:SetupButtonAnim(self.vigorBar.speedText, 8)
    end
  end

  for _, button in ipairs(self.bar.buttons) do
    if animationsAllowed then
      button:SetAlpha(0)
      button.FadeIn:Play()
    else
      button:SetAlpha(1)
    end
  end

  if self:IsVigorAvailable() and self.vigorBar and self.vigorBar.segments then
    for _, segment in ipairs(self.vigorBar.segments) do
      if animationsAllowed then
        segment:SetAlpha(0)
        segment.FadeIn:Play()
      else
        segment:SetAlpha(1)
      end
    end

    if animationsAllowed then
      self.vigorBar.speedText:SetAlpha(0)
      self.vigorBar.speedText.FadeIn:Play()
    else
      self.vigorBar.speedText:SetAlpha(1)
    end
  end

  -- Show the custom vigor bar when the vehicle bar is shown
  if self:IsVigorAvailable() then
    self.vigorBar:Show()
    self.vigorBar.speedText:Show()
    self:UpdateVigorBar()
  end

  -- Update keybinds when the bar is shown
  self:UpdateKeybinds()
end

function VB:OnHideEvent()
  -- Hide the custom vigor bar and its speed text when the vehicle bar is hidden
  if self.vigorBar then
    self.vigorBar:Hide()
    self.vigorBar.speedText:Hide()
  end
end

function VB:OnCombatEvent(toggle)
  self.combatLock = toggle
  if self.combatLock then self:StopAllAnimations() end
end

function VB:Disable()
  if not self.Initialized then return end

  self:UnhookAll()

  if self.bar then
    self:StopAllAnimations()

    UnregisterStateDriver(self.bar, "visibility")
    UnregisterStateDriver(self.ab["handledBars"]["bar1"], "visibility")
    RegisterStateDriver(self.ab["handledBars"]["bar1"], "visibility", E.db.actionbar["bar1"].visibility)

    self.bar:Hide()

    if self.vigorBar then
      self.vigorBar:Hide()
      if self.vigorBar.speedText then self.vigorBar.speedText:Hide() end
    end
  end

  F.Event.UnregisterFrameEventAndCallback("PLAYER_REGEN_ENABLED", self)
  F.Event.UnregisterFrameEventAndCallback("PLAYER_REGEN_DISABLED", self)
end

function VB:Enable()
  if not self.Initialized and E.private.actionbar.enable then return end

  -- Update or create bar
  self:UpdateBar()

  -- Register event to update the custom vigor bar when vigor changes
  if TXUI.IsRetail and not self.eventScriptSet then
    local eventFrame = CreateFrame("Frame")
    eventFrame:RegisterEvent("UNIT_POWER_UPDATE")
    eventFrame:RegisterEvent("UNIT_MAXPOWER")
    eventFrame:RegisterEvent("UPDATE_UI_WIDGET")
    eventFrame:SetScript("OnEvent", function(_, event, arg1, arg2)
      if event == "UNIT_POWER_UPDATE" and arg1 == "player" and arg2 == "ALTERNATE" then
        VB:UpdateVigorBar()
      elseif event == "UPDATE_UI_WIDGET" then
        VB:UpdateVigorBar()
      end
    end)

    self.eventScriptSet = true
    -- Initial update
    self:UpdateVigorBar()
  end

  -- Overwrite default bar visibility
  local visibility = format("[petbattle] hide; [vehicleui][overridebar][shapeshift][possessbar]%s hide;", (self.db.dragonRiding and "[bonusbar:5]") or "")

  self:Hook(self.ab, "PositionAndSizeBar", function(_, barName)
    local bar = self.ab["handledBars"][barName]
    if E.db.actionbar[barName].enabled and (barName == "bar1") then
      UnregisterStateDriver(bar, "visibility")
      RegisterStateDriver(bar, "visibility", visibility .. E.db.actionbar[barName].visibility)
    end
  end)

  -- Unregister/Register State Driver
  UnregisterStateDriver(self.bar, "visibility")
  UnregisterStateDriver(self.ab["handledBars"]["bar1"], "visibility")

  RegisterStateDriver(
    self.bar,
    "visibility",
    format("[petbattle] hide; [vehicleui][overridebar][shapeshift][possessbar]%s show; hide", (self.db.dragonRiding and "[bonusbar:5]") or "")
  )
  RegisterStateDriver(self.ab["handledBars"]["bar1"], "visibility", visibility .. E.db.actionbar["bar1"].visibility)

  -- Register Events
  F.Event.RegisterFrameEventAndCallback("PLAYER_REGEN_ENABLED", self.OnCombatEvent, self, false)
  F.Event.RegisterFrameEventAndCallback("PLAYER_REGEN_DISABLED", self.OnCombatEvent, self, true)
end

function VB:DatabaseUpdate()
  -- Disable
  self:Disable()

  -- Set db
  self.db = F.GetDBFromPath("TXUI.vehicleBar")

  -- Enable only out of combat
  F.Event.ContinueOutOfCombat(function()
    if TXUI:HasRequirements(I.Requirements.VehicleBar) and (self.db and self.db.enabled) and E.private.actionbar.enable then self:Enable() end
  end)
end

function VB:Initialize()
  -- Don't init second time
  if self.Initialized then return end

  -- Vars
  self.combatLock = false
  self.ab = E:GetModule("ActionBars")
  self.vigorBar = nil
  self.previousBarWidth = nil
  self.vigorHeight = 10
  self.spacing = 2
  self.eventScriptSet = false

  -- Register for updates
  F.Event.RegisterOnceCallback("TXUI.InitializedSafe", F.Event.GenerateClosure(self.DatabaseUpdate, self))
  F.Event.RegisterCallback("TXUI.DatabaseUpdate", self.DatabaseUpdate, self)
  F.Event.RegisterCallback("VehicleBar.DatabaseUpdate", self.DatabaseUpdate, self)
  F.Event.RegisterCallback("VehicleBar.SettingsUpdate", self.UpdateBar, self)

  -- We are done, hooray!
  self.Initialized = true
end

TXUI:RegisterModule(VB:GetName())
