local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local SD = TXUI:NewModule("SkinsDetailsDark", "AceHook-3.0")

-- Globals
local ipairs = ipairs

-- Vars
local DT
local LSM

function SD:RefreshDetails()
  for _, instance in DT:ListInstances() do
    if instance.iniciada then
      instance:InstanceReset()
      instance:InstanceRefreshRows()
      instance:ReajustaGump()
      instance:ForceRefresh()
    end
  end
end

function SD:CalculateBackdropColor(eColors, r, g, b)
  local elvUIColors = eColors or E.db.unitframe.colors
  local multiplier = (elvUIColors.healthMultiplier > 0 and elvUIColors.healthMultiplier) or 0.35

  if elvUIColors.customhealthbackdrop then
    r, g, b = elvUIColors.health_backdrop.r, elvUIColors.health_backdrop.g, elvUIColors.health_backdrop.b
  else
    r, g, b = r * multiplier, g * multiplier, b * multiplier
  end

  return r, g, b
end

function SD:RefreshRow(row, r, g, b, bgR, bgG, bgB)
  row.textura:SetVertexColor(r, g, b, 1)

  if self.db.transparency then
    row.background:SetVertexColor(bgR, bgG, bgB, self.db.transparencyAlpha)
  else
    row.background:SetVertexColor(bgR, bgG, bgB, 1)
  end

  -- Gradient names
  if E.db.TXUI.themes.darkMode.enabled and E.db.TXUI.themes.darkMode.gradientName and E.db.TXUI.themes.darkMode.detailsGradientText then
    for i = 1, 4 do
      local textTable = row["lineText" .. i]
      if textTable then
        local text = textTable:GetText()
        if text and text ~= "" and text ~= "waiting for refresh..." then
          local unit = row:GetActor()
          -- for some fucking reason on deaths window, unit table is different than usual
          -- unit[4] is unit's CLASS
          local class = unit and (unit.classe or unit[4]) or nil

          local reverse = i ~= 1
          local gradientText = F.String.GradientClass(F.String.StripColor(text), class, reverse)
          textTable:SetText(gradientText or "BUG")
        end
      end
    end
  end

  self.updateCache[row] = true
end

function SD:RefreshRows(instance, instanceSpecific)
  if not self.isEnabled or not self.db or not self.db.enabled then return end

  if instanceSpecific then instance = instanceSpecific end
  if not instance or not instance.barras then return self:LogDebug("Instance is empty", instance) end

  local elvUIColors = E.db.unitframe.colors
  local r, g, b = elvUIColors.health.r, elvUIColors.health.g, elvUIColors.health.b
  local bgR, bgG, bgB = self:CalculateBackdropColor(elvUIColors, r, g, b)

  for _, bar in ipairs(instance.barras) do
    if not bar or not bar.textura then return end

    self:RefreshRow(bar, r, g, b, bgR, bgG, bgB)
  end
end

function SD:EndRefresh(_, instance)
  self:RefreshRows(instance)
end

function SD:SettingsUpdate()
  if not DT or not self.isEnabled or not self.Initialized then return end

  self.updateCache = {}
  self:RefreshDetails()
end

function SD:Disable()
  if not DT or not self.Initialized then return end
  if not self:IsHooked(DT, "InstanceRefreshRows") then return end

  self:UnhookAll()

  -- Set old colors if using our profile
  if TXUI:HasRequirements(I.Enum.Requirements.DETAILS_LOADED_AND_TXPROFILE) then
    for _, instance in DT:ListInstances() do
      instance.row_info.textL_class_colors = false
      instance.row_info.textR_class_colors = false
      instance.row_info.texture_class_colors = true
    end

    -- Refresh after unhook
    self:RefreshDetails()
  end
end

function SD:Enable()
  if not self.isEnabled or not self.Initialized then return end
  if self:IsHooked(DT, "InstanceRefreshRows") then return end

  -- Get frameworks
  DT = DT or Details
  LSM = LSM or E.Libs.LSM

  -- Sanity check
  if not DT or not LSM then return self:LogDebug("Could not get frameworks", DT, LSM) end

  -- Set correct colors
  for _, instance in DT:ListInstances() do
    instance.row_info.textL_class_colors = true
    instance.row_info.textR_class_colors = true
    instance.row_info.texture_class_colors = false
  end

  -- Hook functions
  self:SecureHook(DT, "InstanceRefreshRows", F.Event.GenerateClosure(self.RefreshRows, self))
  self:SecureHook(DT, "EndRefresh", F.Event.GenerateClosure(self.EndRefresh, self))
  self:SecureHook(DT, "ApplyProfile", F.Event.GenerateClosure(self.DatabaseUpdate, self))

  -- Refresh after hook
  self:SettingsUpdate()
end

function SD:DatabaseUpdate()
  -- Set db
  self.db = F.GetDBFromPath("TXUI.themes.darkMode")

  -- Set enable state
  local isEnabled = (self.db and self.db.enabled) and TXUI:HasRequirements(I.Requirements.DetailsDarkMode)
  local isTransparencyEnabled = isEnabled and self.db.transparency

  if self.isEnabled == isEnabled and self.isTransparencyEnabled == isTransparencyEnabled then return end
  self.isEnabled = isEnabled
  self.isTransparencyEnabled = isTransparencyEnabled

  F.Event.ContinueOutOfCombat(function()
    -- Disable only out of combat
    self:Disable()

    -- Enable only if details is loaded
    if self.isEnabled then self:Enable() end
  end)
end

function SD:Initialize()
  -- Don't init second time
  if self.Initialized then return end

  -- Vars
  self.updateCache = {}

  -- Keep track if we have  transparency enabled
  self.isTransparencyEnabled = false

  -- Register for updates
  F.Event.RegisterCallback("TXUI.DatabaseUpdate", self.DatabaseUpdate, self)
  F.Event.RegisterCallback("SkinsDetailsDark.DatabaseUpdate", self.DatabaseUpdate, self)
  F.Event.RegisterCallback("SkinsDetailsDark.SettingsUpdate", self.SettingsUpdate, self)

  -- Trigger Update when Details is loaded
  F.Event.RegisterOnceCallback("TXUI.InitializedSafe", function()
    F.Event.ContinueOnAddOnLoaded("Details", function()
      self:DatabaseUpdate()
    end)
  end)

  -- We are done, hooray!
  self.Initialized = true
end

TXUI:RegisterModule(SD:GetName())
