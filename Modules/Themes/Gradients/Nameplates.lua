local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local GR = TXUI:GetModule("ThemesGradients")

local pairs = pairs
local C_Timer_After = C_Timer.After

local COLOR_SHIFT = I.Enum.GradientMode.Color.SHIFT
local COLOR_NORMAL = I.Enum.GradientMode.Color.NORMAL
local DIRECTION_LEFT = I.Enum.GradientMode.Direction.LEFT
local DIRECTION_RIGHT = I.Enum.GradientMode.Direction.RIGHT
local ORIENTATION = I.Enum.GradientMode.Mode[I.Enum.GradientMode.Mode.HORIZONTAL]

--[[
  Nameplate health gradients

  ElvUI recolors nameplate health on every UNIT_HEALTH tick (oUF runs the color path after each health update),
  and every recolor wipes a gradient. Instead of re-applying the gradient on each tick, ElvUI's repaint is skipped
  for health bars and the gradient is only painted when the color ElvUI picked actually changes.

  ElvUI hands out shared color tables (NP.Colors.*, NP.db.colors.threat.*, oUF class colors), so "did the color change"
  is a single table comparison. Colors that are rebuilt on every call (smooth health, secret class colors) have no
  gradient pair and are painted flat, exactly like ElvUI would.
]]

-- ElvUI NP.db.colors.threat keys -> threatColorMap keys
local threatKeys = {
  goodColor = "GOOD",
  badColor = "BAD",
  goodTransition = "GOOD_TRANSITION",
  badTransition = "BAD_TRANSITION",
  offTankColor = "OFFTANK",
  offTankColorGoodTransition = "OFFTANK_GOOD_TRANSITION",
  offTankColorBadTransition = "OFFTANK_BAD_TRANSITION",
  soloColor = "SOLO",
}

-- ElvUI NP.Colors.classification keys -> classificationColorMap keys
local classificationKeys = {
  worldboss = "WORLDBOSS",
  rareelite = "RAREELITE",
  rare = "RARE",
  eliteBoss = "ELITE_BOSS",
  eliteMini = "ELITE_MINI",
  caster = "CASTER",
}

-- UnitSelectionType index -> reactionColorMap keys (9 = dead is handled separately)
local selectionKeys = {
  [0] = "BAD", -- hostile
  [1] = "BAD", -- unfriendly
  [2] = "NEUTRAL",
  [3] = "GOOD", -- friendly
  [5] = "GOOD", -- player extended
  [6] = "GOOD", -- party
  [7] = "GOOD", -- party pvp
  [8] = "GOOD", -- friend
  [13] = "GOOD", -- battleground friendly pvp
}

local function InvalidateHealth(element)
  element.__txColor = nil
end

local function PostUpdateHealthColor(element, _, color)
  -- Hot path: runs on every health tick of every nameplate
  if color == nil or color == element.__txColor then return end
  GR:ApplyNameplateGradient(element, color)
end

function GR:BuildNameplateColorLookup()
  local maps, keys = {}, {}

  local function add(color, colorMap, colorEntry)
    if color then
      maps[color] = colorMap
      keys[color] = colorEntry
    end
  end

  local colors = self.np.Colors
  local threatColors = self.np.db and self.np.db.colors and self.np.db.colors.threat

  if threatColors then
    for elvKey, key in pairs(threatKeys) do
      add(threatColors[elvKey], "threatColorMap", key)
    end
  end

  if colors then
    if colors.classification then
      for elvKey, key in pairs(classificationKeys) do
        add(colors.classification[elvKey], "classificationColorMap", key)
      end
    end

    if colors.reactions then
      for i = 1, 8 do
        add(colors.reactions[i], "reactionColorMap", (i > 4 and "GOOD") or (i == 4 and "NEUTRAL") or "BAD")
      end
    end

    if colors.selection then
      for index, key in pairs(selectionKeys) do
        add(colors.selection[index], "reactionColorMap", key)
      end

      add(colors.selection[9], "specialColorMap", "DEAD")
    end

    add(colors.tapped, "specialColorMap", "TAPPED")
  end

  local oUFColors = E.oUF and E.oUF.colors
  if oUFColors then
    add(oUFColors.disconnected, "specialColorMap", "DISCONNECTED")

    if oUFColors.class then
      for classToken, color in pairs(oUFColors.class) do
        add(color, "classColorMap", classToken)
      end
    end
  end

  self.npLookupMap = maps
  self.npLookupKey = keys
end

function GR:ApplyNameplateGradient(element, color)
  local colorMap = self.npLookupMap[color]
  local fgMap = colorMap and F.Color.GetMap(colorMap)

  local shiftColor, normalColor
  if fgMap then
    local colorEntry = self.npLookupKey[color]
    shiftColor = fgMap[COLOR_SHIFT][colorEntry]
    normalColor = fgMap[COLOR_NORMAL][colorEntry]
  end

  if not shiftColor or not normalColor then
    -- No gradient pair for this color: paint it flat like ElvUI would.
    -- This clears __txColor through the SetStatusBarColor hook, so mutated-in-place colors keep updating.
    if color.GetRGB then
      element:SetStatusBarColor(color:GetRGB())
    else
      element:SetStatusBarColor(color.r, color.g, color.b)
    end
    return
  end

  element.__txColor = color

  local texture = element:GetStatusBarTexture()
  if not texture then return end

  if self.npFadeDirection == DIRECTION_LEFT then
    texture:SetGradient(ORIENTATION, shiftColor, normalColor)
  else
    texture:SetGradient(ORIENTATION, normalColor, shiftColor)
  end
end

-- RawHook on NP:SetStatusBarColor, skips ElvUI's per-tick repaint for health bars we paint
function GR:NameplateSetStatusBarColor(np, bar, ...)
  if bar and bar.__txGradient then return end
  return self.hooks[np].SetStatusBarColor(np, bar, ...)
end

function GR:SetupNameplateHealth(_, nameplate)
  local element = nameplate and nameplate.Health
  if not element or element.__txGradient then return end

  element.__txGradient = true
  element.__txColor = nil

  -- Anything else recoloring the bar directly overwrites our gradient, repaint on the next color update
  if not self:IsHooked(element, "SetStatusBarColor") then self:SecureHook(element, "SetStatusBarColor", InvalidateHealth) end

  if element.PostUpdateColor == nil then
    element.PostUpdateColor = PostUpdateHealthColor
    element.__txOwnsPostUpdateColor = true
  elseif element.PostUpdateColor ~= PostUpdateHealthColor and not self:IsHooked(element, "PostUpdateColor") then
    self:SecureHook(element, "PostUpdateColor", PostUpdateHealthColor)
  end
end

function GR:RefreshNameplates()
  if not self.np or not self.np.Plates or not self:IsNameplatesActive() then return end

  local fadeDirection = self.db.fadeDirection and self.db.fadeDirection.nameplate
  self.npFadeDirection = fadeDirection or DIRECTION_RIGHT

  for nameplate in pairs(self.np.Plates) do
    local element = nameplate.Health
    if element and element.__txGradient then
      element.__txColor = nil
      if nameplate:IsElementEnabled("Health") then element:ForceUpdate() end
    end
  end
end

-- Settings updates fire once per unitframe (and continuously while dragging a color picker),
-- so nameplates are refreshed once on the next frame, after every color cache regeneration is done
function GR:QueueNameplateRefresh()
  if self.npRefreshQueued or not self:IsNameplatesActive() then return end
  self.npRefreshQueued = true

  if not self.npRefreshClosure then self.npRefreshClosure = function()
    self.npRefreshQueued = nil
    self:RefreshNameplates()
  end end

  C_Timer_After(0, self.npRefreshClosure)
end

function GR:NameplateColorsUpdate()
  self:BuildNameplateColorLookup()
  self:RefreshNameplates()
end

function GR:IsNameplatesActive()
  return self.np ~= nil and self:IsHooked(self.np, "Update_Health")
end

function GR:EnableNameplates()
  if not self.isEnabled or not self.db or not self.db.enabled or not self.db.nameplates then return end
  if not E.private.nameplates.enable then return end

  local NP = E:GetModule("NamePlates")
  self.np = NP

  -- Nameplates can initialize after UnitFrames
  if not NP.Initialized then
    if not self:IsHooked(NP, "Initialize") then self:SecureHook(NP, "Initialize", "EnableNameplates") end
    return
  end

  if self:IsNameplatesActive() then return end

  self:BuildNameplateColorLookup()

  self:RawHook(NP, "SetStatusBarColor", "NameplateSetStatusBarColor")
  self:SecureHook(NP, "Update_Health", "SetupNameplateHealth")

  -- Texture changes reset the bar color, color/profile changes swap the color tables
  self:SecureHook(NP, "Update_StatusBars", "RefreshNameplates")
  self:SecureHook(NP, "UpdateColors", "NameplateColorsUpdate")
  self:SecureHook(NP, "ConfigureAll", "NameplateColorsUpdate")

  for nameplate in pairs(NP.Plates) do
    self:SetupNameplateHealth(nil, nameplate)
  end

  self:RefreshNameplates()
end

function GR:DisableNameplates()
  local NP = self.np
  if not NP then return end

  if self:IsHooked(NP, "Initialize") then self:Unhook(NP, "Initialize") end
  if not self:IsNameplatesActive() then return end

  self:Unhook(NP, "SetStatusBarColor")
  self:Unhook(NP, "Update_Health")
  self:Unhook(NP, "Update_StatusBars")
  self:Unhook(NP, "UpdateColors")
  self:Unhook(NP, "ConfigureAll")

  for nameplate in pairs(NP.Plates) do
    local element = nameplate.Health
    if element and element.__txGradient then
      element.__txGradient = nil
      element.__txColor = nil

      if self:IsHooked(element, "SetStatusBarColor") then self:Unhook(element, "SetStatusBarColor") end
      if self:IsHooked(element, "PostUpdateColor") then self:Unhook(element, "PostUpdateColor") end

      if element.__txOwnsPostUpdateColor then
        element.PostUpdateColor = nil
        element.__txOwnsPostUpdateColor = nil
      end

      -- Let ElvUI paint its flat color again
      if nameplate:IsElementEnabled("Health") then element:ForceUpdate() end
    end
  end
end

function GR:NameplatesSettingsUpdate()
  if not self.isEnabled or not self:IsHooked(self.uf, "Configure_HealthBar") then return end

  self:SettingsUpdate()

  if self.db.nameplates then
    self:EnableNameplates()
  else
    self:DisableNameplates()
  end
end
