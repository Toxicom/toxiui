local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local WB = TXUI:GetModule("WunderBar")
local DB = WB:NewModule("DataBar")
local DT = E:GetModule("DataTexts")

-- Globals
local abs = math.abs
local C_GossipInfo_GetFriendshipReputation = C_GossipInfo and C_GossipInfo.GetFriendshipReputation
local C_MajorFactions_GetMajorFactionData = C_MajorFactions and C_MajorFactions.GetMajorFactionData
local C_QuestLog_GetInfo = C_QuestLog.GetInfo
local C_QuestLog_GetNumQuestLogEntries = C_QuestLog.GetNumQuestLogEntries
local C_QuestLog_GetQuestWatchType = C_QuestLog.GetQuestWatchType
local C_QuestLog_ReadyForTurnIn = C_QuestLog.ReadyForTurnIn
local C_Reputation_GetFactionParagonInfo = C_Reputation.GetFactionParagonInfo
local C_Reputation_GetWatchedFactionData = C_Reputation.GetWatchedFactionData
local C_Reputation_IsFactionParagon = C_Reputation.IsFactionParagon
local C_Reputation_IsMajorFaction = C_Reputation.IsMajorFaction
local CreateFrame = CreateFrame
local format = string.format
local GetCVarBool = GetCVarBool
local GetNumQuestLogEntries = GetNumQuestLogEntries
local GetQuestLogRewardXP = GetQuestLogRewardXP
local GetQuestLogTitle = GetQuestLogTitle
local GetWatchedFactionInfo = GetWatchedFactionInfo
local GetXPExhaustion = GetXPExhaustion
local IsPlayerAtEffectiveMaxLevel = IsPlayerAtEffectiveMaxLevel
local IsXPUserDisabledFunction = nil
local min = math.min
local SelectQuestLogEntry = SelectQuestLogEntry
local UnitXP = UnitXP
local UnitXPMax = UnitXPMax

local MAX_REPUTATION_REACTION = _G.MAX_REPUTATION_REACTION

if not TXUI.IsVanilla then IsXPUserDisabledFunction = IsXPUserDisabled end

-- Vars
DB.const = {
  mode = {
    ["rep"] = 0,
    ["exp"] = 1,
  },
}

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

function DB:OnEvent(event)
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

      if TXUI.IsRetail then
        local factionData = C_Reputation_GetWatchedFactionData()
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

      if TXUI.IsRetail then
        if C_Reputation_IsFactionParagon(factionID) then
          local currentValue, threshold, _, hasRewardPending = C_Reputation_GetFactionParagonInfo(factionID)
          minValue, maxValue = 0, threshold
          curValue = currentValue % threshold
          if hasRewardPending then curValue = curValue + threshold end
        elseif C_Reputation_IsMajorFaction(factionID) then
          local majorFactionData = C_MajorFactions_GetMajorFactionData(factionID)
          minValue, maxValue = 0, majorFactionData.renownLevelThreshold
        else
          local reputationInfo = C_GossipInfo_GetFriendshipReputation(factionID)
          local friendshipID = reputationInfo.friendshipFactionID

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

    F.Event.ContinueOutOfCombat(function()
      self.updateExpNextOutOfCombat = false

      if (not TXUI.IsVanilla and IsXPUserDisabledFunction()) or (IsPlayerAtEffectiveMaxLevel()) then
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
    end)
  end
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

function DB:UpdateTooltip()
  if not self.mouseover then return end

  if self.mode == DB.const.mode.exp then
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

function DB:OnClick()
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
  if self.noData then
    self.barFrame:Hide()
    return
  else
    self.barFrame:Show()
  end

  local barProgress
  if self.mode == DB.const.mode.rep then
    barProgress = self.data.repPercentage
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
  local mode = ((self.db.mode == "auto") and (not IsPlayerAtEffectiveMaxLevel()) and (TXUI.IsVanilla or not IsXPUserDisabledFunction())) and self.const.mode.exp
    or self.const.mode.rep

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
  if self.db.infoEnabled then
    self.infoText:SetText(E:Round((self.mode == DB.const.mode.exp) and self.data.expPercentage or self.data.repPercentage) .. "%")
  else
    self.infoText:SetText("")
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
  self.noData = false
  self.data = {
    repPercentage = 0,
    expRestPercentage = 0,
    expCompletedXP = 0,
    expCompletedPercentage = 0,
    expPercentage = 0,
    currentXP = 0,
    xpToLevel = 0,
    restedXP = 0,
  }

  self:CreateBar()
  self:UpdateSmartMode(true)
  self:OnWunderBarUpdate()

  -- We are done, hooray!
  self.Initialized = true
end

WB:RegisterSubModule(
  DB,
  F.Table.Join({
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
  }, F.Table.If(TXUI.IsRetail, { "SUPER_TRACKING_CHANGED" }))
)
