local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local M = TXUI:GetModule("Misc")

local CreateFrame = CreateFrame
local GameMenuFrame = GameMenuFrame

-- Spacing helper available across init and show hook
local function m(num)
  return num * 4
end

local function FormatPlayed(seconds, colorize)
  if not seconds or seconds <= 0 then return "N/A" end

  if colorize == nil then colorize = true end

  local minutesTotal = math.floor(seconds / 60)
  local hoursTotal = math.floor(minutesTotal / 60)
  local daysTotal = math.floor(hoursTotal / 24)

  local years = math.floor(daysTotal / 365)
  local daysAfterYears = daysTotal % 365
  local months = math.floor(daysAfterYears / 30)
  local days = daysAfterYears % 30
  local hours = hoursTotal % 24
  local minutes = minutesTotal % 60

  local function unit(n, singular, plural)
    local label = (n == 1) and singular or plural
    local num = tostring(n)
    if colorize then num = F.String.ToxiUI(num) end
    return num .. " " .. label
  end

  if years > 0 then
    if months > 0 then return unit(years, "Year", "Years") .. ", " .. unit(months, "Month", "Months") end
    if days > 0 then return unit(years, "Year", "Years") .. ", " .. unit(days, "Day", "Days") end
    if hours > 0 then return unit(years, "Year", "Years") .. ", " .. unit(hours, "Hour", "Hours") end
    return unit(years, "Year", "Years") .. ", " .. unit(minutes, "Minute", "Minutes")
  end

  if months > 0 then
    if days > 0 then return unit(months, "Month", "Months") .. ", " .. unit(days, "Day", "Days") end
    if hours > 0 then return unit(months, "Month", "Months") .. ", " .. unit(hours, "Hour", "Hours") end
    return unit(months, "Month", "Months") .. ", " .. unit(minutes, "Minute", "Minutes")
  end

  if days > 0 then
    if hours > 0 then return unit(days, "Day", "Days") .. ", " .. unit(hours, "Hour", "Hours") end
    return unit(days, "Day", "Days") .. ", " .. unit(minutes, "Minute", "Minutes")
  end

  if hours > 0 then return unit(hours, "Hour", "Hours") .. ", " .. unit(minutes, "Minute", "Minutes") end

  if minutes > 0 then return unit(minutes, "Minute", "Minutes") end

  return "Less than a minute"
end

-- Sum all stored played seconds across all characters/realms
local function GetTotalPlayedAll()
  local total = 0
  local played = (E.global.TXUI and E.global.TXUI.playedSeconds) or {}
  for _, realmMap in pairs(played) do
    for _, seconds in pairs(realmMap) do
      if seconds and seconds > 0 then total = total + seconds end
    end
  end
  return total
end

function M:OnTimePlayed(_, totalTimePlayed, levelTimePlayed)
  self.totalTimePlayed = totalTimePlayed
  self.levelTimePlayed = levelTimePlayed
  if self.played and self.played.total then
    -- Update UI using sum across all characters
    local sumAll = GetTotalPlayedAll() + (totalTimePlayed or 0)
    self.played.total:SetText("Total: " .. FormatPlayed(sumAll))
  end

  -- Persist per-character seconds in ElvUI account-wide DB under TXUI
  E.global.TXUI = E.global.TXUI or {}
  E.global.TXUI.playedSeconds = E.global.TXUI.playedSeconds or {}
  E.global.TXUI.playedSeconds[E.myrealm] = E.global.TXUI.playedSeconds[E.myrealm] or {}
  E.global.TXUI.playedSeconds[E.myrealm][E.myname] = totalTimePlayed
  -- Ensure class mapping exists for this character
  E.global.TXUI.classMap = E.global.TXUI.classMap or {}
  E.global.TXUI.classMap[E.myrealm] = E.global.TXUI.classMap[E.myrealm] or {}
  E.global.TXUI.classMap[E.myrealm][E.myname] = E.myclass

  -- Only handle once per login request
  self:UnregisterEvent("TIME_PLAYED_MSG")
end

function M:OnPlayerEnteringWorld(_, isLogin, isReloadingUI)
  -- Prepare persistent store for session start per character
  E.global.TXUI = E.global.TXUI or {}
  E.global.TXUI.sessionStartEpoch = E.global.TXUI.sessionStartEpoch or {}
  E.global.TXUI.sessionStartEpoch[E.myrealm] = E.global.TXUI.sessionStartEpoch[E.myrealm] or {}

  if not self._playedRequested then
    self._playedRequested = true
    self:RegisterEvent("TIME_PLAYED_MSG", "OnTimePlayed")
    RequestTimePlayed()
  end

  if isLogin then
    -- Start a fresh session only on initial login
    local now = time()
    self.sessionStartEpoch = now
    E.global.TXUI.sessionStartEpoch[E.myrealm][E.myname] = now
  elseif isReloadingUI then
    -- On UI reload, restore the session start so the timer continues
    local saved = E.global.TXUI.sessionStartEpoch[E.myrealm][E.myname]
    if saved and saved > 0 then self.sessionStartEpoch = saved end
    -- Do NOT request /played on reload; keep it to initial login only
  else
    -- Neither initial login nor reload (failsafe); try to restore if available
    local saved = E.global.TXUI.sessionStartEpoch[E.myrealm][E.myname]
    if saved and saved > 0 then self.sessionStartEpoch = saved end
  end
end

local function AggregatePlayedByClass()
  local totals = {}
  local classes = (E.global.TXUI and E.global.TXUI.classMap) or {}
  local played = (E.global.TXUI and E.global.TXUI.playedSeconds) or {}

  for realm, classMap in pairs(classes) do
    local playedRealm = played[realm]
    if playedRealm then
      for name, classToken in pairs(classMap) do
        local seconds = playedRealm[name]
        if seconds and seconds > 0 then totals[classToken] = (totals[classToken] or 0) + seconds end
      end
    end
  end

  local list = {}
  for classToken, seconds in pairs(totals) do
    table.insert(list, { class = classToken, seconds = seconds })
  end
  table.sort(list, function(a, b)
    return a.seconds > b.seconds
  end)
  return list
end

function M:BuildPlayedGraph()
  if not self.played or not self.backgroundFade then return end

  -- Create container once
  if not self.played.graph then
    local graph = CreateFrame("Frame", nil, self.backgroundFade)
    graph:SetPoint("TOPLEFT", (self.played.session or self.played.total), "BOTTOMLEFT", 0, m(-6))
    graph:SetSize(700, 1) -- height will grow as bars are added
    self.played.graph = graph
    self.played.graph.bars = {}
  end

  local graph = self.played.graph
  -- Clear previous bars
  for _, bar in ipairs(graph.bars) do
    bar:Hide()
  end
  wipe(graph.bars)

  local aggregated = AggregatePlayedByClass()
  if #aggregated == 0 then return end

  local maxSeconds = aggregated[1].seconds
  local maxWidth = 240
  local barHeight = 16
  local spacing = m(-2)

  -- Color maps for class gradients
  local fgMap = F.Color.GetMap("classColorMap")
  local normalMap = fgMap and fgMap[I.Enum.GradientMode.Color.NORMAL]
  local shiftMap = fgMap and fgMap[I.Enum.GradientMode.Color.SHIFT]

  local yOffset = 0
  for _, item in ipairs(aggregated) do
    local barFrame = CreateFrame("Frame", nil, graph)
    -- Increase left inset so the icon aligns better with other sections
    barFrame:SetPoint("TOPLEFT", graph, "TOPLEFT", 24, yOffset)
    barFrame:SetSize(maxWidth, barHeight)

    -- Transparent black backdrop covering full bar width
    local bg = barFrame:CreateTexture(nil, "BACKGROUND")
    bg:SetPoint("LEFT", barFrame, "LEFT", 0, 0)
    bg:SetSize(maxWidth, barHeight)
    bg:SetColorTexture(0, 0, 0, 0.33)

    -- ToxiUI class icon to the left (FontString with icon texture markup)
    local iconFS = barFrame:CreateFontString(nil, "OVERLAY")
    iconFS:SetPoint("RIGHT", barFrame, "LEFT", -4, 0)
    -- Set a font before using texture markup to avoid FontString:SetText errors
    iconFS:SetFont(F.GetFontPath(I.Fonts.Primary), F.FontSizeScaled(barHeight + 2), "")
    -- Force ToxiUI class icon pack to ensure consistency
    local iconTheme = "ToxiClasses"
    local iconMarkup = string.format(M:GetClassIconPath(iconTheme), M.ClassIcons[item.class] or M.ClassIcons[E.myclass])
    -- Downscale the icon from 32x32 to barHeight x barHeight for alignment
    iconMarkup = iconMarkup:gsub("32:32", tostring(barHeight + 2) .. ":" .. tostring(barHeight + 2))
    iconFS:SetText(iconMarkup)

    -- Gradient bar texture sized by proportion
    local width = math.max(2, math.floor((item.seconds / maxSeconds) * maxWidth))
    local tex = barFrame:CreateTexture(nil, "ARTWORK")
    tex:SetPoint("LEFT", barFrame, "LEFT", 0, 0)
    tex:SetSize(width, barHeight)
    tex:SetColorTexture(1, 1, 1, 1)

    local start = shiftMap and shiftMap[item.class] or CreateColor(0.3, 0.3, 0.3, 1)
    local finish = normalMap and normalMap[item.class] or CreateColor(0.6, 0.6, 0.6, 1)
    F.Color.SetGradient(tex, "HORIZONTAL", start, finish)

    -- No class name; layout is ICON | BAR | DURATION

    -- Total time after the bar (outside, to the right)
    local totalFS = barFrame:CreateFontString(nil, "OVERLAY")
    totalFS:SetPoint("LEFT", barFrame, "RIGHT", 8, 0)
    totalFS:SetJustifyH("LEFT")
    totalFS:SetFont(F.GetFontPath(I.Fonts.Primary), F.FontSizeScaled(13), "OUTLINE")
    totalFS:SetTextColor(1, 1, 1, 1)
    totalFS:SetText(FormatPlayed(item.seconds, false))

    table.insert(graph.bars, barFrame)
    barFrame:Show()
    yOffset = yOffset - (barHeight - spacing)
  end

  -- Resize container height to fit bars
  graph:SetHeight(-yOffset + barHeight)
end

function M:GameMenuButton()
  -- Don't init if its not a TXUI profile or requirements are not met
  if not TXUI:HasRequirements(I.Requirements.GameMenuButton) then return end

  -- Don't do anything if disabled
  if not E.db.TXUI.addons.gameMenuSkin.enabled then return end

  -- Background Fade
  if E.db.TXUI.addons.gameMenuSkin.enabled then
    self.gamemenudb = E.db.TXUI.addons.gameMenuSkin

    local outerSpacing = 100

    local collectedMounts = 0
    if TXUI.IsRetail then
      if E.MountIDs then
        for _, value in pairs(E.MountIDs) do
          local _, _, _, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetMountInfoByID(value)
          if isCollected then collectedMounts = collectedMounts + 1 end
        end
      end
    end

    local backgroundFade = CreateFrame("Frame", nil, E.UIParent)
    local collections
    local mythic
    local played

    backgroundFade:SetAllPoints(E.UIParent)
    backgroundFade:SetFrameStrata("HIGH")
    backgroundFade:SetFrameLevel(GameMenuFrame:GetFrameLevel() - 1)
    backgroundFade:EnableMouse(true)

    backgroundFade.bg = backgroundFade:CreateTexture(nil, "BACKGROUND")
    backgroundFade.bg:SetAllPoints(backgroundFade)
    backgroundFade.bg:SetTexture(I.Media.Textures["ToxiUI-clean"])

    backgroundFade.logo = backgroundFade:CreateTexture(nil, "OVERLAY")
    backgroundFade.logo:Size(256, 128)
    backgroundFade.logo:SetTexture(I.Media.Logos.Logo)
    backgroundFade.logo:Point("TOP", 0, -outerSpacing)

    local primaryFont = F.GetFontPath(I.Fonts.Primary)
    local titleFont = F.GetFontPath(I.Fonts.TitleRaid)

    -- Player information texts
    if self.gamemenudb.showInfo then
      -- Bottom text promotion
      backgroundFade.bottomText = backgroundFade:CreateFontString(nil, "OVERLAY")
      backgroundFade.bottomText:Point("BOTTOM", 0, outerSpacing)
      backgroundFade.bottomText:SetFont(primaryFont, F.FontSizeScaled(14), "OUTLINE")
      backgroundFade.bottomText:SetTextColor(1, 1, 1, 0.6)
      backgroundFade.bottomText:SetText("You can find all the relevant " .. TXUI.Title .. " information at " .. I.Strings.Branding.Links.Website)

      -- Player Name
      backgroundFade.nameText = backgroundFade:CreateFontString(nil, "OVERLAY")
      backgroundFade.nameText:SetPoint("TOP", backgroundFade.logo, "BOTTOM", 0, m(-8))
      backgroundFade.nameText:SetFont(titleFont, F.FontSizeScaled(28), "OUTLINE")
      backgroundFade.nameText:SetTextColor(1, 1, 1, 1)
      backgroundFade.nameText:SetText(F.String.GradientClass(E.myname))

      -- Player Guild
      backgroundFade.guildText = backgroundFade:CreateFontString(nil, "OVERLAY")
      backgroundFade.guildText:SetPoint("TOP", backgroundFade.nameText, "BOTTOM", 0, 0)
      backgroundFade.guildText:SetFont(primaryFont, F.FontSizeScaled(16), "OUTLINE")
      backgroundFade.guildText:SetTextColor(1, 1, 1, 1)

      backgroundFade.specIcon = backgroundFade:CreateFontString(nil, "OVERLAY")
      backgroundFade.specIcon:SetPoint("TOP", backgroundFade.guildText, "BOTTOM", 0, m(-6))

      backgroundFade.levelText = backgroundFade:CreateFontString(nil, "OVERLAY")
      backgroundFade.levelText:SetPoint("RIGHT", backgroundFade.specIcon, "LEFT", m(-1), 0)
      backgroundFade.levelText:SetFont(primaryFont, F.FontSizeScaled(20), "OUTLINE")
      backgroundFade.levelText:SetTextColor(1, 1, 1, 1)

      backgroundFade.classText = backgroundFade:CreateFontString(nil, "OVERLAY")
      backgroundFade.classText:SetPoint("LEFT", backgroundFade.specIcon, "RIGHT", m(1), 0)
      backgroundFade.classText:SetFont(primaryFont, F.FontSizeScaled(20), "OUTLINE")
      backgroundFade.classText:SetTextColor(1, 1, 1, 1)
    end

    -- Random tip
    if self.gamemenudb.showTips then
      backgroundFade.tipText = backgroundFade:CreateFontString(nil, "OVERLAY")
      if backgroundFade.specIcon then
        backgroundFade.tipText:SetPoint("TOP", backgroundFade.specIcon, "BOTTOM", 0, m(-6))
      else
        backgroundFade.tipText:SetPoint("TOP", backgroundFade.logo, "BOTTOM", 0, m(-8))
      end
      backgroundFade.tipText:SetFont(primaryFont, F.FontSizeScaled(16), "OUTLINE")
      backgroundFade.tipText:SetTextColor(1, 1, 1, 1)

      backgroundFade.tipText:SetWidth(700)
    end

    if self.gamemenudb.showCollections then
      collections = backgroundFade:CreateFontString(nil, "OVERLAY")
      collections:Point("TOPLEFT", outerSpacing, -outerSpacing)
      collections:SetFont(titleFont, F.FontSizeScaled(24), "OUTLINE")
      collections:SetTextColor(1, 1, 1, 1)
      collections:SetText(F.String.GradientClass("Collections"))

      -- Mounts
      collections.mount = backgroundFade:CreateFontString(nil, "OVERLAY")
      collections.mount:SetPoint("TOPLEFT", collections, "BOTTOMLEFT", 0, m(-4))
      collections.mount:SetFont(primaryFont, F.FontSizeScaled(16), "OUTLINE")
      collections.mount:SetTextColor(1, 1, 1, 1)
      collections.mount:SetText("Mounts: " .. F.String.ToxiUI(collectedMounts))

      -- Toys
      collections.toys = backgroundFade:CreateFontString(nil, "OVERLAY")
      collections.toys:SetPoint("TOPLEFT", collections.mount, "BOTTOMLEFT", 0, m(-1))
      collections.toys:SetFont(primaryFont, F.FontSizeScaled(16), "OUTLINE")
      collections.toys:SetTextColor(1, 1, 1, 1)
      collections.toys:SetText("Toys: " .. F.String.ToxiUI(C_ToyBox.GetNumLearnedDisplayedToys()))

      -- Pets
      collections.pets = backgroundFade:CreateFontString(nil, "OVERLAY")
      collections.pets:SetPoint("TOPLEFT", collections.toys, "BOTTOMLEFT", 0, m(-1))
      collections.pets:SetFont(primaryFont, F.FontSizeScaled(16), "OUTLINE")
      collections.pets:SetTextColor(1, 1, 1, 1)

      -- Achievements
      collections.achievs = backgroundFade:CreateFontString(nil, "OVERLAY")
      collections.achievs:SetPoint("TOPLEFT", collections.pets, "BOTTOMLEFT", 0, m(-3))
      collections.achievs:SetFont(primaryFont, F.FontSizeScaled(16), "OUTLINE")
      collections.achievs:SetTextColor(1, 1, 1, 1)
    end

    if self.gamemenudb.showMythic and UnitLevel("player") >= I.MaxLevelTable[TXUI.MetaFlavor] then
      mythic = backgroundFade:CreateFontString(nil, "OVERLAY")
      if self.gamemenudb.showCollections then
        -- Last item of collections
        mythic:Point("TOPLEFT", collections.achievs, "BOTTOMLEFT", 0, m(-12))
      else
        mythic:Point("TOPLEFT", outerSpacing, -outerSpacing)
      end
      mythic:SetFont(titleFont, F.FontSizeScaled(24), "OUTLINE")
      mythic:SetTextColor(1, 1, 1, 1)
      mythic:SetText(F.String.GradientClass("Mythic+"))

      -- Mythic+ keystone
      mythic.keystone = backgroundFade:CreateFontString(nil, "OVERLAY")
      mythic.keystone:SetPoint("TOPLEFT", mythic, "BOTTOMLEFT", 0, m(-4))
      mythic.keystone:SetFont(primaryFont, F.FontSizeScaled(16), "OUTLINE")
      mythic.keystone:SetTextColor(1, 1, 1, 1)

      -- Mythic+ score
      if self.gamemenudb.showMythicScore then
        mythic.score = backgroundFade:CreateFontString(nil, "OVERLAY")
        mythic.score:SetPoint("TOPLEFT", mythic.keystone, "BOTTOMLEFT", 0, m(-1))
        mythic.score:SetFont(primaryFont, F.FontSizeScaled(16), "OUTLINE")
        mythic.score:SetTextColor(1, 1, 1, 1)
      end

      -- Mythic+ history
      mythic.latestRuns = backgroundFade:CreateFontString(nil, "OVERLAY")
      mythic.latestRuns:SetPoint("TOPLEFT", self.gamemenudb.showMythicScore and mythic.score or mythic.keystone, "BOTTOMLEFT", 0, m(-4))
      mythic.latestRuns:SetFont(titleFont, F.FontSizeScaled(18), "OUTLINE")

      -- 10 = max history limit
      for i = 1, 10 do
        mythic["history" .. i] = backgroundFade:CreateFontString(nil, "OVERLAY")
        mythic["history" .. i]:SetFont(primaryFont, F.FontSizeScaled(16), "OUTLINE")
        mythic["history" .. i]:SetTextColor(1, 1, 1, 1)

        if i == 1 then
          mythic["history" .. i]:SetPoint("TOPLEFT", mythic.latestRuns, "BOTTOMLEFT", 0, m(-2))
        else
          mythic["history" .. i]:SetPoint("TOPLEFT", mythic["history" .. (i - 1)], "BOTTOMLEFT", 0, m(-1))
        end
      end
    end

    -- Played section
    if self.gamemenudb.showPlayed then
      played = backgroundFade:CreateFontString(nil, "OVERLAY")
      if mythic then
        played:Point("TOPLEFT", mythic["history10"], "BOTTOMLEFT", 0, m(-12))
      elseif self.gamemenudb.showCollections and collections and collections.achievs then
        played:Point("TOPLEFT", collections.achievs, "BOTTOMLEFT", 0, m(-12))
      else
        played:Point("TOPLEFT", outerSpacing, -outerSpacing)
      end
      played:SetFont(titleFont, F.FontSizeScaled(24), "OUTLINE")
      played:SetTextColor(1, 1, 1, 1)
      played:SetText(F.String.GradientClass("Played"))

      played.total = backgroundFade:CreateFontString(nil, "OVERLAY")
      played.session = backgroundFade:CreateFontString(nil, "OVERLAY")

      -- Session first (top), then Total under it
      played.session:SetPoint("TOPLEFT", played, "BOTTOMLEFT", 0, m(-4))
      played.session:SetFont(primaryFont, F.FontSizeScaled(16), "OUTLINE")
      played.session:SetTextColor(1, 1, 1, 1)
      played.session:SetText("Session: " .. F.String.ToxiUI("Loading…"))

      played.total:SetPoint("TOPLEFT", played.session, "BOTTOMLEFT", 0, m(-1))
      played.total:SetFont(primaryFont, F.FontSizeScaled(16), "OUTLINE")
      played.total:SetTextColor(1, 1, 1, 1)
      played.total:SetText("Total: " .. F.String.ToxiUI("Loading…"))
    end

    backgroundFade.Animation = TXUI:CreateAnimationGroup(backgroundFade):CreateAnimation("Fade")
    backgroundFade.Animation:SetEasing("out-quintic")
    backgroundFade.Animation:SetChange(1)
    backgroundFade.Animation:SetDuration(1)

    self.backgroundFade = backgroundFade
    self.collections = collections
    self.mythic = mythic
    self.played = played
    self.backgroundFade:Hide()
  end

  -- Hook show event cause blizzard resizes the menu
  self:SecureHookScript(GameMenuFrame, "OnShow", function()
    if self.backgroundFade and self.backgroundFade.Animation then
      -- Build background and sections
      local bgColor
      local alpha = E.db.TXUI.addons.gameMenuSkin.bgColor.a
      if E.db.TXUI.addons.gameMenuSkin.classColor.enabled then
        bgColor = E:ClassColor(E.myclass, true)
      else
        bgColor = E.db.TXUI.addons.gameMenuSkin.bgColor
      end
      self.backgroundFade.bg:SetVertexColor(bgColor.r, bgColor.g, bgColor.b, alpha)

      if self.backgroundFade.guildText and self.backgroundFade.levelText then
        local guildName = GetGuildInfo("player")
        local specIcon, iconsFont = self:GenerateSpecIcon(E.db.TXUI.addons.gameMenuSkin.specIconStyle)

        self.backgroundFade.specIcon:SetFont(iconsFont, F.FontSizeScaled(E.db.TXUI.addons.gameMenuSkin.specIconSize), "")
        self.backgroundFade.specIcon:SetTextColor(1, 1, 1, 1)

        self.backgroundFade.guildText:SetText(guildName and F.String.FastGradientHex("<" .. guildName .. ">", "06c910", "33ff3d") or "")
        self.backgroundFade.specIcon:SetText(specIcon)
        self.backgroundFade.levelText:SetText("Lv " .. E.mylevel)
        self.backgroundFade.classText:SetText(F.String.GradientClass(E.myLocalizedClass, nil, true))
      end

      if self.collections then
        local _, petsOwned = C_PetJournal.GetNumPets()
        self.collections.pets:SetText("Pets: " .. F.String.ToxiUI(petsOwned))
        self.collections.achievs:SetText("Achievement Points: " .. F.String.ToxiUI(E:FormatLargeNumber(GetTotalAchievementPoints(), ",")))
      end

      if self.mythic then
        -- Update keystone text
        do
          local keystoneMapID = C_MythicPlus.GetOwnedKeystoneChallengeMapID()
          local keystoneLevel = C_MythicPlus.GetOwnedKeystoneLevel()
          local keystoneTextPrefix = "Current Keystone: "

          local text

          if keystoneMapID and keystoneMapID > 0 then
            local dungeonName = C_ChallengeMode.GetMapUIInfo(keystoneMapID) or "Unknown"
            local colorObj = C_ChallengeMode.GetKeystoneLevelRarityColor(keystoneLevel)
            local levelText = "+" .. keystoneLevel

            -- Safely get hex color
            local levelColored = levelText
            if colorObj and colorObj.GenerateHexColor then levelColored = F.String.Color(levelText, colorObj:GenerateHexColor()) end

            text = keystoneTextPrefix .. F.String.ToxiUI(dungeonName .. " (" .. levelColored .. ")")
          else
            text = keystoneTextPrefix .. F.String.ToxiUI("N/A")
          end

          self.mythic.keystone:SetText(text)
        end

        -- Update Mythic+ score
        do
          if self.gamemenudb.showMythicScore then
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
        end

        -- Update M+ history
        do
          local history = C_MythicPlus.GetRunHistory(false, true)
          local historyLimit = self.gamemenudb.mythicHistoryLimit
          for i = 1, 10 do
            local historyFrame = self.mythic["history" .. i]
            if historyFrame then
              local historyRun = history[#history - i + 1]
              if historyRun and i <= historyLimit then
                if i == 1 then self.mythic.latestRuns:SetText(F.String.GradientClass("Latest runs")) end

                local historyDungeonName = C_ChallengeMode.GetMapUIInfo(historyRun.mapChallengeModeID) or "Unknown"
                local colorObj = C_ChallengeMode.GetKeystoneLevelRarityColor(historyRun.level)
                local levelText = "+" .. historyRun.level
                local levelColored = levelText
                if colorObj and colorObj.GenerateHexColor then levelColored = F.String.Color(levelText, colorObj:GenerateHexColor()) end
                local output = ("%s (%s)"):format(historyDungeonName, levelColored)
                historyFrame:SetText(historyRun.completed and F.String.Good(output) or F.String.Error(output))
              else
                historyFrame:SetText("")
              end
            end
          end
        end

        -- Re-anchor Played section to the last visible history entry
        if self.played then
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
              -- Session at top, Total below
              self.played.session:ClearAllPoints()
              self.played.session:SetPoint("TOPLEFT", self.played, "BOTTOMLEFT", 0, m(-4))
              self.played.total:ClearAllPoints()
              self.played.total:SetPoint("TOPLEFT", self.played.session, "BOTTOMLEFT", 0, m(-1))
            end
          end
        end
      end

      -- Update Played section from stored /played (requested at login)
      if self.played then
        local sumAll = GetTotalPlayedAll()
        local text = (sumAll and sumAll > 0) and FormatPlayed(sumAll) or F.String.ToxiUI("Loading…")
        self.played.total:SetText("Total: " .. text)
        -- Update session based on elapsed since login
        local sessionSec = (self.sessionStartEpoch and (time() - self.sessionStartEpoch)) or 0
        if self.played.session then
          local sessionText = (sessionSec > 0) and FormatPlayed(sessionSec, true) or F.String.ToxiUI("N/A")
          self.played.session:SetText("Session: " .. sessionText)
        end
        self:BuildPlayedGraph()
      end

      if self.backgroundFade.tipText then
        -- I have a suspicion that if it's defined outside it can cause gradient issues, not sure
        local randomTips = I.Constants.RandomTips

        local randomIndex = math.random(1, #randomTips)
        -- For debugging
        -- randomIndex = 21
        local randomTip = randomTips[randomIndex]

        local monthDate = date("%m/%d") -- mm/dd eg 10/24 (oct 24)
        local year = date("%Y") -- yyyy eg 2023
        local ToxiBirthday = monthDate == "01/06"
        local ToxiUiBirthday = monthDate == "10/18"
        local ToxiUiAge = year - 2020
        local holidays = { ["12/24"] = true, ["12/25"] = true, ["12/26"] = true }
        local holidayString = holidays[monthDate] and "\n\nThe " .. TXUI.Title .. " team wishes you Happy Holidays!" or ""
        -- let's call it an easter egg
        if ToxiBirthday then
          self.backgroundFade.tipText:SetText(
            "Did you know that today, January 6th, is "
              .. F.String.ToxiUI("Toxi")
              .. "'s birthday?\n"
              .. F.String.ToxiUI("Fun fact:")
              .. " First version of the "
              .. TXUI.Title
              .. " installer was released on this day back in 2021!"
          )
        elseif ToxiUiBirthday then
          self.backgroundFade.tipText:SetText(
            "Did you know that today, October 18th, is " .. TXUI.Title .. "'s birthday? " .. TXUI.Title .. " is now " .. ToxiUiAge .. " years old!"
          )
        else
          self.backgroundFade.tipText:SetText(F.String.ToxiUI("Random tip #" .. randomIndex .. ": ") .. randomTip .. holidayString)
        end
      end

      self.backgroundFade:Show()
      self.backgroundFade.Animation:Stop()
      self.backgroundFade:SetAlpha(0)
      self.backgroundFade.Animation:Play()
    end
  end)

  self:SecureHookScript(GameMenuFrame, "OnHide", function()
    if self.backgroundFade then self.backgroundFade:Hide() end
  end)

  -- Request /played only on initial login
  self:RegisterEvent("PLAYER_ENTERING_WORLD", "OnPlayerEnteringWorld")
end

M:AddCallback("GameMenuButton")
