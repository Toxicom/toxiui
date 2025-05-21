local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local M = TXUI:GetModule("Misc")

local CreateFrame = CreateFrame
local GameMenuFrame = GameMenuFrame

function M:GameMenuButton()
  -- Don't init if its not a TXUI profile or requirements are not met
  if not TXUI:HasRequirements(I.Requirements.GameMenuButton) then return end

  -- Don't do anything if disabled
  if not E.db.TXUI.addons.gameMenuSkin.enabled then return end

  -- Background Fade
  if E.db.TXUI.addons.gameMenuSkin.enabled then
    self.gamemenudb = E.db.TXUI.addons.gameMenuSkin
    -- helper for margin value
    local m = function(num)
      return num * 4
    end

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
      collections.mount:SetPoint("TOPLEFT", collections, "BOTTOMLEFT", 0, m(-6))
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
      mythic.keystone:SetPoint("TOPLEFT", mythic, "BOTTOMLEFT", 0, m(-6))
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

    backgroundFade.Animation = TXUI:CreateAnimationGroup(backgroundFade):CreateAnimation("Fade")
    backgroundFade.Animation:SetEasing("out-quintic")
    backgroundFade.Animation:SetChange(1)
    backgroundFade.Animation:SetDuration(1)

    self.backgroundFade = backgroundFade
    self.collections = collections
    self.mythic = mythic
    self.backgroundFade:Hide()
  end

  -- Hook show event cause blizzard resizes the menu
  self:SecureHookScript(GameMenuFrame, "OnShow", function()
    if self.backgroundFade and self.backgroundFade.Animation then
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
end

M:AddCallback("GameMenuButton")
