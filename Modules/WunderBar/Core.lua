local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local WB = TXUI:NewModule("WunderBar", "AceHook-3.0", "AceTimer-3.0")

-- Globals
local find = string.find
local format = string.format
local gsub = string.gsub
local ipairs = ipairs
local strsplit = strsplit
local type = type

-- Vars
WB.isEnabled = false
WB.isVisible = false
WB.isMouseOver = false

WB.registeredModules = {}
WB.registeredModulesNames = {}

function WB:RegisterSubModule(subModule, events)
  -- Since we don't load submodules over the core function, pre-init them here
  TXUI:ModulePreInitialize(subModule)

  local data = {}
  data.name = subModule:GetName()
  data.events = type(events) == "string" and { strsplit("[, ]", events) } or events

  local displayName = format(data.name)

  if find(displayName, "ElvUI:") then
    displayName = gsub(displayName, "ElvUI:", "|cff999999ElvUI:|r")
  elseif find(displayName, "LDB:") then
    displayName = gsub(displayName, "LDB:", "|cff999999LDB:|r")
  else
    displayName = TXUI.Title .. ": " .. displayName .. "|r"
  end

  self.registeredModules[data.name] = data
  self.registeredModulesNames[data.name] = displayName

  return data
end

function WB:EnableDebugMode()
  if not self.isEnabled then return end

  local debugColors = {
    { 240, 71, 43 },
    { 228, 154, 38 },
    { 241, 196, 15 },
    { 111, 184, 66 },
    { 68, 156, 199 },
    { 74, 119, 193 },
    { 129, 71, 212 },
    { 201, 83, 161 },
    { 176, 177, 161 },
    { 108, 120, 116 },
  }

  for _, module in ipairs(self.moduleFrames) do
    module:CreateBackdrop()
    module.backdrop:SetBackdropColor(debugColors[module.moduleIndex][1] / 255, debugColors[module.moduleIndex][2] / 255, debugColors[module.moduleIndex][3] / 255, 1)
  end
end

function WB:Disable()
  self:CancelAllTimers()
  self:UnhookAll()

  self.isEnabled = false
  self.isVisible = false
  self.isMouseOver = false

  F.Event.UnregisterFrameEventAndCallback("PLAYER_REGEN_ENABLED", self)
  F.Event.UnregisterFrameEventAndCallback("PLAYER_REGEN_DISABLED", self)
  F.Event.UnregisterFrameEventAndCallback("PLAYER_UPDATE_RESTING", self)
  F.Event.UnregisterFrameEventAndCallback("ZONE_CHANGED_NEW_AREA", self)
  F.Event.UnregisterFrameEventAndCallback("PLAYER_REGEN_ENABLED", self)

  if not TXUI.IsVanilla then
    F.Event.UnregisterFrameEventAndCallback("PET_BATTLE_CLOSE", self)
    F.Event.UnregisterFrameEventAndCallback("PET_BATTLE_OPENING_START", self)
  end

  if self.Initialized then
    if self.bar then
      self.bar:SetAlpha(0)
      self.bar:Hide()
    end

    self:StopAllAnimations()
    self:DisableAllModules()
  end
end

function WB:Enable()
  self.isEnabled = true
  self.isVisible = false
  self.isMouseOver = false
  self.flyoutIsOpen = false

  -- Register events
  F.Event.RegisterFrameEventAndCallback("PLAYER_REGEN_ENABLED", self.CheckVisibility, self)
  F.Event.RegisterFrameEventAndCallback("PLAYER_REGEN_DISABLED", self.CheckVisibility, self, "PLAYER_REGEN_DISABLED")
  F.Event.RegisterFrameEventAndCallback("PLAYER_UPDATE_RESTING", self.CheckVisibility, self)
  F.Event.RegisterFrameEventAndCallback("ZONE_CHANGED_NEW_AREA", self.CheckVisibility, self)

  if not TXUI.IsVanilla then
    F.Event.RegisterFrameEventAndCallback("PET_BATTLE_CLOSE", self.CheckVisibility, self)
    F.Event.RegisterFrameEventAndCallback("PET_BATTLE_OPENING_START", self.CheckVisibility, self)
  end

  -- Register Scripts
  self:SecureHookScript(self.bar, "OnEnter", "BarOnEnter")
  self:SecureHookScript(self.bar, "OnLeave", "BarOnLeave")
  self:SecureHookScript(self.bar, "OnUpdate", "BarOnUpdate")

  -- Show yourself you wunderbare bar
  self.bar:Show()
  self.bar:SetAlpha(0)

  self:SettingsUpdate()
end

function WB:IsEnabled()
  return self.isEnabled
end

function WB:SettingsUpdate()
  -- Update
  self:UpdateBar()
  self:UpdatePanelSubModules()
end

function WB:DatabaseUpdate()
  -- Disable
  self:Disable()

  -- Set db
  self.db = F.GetDBFromPath("TXUI.wunderbar")

  if not self.Initialized then return end

  -- Enable only out of combat
  F.Event.ContinueOutOfCombat(function()
    if TXUI:HasRequirements(I.Requirements.WunderBar) and (self.db and self.db.general and self.db.general.enabled) then self:Enable() end
  end)
end

function WB:Construct()
  -- Set db
  self.db = F.GetDBFromPath("TXUI.wunderbar")
  self.isTop = self.db.general.position == "TOP"
  self.dirMulti = self.isTop and -1 or 1

  -- Register ElvUI & LDB DataText
  self:RegisterElvUIDatatexts()
  self:RegisterLDBDatatexts()

  -- Cache hearthstone data
  F.CacheHearthstoneData()

  -- Construct Safe
  F.Event.ContinueToxiUIInitializedSafe(function()
    self:ConstructBar()
    self:ConstructModules()

    -- We are done, hooray!
    self.Initialized = true

    -- Enable
    self:DatabaseUpdate()
  end)
end

-- Initialization
function WB:Initialize()
  -- Don't init second time
  if self.Initialized then return end

  -- Register for updates
  F.Event.RegisterOnceCallback("TXUI.Initialized", F.Event.GenerateClosure(self.Construct, self))
  F.Event.RegisterCallback("TXUI.DatabaseUpdate", self.DatabaseUpdate, self)
  F.Event.RegisterCallback("WunderBar.SettingsUpdate", self.SettingsUpdate, self)
end

TXUI:RegisterModule(WB:GetName())
