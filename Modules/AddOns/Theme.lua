local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local T = TXUI:NewModule("Theme", "AceHook-3.0")

-- Globals
local _G = _G
local CreateFrame = CreateFrame
local EnumerateFrames = EnumerateFrames
local getmetatable = getmetatable
local pairs = pairs

T.onEnabledCallbacks = {}

function T:UpdateTemplateStrata(frame)
  if frame.txSoftShadow then
    frame.txSoftShadow:SetFrameLevel(frame:GetFrameLevel())
    frame.txSoftShadow:SetFrameStrata(frame:GetFrameStrata())
  end
end

function T:SetTemplate(frame, template, glossTex, ignoreUpdates, _, isUnitFrameElement, isNamePlateElement)
  template = template or frame.template or "Default"
  glossTex = glossTex or frame.glossTex or nil
  ignoreUpdates = ignoreUpdates or frame.ignoreUpdates or false

  if ignoreUpdates then return end

  local isStatusBar = false
  local parent = frame:GetParent()

  if parent then
    if parent.IsObjectType and (parent:IsObjectType("Texture") or parent:IsObjectType("Statusbar")) then
      isStatusBar = true
    elseif E.statusBars[parent] ~= nil then
      isStatusBar = true
    end
  end

  local skinForUnitFrame = isUnitFrameElement and not isNamePlateElement
  local skinForTransparent = (template == "Transparent") and not isNamePlateElement and not isStatusBar
  local skinForTexture = (template == "Default" and not glossTex) and not isUnitFrameElement and not isNamePlateElement and not isStatusBar

  -- Transparent & UnitFrames
  if (skinForTransparent or skinForUnitFrame or isStatusBar) and (self.db and self.db.enabled and self.db.shadowEnabled) then
    if not frame.TXCreateSoftShadow then return self:LogDebug("API function TXCreateSoftShadow not found!") end
    if frame.shadow then frame.shadow:Kill() end
    frame:TXCreateSoftShadow(F.Dpi(self.db.shadowSize), self.db.shadowAlpha)
    self.shadowCache[frame] = true
  else
    if frame.txSoftShadow then frame.txSoftShadow:Hide() end
  end

  -- Transparent
  if (skinForTransparent or skinForTexture) and (self.db and self.db.enabled) then
    if not frame.TXCreateInnerNoise or not frame.TXCreateInnerShadow then
      return self:LogDebug("API functions not found!", "TXCreateInnerNoise", not frame.TXCreateInnerNoise, "TXCreateInnerShadow", not frame.TXCreateInnerShadow)
    end

    -- Needed for Tooltips, since those are no longer Backdrop Templates
    -- ElvUI needs to fix their tooltip skinning for the NineSlice change Blizzard did (when/if they notice .....)
    -- Ref: https://github.com/Gethe/wow-ui-source/blob/4b8a0a911090d4679db954d61291a852db9542fe/Interface/AddOns/Blizzard_Deprecated/Deprecated_9_1_5.lua
    if frame.Center ~= nil then frame.Center:SetDrawLayer("BACKGROUND", -7) end

    frame:TXCreateInnerNoise()
    frame:TXCreateInnerShadow(skinForTexture)
  else
    if frame.txInnerNoise then frame.txInnerNoise:Hide() end
    if frame.txInnerShadow then frame.txInnerShadow:Hide() end
  end
end

function T:SetTemplateAS(_, frame, template, _)
  self:SetTemplate(frame, template)
end

function T:API(object)
  local mt = getmetatable(object).__index

  -- No api attached?
  if not mt or not mt.SetTemplate then return end

  -- Create TX functions
  if not mt.TXCreateInnerShadow then mt.TXCreateInnerShadow = F.CreateInnerShadow end
  if not mt.TXCreateInnerNoise then mt.TXCreateInnerNoise = F.CreateInnerNoise end
  if not mt.TXCreateSoftShadow then mt.TXCreateSoftShadow = F.CreateSoftShadow end

  -- Hook elvui template
  if not self:IsHooked(mt, "SetTemplate") then
    self:SecureHook(mt, "SetTemplate", "SetTemplate") -- self:LogDebug("Hooked type", object:GetObjectType())
  end

  -- Hook FrameLevel
  if mt.SetFrameLevel and (not self:IsHooked(mt, "SetFrameLevel")) then self:SecureHook(mt, "SetFrameLevel", "UpdateTemplateStrata") end

  -- Hook FrameStrata
  if mt.SetFrameStrata and (not self:IsHooked(mt, "SetFrameStrata")) then self:SecureHook(mt, "SetFrameStrata", "UpdateTemplateStrata") end
end

function T:ForceRefresh()
  -- Refresh Templates
  E:UpdateFrameTemplates()

  -- Refresh all media
  E:UpdateMediaItems(true)
end

function T:MetatableScan()
  -- Remove cache
  self.shadowCache = {}

  -- Register API and hook frames
  local handled = {
    Frame = true,
  }

  local object = CreateFrame("Frame")
  self:API(object)
  self:API(object:CreateTexture())
  self:API(object:CreateFontString())
  self:API(object:CreateMaskTexture())
  self:API(_G.GameFontNormal)
  self:API(CreateFrame("ScrollFrame"))

  object = EnumerateFrames()
  while object do
    if (not object:IsForbidden()) and not handled[object:GetObjectType()] then
      self:API(object)
      handled[object:GetObjectType()] = true
    end

    object = EnumerateFrames(object)
  end
end

function T:Disable()
  if not self.Initialized then return end

  -- Set to disabled
  self.isEnabled = false

  -- Empty cache
  self.shadowCache = {}

  -- Force refresh to disable theme
  if self.Initialized and self.db and not self.db.enabled then self:ForceRefresh() end

  -- Unhook all
  self:UnhookAll()
end

function T:Enable()
  if not self.Initialized then return end

  -- Set to enabled
  self.isEnabled = true

  -- AddOnSkins Skinning
  F.Event.ContinueOnAddOnLoaded("AddOnSkins", function()
    local as = _G.AddOnSkins and _G.AddOnSkins[1]
    if not as then return end

    if not self:IsHooked(as, "SetTemplate") then
      self:SecureHook(as, "SetTemplate", "SetTemplateAS")
      as:UpdateSettings()
    end
  end)

  -- Scan all MetaTables
  self:MetatableScan()

  -- Force Refresh
  self:ForceRefresh()
end

function T:SettingsUpdate()
  if not self.Initialized then return end
  if not self.isEnabled then return end

  for frame, _ in pairs(self.shadowCache) do
    if frame.txSoftShadow then
      if self.db.shadowEnabled then
        frame:TXCreateSoftShadow(self.db.shadowSize, self.db.shadowAlpha)
      else
        frame.txSoftShadow:Hide()
      end
    end
  end
end

function T:DatabaseUpdate()
  -- Set db
  self.db = F.GetDBFromPath("TXUI.addons.elvUITheme")

  local shouldBeEnabled = TXUI:HasRequirements(I.Requirements.ElvUITheme) and (self.db and self.db.enabled)
  if self.isEnabled == shouldBeEnabled then return end

  F.Event.ContinueOutOfCombat(function()
    -- Enable/disable only out of combat
    if shouldBeEnabled then
      self:Enable()
    else
      self:Disable()
    end
  end)
end

function T:Initialize()
  -- Don't init second time
  if self.Initialized then return end

  -- Track our internal state
  self.isEnabled = false

  -- Register for updates
  F.Event.RegisterOnceCallback("TXUI.InitializedSafe", F.Event.GenerateClosure(self.DatabaseUpdate, self))
  F.Event.RegisterCallback("TXUI.DatabaseUpdate", self.DatabaseUpdate, self)
  F.Event.RegisterCallback("Theme.DatabaseUpdate", self.DatabaseUpdate, self)
  F.Event.RegisterCallback("Theme.SettingsUpdate", self.SettingsUpdate, self)

  -- Keep track of frames for fast updates
  self.shadowCache = {}

  -- We are done, hooray!
  self.Initialized = true
end

TXUI:RegisterModule(T:GetName())
