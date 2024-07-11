local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local SD = TXUI:NewModule("SkinsDetailsGradients", "AceHook-3.0")

-- Globals
local abs = math.abs
local ipairs = ipairs

-- Vars
local DT
local GR

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

function SD:RefreshTexture(row)
  if not self.isEnabled or not self.db or not self.db.enabled then return end
  self.hooks[row.textura]["SetTexture"](row.textura, self.db.texture)
  if row.background then row.background.SetTexture(row.background, self.db.texture) end
end

function SD:GetRowColor(frame)
  local actor = frame.minha_tabela
  if actor then
    local classId
    if actor.class then
      classId = actor:class()
    elseif actor[4] then
      -- Index 4 is the element that holds the classId
      -- If this breaks in the future it is likely this element has moved
      classId = actor[4]
    end
    if classId and classId ~= "UNKNOW" then return "classColorMap", classId end
  end
end

function SD:RefreshRow(frame, _, dR, dG, dB)
  if not self.isEnabled or not self.db or not self.db.enabled then return end
  if not frame or not frame.textura then return self:LogDebug("Row is empty", frame) end

  local statusMin, statusMax = frame.statusbar:GetMinMaxValues()
  local valuePercentage = (frame.statusbar:GetValue() - statusMin) / (statusMax - statusMin)
  local valueChanged = frame.currentPercent == nil or (abs(frame.currentPercent - valuePercentage) > 0.05)
  if valueChanged then frame.currentPercent = valuePercentage end

  -- if not self.updateCache[frame] then
  -- https://discord.com/channels/769550106948141086/769550106948141088/1163948358331813959
  -- if frame.lineBorder then frame.lineBorder:Kill() end
  -- frame.statusbar:CreateBackdrop("Default", nil, false, false, true)
  -- self:RefreshTexture(frame)
  -- end

  if not dB then
    dR, dG, dB = frame.textura:GetVertexColor()
  end

  local colorFunc = F.Event.GenerateClosure(self.GetRowColor, self, frame)
  GR:SetGradientColors(frame, valueChanged, dR, dG, dB, false, colorFunc)
end

function SD:RefreshRows(instance, instanceSpecific)
  if not self.isEnabled or not self.db or not self.db.enabled then return end

  if instanceSpecific then instance = instanceSpecific end
  if not instance or not instance.barras then return self:LogDebug("Instance is empty", instance) end

  for _, bar in ipairs(instance.barras) do
    if not bar or not bar.textura then return end

    -- Hook for Color Update
    if not self:IsHooked(bar.textura, "SetVertexColor") then
      bar.fadeMode = I.Enum.GradientMode.Mode[I.Enum.GradientMode.Mode.HORIZONTAL]
      bar.fadeDirection = I.Enum.GradientMode.Direction.RIGHT

      self:RawHook(bar.textura, "SetVertexColor", F.Event.GenerateClosure(self.RefreshRow, self, bar), true)
      -- self:RawHook(bar.textura, "SetTexture", F.Event.GenerateClosure(self.RefreshTexture, self, bar), true)
      -- self:SecureHook(bar.statusbar, "SetValue", F.Event.GenerateClosure(self.RefreshTexture, self, bar), true)
    end
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
  GR = GR or TXUI:GetModule("ThemesGradients")

  -- Sanity check
  if not DT then return self:LogDebug("Could not get framework", DT) end

  -- Set correct colors
  for _, instance in DT:ListInstances() do
    instance.row_info.textL_class_colors = false
    instance.row_info.textR_class_colors = false
    instance.row_info.texture_class_colors = true
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
  self.db = F.GetDBFromPath("TXUI.themes.gradientMode")

  -- Set enable state
  local isEnabled = (self.db and self.db.enabled) and TXUI:HasRequirements(I.Requirements.DetailsGradientMode)

  if self.isEnabled == isEnabled then return end
  self.isEnabled = isEnabled

  F.Event.ContinueOutOfCombat(function()
    -- Disable only out of combat
    self:Disable()

    -- Enable only if details is loaded
    F.Event.RunNextFrame(function()
      if self.isEnabled then self:Enable() end
    end)
  end)
end

function SD:Initialize()
  -- Don't init second time
  if self.Initialized then return end

  -- Vars
  self.isEnabled = false
  self.updateCache = {}

  -- Register for updates
  F.Event.RegisterCallback("TXUI.DatabaseUpdate", self.DatabaseUpdate, self)
  F.Event.RegisterCallback("SkinsDetailsGradients.DatabaseUpdate", self.DatabaseUpdate, self)
  F.Event.RegisterCallback("SkinsDetailsGradients.SettingsUpdate", self.SettingsUpdate, self)

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
