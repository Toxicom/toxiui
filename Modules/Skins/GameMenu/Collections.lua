local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local GM = TXUI:GetModule("GameMenu")

local m = GM.Spacing

function GM:CreateCollections()
  local parent = self.backgroundFade

  local collections = parent:CreateFontString(nil, "OVERLAY")
  collections:Point("TOPLEFT", self.outerSpacing, -self.outerSpacing)
  collections:SetFont(self.titleFont, F.FontSizeScaled(24), "OUTLINE")
  collections:SetTextColor(1, 1, 1, 1)
  collections:SetText(F.String.GradientClass("Collections"))

  -- Mounts
  collections.mount = parent:CreateFontString(nil, "OVERLAY")
  collections.mount:SetPoint("TOPLEFT", collections, "BOTTOMLEFT", 0, m(-4))
  collections.mount:SetFont(self.primaryFont, F.FontSizeScaled(16), "OUTLINE")
  collections.mount:SetTextColor(1, 1, 1, 1)

  -- Toys
  collections.toys = parent:CreateFontString(nil, "OVERLAY")
  collections.toys:SetPoint("TOPLEFT", collections.mount, "BOTTOMLEFT", 0, m(-1))
  collections.toys:SetFont(self.primaryFont, F.FontSizeScaled(16), "OUTLINE")
  collections.toys:SetTextColor(1, 1, 1, 1)

  -- Pets
  collections.pets = parent:CreateFontString(nil, "OVERLAY")
  collections.pets:SetPoint("TOPLEFT", collections.toys, "BOTTOMLEFT", 0, m(-1))
  collections.pets:SetFont(self.primaryFont, F.FontSizeScaled(16), "OUTLINE")
  collections.pets:SetTextColor(1, 1, 1, 1)

  -- Achievements
  collections.achievs = parent:CreateFontString(nil, "OVERLAY")
  collections.achievs:SetPoint("TOPLEFT", collections.pets, "BOTTOMLEFT", 0, m(-3))
  collections.achievs:SetFont(self.primaryFont, F.FontSizeScaled(16), "OUTLINE")
  collections.achievs:SetTextColor(1, 1, 1, 1)

  self.collections = collections
end

function GM:CreateMythic()
  local parent = self.backgroundFade

  local mythic = parent:CreateFontString(nil, "OVERLAY")
  if self.collections then
    mythic:Point("TOPLEFT", self.collections.achievs, "BOTTOMLEFT", 0, m(-12))
  else
    mythic:Point("TOPLEFT", self.outerSpacing, -self.outerSpacing)
  end
  mythic:SetFont(self.titleFont, F.FontSizeScaled(24), "OUTLINE")
  mythic:SetTextColor(1, 1, 1, 1)
  mythic:SetText(F.String.GradientClass("Mythic+"))

  -- Keystone
  mythic.keystone = parent:CreateFontString(nil, "OVERLAY")
  mythic.keystone:SetPoint("TOPLEFT", mythic, "BOTTOMLEFT", 0, m(-4))
  mythic.keystone:SetFont(self.primaryFont, F.FontSizeScaled(16), "OUTLINE")
  mythic.keystone:SetTextColor(1, 1, 1, 1)

  -- Score
  if self.db.showMythicScore then
    mythic.score = parent:CreateFontString(nil, "OVERLAY")
    mythic.score:SetPoint("TOPLEFT", mythic.keystone, "BOTTOMLEFT", 0, m(-1))
    mythic.score:SetFont(self.primaryFont, F.FontSizeScaled(16), "OUTLINE")
    mythic.score:SetTextColor(1, 1, 1, 1)
  end

  -- History header
  mythic.latestRuns = parent:CreateFontString(nil, "OVERLAY")
  mythic.latestRuns:SetPoint("TOPLEFT", self.db.showMythicScore and mythic.score or mythic.keystone, "BOTTOMLEFT", 0, m(-4))
  mythic.latestRuns:SetFont(self.titleFont, F.FontSizeScaled(18), "OUTLINE")

  -- History entries (10 max)
  for i = 1, 10 do
    mythic["history" .. i] = parent:CreateFontString(nil, "OVERLAY")
    mythic["history" .. i]:SetFont(self.primaryFont, F.FontSizeScaled(16), "OUTLINE")
    mythic["history" .. i]:SetTextColor(1, 1, 1, 1)

    if i == 1 then
      mythic["history" .. i]:SetPoint("TOPLEFT", mythic.latestRuns, "BOTTOMLEFT", 0, m(-2))
    else
      mythic["history" .. i]:SetPoint("TOPLEFT", mythic["history" .. (i - 1)], "BOTTOMLEFT", 0, m(-1))
    end
  end

  self.mythic = mythic
end

function GM:UpdateCollections()
  if not self.collections then return end

  -- Count mounts
  local collectedMounts = 0
  if TXUI.IsRetail and E.MountIDs then
    for _, value in pairs(E.MountIDs) do
      local _, _, _, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetMountInfoByID(value)
      if isCollected then collectedMounts = collectedMounts + 1 end
    end
  end

  self.collections.mount:SetText("Mounts: " .. F.String.ToxiUI(collectedMounts))
  self.collections.toys:SetText("Toys: " .. F.String.ToxiUI(C_ToyBox.GetNumLearnedDisplayedToys()))

  local _, petsOwned = C_PetJournal.GetNumPets()
  self.collections.pets:SetText("Pets: " .. F.String.ToxiUI(petsOwned))
  self.collections.achievs:SetText("Achievement Points: " .. F.String.ToxiUI(E:FormatLargeNumber(GetTotalAchievementPoints(), ",")))
end

function GM:UpdateMythic()
  if not self.mythic then return end

  -- Keystone
  do
    local keystoneMapID = C_MythicPlus.GetOwnedKeystoneChallengeMapID()
    local keystoneLevel = C_MythicPlus.GetOwnedKeystoneLevel()
    local prefix = "Current Keystone: "

    if keystoneMapID and keystoneMapID > 0 then
      local dungeonName = C_ChallengeMode.GetMapUIInfo(keystoneMapID) or "Unknown"
      local colorObj = C_ChallengeMode.GetKeystoneLevelRarityColor(keystoneLevel)
      local levelText = "+" .. keystoneLevel
      local levelColored = levelText
      if colorObj and colorObj.GenerateHexColor then levelColored = F.String.Color(levelText, colorObj:GenerateHexColor()) end
      self.mythic.keystone:SetText(prefix .. F.String.ToxiUI(dungeonName .. " (" .. levelColored .. ")"))
    else
      self.mythic.keystone:SetText(prefix .. F.String.ToxiUI("N/A"))
    end
  end

  -- Score
  if self.db.showMythicScore and self.mythic.score then
    local info = C_PlayerInfo.GetPlayerMythicPlusRatingSummary("player")
    if info.currentSeasonScore then
      local prefix = "M+ Score: "
      local score = info.currentSeasonScore
      if score > 0 then
        local color = C_ChallengeMode.GetDungeonScoreRarityColor(score)
        self.mythic.score:SetText(prefix .. F.String.Color(score, color:GenerateHexColor()))
      else
        self.mythic.score:SetText(prefix .. F.String.ToxiUI("N/A"))
      end
    end
  end

  -- History
  do
    local history = C_MythicPlus.GetRunHistory(false, true)
    local historyLimit = self.db.mythicHistoryLimit
    for i = 1, 10 do
      local historyFrame = self.mythic["history" .. i]
      if historyFrame then
        local historyRun = history[#history - i + 1]
        if historyRun and i <= historyLimit then
          if i == 1 then self.mythic.latestRuns:SetText(F.String.GradientClass("Latest runs")) end

          local dungeonName = C_ChallengeMode.GetMapUIInfo(historyRun.mapChallengeModeID) or "Unknown"
          local colorObj = C_ChallengeMode.GetKeystoneLevelRarityColor(historyRun.level)
          local levelText = "+" .. historyRun.level
          local levelColored = levelText
          if colorObj and colorObj.GenerateHexColor then levelColored = F.String.Color(levelText, colorObj:GenerateHexColor()) end
          local output = ("%s (%s)"):format(dungeonName, levelColored)
          historyFrame:SetText(historyRun.completed and F.String.Good(output) or F.String.Error(output))
        else
          historyFrame:SetText("")
        end
      end
    end
  end
end

-- Re-anchor the Played section below the last visible mythic history entry
function GM:ReanchorPlayed()
  if not self.mythic or not self.played then return end

  local lastIndex = 0
  for i = 1, 10 do
    local f = self.mythic["history" .. i]
    if f and f:GetText() and f:GetText() ~= "" then lastIndex = i end
  end

  local anchor = (lastIndex > 0) and self.mythic["history" .. lastIndex] or self.mythic.latestRuns
  if anchor then
    self.played:ClearAllPoints()
    self.played:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, m(-12))
    if self.played.total and self.played.session then
      self.played.session:ClearAllPoints()
      self.played.session:SetPoint("TOPLEFT", self.played, "BOTTOMLEFT", 0, m(-4))
      self.played.total:ClearAllPoints()
      self.played.total:SetPoint("TOPLEFT", self.played.session, "BOTTOMLEFT", 0, m(-1))
    end
  end
end
