local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

local _G = _G
local pairs = pairs
local SetCVar = SetCVar
local tinsert = table.insert
local xpcall = xpcall

-- Main AddOn Title, see branding
TXUI.Title = I.Strings.Branding.Title

-- Core Variables
TXUI.ReleaseVersion = 0 -- for internal tracking, this is populated inside the changelog module
TXUI.Changelog = {}

-- Modules
TXUI.RegisteredModules = {}

local function errorhandler(err)
  return _G.geterrorhandler()(err)
end

function TXUI:RegisterModule(name)
  if not self.RegisteredModules[name] then tinsert(self.RegisteredModules, name) end
end

function TXUI:UpdateProfiles(_)
  if TXUI.PreventProfileUpdates then return end

  TXUI:DBConvert()

  F.Event.TriggerEvent("TXUI.DatabaseUpdate")
end

function TXUI:ModulePreInitialize(module)
  module.isEnabled = false
  F.Log.InjectLogger(module)
end

function TXUI:SetupDevRelease()
  if not self.DevRelease or (not F.IsTXUIProfile()) then return end

  -- Enable Script Errors
  SetCVar("scriptErrors", 1)

  -- Set taint errors to be enabled
  E.db.general.taintLog = false
end

function TXUI:InitializeModules()
  -- Update cooldown text settings
  E:UpdateCooldownSettings("all")

  -- Dev first, to enable easy overrides
  if self.DevRelease then
    local module = self:GetModule("Dev")
    self:ModulePreInitialize(module)
    if module.Initialize then xpcall(module.Initialize, errorhandler, module) end
  end

  -- Setup stuff for devs & testers
  self:SetupDevRelease()

  -- Changelog second, most important for all functions
  do
    local module = self:GetModule("Changelog")
    self:ModulePreInitialize(module)
    if module.Initialize then xpcall(module.Initialize, errorhandler, module) end
  end

  -- Convet DBs, after changelog is loaded but before anything else
  self:DBConvert()

  -- Skins, second most important
  do
    local module = self:GetModule("Skins")
    self:ModulePreInitialize(module)
    if module.Initialize then xpcall(module.Initialize, errorhandler, module) end
  end

  -- Options, third most important
  do
    local module = self:GetModule("Options")
    self:ModulePreInitialize(module)
    if module.Initialize then xpcall(module.Initialize, errorhandler, module) end
  end

  -- All other modules that are registered the normal way
  for _, moduleName in pairs(self.RegisteredModules) do
    local module = self:GetModule(moduleName)
    self:ModulePreInitialize(module)
    if module.Initialize then xpcall(module.Initialize, errorhandler, module) end
  end

  -- Init Popups
  self:LoadStaticPopups()

  -- Init commands
  self:LoadCommands()

  -- Init Done, let modules check if they are enabled
  local function onAllEvents()
    -- Weait until ElvUI is done Updating
    F.Event.ContinueAfterElvUIUpdate(function()
      -- Set initialized
      self.initialized = true
      F.Event.TriggerEvent("TXUI.Initialized")

      -- Run those delayed after init
      F.Event.RunNextFrame(function()
        -- Mark TXUI has entered world
        self.DelayedWorldEntered = true

        E:ConfigMode_AddGroup("TXUI", TXUI.Title)

        -- Show Dev Mode or Tester Message
        if self.DevRelease then
          local isDev = F.IsDeveloper()
          local entryName = F.GetContributorEntryName() or "Person"
          local prettyName = isDev and F.String.FastGradient(entryName, 0, 0.9, 1, 0, 0.6, 1) or F.String.FastGradient("awesome " .. entryName, 0.57, 0.92, 0.49, 0.38, 0.81, 0.43)
          local message = isDev and ("Dev features are " .. F.String.Error("active")) or ("Debug mode is " .. F.String.Error("enabled"))
          self:LogInfo("Initialize > Hello " .. prettyName .. "!", message)
        end

        -- Print all delayed messages
        F.Log.PrintDelayedMessages()
      end, 5)

      -- Set initialized safe after combat ends
      F.Event.ContinueOutOfCombat(function()
        self.initializedSafe = true
        F.Event.TriggerEvent("TXUI.InitializedSafe")
      end)
    end)
  end

  local events = { "PLAYER_ENTERING_WORLD" }
  if TXUI.IsRetail then tinsert(events, "FIRST_FRAME_RENDERED") end

  F.Event.ContinueAfterAllEvents(onAllEvents, F.Table.SafeUnpack(events))
end
