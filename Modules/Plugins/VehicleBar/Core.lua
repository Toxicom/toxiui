local TXUI, F, E, I = unpack((select(2, ...)))
local VB = TXUI:NewModule("VehicleBar", "AceHook-3.0")

-- Globals
local format = string.format

local InCombatLockdown = InCombatLockdown
local ipairs = ipairs
local RegisterStateDriver = RegisterStateDriver
local UnregisterStateDriver = UnregisterStateDriver

function VB:OnShowEvent()
  self:StopAllAnimations()

  local animationsAllowed = self.db.animations and (not InCombatLockdown()) and not self.combatLock

  if animationsAllowed then
    for i, button in ipairs(self.bar.buttons) do
      self:SetupButtonAnim(button, i)
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

  -- Update keybinds when the bar is shown
  self:UpdateKeybinds()
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
  end

  F.Event.UnregisterFrameEventAndCallback("PLAYER_REGEN_ENABLED", self)
  F.Event.UnregisterFrameEventAndCallback("PLAYER_REGEN_DISABLED", self)
end

function VB:Enable()
  if not self.Initialized and E.private.actionbar.enable then return end

  -- Update or create bar
  self:UpdateBar()

  -- Overwrite default bar visibility
  local visibility = format("[petbattle] hide; [vehicleui][overridebar][shapeshift][possessbar]%s hide;", "[bonusbar:5]")

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

  RegisterStateDriver(self.bar, "visibility", format("[petbattle] hide; [vehicleui][overridebar][shapeshift][possessbar]%s show; hide", "[bonusbar:5]"))
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
  self.previousBarWidth = nil
  self.spacing = 2

  -- Register for updates
  F.Event.RegisterOnceCallback("TXUI.InitializedSafe", F.Event.GenerateClosure(self.DatabaseUpdate, self))
  F.Event.RegisterCallback("TXUI.DatabaseUpdate", self.DatabaseUpdate, self)
  F.Event.RegisterCallback("VehicleBar.DatabaseUpdate", self.DatabaseUpdate, self)
  F.Event.RegisterCallback("VehicleBar.SettingsUpdate", self.UpdateBar, self)

  -- We are done, hooray!
  self.Initialized = true
end

TXUI:RegisterModule(VB:GetName())
