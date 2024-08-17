local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local WB = TXUI:GetModule("WunderBar")
local VL = WB:NewModule("Volume")

function VL:OnEvent(...)
  local dtModule = WB:GetElvUIDataText("Volume")

  if dtModule then
    dtModule.eventFunc(self.dataTextDummy, ...)

    self:UpdateTooltip(dtModule)
  end
end

function VL:OnClick(...)
  local dtModule = WB:GetElvUIDataText("Volume")
  if dtModule then dtModule.onClick(...) end
end

function VL:UpdateTooltip(dtModule)
  if not self.mouseOver then return end
  dtModule.onEnter()
end

function VL:OnEnter()
  self.mouseOver = true
  self:UpdateColor()

  local dtModule = WB:GetElvUIDataText("Volume")
  if dtModule then dtModule.onEnter() end
end

function VL:OnLeave()
  self.mouseOver = false
  self:UpdateColor()
end

function VL:OnWunderBarUpdate()
  self:UpdateFonts()
  self:UpdateText()
  self:UpdateColor()
  self:UpdateElements()
  self:OnEvent("ELVUI_FORCE_UPDATE")
end

function VL:UpdateColor()
  if self.mouseOver then
    WB:SetFontAccentColor(self.volumeText)
    if self.db.showIcon then WB:SetFontAccentColor(self.volumeIcon) end
  else
    WB:SetFontNormalColor(self.volumeText)
    if self.db.showIcon then WB:SetFontIconColor(self.volumeIcon) end
  end
end

function VL:UpdateFonts()
  WB:SetFontFromDB(nil, nil, self.volumeText)
  WB:SetIconFromDB(self.db, "icon", self.volumeIcon)
end

function VL:UpdateText()
  self.volumeIcon:SetText(self.db.icon)
end

function VL:UpdateElements()
  local anchorPoint = WB:GetGrowDirection(self.Module, true)
  local iconSize = self.db.showIcon and self.db.iconFontSize or 1

  self.volumeText:ClearAllPoints()
  self.volumeIcon:ClearAllPoints()
  self.volumeIcon:SetJustifyH("RIGHT")

  if anchorPoint == "RIGHT" then
    self.volumeText:SetJustifyH("RIGHT")
    self.volumeText:SetPoint("RIGHT", self.frame, "RIGHT", 0, 0)
  else
    self.volumeText:SetJustifyH("LEFT")
    self.volumeText:SetPoint("LEFT", self.frame, "LEFT", (iconSize + 5), 0)
  end

  self.volumeIcon:SetPoint("RIGHT", self.volumeText, "LEFT", -5, 0)

  if self.db.showIcon then
    self.volumeIcon:Show()
  else
    self.volumeIcon:Hide()
  end
end

function VL:CreateText()
  local volumeText = self.frame:CreateFontString(nil, "OVERLAY")
  local volumeIcon = self.frame:CreateFontString(nil, "OVERLAY")

  volumeText:SetPoint("CENTER")
  volumeIcon:SetPoint("CENTER")

  self.volumeText = volumeText
  self.volumeIcon = volumeIcon

  self.dataTextDummy.text.SetText = function(_, text)
    local displayText
    if self.db.textColor == "GREEN" then
      displayText = text
    elseif self.db.textColor == "ACCENT" then
      local fontColor = WB:GetFontAccentColor()
      displayText = text:gsub("00FF00", E:RGBToHex(fontColor.r, fontColor.g, fontColor.b, ""))
    else
      displayText = F.String.StripColor(text)
    end
    self.volumeText:SetText(self.db.useUppercase and F.String.Uppercase(displayText) or displayText)
  end
end

function VL:OnInit()
  -- Get our settings DB
  self.db = WB:GetSubModuleDB(self:GetName())

  -- Don't init second time
  if self.Initialized then return end

  -- Vars
  self.frame = self.SubModuleHolder
  self.mouseOver = false

  -- Enable mouse wheel support
  self.Module:EnableMouseWheel(true)

  -- Dummy
  self.dataTextDummy = WB:GetElvUIDummy()
  self.dataTextDummy.EnableMouseWheel = E.noop
  self.dataTextDummy.SetScript = function(_, event, func)
    self.Module:SetScript(event, func)
  end

  self:CreateText()
  self:OnWunderBarUpdate()

  -- We are done, hooray!
  self.Initialized = true
end

WB:RegisterSubModule(VL, { "CVAR_UPDATE" })
