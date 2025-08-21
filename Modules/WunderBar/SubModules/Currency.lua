local TXUI, F, E, _, _, P = unpack((select(2, ...)))
local WB = TXUI:GetModule("WunderBar")
local CR = WB:NewModule("Currency", "AceHook-3.0")
local DT = E:GetModule("DataTexts")
local HS = WB:GetModule("Hearthstone")

local _G = _G
local BreakUpLargeNumbers = BreakUpLargeNumbers
local C_Bank_FetchDepositedMoney = C_Bank and C_Bank.FetchDepositedMoney
local C_CurrencyInfo_GetCurrencyInfo = C_CurrencyInfo.GetCurrencyInfo
local C_Timer_NewTicker = C_Timer.NewTicker
local C_WowTokenPublic_GetCurrentMarketPrice = C_WowTokenPublic and C_WowTokenPublic.GetCurrentMarketPrice
local C_WowTokenPublic_UpdateMarketPrice = C_WowTokenPublic and C_WowTokenPublic.UpdateMarketPrice
local floor = math.floor
local format = string.format
local GetContainerNumFreeSlots = GetContainerNumFreeSlots or (C_Container and C_Container.GetContainerNumFreeSlots)
local GetCVarBool = GetCVarBool
local GetMoney = GetMoney
local ipairs = ipairs
local IsLoggedIn = IsLoggedIn
local mod = mod
local pairs = pairs
local sort = table.sort
local tinsert = table.insert
local ToggleCharacter = ToggleCharacter
local tonumber = tonumber
local unpack = unpack

local CURRENCY = CURRENCY
local NUM_BAG_SLOTS = NUM_BAG_SLOTS

function CR:OnUpdate(elapsed)
  self.updateWait = self.updateWait - elapsed
  if self.updateWait > 0 then return end

  if self.mouseOver then self:UpdateTooltip() end

  self.updateWait = 1
end

function CR:OnEvent(event)
  -- otherwise our gold is sometimes 0, what the actual fuck
  if not IsLoggedIn() then return end

  if
    (event == "ELVUI_FORCE_UPDATE")
    or (event == "PLAYER_MONEY")
    or (event == "SEND_MAIL_MONEY_CHANGED")
    or (event == "SEND_MAIL_COD_CHANGED")
    or (event == "PLAYER_TRADE_MONEY")
    or (event == "TRADE_MONEY_CHANGED")
  then
    local totalGold = GetMoney()
    local oldGold = _G.ElvDB.gold[E.myrealm][E.myname] or totalGold

    local goldChange = totalGold - oldGold
    if oldGold > totalGold then
      self.goldSpent = self.goldSpent - goldChange
    else
      self.goldProfit = self.goldProfit + goldChange
    end

    local freeBagSpace = 0

    if self.db.showBagSpace then
      for i = 0, NUM_BAG_SLOTS do
        freeBagSpace = freeBagSpace + GetContainerNumFreeSlots(i)
      end
    end

    if totalGold ~= self.totalGold or (self.db.showBagSpace and freeBagSpace ~= self.freeBagSpace) then
      _G.ElvDB.gold[E.myrealm][E.myname] = totalGold

      self.totalGold = totalGold
      self.freeBagSpace = freeBagSpace
      self:UpdateText()
      self:UpdateElements()

      if event ~= "ELVUI_FORCE_UPDATE" then
        WB:FlashFontOnEvent(self.currencyText)
        WB:FlashFontOnEvent(self.currencyIcon, true)
      end
    end
  end

  if (event == "ELVUI_FORCE_UPDATE") or (event == "CHAT_MSG_CURRENCY") or (event == "CURRENCY_DISPLAY_UPDATE") then
    self:UpdateText()
    self:UpdateElements()

    if event ~= "ELVUI_FORCE_UPDATE" then
      WB:FlashFontOnEvent(self.currencyText)
      WB:FlashFontOnEvent(self.currencyIcon, true)
    end
  end
end

function CR:DeleteCharacter(realm, name)
  _G.ElvDB.gold[realm][name] = nil
  _G.ElvDB.class[realm][name] = nil
  _G.ElvDB.faction[realm][name] = nil

  if name == E.myname and realm == E.myrealm then self:OnEvent("ELVUI_FORCE_UPDATE") end
end

function CR:LeftClick()
  ToggleAllBags()
end

function CR:ShiftRightClick()
  local menuList = {}

  tinsert(menuList, {
    text = "Delete Character",
    isTitle = true,
    notCheckable = true,
  })

  for realm in pairs(_G.ElvDB.serverID[E.serverID]) do
    for name in pairs(_G.ElvDB.gold[realm]) do
      tinsert(menuList, {
        text = format("%s - %s", name, realm),
        notCheckable = true,
        func = function()
          CR:DeleteCharacter(realm, name)
        end,
      })
    end
  end

  E:SetEasyMenuAnchor(E.EasyMenu, self.frame)
  E:ComplicatedMenu(menuList, E.EasyMenu, nil, nil, nil, "MENU")
end

function CR:CtrlRightClick()
  self.goldProfit = 0
  self.goldSpent = 0
end

function CR:RightClick()
  ToggleCharacter("TokenFrame")
end

local currencyColorTable = {
  [3290] = { color = _G.LEGENDARY_ORANGE_COLOR:GenerateHexColor(), weight = 10 }, -- Gilded Ethereal Crest
  [3288] = { color = _G.EPIC_PURPLE_COLOR:GenerateHexColor(), weight = 9 }, --        Runed Ethereal Crest
  [3286] = { color = _G.RARE_BLUE_COLOR:GenerateHexColor(), weight = 8 }, --         Carved Ethereal Crest
  [3284] = { color = _G.UNCOMMON_GREEN_COLOR:GenerateHexColor(), weight = 7 }, -- Weathered Ethereal Crest
  [3008] = { color = _G.HEIRLOOM_BLUE_COLOR:GenerateHexColor(), weight = 6 }, --                Valorstones
  [3028] = { color = _G.ARTIFACT_GOLD_COLOR:GenerateHexColor(), weight = 5 }, --        Restored Coffer Key
}

function CR:OnEnter()
  WB:SetFontAccentColor(self.currencyText)
  if self.db.showIcon then WB:SetFontAccentColor(self.currencyIcon) end

  self:UpdateTooltip()
  self.mouseOver = true
end

function CR:OnLeave()
  self.mouseOver = false
  self:UpdateFonts()
end

function CR:UpdateTooltip()
  DT.tooltip:ClearLines()
  DT.tooltip:AddLine(CURRENCY)
  DT.tooltip:AddLine(" ")

  local style = "BLIZZARD"
  DT.tooltip:AddLine("Session:")
  DT.tooltip:AddDoubleLine("Earned:", E:FormatMoney(self.goldProfit, style, true), 1, 1, 1, 1, 1, 1)
  DT.tooltip:AddDoubleLine("Spent:", E:FormatMoney(self.goldSpent, style, true), 1, 1, 1, 1, 1, 1)
  if self.goldProfit < self.goldSpent then
    DT.tooltip:AddDoubleLine("Deficit:", E:FormatMoney(self.goldProfit - self.goldSpent, style, true), 1, 0, 0, 1, 1, 1)
  elseif (self.goldProfit - self.goldSpent) > 0 then
    DT.tooltip:AddDoubleLine("Profit:", E:FormatMoney(self.goldProfit - self.goldSpent, style, true), 0, 1, 0, 1, 1, 1)
  end
  DT.tooltip:AddLine(" ")

  local totalGold, totalHorde, totalAlliance = 0, 0, 0
  DT.tooltip:AddLine("Character: ")

  local goldTable = {}
  for realm in pairs(_G.ElvDB.serverID[E.serverID]) do
    for k, _ in pairs(_G.ElvDB.gold[realm]) do
      if _G.ElvDB.gold[realm][k] then
        local color = E:ClassColor(_G.ElvDB.class[realm][k]) or {
          r = 1,
          g = 1,
          b = 1,
        }
        tinsert(goldTable, {
          name = k,
          realm = realm,
          amount = _G.ElvDB.gold[realm][k],
          amountText = E:FormatMoney(_G.ElvDB.gold[realm][k], style, true),
          faction = _G.ElvDB.faction[realm][k] or "",
          r = color.r,
          g = color.g,
          b = color.b,
        })
      end

      if _G.ElvDB.faction[realm][k] == "Alliance" then
        totalAlliance = totalAlliance + _G.ElvDB.gold[realm][k]
      elseif _G.ElvDB.faction[realm][k] == "Horde" then
        totalHorde = totalHorde + _G.ElvDB.gold[realm][k]
      end

      totalGold = totalGold + _G.ElvDB.gold[realm][k]
    end
  end

  sort(goldTable, function(a, b)
    return a.amount > b.amount
  end)

  for _, g in ipairs(goldTable) do
    local nameLine = ""
    if g.faction ~= "" and g.faction ~= "Neutral" then nameLine = format("|TInterface/FriendsFrame/PlusManz-%s:14|t ", g.faction) end

    local toonName = format("%s%s%s", nameLine, g.name, (g.realm and g.realm ~= E.myrealm and " - " .. g.realm) or "")
    DT.tooltip:AddDoubleLine((g.name == E.myname and toonName .. " |TInterface/COMMON/Indicator-Green:14|t") or toonName, g.amountText, g.r, g.g, g.b, 1, 1, 1)
  end

  DT.tooltip:AddLine(" ")
  DT.tooltip:AddLine("Server: ")
  if totalAlliance > 0 and totalHorde > 0 then
    if totalAlliance ~= 0 then DT.tooltip:AddDoubleLine("Alliance: ", E:FormatMoney(totalAlliance, style, true), 0, 0.376, 1, 1, 1, 1) end
    if totalHorde ~= 0 then DT.tooltip:AddDoubleLine("Horde: ", E:FormatMoney(totalHorde, style, true), 1, 0.2, 0.2, 1, 1, 1) end
    DT.tooltip:AddLine(" ")
  end
  DT.tooltip:AddDoubleLine("All characters: ", E:FormatMoney(totalGold, style, true), 1, 1, 1, 1, 1, 1)

  if C_Bank_FetchDepositedMoney then
    local warbandMoney = C_Bank_FetchDepositedMoney(2) -- 2 = account
    if warbandMoney then
      DT.tooltip:AddDoubleLine("Warbank: ", E:FormatMoney(warbandMoney, style, true), 1, 1, 1, 1, 1, 1)
      DT.tooltip:AddLine(" ")
      DT.tooltip:AddDoubleLine("Total: ", E:FormatMoney(warbandMoney + totalGold, style, true), 1, 1, 1, 1, 1, 1)
    end
  end
  DT.tooltip:AddLine(" ")

  local shownHeaders = {}
  local addLine = false

  local function SortCurrenciesByWeight(tooltipData, colorTable)
    local sortedData = {}
    local currentGroup = {}

    -- Iterate through each entry in tooltipData
    for _, info in ipairs(tooltipData) do
      -- Unpack the info table: currencyName, currencyIndex, headerIndex, and isHeader
      local _, currencyIndex, _, isHeader = unpack(info)

      -- Check if this entry is a header
      if isHeader then
        -- Sort the previous group (if it exists) and add it to sortedData
        if #currentGroup > 0 then
          table.sort(currentGroup, function(a, b)
            return a.weight > b.weight
          end)

          -- Add sorted group to final data
          for _, entry in ipairs(currentGroup) do
            tinsert(sortedData, entry.info)
          end

          -- Clear the group for the next set of currencies
          currentGroup = {}
        end

        -- Add the header directly to sortedData (keeping it in its original position)
        tinsert(sortedData, info)
      else
        -- If it's not a header, calculate the weight and add it to the current group
        local weight = (colorTable[currencyIndex] and colorTable[currencyIndex].weight) or 0
        tinsert(currentGroup, { info = info, weight = weight })
      end
    end

    -- Sort and add the last group (if any)
    if #currentGroup > 0 then
      table.sort(currentGroup, function(a, b)
        return a.weight > b.weight
      end)

      -- Add sorted group to final data
      for _, entry in ipairs(currentGroup) do
        tinsert(sortedData, entry.info)
      end
    end

    return sortedData
  end

  local sortedTooltipData = SortCurrenciesByWeight(E.global.datatexts.settings.Currencies.tooltipData, currencyColorTable)

  for _, data in ipairs(sortedTooltipData) do
    local _, currencyIndex, headerIndex = unpack(data)
    if currencyIndex and self.db.enabledCurrencies[currencyIndex] then
      local currencyInfo = C_CurrencyInfo_GetCurrencyInfo(currencyIndex)

      if currencyInfo then
        if not shownHeaders[headerIndex] then
          if addLine then DT.tooltip:AddLine(" ") end

          DT.tooltip:AddLine(E.global.datatexts.settings.Currencies.tooltipData[headerIndex][1])
          shownHeaders[headerIndex] = true
        end

        -- Get Icon Texture
        local iconTexture = currencyInfo.iconFileID and format("|T%s:16:16:0:0:64:64:4:60:4:60|t", currencyInfo.iconFileID) or format("|T%s:16:16:0:0:64:64:4:60:4:60|t", "136012")

        local name = currencyInfo.name
        if currencyColorTable[currencyIndex] then name = "|c" .. currencyColorTable[currencyIndex].color .. name .. "|r" end
        -- Format name
        local leftLine = format("%s %s", iconTexture, name)

        -- Format quantity
        local rightLine
        if currencyInfo.maxQuantity and currencyInfo.maxQuantity > 0 then
          rightLine = format("%s / %s", BreakUpLargeNumbers(currencyInfo.quantity), BreakUpLargeNumbers(currencyInfo.maxQuantity))
        else
          rightLine = format("%s", BreakUpLargeNumbers(currencyInfo.quantity))
        end

        -- Add to tooltip
        DT.tooltip:AddDoubleLine(leftLine, rightLine, 1, 1, 1, 1, 1, 1)

        addLine = true
      end
    end
  end

  if TXUI.IsRetail then
    if addLine then DT.tooltip:AddLine(" ") end
    DT.tooltip:AddDoubleLine("WoW Token:", E:FormatMoney(C_WowTokenPublic_GetCurrentMarketPrice() or 0, style, true), 0, 0.8, 1, 1, 1, 1)
  end

  local grayValue = E:GetModule("Bags"):GetGraysValue()
  if grayValue > 0 then
    DT.tooltip:AddLine(" ")
    DT.tooltip:AddDoubleLine("Grays", E:FormatMoney(grayValue, style, true), nil, nil, nil, 1, 1, 1)
  end

  -- Mobile Warbank cooldown
  if TXUI.IsRetail then
    local spellName = C_Spell.GetSpellName(self.warbankId)
    DT.tooltip:AddLine(" ")
    DT.tooltip:AddLine("Mobile Warbank")
    HS:AddHearthstoneLine { id = self.warbankId, name = spellName, type = "spell" }
  end

  DT.tooltip:AddLine(" ")
  DT.tooltip:AddLine("|cffFFFFFFLeft Click:|r Open Bags")
  DT.tooltip:AddLine("|cffFFFFFFRight Click:|r Open Currency Frame")
  if TXUI.IsRetail then DT.tooltip:AddLine("|cffFFFFFFShift + Left Click:|r Summon Mobile Warbank") end
  DT.tooltip:AddLine("|cffFFFFFFCtrl + Right Click:|r Reset Session Data")
  DT.tooltip:AddLine("|cffFFFFFFShift + Right Click:|r Reset Character Data")
  DT.tooltip:Show()
end

function CR:OnWunderBarUpdate()
  self:UpdateFonts()
  self:UpdateText()
  self:UpdateElements()
end

function CR:UpdateFonts()
  WB:SetFontFromDB(nil, nil, self.currencyText)
  WB:SetIconFromDB(self.db, "icon", self.currencyIcon)
end

function CR:UpdateText()
  local currencyString, currencyIndex = "", nil
  local colorGold, colorSilver, colorCopper = "|cffffd700", "|cffc7c7cf", "|cffeda55f"

  local colorGoldType = function(s, c)
    return self.db.useGoldColors and format("%s%s|r", c, s) or s
  end

  if self.db.displayedCurrency ~= "GOLD" then
    currencyIndex = tonumber(self.db.displayedCurrency)
    if not currencyIndex then self.db.displayedCurrency = P.wunderbar.subModules.Currency.displayedCurrency end
  end

  if self.db.displayedCurrency == "GOLD" then
    local gold = floor(self.totalGold / 10000)
    local silver = floor(mod(self.totalGold / 100, 100))
    local copper = floor(mod(self.totalGold, 100))

    if gold > 0 then
      currencyString = format("%s%s%s", BreakUpLargeNumbers(gold), colorGoldType("g", colorGold), (self.db.showSmall and (silver > 0 or copper > 0)) and " " or "")
    end

    if gold <= 0 or self.db.showSmall then
      if silver > 0 then currencyString = format("%s%d%s%s", currencyString, silver, colorGoldType("s", colorSilver), copper > 0 and " " or "") end
      if copper > 0 or self.totalGold == 0 then currencyString = format("%s%d%s", currencyString, copper, colorGoldType("c", colorCopper)) end
    end
  else
    local currencyInfo = C_CurrencyInfo_GetCurrencyInfo(currencyIndex)
    currencyString = format("%s %s", E:AbbreviateString(currencyInfo.name), E:ShortValue(currencyInfo.quantity))
  end

  if currencyString == "" then currencyString = "0" .. colorGoldType("c", colorCopper) end
  if self.db.showBagSpace then currencyString = currencyString .. " (" .. self.freeBagSpace .. ")" end

  self.currencyText:SetText(currencyString)
  self.currencyIcon:SetText(self.db.icon)
end

function CR:UpdateElements()
  local anchorPoint = WB:GetGrowDirection(self.Module, true)
  local iconSize = self.db.showIcon and self.db.iconFontSize or 1

  self.currencyText:ClearAllPoints()
  self.currencyIcon:ClearAllPoints()
  self.currencyIcon:SetJustifyH("RIGHT")

  if anchorPoint == "RIGHT" then
    self.currencyText:SetJustifyH("RIGHT")
    self.currencyText:SetPoint("RIGHT", self.frame, "RIGHT", 0, 0)
  else
    self.currencyText:SetJustifyH("LEFT")
    self.currencyText:SetPoint("LEFT", self.frame, "LEFT", (iconSize + 5), 0)
  end

  self.currencyIcon:SetPoint("RIGHT", self.currencyText, "LEFT", -5, 3)

  if self.db.showIcon then
    self.currencyIcon:Show()
  else
    self.currencyIcon:Hide()
  end
end

function CR:CreateText()
  local secureFrameHolder = CreateFrame("Button", nil, self.frame, "SecureActionButtonTemplate")
  secureFrameHolder:ClearAllPoints()
  secureFrameHolder:SetAllPoints()
  secureFrameHolder:EnableMouse(true)
  secureFrameHolder:RegisterForClicks(GetCVarBool("ActionButtonUseKeyDown") and "AnyDown" or "AnyUp")

  self:HookScript(secureFrameHolder, "OnEnter", function(...)
    WB:ModuleOnEnter(self, ...)
  end)

  self:HookScript(secureFrameHolder, "OnLeave", function(...)
    WB:ModuleOnLeave(self, ...)
  end)

  self.secureFrame = secureFrameHolder

  if TXUI.IsRetail then
    local spellName = C_Spell.GetSpellName(self.warbankId)
    self.secureFrame:SetAttribute("shift-type1", "spell")
    self.secureFrame:SetAttribute("shift-spell1", spellName)
  end

  self.secureFrame:SetAttribute("type1", "function")
  self.secureFrame:SetAttribute("_function1", function()
    self:LeftClick()
  end)
  self.secureFrame:SetAttribute("type2", "function")
  self.secureFrame:SetAttribute("_function2", function()
    self:RightClick()
  end)
  self.secureFrame:SetAttribute("shift-type2", "function")
  self.secureFrame:SetAttribute("shift-_function2", function()
    self:ShiftRightClick()
  end)
  self.secureFrame:SetAttribute("ctrl-type2", "function")
  self.secureFrame:SetAttribute("ctrl-_function2", function()
    self:CtrlRightClick()
  end)

  local currencyText = secureFrameHolder:CreateFontString(nil, "OVERLAY")
  local currencyIcon = secureFrameHolder:CreateFontString(nil, "OVERLAY")
  currencyText.cooldownText = secureFrameHolder:CreateFontString(nil, "OVERLAY")

  currencyText:SetPoint("CENTER")
  currencyIcon:SetPoint("CENTER")

  self.currencyText = currencyText
  self.currencyIcon = currencyIcon
end

function CR:CreateElvUIDB()
  _G.ElvDB = _G.ElvDB or {}

  _G.ElvDB.gold = _G.ElvDB.gold or {}
  _G.ElvDB.gold[E.myrealm] = _G.ElvDB.gold[E.myrealm] or {}

  _G.ElvDB.class = _G.ElvDB.class or {}
  _G.ElvDB.class[E.myrealm] = _G.ElvDB.class[E.myrealm] or {}
  _G.ElvDB.class[E.myrealm][E.myname] = E.myclass

  _G.ElvDB.faction = _G.ElvDB.faction or {}
  _G.ElvDB.faction[E.myrealm] = _G.ElvDB.faction[E.myrealm] or {}
  _G.ElvDB.faction[E.myrealm][E.myname] = E.myfaction

  _G.ElvDB.serverID = _G.ElvDB.serverID or {}
  _G.ElvDB.serverID[E.serverID] = _G.ElvDB.serverID[E.serverID] or {}
  _G.ElvDB.serverID[E.serverID][E.myrealm] = true
end

function CR:OnInit()
  -- Get our settings DB
  self.db = WB:GetSubModuleDB(self:GetName())

  -- Don't init second time
  if self.Initialized then return end

  -- Vars
  self.frame = self.SubModuleHolder
  self.goldProfit = 0
  self.goldSpent = 0
  self.totalGold = 0
  self.freeBagSpace = 0
  self.warbankId = 460905
  self.updateWait = 0
  self.mouseOver = false

  -- Create ElvDB for this toon
  self:CreateElvUIDB()

  -- Create Token Ticker
  if not TXUI.IsVanilla then
    self.tokenCallback = F.Event.GenerateClosure(C_WowTokenPublic_UpdateMarketPrice)
    self.tokenTicker = C_Timer_NewTicker(60, self.tokenCallback)
    self.tokenCallback()
  end

  self:CreateText()
  self:OnWunderBarUpdate()

  -- We are done, hooray!
  self.Initialized = true
end

WB:RegisterSubModule(CR, {
  "PLAYER_MONEY",
  "SEND_MAIL_MONEY_CHANGED",
  "SEND_MAIL_COD_CHANGED",
  "PLAYER_TRADE_MONEY",
  "TRADE_MONEY_CHANGED",
  "CHAT_MSG_CURRENCY",
  "CURRENCY_DISPLAY_UPDATE",
})
