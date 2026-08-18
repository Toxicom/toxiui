local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local GR = TXUI:NewModule("ThemesGradients", "AceHook-3.0")
local LSM = E.Libs.LSM

local pairs = pairs

local function updateCallbackWrapper(self, func, _, ignoreSettings)
  if not ignoreSettings then self:SettingsUpdate() end
  func()
end

function GR:AddFrameToSettingsUpdate(category, frame, func)
  if self.settingsEvents[frame] ~= nil then return end

  self.settingsEvents[frame] = true
  F.Event.RegisterCallback("ThemesGradients.SettingsUpdate." .. category, F.Event.GenerateClosure(updateCallbackWrapper, self, func), frame)
end

function GR:UpdateFadeDirection(frame)
  local unitType = frame.unitframeType or frame.__owner.unitframeType
  local fadeDirection = unitType and self.db.fadeDirection and self.db.fadeDirection[unitType]
  if not fadeDirection then fadeDirection = I.Enum.GradientMode.Direction.RIGHT end

  frame.fadeMode = I.Enum.GradientMode.Mode[I.Enum.GradientMode.Mode.HORIZONTAL]
  frame.fadeDirection = fadeDirection
end

function GR:UpdateStatusBarFrame(frame)
  if not self.isEnabled or not self.db or not self.db.enabled then return end
  if not frame then return end

  -- Configure Health
  if frame.Health then
    local healthTexture = LSM:Fetch("statusbar", self.db.textures.health)
    frame.Health:SetStatusBarTexture(healthTexture)
    frame.Health.bg:SetTexture(healthTexture)
    self:UpdateFadeDirection(frame.Health)

    -- Hook if needed
    if not self:IsHooked(frame.Health, "PostUpdateColor") then
      self:RawHook(frame.Health, "PostUpdateColor", F.Event.GenerateClosure(self.PostUpdateHealthColor, self))
      self:AddFrameToSettingsUpdate("Health", frame.Health, F.Event.GenerateClosure(self.PostUpdateHealthColor, self, frame.Health, frame.__unit))
    end
  end

  -- Configure CastBar
  if frame.Castbar then
    local castTexture = LSM:Fetch("statusbar", self.db.textures.cast)
    frame.Castbar:SetStatusBarTexture(castTexture)
    frame.Castbar.bg:SetTexture(castTexture)
    self:UpdateFadeDirection(frame.Castbar)

    -- Hook if needed
    if not self:IsHooked(frame.Castbar, "PostCastStart") then
      self:SecureHook(frame.Castbar, "PostCastStart", F.Event.GenerateClosure(self.PostUpdateCastColor, self, frame.Castbar, false))
      self:SecureHook(frame.Castbar, "PostCastFail", F.Event.GenerateClosure(self.PostUpdateCastColor, self, frame.Castbar, true))
      self:SecureHook(frame.Castbar, "PostCastInterruptible", F.Event.GenerateClosure(self.PostUpdateCastColor, self, frame.Castbar, false))
    end
  end

  -- Configure Power Bar
  if frame.Power then
    local powerTexture = LSM:Fetch("statusbar", self.db.textures.power)
    frame.Power:SetStatusBarTexture(powerTexture)
    frame.Power.bg:SetTexture(powerTexture)
    self:UpdateFadeDirection(frame.Power)

    -- Hook if needed
    if not self:IsHooked(frame.Power, "PostUpdateColor") then
      self:RawHook(frame.Power, "PostUpdateColor", F.Event.GenerateClosure(self.PostUpdatePowerColor, self))
      self:AddFrameToSettingsUpdate("Power", frame.Power, F.Event.GenerateClosure(self.PostUpdatePowerColor, self, frame.Power, frame.__unit))
    end
  end
end

function GR:ConfigureStatusBarFrame(_, frame)
  -- Reset cached per-frame state so it's rebuilt fresh (e.g. when test mode activates)
  if frame.Health then
    frame.Health._gradColorFunc = nil
    frame.Health.unitDead = nil
  end
  self:UpdateStatusBarFrame(frame)
end

function GR:UpdateStatusBar(_, frame)
  if not self.isEnabled or not self.db or not self.db.enabled then return end
  if not frame then return end

  local parentFrame = frame:GetParent()
  if not parentFrame then return end

  self:UpdateStatusBarFrame(parentFrame)
end

function GR:UpdateStatusBars()
  for frame in pairs(self.uf.statusbars) do
    if frame then self:UpdateStatusBar(nil, frame) end
  end
end

function GR:SettingsUpdate()
  -- Clear cache
  self.updateCache = {}

  -- Regenerate Colors
  F.Color.GenerateCache()

  -- Refresh fade directions for all registered frames
  for frame in pairs(self.settingsEvents) do
    self:UpdateFadeDirection(frame)
  end
end

function GR:TexturesUpdate()
  self:UpdateStatusBars()
end

function GR:Disable()
  if not self.Initialized then return end
  if not self:IsHooked(self.uf, "Configure_HealthBar") then return end

  self:UnhookAll()
  self.uf:Update_AllFrames()
end

function GR:Enable()
  if not self.Initialized then return end
  if not self.isEnabled or not self.db or not self.db.enabled then return end
  if self:IsHooked(self.uf, "Configure_HealthBar") then return end

  -- Apply settings
  self:SettingsUpdate()

  -- Hook functions for configure functions
  self:SecureHook(self.uf, "Configure_HealthBar", "ConfigureStatusBarFrame")
  self:SecureHook(self.uf, "Configure_Castbar", "ConfigureStatusBarFrame")
  self:SecureHook(self.uf, "Configure_Power", "ConfigureStatusBarFrame")

  -- Hook functions for update functions
  self:SecureHook(self.uf, "Update_StatusBars", "UpdateStatusBars")
  self:SecureHook(self.uf, "Update_StatusBar", "UpdateStatusBar")

  -- Update!
  self.uf:Update_AllFrames()
end

function GR:DatabaseUpdate()
  -- Set db
  self.db = F.GetDBFromPath("TXUI.themes.gradientMode")

  -- Set enable state
  local isEnabled = (self.db and self.db.enabled) and TXUI:HasRequirements(I.Requirements.GradientMode)
  if self.isEnabled == isEnabled then return end
  self.isEnabled = isEnabled

  F.Event.ContinueOutOfCombat(function()
    F.Event.ContinueAfterElvUIUpdate(function()
      -- Disable only out of combat
      self:Disable()

      -- Enable only out of combat
      if self.isEnabled then
        if self.uf.Initialized then
          self:Enable()
        else
          self:SecureHook(self.uf, "Initialize", F.Event.GenerateClosure(self.Enable, self))
        end
      end
    end)
  end)
end

function GR:Initialize()
  -- Don't init second time
  if self.Initialized then return end

  -- Get Frameworks
  self.uf = E:GetModule("UnitFrames")

  -- Force Update Cache
  self.updateCache = {}
  self.settingsEvents = {}

  -- Register for updates
  F.Event.RegisterOnceCallback("TXUI.InitializedSafe", F.Event.GenerateClosure(self.DatabaseUpdate, self))
  F.Event.RegisterCallback("TXUI.DatabaseUpdate", self.DatabaseUpdate, self)
  F.Event.RegisterCallback("ThemesGradients.DatabaseUpdate", self.DatabaseUpdate, self)
  F.Event.RegisterCallback("ThemesGradients.SettingsUpdate", self.SettingsUpdate, self)
  F.Event.RegisterCallback("ThemesGradients.TexturesUpdate", self.TexturesUpdate, self)

  -- We are done, hooray!
  self.Initialized = true
end

TXUI:RegisterModule(GR:GetName())
