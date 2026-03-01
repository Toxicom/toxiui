local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local WB = TXUI:GetModule("WunderBar")

local CreateFrame = CreateFrame
local GameTooltip = GameTooltip
local GetCVarBool = GetCVarBool
local GetItemCooldown = C_Container and C_Container.GetItemCooldown
local GetSpellTexture = (C_Spell and C_Spell.GetSpellTexture) or GetSpellTexture
local InCombatLockdown = InCombatLockdown

local secureFlyOutFrame
local secureFlyOutButtons = {}

function WB:ShowSecureFlyOut(parent, direction, primarySlots, secondarySlots)
  if secureFlyOutFrame and secureFlyOutFrame:IsShown() then
    secureFlyOutFrame:Hide()
    self.flyoutIsOpen = false
    return
  end

  local dirUp = direction == "UP"
  local dirDown = direction == "DOWN"
  local dirLeft = direction == "LEFT"
  local dirRight = direction == "RIGHT"

  if InCombatLockdown() then return end

  local showTooltip = function(button)
    GameTooltip:SetOwner(button, "ANCHOR_LEFT", 4, 4)
    if button.isItem then
      -- Use the item's on-use spell tooltip for a clean display without inventory data
      -- C_Item.GetItemSpell returns (spellName, spellID) as two separate values
      local itemSpellID
      if C_Item and C_Item.GetItemSpell then
        local _, sid = C_Item.GetItemSpell(button.spellID)
        itemSpellID = sid
      end
      if itemSpellID then
        GameTooltip:SetSpellByID(itemSpellID)
      else
        GameTooltip:SetHyperlink("item:" .. button.spellID)
      end
    elseif button.spellID then
      -- Necessary for professions
      local _, _, _, _, _, _, spellID = E:GetSpellInfo(button.spellID)
      GameTooltip:SetSpellByID(spellID or button.spellID)
    end
  end

  local flyoutDb = F.GetDBFromPath("TXUI.wunderbar.general.flyoutBackdrop")
  local spacing, padding = flyoutDb.spacing, flyoutDb.padding
  local dbGroupSpacing = flyoutDb.groupSpacing or 0
  local slotWidth = flyoutDb.width + E.Border
  local slotHeight = (slotWidth - E.Border) / 3 * 2 + E.Border
  local labelFont = F.GetFontPath(flyoutDb.labelFont)

  -- Limit the number of slots per column
  local maxSlotsPerColumn = 8
  local numPrimaryColumns = math.ceil(#primarySlots / maxSlotsPerColumn)
  local numSecondaryColumns = secondarySlots and math.ceil(#secondarySlots / maxSlotsPerColumn) or 0

  local totalColumns = numPrimaryColumns + numSecondaryColumns
  local totalSlots = #primarySlots + (secondarySlots and #secondarySlots or 0)

  -- Extra gap inserted between primary and secondary column groups
  local groupSpacing = (numSecondaryColumns > 0) and dbGroupSpacing or 0

  -- If there's less than 8 items in a column, we want to adjust our totalHeight calculation
  local heightCalcVar = (maxSlotsPerColumn < #primarySlots and maxSlotsPerColumn or #primarySlots)
  -- Calculate the total width and height of the flyout
  local totalWidth = totalColumns * slotWidth + (totalColumns - 1) * spacing + 2 * padding + groupSpacing
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
      -- Secondary slots start to the left of the primary slots and grow left (with extra group gap)
      columnOffset = numPrimaryColumns * slotWithSpacing + slotOffset + padding + groupSpacing
    end

    if not slot then
      slot = CreateFrame("Button", TXUI.Title .. "SecureFlyoutSlot" .. i, secureFlyOutFrame, "SecureActionButtonTemplate")
      slot:EnableMouse(true)
      slot:RegisterForClicks(GetCVarBool("ActionButtonUseKeyDown") and "AnyDown" or "AnyUp")
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
        self.flyoutIsOpen = false
      end)

      F.CreateSoftShadow(slot, 4)
      secureFlyOutButtons[i] = slot
    end

    slot:SetSize(slotWidth, slotHeight)
    slot.label:SetFont(labelFont, flyoutDb.labelFontSize, "OUTLINE")
    slot:ClearAllPoints()

    if indexInColumn == 1 then
      -- First slot in the column
      slot:SetPoint(dirDown and "TOPRIGHT" or "BOTTOMRIGHT", secureFlyOutFrame, dirDown and "TOPRIGHT" or "BOTTOMRIGHT", -columnOffset, self.dirMulti * padding)
      prevSlots[currentColumn] = slot
    else
      -- Subsequent slots, positioned above the previous slot in the same column
      -- Ensure the slot is positioned correctly with respect to spacing and the slot above it
      slot:SetPoint(dirDown and "TOP" or "BOTTOM", prevSlots[currentColumn], dirDown and "BOTTOM" or "TOP", 0, self.dirMulti * spacing)
      prevSlots[currentColumn] = slot
    end

    local isItem = info.type == "item" or info.type == "toy"
    slot:SetAttribute("type", isItem and "item" or info.type)

    if info.type == "function" then
      slot:SetAttribute("_function", info.func)
      slot.spellID = info.spellID
      slot.isItem = nil
    elseif isItem then
      slot:SetAttribute("item", info.name)
      slot.spellID = info.spellID
      slot.isItem = true
    else
      slot:SetAttribute("spell", info.spellID)
      slot.spellID = info.spellID
      slot.isItem = nil
    end

    local texture = info.icon or GetSpellTexture(info.spellID)

    slot:SetNormalTexture(texture)
    slot:SetPushedTexture(texture)
    slot:SetDisabledTexture(texture)

    local left, right, top, bottom = E:CropRatio(slot:GetWidth(), slot:GetHeight())
    local normalTexture, pushedTexture, disabledTexture = slot:GetNormalTexture(), slot:GetPushedTexture(), slot:GetDisabledTexture()
    normalTexture:SetTexCoord(left, right, top, bottom)
    normalTexture:SetInside()
    pushedTexture:SetTexCoord(left, right, top, bottom)
    pushedTexture:SetInside()
    disabledTexture:SetTexCoord(left, right, top, bottom)
    disabledTexture:SetInside()
    disabledTexture:SetDesaturated(true)

    -- Reset cooldown state from any previous use of this pooled button
    slot:SetScript("OnUpdate", nil)
    if slot.cooldown then slot.cooldown:SetCooldown(0, 0) end
    if slot.cdText then slot.cdText:SetText("") end

    -- Create Cooldown for spells and items
    if info.type == "spell" or isItem then
      if not slot.cooldown then
        local cooldown = CreateFrame("Cooldown", nil, slot, "CooldownFrameTemplate")
        cooldown:SetAllPoints()
        cooldown:SetDrawBling(false)
        cooldown:SetDrawEdge(false)
        cooldown:SetHideCountdownNumbers(true)
        slot.cooldown = cooldown
      end

      if not slot.cdText then
        local cdText = slot.cooldown:CreateFontString(nil, "OVERLAY")
        cdText:SetPoint("CENTER", slot.cooldown, "CENTER")
        slot.cdText = cdText
      end

      slot.cdText:SetFont(labelFont, flyoutDb.labelFontSize, "OUTLINE")

      -- Hook OnUpdate script to update cooldown
      if info.type == "spell" then
        slot:SetScript("OnUpdate", function(btn)
          local start, duration = E:GetSpellCooldown(info.spellID)
          if start and duration and duration > 0 then
            local remaining = math.floor((start + duration) - GetTime())
            slot.cdText:SetText(F.String.FormatTimeClass(remaining))
            btn.cooldown:SetCooldown(start, duration)
          else
            btn.cooldown:SetCooldown(0, 0)
            slot.cdText:SetText("")
          end
        end)
      elseif GetItemCooldown then
        slot:SetScript("OnUpdate", function(btn)
          local start, duration = GetItemCooldown(info.spellID)
          if start and duration and duration > 0 then
            local remaining = math.floor((start + duration) - GetTime())
            slot.cdText:SetText(F.String.FormatTimeClass(remaining))
            btn.cooldown:SetCooldown(start, duration)
          else
            btn.cooldown:SetCooldown(0, 0)
            slot.cdText:SetText("")
          end
        end)
      end
    end

    if info.label and E.db.TXUI.wunderbar.subModules.Hearthstone.showLabels and not info.mage then
      slot.label:SetText(info.label)
    elseif info.label and E.db.TXUI.wunderbar.subModules.Hearthstone.showMageLabels and info.mage then
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
    self.flyoutIsOpen = false
    return
  end

  secureFlyOutFrame:SetFrameStrata("DIALOG")
  secureFlyOutFrame:ClearAllPoints()

  if dirUp then
    secureFlyOutFrame:SetPoint("BOTTOMRIGHT", parent, "TOPRIGHT")
  elseif dirDown then
    secureFlyOutFrame:SetPoint("TOPRIGHT", parent, "BOTTOMRIGHT")
  elseif dirLeft then
    secureFlyOutFrame:SetPoint("RIGHT", parent, "LEFT")
  elseif dirRight then
    secureFlyOutFrame:SetPoint("LEFT", parent, "RIGHT")
  end

  for i = 1, numSlots do
    local slot = secureFlyOutButtons[i]

    if slot.FadeIn:IsPlaying() then slot.FadeIn:Stop() end
    slot.FadeIn:Play()
  end

  secureFlyOutFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
  secureFlyOutFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
  secureFlyOutFrame:SetScript("OnEvent", function(frame, event)
    if event and (event == "PLAYER_REGEN_DISABLED" or event == "PLAYER_ENTERING_WORLD") then
      if frame and frame:IsShown() then
        frame:Hide()
        self.flyoutIsOpen = false
      end
    end
  end)

  secureFlyOutFrame:Show()
  self.flyoutIsOpen = true
end
