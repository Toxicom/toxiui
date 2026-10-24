local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local WB = TXUI:GetModule("WunderBar")
local DB = WB:NewModule("DataBar")
local DT = E:GetModule("DataTexts")

-- Globals
local abs = math.abs
local C_Housing = C_Housing
local C_HousingCatalog = C_HousingCatalog
local C_HousingDecor = C_HousingDecor
local C_HousingNeighborhood = C_HousingNeighborhood
local C_NeighborhoodInitiative = C_NeighborhoodInitiative
local C_QuestLog_GetInfo = C_QuestLog.GetInfo
local C_QuestLog_GetNumQuestLogEntries = C_QuestLog.GetNumQuestLogEntries
local C_QuestLog_GetQuestWatchType = C_QuestLog.GetQuestWatchType
local C_QuestLog_ReadyForTurnIn = C_QuestLog.ReadyForTurnIn
local CreateFrame = CreateFrame
local format = string.format
local GetCVarBool = GetCVarBool
local GetNumQuestLogEntries = GetNumQuestLogEntries
local GetQuestLogRewardXP = GetQuestLogRewardXP
local GetQuestLogTitle = GetQuestLogTitle
local GetTime = GetTime
local GetWatchedFactionInfo = GetWatchedFactionInfo
local GetXPExhaustion = GetXPExhaustion
local ipairs = ipairs
local IsPlayerAtEffectiveMaxLevel = (GameRulesUtil and GameRulesUtil.IsPlayerAtEffectiveMaxLevel) or IsPlayerAtEffectiveMaxLevel
local IsShiftKeyDown = IsShiftKeyDown
local IsXPUserDisabledFunction = nil
local max = math.max
local min = math.min
local PlayerIsTimerunning = PlayerIsTimerunning
local SecondsToTime = SecondsToTime
local SelectQuestLogEntry = SelectQuestLogEntry
local type = type
local UnitXP = UnitXP
local UnitXPMax = UnitXPMax

local HOUSING_DASHBOARD_ADDRESS = _G.HOUSING_DASHBOARD_ADDRESS or "Plot %d, %s"
local MAX_REPUTATION_REACTION = _G.MAX_REPUTATION_REACTION

if not TXUI.IsClassicEra and not TXUI.IsAnniversary then IsXPUserDisabledFunction = IsXPUserDisabled end

-- Vars
DB.const = {
  mode = {
    ["rep"] = 0,
    ["exp"] = 1,
    ["house"] = 2,
  },
}

-- Events that refresh the house bar, also used to re-evaluate the teleport/return state
local houseUpdateEvents = {
  ["ELVUI_FORCE_UPDATE"] = true,
  ["HOUSE_LEVEL_FAVOR_UPDATED"] = true,
  ["HOUSE_PLOT_ENTERED"] = true,
  ["HOUSE_PLOT_EXITED"] = true,
  ["HOUSING_SERVICES_AVAILABILITY_UPDATED"] = true,
  ["PLAYER_HOUSE_LIST_UPDATED"] = true,
  ["TRACKED_HOUSE_CHANGED"] = true,
  ["ZONE_CHANGED_NEW_AREA"] = true,
}

-- Same labels the Blizzard House Upgrade frame uses for budget rewards
local houseRewardValueNames = (TXUI.IsRetail and Enum.HouseLevelRewardValueType)
    and {
      [Enum.HouseLevelRewardValueType.InteriorDecor] = _G.HOUSING_DASHBOARD_REWARD_INTERIOR_BUDGET,
      [Enum.HouseLevelRewardValueType.ExteriorDecor] = _G.HOUSING_DASHBOARD_REWARD_EXTERIOR_BUDGET,
      [Enum.HouseLevelRewardValueType.Rooms] = _G.HOUSING_DASHBOARD_REWARD_ROOM_BUDGET,
      [Enum.HouseLevelRewardValueType.Fixtures] = _G.HOUSING_DASHBOARD_REWARD_FIXTURE_BUDGET,
    }
  or {}

function DB:GetValues(curValue, minValue, maxValue)
  local maximum = maxValue - minValue
  local current, diff = curValue - minValue, maximum

  if diff == 0 then diff = 1 end -- prevent a division by zero

  if current == maximum then
    return 1, 1, 100, true
  else
    return current, maximum, E:Round(current / diff * 100)
  end
end

function DB:OnEvent(event, arg1, arg2)
  -- Only faction combat text can change reputation, same filter as ElvUI
  if event == "COMBAT_TEXT_UPDATE" and E:NotSecretValue(arg1) and arg1 ~= "FACTION" then return end

  -- Housing data arrives async, collect it before smart mode decides what to show
  if TXUI.IsRetail then self:UpdateHousingData(event, arg1, arg2) end

  -- If smart mode changes, force update
  if self:UpdateSmartMode() then event = "ELVUI_FORCE_UPDATE" end

  -- Reputation
  if
    (self.mode == DB.const.mode.rep)
    and not self.updateRepNextOutOfCombat
    and ((event == "ELVUI_FORCE_UPDATE") or (event == "UPDATE_FACTION") or (event == "COMBAT_TEXT_UPDATE"))
  then
    self.updateRepNextOutOfCombat = true

    F.Event.ContinueOutOfCombat(function()
      self.updateRepNextOutOfCombat = false

      local name
      local reaction
      local minValue
      local maxValue
      local curValue
      local factionID

      if C_Reputation and C_Reputation.GetWatchedFactionData then
        local factionData = C_Reputation.GetWatchedFactionData()
        if factionData then
          name = factionData.name
          reaction = factionData.reaction
          minValue = factionData.currentReactionThreshold
          maxValue = factionData.nextReactionThreshold
          curValue = factionData.currentStanding
          factionID = factionData.factionID
        end
      else
        name, reaction, minValue, maxValue, curValue, factionID = GetWatchedFactionInfo()
      end

      local isCapped = false

      if not name then
        self.noData = true
        self:UpdateBar()
        return
      end

      self.noData = false

      if C_Reputation then
        if C_Reputation.IsFactionParagonForCurrentPlayer and C_Reputation.IsFactionParagonForCurrentPlayer(factionID) then
          local currentValue, threshold, _, hasRewardPending = C_Reputation.GetFactionParagonInfo(factionID)
          minValue, maxValue = 0, threshold
          curValue = currentValue % threshold
          if hasRewardPending then curValue = curValue + threshold end
        elseif C_Reputation.IsMajorFaction and C_Reputation.IsMajorFaction(factionID) then
          local majorFactionData = C_MajorFactions.GetMajorFactionData(factionID)
          minValue, maxValue = 0, majorFactionData and majorFactionData.renownLevelThreshold or 1
        elseif C_GossipInfo and C_GossipInfo.GetFriendshipReputation then
          local reputationInfo = C_GossipInfo.GetFriendshipReputation(factionID)
          local friendshipID = reputationInfo and reputationInfo.friendshipFactionID or 0

          if friendshipID > 0 then
            if reputationInfo.nextThreshold then
              minValue, maxValue, curValue = reputationInfo.reactionThreshold, reputationInfo.nextThreshold, reputationInfo.standing
            else
              minValue, maxValue, curValue = 0, 1, 1
              isCapped = true
            end
          elseif reaction == MAX_REPUTATION_REACTION then
            isCapped = true
          end
        end
      end

      -- Normalize values
      maxValue = maxValue - minValue
      curValue = curValue - minValue

      if isCapped and maxValue == 0 then
        maxValue = 1
        curValue = 1
      end

      minValue = 0

      local _, _, percent, _ = self:GetValues(curValue, minValue, maxValue)
      self.data.repPercentage = percent

      self:UpdateTooltip()
      self:UpdateBar()
    end)

    -- Experience
  elseif
    (self.mode == DB.const.mode.exp)
    and not self.updateExpNextOutOfCombat
    and (
      (event == "ELVUI_FORCE_UPDATE")
      or (event == "PLAYER_XP_UPDATE")
      or (event == "DISABLE_XP_GAIN")
      or (event == "ENABLE_XP_GAIN")
      or (event == "QUEST_LOG_UPDATE")
      or (event == "SUPER_TRACKING_CHANGED")
      or (event == "ZONE_CHANGED")
      or (event == "ZONE_CHANGED_NEW_AREA")
      or (event == "UPDATE_EXHAUSTION")
    )
  then
    self.updateExpNextOutOfCombat = true

    local updateExp = function()
      self.updateExpNextOutOfCombat = false
      self.noData = false

      if (not TXUI.IsClassicEra and not TXUI.IsAnniversary and IsXPUserDisabledFunction()) or (IsPlayerAtEffectiveMaxLevel()) then
        self.data.expRestPercentage = 0
        self.data.expCompletedXP = 0
        self.data.expCompletedPercentage = 0
        self.data.expPercentage = 100
        self.data.currentXP = 0
        self.data.xpToLevel = 0
        self.data.restedXP = 0
      else
        self.data.currentXP, self.data.xpToLevel, self.data.restedXP = UnitXP("player"), UnitXPMax("player"), GetXPExhaustion()
        if self.data.xpToLevel <= 0 then self.data.xpToLevel = 1 end
        if not self.data.restedXP then self.data.restedXP = 0 end

        if self.db.showCompletedXP and (event ~= "PLAYER_XP_UPDATE") then
          self.data.expCompletedXP, self.data.expCompletedPercentage = self:GetCompletedPercentage()
        end

        self.data.expRestPercentage = (self.data.restedXP > 0) and ((min(self.data.restedXP, self.data.xpToLevel) / self.data.xpToLevel) * 100) or 0
        self.data.expPercentage = (self.data.currentXP / self.data.xpToLevel) * 100
      end

      self:UpdateTooltip()
      self:UpdateBar()
    end

    -- QUEST_LOG_UPDATE fires in bursts while questing and the completed XP scan walks the whole quest log,
    -- so coalesce those into one update. The flag above drops further events until it runs
    if event == "QUEST_LOG_UPDATE" then
      E:Delay(0.5, F.Event.ContinueOutOfCombat, updateExp)
    else
      F.Event.ContinueOutOfCombat(updateExp)
    end

    -- House
  elseif (self.mode == DB.const.mode.house) and not self.updateHouseNextOutOfCombat and houseUpdateEvents[event] then
    self.updateHouseNextOutOfCombat = true

    F.Event.ContinueOutOfCombat(function()
      self.updateHouseNextOutOfCombat = false
      self.noData = not (self:IsHousingAvailable() and self.houseInfo and (self.data.houseLevel > 0))

      self:UpdateTooltip()
      self:UpdateBar()
    end)
  end
end

function DB:IsHousingAvailable()
  return TXUI.IsRetail and C_Housing.IsHousingServiceEnabled() and not PlayerIsTimerunning()
end

function DB:UpdateHousingData(event, arg1, arg2)
  if (event == "ELVUI_FORCE_UPDATE") or (event == "HOUSING_SERVICES_AVAILABILITY_UPDATED") then
    -- Houses are only shown in smart & house mode, don't bother the server otherwise
    if (self.db.mode == "rep") or not self:IsHousingAvailable() then return end

    -- WunderBar sends force updates in bursts, throttle the server requests
    local now = GetTime()
    if (event == "ELVUI_FORCE_UPDATE") and ((now - self.houseRequestTime) < 5) then return end
    self.houseRequestTime = now

    if self.houseInfo then
      C_Housing.GetCurrentHouseLevelFavor(self.houseInfo.houseGUID) -- responds with HOUSE_LEVEL_FAVOR_UPDATED
    else
      C_Housing.GetPlayerOwnedHouses() -- responds with PLAYER_HOUSE_LIST_UPDATED
    end
  elseif event == "PLAYER_HOUSE_LIST_UPDATED" then
    self.houseList = arg1
    self:SelectHouse()
  elseif event == "TRACKED_HOUSE_CHANGED" then
    self:SelectHouse()
  elseif event == "HOUSE_LEVEL_FAVOR_UPDATED" then
    -- Fires for every owned house at once, e.g. on decor acquisition bonuses
    if arg1 and self.houseInfo and (arg1.houseGUID == self.houseInfo.houseGUID) then self:SetHouseLevelFavor(arg1.houseLevel, arg1.houseFavor) end
  elseif event == "HOUSE_LEVEL_CHANGED" then
    if self.houseInfo then C_Housing.GetCurrentHouseLevelFavor(self.houseInfo.houseGUID) end

    if self.mode == DB.const.mode.house then
      WB:FlashFade(self.bar.spark)
      if self.db.showIcon then WB:FlashFontOnEvent(self.barIcon, true) end
    end
  elseif event == "RECEIVED_HOUSE_LEVEL_REWARDS" then
    self.houseRewards[arg1] = arg2
    if self.mode == DB.const.mode.house then self:UpdateTooltip() end
  elseif event == "NEIGHBORHOOD_INITIATIVE_UPDATED" then
    if self.mode == DB.const.mode.house then self:UpdateTooltip() end
  end
end

function DB:SelectHouse()
  if not self.houseList then return end

  -- Prefer the house Blizzard's favor bar tracks, otherwise the first one we own
  local trackedGUID = C_Housing.GetTrackedHouseGuid()
  local selected

  for _, houseInfo in ipairs(self.houseList) do
    if houseInfo.houseGUID and ((houseInfo.houseGUID == trackedGUID) or not selected) then selected = houseInfo end
  end

  -- Favor data belongs to the previous house
  if (selected and selected.houseGUID) ~= (self.houseInfo and self.houseInfo.houseGUID) then self.data.houseLevel = 0 end

  self.houseInfo = selected
  if selected then C_Housing.GetCurrentHouseLevelFavor(selected.houseGUID) end
end

function DB:SetHouseLevelFavor(level, favor)
  local data = self.data
  local maxLevel = C_Housing.GetMaxHouseLevel()
  local levelFavor = C_Housing.GetHouseLevelFavorForLevel(level)
  local nextFavor = (level < maxLevel) and C_Housing.GetHouseLevelFavorForLevel(level + 1) or levelFavor

  data.houseLevel = level
  data.houseMaxLevel = maxLevel
  data.houseCurrent = favor - levelFavor
  data.houseNeeded = nextFavor - levelFavor

  -- Upgrades are bought manually, so favor can exceed the next level
  data.housePercent = (data.houseNeeded > 0) and max(min((data.houseCurrent / data.houseNeeded) * 100, 100), 0) or 100
end

function DB:CanReturnHome()
  -- Same as Blizzard's dashboard teleport button: offer the way back while visiting our own neighborhood
  if not self.houseInfo or not C_HousingNeighborhood.CanReturnAfterVisitingHouse() then return false end

  local neighborhoodGUID = C_Housing.GetCurrentNeighborhoodGUID()
  return (neighborhoodGUID ~= nil) and (neighborhoodGUID == self.houseInfo.neighborhoodGUID)
end

function DB:UpdateSecureOverlay()
  if not self.secureOverlay or self.updateOverlayNextOutOfCombat then return end
  self.updateOverlayNextOutOfCombat = true

  -- Secure frames can only be shown, hidden or changed out of combat
  F.Event.ContinueOutOfCombat(function()
    self.updateOverlayNextOutOfCombat = false

    local overlay = self.secureOverlay
    local houseInfo = self.houseInfo

    if (self.mode ~= DB.const.mode.house) or self.noData or not houseInfo then
      overlay:Hide()
      return
    end

    overlay:SetAttribute("type2", self:CanReturnHome() and "returnhome" or "teleporthome")
    overlay:SetAttribute("house-neighborhood-guid", houseInfo.neighborhoodGUID)
    overlay:SetAttribute("house-guid", houseInfo.houseGUID)
    overlay:SetAttribute("house-plot-id", houseInfo.plotID)
    overlay:Show()
  end)
end

function DB:UpdateExperienceTooltip()
  DT.tooltip:ClearLines()
  DT.tooltip:AddDoubleLine("Experience", format("%s %d", "Level", E.mylevel))
  DT.tooltip:AddLine(" ")

  local remainXP = self.data.xpToLevel - self.data.currentXP
  local remainPercent = (remainXP / self.data.xpToLevel) * 100
  local remainBars = 20 * (remainXP / self.data.xpToLevel)

  DT.tooltip:AddDoubleLine(
    "XP:",
    format(" %s / %s (%.2f%%)", E:ShortValue(self.data.currentXP), E:ShortValue(self.data.xpToLevel), self.data.expPercentage),
    1,
    1,
    1,
    F.SlowColorGradient(1 - (remainPercent * 0.01), 1, 0.1, 0.1, 1, 1, 0.1, 0.1, 1, 0.1)
  )

  DT.tooltip:AddDoubleLine(
    "Remaining:",
    format(" %s (%.2f%% - %d " .. "Bars" .. ")", E:ShortValue(remainXP), remainPercent, remainBars),
    1,
    1,
    1,
    F.SlowColorGradient(1 - (remainPercent * 0.01), 1, 0.1, 0.1, 1, 1, 0.1, 0.1, 1, 0.1)
  )

  if self.data.expCompletedXP > 0 then
    local expCompletedRawPerc = (self.data.expCompletedXP / self.data.xpToLevel) * 100
    DT.tooltip:AddDoubleLine(
      "Quest Log XP:",
      format(" %s (%.2f%%)", E:ShortValue(self.data.expCompletedXP), expCompletedRawPerc),
      1,
      1,
      1,
      F.SlowColorGradient(expCompletedRawPerc * 0.01, 1, 0.1, 0.1, 1, 1, 0.1, 0.1, 1, 0.1)
    )
  end

  if self.data.restedXP > 0 then
    local restedRawPerc = (self.data.restedXP / self.data.xpToLevel) * 100
    DT.tooltip:AddDoubleLine(
      "Rested:",
      format("%s (%.2f%%)", E:ShortValue(self.data.restedXP), restedRawPerc),
      1,
      1,
      1,
      F.SlowColorGradient(restedRawPerc * 0.01, 1, 0.1, 0.1, 1, 1, 0.1, 0.1, 1, 0.1)
    )
  end

  DT.tooltip:Show()
end

function DB:AddHouseRewardLines(level)
  local rewards = self.houseRewards[level]

  -- Rewards are async, request them once per level (holds the request time until RECEIVED_HOUSE_LEVEL_REWARDS)
  if type(rewards) ~= "table" then
    if not rewards or ((GetTime() - rewards) > 10) then
      self.houseRewards[level] = GetTime()
      C_Housing.GetHouseLevelRewardsForLevel(level)
    end
    return
  end

  if #rewards == 0 then return end

  DT.tooltip:AddLine(" ")
  DT.tooltip:AddLine(format("%s %d %s", "Level", level, "Unlocks"))

  for _, reward in ipairs(rewards) do
    if reward.type == Enum.HouseLevelRewardType.Value then
      DT.tooltip:AddDoubleLine(
        houseRewardValueNames[reward.valueType] or "Budget",
        format("%s > %s", F.String.Silver(reward.oldValue or 0), F.String.Good(reward.newValue or 0)),
        1,
        1,
        1
      )
    elseif reward.objectName then
      DT.tooltip:AddLine(reward.objectName, 1, 1, 1)
    end
  end
end

function DB:AddEndeavorLines()
  if not C_NeighborhoodInitiative.IsInitiativeEnabled() then return end

  -- Only ask the server while hovering, at most once a minute
  local now = GetTime()
  if (now - self.initiativeRequestTime) > 60 then
    self.initiativeRequestTime = now
    C_NeighborhoodInitiative.RequestNeighborhoodInitiativeInfo() -- responds with NEIGHBORHOOD_INITIATIVE_UPDATED
  end

  -- Info belongs to the neighborhood viewed in the dashboard, only show the one we contribute to
  local info = C_NeighborhoodInitiative.GetNeighborhoodInitiativeInfo()
  if not info or not info.isLoaded or (info.initiativeID == 0) or (info.neighborhoodGUID ~= C_NeighborhoodInitiative.GetActiveNeighborhood()) then return end

  local progressPercent = min(info.currentProgress / max(info.progressRequired, 1), 1)

  DT.tooltip:AddLine(" ")
  DT.tooltip:AddDoubleLine("Endeavor", info.title)

  DT.tooltip:AddDoubleLine(
    "Progress:",
    format(" %s / %s (%.2f%%)", E:ShortValue(info.currentProgress), E:ShortValue(info.progressRequired), progressPercent * 100),
    1,
    1,
    1,
    F.SlowColorGradient(progressPercent, 1, 0.1, 0.1, 1, 1, 0.1, 0.1, 1, 0.1)
  )

  DT.tooltip:AddDoubleLine("Contribution:", E:ShortValue(info.playerTotalContribution), 1, 1, 1, 1, 1, 1)

  if info.duration > 0 then DT.tooltip:AddDoubleLine("Time Left:", SecondsToTime(info.duration, false, true, 1), 1, 1, 1, 1, 1, 1) end

  local availableFavor = C_NeighborhoodInitiative.GetAvailableHouseXP()
  if availableFavor > 0 then DT.tooltip:AddDoubleLine("Earnable Favor:", E:ShortValue(availableFavor), 1, 1, 1, 1, 1, 1) end
end

function DB:UpdateHouseTooltip()
  local houseInfo, data = self.houseInfo, self.data
  if not houseInfo or (data.houseLevel == 0) then return end

  local isInsideOwned = C_Housing.IsInsideOwnedHouseOrPlot()
  local canReturn = self:CanReturnHome()

  DT.tooltip:ClearLines()
  DT.tooltip:AddDoubleLine(houseInfo.houseName or "House", format("%s %d / %d", "Level", data.houseLevel, data.houseMaxLevel))
  if houseInfo.neighborhoodName then DT.tooltip:AddLine(F.String.Silver(format(HOUSING_DASHBOARD_ADDRESS, houseInfo.plotID, houseInfo.neighborhoodName))) end
  DT.tooltip:AddLine(" ")

  -- Favor
  if data.houseLevel >= data.houseMaxLevel then
    DT.tooltip:AddDoubleLine("Favor:", F.String.Good("Max Level"), 1, 1, 1)
  else
    local houseNeeded = max(data.houseNeeded, 1)
    local remainFavor = max(houseNeeded - data.houseCurrent, 0)
    local remainPercent = (remainFavor / houseNeeded) * 100
    local r, g, b = F.SlowColorGradient(1 - (remainPercent * 0.01), 1, 0.1, 0.1, 1, 1, 0.1, 0.1, 1, 0.1)

    DT.tooltip:AddDoubleLine("Favor:", format(" %s / %s (%.2f%%)", E:ShortValue(data.houseCurrent), E:ShortValue(houseNeeded), data.housePercent), 1, 1, 1, r, g, b)

    if remainFavor > 0 then
      DT.tooltip:AddDoubleLine("Remaining:", format(" %s (%.2f%%)", E:ShortValue(remainFavor), remainPercent), 1, 1, 1, r, g, b)
    else
      DT.tooltip:AddLine(F.String.Good("Upgrade available in the Housing Dashboard"))
    end

    self:AddHouseRewardLines(data.houseLevel + 1)
  end

  self:AddEndeavorLines()

  -- Decor
  DT.tooltip:AddLine(" ")

  local totalOwned, exemptOwned = C_HousingCatalog.GetDecorTotalOwnedCount()
  local maxOwned = C_HousingCatalog.GetDecorMaxOwnedCount()
  if maxOwned > 0 then
    local owned = totalOwned - exemptOwned
    local ownedText = format("%d / %d", owned, maxOwned)

    if owned >= maxOwned then
      ownedText = F.String.Error(ownedText)
    elseif owned >= (maxOwned * 0.9) then
      ownedText = F.String.Warning(ownedText)
    end

    DT.tooltip:AddDoubleLine("Decor Storage:", ownedText, 1, 1, 1, 1, 1, 1)
  end

  -- Placement budget is nil outside of our own house & plot
  if isInsideOwned then
    local spentBudget, maxBudget = C_HousingDecor.GetSpentPlacementBudget(), C_HousingDecor.GetMaxPlacementBudget()
    if spentBudget and maxBudget and (maxBudget > 0) then DT.tooltip:AddDoubleLine("Placement Budget:", format("%d / %d", spentBudget, maxBudget), 1, 1, 1, 1, 1, 1) end
  end

  -- Teleport, cooldown times can be secret
  if not canReturn then
    local cooldown = C_Housing.GetVisitCooldownInfo()
    if cooldown and E:NotSecretValue(cooldown.startTime) and E:NotSecretValue(cooldown.duration) then
      local remaining = cooldown.isActive and (cooldown.duration - (GetTime() - cooldown.startTime)) or 0
      DT.tooltip:AddDoubleLine("Teleport Home:", (remaining > 0) and F.String.Error(SecondsToTime(remaining)) or F.String.Good("Ready"), 1, 1, 1)
    end
  end

  DT.tooltip:AddLine(" ")
  DT.tooltip:AddLine("|cffFFFFFFLeft Click:|r Toggle Housing Dashboard")
  DT.tooltip:AddLine("|cffFFFFFFRight Click:|r " .. (canReturn and "Return from Visit" or "Teleport Home"))
  if isInsideOwned then DT.tooltip:AddLine("|cffFFFFFFShift-Left Click:|r Toggle House Editor") end

  DT.tooltip:Show()
end

function DB:UpdateTooltip()
  if not self.mouseover then return end

  if self.mode == DB.const.mode.house then
    self:UpdateHouseTooltip()
  elseif self.mode == DB.const.mode.exp then
    self:UpdateExperienceTooltip()
  elseif self.mode == DB.const.mode.rep then
    local dtModule = WB:GetElvUIDataText("Reputation")
    if dtModule then
      dtModule.eventFunc(WB:GetElvUIDummy(), "ELVUI_FORCE_UPDATE")
      dtModule.onEnter()
    end
  end
end

function DB:OnEnter()
  self.mouseover = true
  self:UpdateTooltip()

  WB:SetAccentColorFunc(self.bar, "statusbar")
  WB:SetAccentColorFunc(self.bar.background, "vertex", 0.35)

  if self.db.showIcon then WB:SetFontAccentColor(self.barIcon) end
end

function DB:OnLeave()
  self.mouseover = false

  WB:SetNormalColorFunc(self.bar, "statusbar")
  WB:SetNormalColorFunc(self.bar.background, "vertex", 0.35)

  if self.db.showIcon then WB:SetFontIconColor(self.barIcon) end
end

function DB:OnClick(_, button)
  -- Right click is handled by the secure overlay (teleport home)
  if self.mode == DB.const.mode.house then
    if button ~= "LeftButton" then return end

    if not IsShiftKeyDown() then
      _G.HousingFramesUtil.ToggleHousingDashboard()
    elseif C_Housing.IsInsideOwnedHouseOrPlot() then
      _G.HousingFramesUtil.ToggleHouseEditor()
    end

    return
  end

  if self.mode ~= DB.const.mode.rep then return end

  local dtModule = WB:GetElvUIDataText("Reputation")
  if dtModule then dtModule.onClick() end
end

function DB:OnWunderBarUpdate()
  self:UpdateSmartMode()
  self:UpdateElements()
  self:UpdateBar()
  self:UpdatePosition()
  self:OnEvent("ELVUI_FORCE_UPDATE")
end

function DB:UpdateBar()
  self:UpdateSecureOverlay()

  if self.noData then
    self.barFrame:Hide()
    return
  else
    self.barFrame:Show()
  end

  local barProgress
  if self.mode == DB.const.mode.rep then
    barProgress = self.data.repPercentage
  elseif self.mode == DB.const.mode.house then
    barProgress = self.data.housePercent
  else
    barProgress = self.data.expPercentage
  end

  if self.db.showIcon and (abs(barProgress - self.bar:GetValue()) > 0.1) then
    WB:FlashFontOnEvent(self.barIcon, true)
    WB:FlashFade(self.bar.spark)
  end

  WB:SetBarProgress(self.bar, barProgress)

  if self.db.showCompletedXP and (self.mode == DB.const.mode.exp) then
    self.bar.completedOverlay:Show()
    WB:SetBarProgress(self.bar.completedOverlay, self.data.expCompletedPercentage)
  else
    self.bar.completedOverlay:Hide()
  end

  self:UpdateInfoText()
end

function DB:UpdatePosition()
  local anchorPoint = WB:GetGrowDirection(self.Module, true)
  local maxWidth = WB:GetMaxWidth(self.Module)
  local iconSize = self.db.showIcon and self.db.iconFontSize or 0.01
  local barOffset = self.db.barOffset

  local iconOffset = 2
  local iconPadding = 5
  local iconSpace = iconSize + (iconPadding * 2)

  self.bar:ClearAllPoints()
  self.bar:SetSize(maxWidth - iconSpace - iconPadding, self.db.barHeight)
  self.bar.spark:SetSize(20, self.db.barHeight * 4)

  if anchorPoint == "RIGHT" then
    self.bar:SetPoint(anchorPoint, self.frame, anchorPoint, 0, barOffset)
  else
    self.bar:SetPoint(anchorPoint, self.frame, anchorPoint, iconSpace, barOffset)
  end

  self.barFrame:ClearAllPoints()
  self.barFrame:SetAllPoints()

  self.barIcon:ClearAllPoints()
  self.barIcon:SetPoint("RIGHT", self.bar, "LEFT", -iconPadding, iconOffset)

  self.infoText:ClearAllPoints()
  self.infoText:SetPoint("CENTER", 0, WB.dirMulti * self.db.infoOffset)

  self.bar.completedOverlay:ClearAllPoints()
  self.bar.completedOverlay:SetAllPoints(self.bar)
end

function DB:GetCompletedPercentage()
  local totalCompletedXP = 0

  if TXUI.IsRetail then
    for i = 1, C_QuestLog_GetNumQuestLogEntries() do
      local questInfo = C_QuestLog_GetInfo(i)
      if questInfo and not questInfo.isHidden and questInfo.isOnMap and C_QuestLog_GetQuestWatchType(questInfo.questID) and C_QuestLog_ReadyForTurnIn(questInfo.questID) then
        totalCompletedXP = totalCompletedXP + GetQuestLogRewardXP(questInfo.questID)
      end
    end
  else
    local currentZone = E.MapInfo.name
    if not currentZone then return 0, 0 end

    local currentZoneCheck
    for i = 1, GetNumQuestLogEntries() do
      local name, _, _, isHeader, _, isComplete, _, questID = GetQuestLogTitle(i)

      if isHeader then
        currentZoneCheck = currentZone == name
      elseif currentZoneCheck and isComplete == 1 then
        SelectQuestLogEntry(i)
        totalCompletedXP = totalCompletedXP + GetQuestLogRewardXP(questID)
      end
    end
  end

  return totalCompletedXP, (min(self.data.currentXP + totalCompletedXP, self.data.xpToLevel) / self.data.xpToLevel) * 100
end

function DB:UpdateSmartMode(init)
  local isAuto = self.db.mode == "auto"
  local mode = self.const.mode.rep

  if TXUI.IsRetail and (self.db.mode == "house") then
    mode = self.const.mode.house
  elseif isAuto and (not IsPlayerAtEffectiveMaxLevel()) and ((TXUI.IsClassicEra or TXUI.IsAnniversary) or not IsXPUserDisabledFunction()) then
    mode = self.const.mode.exp
  elseif isAuto and self.houseInfo and self:IsHousingAvailable() then
    -- House while on our plot, then the watched reputation, then the house again
    if C_Housing.IsInsideOwnedHouseOrPlot() or not C_Reputation.GetWatchedFactionData() then mode = self.const.mode.house end
  end

  if not init and (mode ~= self.mode) then
    self.mode = mode
    return true
  elseif init then
    self.mode = mode
    return true
  end

  return false
end

function DB:UpdateElements()
  WB:SetIconFromDB(self.db, "icon", self.barIcon)
  self.barIcon:SetText(self.db.icon)

  WB:SetNormalColorFunc(self.bar, "statusbar", 1, false)
  WB:SetNormalColorFunc(self.bar.background, "vertex", 0.35, false)

  WB:SetAccentColorFunc(self.bar.completedOverlay, "statusbar", 0.35, false)
  WB:SetAccentColorFunc(self.bar.spark, "vertex", 0.35, false)

  if self.db.showIcon then
    self.barIcon:Show()
  else
    self.barIcon:Hide()
  end

  WB:SetFontFromDB(self.db, "info", self.infoText, true, self.db.infoUseAccent)
end

function DB:UpdateInfoText()
  if not self.db.infoEnabled then
    self.infoText:SetText("")
  elseif self.mode == DB.const.mode.house then
    self.infoText:SetText(format("L%d · %d%%", self.data.houseLevel, E:Round(self.data.housePercent)))
  else
    self.infoText:SetText(E:Round((self.mode == DB.const.mode.exp) and self.data.expPercentage or self.data.repPercentage) .. "%")
  end
end

function DB:CreateBar()
  -- Frames
  local barFrame = CreateFrame("BUTTON", nil, self.frame)

  barFrame:SetPoint("CENTER")

  local onEnter = function(...)
    WB:ModuleOnEnter(self, ...)
  end
  local onLeave = function(...)
    WB:ModuleOnLeave(self, ...)
  end
  local onClick = function(...)
    WB:ModuleOnClick(self, ...)
  end

  -- Frame
  barFrame:SetScript("OnEnter", onEnter)
  barFrame:SetScript("OnLeave", onLeave)

  barFrame:RegisterForClicks(GetCVarBool("ActionButtonUseKeyDown") and "AnyDown" or "AnyUp")
  barFrame:SetScript("OnClick", onClick)

  self.barFrame = barFrame

  -- Secure overlay for house mode, teleporting home is protected. Parented to the holder instead of the bar frame,
  -- so the insecure bar frame can still be shown/hidden in combat. Only shown in house mode (see UpdateSecureOverlay)
  if TXUI.IsRetail then
    local secureOverlay = CreateFrame("BUTTON", nil, self.frame, "SecureActionButtonTemplate")
    secureOverlay:SetAllPoints()
    secureOverlay:SetFrameLevel(barFrame:GetFrameLevel() + 10)
    secureOverlay:RegisterForClicks(GetCVarBool("ActionButtonUseKeyDown") and "AnyDown" or "AnyUp")
    secureOverlay:SetScript("OnEnter", onEnter)
    secureOverlay:SetScript("OnLeave", onLeave)

    -- Left clicks behave exactly like the insecure bar frame
    local onLeftClick = function(frame)
      onClick(frame, "LeftButton")
    end

    secureOverlay:SetAttribute("type1", "function")
    secureOverlay:SetAttribute("_function1", onLeftClick)
    secureOverlay:SetAttribute("shift-type1", "function")
    secureOverlay:SetAttribute("shift-_function1", onLeftClick)
    secureOverlay:Hide()

    self.secureOverlay = secureOverlay
  end

  -- Bar
  local bar = CreateFrame("STATUSBAR", nil, barFrame)
  bar:SetStatusBarTexture(E.media.blankTex)
  bar:SetStatusBarColor(1, 1, 1, 1)
  bar:SetMinMaxValues(0, 100)
  bar.barTexture = bar:GetStatusBarTexture()
  bar.barTexture:SetDrawLayer("ARTWORK", 3)

  bar.spark = bar:CreateTexture(nil, "OVERLAY")
  bar.spark:SetDrawLayer("OVERLAY", 7)
  bar.spark:SetBlendMode("ADD")
  bar.spark:SetSnapToPixelGrid(false)
  bar.spark:SetPoint("LEFT", bar:GetStatusBarTexture(), "RIGHT", -10, 0)
  bar.spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
  bar.spark:SetAlpha(0)

  bar.completedOverlay = CreateFrame("STATUSBAR", nil, barFrame)
  bar.completedOverlay:SetStatusBarTexture(E.media.blankTex)
  bar.completedOverlay:SetStatusBarColor(1, 1, 1, 1)
  bar.completedOverlay:SetMinMaxValues(0, 100)
  bar.completedOverlay:EnableMouse(false)
  bar.completedOverlay.barTexture = bar.completedOverlay:GetStatusBarTexture()
  bar.completedOverlay.barTexture:SetDrawLayer("ARTWORK", 2)

  bar.background = bar:CreateTexture(nil, "BACKGROUND")
  bar.background:SetColorTexture(1, 1, 1)
  bar.background:SetAllPoints()

  self.bar = bar

  -- Info Text
  local infoText = bar:CreateFontString(nil, "OVERLAY")
  self.infoText = infoText

  -- Icon
  local barIcon = bar:CreateFontString(nil, "OVERLAY")
  barIcon:SetPoint("CENTER")

  self.barIcon = barIcon
end

function DB:OnInit()
  -- Get our settings DB
  self.db = WB:GetSubModuleDB(self:GetName())

  -- Don't init second time
  if self.Initialized then return end

  -- Vars
  self.frame = self.SubModuleHolder
  self.updateExpNextOutOfCombat = false
  self.updateRepNextOutOfCombat = false
  self.updateHouseNextOutOfCombat = false
  self.updateOverlayNextOutOfCombat = false
  self.noData = false
  self.houseRequestTime = 0
  self.initiativeRequestTime = 0
  self.houseRewards = {}
  self.data = {
    repPercentage = 0,
    expRestPercentage = 0,
    expCompletedXP = 0,
    expCompletedPercentage = 0,
    expPercentage = 0,
    currentXP = 0,
    xpToLevel = 0,
    restedXP = 0,
    houseLevel = 0,
    houseMaxLevel = 0,
    houseCurrent = 0,
    houseNeeded = 0,
    housePercent = 0,
  }

  self:CreateBar()
  self:UpdateSmartMode(true)
  self:OnWunderBarUpdate()

  -- We are done, hooray!
  self.Initialized = true
end

WB:RegisterSubModule(
  DB,
  F.Table.Join(
    {
      "PLAYER_XP_UPDATE",
      "QUEST_LOG_UPDATE",
      "ZONE_CHANGED",
      "ZONE_CHANGED_NEW_AREA",
      "UPDATE_EXPANSION_LEVEL",
      "DISABLE_XP_GAIN",
      "ENABLE_XP_GAIN",
      "UPDATE_EXHAUSTION",
      "UPDATE_FACTION",
      "COMBAT_TEXT_UPDATE",
    },
    F.Table.If(TXUI.IsRetail, {
      "SUPER_TRACKING_CHANGED",
      "HOUSE_LEVEL_CHANGED",
      "HOUSE_LEVEL_FAVOR_UPDATED",
      "HOUSE_PLOT_ENTERED",
      "HOUSE_PLOT_EXITED",
      "HOUSING_SERVICES_AVAILABILITY_UPDATED",
      "NEIGHBORHOOD_INITIATIVE_UPDATED",
      "PLAYER_HOUSE_LIST_UPDATED",
      "RECEIVED_HOUSE_LEVEL_REWARDS",
      "TRACKED_HOUSE_CHANGED",
    })
  )
)
