local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local WB = TXUI:GetModule("WunderBar")

local CreateFrame = CreateFrame
local GameTooltip = GameTooltip
local GetSpellTexture = GetSpellTexture
local InCombatLockdown = InCombatLockdown
local unpack = unpack

local secureFlyOutFrame
local secureFlyOutButtons = {}

function WB:ShowSecureFlyOut(parent, direction, slots)
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

  if not secureFlyOutFrame then secureFlyOutFrame = CreateFrame("Frame", nil, self.bar) end
  secureFlyOutFrame:SetSize(30 + E.Border, 30 + E.Border)

  local numSlots = 0
  local spacing, padding = 2, 2

  local prevSlot = nil
  for i = 1, #slots do
    local info = slots[i]

    local slot = secureFlyOutButtons[i]
    if not slot then
      slot = CreateFrame("Button", nil, secureFlyOutFrame, "SecureActionButtonTemplate")
      slot:EnableMouse(true)
      slot:RegisterForClicks("AnyDown")
      slot:SetSize(30 + E.Border, 30 + E.Border)
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
      slot.FadeIn.Hold:SetDuration(i * (0.3 / #slots))
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

    if direction == "UP" then
      if prevSlot then
        slot:SetPoint("BOTTOM", prevSlot, "TOP", 0, spacing)
      else
        slot:SetPoint("BOTTOM", 0, padding)
      end
    elseif direction == "DOWN" then
      if prevSlot then
        slot:SetPoint("TOP", prevSlot, "BOTTOM", 0, -spacing)
      else
        slot:SetPoint("TOP", 0, -padding)
      end
    elseif direction == "LEFT" then
      if prevSlot then
        slot:SetPoint("RIGHT", prevSlot, "LEFT", -spacing, 0)
      else
        slot:SetPoint("RIGHT", -padding, 0)
      end
    elseif direction == "RIGHT" then
      if prevSlot then
        slot:SetPoint("LEFT", prevSlot, "RIGHT", spacing, 0)
      else
        slot:SetPoint("LEFT", padding, 0)
      end
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

    prevSlot = slot
    numSlots = numSlots + 1
  end

  -- Hide unused buttons
  local unusedButtonIndex = numSlots + 1
  while secureFlyOutButtons[unusedButtonIndex] do
    secureFlyOutButtons[unusedButtonIndex]:Hide()
    unusedButtonIndex = unusedButtonIndex + 1
  end

  if numSlots == 0 then
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
