local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local DM = TXUI:NewModule("SkinsDamageMeter", "AceHook-3.0")
local S = E:GetModule("Skins")
local M -- Misc module, initialized later

local _G = _G
local hooksecurefunc = hooksecurefunc
local strsplit = strsplit
local tonumber = tonumber

-- Texture paths (cached as constants)
local TEXTURE_SPEC = "Interface\\AddOns\\ElvUI_ToxiUI\\Media\\Textures\\Icons\\ToxiSpecStylized"
local TEXTURE_CLASS = "Interface\\AddOns\\ElvUI_ToxiUI\\Media\\Textures\\Icons\\ToxiClasses"

-- Pre-computed tex coord cache: [key] = { texturePath, left, right, top, bottom }
local TexCoordCache = {}

-- Parse coordinate string once and cache normalized tex coords
local function GetTexCoords(cacheKey, coordString, texturePath)
  local cached = TexCoordCache[cacheKey]
  if cached then return cached end

  local x1, x2, y1, y2 = strsplit(":", coordString)
  x1, x2, y1, y2 = tonumber(x1), tonumber(x2), tonumber(y1), tonumber(y2)

  cached = {
    texture = texturePath,
    left = x1 / 512,
    right = x2 / 512,
    top = y1 / 512,
    bottom = y2 / 512,
  }
  TexCoordCache[cacheKey] = cached
  return cached
end

local function ApplySpecIcon(content)
  if not content.Icon or not content.Icon.Icon then return end
  if not M or not M.BlizzardToSpecID then return end
  if not E.db.TXUI.addons.damageMeter.icons then return end
  if content.spellID then return end

  local texData

  -- Priority 1: Spec icon if available
  if content.specIconID then
    local specID = M.BlizzardToSpecID[content.specIconID]
    if specID and M.SpecIcons[specID] then texData = GetTexCoords("spec_" .. specID, M.SpecIcons[specID], TEXTURE_SPEC) end
  end

  -- Priority 2: Class icon if class is known (for NPCs without spec)
  if not texData and content.classFilename and M.ClassIcons[content.classFilename] then
    texData = GetTexCoords("class_" .. content.classFilename, M.ClassIcons[content.classFilename], TEXTURE_CLASS)
  end

  if not texData then return end

  content.Icon.Icon:SetTexture(texData.texture)
  content.Icon.Icon:SetTexCoord(texData.left, texData.right, texData.top, texData.bottom)
end

-- Gradient color cache (populated lazily, invalidated on settings change)
local gradientOrientation
local fgMapNormal
local fgMapShift

local function EnsureGradientCache()
  if fgMapNormal then return true end

  local fgMap = F.Color.GetMap("classColorMap")
  if not fgMap then
    F.Color.GenerateCache()
    fgMap = F.Color.GetMap("classColorMap")
  end
  if not fgMap then return false end

  fgMapNormal = fgMap[I.Enum.GradientMode.Color.NORMAL]
  fgMapShift = fgMap[I.Enum.GradientMode.Color.SHIFT]
  gradientOrientation = I.Enum.GradientMode.Mode[I.Enum.GradientMode.Mode.HORIZONTAL]
  return fgMapNormal ~= nil and fgMapShift ~= nil
end

local function InvalidateGradientCache()
  fgMapNormal = nil
  fgMapShift = nil
end

-- Apply gradient colors to the status bar (hot path — called on every SetStatusBarColor)
local function ApplyGradient(content)
  if not content then return end

  local classFilename = content.classFilename
  if not classFilename then return end
  if not EnsureGradientCache() then return end

  local normalColor = fgMapNormal[classFilename]
  local shiftColor = fgMapShift[classFilename]
  if not normalColor or not shiftColor then return end

  -- Cache texture reference on the content frame
  local texture = content.txuiBarTexture
  if not texture then
    if not content.StatusBar then return end
    texture = content.StatusBar:GetStatusBarTexture()
    if not texture then return end
    content.txuiBarTexture = texture
  end

  texture:SetGradient(gradientOrientation, shiftColor, normalColor)
end

-- Animation duration for header fade
local HEADER_FADE_DURATION = 0.3
local HEADER_FADE_EASING = "out-quintic"

-- Setup fade animation for a single frame
local function SetupFadeAnimation(frame)
  if not frame or frame.txuiFadeAnim then return end

  frame.txuiFadeAnim = TXUI:CreateAnimationGroup(frame):CreateAnimation("Fade")
  frame.txuiFadeAnim:SetDuration(HEADER_FADE_DURATION)
  frame.txuiFadeAnim:SetEasing(HEADER_FADE_EASING)
end

-- Animate alpha on a single frame
local function AnimateAlpha(frame, alpha)
  if not frame or not frame.txuiFadeAnim then return end

  -- Stop any running animation
  if frame.txuiFadeAnim:IsPlaying() then frame.txuiFadeAnim:Stop() end

  frame.txuiFadeAnim:SetChange(alpha)
  frame.txuiFadeAnim:Play()
end

-- Animate alpha on all header elements
local function AnimateHeaderAlpha(window, alpha)
  if window.DamageMeterTypeDropdown then AnimateAlpha(window.DamageMeterTypeDropdown, alpha) end
  if window.SessionDropdown then AnimateAlpha(window.SessionDropdown, alpha) end
  if window.SettingsDropdown then AnimateAlpha(window.SettingsDropdown, alpha) end
end

-- Set alpha immediately on all header elements (no animation)
local function SetHeaderAlpha(window, alpha)
  if window.DamageMeterTypeDropdown then window.DamageMeterTypeDropdown:SetAlpha(alpha) end
  if window.SessionDropdown then window.SessionDropdown:SetAlpha(alpha) end
  if window.SettingsDropdown then window.SettingsDropdown:SetAlpha(alpha) end
end

local function SkinHeader(window)
  if not window or not window.Header then return end
  if not E.db.TXUI.addons.damageMeter.headerFade then return end
  if window.txuiHeaderHooked then return end
  window.txuiHeaderHooked = true

  -- Make header backdrop transparent
  window.Header:SetAlpha(0)

  local db = E.db.TXUI.addons.damageMeter

  -- Setup fade animations for each header element
  SetupFadeAnimation(window.DamageMeterTypeDropdown)
  SetupFadeAnimation(window.SessionDropdown)
  SetupFadeAnimation(window.SettingsDropdown)

  -- Set initial alpha to hidden (no animation on initial setup)
  SetHeaderAlpha(window, db.headerFadeMinAlpha)

  -- OnEnter: animate header to full alpha
  window:HookScript("OnEnter", function()
    AnimateHeaderAlpha(window, db.headerFadeMaxAlpha)
  end)

  -- OnLeave: animate header to low alpha (only if mouse truly left the window)
  window:HookScript("OnLeave", function()
    if window:IsMouseOver() then return end
    AnimateHeaderAlpha(window, db.headerFadeMinAlpha)
  end)
end

-- Hook into ElvUI's S:DamageMeter_HandleStatusBar for each meter bar
local function SkinMeter(content)
  if not content or not content.StatusBar then return end
  if content.txuiHooked then return end
  content.txuiHooked = true

  -- Hook UpdateIcon for future updates and apply immediately
  if content.UpdateIcon then hooksecurefunc(content, "UpdateIcon", ApplySpecIcon) end
  ApplySpecIcon(content)

  -- Hook for gradient mode (works with any theme)
  if E.db.TXUI.addons.damageMeter.gradients then
    if not DM:IsHooked(content.StatusBar, "SetStatusBarColor") then DM:SecureHook(content.StatusBar, "SetStatusBarColor", F.Event.GenerateClosure(ApplyGradient, content)) end
    ApplyGradient(content)
  end
end

function DM:Initialize()
  if self.Initialized then return end

  F.Event.RegisterOnceCallback("TXUI.InitializedSafe", function()
    -- Check requirements and if module is enabled
    if not TXUI:HasRequirements(I.Requirements.DamageMeter) then return end
    if not E.db.TXUI.addons.damageMeter.enabled then return end

    -- Get modules now that everything is loaded
    M = TXUI:GetModule("Misc")

    hooksecurefunc(S, "DamageMeter_HandleStatusBar", SkinMeter)

    -- Re-apply gradients when gradient settings change
    if E.db.TXUI.addons.damageMeter.gradients then
      local function RefreshGradients()
        if not _G.DamageMeter then return end
        InvalidateGradientCache()
        F.Color.GenerateCache()
        _G.DamageMeter:ForEachSessionWindow(function(window)
          local ScrollBox = window.GetScrollBox and window:GetScrollBox()
          if ScrollBox and ScrollBox.ForEachFrame then ScrollBox:ForEachFrame(ApplyGradient) end
        end)
      end

      F.Event.RegisterCallback("ThemesGradients.SettingsUpdate.Health", RefreshGradients, self)
      F.Event.RegisterCallback("ThemesGradients.DatabaseUpdate", RefreshGradients, self)
    end

    F.Event.ContinueOnAddOnLoaded("Blizzard_DamageMeter", function()
      if not _G.DamageMeter then return end

      -- Apply skins to existing session windows
      _G.DamageMeter:ForEachSessionWindow(function(window)
        SkinHeader(window)

        -- Apply SkinMeter to any already-created bars (avoids RefreshLayout taint)
        local ScrollBox = window.GetScrollBox and window:GetScrollBox()
        if ScrollBox and ScrollBox.ForEachFrame then ScrollBox:ForEachFrame(SkinMeter) end
      end)

      -- Enable and show the damage meter
      local isDamageMeterEnabled = C_CVar.GetCVarBool("damageMeterEnabled")
      if not isDamageMeterEnabled then
        C_CVar.SetCVar("damageMeterEnabled", "1")
        _G.DamageMeter:Show()
      end
    end)
  end)

  self.Initialized = true
end

if TXUI.IsRetail then TXUI:RegisterModule(DM:GetName()) end
