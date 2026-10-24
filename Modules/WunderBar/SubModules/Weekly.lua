local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

-- Mythic+ and Great Vault only exist on Retail
if not TXUI.IsRetail then return end

local WB = TXUI:GetModule("WunderBar")
local WK = WB:NewModule("Weekly", "AceHook-3.0")
local DT = E:GetModule("DataTexts")

local C_ChallengeMode = C_ChallengeMode
local C_Container = C_Container
local C_CurrencyInfo = C_CurrencyInfo
local C_Item = C_Item
local C_MythicPlus = C_MythicPlus
local C_PlayerInfo = C_PlayerInfo
local C_Spell = C_Spell
local C_WeeklyRewards = C_WeeklyRewards
local CreateFrame = CreateFrame
local format = string.format
local GetCVarBool = GetCVarBool
local ipairs = ipairs
local IsSpellKnownOrOverridesKnown = IsSpellKnownOrOverridesKnown
local pairs = pairs
local sort = table.sort
local strfind = string.find
local tconcat = table.concat
local tinsert = table.insert
local wipe = wipe

local DUNGEONS = DUNGEONS
local RAID = RAID
local WORLD = WORLD

-- Vault rows, in the same order as Blizzard's Great Vault
local vaultRows = {
  { type = Enum.WeeklyRewardChestThresholdType.Raid, label = RAID },
  { type = Enum.WeeklyRewardChestThresholdType.Activities, label = DUNGEONS },
  { type = Enum.WeeklyRewardChestThresholdType.World, label = WORLD },
}

-- Teleport spell per challenge map, resolved once per map
local teleportCache = {}

-- Reusable tables
local weeklyRuns = {}
local slotTexts = {}

local function sortByLevel(a, b)
  return a.level > b.level
end

local function sortByIndex(a, b)
  return a.index < b.index
end

-- Initials of a dungeon name, "Windrunner Spire" -> "WS"
local function GetInitials(name)
  local initials = name:gsub("(%a)[%w']*", "%1"):gsub("[^%u]", "")
  return initials ~= "" and initials or name
end

-- Blizzard has no challenge map -> teleport spell lookup, so match the dungeon name
-- against the localized teleport spell descriptions ("Teleport to the entrance to X")
function WK:GetTeleport(mapChallengeModeID)
  if not mapChallengeModeID then return end

  local cached = teleportCache[mapChallengeModeID]
  if cached then return cached end

  local mapName = C_ChallengeMode.GetMapUIInfo(mapChallengeModeID)
  if not mapName or mapName == "" then return end

  for id, option in pairs(I.HearthstoneData) do
    if option.mythic then
      -- An explicit cmID on the teleport entry wins over the description match
      local matches = option.cmID == mapChallengeModeID
      if option.cmID == nil then
        local description = C_Spell.GetSpellDescription(id)
        matches = description ~= nil and strfind(description, mapName, 1, true) ~= nil
      end

      -- Some dungeons have multiple teleport spells, prefer the one that is known
      if matches and (not cached or IsSpellKnownOrOverridesKnown(id)) then cached = { id = id, label = option.label } end
    end
  end

  teleportCache[mapChallengeModeID] = cached
  return cached
end

function WK:GetSeasonTeleports()
  local teleports = {}

  for id, option in pairs(I.HearthstoneData) do
    if option.mythic and option.season == TXUI.RetailSeason and IsSpellKnownOrOverridesKnown(id) then tinsert(teleports, { spellID = id, type = "spell", label = option.label }) end
  end

  return teleports
end

function WK:UpdateKeystone()
  local keystone = self.keystone
  wipe(keystone)

  local mapID = C_MythicPlus.GetOwnedKeystoneChallengeMapID()
  if not mapID or mapID == 0 then return end

  keystone.mapID = mapID
  keystone.level = C_MythicPlus.GetOwnedKeystoneLevel()
  keystone.name = C_ChallengeMode.GetMapUIInfo(mapID) or ""
  keystone.teleport = self:GetTeleport(mapID)
  keystone.short = (keystone.teleport and keystone.teleport.label) or GetInitials(keystone.name)
end

function WK:GetRating()
  local summary = C_PlayerInfo.GetPlayerMythicPlusRatingSummary("player")
  return summary and summary.currentSeasonScore or 0, summary
end

function WK:GetVaultProgress()
  local unlocked, total = 0, 0

  for _, activity in ipairs(C_WeeklyRewards.GetActivities()) do
    total = total + 1
    if activity.progress >= activity.threshold then unlocked = unlocked + 1 end
  end

  return unlocked, total
end

function WK:GetBarText()
  local mode = self.db.textMode

  if mode == "VAULT" then
    local unlocked, total = self:GetVaultProgress()
    return format("%d/%d", unlocked, total)
  end

  if mode == "KEY" and self.keystone.level then
    return F.String.KeystoneLevel(self:FormatBarText(format("+%d %s", self.keystone.level, self.keystone.short)), self.keystone.level)
  end

  local rating = self:GetRating()
  if rating > 0 then return F.String.DungeonScore(format("%d", rating), rating) end

  return self:FormatBarText(mode == "KEY" and "No Key" or "0")
end

-- Uppercase before coloring, so the color escape codes stay intact
function WK:FormatBarText(text)
  return self.db.useUppercase and F.String.Uppercase(text) or text
end

function WK:UpdateText()
  self.weeklyText:SetText(self:GetBarText())
  self.weeklyIcon:SetText(self.db.icon)
end

function WK:UpdateSecureAttributes()
  F.Event.ContinueOutOfCombat(function()
    local secureFrame = self.secureFrame
    local teleport = self.keystone.teleport
    local growRight = WB:GetGrowDirection(self.Module) == "RIGHT"

    local openFlyout = function()
      local teleports = self:GetSeasonTeleports()
      if #teleports > 0 then WB:ShowSecureFlyOut(self.frame, self.flyoutDirection, teleports, nil, growRight) end
    end

    -- Left: Great Vault
    secureFrame:SetAttribute("type1", "function")
    secureFrame:SetAttribute("_function1", function()
      self:ToggleGreatVault()
    end)

    -- Shift-Left: link keystone
    secureFrame:SetAttribute("shift-type1", "function")
    secureFrame:SetAttribute("shift-_function1", function()
      self:LinkKeystone()
    end)

    -- Right: teleport to the keystone dungeon, or the season teleports when it's not known
    if teleport and IsSpellKnownOrOverridesKnown(teleport.id) then
      secureFrame:SetAttribute("type2", "spell")
      secureFrame:SetAttribute("spell2", teleport.id)
    else
      secureFrame:SetAttribute("type2", "function")
      secureFrame:SetAttribute("_function2", openFlyout)
    end

    -- Shift-Right: season teleports
    secureFrame:SetAttribute("shift-type2", "function")
    secureFrame:SetAttribute("shift-_function2", openFlyout)
  end)
end

function WK:ToggleGreatVault()
  if not _G.WeeklyRewardsFrame then _G.WeeklyRewards_LoadUI() end

  local frame = _G.WeeklyRewardsFrame
  if not frame then return end

  if frame:IsShown() then
    frame:Hide()
  else
    frame:Show()
  end
end

function WK:LinkKeystone()
  for bag = 0, NUM_BAG_SLOTS do
    for slot = 1, C_Container.GetContainerNumSlots(bag) do
      local info = C_Container.GetContainerItemInfo(bag, slot)
      if info and info.itemID and info.hyperlink and C_Item.IsItemKeystoneByID(info.itemID) then
        if not _G.ChatFrameUtil.InsertLink(info.hyperlink) then _G.ChatFrameUtil.OpenChat(info.hyperlink) end
        return
      end
    end
  end
end

function WK:AddVaultLines()
  DT.tooltip:AddLine(" ")
  DT.tooltip:AddLine("Great Vault")

  if C_WeeklyRewards.HasAvailableRewards() then DT.tooltip:AddLine(F.String.Good("Rewards are waiting for you!")) end

  for _, row in ipairs(vaultRows) do
    local activities = C_WeeklyRewards.GetActivities(row.type)

    if #activities > 0 then
      sort(activities, sortByIndex)
      wipe(slotTexts)

      for _, activity in ipairs(activities) do
        if activity.progress >= activity.threshold then
          local itemLink = C_WeeklyRewards.GetExampleRewardItemHyperlinks(activity.id)
          local itemLevel = itemLink and C_Item.GetDetailedItemLevelInfo(itemLink)
          tinsert(slotTexts, F.String.Good(itemLevel and format("%d", itemLevel) or "..."))
        else
          tinsert(slotTexts, F.String.Muted(format("%d/%d", activity.progress, activity.threshold)))
        end
      end

      DT.tooltip:AddDoubleLine(row.label, tconcat(slotTexts, "  "), 1, 1, 1)
    end
  end
end

function WK:AddWeeklyRuns()
  wipe(weeklyRuns)

  for _, run in ipairs(C_MythicPlus.GetRunHistory(false, true)) do
    if run.thisWeek then tinsert(weeklyRuns, run) end
  end

  DT.tooltip:AddLine(" ")
  DT.tooltip:AddDoubleLine("This Week", format("%d runs", #weeklyRuns))

  sort(weeklyRuns, sortByLevel)

  -- The top 8 runs count towards the vault
  for i = 1, math.min(#weeklyRuns, 8) do
    local run = weeklyRuns[i]
    local name = C_ChallengeMode.GetMapUIInfo(run.mapChallengeModeID) or ""
    local level = F.String.KeystoneLevel(format("+%d", run.level), run.level)
    DT.tooltip:AddDoubleLine(run.completed and name or F.String.Muted(name), level, 1, 1, 1)
  end
end

function WK:AddDungeonScores(summary)
  local scores = {}

  for _, mapScore in ipairs(summary and summary.runs or {}) do
    scores[mapScore.challengeModeID] = mapScore
  end

  local maps = C_ChallengeMode.GetMapTable()
  if not maps or #maps == 0 then return end

  sort(maps, function(a, b)
    local scoreA, scoreB = scores[a] and scores[a].mapScore or 0, scores[b] and scores[b].mapScore or 0
    return scoreA > scoreB
  end)

  DT.tooltip:AddLine(" ")
  DT.tooltip:AddLine("Dungeon Scores")

  for _, mapID in ipairs(maps) do
    local name = C_ChallengeMode.GetMapUIInfo(mapID) or ""
    local mapScore = scores[mapID]

    if mapScore and mapScore.mapScore > 0 then
      local level = F.String.KeystoneLevel(format("+%d", mapScore.bestRunLevel), mapScore.bestRunLevel)
      DT.tooltip:AddDoubleLine(name, F.String.DungeonMapScore(format("%d", mapScore.mapScore), mapScore.mapScore) .. "  " .. level, 1, 1, 1)
    else
      DT.tooltip:AddDoubleLine(F.String.Muted(name), F.String.Muted("-"), 1, 1, 1)
    end
  end
end

function WK:UpdateTooltip()
  if not self.mouseOver then return end

  local rating, summary = self:GetRating()

  DT.tooltip:ClearLines()
  DT.tooltip:AddDoubleLine("Mythic+", F.String.DungeonScore(format("%d", rating), rating))

  local keystone = self.keystone
  if keystone.level then
    DT.tooltip:AddDoubleLine("Keystone", F.String.KeystoneLevel(format("+%d %s", keystone.level, keystone.name), keystone.level), 1, 1, 1)
  else
    DT.tooltip:AddDoubleLine("Keystone", F.String.Muted("None"), 1, 1, 1)
  end

  local keyInfo = C_CurrencyInfo.GetCurrencyInfo(Constants.DelvesConsts.DELVES_NORMAL_KEY_CURRENCY_ID)
  if keyInfo and keyInfo.name then DT.tooltip:AddDoubleLine(keyInfo.name, format("%d", keyInfo.quantity), 1, 1, 1, 1, 1, 1) end

  self:AddVaultLines()
  self:AddWeeklyRuns()

  if self.db.showDungeonScores then self:AddDungeonScores(summary) end

  DT.tooltip:AddLine(" ")
  DT.tooltip:AddLine("|cffFFFFFFLeft Click:|r Toggle Great Vault")
  if keystone.level then DT.tooltip:AddLine("|cffFFFFFFShift-Left Click:|r Link Keystone") end
  if keystone.teleport and IsSpellKnownOrOverridesKnown(keystone.teleport.id) then
    DT.tooltip:AddLine("|cffFFFFFFRight Click:|r Teleport to " .. keystone.name)
    DT.tooltip:AddLine("|cffFFFFFFShift-Right Click:|r Open Mythic+ Teleports Menu")
  else
    DT.tooltip:AddLine("|cffFFFFFFRight Click:|r Open Mythic+ Teleports Menu")
  end

  DT.tooltip:Show()
end

function WK:OnEvent(event)
  -- Key changes arrive in bag update bursts, coalesce them
  if event == "BAG_UPDATE_DELAYED" then
    if self.updatePending then return end
    self.updatePending = true

    E:Delay(1, function()
      self.updatePending = false
      self:OnEvent("ELVUI_FORCE_UPDATE")
    end)

    return
  end

  local previousMap, previousLevel = self.keystone.mapID, self.keystone.level
  self:UpdateKeystone()

  if self.keystone.mapID ~= previousMap or self.keystone.level ~= previousLevel then self:UpdateSecureAttributes() end

  -- Flash once when new vault rewards became available
  local hasRewards = C_WeeklyRewards.HasAvailableRewards()
  if hasRewards and not self.hadRewards and event ~= "ELVUI_FORCE_UPDATE" then
    WB:FlashFontOnEvent(self.weeklyText)
    WB:FlashFontOnEvent(self.weeklyIcon, true)
  end
  self.hadRewards = hasRewards

  self:UpdateText()
  self:UpdateTooltip()
end

do
  local tooltipElapsed = 0

  -- Vault item levels load asynchronously, refresh the tooltip while hovering
  function WK:OnUpdate(elapsed)
    if not self.mouseOver then return end

    tooltipElapsed = tooltipElapsed + elapsed
    if tooltipElapsed < 1 then return end

    tooltipElapsed = 0
    self:UpdateTooltip()
  end
end

function WK:OnEnter()
  self.mouseOver = true
  self:UpdateColor()
  self:UpdateTooltip()
end

function WK:OnLeave()
  self.mouseOver = false
  self:UpdateColor()
end

function WK:OnWunderBarUpdate()
  self.flyoutDirection = E.db.TXUI.wunderbar.general.position == "TOP" and "DOWN" or "UP"

  self:UpdateFonts()
  self:UpdateColor()
  self:UpdateElements()
  self:UpdateKeystone()
  self:UpdateText()
  self:UpdateSecureAttributes()
end

function WK:UpdateColor()
  if self.mouseOver then
    WB:SetFontAccentColor(self.weeklyText)
    if self.db.showIcon then WB:SetFontAccentColor(self.weeklyIcon) end
  else
    WB:SetFontNormalColor(self.weeklyText)
    if self.db.showIcon then WB:SetFontIconColor(self.weeklyIcon) end
  end
end

function WK:UpdateFonts()
  WB:SetFontFromDB(nil, nil, self.weeklyText)
  WB:SetIconFromDB(self.db, "icon", self.weeklyIcon)
end

function WK:UpdateElements()
  local anchorPoint = WB:GetGrowDirection(self.Module, true)
  local iconSize = self.db.showIcon and self.db.iconFontSize or 1

  self.weeklyText:ClearAllPoints()
  self.weeklyIcon:ClearAllPoints()
  self.weeklyIcon:SetJustifyH("RIGHT")

  if anchorPoint == "RIGHT" then
    self.weeklyText:SetJustifyH("RIGHT")
    self.weeklyText:SetPoint("RIGHT", self.frame, "RIGHT", 0, 0)
  else
    self.weeklyText:SetJustifyH("LEFT")
    self.weeklyText:SetPoint("LEFT", self.frame, "LEFT", (iconSize + 5), 0)
  end

  self.weeklyIcon:SetPoint("RIGHT", self.weeklyText, "LEFT", -5, 0)

  if self.db.showIcon then
    self.weeklyIcon:Show()
  else
    self.weeklyIcon:Hide()
  end
end

function WK:CreateText()
  local secureFrame = CreateFrame("Button", nil, self.frame, "SecureActionButtonTemplate")
  secureFrame:ClearAllPoints()
  secureFrame:SetAllPoints()
  secureFrame:EnableMouse(true)
  secureFrame:RegisterForClicks(GetCVarBool("ActionButtonUseKeyDown") and "AnyDown" or "AnyUp")

  self:HookScript(secureFrame, "OnEnter", function(...)
    WB:ModuleOnEnter(self, ...)
  end)

  self:HookScript(secureFrame, "OnLeave", function(...)
    WB:ModuleOnLeave(self, ...)
  end)

  self.secureFrame = secureFrame

  self.weeklyIcon = secureFrame:CreateFontString(nil, "OVERLAY")
  self.weeklyText = secureFrame:CreateFontString(nil, "OVERLAY")
  self.weeklyIcon:SetPoint("CENTER")
  self.weeklyText:SetPoint("CENTER")
end

function WK:OnInit()
  -- Get our settings DB
  self.db = WB:GetSubModuleDB(self:GetName())

  -- Don't init second time
  if self.Initialized then return end

  -- Vars
  self.frame = self.SubModuleHolder
  self.mouseOver = false
  self.keystone = {}

  -- Ask the server for map & score data, like the Great Vault does
  C_MythicPlus.RequestMapInfo()

  self:CreateText()
  self:OnWunderBarUpdate()

  -- We are done, hooray!
  self.Initialized = true
end

WB:RegisterSubModule(WK, {
  "BAG_UPDATE_DELAYED",
  "CHALLENGE_MODE_COMPLETED",
  "CHALLENGE_MODE_MAPS_UPDATE",
  "MYTHIC_PLUS_NEW_WEEKLY_RECORD",
  "WEEKLY_REWARDS_ITEM_CHANGED",
  "WEEKLY_REWARDS_UPDATE",
})
