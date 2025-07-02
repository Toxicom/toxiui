local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local WB = TXUI:GetModule("WunderBar")
local HS = WB:NewModule("Hearthstone", "AceHook-3.0")
local DT = E:GetModule("DataTexts")

local CreateFrame = CreateFrame
local floor = math.floor
local format = string.format
local GetBindLocation = GetBindLocation
local GetCVarBool = GetCVarBool
local GetItemCooldownFunction = C_Container.GetItemCooldown
local GetItemCount = GetItemCount
local GetItemIcon = GetItemIcon
local GetSpellCooldown = (C_Spell and C_Spell.GetSpellCooldown) or GetSpellCooldown
local GetSpellTexture = (C_Spell and C_Spell.GetSpellTexture) or GetSpellTexture
local GetTime = GetTime
local mod = mod
local pairs = pairs
local tinsert = table.insert

local triggerLoadFinished = false
function HS:OnUpdate(elapsed)
  self.updateWait = self.updateWait - elapsed
  if self.updateWait > 0 then return end

  if self.dataLoaded then
    if self.db.cooldownEnabled then self:UpdateCooldownText() end
    if self.mouseOver then self:UpdateTooltip() end
  elseif self.dataLoaded ~= I.HearthstoneDataLoaded and not triggerLoadFinished then
    triggerLoadFinished = true
    self:OnWunderBarUpdate()
  end

  self.updateWait = 1
end

function HS:OnEvent()
  self:OnWunderBarUpdate()
end

function HS:GetCooldownForItem(itemInfo)
  -- Check if everything is loaded
  if not self.dataLoaded then return end

  if not itemInfo or not itemInfo.id then return self:LogDebug("HS:GetCooldownForItem > Item could not be found in DB") end

  local _, gcd
  if TXUI.IsVanilla then
    _, gcd = GetSpellCooldown(61304)
  else
    gcd = GetSpellCooldown(61304)
    gcd = gcd and gcd.duration or nil
  end
  if gcd == nil then return self:LogDebug("HS:GetCooldownForItem > GetSpellCooldown returned nil for gcd") end

  local startTime, duration

  if (itemInfo.type == "toy") or (itemInfo.type == "item") then
    startTime, duration = GetItemCooldownFunction(itemInfo.id)
  elseif itemInfo.type == "spell" then
    if TXUI.IsVanilla then
      startTime, duration = GetSpellCooldown(itemInfo.id)
    else
      local cd = GetSpellCooldown(itemInfo.id)
      startTime, duration = cd.startTime, cd.duration
    end
  end

  if startTime == nil or duration == nil then return self:LogDebug("HS:GetCooldownForItem > GetItemCooldown returned nil for item") end

  local cooldownTime = startTime + duration - GetTime()
  local ready = (duration - gcd <= 0) or cooldownTime <= 0

  if not ready then
    local min = floor(cooldownTime / 60)
    local sec = floor(mod(cooldownTime, 60))
    return false, format("%02d:%02d", min, sec)
  end

  return true, "Ready"
end

function HS:AddHearthstoneLine(itemInfo)
  -- Check if everything is loaded
  if not self.dataLoaded then return end

  if not itemInfo or not itemInfo.id then return self:LogDebug("HS:AddHearthstoneLine > Item could not be found in DB") end

  local name = format(itemInfo.name)
  local texture = (itemInfo.type == "spell") and GetSpellTexture(itemInfo.id) or GetItemIcon(itemInfo.id)

  -- Debug
  if texture == nil or texture == "" then return self:LogDebug("HS:AddHearthstoneLine > GetItemIcon returned nil") end

  -- Get cooldown
  local ready, readyString = self:GetCooldownForItem(itemInfo)

  -- maw cypher
  if itemInfo.id == 180817 then
    local charge = GetItemCount(itemInfo.id, nil, true)
    name = name .. format(" (%d)", charge)
  end

  -- Good format blizzard, there was no easier way
  local icon = format("|T%s:16:18:0:0:64:64:4:60:7:57:255:255:255|t ", texture)
  DT.tooltip:AddDoubleLine(icon .. name, readyString, 1, 1, 1, ready and 0 or 1, ready and 1 or 0, 0)
end

function HS:GetClassTeleport()
  for _, option in pairs(I.HearthstoneData) do
    if option.known and (option.class and option.class == E.myclass) then return option end
  end

  return {}
end

function HS:GetMythicPortals()
  if not TXUI.IsRetail then return nil end

  local portals = {}

  for _, option in pairs(I.HearthstoneData) do
    if self.db.seasonMythics then
      if option.known and option.mythic and option.season == TXUI.RetailSeason then
        option.spellID = option.id
        option.type = "spell"
        tinsert(portals, option)
      end
    elseif option.known and option.mythic then
      option.spellID = option.id
      option.type = "spell"
      tinsert(portals, option)
    end
  end

  return portals
end

function HS:GetCovenantStone(hs)
  local covenant = F.GetCachedCovenant(true)

  if hs.covenant ~= covenant then
    for _, option in pairs(I.HearthstoneData) do
      if option.known and (option.covenant and option.covenant == covenant) then
        self:LogDebug("HS:GetCovenantStone > Replaced stone", hs.covenant, option.covenant)
        return option
      end
    end
  end

  return hs
end

function HS:GetMagePortals()
  local teleportList = {}
  local portalList = {}

  for _, option in F.Table.Sort(I.HearthstoneData) do
    if option.known then -- Show Only Known
      if option.teleport then
        tinsert(teleportList, { spellID = option.id, type = "spell", label = option.label, mage = true })
      elseif option.portal then
        tinsert(portalList, { spellID = option.id, type = "spell", label = option.label, mage = true })
      end
    end
  end

  WB:ShowSecureFlyOut(self.frame, self.flyoutDirection, teleportList, portalList)
end

function HS:UpdateSelected()
  -- Check if everything is loaded
  if not self.dataLoaded then return end

  -- Check if spell is in DB
  self.hsPrimary = I.HearthstoneData[self.db.primaryHS] or I.HearthstoneData[P.wunderbar.subModules.Hearthstone.primaryHS]
  if not self.hsPrimary then return self:LogDebug("HS:UpdateSelected > Item could not be found in DB for hsPrimary") end

  -- Check if spell is in DB
  self.hsSecondary = I.HearthstoneData[self.db.secondaryHS] or I.HearthstoneData[P.wunderbar.subModules.Hearthstone.secondaryHS]
  if not self.hsSecondary then return self:LogDebug("HS:UpdateSelected > Item could not be found in DB for hsSecondary") end

  -- Check if any ids could be found
  if not self.hsPrimary.id or not self.hsSecondary.id then return self:LogDebug("HS:UpdateSelected > Main IDs and Fallback could not be found") end

  -- If covenant hearthstone is selected, be smart and replace it with current covenant
  if self.hsPrimary.covenant then self.hsPrimary = self:GetCovenantStone(self.hsPrimary) end
  if self.hsSecondary.covenant then self.hsSecondary = self:GetCovenantStone(self.hsSecondary) end

  -- Fallback to default if spell is not known
  if not self.hsPrimary.known then self.hsPrimary = I.HearthstoneData[P.wunderbar.subModules.Hearthstone.primaryHS] end

  -- Fallback to default if spell is not known
  if not self.hsSecondary.known then self.hsSecondary = I.HearthstoneData[P.wunderbar.subModules.Hearthstone.secondaryHS] end

  if self.db.randomPrimaryHs then
    local idTable = {}
    local covenantHsIds = { [180290] = true, [184353] = true, [183716] = true, [182773] = true }
    for _, option in pairs(I.HearthstoneData) do
      if option.known then
        if not option.class and option.hearthstone and not covenantHsIds[option.id] then tinsert(idTable, option.id) end
      end
    end

    if not F.Table.IsEmpty(idTable) then
      local rngIndex = math.random(1, #idTable)
      local randomId = idTable[rngIndex]
      local hs = I.HearthstoneData[randomId]
      if not F.Table.IsEmpty(hs) then self.hsPrimary = hs end
    end
  end

  -- Get class teleport for non mages
  if E.myclass ~= "MAGE" then self.hsClass = self:GetClassTeleport() end
  self.hsMythics = self:GetMythicPortals()

  -- Set Types
  self.secureFrame:SetAttribute("type1", self.hsPrimary.type)
  if F.IsAddOnEnabled("TomeOfTeleportation") then
    self.secureFrame:SetAttribute("type2", "function")
    self.secureFrame:SetAttribute("_function2", function()
      _G.TeleporterSlashCmdFunction()
    end)
  else
    self.secureFrame:SetAttribute("type2", self.hsSecondary.type)
  end

  if self.hsMythics and not F.Table.IsEmpty(self.hsMythics) then
    self.secureFrame:SetAttribute("shift-type1", "function")
    self.secureFrame:SetAttribute("shift-_function1", function()
      WB:ShowSecureFlyOut(self.frame, self.flyoutDirection, self.hsMythics)
    end)
  end

  -- Set Type IDs
  self.secureFrame:SetAttribute(self.hsPrimary.type .. "1", self.hsPrimary.name)
  self.secureFrame:SetAttribute(self.hsSecondary.type .. "2", self.hsSecondary.name)

  -- Class spells
  if self.hsClass.name then
    self.secureFrame:SetAttribute("shift-type2", self.hsClass.type)
    self.secureFrame:SetAttribute("shift-" .. self.hsClass.type .. "2", self.hsClass.name)
  end

  -- Mage Love <3
  if E.myclass == "MAGE" then
    self.hasTeleports = true

    -- Portal & Teleport
    self.secureFrame:SetAttribute("shift-type2", "function")
    self.secureFrame:SetAttribute("shift-_function2", function()
      self:GetMagePortals()
    end)
  end
end

function HS:UpdateTooltip()
  -- Check if everything is loaded
  if not self.dataLoaded then return end

  DT.tooltip:ClearLines()
  DT.tooltip:SetText("Hearthstone")
  DT.tooltip:AddLine(" ")

  self:AddHearthstoneLine(self.hsPrimary)
  if self.hsPrimary ~= self.hsSecondary and not F.IsAddOnEnabled("TomeOfTeleportation") then self:AddHearthstoneLine(self.hsSecondary) end

  DT.tooltip:AddLine(" ")

  local additionalAdded = false
  for index, enabled in pairs(self.db.additionalHS) do
    if enabled then
      local data = I.HearthstoneData[index]
      if data and data.known and not data.hearthstone and not data.class and not data.portal and not data.teleport then
        if not additionalAdded then
          DT.tooltip:AddLine("Additional")
          DT.tooltip:AddLine(" ")
        end
        self:AddHearthstoneLine(data)
        additionalAdded = true
      end
    end
  end

  if additionalAdded then DT.tooltip:AddLine(" ") end

  local classAdded = false
  if self.hsClass.name then
    DT.tooltip:AddLine("Class")
    DT.tooltip:AddLine(" ")
    self:AddHearthstoneLine(self.hsClass)
    DT.tooltip:AddLine(" ")
    classAdded = true
  end

  -- Primary
  if self.hsPrimary and self.hsPrimary.name then DT.tooltip:AddLine("|cffFFFFFFLeft Click:|r Cast " .. self.hsPrimary.name) end

  -- Secondary
  if F.IsAddOnEnabled("TomeOfTeleportation") then
    DT.tooltip:AddLine("|cffFFFFFFRight Click:|r Toggle Tome of Teleporation")
  elseif self.hsSecondary and self.hsSecondary.name then
    DT.tooltip:AddLine("|cffFFFFFFRight Click:|r Cast " .. self.hsSecondary.name)
  end

  -- Shift-Primary for Mythic+ Teleports
  if (self.hsMythics and not F.Table.IsEmpty(self.hsMythics)) and TXUI.IsRetail then DT.tooltip:AddLine("|cffFFFFFFShift-Left Click:|r Open Mythic+ Teleports Menu") end

  -- Shift-Secondary for Class Travel other than Mages
  if classAdded then DT.tooltip:AddLine("|cffFFFFFFShift-Right Click:|r Cast " .. self.hsClass.name) end

  -- Shift-Secondary for Mages
  if self.hasTeleports then DT.tooltip:AddLine("|cffFFFFFFShift-Right Click:|r Open Mage Teleport Menu") end

  DT.tooltip:Show()
end

function HS:OnEnter()
  WB:SetFontAccentColor(self.hearthstoneText)
  if self.db.showIcon then WB:SetFontAccentColor(self.hearthstoneIcon) end

  self:UpdateTooltip()
  self.mouseOver = true
end

function HS:OnLeave()
  self.mouseOver = false

  WB:SetFontNormalColor(self.hearthstoneText)
  if self.db.showIcon then WB:SetFontIconColor(self.hearthstoneIcon) end
end

function HS:OnWunderBarUpdate()
  F.Event.ContinueOutOfCombat(function()
    self.dataLoaded = I.HearthstoneDataLoaded
    self.hsLocation = GetBindLocation()

    self:UpdateSelected()
    self:UpdateFonts()
    self:UpdateText()
    self:UpdateColor()
    self:UpdateElements()
  end)
end

function HS:UpdateColor()
  WB:SetFontNormalColor(self.hearthstoneText)
  WB:SetFontIconColor(self.hearthstoneIcon)

  if self.db.cooldownUseAccent then
    WB:SetFontAccentColor(self.hearthstoneText.cooldownText, false)
  else
    WB:SetFontNormalColor(self.hearthstoneText.cooldownText, false)
  end
end

function HS:UpdateFonts()
  WB:SetFontFromDB(nil, nil, self.hearthstoneText)
  WB:SetFontFromDB(self.db, "cooldown", self.hearthstoneText.cooldownText, false, self.db.cooldownUseAccent)
  WB:SetIconFromDB(self.db, "icon", self.hearthstoneIcon)
end

function HS:UpdateText()
  self.hearthstoneText:SetText(self.db.useUppercase and F.String.Uppercase(self.hsLocation) or self.hsLocation)
  self.hearthstoneIcon:SetText(self.db.icon)
end

function HS:UpdateCooldownText()
  local primaryReady, primaryReadyText = self:GetCooldownForItem(self.hsPrimary)
  local secondaryReady, secondaryReadyText = true, ""

  if self.hsPrimary ~= self.hsSecondary then
    secondaryReady, secondaryReadyText = self:GetCooldownForItem(self.hsSecondary)
  end

  if not primaryReady and not secondaryReady then
    if not WB:IsTextTransitionPlaying(self.hearthstoneText.cooldownText) then
      self.hearthstoneText.cooldownLoop = 0

      WB:StartTextTransition(self.hearthstoneText.cooldownText, 5, function(anim)
        if self.hearthstoneText.cooldownLoop == 0 then
          anim.LoopCounter = 2
        elseif anim.LoopCounter > 2 then
          anim.LoopCounter = 1
        end

        self.hearthstoneText.cooldownLoop = anim.LoopCounter
        self:UpdateCooldownText()
      end)
    end

    if self.hearthstoneText.cooldownLoop == 1 then
      self.hearthstoneText.cooldownText:SetText(primaryReadyText)
    elseif self.hearthstoneText.cooldownLoop == 2 then
      self.hearthstoneText.cooldownText:SetText(secondaryReadyText)
    else
      self.hearthstoneText.cooldownText:SetText("")
    end
  else
    WB:StopAnimationType(self.hearthstoneText.cooldownText, WB.animationType.FADE)
    self.hearthstoneText.cooldownText:SetAlpha(1)

    if not primaryReady then
      self.hearthstoneText.cooldownText:SetText(primaryReadyText)
    elseif not secondaryReady then
      self.hearthstoneText.cooldownText:SetText(secondaryReadyText)
    else
      self.hearthstoneText.cooldownText:SetText("")
    end
  end
end

function HS:UpdateElements()
  local anchorPoint = WB:GetGrowDirection(self.Module, true)
  local iconSize = self.db.showIcon and self.db.iconFontSize or 1

  self.hearthstoneText:ClearAllPoints()
  self.hearthstoneIcon:ClearAllPoints()
  self.hearthstoneIcon:SetJustifyH("RIGHT")

  if anchorPoint == "RIGHT" then
    self.hearthstoneText:SetJustifyH("RIGHT")
    self.hearthstoneText:SetPoint("RIGHT", self.frame, "RIGHT", 0, 0)
  else
    self.hearthstoneText:SetJustifyH("LEFT")
    self.hearthstoneText:SetPoint("LEFT", self.frame, "LEFT", (iconSize + 5), 0)
  end

  self.hearthstoneIcon:SetPoint("RIGHT", self.hearthstoneText, "LEFT", -5, 3)
  self.hearthstoneText.cooldownText:SetPoint("CENTER", self.hearthstoneText, "CENTER", 0, WB.dirMulti * self.db.cooldownOffset)

  if self.db.showIcon then
    self.hearthstoneIcon:Show()
  else
    self.hearthstoneIcon:Hide()
  end
end

function HS:CreateText()
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

  local hearthstoneIcon = secureFrameHolder:CreateFontString(nil, "OVERLAY")
  local hearthstoneText = secureFrameHolder:CreateFontString(nil, "OVERLAY")
  hearthstoneText.cooldownText = secureFrameHolder:CreateFontString(nil, "OVERLAY")
  hearthstoneText.cooldownLoop = 0

  hearthstoneIcon:SetPoint("CENTER")
  hearthstoneText:SetPoint("CENTER")

  self.hearthstoneIcon = hearthstoneIcon
  self.hearthstoneText = hearthstoneText
end

function HS:OnInit()
  -- Get our settings DB
  self.db = WB:GetSubModuleDB(self:GetName())

  -- Don't init second time
  if self.Initialized then return end

  -- Vars
  self.frame = self.SubModuleHolder
  self.updateWait = 0
  self.mouseOver = false
  self.dataLoaded = false
  self.hsLocation = ""
  self.hsPrimary = {}
  self.hsSecondary = {}
  self.hsClass = {}
  self.hasTeleports = false

  -- Create stuff
  self:CreateText()
  self:OnWunderBarUpdate()

  self.flyoutDirection = E.db.TXUI.wunderbar.general.position == "TOP" and "DOWN" or "UP"

  -- We are done, hooray!
  self.Initialized = true
end

WB:RegisterSubModule(
  HS,
  F.Table.Join({
    "HEARTHSTONE_BOUND",
  }, F.Table.If(TXUI.IsRetail, { "COVENANT_CHOSEN" }))
)
