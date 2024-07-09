local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local WB = TXUI:GetModule("WunderBar")

local CreateFrame = CreateFrame
local GameTooltip = GameTooltip
local GetSpellTexture = GetSpellTexture
local InCombatLockdown = InCombatLockdown
local unpack = unpack

local secureFlyOutFrame
local secureFlyOutButtons = {}

function WB:ShowSecureFlyOut(parent, direction, primarySlots, secondarySlots)
  if secureFlyOutFrame and secureFlyOutFrame:IsShown() then
    secureFlyOutFrame:Hide()
    return
  end

  if InCombatLockdown() then return end

  local showTooltip = function(button)
    if button.spellID then
      GameTooltip:SetOwner(button, "ANCHOR_LEFT", 4, 4)
      -- Necessary for professions
      local _, _, _, _, _, _, spellID = GetSpellInfo(button.spellID)
      GameTooltip:SetSpellByID(spellID or button.spellID)
    end
  end

  local spacing, padding = 4, 16
  local slotWidth = 40 + E.Border
  local slotHeight = 30 + E.Border

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

  if E.db.TXUI.wunderbar.general.flyoutBackdrop then
    local alpha = E.db.TXUI.wunderbar.general.flyoutBackdropAlpha
    local r, g, b = 0, 0, 0

    if E.db.TXUI.wunderbar.general.flyoutBackdropClassColor then
      local color = E:ClassColor(E.myclass, true)
      if not F.Table.IsEmpty(color) then
        r, g, b = color.r, color.g, color.b
      end
    end

    secureFlyOutFrame:SetBackdrop {
      bgFile = E.media.blankTex,
      edgeFile = E.media.blankTex,
      edgeSize = E.db.TXUI.wunderbar.general.flyoutBackdropBorderSize,
    }
    secureFlyOutFrame:SetBackdropColor(r, g, b, alpha) -- Set the backdrop color
    secureFlyOutFrame:SetBackdropBorderColor(0, 0, 0, 1) -- Set the border color
    secureFlyOutFrame:EnableMouse(true) -- Enable mouse interaction
  else
    secureFlyOutFrame:SetBackdrop()
  end

  secureFlyOutFrame:SetSize(totalWidth, totalHeight)

  local numSlots = 0

  local prevSlots = {} -- Table to keep track of the previous slot in each column

  for i = 1, totalSlots do
    local info, slot, columnOffset

    local isPrimary = i <= #primarySlots
    local currentColumn
    local indexInColumn

    if isPrimary then
      info = primarySlots[i]
      slot = secureFlyOutButtons[i]
      currentColumn = math.ceil(i / maxSlotsPerColumn)
      indexInColumn = (i - 1) % maxSlotsPerColumn + 1
      -- Primary slots start from the rightmost column and grow left
      columnOffset = totalWidth - currentColumn * (slotWidth + spacing) + padding
    else
      local secondaryIndex = i - #primarySlots
      info = secondarySlots[secondaryIndex]
      slot = secureFlyOutButtons[i]
      currentColumn = math.ceil(secondaryIndex / maxSlotsPerColumn)
      indexInColumn = (secondaryIndex - 1) % maxSlotsPerColumn + 1
      -- Secondary slots start to the left of the primary slots and grow left
      columnOffset = totalWidth - (numPrimaryColumns * (slotWidth + spacing) + currentColumn * (slotWidth + spacing)) + padding
    end

    if not slot then
      slot = CreateFrame("Button", nil, secureFlyOutFrame, "SecureActionButtonTemplate")
      slot:EnableMouse(true)
      slot:RegisterForClicks("AnyDown")
      slot:SetSize(slotWidth, slotHeight)
      slot:SetTemplate()
      slot:StyleButton(nil, true)
      slot:SetScript("OnEnter", showTooltip)
      slot:SetScript("OnLeave", F.Event.GenerateClosure(GameTooltip.Hide, GameTooltip))

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

    slot:ClearAllPoints()

    if indexInColumn == 1 then
      -- First slot in the column
      -- I don't fucking know how I got here to this calc but I think it makes sense, basically position the column
      -- based on all the columns, then add 4:3 ratio padding and add border because icons have borders /shrug
      slot:SetPoint("BOTTOMRIGHT", secureFlyOutFrame, "BOTTOMLEFT", columnOffset + (padding / 4 * 3) + E.Border, padding)
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
