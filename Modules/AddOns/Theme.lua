local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local T = TXUI:NewModule("Theme", "AceHook-3.0")

-- Globals
local _G = _G
local CommunitiesListEntryMixin = CommunitiesListEntryMixin
local CreateFrame = CreateFrame
local EnumerateFrames = EnumerateFrames
local getmetatable = getmetatable
local pairs = pairs
local tinsert = table.insert
local unpack = unpack

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

function T:SetHoverHandlers(obj, onEnter, onLeave)
  self:SecureHookScript(obj, "OnEnter", onEnter)
  self:SecureHookScript(obj, "OnLeave", onLeave)

  self:SecureHook(obj, "SetScript", function(frame, scriptType)
    if scriptType == "OnEnter" then
      self:Unhook(frame, "OnEnter")
      self:SecureHookScript(frame, "OnEnter", onEnter)
    elseif scriptType == "OnLeave" then
      self:Unhook(frame, "OnLeave")
      self:SecureHookScript(frame, "OnLeave", onLeave)
    end
  end)
end

function T:HandleButtonHover(obj)
  local gr = F.Table.HexToRGB(I.Strings.Colors[I.Enum.Colors.TXUI]) -- TODO: needs to be cached
  F.Color.SetGradientRGB(obj.txBackground, I.Enum.GradientMode.Mode[I.Enum.GradientMode.Mode.VERTICAL], gr.r, gr.g, gr.b, 0.4, gr.r, gr.g, gr.b, 0)
end

function T:HandleButtonLeave(obj)
  local gr = F.Table.HexToRGB(I.Strings.Colors[I.Enum.Colors.TXUI]) -- TODO: needs to be cached
  F.Color.SetGradientRGB(obj.txBackground, I.Enum.GradientMode.Mode[I.Enum.GradientMode.Mode.VERTICAL], gr.r, gr.g, gr.b, 0, gr.r, gr.g, gr.b, 0)
end

function T:HandleButton(_, button)
  if not button or not (button.template or button.backdrop) then return end

  local parent = button.backdrop or button
  if parent.txBackground then return end

  parent.SetBackdropColor = E.noop -- TODO: needs to be reversed on disable
  parent.SetBackdropBorderColor = E.noop -- TODO: needs to be reversed on disable

  -- TODO: this needs to be smarter
  -- local text = button.Text or button.GetName and button:GetName() and _G[button:GetName() .. "Text"]
  -- if text and text.GetTextColor then F.SetFontColorFromDB(nil, nil, text) end

  local bg = parent:CreateTexture()
  bg:SetInside(parent, 1, 1)
  bg:SetTexture(E.Libs.LSM:Fetch("statusbar", "TX WorldState Score"))
  bg:SetVertexColor(1, 1, 1, 1)

  parent.txBackground = bg

  if parent.Center then
    local layer, subLayer = parent.Center:GetDrawLayer()
    subLayer = subLayer and subLayer + 1 or 0
    bg:SetDrawLayer(layer, subLayer)
  end

  self:HandleButtonLeave(parent)
  self:SetHoverHandlers(button, F.Event.GenerateClosure(T.HandleButtonHover, self, parent), F.Event.GenerateClosure(T.HandleButtonLeave, self, parent))
end

function T:HandleButtonColor(_, button)
  if not button or not button.SetBackdropColor then return end
  local parent = button.backdrop or button
  if not parent.txBackground then return end

  local gr = F.Table.HexToRGB(I.Strings.Colors[I.Enum.Colors.TXUI]) -- TODO: cache this

  -- TODO: should use animations
  if button:IsEnabled() then
    F.Color.SetGradientRGB(parent.txBackground, I.Enum.GradientMode.Mode[I.Enum.GradientMode.Mode.VERTICAL], gr.r, gr.g, gr.b, 0, gr.r, gr.g, gr.b, 0)
  else
    F.Color.SetGradientRGB(parent.txBackground, I.Enum.GradientMode.Mode[I.Enum.GradientMode.Mode.VERTICAL], gr.r, gr.g, gr.b, 0.8, gr.r, gr.g, gr.b, 0)
  end
end

function T:HandleWidget(_, widget)
  local widgetType = widget.type
  if not widgetType then return end
  if widgetType == "Button" or widgetType == "Button-ElvUI" then self:HandleButton(nil, widget) end
end

function T:API(object)
  local mt = getmetatable(object).__index

  -- No api attached?
  if not mt.SetTemplate then return end

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

function T:UpdateClubInfo(frame, clubInfo)
  local cI = clubInfo or frame.clubInfo
  if not cI or not cI.clubId or (clubInfo.clubId ~= 156744552) then return end

  frame.Icon:SetBlendMode("DISABLE")
  frame.Icon:SetTexture(I.Media.Logos.LogoSmall)
  frame.Icon:SetTexCoord(unpack(E.TexCoords))
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

  -- Re-Hook "watchers" if the skin gets enabled again we need those
  self:SecureHook(E.Skins, "HandleButton", F.Event.GenerateClosure(T.OnEnabledProxy, T, T.HandleButton))
  self:SecureHook(E.Skins, "Ace3_RegisterAsWidget", F.Event.GenerateClosure(T.OnEnabledProxy, T, T.HandleWidget))
  self:SecureHook(E, "Config_SetButtonColor", F.Event.GenerateClosure(T.OnEnabledProxy, T, T.HandleButtonColor))
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

  F.Event.ContinueOnAddOnLoaded("Blizzard_Communities", function()
    local communitiesListEntryMixin = CommunitiesListEntryMixin

    if communitiesListEntryMixin then
      if not self:IsHooked(communitiesListEntryMixin, "SetAddCommunity") then
        self:SecureHook(communitiesListEntryMixin, "SetAddCommunity", "UpdateClubInfo")
        self:SecureHook(communitiesListEntryMixin, "SetClubInfo", "UpdateClubInfo")

        if TXUI.IsRetail then
          self:SecureHook(communitiesListEntryMixin, "SetFindCommunity", "UpdateClubInfo")
          self:SecureHook(communitiesListEntryMixin, "SetGuildFinder", "UpdateClubInfo")
        end
      end
    end
  end)

  -- Scan all MetaTables
  self:MetatableScan()

  -- Handle buttons created before we Initialized
  for _, funs in pairs(self.onEnabledCallbacks) do
    local func, args = unpack(funs)
    func(self, unpack(args))
  end

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

function T:OnEnabledProxy(func, ...)
  if not self.Initialized or not self.isEnabled then
    tinsert(self.onEnabledCallbacks, { func, { ... } })
  else
    func(T, ...)
  end
end

T:SecureHook(E.Skins, "HandleButton", F.Event.GenerateClosure(T.OnEnabledProxy, T, T.HandleButton))
T:SecureHook(E.Skins, "Ace3_RegisterAsWidget", F.Event.GenerateClosure(T.OnEnabledProxy, T, T.HandleWidget))
T:SecureHook(E, "Config_SetButtonColor", F.Event.GenerateClosure(T.OnEnabledProxy, T, T.HandleButtonColor))

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
  self.buttonCache = {}

  -- We are done, hooray!
  self.Initialized = true
end

TXUI:RegisterModule(T:GetName())
