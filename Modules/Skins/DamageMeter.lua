local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local DM = TXUI:NewModule("SkinsDamageMeter")
local M -- Misc module, initialized later

local _G = _G
local hooksecurefunc = hooksecurefunc
local strsplit = strsplit
local tonumber = tonumber

local TEXTURE_SPEC
local TEXTURE_CLASS = "Interface\\AddOns\\ElvUI_ToxiUI\\Media\\Textures\\Icons\\ToxiClasses"

local hasSpecIcons

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
  if hasSpecIcons and content.specIconID then
    local specID = M.BlizzardToSpecID[content.specIconID]
    if specID and M.SpecIcons[specID] then texData = GetTexCoords("spec_" .. specID, M.SpecIcons[specID], TEXTURE_SPEC) end
  end

  -- Priority 2: Class icon — for class-only styles use TEXTURE_SPEC (the chosen sheet);
  -- for ToxiSpecStylized use TEXTURE_CLASS (ToxiClasses) as fallback alongside spec icons
  if not texData and content.classFilename and M.ClassIcons[content.classFilename] then
    local classTexture = hasSpecIcons and TEXTURE_CLASS or TEXTURE_SPEC
    texData = GetTexCoords("class_" .. content.classFilename, M.ClassIcons[content.classFilename], classTexture)
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

local function ApplyGradientToTexture(texture, classFilename)
  if not EnsureGradientCache() then return end
  local normalColor = fgMapNormal[classFilename]
  local shiftColor = fgMapShift[classFilename]
  if not normalColor or not shiftColor then return end
  F.Color.SetGradient(texture, gradientOrientation, normalColor, shiftColor)
end

-- Apply gradient colors to a bar texture using the content's class
local function ApplyGradient(content)
  if not content then return end

  local classFilename = content.classFilename
  if not classFilename then return end

  -- Cache texture reference on the content frame
  local texture = content.txuiBarTexture
  if not texture then
    if not content.StatusBar then return end
    texture = content.StatusBar:GetStatusBarTexture()
    if not texture then return end
    content.txuiBarTexture = texture
  end

  ApplyGradientToTexture(texture, classFilename)
end

local function SkinMeter(content)
  if not content or not content.StatusBar then return end

  if not content.txuiHooked then
    content.txuiHooked = true

    if content.UpdateIcon then hooksecurefunc(content, "UpdateIcon", ApplySpecIcon) end

    if E.db.TXUI.addons.damageMeter.gradients then
      local barTexture = content.StatusBar:GetStatusBarTexture()
      if barTexture and not barTexture.txuiGradientHooked then
        barTexture.txuiGradientHooked = true
        content.txuiBarTexture = barTexture

        hooksecurefunc(barTexture, "SetVertexColor", function()
          if not E.db.TXUI.addons.damageMeter.gradients then return end
          if not content.classFilename then return end
          ApplyGradientToTexture(barTexture, content.classFilename)
        end)
      end
    end
  end

  ApplySpecIcon(content)
  if E.db.TXUI.addons.damageMeter.gradients then ApplyGradient(content) end
end

local function HookScrollBox(scrollBox)
  if not scrollBox or scrollBox.txuiHooked then return end
  scrollBox.txuiHooked = true

  hooksecurefunc(scrollBox, "Update", function(self)
    if self.ForEachFrame then self:ForEachFrame(SkinMeter) end
  end)

  if scrollBox.ForEachFrame then scrollBox:ForEachFrame(SkinMeter) end
end

-- Hide the "sticky self row" (LocalPlayerEntry) that floats while scrolling
local function GetSessionLocalPlayerEntry(window)
  if not window then return nil end
  if window.GetLocalPlayerEntry then return window:GetLocalPlayerEntry() end

  local container = window.MinimizeContainer or window
  return container and container.LocalPlayerEntry
end

local function GetSessionSourceWindow(window)
  if not window then return nil end
  if window.GetSourceWindow then return window:GetSourceWindow() end

  return window.SourceWindow
end

local function HideLocalPlayerEntry(window)
  if not E.db.TXUI.addons.damageMeter.hideLocalPlayerEntry then return end

  local entry = GetSessionLocalPlayerEntry(window)
  if not entry then return end

  entry:Hide()
  entry:SetAlpha(0)
  entry:EnableMouse(false)
end

local function HookLocalPlayerEntry(window)
  if not window or window.txuiLocalPlayerEntryHooked then return end
  window.txuiLocalPlayerEntryHooked = true

  -- Hide now
  HideLocalPlayerEntry(window)

  -- Prevent it from coming back on scroll/refresh
  if window.ShowLocalPlayerEntry then hooksecurefunc(window, "ShowLocalPlayerEntry", function(self)
    HideLocalPlayerEntry(self)
  end) end

  if window.EnsureLocalPlayerPresent then hooksecurefunc(window, "EnsureLocalPlayerPresent", function(self)
    HideLocalPlayerEntry(self)
  end) end

  -- Safety: if the frame is shown for any reason, re-hide
  window:HookScript("OnShow", function(self)
    HideLocalPlayerEntry(self)
  end)
end

local function HookSessionWindow(window)
  if not window then return end

  -- Hide sticky local player row
  if E.db.TXUI.addons.damageMeter.hideLocalPlayerEntry then HookLocalPlayerEntry(window) end

  local scrollBox = window.GetScrollBox and window:GetScrollBox()
  if scrollBox then HookScrollBox(scrollBox) end

  -- Source window (spell breakdown) is under MinimizeContainer; use GetSourceWindow()
  local sourceWindow = GetSessionSourceWindow(window)
  if sourceWindow then
    local sourceScrollBox = sourceWindow.GetScrollBox and sourceWindow:GetScrollBox()
    if sourceScrollBox then HookScrollBox(sourceScrollBox) end
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

    local iconStyle = E.db.TXUI.elvUIIcons.classIcons.theme or "ToxiSpecStylized"
    TEXTURE_SPEC = "Interface\\AddOns\\ElvUI_ToxiUI\\Media\\Textures\\Icons\\" .. iconStyle
    hasSpecIcons = iconStyle:match("ToxiSpec")

    -- Re-apply gradients when gradient settings change
    if E.db.TXUI.addons.damageMeter.gradients then
      local function RefreshGradients()
        if not _G.DamageMeter then return end
        InvalidateGradientCache()
        F.Color.GenerateCache()
        _G.DamageMeter:ForEachSessionWindow(function(window)
          local scrollBox = window.GetScrollBox and window:GetScrollBox()
          if scrollBox and scrollBox.ForEachFrame then scrollBox:ForEachFrame(ApplyGradient) end

          local sourceWindow = GetSessionSourceWindow(window)
          if sourceWindow then
            local sourceScrollBox = sourceWindow.GetScrollBox and sourceWindow:GetScrollBox()
            if sourceScrollBox and sourceScrollBox.ForEachFrame then sourceScrollBox:ForEachFrame(ApplyGradient) end
          end
        end)
      end

      F.Event.RegisterCallback("ThemesGradients.SettingsUpdate.Health", RefreshGradients, self)
      F.Event.RegisterCallback("ThemesGradients.DatabaseUpdate", RefreshGradients, self)
    end

    F.Event.ContinueOnAddOnLoaded("Blizzard_DamageMeter", function()
      if not _G.DamageMeter then return end

      hooksecurefunc(_G.DamageMeter, "SetupSessionWindow", function()
        _G.DamageMeter:ForEachSessionWindow(HookSessionWindow)
      end)

      -- Apply to existing session windows
      _G.DamageMeter:ForEachSessionWindow(HookSessionWindow)

      -- Enable and show the damage meter
      local isDamageMeterEnabled = C_CVar.GetCVarBool("damageMeterEnabled")
      if not isDamageMeterEnabled then
        E:SetCVar("damageMeterEnabled", "1")
        _G.DamageMeter:Show()
      end

      -- Sync reset-on-new-instance CVar with option
      E:SetCVar("damageMeterResetOnNewInstance", E.db.TXUI.addons.damageMeter.resetOnNewInstance and "1" or "0")
    end)
  end)

  self.Initialized = true
end

if TXUI.IsRetail then TXUI:RegisterModule(DM:GetName()) end
