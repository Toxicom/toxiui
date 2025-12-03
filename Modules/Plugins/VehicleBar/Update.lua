local TXUI, F, E, I = unpack((select(2, ...)))
local VB = TXUI:GetModule("VehicleBar")
local LAB = LibStub("LibActionButton-1.0-ElvUI")

local GetOverrideBarIndex = GetOverrideBarIndex
local GetVehicleBarIndex = GetVehicleBarIndex
local format = string.format
local pairs = pairs
local ipairs = ipairs
local strsplit = strsplit

function VB:UpdateKeybinds()
  for i, button in ipairs(self.bar.buttons) do
    -- Keybinds handling
    local buttonIndex = (i == 8) and 12 or i
    local actionButton = _G["ActionButton" .. buttonIndex]
    if actionButton then
      local keybind = GetBindingKey("ACTIONBUTTON" .. buttonIndex)
      if keybind and self.db.showKeybinds then
        button.HotKey:SetTextColor(1, 1, 1)
        button.HotKey:SetText(self:FormatKeybind(keybind))
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
  local bar = self.bar or CreateFrame("Frame", "TXUIVehicleBar", E.UIParent, "SecureHandlerStateTemplate")

  -- Default position
  local point, anchor, attachTo, x, y = strsplit(",", F.Position(strsplit(",", self.db.position)))
  bar:SetPoint(point, anchor, attachTo, x, y)

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
      local button = LAB:CreateButton(buttonIndex, "TXUIVehicleBarButton" .. buttonIndex, bar, nil)

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
  bar:SetHeight((size / 4 * 3))

  -- Update button position and size
  for i, button in ipairs(bar.buttons) do
    button:SetSize(size, size / 4 * 3)
    button:ClearAllPoints()

    if i == 1 then
      button:SetPoint("BOTTOMLEFT", self.spacing, self.spacing)
    else
      button:SetPoint("LEFT", bar.buttons[i - 1], "RIGHT", self.spacing, 0)
    end
  end

  -- Update Paging
  if not TXUI.IsVanilla then
    local pageState =
      format("[overridebar] %d; [vehicleui] %d; [possessbar] %d; [shapeshift] 13; %s", GetOverrideBarIndex(), GetVehicleBarIndex(), GetVehicleBarIndex(), "[bonusbar:5] 11;")
    local pageAttribute = self.ab:GetPage("bar1", 1, pageState)
    RegisterStateDriver(bar, "page", pageAttribute)
    self.bar:SetAttribute("page", pageAttribute)
  end

  -- ElvUI Bar config
  self.ab:UpdateButtonConfig("bar1", "ACTIONBUTTON")
  self.ab:PositionAndSizeBar("bar1")

  -- Hook for animation
  self:SecureHookScript(bar, "OnShow", "OnShowEvent")

  -- Hide
  bar:Hide()

  -- Only run after first creation
  if init then
    -- Create Mover
    E:CreateMover(bar, "ToxiUIVehicleBar", TXUI.Title .. " Vehicle Bar", nil, nil, nil, "ALL,TXUI", nil, "TXUI,misc,vehicleBar")

    -- Force update
    for _, button in pairs(bar.buttons) do
      button:UpdateAction()
    end
  end

  self:UpdateKeybinds()
end
