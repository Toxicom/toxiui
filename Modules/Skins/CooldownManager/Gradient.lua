local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local CM = TXUI:GetModule("CooldownManager")

local _G = _G
local hooksecurefunc = hooksecurefunc

-- Blizzard sets the bar color once in XML and never touches it again, other skins (WindTools)
-- color bars when they are acquired inside RefreshLayout, so a RefreshLayout post-hook runs last
local gradientOrientation = "HORIZONTAL"

function CM:GetBuffBarGradientColors()
  F.Color.GenerateCache()

  local colorMap = F.Color.GetMap("classColorMap")
  if not colorMap then return end

  return colorMap[I.Enum.GradientMode.Color.SHIFT][E.myclass], colorMap[I.Enum.GradientMode.Color.NORMAL][E.myclass]
end

function CM:ApplyBuffBarGradient()
  if not self.buffBarGradientActive then return end

  local viewer = _G[self.frameNames.buffBar]
  if not viewer or not viewer.itemFramePool then return end

  local shiftColor, normalColor = self.buffBarShiftColor, self.buffBarNormalColor
  if not shiftColor or not normalColor then return end

  for frame in viewer.itemFramePool:EnumerateActive() do
    local texture = frame.Bar and frame.Bar:GetStatusBarTexture()
    if texture then F.Color.SetGradient(texture, gradientOrientation, shiftColor, normalColor) end
  end
end

function CM:UpdateBuffBarGradientColors()
  self.buffBarShiftColor, self.buffBarNormalColor = self:GetBuffBarGradientColors()
  self:ApplyBuffBarGradient()
end

function CM:EnableBuffBarGradient()
  local viewer = _G[self.frameNames.buffBar]
  if not viewer then return end

  self.buffBarGradientActive = true

  -- Plain hook, AceHook can't hook RefreshLayout twice and Centering might already own it.
  -- It stays in place across Disable/Enable and is gated by buffBarGradientActive
  if not viewer.txBuffBarGradientHooked then
    viewer.txBuffBarGradientHooked = true
    hooksecurefunc(viewer, "RefreshLayout", function()
      self:ApplyBuffBarGradient()
    end)
  end

  F.Event.RegisterCallback("ThemesGradients.SettingsUpdate.Health", self.UpdateBuffBarGradientColors, self)
  F.Event.RegisterCallback("ThemesGradients.SettingsUpdate", self.UpdateBuffBarGradientColors, self)

  self:UpdateBuffBarGradientColors()
end

function CM:DisableBuffBarGradient()
  if not self.buffBarGradientActive then return end
  self.buffBarGradientActive = false

  F.Event.UnregisterCallback("ThemesGradients.SettingsUpdate.Health", self)
  F.Event.UnregisterCallback("ThemesGradients.SettingsUpdate", self)
end
