local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local DM = TXUI:NewModule("SkinsDamageMeter", "AceHook-3.0")
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

  -- Priority 3: ToxiUI logo fallback
  if not texData then
    TXUI:LogDebug("DamageMeter: Unknown icon - specIconID: ", content.specIconID, " classFilename: ", content.classFilename)
    texData = GetTexCoords("fallback", "0:64:320:384", TEXTURE_SPEC)
  end

  content.Icon.Icon:SetTexture(texData.texture)
  content.Icon.Icon:SetTexCoord(texData.left, texData.right, texData.top, texData.bottom)
end

-- Called for each meter bar after ElvUI's SkinMeter has run
local function SkinMeter(content)
  if not content or not content.StatusBar then return end
  if content.txuiHooked then return end
  content.txuiHooked = true

  -- Hook UpdateIcon to apply ToxiUI spec icons on future updates
  if content.UpdateIcon then hooksecurefunc(content, "UpdateIcon", function(self)
    ApplySpecIcon(self)
  end) end

  -- Apply immediately for current state
  ApplySpecIcon(content)
end

local function HookScrollBox(scrollBox)
  if not scrollBox or scrollBox.txuiHooked then return end

  hooksecurefunc(scrollBox, "Update", function(sb)
    sb:ForEachFrame(SkinMeter)
  end)
  scrollBox.txuiHooked = true

  -- Process existing frames
  scrollBox:ForEachFrame(SkinMeter)
end

local function HookSessionWindows()
  if not _G.DamageMeter then return end

  _G.DamageMeter:ForEachSessionWindow(function(window)
    local ScrollBox = window.GetScrollBox and window:GetScrollBox()
    if ScrollBox then HookScrollBox(ScrollBox) end
  end)
end

function DM:Initialize()
  if self.Initialized then return end

  F.Event.RegisterOnceCallback("TXUI.InitializedSafe", function()
    -- Check if module is enabled
    if not E.db.TXUI.addons.damageMeter.enabled then return end

    -- Get Misc module now that everything is loaded
    M = TXUI:GetModule("Misc")

    F.Event.ContinueOnAddOnLoaded("Blizzard_DamageMeter", function()
      -- Hook existing windows
      HookSessionWindows()

      -- Hook future windows
      hooksecurefunc(_G.DamageMeter, "SetupSessionWindow", HookSessionWindows)
    end)
  end)

  self.Initialized = true
end

if TXUI.IsRetail then TXUI:RegisterModule(DM:GetName()) end
