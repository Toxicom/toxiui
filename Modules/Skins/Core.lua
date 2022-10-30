local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local S = TXUI:GetModule("Skins")

local IsAddOnLoaded = IsAddOnLoaded
local xpcall = xpcall
local next = next
local _G = _G
S.addonsToLoad = {}

function S:Enable()
  if self.isEnabled or not self.Initialized then return end
  self.isEnabled = true

  F.Event.ContinueOnAddOnLoaded("AddOnSkins", F.Event.GenerateClosure(self.AddOnSkins, self))
  F.Event.ContinueOnAddOnLoaded("ElvUI_WindTools", F.Event.GenerateClosure(self.ElvUI_WindTools, self))
end

function S:DatabaseUpdate()
  if self.isEnabled or not self.Initialized then return end

  F.Event.ContinueOutOfCombat(function()
    -- Enable only out of combat
    if F.IsTXUIProfile() then self:Enable() end
  end)
end

local function errorhandler(err)
  return _G.geterrorhandler()(err)
end

function S:AddCallbackForAddon(addonName, func)
  local addon = self.addonsToLoad[addonName]
  if not addon then
    self.addonsToLoad[addonName] = {}
    addon = self.addonsToLoad[addonName]
  end

  if type(func) == "string" then func = self[func] end

  tinsert(addon, func or self[addonName])
end

function S:CallLoadedAddon(addonName, object)
  for _, func in next, object do
    xpcall(func, errorhandler, self)
  end

  self.addonsToLoad[addonName] = nil
end

function S:Initialize()
  -- Don't init second time
  if self.Initialized then return end

  -- Vars
  self.isEnabled = false

  -- Register for updates
  F.Event.RegisterOnceCallback("TXUI.InitializedSafe", F.Event.GenerateClosure(self.DatabaseUpdate, self))
  F.Event.RegisterCallback("TXUI.DatabaseUpdate", self.DatabaseUpdate, self)

  for addonName, object in pairs(self.addonsToLoad) do
    local isLoaded, isFinished = IsAddOnLoaded(addonName)
    if isLoaded and isFinished then self:CallLoadedAddon(addonName, object) end
  end

  -- We are done, hooray!
  self.Initialized = true
end

TXUI:RegisterModule(S:GetName())
