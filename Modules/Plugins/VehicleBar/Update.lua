local TXUI, F, E, I = unpack((select(2, ...)))
local VB = TXUI:GetModule("VehicleBar")
local CM = TXUI:GetModule("ColorModifiers")
local LAB = LibStub("LibActionButton-1.0-ElvUI")

local GetOverrideBarIndex = GetOverrideBarIndex
local GetVehicleBarIndex = GetVehicleBarIndex
local format = string.format
local pairs = pairs
local ipairs = ipairs
local strsplit = strsplit

function VB:UpdateVigorSegments()
  local chargeInfo = self:GetSpellChargeInfo()

  if not chargeInfo then return end

  local currentCharges = chargeInfo.currentCharges
  local maxCharges = chargeInfo.maxCharges

  -- Calculate fractional charge progress
  local fractionalCharge = 0
  if currentCharges < maxCharges and chargeInfo.cooldownStartTime and chargeInfo.cooldownDuration then
    local elapsed = GetTime() - chargeInfo.cooldownStartTime
    fractionalCharge = elapsed / chargeInfo.cooldownDuration
  end

  local grayColor = 0.5 -- Gray color for recharging segments

  for i, segment in ipairs(self.vigorBar.segments) do
    if i <= currentCharges then
      -- Full charge - use gradient colors
      segment:SetValue(1)
      if segment.leftColor and segment.rightColor then
        segment:GetStatusBarTexture():SetGradient("HORIZONTAL", segment.leftColor, segment.rightColor)
      else
        segment:SetStatusBarColor(segment.classColor.r, segment.classColor.g, segment.classColor.b)
      end
      segment:Show()
    elseif i == currentCharges + 1 and fractionalCharge > 0 then
      -- Recharging - use gray color
      segment:SetValue(fractionalCharge)
      segment:SetStatusBarColor(grayColor, grayColor, grayColor)
      segment:Show()
    else
      -- Empty - hide
      segment:SetValue(0)
      segment:Show()
    end
  end
end

function VB:UpdateSpeedText()
  if not self.vigorBar or not self:IsVigorAvailable() then return end

  local isGliding, _, forwardSpeed = C_PlayerInfo.GetGlidingInfo()
  local base = isGliding and forwardSpeed or GetUnitSpeed("player")

  if not E:NotSecretValue(base) then
    self.vigorBar.speedText:SetText(F.String.Muted("N/A"))
    return
  end

  local movespeed = Round(base / BASE_MOVEMENT_SPEED * 100)

  self.vigorBar.speedText:SetText(self:ColorSpeedText(format("%d%%", movespeed)))
end

function VB:UpdateVigorColors()
  if not self.vigorBar or F.Table.IsEmpty(self.vigorBar.segments) then return end

  local leftColor, rightColor

  if self.vdb.useCustomColor then
    local customLeft = self.vdb.customColorLeft
    local customRight = self.vdb.customColorRight
    leftColor = CreateColor(customLeft.r, customLeft.g, customLeft.b, 1)
    rightColor = CreateColor(customRight.r, customRight.g, customRight.b, 1)
  elseif E.db.TXUI.themes.gradientMode.enabled then
    F.Color.GenerateCache()
    local fgMap = F.Color.GetMap("classColorMap")
    if fgMap then
      leftColor = fgMap[I.Enum.GradientMode.Color.SHIFT][E.myclass]
      rightColor = fgMap[I.Enum.GradientMode.Color.NORMAL][E.myclass]
    end
  end

  for _, segment in ipairs(self.vigorBar.segments) do
    segment.leftColor = leftColor
    segment.rightColor = rightColor
  end

  self:UpdateVigorSegments()
end

function VB:UpdateVigorBar()
  -- Always recreate segments when settings change to ensure colors/textures are updated
  if not F.Table.IsEmpty(self.vigorBar.segments) then
    for _, segment in ipairs(self.vigorBar.segments) do
      segment:Kill()
    end
    self.vigorBar.segments = {}
  end

  -- Update vigor bar size before creating segments
  local height = self.vdb.height or 10
  local width = self.bar:GetWidth() - self.spacing
  self.vigorBar:SetSize(width, height)

  -- Update speed text font and position
  self.vigorBar.speedText:SetFont(F.GetFontPath(self.vdb.speedTextFont), F.FontSizeScaled(self.vdb.speedTextFontSize), "OUTLINE")
  self.vigorBar.speedText:ClearAllPoints()
  self.vigorBar.speedText:SetPoint("BOTTOM", self.vigorBar, "TOP", 0, self.vdb.speedTextOffsetY)

  -- Show or hide speed text
  if self.vdb.showSpeedText then
    self.vigorBar.speedText:Show()
  else
    self.vigorBar.speedText:Hide()
  end

  -- Recreate speed text ticker if update rate changed
  if self.vigorBar.speedTextTicker then self.vigorBar.speedTextTicker:Cancel() end
  self.vigorBar.speedTextTicker = C_Timer.NewTicker(self.vdb.speedTextUpdateRate, function()
    if self:IsVigorAvailable() and self.vigorBar and self.vigorBar:IsShown() then self:UpdateSpeedText() end
  end)

  -- Create segments (they will be sized correctly based on vigorBar width)
  self:CreateVigorSegments()

  -- Update segment display
  self:UpdateVigorSegments()
end

function VB:UpdateButtonLock()
  if not self.bar or not self.bar.buttons then return end
  for _, button in ipairs(self.bar.buttons) do
    button:SetAttribute("buttonlock", self.ab.db.lockActionBars or nil)
  end
end

function VB:UpdateKeybinds()
  for i, button in ipairs(self.bar.buttons) do
    -- Keybinds handling
    local buttonIndex = (i == 8) and 12 or i
    local actionButton = _G["ActionButton" .. buttonIndex]
    if actionButton then
      local keybind = GetBindingKey("ACTIONBUTTON" .. buttonIndex)
      if keybind and self.db.showKeybinds then
        button.HotKey:SetTextColor(1, 1, 1)
        button.HotKey:SetText(CM:FormatKeybind(keybind))
        -- stop truncating keybinds (thx Repooc =])
        button.HotKey:Width(button:GetWidth())
        button.HotKey:Show()
      else
        button.HotKey:Hide()
      end
    end

    -- Macro Text handling
    if button.Name then
      if self.db.showMacro then
        button.Name:Show()
      else
        button.Name:Hide()
      end
    end
  end
end

function VB:UpdateBar()
  -- Vars
  local size = self.db.buttonWidth or 48

  -- Create or get bar
  local init = self.bar == nil
  local bar = self.bar or CreateFrame("Frame", "ToxiUI_VehicleBar", E.UIParent, "SecureHandlerStateTemplate")
  -- Default position (only on initial creation)
  if init then
    local point, anchor, attachTo, x, y = strsplit(",", F.Position(strsplit(",", self.db.position)))
    bar:SetPoint(point, anchor, attachTo, x, y)
  end

  -- Set bar vars
  self.bar = bar
  self.bar.id = 1

  -- Page Handling
  bar:SetAttribute(
    "_onstate-page",
    [[
        newstate = ((HasTempShapeshiftActionBar() and self:GetAttribute("hasTempBar")) and GetTempShapeshiftBarIndex())
        or (UnitHasVehicleUI("player") and GetVehicleBarIndex())
        or (HasOverrideActionBar() and GetOverrideBarIndex())
        or newstate

        if not newstate then
            return
        end

        if newstate ~= 0 then
            self:SetAttribute("state", newstate)
            control:ChildUpdate("state", newstate)
        else
            local newCondition = self:GetAttribute("newCondition")
            if newCondition then
                newstate = SecureCmdOptionParse(newCondition)
                self:SetAttribute("state", newstate)
                control:ChildUpdate("state", newstate)
            end
        end
    ]]
  )

  -- Create Buttons
  if not bar.buttons then
    bar.buttons = {}

    for i = 1, 8 do
      local buttonIndex = (i == 8) and 12 or i

      -- Create button
      local button = LAB:CreateButton(buttonIndex, "ToxiUI_VehicleBarButton" .. buttonIndex, bar, nil)

      -- Set state aka actions
      button:SetState(0, "action", buttonIndex)
      for k = 1, 18 do
        button:SetState(k, "action", (k - 1) * 12 + buttonIndex)
      end
      if buttonIndex == 12 then button:SetState(12, "custom", self.ab.customExitButton) end

      -- Style
      self.ab:StyleButton(button, nil, nil)
      button:SetTemplate("Transparent")
      button:SetCheckedTexture("")
      button.MasqueSkinned = true -- Ugly fix for smaller cooldowns, not actually using Masque

      -- Always show grid for empty buttons
      button.config.showGrid = true

      -- Adjust the count position
      button.Count:ClearAllPoints()
      button.Count:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", self.spacing, self.spacing)

      -- Add to array
      bar.buttons[i] = button
    end
  end

  -- Calculate Bar Width/Height
  local width = (size * 8) + (self.spacing * (8 - 1)) + 4
  bar:SetWidth(width)
  bar:SetHeight((size / 3 * 2))

  -- Update button position and size
  local buttonWidth, buttonHeight = size, size / 3 * 2
  local left, right, top, bottom = E:CropRatio(buttonWidth, buttonHeight)

  for i, button in ipairs(bar.buttons) do
    button:SetSize(buttonWidth, buttonHeight)
    button:ClearAllPoints()

    if i == 1 then
      button:SetPoint("BOTTOMLEFT", self.spacing, self.spacing)
    else
      button:SetPoint("LEFT", bar.buttons[i - 1], "RIGHT", self.spacing, 0)
    end

    -- Crop the icon so it's not squished
    button.icon:SetTexCoord(left, right, top, bottom)
  end

  -- Update Paging
  if not TXUI.IsClassicEra and not TXUI.IsAnniversary then
    local pageState =
      format("[overridebar] %d; [vehicleui] %d; [possessbar] %d; [shapeshift] 13; %s", GetOverrideBarIndex(), GetVehicleBarIndex(), GetVehicleBarIndex(), "[bonusbar:5] 11;")
    local pageAttribute = self.ab:GetPage("bar1", 1, pageState)
    RegisterStateDriver(bar, "page", pageAttribute)
    self.bar:SetAttribute("page", pageAttribute)
  end

  -- ElvUI Bar config
  self.ab:UpdateButtonConfig("bar1", "ACTIONBUTTON")
  self.ab:PositionAndSizeBar("bar1")

  -- Hide
  bar:Hide()

  -- Only run after first creation
  if init then
    -- Hook for animation (only hook once during initialization)
    self:SecureHookScript(bar, "OnShow", "OnShowEvent")
    if TXUI.IsRetail then self:SecureHookScript(bar, "OnHide", "OnHideEvent") end

    -- Create Mover
    E:CreateMover(bar, "ToxiUIVehicleBar", TXUI.Title .. " Vehicle Bar", nil, nil, nil, "ALL,TXUI", nil, "TXUI,misc,vehicleBar")

    -- Force update
    for _, button in pairs(bar.buttons) do
      button:UpdateAction()
    end

    if TXUI.IsRetail and not self.vigorBar and self.vdb.enabled then self:CreateVigorBar() end
  end

  -- Update vigor bar if it exists (for settings changes)
  if TXUI.IsRetail and self.vigorBar and self.vdb.enabled then
    self:UpdateVigorBar()
    -- Show vigor bar if the vehicle bar is currently shown and we're skyriding
    if self.bar:IsShown() and self:IsVigorAvailable() then self.vigorBar:Show() end
  end

  self:UpdateKeybinds()
  self:UpdateButtonLock()
end
