local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local DM = TXUI:NewModule("SkinsDamageMeter", "AceHook-3.0")
local S = E:GetModule("Skins")
local M -- Misc module, initialized later
local GR -- Gradients module, initialized later

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

  if not texData then return end

  content.Icon.Icon:SetTexture(texData.texture)
  content.Icon.Icon:SetTexCoord(texData.left, texData.right, texData.top, texData.bottom)
end

-- Get class color for gradient mode
local function GetBarColor(content)
  if content.classFilename then return "classColorMap", content.classFilename end
end

-- Apply gradient colors to the status bar
local function ApplyGradient(content, _, dR, dG, dB)
  if not GR or not GR.db then return end
  if not E.db.TXUI.addons.damageMeter.gradients then return end
  if not content or not content.StatusBar then return end

  -- Set percentage for gradient calculation (always full since we can't access internal value)
  local valueChanged = content.currentPercent == nil
  if valueChanged then content.currentPercent = 1 end

  -- Get current color if not provided
  if not dB then
    local texture = content.StatusBar:GetStatusBarTexture()
    if texture then
      dR, dG, dB = texture:GetVertexColor()
    end
  end

  if not dR then return end

  local colorFunc = F.Event.GenerateClosure(GetBarColor, content)
  GR:SetGradientColors(content, valueChanged, dR, dG, dB, false, colorFunc)
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
    local texture = content.StatusBar:GetStatusBarTexture()
    if texture and not DM:IsHooked(texture, "SetVertexColor") then
      -- Set gradient properties on the content frame
      content.fadeMode = I.Enum.GradientMode.Mode[I.Enum.GradientMode.Mode.HORIZONTAL]
      content.fadeDirection = I.Enum.GradientMode.Direction.RIGHT

      DM:RawHook(texture, "SetVertexColor", F.Event.GenerateClosure(ApplyGradient, content), true)
    end
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
    GR = TXUI:GetModule("ThemesGradients")

    hooksecurefunc(S, "DamageMeter_HandleStatusBar", SkinMeter)

    F.Event.ContinueOnAddOnLoaded("Blizzard_DamageMeter", function()
      if not _G.DamageMeter then return end

      E:Delay(0.1, function()
        _G.DamageMeter:RefreshLayout()
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
