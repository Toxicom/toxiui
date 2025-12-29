local TXUI, F, E, I = unpack((select(2, ...)))
local VB = TXUI:GetModule("VehicleBar")
local LSM = E.Libs.LSM

local tinsert = table.insert

function VB:CreateVigorBar()
  local vigorBar = CreateFrame("Frame", "ToxiUI_VigorBar", UIParent)
  local width = self.bar:GetWidth()
  local height = self.vdb.height or 10
  vigorBar:SetSize(width - self.spacing, height)
  vigorBar:SetPoint("BOTTOM", self.bar, "TOP", 0, self.spacing * 3)

  -- Create a separate frame for speed text with higher frame level
  local speedTextFrame = CreateFrame("Frame", "ToxiUI_VigorBar_SpeedTextFrame", vigorBar)
  speedTextFrame:SetAllPoints(vigorBar)
  speedTextFrame:SetFrameLevel(vigorBar:GetFrameLevel() + 10)

  -- Create speed text on the higher-level frame
  vigorBar.speedText = speedTextFrame:CreateFontString(nil, "OVERLAY")
  vigorBar.speedText:SetFont(F.GetFontPath(self.vdb.speedTextFont), F.FontSizeScaled(self.vdb.speedTextFontSize), "OUTLINE")
  vigorBar.speedText:SetPoint("BOTTOM", vigorBar, "TOP", 0, self.vdb.speedTextOffsetY)
  vigorBar.speedText:SetText("0%")

  if self.vdb.showSpeedText then
    vigorBar.speedText:Show()
  else
    vigorBar.speedText:Hide()
  end

  vigorBar:Hide()

  -- Register for spell charge updates
  vigorBar:UnregisterAllEvents()
  vigorBar:RegisterEvent("SPELL_UPDATE_CHARGES")
  vigorBar:SetScript("OnEvent", function(_, event)
    if event == "SPELL_UPDATE_CHARGES" and self:IsVigorAvailable() and self.vigorBar then
      -- Only update segment values, don't recreate
      self:UpdateVigorSegments()
    end
  end)

  -- OnUpdate for smooth recharge animation
  vigorBar:SetScript("OnUpdate", function()
    if self:IsVigorAvailable() and self.vigorBar and self.vigorBar:IsShown() then
      -- Update vigor segments every frame for smooth animation
      self:UpdateVigorSegments()
    end
  end)

  -- Use C_Timer for speed text updates (more efficient than OnUpdate throttling)
  vigorBar.speedTextTicker = C_Timer.NewTicker(self.vdb.speedTextUpdateRate, function()
    if self:IsVigorAvailable() and self.vigorBar and self.vigorBar:IsShown() then
      self:UpdateSpeedText()
    end
  end)

  self.vigorBar = vigorBar
  self.vigorBar.segments = {}

  self:CreateVigorSegments()
  if not F.Table.IsEmpty(self.vigorBar.segments) then self:UpdateVigorSegments() end
end

function VB:CreateVigorSegments()
  local segments = {}
  local chargeInfo = self:GetSpellChargeInfo()
  if not chargeInfo then return end

  local maxCharges = chargeInfo.maxCharges
  local height = self.vdb.height or 10

  local segmentWidth = (self.vigorBar:GetWidth() / maxCharges) - (self.spacing * 2)

  local classColor = E:ClassColor(E.myclass, true)
  local r, g, b = classColor.r, classColor.g, classColor.b

  local leftColor, rightColor

  -- Check if custom colors are enabled
  if self.vdb.useCustomColor then
    local customLeft = self.vdb.customColorLeft
    local customRight = self.vdb.customColorRight
    leftColor = CreateColor(customLeft.r, customLeft.g, customLeft.b, 1)
    rightColor = CreateColor(customRight.r, customRight.g, customRight.b, 1)
  elseif E.db.TXUI.themes.gradientMode.enabled then
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

  for i = 1, maxCharges do
    local segment = CreateFrame("StatusBar", "ToxiUI_VigorBar_Segment" .. i, self.vigorBar)
    segment:SetSize(segmentWidth, height)

    if E.db.TXUI.themes.darkMode.enabled then
      segment:SetStatusBarTexture(darkTexture)
    else
      segment:SetStatusBarTexture(normalTexture)
    end

    segment:GetStatusBarTexture():SetHorizTile(false)

    -- Store colors for later use
    segment.classColor = { r = r, g = g, b = b }
    segment.leftColor = leftColor
    segment.rightColor = rightColor

    -- Set initial color (will be updated in UpdateVigorSegments)
    if leftColor and rightColor then
      segment:GetStatusBarTexture():SetGradient("HORIZONTAL", leftColor, rightColor)
    else
      segment:SetStatusBarColor(r, g, b)
    end

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
