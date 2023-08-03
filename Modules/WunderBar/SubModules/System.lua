local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local WB = TXUI:GetModule("WunderBar")
local ST = WB:NewModule("System")

local GetFramerate = GetFramerate
local GetNetStats = GetNetStats
local select = select

function ST:OnUpdate(elapsed)
  self.updateWait = self.updateWait - elapsed
  if self.updateWait > 0 then return end

  local framerate = E:Round(GetFramerate())
  local latency = select(self.db.useWorldLatency and 4 or 3, GetNetStats())

  if framerate ~= self.framerate or latency ~= self.latency then
    self.framerate = framerate
    self.latency = latency

    self:UpdateText()
    self:UpdateElements()

    if not self.mouseOver then self:UpdateColor() end
  end

  self:UpdateTooltip()
  self.updateWait = self.db.fastUpdate and 1 or 5
end

function ST:UpdateTooltip()
  if not self.mouseOver then return end

  local dtModule = WB:GetElvUIDataText("System")
  if dtModule then dtModule.onEnter(false) end
end

function ST:OnClick(...)
  local dtModule = WB:GetElvUIDataText("System")
  if dtModule then dtModule.onClick(...) end
end

function ST:OnEnter()
  WB:SetFontAccentColor(self.framerateText)
  WB:SetFontAccentColor(self.latencyText)

  if self.db.showIcons then WB:SetFontAccentColor(self.framerateIcon) end
  if self.db.showIcons then WB:SetFontAccentColor(self.latencyIcon) end

  self.mouseOver = true
  self:UpdateTooltip()
end

function ST:OnLeave()
  self.mouseOver = false
  self:UpdateColor()
end

function ST:OnWunderBarUpdate()
  self:UpdateFonts()
  self:UpdateText()
  self:UpdateColor()
  self:UpdateElements()
end

function ST:GetGradientColor(perc, icon)
  local r, g, b, a
  local normal = icon and WB:GetFontIconColor() or WB:GetFontNormalColor()

  if self.db.textColorFadeFromNormal then
    r, g, b = F.SlowColorGradient(perc, 1, 0.1, 0.1, 1, 1, 0.1, normal.r, normal.g, normal.b)
  else
    r, g, b = F.SlowColorGradient(perc, 1, 0.1, 0.1, 1, 1, 0.1, 0.1, 1, 0.1)
  end

  a = normal.a

  return {
    r = r,
    g = g,
    b = b,
    a = a,
  }
end

function ST:UpdateColor()
  if self.db.textColor or self.db.iconColor then
    -- fps
    do
      local lowerBound = (self.db.textColorFramerateThreshold * 0.5)
      local percentage = (self.framerate < self.db.textColorFramerateThreshold) and ((self.framerate - lowerBound) / lowerBound) or 100

      if self.db.textColor then WB:SetFontColor(self.framerateText, self:GetGradientColor(percentage, false)) end

      if self.db.iconColor then WB:SetFontColor(self.framerateIcon, self:GetGradientColor(percentage, true)) end
    end

    -- latency
    do
      local percentage = (self.latency > self.db.textColorLatencyThreshold) and (1 - (self.latency - self.db.textColorLatencyThreshold) / self.db.textColorLatencyThreshold) or 100

      if self.db.textColor then WB:SetFontColor(self.latencyText, self:GetGradientColor(percentage, false)) end

      if self.db.iconColor then WB:SetFontColor(self.latencyIcon, self:GetGradientColor(percentage, true)) end
    end
  end

  if not self.db.textColor then
    WB:SetFontNormalColor(self.framerateText)
    WB:SetFontNormalColor(self.latencyText)
  end

  if not self.db.iconColor then
    WB:SetFontIconColor(self.framerateIcon)
    WB:SetFontIconColor(self.latencyIcon)
  end
end

function ST:UpdateFonts()
  WB:SetFontFromDB(nil, nil, self.framerateText)
  WB:SetFontFromDB(nil, nil, self.latencyText)

  WB:SetIconFromDB(self.db, "icon", self.framerateIcon)
  WB:SetIconFromDB(self.db, "icon", self.latencyIcon)
end

function ST:UpdateText()
  self.framerateText:SetText(self.framerate)
  self.framerateIcon:SetText(self.db.iconFramerate)

  self.latencyText:SetText(self.latency)
  self.latencyIcon:SetText(self.db.iconLatency)
end

function ST:UpdateElements()
  local anchorPoint = WB:GetGrowDirection(self.Module, true)
  local iconSize = self.db.showIcons and self.db.iconFontSize or 1

  self.latencyText:ClearAllPoints()
  self.latencyIcon:ClearAllPoints()
  self.framerateText:ClearAllPoints()
  self.framerateIcon:ClearAllPoints()

  self.latencyIcon:SetJustifyH("RIGHT")
  self.framerateIcon:SetJustifyH("RIGHT")

  if anchorPoint == "RIGHT" then
    self.latencyText:SetJustifyH("RIGHT")
    self.framerateText:SetJustifyH("RIGHT")

    self.latencyText:SetPoint("RIGHT", self.frame, "RIGHT", 0, 0)
    self.framerateText:SetPoint("RIGHT", self.frame, "RIGHT", -(self.latencyText:GetStringWidth() + iconSize + 20), 0)
  else
    self.latencyText:SetJustifyH("LEFT")
    self.framerateText:SetJustifyH("LEFT")

    self.framerateText:SetPoint("LEFT", self.frame, "LEFT", (iconSize + 5), 0)
    self.latencyText:SetPoint("LEFT", self.frame, "LEFT", (self.framerateText:GetStringWidth() + (iconSize * 2) + 20), 0)
  end

  self.latencyIcon:SetPoint("RIGHT", self.latencyText, "LEFT", -5, 0)
  self.framerateIcon:SetPoint("RIGHT", self.framerateText, "LEFT", -5, 0)

  if self.db.showIcons then
    self.framerateIcon:Show()
    self.latencyIcon:Show()
  else
    self.framerateIcon:Hide()
    self.latencyIcon:Hide()
  end
end

function ST:CreateText()
  local framerateText = self.frame:CreateFontString(nil, "OVERLAY")
  local latencyText = self.frame:CreateFontString(nil, "OVERLAY")

  local framerateIcon = self.frame:CreateFontString(nil, "OVERLAY")
  local latencyIcon = self.frame:CreateFontString(nil, "OVERLAY")

  framerateText:SetPoint("CENTER")
  latencyText:SetPoint("CENTER")

  framerateIcon:SetPoint("CENTER")
  latencyIcon:SetPoint("CENTER")

  self.framerateText = framerateText
  self.latencyText = latencyText

  self.framerateIcon = framerateIcon
  self.latencyIcon = latencyIcon
end

function ST:OnInit()
  -- Get our settings DB
  self.db = WB:GetSubModuleDB(self:GetName())

  -- Don't init second time
  if self.Initialized then return end

  -- Vars
  self.frame = self.SubModuleHolder
  self.mouseOver = false
  self.updateWait = 0
  self.framerate = 0
  self.latency = 0

  -- Create virtual frame and connect it to datatext
  self.systemVirtualFrame = {
    name = "System",
    text = {
      SetFormattedText = E.noop,
    },
  }
  WB:ConnectVirtualFrameToDataText("System", self.systemVirtualFrame)

  self:CreateText()
  self:OnWunderBarUpdate()

  -- Update data text for accurate tooltips
  local dtModule = WB:GetElvUIDataText("System")
  if dtModule then dtModule.eventFunc(self.systemVirtualFrame) end

  -- We are done, hooray!
  self.Initialized = true
end

WB:RegisterSubModule(ST)
