local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local GR = TXUI:GetModule("ThemesGradients")

local GetSpecialization = C_SpecializationInfo and C_SpecializationInfo.GetSpecialization
local hooksecurefunc = hooksecurefunc
local ipairs = ipairs
local next = next

local orientation = "HORIZONTAL"
local SHIFT, NORMAL = I.Enum.GradientMode.Color.SHIFT, I.Enum.GradientMode.Color.NORMAL

-- Rune type -> resource key. Retail uses the specialization, Wrath/Mists use Blizzard's rune types
local runeKeys = TXUI.IsRetail and { "RUNE_BLOOD", "RUNE_FROST", "RUNE_UNHOLY" } or { "RUNE_BLOOD", "RUNE_UNHOLY", "RUNE_FROST", "RUNE_DEATH" }

-- Every pip gets the full gradient (like the vigor bar), resources without a key keep ElvUI's color
local function ApplyGradient(bar, key)
  local colorMap = F.Color.GetMap("classResourceMap")
  local shiftColor, normalColor = colorMap and colorMap[SHIFT][key], colorMap and colorMap[NORMAL][key]
  if not shiftColor or not normalColor then return end

  F.Color.SetGradient(bar:GetStatusBarTexture(), orientation, shiftColor, normalColor)

  -- Keep a custom class power backdrop from ElvUI
  if bar.bg and not E.db.unitframe.colors.customclasspowerbackdrop then
    local bgMap = F.Color.GetBackgroundMap("classResourceMap")
    if bgMap then F.Color.SetGradient(bar.bg, orientation, bgMap[SHIFT][key], bgMap[NORMAL][key]) end
  end
end

function GR:IsClassResourcesActive()
  return self.isEnabled and self.db and self.db.enabled and self.db.classResources
end

function GR:UpdateRuneGradient(rune)
  local value = rune:GetValue()
  if E:IsSecretValue(value) then return end

  -- Recharging runes keep ElvUI's charging color
  if E.db.unitframe.colors.chargingRunes then
    local isReady
    if TXUI.IsRetail then
      isReady = value == 1
    else
      local _, maxValue = rune:GetMinMaxValues()
      isReady = value == maxValue
    end

    if not isReady then return end
  end

  local runeType = rune.runeType or (GetSpecialization and GetSpecialization()) or 1
  local key = runeKeys[runeType]
  if key then ApplyGradient(rune, key) end
end

function GR:ClassPowerUpdateColor(element, powerType, rune)
  if not element or not self:IsClassResourcesActive() then return end

  if powerType == "RUNES" then
    if rune then
      self:UpdateRuneGradient(rune)
    else
      for _, bar in ipairs(element) do
        self:UpdateRuneGradient(bar)
      end
    end
  elseif powerType == "COMBO_POINTS" then
    for index, bar in ipairs(element) do
      ApplyGradient(bar, "COMBO_POINT_" .. index)
    end
  elseif powerType then
    for _, bar in ipairs(element) do
      ApplyGradient(bar, powerType)
    end
  end
end

-- ElvUI colors charged combo points after the class power colors
function GR:ClassPowerPostUpdate(element, _, _, _, powerType, chargedPoints)
  if powerType ~= "COMBO_POINTS" or not chargedPoints or not self:IsClassResourcesActive() then return end

  for _, index in next, chargedPoints do
    local bar = element[index]
    if bar then ApplyGradient(bar, "COMBO_POINT_CHARGED") end
  end
end

function GR:RunesUpdateCharged(_, runes, rune)
  if not self:IsClassResourcesActive() then return end

  if rune then
    self:UpdateRuneGradient(rune)
  elseif runes then
    self:ClassPowerUpdateColor(runes, "RUNES")
  end
end

-- The class power element keeps its own reference to ElvUI's color function, so hook it on the element.
-- Plain hooks survive Disable and are gated by IsClassResourcesActive
function GR:ConfigureClassBar(_, frame)
  local element = frame and frame.ClassPower
  if not element or element.txGradientHooked then return end
  element.txGradientHooked = true

  hooksecurefunc(element, "UpdateColor", function(...)
    self:ClassPowerUpdateColor(...)
  end)

  hooksecurefunc(element, "PostUpdate", function(...)
    self:ClassPowerPostUpdate(...)
  end)
end

-- ForceUpdate runs ElvUI's coloring again, the hooks add the gradients on top while active
function GR:RefreshClassResources()
  local frame = self.uf and self.uf.player
  if not frame then return end

  if frame.ClassPower and frame.ClassPower.ForceUpdate then frame.ClassPower:ForceUpdate() end
  if frame.Runes and frame.Runes.ForceUpdate then frame.Runes:ForceUpdate() end
end

function GR:ClassResourcesSettingsUpdate()
  F.Color.GenerateCache()
  self:RefreshClassResources()
end

function GR:EnableClassResources()
  self:SecureHook(self.uf, "ClassPower_UpdateColor", "ClassPowerUpdateColor")
  self:SecureHook(self.uf, "Runes_UpdateCharged", "RunesUpdateCharged")
  self:SecureHook(self.uf, "Configure_ClassBar", "ConfigureClassBar")

  if self.uf.player then self:ConfigureClassBar(nil, self.uf.player) end
  self:RefreshClassResources()
end
