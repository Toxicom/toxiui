local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local WB = TXUI:GetModule("WunderBar")

local CreateFrame = CreateFrame
local GameTooltip = GameTooltip
local GetSpellInfo = (C_Spell and C_Spell.GetSpellInfo) or GetSpellInfo
local GetSpellTexture = (C_Spell and C_Spell.GetSpellTexture) or GetSpellTexture
local InCombatLockdown = InCombatLockdown

local secureFlyOutFrame
local secureFlyOutButtons = {}

function WB:ShowSecureFlyOut(parent, direction, primarySlots, secondarySlots)
  if secureFlyOutFrame and secureFlyOutFrame:IsShown() then
    secureFlyOutFrame:Hide()
    return
  end

  if InCombatLockdown() then return end

  local function getSpellID(button)
    local spellID
    if C_Spell then
      spellID = GetSpellInfo(button.spellID).spellID
    else
      spellID = select(7, GetSpellInfo(button.spellID))
    end

    return spellID
  end

  local showTooltip = function(button)
    if button.spellID then
      GameTooltip:SetOwner(button, "ANCHOR_LEFT", 4, 4)
      -- Necessary for professions
      local spellID = getSpellID(button)
      GameTooltip:SetSpellByID(spellID or button.spellID)
    end
  end

  local flyoutDb = F.GetDBFromPath("TXUI.wunderbar.general.flyoutBackdrop")
  local spacing, padding = flyoutDb.spacing, flyoutDb.padding
  local slotWidth = flyoutDb.width + E.Border
  local slotHeight = (slotWidth - E.Border) / 4 * 3 + E.Border
  local labelFont = F.GetFontPath(flyoutDb.labelFont)

  -- Limit the number of slots per column
  local maxSlotsPerColumn = 8
  local numPrimaryColumns = math.ceil(#primarySlots / maxSlotsPerColumn)
  local numSecondaryColumns = secondarySlots and math.ceil(#secondarySlots / maxSlotsPerColumn) or 0

  local totalColumns = numPrimaryColumns + numSecondaryColumns
  local totalSlots = #primarySlots + (secondarySlots and #secondarySlots or 0)

  -- If there's less than 8 items in a column, we want to adjust our totalHeight calculation
  local heightCalcVar = (maxSlotsPerColumn < #primarySlots and maxSlotsPerColumn or #primarySlots)
  -- Calculate the total width and height of the flyout
  local totalWidth = totalColumns * slotWidth + (totalColumns - 1) * spacing + 2 * padding
  local totalHeight = heightCalcVar * slotHeight + (heightCalcVar - 1) * spacing + 2 * padding

  if not secureFlyOutFrame then secureFlyOutFrame = CreateFrame("Frame", nil, self.bar, "BackdropTemplate") end

  if flyoutDb.enabled then
    local alpha = flyoutDb.alpha
    local r, g, b = 0, 0, 0

    if flyoutDb.classColor then
      local color = E:ClassColor(E.myclass, true)
      if not F.Table.IsEmpty(color) then
        r, g, b = color.r, color.g, color.b
      end
    end

    secureFlyOutFrame:SetBackdrop {
      bgFile = E.media.blankTex,
      edgeFile = E.media.blankTex,
      edgeSize = flyoutDb.borderSize,
    }
    secureFlyOutFrame:SetBackdropColor(r, g, b, alpha) -- Set the backdrop color
    secureFlyOutFrame:SetBackdropBorderColor(0, 0, 0, 1) -- Set the border color
    secureFlyOutFrame:EnableMouse(true) -- Enable mouse interaction
  else
    secureFlyOutFrame:SetBackdrop {}
  end

  secureFlyOutFrame:SetSize(totalWidth, totalHeight)

  local numSlots = 0

  local prevSlots = {} -- Table to keep track of the previous slot in each column

  for i = 1, totalSlots do
    local info, slot, columnOffset

    local isPrimary = i <= #primarySlots
    local currentColumn
    local indexInColumn
    local slotWithSpacing

    if isPrimary then
      info = primarySlots[i]
      slot = secureFlyOutButtons[i]
      currentColumn = math.ceil(i / maxSlotsPerColumn)
      indexInColumn = (i - 1) % maxSlotsPerColumn + 1
      slotWithSpacing = slotWidth + spacing
      -- Primary slots start from the rightmost column and grow left
      columnOffset = (currentColumn - 1) * slotWithSpacing + padding
    else
      local secondaryIndex = i - #primarySlots
      info = secondarySlots[secondaryIndex]
      slot = secureFlyOutButtons[i]
      currentColumn = math.ceil(secondaryIndex / maxSlotsPerColumn)
      indexInColumn = (secondaryIndex - 1) % maxSlotsPerColumn + 1
      slotWithSpacing = slotWidth + spacing
      local slotOffset = (currentColumn - 1) * slotWithSpacing
      -- Secondary slots start to the left of the primary slots and grow left
      columnOffset = numPrimaryColumns * slotWithSpacing + slotOffset + padding
    end

    if not slot then
      slot = CreateFrame("Button", nil, secureFlyOutFrame, "SecureActionButtonTemplate")
      slot:EnableMouse(true)
      slot:RegisterForClicks("AnyDown")
      slot:SetTemplate()
      slot:StyleButton(nil, true)
      slot:SetScript("OnEnter", showTooltip)
      slot:SetScript("OnLeave", F.Event.GenerateClosure(GameTooltip.Hide, GameTooltip))

      slot.label = slot:CreateFontString(nil, "OVERLAY")
      slot.label:SetPoint("CENTER", slot, "CENTER")

      slot.FadeIn = TXUI:CreateAnimationGroup(slot)

      slot.FadeIn.ResetFade = slot.FadeIn:CreateAnimation("Fade")
      slot.FadeIn.ResetFade:SetDuration(0)
      slot.FadeIn.ResetFade:SetChange(0)
      slot.FadeIn.ResetFade:SetOrder(1)

      slot.FadeIn.Hold = slot.FadeIn:CreateAnimation("Sleep")
      slot.FadeIn.Hold:SetDuration(i * (0.3 / totalSlots))
      slot.FadeIn.Hold:SetOrder(2)

      slot.FadeIn.Fade = slot.FadeIn:CreateAnimation("Fade")
      slot.FadeIn.Fade:SetDuration(0.3)
      slot.FadeIn.Fade:SetEasing("out-quintic")
      slot.FadeIn.Fade:SetChange(1)
      slot.FadeIn.Fade:SetOrder(3)

      self:SecureHookScript(slot, "OnClick", function()
        secureFlyOutFrame:Hide()
      end)

      F.CreateSoftShadow(slot, 4)
      secureFlyOutButtons[i] = slot
    end

    slot:SetSize(slotWidth, slotHeight)
    slot.label:SetFont(labelFont, flyoutDb.labelFontSize, "OUTLINE")
    slot:ClearAllPoints()

    if indexInColumn == 1 then
      -- First slot in the column
      -- I don't fucking know how I got here to this calc but I think it makes sense, basically position the column
      -- based on all the columns, then add 4:3 ratio padding and add border because icons have borders /shrug
      slot:SetPoint("BOTTOMRIGHT", secureFlyOutFrame, "BOTTOMRIGHT", -columnOffset, padding)
      prevSlots[currentColumn] = slot
    else
      -- Subsequent slots, positioned above the previous slot in the same column
      -- Ensure the slot is positioned correctly with respect to spacing and the slot above it
      slot:SetPoint("BOTTOM", prevSlots[currentColumn], "TOP", 0, spacing)
      prevSlots[currentColumn] = slot
    end

    slot:SetAttribute("type", info.type)

    if info.type == "function" then
      slot:SetAttribute("_function", info.func)
      slot.spellID = info.spellID
    else
      slot:SetAttribute(info.type, info.spellID)
      slot.spellID = info.spellID
    end

    local texture = info.icon or GetSpellTexture(info.spellID)

    slot:SetNormalTexture(texture)
    slot:SetPushedTexture(texture)
    slot:SetDisabledTexture(texture)

    local left, right, top, bottom = E:CropRatio(slot)
    local normalTexture, pushedTexture, disabledTexture = slot:GetNormalTexture(), slot:GetPushedTexture(), slot:GetDisabledTexture()
    normalTexture:SetTexCoord(left, right, top, bottom)
    normalTexture:SetInside()
    pushedTexture:SetTexCoord(left, right, top, bottom)
    pushedTexture:SetInside()
    disabledTexture:SetTexCoord(left, right, top, bottom)
    disabledTexture:SetInside()
    disabledTexture:SetDesaturated(true)

    if info.label and E.db.TXUI.wunderbar.subModules.Hearthstone.showLabels then
      slot.label:SetText(info.label)
    else
      slot.label:SetText("")
    end

    slot:SetAlpha(0)
    slot:Show()

    numSlots = numSlots + 1
  end

  -- Hide unused buttons
  local unusedButtonIndex = numSlots + 1
  while secureFlyOutButtons[unusedButtonIndex] do
    secureFlyOutButtons[unusedButtonIndex]:Hide()
    unusedButtonIndex = unusedButtonIndex + 1
  end

  if totalSlots == 0 then
    secureFlyOutFrame:Hide()
    return
  end

  secureFlyOutFrame:SetFrameStrata("DIALOG")
  secureFlyOutFrame:ClearAllPoints()

  if direction == "UP" then
    secureFlyOutFrame:SetPoint("BOTTOMRIGHT", parent, "TOPRIGHT")
  elseif direction == "DOWN" then
    secureFlyOutFrame:SetPoint("TOP", parent, "BOTTOM")
  elseif direction == "LEFT" then
    secureFlyOutFrame:SetPoint("RIGHT", parent, "LEFT")
  elseif direction == "RIGHT" then
    secureFlyOutFrame:SetPoint("LEFT", parent, "RIGHT")
  end

  for i = 1, numSlots do
    local slot = secureFlyOutButtons[i]

    if slot.FadeIn:IsPlaying() then slot.FadeIn:Stop() end
    slot.FadeIn:Play()
  end

  secureFlyOutFrame:Show()
end
