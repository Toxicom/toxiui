local TXUI, F, E, I = unpack((select(2, ...)))
local VB = TXUI:GetModule("VehicleBar")
local LSM = E.Libs.LSM

local tinsert = table.insert

function VB:CreateVigorBar()
  local vigorBar = CreateFrame("Frame", "CustomVigorBar", UIParent)
  local width = self.bar:GetWidth()
  local height = self.vdb.height or 10
  vigorBar:SetSize(width - self.spacing, height)
  vigorBar:SetPoint("BOTTOM", self.bar, "TOP", 0, self.spacing * 3)

  vigorBar:Hide()

  -- Register for spell charge updates
  vigorBar:UnregisterAllEvents()
  vigorBar:RegisterEvent("SPELL_UPDATE_CHARGES")
  vigorBar:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
  vigorBar:SetScript("OnEvent", function(_, event)
    if (event == "SPELL_UPDATE_CHARGES" or event == "UNIT_SPELLCAST_SUCCEEDED") and self:IsVigorAvailable() and self.vigorBar then
      self:UpdateVigorBar()
    end
  end)

  -- OnUpdate for smooth recharge animation
  vigorBar:SetScript("OnUpdate", function()
    if self:IsVigorAvailable() and self.vigorBar and self.vigorBar:IsShown() then
      self:UpdateVigorSegments()
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
    local segment = CreateFrame("StatusBar", nil, self.vigorBar)
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

    if E.db.TXUI.addons.elvUITheme.enabled and E.db.TXUI.addons.elvUITheme.shadowEnabled then
      F.CreateSoftShadow(segment, E.db.TXUI.addons.elvUITheme.shadowSize * 2)
    end

    tinsert(segments, segment)
  end

  self.vigorBar.segments = segments
end
