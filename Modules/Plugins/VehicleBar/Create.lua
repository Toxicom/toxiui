local TXUI, F, E, I = unpack((select(2, ...)))
local VB = TXUI:GetModule("VehicleBar")
local LSM = E.Libs.LSM

local tinsert = table.insert

function VB:CreateVigorBar()
  local vigorBar = CreateFrame("Frame", "CustomVigorBar", UIParent)
  local width = self.bar:GetWidth()
  vigorBar:SetSize(width - self.spacing, self.vigorHeight)
  vigorBar:SetPoint("BOTTOM", self.bar, "TOP", 0, self.spacing * 3) -- Adjust position as needed

  -- Create the speed text
  vigorBar.speedText = vigorBar:CreateFontString(nil, "OVERLAY")
  vigorBar.speedText:SetFont(F.GetFontPath(I.Fonts.TitleBlack), F.FontSizeScaled(24), "OUTLINE")
  vigorBar.speedText:SetPoint("BOTTOM", vigorBar, "TOP", 0, 0)
  vigorBar.speedText:SetText("0%")

  -- Set parent-child relationship
  vigorBar.speedText:SetParent(vigorBar)

  vigorBar:Hide()

  -- Update speed text regularly
  vigorBar:SetScript("OnUpdate", function()
    self:UpdateSpeedText()
  end)

  vigorBar:UnregisterAllEvents()
  vigorBar:RegisterEvent("UPDATE_UI_WIDGET")
  vigorBar:SetScript("OnEvent", function(_, event)
    if event == "UPDATE_UI_WIDGET" and self:IsVigorAvailable() and self.vigorBar then self:UpdateVigorBar() end
  end)

  self.vigorBar = vigorBar
  self.vigorBar.segments = {}

  self:CreateVigorSegments()
  if not F.Table.IsEmpty(self.vigorBar.segments) then self:UpdateVigorSegments() end
end

function VB:CreateVigorSegments()
  local segments = {}
  local widgetInfo = self:GetWidgetInfo()
  if not widgetInfo then return end

  local maxVigor = widgetInfo.numTotalFrames -- Total Vigor Segments

  local segmentWidth = (self.vigorBar:GetWidth() / maxVigor) - (self.spacing * 2)

  local classColor = E:ClassColor(E.myclass, true)
  local r, g, b = classColor.r, classColor.g, classColor.b

  local leftColor, rightColor

  if E.db.TXUI.themes.gradientMode.enabled then
    local colorMap = E.db.TXUI.themes.gradientMode.classColorMap

    local left = colorMap[1][E.myclass]
    local right = colorMap[2][E.myclass]

    if left.r and right.r then
      leftColor = CreateColor(left.r, left.g, left.b, 1)
      rightColor = CreateColor(right.r, right.g, right.b, 1)
    end
  end

  local darkTexture = LSM:Fetch("statusbar", self.vdb.darkTexture)
  local normalTexture = LSM:Fetch("statusbar", self.vdb.normalTexture)

  for i = 1, maxVigor do
    local segment = CreateFrame("StatusBar", nil, self.vigorBar)
    segment:SetSize(segmentWidth, self.vigorHeight) -- Width, Height of each segment

    if E.db.TXUI.themes.darkMode.enabled then
      segment:SetStatusBarTexture(darkTexture)
    else
      segment:SetStatusBarTexture(normalTexture)
    end

    segment:GetStatusBarTexture():SetHorizTile(false)
    segment:SetStatusBarColor(r, g, b)

    if E.db.TXUI.themes.gradientMode.enabled and leftColor and rightColor then segment:GetStatusBarTexture():SetGradient("HORIZONTAL", leftColor, rightColor) end

    -- Background
    local bg = segment:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(0, 0, 0, 0.5)

    -- Border
    local border = CreateFrame("Frame", nil, segment, "BackdropTemplate")
    border:SetPoint("TOPLEFT", -1, 1)
    border:SetPoint("BOTTOMRIGHT", 1, -1)
    border:SetBackdrop {
      edgeFile = E.media.blankTex,
      edgeSize = E.twoPixelsPlease and 2 or 1,
    }
    border:SetBackdropBorderColor(0, 0, 0)

    if i == 1 then
      segment:SetPoint("LEFT", self.vigorBar, "LEFT", self.spacing, 0)
    else
      segment:SetPoint("LEFT", segments[i - 1], "RIGHT", self.spacing * 2, 0)
    end

    segment:SetMinMaxValues(0, 1)

    if E.db.TXUI.addons.elvUITheme.enabled and E.db.TXUI.addons.elvUITheme.shadowEnabled then F.CreateSoftShadow(segment, E.db.TXUI.addons.elvUITheme.shadowSize * 2) end

    tinsert(segments, segment)
  end

  self.vigorBar.segments = segments
end
