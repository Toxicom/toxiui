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
      GameTooltip:SetSpellByID(button.spellID)
    end
  end

  local numPrimarySlots = #primarySlots
  local numSecondarySlots = secondarySlots and #secondarySlots or 0
  local maxSlotsInOneColumn = math.max(numPrimarySlots, numSecondarySlots)
  local totalSlots = numPrimarySlots + numSecondarySlots
  local spacing, padding = 2, 2
  local slotWidth = 40 + E.Border
  local slotHeight = 30 + E.Border

  if not secureFlyOutFrame then secureFlyOutFrame = CreateFrame("Frame", nil, self.bar) end
  -- Adjust frame size: width for two columns, height based on the taller column
  secureFlyOutFrame:SetSize(2 * slotWidth + 3 * spacing + padding, maxSlotsInOneColumn * slotHeight + (maxSlotsInOneColumn - 1) * spacing + 2 * padding)

  local numSlots = 0

  local prevSlot
  for i = 1, totalSlots do
    local info
    local slot
    local columnOffset -- X offset for the column (0 for the first column, slotWidth + spacing for the second)
    if i <= numPrimarySlots then
      info = primarySlots[i]
      slot = secureFlyOutButtons[i]
      columnOffset = 0
    elseif secondarySlots then
      info = secondarySlots[i - numPrimarySlots]
      slot = secureFlyOutButtons[i]
      columnOffset = slotWidth + spacing -- Offset for the second column
    end

    if not slot then
      slot = CreateFrame("Button", nil, secureFlyOutFrame, "SecureActionButtonTemplate")
      slot:EnableMouse(true)
      slot:RegisterForClicks("AnyDown")
      slot:SetSize(40 + E.Border, 30 + E.Border)
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

    if i == 1 or i == numPrimarySlots + 1 then
      -- First slot in each column
      slot:SetPoint("TOPLEFT", secureFlyOutFrame, "TOPLEFT", padding + columnOffset, -padding)
      prevSlot = slot -- Set prevSlot here for the first slot in each column
    else
      -- Subsequent slots, positioned below the previous slot in the same column
      slot:SetPoint("TOP", prevSlot, "BOTTOM", 0, -spacing)
      prevSlot = slot -- Set prevSlot here for subsequent slots
    end

    slot:SetAttribute("type", info.type)

    if info.type == "function" then
      slot:SetAttribute("_function", info.func)
    else
      slot:SetAttribute(info.type, info.spellID)
      slot.spellID = info.spellID
    end

    local texture = info.icon or GetSpellTexture(info.spellID)

    slot:SetNormalTexture(texture)
    slot:SetPushedTexture(texture)
    slot:SetDisabledTexture(texture)

    local left, right, top, bottom = unpack(E.TexCoords)
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
    secureFlyOutFrame:SetPoint("BOTTOM", parent, "TOP")
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
