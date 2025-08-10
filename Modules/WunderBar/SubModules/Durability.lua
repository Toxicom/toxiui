local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local WB = TXUI:GetModule("WunderBar")
local DB = WB:NewModule("Durability")
local DT = E:GetModule("DataTexts")

local _G = _G
local floor = math.floor
local format = string.format
local GetAverageItemLevel = GetAverageItemLevel
local GetInventoryItemDurability = GetInventoryItemDurability
local GetInventoryItemLink = GetInventoryItemLink
local GetInventoryItemTexture = GetInventoryItemTexture
local GetItemInfo = GetItemInfo
local GetMoneyString = GetMoneyString
local max = math.max
local min = math.min
local pairs = pairs
local select = select
local unpack = unpack
local wipe = table.wipe

local REPAIR_COST = _G.REPAIR_COST
local DURABILITY = _G.DURABILITY

local slots = {
  [1] = _G.INVTYPE_HEAD,
  [3] = _G.INVTYPE_SHOULDER,
  [5] = _G.INVTYPE_CHEST,
  [6] = _G.INVTYPE_WAIST,
  [7] = _G.INVTYPE_LEGS,
  [8] = _G.INVTYPE_FEET,
  [9] = _G.INVTYPE_WRIST,
  [10] = _G.INVTYPE_HAND,
  [16] = _G.INVTYPE_WEAPONMAINHAND,
  [17] = _G.INVTYPE_WEAPONOFFHAND,
}

function DB:OnEvent(event)
  -- Update only ilvl display
  if event == "PLAYER_AVG_ITEM_LEVEL_UPDATE" then
    self:UpdateText()
    return
  end

  -- Don't update if update is queued
  if self.updateNextOutOfCombat then return end
  self.updateNextOutOfCombat = true

  F.Event.ContinueOutOfCombat(function()
    self.updateNextOutOfCombat = false
    local totalDurability = 100
    local totalRepairCost = 0

    wipe(self.invDurability)
    wipe(self.invItemLevel)

    for index in pairs(slots) do
      local currentDura, maxDura = GetInventoryItemDurability(index)
      if currentDura and maxDura and maxDura > 0 then
        -- Populate percentage for tooltip
        local perc = (currentDura / maxDura) * 100
        local repairCost

        self.invDurability[index] = perc

        -- Update lowest durability
        if perc < totalDurability then totalDurability = perc end

        -- Add repair costs for tooltip
        if TXUI.IsRetail and E.ScanTooltip:GetTooltipData() then
          E.ScanTooltip:SetInventoryItem("player", index)
          E.ScanTooltip:Show()

          local tooltipData = E.ScanTooltip:GetTooltipData()
          repairCost = tooltipData and tooltipData.repairCost or 0
        else
          repairCost = select(3, E.ScanTooltip:SetInventoryItem("player", index)) or 0
        end

        totalRepairCost = totalRepairCost + repairCost

        -- Get item level if enabled (for Wrath we use UpdateAverageItemLevel)
        if TXUI.IsRetail and self.db.showItemLevel then
          local slotInfo = E:GetGearSlotInfo("player", index)

          if slotInfo == "tooSoon" then
            self.invItemLevel[index] = 0
          else
            self.invItemLevel[index] = slotInfo.iLvl
          end
        end
      end
    end

    totalDurability = E:Round(totalDurability)
    self.totalRepairCost = totalRepairCost

    local itemLevelChanged = self:UpdateAverageItemLevel()

    if itemLevelChanged or totalDurability ~= self.totalDurability then
      self.totalDurability = totalDurability
      self:UpdateText()
      self:UpdateColor()
      self:UpdateElements()
    end
  end)
end

function DB:OnClick(...)
  local _, key = ...

  if key == "LeftButton" then
    local dtModule = WB:GetElvUIDataText("Durability")
    if dtModule then dtModule.onClick(...) end
  end

  if key == "RightButton" and (C_MountJournal and C_MountJournal.GetMountInfoByID) then
    local mountID = self.db.repairMount
    if mountID then
      local _, _, _, _, isUsable = C_MountJournal.GetMountInfoByID(mountID)
      if isUsable then C_MountJournal.SummonByID(mountID) end
    end
  end
end

function DB:OnEnter()
  WB:SetFontAccentColor(self.durabilityText)
  if self.db.showIcon then WB:SetFontAccentColor(self.durabilityIcon) end

  if self.db.showItemLevel then
    local equippedPercent = min(1, max(1, self.avgItemLevel) / max(1, self.avgItemLevelEquipped))
    local equippedColors = { F.SlowColorGradient(equippedPercent, 1, 0.1, 0.1, 1, 1, 0.1, 0.1, 1, 0.1) }

    DT.tooltip:AddLine("Item Level")
    DT.tooltip:AddLine(" ")
    DT.tooltip:AddDoubleLine("Average Item Level", format("%0.2f", E:Round(self.avgItemLevel, 2)), 1, 1, 1, 0.1, 1, 0.1)
    DT.tooltip:AddDoubleLine("Equipped Item Level", format("%0.2f", E:Round(self.avgItemLevelEquipped, 2)), 1, 1, 1, unpack(equippedColors))
    DT.tooltip:AddLine(" ")
  end

  DT.tooltip:AddLine(DURABILITY)
  DT.tooltip:AddLine(" ")

  for slot, durability in pairs(self.invDurability) do
    local iLvLText = (self.db.showItemLevel and self.invItemLevel[slot] and self.invItemLevel[slot] ~= 0) and format(" |cffffffff[%s]|r", self.invItemLevel[slot]) or ""

    DT.tooltip:AddDoubleLine(
      format("|T%s:14:14:0:0:64:64:4:60:4:60|t  %s%s", GetInventoryItemTexture("player", slot), GetInventoryItemLink("player", slot), iLvLText),
      format("%d%%", durability),
      1,
      1,
      1,
      F.SlowColorGradient(durability * 0.01, 1, 0.1, 0.1, 1, 1, 0.1, 0.1, 1, 0.1)
    )
  end

  if self.totalRepairCost > 0 then
    DT.tooltip:AddLine(" ")
    DT.tooltip:AddDoubleLine(REPAIR_COST, GetMoneyString(self.totalRepairCost), 0.6, 0.8, 1, 1, 1, 1)
  end

  DT.tooltip:AddLine(" ")
  DT.tooltip:AddLine("|cffFFFFFFLeft Click:|r Open Character Frame")
  if C_MountJournal and C_MountJournal.GetMountInfoByID then
    local mountID = self.db.repairMount
    if mountID then
      local name, _, icon, _, isUsable = C_MountJournal.GetMountInfoByID(mountID)
      local iconStr = icon and format("|T%s:16:16:0:0:50:50:4:46:4:46|t", icon) or ""
      if name and isUsable then DT.tooltip:AddLine("|cffFFFFFFRight Click:|r Summon " .. iconStr .. name) end
    end
  end

  DT.tooltip:Show()
end

function DB:OnLeave()
  self:UpdateColor()
end

function DB:OnWunderBarUpdate()
  self:UpdateFonts()
  self:UpdateText()
  self:UpdateColor()
  self:UpdateElements()
end

function DB:UpdateColor()
  if self.db.animateLow and self.totalDurability <= self.db.animateThreshold then
    WB:StartColorFlash(self.durabilityText, 1, WB:GetFontNormalColor(), WB:GetFontAccentColor())
    WB:StartColorFlash(self.durabilityIcon, 1, WB:GetFontIconColor(), WB:GetFontAccentColor())
    return
  end

  local textR, textG, textB, textA
  local iconR, iconG, iconB, iconA

  if (self.db.iconColor or self.db.textColor) and not self.db.textColorFadeFromNormal then
    textR, textG, textB = F.SlowColorGradient(self.totalDurability * 0.01, 1, 0.1, 0.1, 1, 1, 0.1, 0.1, 1, 0.1)
    iconR, iconG, iconB = textR, textG, textB

    textA = WB:GetFontNormalColor().a
    iconA = WB:GetFontIconColor().a
  end

  if self.db.textColor and self.db.textColorFadeFromNormal then
    local fontColor = WB:GetFontNormalColor()
    textA = fontColor.a
    textR, textG, textB = F.SlowColorGradient(self.totalDurability * 0.01, 1, 0.1, 0.1, 1, 1, 0.1, fontColor.r, fontColor.g, fontColor.b)
  end

  if self.db.iconColor and self.db.textColorFadeFromNormal then
    local fontColor = WB:GetFontIconColor()
    iconA = fontColor.a
    iconR, iconG, iconB = F.SlowColorGradient(self.totalDurability * 0.01, 1, 0.1, 0.1, 1, 1, 0.1, fontColor.r, fontColor.g, fontColor.b)
  end

  if self.db.textColor then
    WB:SetFontColor(self.durabilityText, {
      r = textR,
      g = textG,
      b = textB,
      a = textA,
    })
  else
    WB:SetFontNormalColor(self.durabilityText)
  end

  if self.db.iconColor then
    WB:SetFontColor(self.durabilityIcon, {
      r = iconR,
      g = iconG,
      b = iconB,
      a = iconA,
    })
  else
    WB:SetFontIconColor(self.durabilityIcon)
  end
end

function DB:UpdateFonts()
  WB:SetFontFromDB(nil, nil, self.durabilityText)
  WB:SetIconFromDB(self.db, "icon", self.durabilityIcon)
end

function DB:UpdateAverageItemLevel()
  if TXUI.IsRetail or TXUI.IsMists then
    local avgItemLevel, avgItemLevelEquipped = GetAverageItemLevel()

    if avgItemLevel ~= self.avgItemLevel or avgItemLevelEquipped ~= self.avgItemLevelEquipped then
      self.avgItemLevel = avgItemLevel
      self.avgItemLevelEquipped = avgItemLevelEquipped
      return true
    end
  else
    local levelTotal, itemCountAvg, itemCountEquipped, excludeOffHand = 0, 0, 0, false

    for i = 1, 18 do
      if i ~= 4 then -- no shirts
        local itemLink = GetInventoryItemLink("player", i)
        if itemLink then
          local itemLevel, _, _, _, _, itemEquipLoc = select(4, GetItemInfo(itemLink))
          if not itemLevel then itemLevel = 0 end

          -- We can't equip offhands, so don't add it to the avg
          if i == 16 and (itemEquipLoc and itemEquipLoc == "INVTYPE_2HWEAPON") then -- INVSLOT_MAINHAND
            excludeOffHand = true
          end

          -- Edge Case: Titan Grip
          if i == 17 and (itemEquipLoc and itemEquipLoc == "INVTYPE_2HWEAPON") then -- INVSLOT_OFFHAND
            excludeOffHand = false
          end

          itemCountAvg = itemCountAvg + 1
          itemCountEquipped = itemCountEquipped + 1
          levelTotal = levelTotal + itemLevel
          self.invItemLevel[i] = itemLevel
        else
          itemCountEquipped = itemCountEquipped + 1
          self.invItemLevel[i] = 0
        end
      end
    end

    if excludeOffHand then itemCountEquipped = itemCountEquipped - 1 end
    local avgItemLevel, avgItemLevelEquipped = levelTotal / (itemCountAvg or 1), levelTotal / (itemCountEquipped or 1)

    if avgItemLevel ~= self.avgItemLevel or avgItemLevelEquipped ~= self.avgItemLevelEquipped then
      self.avgItemLevel = avgItemLevel
      self.avgItemLevelEquipped = avgItemLevelEquipped
      return true
    end
  end

  return false
end

function DB:UpdateText()
  local iLvLText = ""

  if self.db.showItemLevel then
    local displayItemLevel

    if self.db.itemLevelShort then
      displayItemLevel = format("%0.f", floor(max(0, self.avgItemLevelEquipped)))
    else
      displayItemLevel = format("%0.2f", E:Round(self.avgItemLevelEquipped, 2))
    end

    iLvLText = format(" (%s)", displayItemLevel)
  end

  self.durabilityText:SetText(format("%s%%%s", self.totalDurability, iLvLText))
  self.durabilityIcon:SetText(self.db.icon)
end

function DB:UpdateElements()
  local anchorPoint = WB:GetGrowDirection(self.Module, true)
  local iconSize = self.db.showIcon and self.db.iconFontSize or 1

  self.durabilityText:ClearAllPoints()
  self.durabilityIcon:ClearAllPoints()
  self.durabilityIcon:SetJustifyH("RIGHT")

  if anchorPoint == "RIGHT" then
    self.durabilityText:SetJustifyH("RIGHT")
    self.durabilityText:SetPoint("RIGHT", self.frame, "RIGHT", 0, 0)
  else
    self.durabilityText:SetJustifyH("LEFT")
    self.durabilityText:SetPoint("LEFT", self.frame, "LEFT", (iconSize + 5), 0)
  end

  self.durabilityIcon:SetPoint("RIGHT", self.durabilityText, "LEFT", -5, 0)

  if self.db.showIcon then
    self.durabilityIcon:Show()
  else
    self.durabilityIcon:Hide()
  end
end

function DB:CreateText()
  local durabilityText = self.frame:CreateFontString(nil, "OVERLAY")
  local durabilityIcon = self.frame:CreateFontString(nil, "OVERLAY")

  durabilityText:SetPoint("CENTER")
  durabilityIcon:SetPoint("CENTER")

  self.durabilityText = durabilityText
  self.durabilityIcon = durabilityIcon
end

function DB:OnInit()
  -- Get our settings DB
  self.db = WB:GetSubModuleDB(self:GetName())

  -- Don't init second time
  if self.Initialized then return end

  -- Vars
  self.frame = self.SubModuleHolder
  self.updateNextOutOfCombat = false
  self.totalDurability = 0
  self.totalRepairCost = 0
  self.avgItemLevel = 0
  self.avgItemLevelEquipped = 0
  self.invDurability = {}
  self.invItemLevel = {}

  self:CreateText()
  self:OnWunderBarUpdate()

  -- We are done, hooray!
  self.Initialized = true
end

WB:RegisterSubModule(
  DB,
  F.Table.Join({
    "UPDATE_INVENTORY_DURABILITY",
    "MERCHANT_SHOW",
  }, F.Table.If(TXUI.IsRetail, { "PLAYER_AVG_ITEM_LEVEL_UPDATE" }), F.Table.If(TXUI.IsMists, { "PLAYER_EQUIPMENT_CHANGED" }))
)
