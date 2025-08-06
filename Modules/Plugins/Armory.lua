local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local A = TXUI:NewModule("Armory", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")

-- Globals
local _G = _G
local BreakUpLargeNumbers = BreakUpLargeNumbers
local C_PaperDollInfo = _G.C_PaperDollInfo
local CreateFrame = CreateFrame
local EFFECTIVE_LEVEL_FORMAT = _G.EFFECTIVE_LEVEL_FORMAT
local format = string.format
local GetAchievementInfo = GetAchievementInfo
local GetAverageItemLevel = GetAverageItemLevel
local GetCurrentTitle = GetCurrentTitle
local GetInventoryItemID = GetInventoryItemID
local GetItemInfo = GetItemInfo
local GetMeleeHaste = GetMeleeHaste
local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo
local GetSpecializationRole = GetSpecializationRole

local GetTitleName = GetTitleName
local InCombatLockdown = InCombatLockdown
local ipairs = ipairs
local ENUM_ITEM_CLASS_WEAPON = _G.Enum.ItemClass.Weapon
local LE_UNIT_STAT_AGILITY = _G.LE_UNIT_STAT_AGILITY
local LE_UNIT_STAT_INTELLECT = _G.LE_UNIT_STAT_INTELLECT
local LE_UNIT_STAT_STRENGTH = _G.LE_UNIT_STAT_STRENGTH
local LOCALIZED_CLASS_NAMES_FEMALE = _G.LOCALIZED_CLASS_NAMES_FEMALE
local LOCALIZED_CLASS_NAMES_MALE = _G.LOCALIZED_CLASS_NAMES_MALE
local max = math.max
local MIN_PLAYER_LEVEL_FOR_ITEM_LEVEL_DISPLAY = _G.MIN_PLAYER_LEVEL_FOR_ITEM_LEVEL_DISPLAY
local next = next
local pairs = pairs
local select = select
local UnitAttackSpeed = UnitAttackSpeed
local UnitEffectiveLevel = UnitEffectiveLevel
local UnitLevel = UnitLevel
local UnitSex = UnitSex
local unpack = unpack
local wipe = wipe

-- Vars
A.enumDirection = F.Enum { "LEFT", "RIGHT", "BOTTOM" }
A.colors = {
  LIGHT_GREEN = "#12E626",
  DARK_GREEN = "#00B01C",
  RED = "#F0544F",
}
A.characterSlots = {
  ["HeadSlot"] = {
    id = 1,
    needsEnchant = false,
    needsSocket = false,
    direction = A.enumDirection.LEFT,
  },
  ["NeckSlot"] = {
    id = 2,
    needsEnchant = false,
    needsSocket = TXUI.IsRetail,
    warningCondition = {
      level = I.MaxLevelTable[TXUI.MetaFlavor],
    },
    direction = A.enumDirection.LEFT,
  },
  ["ShoulderSlot"] = {
    id = 3,
    needsEnchant = false,
    needsSocket = false,
    direction = A.enumDirection.LEFT,
  },
  ["BackSlot"] = {
    id = 15,
    needsEnchant = true,
    warningCondition = {
      level = I.MaxLevelTable[TXUI.MetaFlavor],
    },
    needsSocket = false,
    direction = A.enumDirection.LEFT,
  },
  ["ChestSlot"] = {
    id = 5,
    needsEnchant = true,
    warningCondition = {
      level = I.MaxLevelTable[TXUI.MetaFlavor],
    },
    needsSocket = false,
    direction = A.enumDirection.LEFT,
  },
  ["ShirtSlot"] = {
    id = 4,
    needsEnchant = false,
    needsSocket = false,
    direction = A.enumDirection.LEFT,
  },
  ["TabardSlot"] = {
    id = 18,
    needsEnchant = false,
    needsSocket = false,
    direction = A.enumDirection.LEFT,
  },
  ["WristSlot"] = {
    id = 9,
    needsEnchant = true,
    warningCondition = {
      level = I.MaxLevelTable[TXUI.MetaFlavor],
    },
    needsSocket = false,
    direction = A.enumDirection.LEFT,
  },
  ["HandsSlot"] = {
    id = 10,
    needsEnchant = false,
    needsSocket = false,
    direction = A.enumDirection.RIGHT,
  },
  ["WaistSlot"] = {
    id = 6,
    needsEnchant = false,
    needsSocket = false,
    direction = A.enumDirection.RIGHT,
  },
  ["LegsSlot"] = {
    id = 7,
    needsEnchant = true,
    warningCondition = {
      level = I.MaxLevelTable[TXUI.MetaFlavor],
    },
    needsSocket = false,
    direction = A.enumDirection.RIGHT,
  },
  ["FeetSlot"] = {
    id = 8,
    needsEnchant = true,
    warningCondition = {
      level = I.MaxLevelTable[TXUI.MetaFlavor],
    },
    needsSocket = false,
    direction = A.enumDirection.RIGHT,
  },
  ["Finger0Slot"] = {
    id = 11,
    needsEnchant = true,
    warningCondition = {
      level = I.MaxLevelTable[TXUI.MetaFlavor],
    },
    needsSocket = TXUI.IsRetail,
    direction = A.enumDirection.RIGHT,
  },
  ["Finger1Slot"] = {
    id = 12,
    needsEnchant = true,
    warningCondition = {
      level = I.MaxLevelTable[TXUI.MetaFlavor],
    },
    needsSocket = TXUI.IsRetail,
    direction = A.enumDirection.RIGHT,
  },
  ["Trinket0Slot"] = {
    id = 13,
    needsEnchant = false,
    needsSocket = false,
    direction = A.enumDirection.RIGHT,
  },
  ["Trinket1Slot"] = {
    id = 14,
    needsEnchant = false,
    needsSocket = false,
    direction = A.enumDirection.RIGHT,
  },
  ["MainHandSlot"] = {
    id = 16,
    needsEnchant = true,
    warningCondition = {
      level = I.MaxLevelTable[TXUI.MetaFlavor],
    },
    needsSocket = false,
    direction = A.enumDirection.RIGHT,
  },
  ["SecondaryHandSlot"] = {
    id = 17,
    needsEnchant = true,
    warningCondition = {
      itemType = ENUM_ITEM_CLASS_WEAPON,
      level = I.MaxLevelTable[TXUI.MetaFlavor],
    },
    needsSocket = false,
    direction = A.enumDirection.LEFT,
  },
}

function A:GetPrimaryTalentIndex()
  local primaryTalentTreeIdx = 0
  local primaryTalentTree = GetSpecialization()

  if primaryTalentTree then primaryTalentTreeIdx = GetSpecializationInfo(primaryTalentTree) or 0 end

  return primaryTalentTreeIdx
end

function A:UseFontGradient(db, prefix)
  local dbEntry = db[prefix .. "FontColor"]
  return (dbEntry == "GRADIENT")
end

function A:UseFontClassGradient(db, prefix)
  local dbEntry = db[prefix .. "FontColor"]
  return (dbEntry == "CLASS_GRADIENT")
end

function A:GetSlotNameByID(slotId)
  for slot, options in pairs(self.characterSlots) do
    if options.id == slotId then return slot end
  end
end

function A:CheckMessageCondition(slotOptions)
  local conditions = slotOptions.warningCondition
  local enchantNeeded = true

  -- Level Condition
  if enchantNeeded and conditions.level then enchantNeeded = (conditions.level == UnitLevel("player")) end

  -- Primary Stat Condition
  if enchantNeeded and conditions.primary then
    enchantNeeded = false
    local spec = GetSpecialization()
    if spec then
      local primaryStat = select(6, GetSpecializationInfo(spec, nil, nil, nil, UnitSex("player")))

      enchantNeeded = (conditions.primary == primaryStat)
    end
  end

  -- ItemType and ItemSubtype check
  if enchantNeeded and conditions.itemType then
    local itemType = select(12, GetItemInfo(GetInventoryItemID("player", slotOptions.id)))
    enchantNeeded = (itemType == conditions.itemType)
  end

  return enchantNeeded
end

function A:AnimationsAllowed()
  return (not InCombatLockdown()) and self.db.animations
end

function A:ClearAnimations(stats)
  if stats then
    self.statsCount = 1
    wipe(self.statsObjects)
  else
    wipe(self.animationObjects)
  end
end

function A:GetAnimationSlot(stats)
  if stats then
    local count = self.statsCount
    self.statsCount = self.statsCount + 1
    return count
  end
end

function A:AddAnimation(anim, stats, slot)
  if stats then
    if not slot then self.statsCount = self.statsCount + 1 end
    self.statsObjects[anim] = true
  else
    self.animationObjects[anim] = true
  end
end

function A:PlayAnimations()
  for anim, _ in pairs(self.statsObjects) do
    if anim:IsPlaying() then anim:Stop() end
    if self:AnimationsAllowed() then anim:Play() end
  end

  for anim, _ in pairs(self.animationObjects) do
    if anim:IsPlaying() then anim:Stop() end
    if self:AnimationsAllowed() then anim:Play() end
  end
end

function A:SetupGrowAnimation(obj, hold)
  local holdDuration, fadeDuration, growDuration = 0.02, 0.15, 1

  if obj.GrowIn then
    if hold and hold > 0 then
      obj.GrowIn.Hold:SetDuration(((hold * holdDuration) * self.db.animationsMult) + ((fadeDuration * 0.3) * self.db.animationsMult))
    else
      obj.GrowIn.Hold:SetDuration(0)
    end

    obj.GrowIn.Grow:SetDuration(growDuration * self.db.animationsMult)
    return
  end

  obj.GrowIn = TXUI:CreateAnimationGroup(obj)

  obj.GrowIn.ResetGrow = obj.GrowIn:CreateAnimation("Width")
  obj.GrowIn.ResetGrow:SetDuration(0)
  obj.GrowIn.ResetGrow:SetChange(0)
  obj.GrowIn.ResetGrow:SetOrder(1)

  obj.GrowIn.Hold = obj.GrowIn:CreateAnimation("Sleep")
  obj.GrowIn.Hold:SetOrder(2)

  obj.GrowIn.Grow = obj.GrowIn:CreateAnimation("Width")
  obj.GrowIn.Grow:SetEasing("out-quintic")
  obj.GrowIn.Grow:SetDuration(growDuration * self.db.animationsMult)
  obj.GrowIn.Grow:SetOrder(3)

  if hold and hold > 0 then
    obj.GrowIn.Hold:SetDuration(((hold * holdDuration) * self.db.animationsMult) + ((fadeDuration * 0.3) * self.db.animationsMult))
  else
    obj.GrowIn.Hold:SetDuration(0)
  end

  self:AddAnimation(obj.GrowIn)
end

function A:SetupFadeAnimation(obj, slot)
  local holdDuration, fadeDuration = 0.02, 0.15

  if obj.FadeIn then
    obj.FadeIn.Hold:SetDuration(((slot or self.statsCount) * holdDuration) * self.db.animationsMult)
    obj.FadeIn.Fade:SetDuration(fadeDuration * self.db.animationsMult)
    self:AddAnimation(obj.FadeIn, true, slot)
    return
  end

  obj.FadeIn = TXUI:CreateAnimationGroup(obj)

  obj.FadeIn.ResetFade = obj.FadeIn:CreateAnimation("Fade")
  obj.FadeIn.ResetFade:SetDuration(0)
  obj.FadeIn.ResetFade:SetChange(0)
  obj.FadeIn.ResetFade:SetOrder(1)

  obj.FadeIn.Hold = obj.FadeIn:CreateAnimation("Sleep")
  obj.FadeIn.Hold:SetDuration(((slot or self.statsCount) * holdDuration) * self.db.animationsMult)
  obj.FadeIn.Hold:SetOrder(2)

  obj.FadeIn.Fade = obj.FadeIn:CreateAnimation("Fade")
  obj.FadeIn.Fade:SetDuration(fadeDuration * self.db.animationsMult)
  obj.FadeIn.Fade:SetEasing("out-quintic")
  obj.FadeIn.Fade:SetChange(1)
  obj.FadeIn.Fade:SetOrder(3)

  self:AddAnimation(obj.FadeIn, true, slot)
end

function A:UpdateItemLevel()
  if not self.frame:IsShown() then return end

  F.SetFontFromDB(self.db.stats, "itemLevel", self.frame.ItemLevelText)

  local itemLevelText

  local avgItemLevel, avgItemLevelEquipped = GetAverageItemLevel()
  local minItemLevel = C_PaperDollInfo.GetMinItemLevel()
  local displayItemLevel = max(minItemLevel or 0, avgItemLevelEquipped)

  if self.db.stats.showAvgItemLevel and TXUI.IsRetail then
    itemLevelText = format(format("%s / %s", self.db.stats.itemLevelFormat, self.db.stats.itemLevelFormat), displayItemLevel, avgItemLevel)
  else
    itemLevelText = format(self.db.stats.itemLevelFormat, displayItemLevel)
  end

  if self:UseFontGradient(self.db.stats, "itemLevel") then
    local epicComplete = select(13, GetAchievementInfo(TXUI.IsRetail and 40147 or 5372))

    if epicComplete then
      self.frame.ItemLevelText:SetText(F.String.FastGradient(itemLevelText, 0.78, 0.13, 0.57, 0.42, 0.08, 0.82))
    else
      local rareComplete = select(13, GetAchievementInfo(TXUI.IsRetail and 40146 or 5373))

      if rareComplete then
        self.frame.ItemLevelText:SetText(F.String.FastGradient(itemLevelText, 0.01, 0.78, 0.98, 0, 0.38, 0.90))
      else
        self.frame.ItemLevelText:SetText(F.String.FastGradient(itemLevelText, 0.07, 0.90, 0.15, 0, 0.69, 0.11))
      end
    end
  elseif self:UseFontClassGradient(self.db.stats, "itemLevel") then
    self.frame.ItemLevelText:SetText(F.String.GradientClass(itemLevelText, nil, true))
  else
    self.frame.ItemLevelText:SetText(itemLevelText)
    F.SetFontColorFromDB(self.db.stats, "itemLevel", self.frame.ItemLevelText)
  end
end

function A:UpdateTitle()
  F.SetFontFromDB(self.db, "nameText", self.nameText, false)
  F.SetFontFromDB(self.db, "titleText", self.titleText, false)
  F.SetFontFromDB(self.db, "levelTitleText", self.levelTitleText)
  F.SetFontFromDB(self.db, "levelText", self.levelText)
  F.SetFontFromDB(self.db, "classText", self.classText, false)
  F.SetFontFromDB(self.db, "specIcon", self.specIcon, false)

  local titleId = GetCurrentTitle()
  local titleName = GetTitleName(titleId) or ""
  local classNames = LOCALIZED_CLASS_NAMES_MALE
  local playerLevel = UnitLevel("player")
  local playerEffectiveLevel = UnitEffectiveLevel("player")

  if playerEffectiveLevel ~= playerLevel then playerLevel = EFFECTIVE_LEVEL_FORMAT:format(playerEffectiveLevel, playerLevel) end

  local currentClass = E.myclass
  if UnitSex("player") == 3 then classNames = LOCALIZED_CLASS_NAMES_FEMALE end

  local primaryTalentTreeIdx = A:GetPrimaryTalentIndex()

  -- Those cannot be empty
  if not currentClass or not playerLevel then return end

  local classColorNormal = E.db.TXUI.themes.gradientMode.classColorMap[I.Enum.GradientMode.Color.NORMAL][currentClass]

  if self:UseFontGradient(self.db, "nameText") then
    self.nameText:SetText(F.String.FastGradient(E.myname, 0, 0.6, 1, 0, 0.9, 1))
  elseif self:UseFontClassGradient(self.db, "nameText") then
    self.nameText:SetText(F.String.GradientClass(E.myname))
  else
    self.nameText:SetText(E.myname)
    F.SetFontColorFromDB(self.db, "nameText", self.nameText)
  end

  if self:UseFontGradient(self.db, "titleText") then
    self.titleText:SetText(F.String.FastGradient(titleName, 0, 0.9, 1, 0, 0.6, 1))
  elseif self:UseFontClassGradient(self.db, "titleText") then
    self.titleText:SetText(F.String.GradientClass(titleName))
  else
    self.titleText:SetText(titleName)
    F.SetFontColorFromDB(self.db, "titleText", self.titleText)
  end

  if self.db.levelTitleTextShort then
    self.levelTitleText:SetText("Lv")
  else
    self.levelTitleText:SetText("Level")
  end
  self.levelText:SetText(playerLevel)

  local fontIcon = P.wunderbar.subModules.SpecSwitch.icons[primaryTalentTreeIdx] or P.wunderbar.subModules.SpecSwitch.icons[0]

  if self:UseFontGradient(self.db, "specIcon") then
    self.specIcon:SetText(F.String.RGB(fontIcon, classColorNormal))
  else
    self.specIcon:SetText(fontIcon)
    F.SetFontColorFromDB(self.db, "specIcon", self.specIcon)
  end

  if self:UseFontGradient(self.db, "classText") then
    self.classText:SetText(F.String.GradientClass(classNames[currentClass], nil, true))
  else
    self.classText:SetText(classNames[currentClass])
    F.SetFontColorFromDB(self.db, "classText", self.classText)
  end

  self.nameText:ClearAllPoints()
  self.nameText:SetPoint("TOP", self.frameModel, self.db.nameTextOffsetX, 59 + self.db.nameTextOffsetY)
  self.nameText:SetJustifyH("CENTER")
  self.nameText:SetJustifyV("BOTTOM")

  self.titleText:ClearAllPoints()
  self.titleText:SetPoint("LEFT", self.nameText, "RIGHT", self.db.titleTextOffsetX, self.db.titleTextOffsetY)
  self.titleText:SetJustifyH("LEFT")
  self.titleText:SetJustifyV("BOTTOM")

  local iconPadding = 10
  local textPadding = 2

  local leftWidth = self.levelText:GetStringWidth() + self.levelTitleText:GetStringWidth() + textPadding
  local rightWidth = self.classText:GetStringWidth()
  local iconWidth = self.specIcon:GetStringWidth() + (iconPadding * 2)
  local totalWidth = leftWidth + rightWidth + iconWidth
  local anchorWidth = totalWidth - (leftWidth + (iconWidth / 2))
  local centerOffset = (totalWidth / 2) - anchorWidth

  self.specIcon:ClearAllPoints()
  self.specIcon:SetPoint("TOP", self.frameModel, centerOffset, 30)
  self.specIcon:SetJustifyH("CENTER")
  self.specIcon:SetJustifyV("BOTTOM")

  self.levelText:ClearAllPoints()
  self.levelText:SetPoint("RIGHT", self.specIcon, "LEFT", (-iconPadding + self.db.levelTextOffsetX), self.db.levelTextOffsetY)
  self.levelText:SetJustifyH("LEFT")
  self.levelText:SetJustifyV("BOTTOM")

  self.levelTitleText:ClearAllPoints()
  self.levelTitleText:SetPoint("RIGHT", self.levelText, "LEFT", (-textPadding + self.db.levelTitleTextOffsetX), self.db.levelTitleTextOffsetY)
  self.levelTitleText:SetJustifyH("LEFT")
  self.levelTitleText:SetJustifyV("BOTTOM")

  self.classText:ClearAllPoints()
  self.classText:SetPoint("LEFT", self.specIcon, "RIGHT", (iconPadding + self.db.classTextOffsetX), self.db.classTextOffsetY)
  self.classText:SetJustifyH("RIGHT")
  self.classText:SetJustifyV("BOTTOM")
end

function A:EnchantAbbreviate(str)
  local abbrevs = {
    -- Primary
    [_G["SPELL_STAT" .. _G.LE_UNIT_STAT_STRENGTH .. "_NAME"]] = "Str.",
    [_G["SPELL_STAT" .. _G.LE_UNIT_STAT_AGILITY .. "_NAME"]] = "Agi.",
    [_G["SPELL_STAT" .. _G.LE_UNIT_STAT_INTELLECT .. "_NAME"]] = "Int.",
    [_G["SPELL_STAT" .. _G.LE_UNIT_STAT_STAMINA .. "_NAME"]] = "Stam.",
    -- Secondary
    [_G["STAT_VERSATILITY"]] = "Vers.",
    [_G["STAT_CRITICAL_STRIKE"]] = "Crit.",
    -- Tertiary
    [_G["STAT_AVOIDANCE"]] = "Avoid.",
  }

  local short = F.String.Abbreviate(str)
  for stat, abbrev in pairs(abbrevs) do
    short = short:gsub(stat, abbrev)
  end

  return short
end

function A:UpdatePageStrings(_, slotId, _, slotItem, slotInfo, which)
  if which ~= "Character" then return end
  if not slotItem.enchantText or not slotItem.iLvlText then return end

  local slotName = self:GetSlotNameByID(slotId)
  if not slotName then return end

  local slotOptions = self.characterSlots[slotName]
  if not slotOptions then return end

  -- Enchant/Socket Text Handling
  if self.db.pageInfo.enchantTextEnabled and slotInfo.itemLevelColors and next(slotInfo.itemLevelColors) then
    if self.db.pageInfo.missingSocketText and slotOptions.needsSocket then
      if not slotOptions.warningCondition or (self:CheckMessageCondition(slotOptions)) then
        local missingGemSlots = 2 - #slotInfo.gems
        if missingGemSlots > 0 then
          local text = format("Add %d sockets", missingGemSlots)
          local missingColor = { F.String.FastColorGradientHex(missingGemSlots / 2, A.colors.LIGHT_GREEN, A.colors.RED) }
          slotItem.enchantText:SetText(F.String.RGB(text, missingColor))
        end
      else
        slotItem.enchantText:SetText("")
      end
    elseif slotInfo.enchantColors and next(slotInfo.enchantColors) then
      if slotInfo.enchantText and (slotInfo.enchantText ~= "") then
        local text = slotInfo.enchantTextShort
        -- Strip color
        text = F.String.StripColor(text)
        if self.db.pageInfo.abbreviateEnchantText then text = self:EnchantAbbreviate(slotInfo.enchantText) end

        if self.db.pageInfo.useEnchantClassColor then
          slotItem.enchantText:SetText(F.String.Class(text))
        else
          slotItem.enchantText:SetText(text)
        end
      end
    elseif self.db.pageInfo.missingEnchantText and slotOptions.needsEnchant and not E.TimerunningID then
      if not slotOptions.warningCondition or (self:CheckMessageCondition(slotOptions)) then
        slotItem.enchantText:SetText(F.String.Error("Add enchant"))
      else
        slotItem.enchantText:SetText("")
      end
    else
      slotItem.enchantText:SetText("")
    end
  else
    slotItem.enchantText:SetText("")
  end

  -- Hide Gradient
  if slotItem.TXGradient then slotItem.TXGradient:Hide() end

  -- If we got an item color, show gradient and set color
  if slotInfo.itemLevelColors and next(slotInfo.itemLevelColors) then
    local r, g, b = unpack(slotInfo.itemLevelColors)

    -- Create Gradient if it doesen't exist
    if not slotItem.TXGradient then
      slotItem.TXGradient = CreateFrame("Frame", nil, slotItem)
      slotItem.TXGradient:SetFrameLevel(self.frameModel:GetFrameLevel() - 1)

      slotItem.TXGradient.Texture = slotItem.TXGradient:CreateTexture(nil, "OVERLAY")
      slotItem.TXGradient.Texture:SetInside()
      slotItem.TXGradient.Texture:SetTexture(E.media.blankTex)
      slotItem.TXGradient.Texture:SetVertexColor(1, 1, 1, 1)

      if slotOptions.direction == self.enumDirection.LEFT then
        slotItem.TXGradient:SetPoint("BOTTOMLEFT", slotItem, "BOTTOMRIGHT", -1, -1)
      elseif slotOptions.direction == self.enumDirection.RIGHT then
        slotItem.TXGradient:SetPoint("BOTTOMRIGHT", slotItem, "BOTTOMLEFT", 1, -1)
      end
    end

    -- Setup Animations
    self:SetupGrowAnimation(slotItem.TXGradient)

    -- Update Size
    slotItem.TXGradient.GrowIn.Grow:SetChange(E:Scale(self.db.pageInfo.itemQualityGradientWidth))
    slotItem.TXGradient:SetSize(self.db.pageInfo.itemQualityGradientWidth, self.db.pageInfo.itemQualityGradientHeight)

    -- Update Colors
    if slotOptions.direction == self.enumDirection.LEFT then
      F.Color.SetGradientRGB(
        slotItem.TXGradient.Texture,
        "HORIZONTAL",
        r,
        g,
        b,
        self.db.pageInfo.itemQualityGradientStartAlpha,
        r,
        g,
        b,
        self.db.pageInfo.itemQualityGradientEndAlpha
      )
    elseif slotOptions.direction == self.enumDirection.RIGHT then
      F.Color.SetGradientRGB(
        slotItem.TXGradient.Texture,
        "HORIZONTAL",
        r,
        g,
        b,
        self.db.pageInfo.itemQualityGradientEndAlpha,
        r,
        g,
        b,
        self.db.pageInfo.itemQualityGradientStartAlpha
      )
    end

    slotItem.TXGradient:Show()
  end

  -- iLvL Text Handling
  if not self.db.pageInfo.itemLevelTextEnabled then slotItem.iLvlText:SetText("") end

  -- Icons Handling
  if not self.db.pageInfo.itemLevelTextEnabled or not self.db.pageInfo.iconsEnabled then
    for x = 1, 10 do
      local essenceType = slotItem["textureSlotEssenceType" .. x]
      if essenceType then essenceType:Hide() end
      slotItem["textureSlot" .. x]:SetTexture()
      slotItem["textureSlotBackdrop" .. x]:Hide()
    end
  end
end

function A:UpdatePageInfo(_, _, which)
  if (which ~= nil) and (which ~= "Character") then return end

  for slot, options in pairs(self.characterSlots) do
    if (options.id ~= 4) and (options.id ~= 18) then
      local slotFrame = _G["Character" .. slot]

      if self.db.pageInfo.moveSockets then
        local slotWidth, slotHeight = slotFrame:GetWidth(), slotFrame:GetHeight()

        for i = 1, 3 do
          local socket = slotFrame["textureSlot" .. i]
          local socketWidth, socketHeight = 16, 8
          socket:SetSize(socketWidth, socketHeight)
          local left, right, top, bottom = E:CropRatio(socketWidth, socketHeight)
          socket:SetTexCoord(left, right, top, bottom)
          socket:ClearAllPoints()

          if i == 1 then
            if options.direction == self.enumDirection.LEFT then
              socket:SetPoint("BOTTOMLEFT", slotFrame, "BOTTOMLEFT", slotWidth + 10, slotHeight - socketHeight - E.Border)
            elseif options.direction == self.enumDirection.RIGHT then
              socket:SetPoint("BOTTOMRIGHT", slotFrame, "BOTTOMRIGHT", -(slotWidth + 10), slotHeight - socketHeight - E.Border)
            end
          else
            local prevSocket = slotFrame["textureSlot" .. i - 1]
            if options.direction == self.enumDirection.LEFT then
              socket:SetPoint("BOTTOMLEFT", prevSocket, "BOTTOMRIGHT", 0, 0)
            elseif options.direction == self.enumDirection.RIGHT then
              socket:SetPoint("BOTTOMRIGHT", prevSocket, "BOTTOMLEFT", 0, 0)
            end
          end
        end
      end

      -- ItemLevel Slot Text
      if slotFrame.iLvlText then F.SetFontFromDB(self.db.pageInfo, "iLvL", slotFrame.iLvlText, false) end

      -- Enchant Slot Text
      if slotFrame.enchantText then F.SetFontFromDB(self.db.pageInfo, "enchant", slotFrame.enchantText, false) end
    end
  end

  self:UpdateItemLevel()
end

function A:UpdateCategoryHeader(frame, animationSlot)
  if frame.StripTextures then frame:StripTextures() end
  if frame.backdrop then frame.backdrop:Kill() end
  if frame.Background then frame.Background:Kill() end

  local currentClass = E.myclass
  local classColorNormal = E.db.TXUI.themes.gradientMode.classColorMap[I.Enum.GradientMode.Color.NORMAL][currentClass]
  local classColorShift = E.db.TXUI.themes.gradientMode.classColorMap[I.Enum.GradientMode.Color.SHIFT][currentClass]

  -- Set custom font
  F.SetFontFromDB(self.db.stats, "header", frame.Title, false)

  local useHeaderGradient = self:UseFontGradient(self.db.stats, "header")
  local useHeaderClassGradient = self:UseFontClassGradient(self.db.stats, "header")
  local categoryHeader = F.String.StripColor(frame.Title:GetText())

  -- Set color gradient
  if useHeaderGradient then
    frame.Title:SetText(F.String.FastGradient(categoryHeader, 0, 0.9, 1, 0, 0.6, 1))
  elseif useHeaderClassGradient then
    frame.Title:SetText(F.String.GradientClass(categoryHeader))
  else
    frame.Title:SetText(categoryHeader)
    F.SetFontColorFromDB(self.db.stats, "header", frame.Title)
  end

  -- Create left divider
  local leftDivider = frame.Title.TXLeftDivider or frame:CreateTexture(nil, "ARTWORK")
  leftDivider:SetHeight(2)
  leftDivider:SetTexture(E.media.blankTex)
  leftDivider:SetVertexColor(1, 1, 1, 1)

  if useHeaderGradient then
    F.Color.SetGradientRGB(leftDivider, "HORIZONTAL", 0, 0.6, 1, 0, 0, 0.9, 1, 1)
  elseif useHeaderClassGradient then
    F.Color.SetGradientRGB(leftDivider, "HORIZONTAL", classColorNormal.r, classColorNormal.g, classColorNormal.b, 0, classColorShift.r, classColorShift.g, classColorShift.b, 1)
  else
    local fontColor = F.GetFontColorFromDB(self.db.stats, "header")
    F.Color.SetGradientRGB(leftDivider, "HORIZONTAL", fontColor.r, fontColor.g, fontColor.b, 0, fontColor.r, fontColor.g, fontColor.b, fontColor.a)
  end

  -- Create right divider
  local rightDivider = frame.Title.TXRightDivider or frame:CreateTexture(nil, "ARTWORK")
  rightDivider:SetHeight(2)
  rightDivider:SetTexture(E.media.blankTex)
  rightDivider:SetVertexColor(1, 1, 1, 1)
  F.Color.SetGradientRGB(rightDivider, "HORIZONTAL", 0, 0.9, 1, 1, 0, 0.6, 1, 0)
  if useHeaderGradient then
    F.Color.SetGradientRGB(rightDivider, "HORIZONTAL", 0, 0.9, 1, 1, 0, 0.6, 1, 0)
  elseif useHeaderClassGradient then
    F.Color.SetGradientRGB(rightDivider, "HORIZONTAL", classColorShift.r, classColorShift.g, classColorShift.b, 1, classColorNormal.r, classColorNormal.g, classColorNormal.b, 0)
  else
    local fontColor = F.GetFontColorFromDB(self.db.stats, "header")
    F.Color.SetGradientRGB(rightDivider, "HORIZONTAL", fontColor.r, fontColor.g, fontColor.b, fontColor.a, fontColor.r, fontColor.g, fontColor.b, 0)
  end

  -- Setup Animations
  self:SetupGrowAnimation(leftDivider, animationSlot)
  self:SetupGrowAnimation(rightDivider, animationSlot)

  -- Anchor to calculate size
  leftDivider:ClearAllPoints()
  leftDivider:SetPoint("LEFT", frame, "LEFT", 3, 0)
  leftDivider:SetPoint("RIGHT", frame.Title, "LEFT", -3, 0)
  rightDivider:ClearAllPoints()
  rightDivider:SetPoint("RIGHT", frame, "RIGHT", -3, 0)
  rightDivider:SetPoint("LEFT", frame.Title, "RIGHT", 3, 0)

  -- Vars
  local leftDividerWidth = leftDivider:GetWidth()
  local rightDividerWidth = leftDivider:GetWidth()

  -- Update Animations
  leftDivider.GrowIn.Grow:SetChange(leftDividerWidth)
  rightDivider.GrowIn.Grow:SetChange(rightDividerWidth)

  -- Set Final Anchor
  leftDivider:ClearAllPoints()
  leftDivider:SetPoint("RIGHT", frame.Title, "LEFT", -3, 0)

  rightDivider:ClearAllPoints()
  rightDivider:SetPoint("LEFT", frame.Title, "RIGHT", 3, 0)

  -- Set refs
  frame.Title.TXLeftDivider = leftDivider
  frame.Title.TXRightDivider = rightDivider
end

function A:CleanupCharacterStat(frame)
  -- Kill Blizzard and ElvUI Stuff
  if frame.Background then frame.Background:Kill() end
  if frame.leftGrad then frame.leftGrad:Kill() end
  if frame.rightGrad then frame.rightGrad:Kill() end
end

function A:UpdateCharacterStat(frame, showGradient)
  -- Kill Blizzard and ElvUI Stuff
  A:CleanupCharacterStat(frame)

  -- Set custom font gradient for label
  if frame.Label then
    F.SetFontFromDB(self.db.stats, "label", frame.Label, false)

    local labelString = F.String.StripColor(frame.Label:GetText())

    if self.db.stats.abbreviateLabels then labelString = E:ShortenString(E.TagFunctions.Abbrev(labelString), 12) end

    if self.db.stats.showIcons and self.db.stats.mode[frame.stringId] then
      if not frame.Icon then
        frame.Icon = frame:CreateFontString(nil, "OVERLAY")
        frame.Icon:SetPoint("RIGHT", frame.Label, "LEFT", 0, 0)
        frame.Icon:SetTextColor(1, 1, 1, 1)
      end

      local icon = self.db.stats.mode[frame.stringId].icon or ""

      F.SetFontFromDB(self.db.stats, "icon", frame.Icon, false)
      frame.Icon:SetText(icon)
      F.SetFontColorFromDB(self.db.stats, "icon", frame.Icon)
    else
      if frame.Icon then frame.Icon:SetText("") end
    end

    if self:UseFontGradient(self.db.stats, "label") then
      frame.Label:SetText(F.String.FastGradient(labelString, 0, 0.6, 1, 0, 0.9, 1))
    elseif self:UseFontClassGradient(self.db.stats, "label") then
      frame.Label:SetText(F.String.GradientClass(labelString, nil, true))
    else
      frame.Label:SetText(labelString)
      F.SetFontColorFromDB(self.db.stats, "label", frame.Label)
    end
  end

  local currentClass = E.myclass
  local classColorNormal = E.db.TXUI.themes.gradientMode.classColorMap[I.Enum.GradientMode.Color.NORMAL][currentClass]
  local classColorShift = E.db.TXUI.themes.gradientMode.classColorMap[I.Enum.GradientMode.Color.SHIFT][currentClass]

  -- Set custom for value
  if frame.Value then F.SetFontFromDB(self.db.stats, "value", frame.Value) end

  -- Set custom background gradient
  if frame.TXGradient then frame.TXGradient:Hide() end
  if showGradient and self.db.stats.alternatingBackgroundEnabled then
    frame.TXGradient = frame.TXGradient or frame:CreateTexture(nil, "ARTWORK")
    frame.TXGradient:SetPoint("LEFT", frame, "CENTER")
    frame.TXGradient:SetSize(90, frame:GetHeight())
    frame.TXGradient:SetTexture(E.media.blankTex)

    if self:UseFontGradient(self.db.stats, "label") then
      F.Color.SetGradientRGB(frame.TXGradient, "HORIZONTAL", 0, 0.6, 1, 0, 0, 0.9, 1, self.db.stats.alternatingBackgroundAlpha)
    elseif self:UseFontClassGradient(self.db.stats, "label") then
      F.Color.SetGradientRGB(
        frame.TXGradient,
        "HORIZONTAL",
        classColorNormal.r,
        classColorNormal.g,
        classColorNormal.b,
        0,
        classColorShift.r,
        classColorShift.g,
        classColorShift.b,
        self.db.stats.alternatingBackgroundAlpha
      )
    else
      local fontColor = F.GetFontColorFromDB(self.db.stats, "label")
      F.Color.SetGradientRGB(
        frame.TXGradient,
        "HORIZONTAL",
        fontColor.r,
        fontColor.g,
        fontColor.b,
        0,
        fontColor.r,
        fontColor.g,
        fontColor.b,
        self.db.stats.alternatingBackgroundAlpha
      )
    end

    frame.TXGradient:Show()
  end
end

function A:UpdateCharacterStats()
  if not self.frame:IsShown() then return end

  local characterStatsPane = _G.CharacterStatsPane
  local titlePane = _G.PaperDollFrame.TitleManagerPane
  local equipmentPane = _G.PaperDollFrame.EquipmentManagerPane
  local sidebarTabs = _G.PaperDollSidebarTabs
  if not characterStatsPane then return end

  -- 11.0 Fucked up the strata I guess?
  local strataFrames = { characterStatsPane, titlePane, equipmentPane, sidebarTabs }
  for _, frame in ipairs(strataFrames) do
    if frame then frame:SetFrameStrata("HIGH") end
  end

  local spec = GetSpecialization()
  local level = UnitLevel("player")
  local categoryYOffset = 0
  local statYOffset = 0
  local lastAnchor, role

  self:ClearAnimations(true)

  if spec then role = GetSpecializationRole(spec) end

  if TXUI.IsRetail then
    if level >= (MIN_PLAYER_LEVEL_FOR_ITEM_LEVEL_DISPLAY or 0) then
      self:CleanupCharacterStat(characterStatsPane.ItemLevelFrame)

      local animationSlot = self:GetAnimationSlot(true)
      self:SetupFadeAnimation(characterStatsPane.ItemLevelFrame)
      self:SetupFadeAnimation(characterStatsPane.ItemLevelCategory, animationSlot)
      self:UpdateCategoryHeader(characterStatsPane.ItemLevelCategory, animationSlot)

      characterStatsPane.ItemLevelCategory:Show()
      characterStatsPane.ItemLevelFrame:Show()
      characterStatsPane.AttributesCategory:ClearAllPoints()
      characterStatsPane.AttributesCategory:SetPoint("TOP", characterStatsPane.ItemLevelFrame, "BOTTOM", 0, 0)
    else
      characterStatsPane.ItemLevelCategory:Hide()
      characterStatsPane.ItemLevelFrame:Hide()
      characterStatsPane.AttributesCategory:ClearAllPoints()
      characterStatsPane.AttributesCategory:SetPoint("TOP", characterStatsPane, "TOP", 0, -2)
      categoryYOffset = -11
      statYOffset = -5
    end
  end

  local statFrame
  if TXUI.IsRetail then
    characterStatsPane.statsFramePool:ReleaseAll()
    statFrame = characterStatsPane.statsFramePool:Acquire()
  end
  local categories = _G.PAPERDOLL_STATCATEGORIES

  for catIndex = 1, #categories do
    local catFrame = characterStatsPane[categories[catIndex].categoryFrame]
    local animationSlot = self:GetAnimationSlot(true)
    local numStatInCat = 0
    for statIndex = 1, #categories[catIndex].stats do
      local stat = categories[catIndex].stats[statIndex]
      local hideAt = stat.hideAt
      local showStat = true
      local statMode = 1

      -- Append ID string to stat frame
      statFrame.stringId = stat.stat

      if self.db.stats.mode[stat.stat] ~= nil then
        statMode = self.db.stats.mode[stat.stat].mode
      else
        showStat = false
      end

      -- Mode 0 - Always Hide
      if showStat and (statMode == 0) then showStat = false end

      -- Mode 1 - Smart
      if showStat and (statMode == 1) then
        if showStat and (stat.primary and spec) then
          local primaryStat = select(6, GetSpecializationInfo(spec, nil, nil, nil, UnitSex("player")))

          if stat.primary ~= primaryStat then showStat = false end
        end

        if showStat and (stat.primaries and spec) then
          local primaryStat = select(6, GetSpecializationInfo(spec, nil, nil, nil, UnitSex("player")))

          local foundPrimary = false

          for _, primary in pairs(stat.primaries) do
            if primaryStat == primary then
              foundPrimary = true
              break
            end
          end

          showStat = foundPrimary
        end

        if showStat and stat.roles then
          local foundRole = false

          for _, statRole in pairs(stat.roles) do
            if role == statRole then
              foundRole = true
              break
            end
          end

          showStat = foundRole
        end

        if showStat and stat.classes then
          local foundClass = false

          for _, statClass in pairs(stat.classes) do
            if E.myclass == statClass then
              foundClass = true
              break
            end
          end

          showStat = foundClass
        end

        if showStat and stat.showFunc then showStat = stat.showFunc() end
      end

      -- Mode 2 - Always Show if not empty
      if showStat and (statMode == 2) and (hideAt == nil) then hideAt = 0 end

      -- Mode 3 - Always Show
      -- This is not needed here, just added here to make the logic more clearer
      if showStat and (statMode == 3) then showStat = true end

      if showStat and TXUI.IsRetail then
        statFrame.onEnterFunc = nil
        statFrame.UpdateTooltip = nil

        _G.PAPERDOLL_STATINFO[stat.stat].updateFunc(statFrame, "player")

        -- Mode 1/2 - Validate hideAt value in Smart Mode/Always Show if not empty mode
        if (hideAt ~= nil) and ((statMode == 1) or (statMode == 2)) then showStat = (stat.hideAt ~= statFrame.numericValue) end

        if showStat then
          if numStatInCat == 0 then
            if lastAnchor then catFrame:SetPoint("TOP", lastAnchor, "BOTTOM", 0, categoryYOffset) end

            statFrame:SetPoint("TOP", catFrame, "BOTTOM", 0, -2)
          else
            statFrame:SetPoint("TOP", lastAnchor, "BOTTOM", 0, statYOffset)
          end

          numStatInCat = numStatInCat + 1
          self:UpdateCharacterStat(statFrame, (numStatInCat % 2) == 0)
          self:SetupFadeAnimation(statFrame)

          lastAnchor = statFrame
          statFrame = characterStatsPane.statsFramePool:Acquire()
        end
      end
    end

    if TXUI.IsRetail then
      if numStatInCat > 0 then
        catFrame:Show()
        self:SetupFadeAnimation(catFrame, animationSlot)
        self:UpdateCategoryHeader(catFrame, animationSlot)
      else
        catFrame:Hide()
      end
    end
  end

  if TXUI.IsRetail then characterStatsPane.statsFramePool:Release(statFrame) end
end

function A:UpdateAttackSpeed(statFrame, unit)
  local meleeHaste = GetMeleeHaste()
  local speed, offhandSpeed = UnitAttackSpeed(unit)

  local displaySpeed = format("%.2f", speed)
  if offhandSpeed then offhandSpeed = format("%.2f", offhandSpeed) end
  if offhandSpeed then
    displaySpeed = BreakUpLargeNumbers(displaySpeed) .. " / " .. offhandSpeed
  else
    displaySpeed = BreakUpLargeNumbers(displaySpeed)
  end

  _G.PaperDollFrame_SetLabelAndText(statFrame, _G.WEAPON_SPEED, displaySpeed, false, speed)

  statFrame.tooltip = _G.HIGHLIGHT_FONT_COLOR_CODE .. format(_G.PAPERDOLLFRAME_TOOLTIP_FORMAT, _G.ATTACK_SPEED) .. " " .. displaySpeed .. _G.FONT_COLOR_CODE_CLOSE
  statFrame.tooltip2 = format(_G.STAT_ATTACK_SPEED_BASE_TOOLTIP, BreakUpLargeNumbers(meleeHaste))

  statFrame:Show()
end

function A:ApplyCustomStatCategories()
  _G.PAPERDOLL_STATCATEGORIES = {
    [1] = {
      categoryFrame = "AttributesCategory",
      stats = {
        [1] = {
          stat = "STRENGTH",
          primary = LE_UNIT_STAT_STRENGTH,
        },
        [2] = {
          stat = "AGILITY",
          primary = LE_UNIT_STAT_AGILITY,
        },
        [3] = {
          stat = "INTELLECT",
          primary = LE_UNIT_STAT_INTELLECT,
        },
        [4] = {
          stat = "STAMINA",
        },
        [5] = {
          stat = "HEALTH",
          roles = { "TANK" },
        }, -- Added
        [6] = {
          stat = "POWER",
          roles = { "HEALER" },
        }, -- Added
        [7] = {
          stat = "ARMOR",
          roles = { "TANK" },
        }, -- Modified Smart
        [8] = {
          stat = "STAGGER",
          hideAt = 0,
          roles = { "TANK" },
          classes = { "MONK" },
        }, -- Modified Smart
        [9] = {
          stat = "MANAREGEN",
          roles = { "HEALER" },
        },
        [10] = {
          stat = "ENERGY_REGEN",
          hideAt = 0,
          roles = { "TANK", "DAMAGER" },
          classes = { "ROGUE", "DRUID", "MONK" },
        }, -- Added
        [11] = {
          stat = "RUNE_REGEN",
          hideAt = 0,
          classes = { "DEATHKNIGHT" },
        }, -- Added
        [12] = {
          stat = "FOCUS_REGEN",
          hideAt = 0,
          classes = { "HUNTER" },
        }, -- Added
        [13] = {
          stat = "MOVESPEED",
          hideAt = 0,
        }, -- Added
      },
    },
    [2] = {
      categoryFrame = "EnhancementsCategory",
      stats = {
        {
          stat = "ATTACK_DAMAGE",
          hideAt = 0,
          primaries = { LE_UNIT_STAT_STRENGTH, LE_UNIT_STAT_AGILITY },
          roles = { "DAMAGER" },
        }, -- Added
        {
          stat = "ATTACK_AP",
          hideAt = 0,
          primaries = { LE_UNIT_STAT_STRENGTH, LE_UNIT_STAT_AGILITY },
          roles = { "DAMAGER" },
        }, -- Added
        {
          stat = "ATTACK_ATTACKSPEED",
          hideAt = 0,
          primaries = { LE_UNIT_STAT_STRENGTH, LE_UNIT_STAT_AGILITY },
          roles = { "DAMAGER" },
        }, -- Added
        {
          stat = "SPELLPOWER",
          hideAt = 0,
          primary = LE_UNIT_STAT_INTELLECT,
          roles = { "HEALER", "DAMAGER" },
        }, -- Added
        {
          stat = "CRITCHANCE",
          hideAt = 0,
        }, -- 1
        {
          stat = "HASTE",
          hideAt = 0,
        }, -- 2
        {
          stat = "MASTERY",
          hideAt = 0,
        }, -- 3
        {
          stat = "VERSATILITY",
          hideAt = 0,
        }, -- 4
        {
          stat = "LIFESTEAL",
          hideAt = 0,
        }, -- 5
        {
          stat = "AVOIDANCE",
          hideAt = 0,
        }, -- 6
        {
          stat = "SPEED",
          hideAt = 0,
        }, -- 7
        {
          stat = "DODGE",
          roles = { "TANK" },
        }, -- 8
        {
          stat = "PARRY",
          hideAt = 0,
          roles = { "TANK" },
        }, -- 9
        {
          stat = "BLOCK",
          hideAt = 0,
          showFunc = C_PaperDollInfo.OffhandHasShield,
        }, -- 10
      },
    },
  }
end

local isHooked = false
function A:UpdateBackground()
  if self.db.background.enabled then
    if self.db.background.hideControls then
      local controlFrame = _G.CharacterModelScene and _G.CharacterModelScene.ControlFrame
      if controlFrame and not isHooked then
        controlFrame:SetScript("OnShow", function(frame)
          frame:Hide()
        end)
        isHooked = true
      end
    end

    if self.db.background.class then
      self.frame.TXBackground.Texture:SetTexture(I.Media.Armory["ToxiUI-" .. E.myclass])
    else
      self.frame.TXBackground.Texture:SetTexture(I.Media.Armory["BG" .. self.db.background.style])
    end
    self.frame.TXBackground.Texture:SetVertexColor(1, 1, 1, self.db.background.alpha)
  else
    self.frame.TXBackground.Texture:SetTexture(nil)
    self.frame.TXBackground.Texture:SetVertexColor(0, 0, 0, 0)
  end
end

function A:UpdateLineColors()
  local orientation = "HORIZONTAL"
  local white = CreateColor(1, 1, 1, 1)

  local top = self.frame.topLine.Texture
  local bottom = self.frame.bottomLine.Texture

  -- Reset gradient
  top:SetGradient(orientation, white, white)
  bottom:SetGradient(orientation, white, white)

  if self.db.lines.enabled then
    local alpha = self.db.lines.alpha

    -- Set default white lines for Gradient
    top:SetColorTexture(1, 1, 1, alpha)
    bottom:SetColorTexture(1, 1, 1, alpha)

    if self.db.lines.color == "CLASS" then
      local classColor = E:ClassColor(E.myclass, true)
      local r, g, b = classColor.r, classColor.g, classColor.b

      top:SetColorTexture(r, g, b, alpha)
      bottom:SetColorTexture(r, g, b, alpha)
    end

    if self.db.lines.color == "GRADIENT" then
      if E.db.TXUI.themes.gradientMode.classColorMap then
        local colorMap = E.db.TXUI.themes.gradientMode.classColorMap

        local left = colorMap[1][E.myclass] -- Left (player UF)
        local right = colorMap[2][E.myclass] -- Right (player UF)

        if left and left.r and right and right.r then
          top:SetGradient(orientation, { r = left.r, g = left.g, b = left.b, a = alpha }, { r = right.r, g = right.g, b = right.b, a = alpha })
          bottom:SetGradient(orientation, { r = left.r, g = left.g, b = left.b, a = alpha }, { r = right.r, g = right.g, b = right.b, a = alpha })
        else
          TXUI:LogDebug("Armory Lines >> Left or Right gradient not found")
        end
      else
        TXUI:LogDebug("Armory Lines >> Gradient color map not found")
      end
    end
  else
    top:SetColorTexture(0, 0, 0, 0)
    bottom:SetColorTexture(0, 0, 0, 0)
  end
end

function A:UpdateLines()
  local height = self.db.lines.height

  self.frame.topLine:SetHeight(height)
  self.frame.bottomLine:SetHeight(height)

  self:UpdateLineColors()
end

function A:KillBlizzard()
  local killList = { "CharacterLevelText", "CharacterFrameTitleText", "CharacterModelFrameBackgroundOverlay" }
  for _, frame in ipairs(killList) do
    if _G[frame] then _G[frame]:Kill() end
  end

  if self.frameModel.backdrop then self.frameModel.backdrop:Kill() end

  for _, corner in pairs { "TopLeft", "TopRight", "BotLeft", "BotRight" } do
    local bg = _G["CharacterModelFrameBackground" .. corner]
    if bg then bg:Kill() end
  end

  self.frameModel:DisableDrawLayer("BACKGROUND")
  self.frameModel:DisableDrawLayer("BORDER")
  self.frameModel:DisableDrawLayer("OVERLAY")
end

function A:UpdateCharacterArmory()
  if not self.db or not self.db.enabled then return end

  self:KillBlizzard()
  self:UpdateBackground()
  self:UpdateLines()
  self:UpdateTitle()
  self:UpdatePageInfo() -- Also does :UpdateItemLevel
  self:UpdateCharacterStats()

  -- Update ElvUI Item Info instantly if frame is currently open
  if self.frame:IsShown() then E:GetModule("Misc"):UpdateCharacterInfo() end
end

function A:OpenCharacterArmory()
  self:UpdateCharacterArmory()
  -- For some reason in Mists animation doesn't happen immediately unless you hover the character frame, not sure what event we're missing
  E:Delay(0.01, function()
    self:PlayAnimations()
  end)
end

function A:CreateElements()
  if self.frame then return end

  self.frame = _G.CharacterFrame
  self.frameModel = _G.CharacterModelScene
  self.frameName = self.frame:GetName()
  self.frameHolder = CreateFrame("FRAME", nil, self.frameModel)

  self.animationObjects = {}
  self.statsObjects = {}
  self.statsCount = 1

  local background = CreateFrame("Frame", nil, self.frameHolder)
  local nameText = self.frameHolder:CreateFontString(nil, "OVERLAY")
  local titleText = self.frameHolder:CreateFontString(nil, "OVERLAY")
  local levelTitleText = self.frameHolder:CreateFontString(nil, "OVERLAY")
  local levelText = self.frameHolder:CreateFontString(nil, "OVERLAY")
  local specIcon = self.frameHolder:CreateFontString(nil, "OVERLAY")
  local classText = self.frameHolder:CreateFontString(nil, "OVERLAY")

  local frameHeight, frameWidth = self.frame:GetSize()
  local cutOffPercentage = (1 - (frameHeight / frameWidth))

  background:SetInside(self.frame)
  background:SetFrameLevel(self.frameModel:GetFrameLevel() - 1)
  background.Texture = background:CreateTexture(nil, "BACKGROUND")
  background.Texture:SetInside()
  background.Texture:SetTexCoord(0, 1, cutOffPercentage, 1)

  self.frame.TXBackground = background

  local lineHeight = E.db.TXUI.armory.lines.height or 1
  local topLine = CreateFrame("Frame", nil, self.frameHolder)
  local bottomLine = CreateFrame("Frame", nil, self.frameHolder)

  topLine:SetHeight(lineHeight)
  bottomLine:SetHeight(lineHeight)
  topLine:SetPoint("TOPLEFT", self.frame.TXBackground, "TOPLEFT", 0, 0)
  topLine:SetPoint("TOPRIGHT", self.frame.TXBackground, "TOPRIGHT", 0, 0)
  bottomLine:SetPoint("BOTTOMLEFT", self.frame.TXBackground, "BOTTOMLEFT", 0, 0)
  bottomLine:SetPoint("BOTTOMRIGHT", self.frame.TXBackground, "BOTTOMRIGHT", 0, 0)
  topLine.Texture = topLine:CreateTexture(nil, "BACKGROUND")
  bottomLine.Texture = bottomLine:CreateTexture(nil, "BACKGROUND")
  topLine.Texture:SetAllPoints()
  bottomLine.Texture:SetAllPoints()

  self.frame.topLine = topLine
  self.frame.bottomLine = bottomLine

  self:UpdateLineColors()

  self.nameText = nameText
  self.titleText = titleText
  self.levelTitleText = levelTitleText
  self.levelText = levelText
  self.specIcon = specIcon
  self.classText = classText
end

function A:ElvOptionsCheck()
  if not E.db.general.itemLevel.displayCharacterInfo then
    E.db.general.itemLevel.displayCharacterInfo = true
    E:GetModule("Misc"):ToggleItemLevelInfo(false)
    self:UpdateItemLevel()
  end
end

function A:HandleEvent(event, unit)
  if not self.frame:IsShown() then return end

  if event == "UNIT_NAME_UPDATE" then
    if unit == "player" then self:UpdateTitle() end
  elseif (event == "PLAYER_PVP_RANK_CHANGED") or (event == "PLAYER_TALENT_UPDATE") then
    self:UpdateTitle()
  elseif event == "PLAYER_AVG_ITEM_LEVEL_UPDATE" then
    self:UpdateItemLevel()
  end
end

function A:Disable()
  if not self.Initialized then return end
  if not self:IsHooked(_G, "PaperDollFrame_UpdateStats") then return end

  self:CancelAllTimers()
  self:UnhookAll()

  F.Event.UnregisterFrameEventAndCallback("UNIT_NAME_UPDATE", self)
  F.Event.UnregisterFrameEventAndCallback("PLAYER_PVP_RANK_CHANGED", self)
  F.Event.UnregisterFrameEventAndCallback("PLAYER_AVG_ITEM_LEVEL_UPDATE", self)
  F.Event.UnregisterFrameEventAndCallback("PLAYER_TALENT_UPDATE", self)
end

function A:Enable()
  if not self.Initialized then return end
  if self:IsHooked(_G, "PaperDollFrame_UpdateStats") then return end

  self:CreateElements()

  -- Hook ElvUI Overrides
  local m = E:GetModule("Misc")
  self:SecureHook(m, "UpdateCharacterInfo", F.Event.GenerateClosure(self.UpdateItemLevel, self))
  self:SecureHook(m, "UpdateAverageString", F.Event.GenerateClosure(self.UpdateItemLevel, self))
  self:SecureHook(m, "UpdatePageStrings", F.Event.GenerateClosure(self.UpdatePageStrings, self))
  self:SecureHook(m, "CreateSlotStrings", F.Event.GenerateClosure(self.UpdatePageInfo, self))
  self:SecureHook(m, "UpdateInspectPageFonts", F.Event.GenerateClosure(self.UpdatePageInfo, self))
  self:SecureHook(m, "ToggleItemLevelInfo", F.Event.GenerateClosure(self.ElvOptionsCheck, self))
  self:SecureHook(_G, "PaperDollFrame_UpdateStats", F.Event.GenerateClosure(self.UpdateCharacterStats, self))

  -- Register Events
  F.Event.RegisterFrameEventAndCallback("UNIT_NAME_UPDATE", self.HandleEvent, self, "UNIT_NAME_UPDATE")
  F.Event.RegisterFrameEventAndCallback("PLAYER_PVP_RANK_CHANGED", self.HandleEvent, self, "PLAYER_PVP_RANK_CHANGED")
  F.Event.RegisterFrameEventAndCallback("PLAYER_AVG_ITEM_LEVEL_UPDATE", self.HandleEvent, self, "PLAYER_AVG_ITEM_LEVEL_UPDATE")
  F.Event.RegisterFrameEventAndCallback("PLAYER_TALENT_UPDATE", self.HandleEvent, self, "PLAYER_TALENT_UPDATE")

  -- Hook Blizzard OnShow
  self:SecureHookScript(self.frame, "OnShow", "OpenCharacterArmory")

  -- Hook broken blizzard function
  self:RawHook(_G, "PaperDollFrame_SetAttackSpeed", "UpdateAttackSpeed", true)

  -- Apply our custom stat categories
  self:ApplyCustomStatCategories()

  -- Check ElvUI Options
  self:ElvOptionsCheck()

  -- Update instantly if frame is currently open
  if self.frame:IsShown() then self:UpdateCharacterArmory() end
end

function A:DatabaseUpdate()
  -- Set db
  self.db = F.GetDBFromPath("TXUI.armory")

  -- Enable/Disable only out of combat
  F.Event.ContinueOutOfCombat(function()
    -- Disable
    self:Disable()

    -- Enable
    if TXUI:HasRequirements(I.Requirements.Armory) and (self.db and self.db.enabled) then self:Enable() end
  end)
end

function A:Initialize()
  -- Don't init second time
  if self.Initialized then return end

  -- Register for updates
  F.Event.RegisterOnceCallback("TXUI.InitializedSafe", F.Event.GenerateClosure(self.DatabaseUpdate, self))
  F.Event.RegisterCallback("TXUI.DatabaseUpdate", self.DatabaseUpdate, self)
  F.Event.RegisterCallback("Armory.DatabaseUpdate", self.DatabaseUpdate, self)
  F.Event.RegisterCallback("Armory.SettingsUpdate", self.UpdateCharacterArmory, self)

  -- We are done, hooray!
  self.Initialized = true
end

if TXUI.IsRetail then TXUI:RegisterModule(A:GetName()) end
