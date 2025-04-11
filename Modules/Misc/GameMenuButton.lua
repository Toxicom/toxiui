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
    backgroundFade.logo:Point("TOP", 0, -100)

    local primaryFont = F.GetFontPath(I.Fonts.Primary)
    local titleFont = F.GetFontPath(I.Fonts.TitleRaid)

    -- Player information texts
    if E.db.TXUI.addons.gameMenuSkin.showInfo then
      -- Bottom text promotion
      backgroundFade.bottomText = backgroundFade:CreateFontString(nil, "OVERLAY")
      backgroundFade.bottomText:Point("BOTTOM", 0, 100)
      backgroundFade.bottomText:SetFont(primaryFont, F.FontSizeScaled(14), "OUTLINE")
      backgroundFade.bottomText:SetTextColor(1, 1, 1, 0.6)
      backgroundFade.bottomText:SetText("You can find all the relevant " ..
        TXUI.Title .. " information at " .. I.Strings.Branding.Links.Website)

      -- Player Name
      backgroundFade.nameText = backgroundFade:CreateFontString(nil, "OVERLAY")
      backgroundFade.nameText:SetPoint("TOP", backgroundFade.logo, "BOTTOM", 0, -30)
      backgroundFade.nameText:SetFont(titleFont, F.FontSizeScaled(28), "OUTLINE")
      backgroundFade.nameText:SetTextColor(1, 1, 1, 1)
      backgroundFade.nameText:SetText(F.String.GradientClass(E.myname))

      -- Player Guild
      backgroundFade.guildText = backgroundFade:CreateFontString(nil, "OVERLAY")
      backgroundFade.guildText:SetPoint("TOP", backgroundFade.nameText, "BOTTOM", 0, 0)
      backgroundFade.guildText:SetFont(primaryFont, F.FontSizeScaled(16), "OUTLINE")
      backgroundFade.guildText:SetTextColor(1, 1, 1, 1)

      backgroundFade.specIcon = backgroundFade:CreateFontString(nil, "OVERLAY")
      backgroundFade.specIcon:SetPoint("TOP", backgroundFade.guildText, "BOTTOM", 0, -24)

      backgroundFade.levelText = backgroundFade:CreateFontString(nil, "OVERLAY")
      backgroundFade.levelText:SetPoint("RIGHT", backgroundFade.specIcon, "LEFT", -4, 0)
      backgroundFade.levelText:SetFont(primaryFont, F.FontSizeScaled(20), "OUTLINE")
      backgroundFade.levelText:SetTextColor(1, 1, 1, 1)

      backgroundFade.classText = backgroundFade:CreateFontString(nil, "OVERLAY")
      backgroundFade.classText:SetPoint("LEFT", backgroundFade.specIcon, "RIGHT", 4, 0)
      backgroundFade.classText:SetFont(primaryFont, F.FontSizeScaled(20), "OUTLINE")
      backgroundFade.classText:SetTextColor(1, 1, 1, 1)
    end

    -- Random tip
    if E.db.TXUI.addons.gameMenuSkin.showTips then
      backgroundFade.tipText = backgroundFade:CreateFontString(nil, "OVERLAY")
      if backgroundFade.specIcon then
        backgroundFade.tipText:SetPoint("TOP", backgroundFade.specIcon, "BOTTOM", 0, -24)
      else
        backgroundFade.tipText:SetPoint("TOP", backgroundFade.logo, "BOTTOM", 0, -30)
      end
      backgroundFade.tipText:SetFont(primaryFont, F.FontSizeScaled(16), "OUTLINE")
      backgroundFade.tipText:SetTextColor(1, 1, 1, 1)

      backgroundFade.tipText:SetWidth(700)
    end

    if E.db.TXUI.addons.gameMenuSkin.showCollections then
      collections = backgroundFade:CreateFontString(nil, "OVERLAY")
      collections:Point("TOPLEFT", 100, -100)
      collections:SetFont(titleFont, F.FontSizeScaled(24), "OUTLINE")
      collections:SetTextColor(1, 1, 1, 1)
      collections:SetText(F.String.GradientClass("Collections"))

      -- Mounts
      collections.mount = backgroundFade:CreateFontString(nil, "OVERLAY")
      collections.mount:SetPoint("TOPLEFT", collections, "BOTTOMLEFT", 0, -24)
      collections.mount:SetFont(primaryFont, F.FontSizeScaled(16), "OUTLINE")
      collections.mount:SetTextColor(1, 1, 1, 1)
      collections.mount:SetText("Mounts: " .. F.String.ToxiUI(collectedMounts))

      -- Toys
      collections.toys = backgroundFade:CreateFontString(nil, "OVERLAY")
      collections.toys:SetPoint("TOPLEFT", collections.mount, "BOTTOMLEFT", 0, -4)
      collections.toys:SetFont(primaryFont, F.FontSizeScaled(16), "OUTLINE")
      collections.toys:SetTextColor(1, 1, 1, 1)
      collections.toys:SetText("Toys: " .. F.String.ToxiUI(C_ToyBox.GetNumLearnedDisplayedToys()))

      -- Pets
      local _, petsOwned = C_PetJournal.GetNumPets()
      collections.pets = backgroundFade:CreateFontString(nil, "OVERLAY")
      collections.pets:SetPoint("TOPLEFT", collections.toys, "BOTTOMLEFT", 0, -4)
      collections.pets:SetFont(primaryFont, F.FontSizeScaled(16), "OUTLINE")
      collections.pets:SetTextColor(1, 1, 1, 1)
      collections.pets:SetText("Pets: " .. F.String.ToxiUI(petsOwned))

      -- Achievements
      collections.achievs = backgroundFade:CreateFontString(nil, "OVERLAY")
      collections.achievs:SetPoint("TOPLEFT", collections.pets, "BOTTOMLEFT", 0, -12)
      collections.achievs:SetFont(primaryFont, F.FontSizeScaled(16), "OUTLINE")
      collections.achievs:SetTextColor(1, 1, 1, 1)
    end

    if E.db.TXUI.addons.gameMenuSkin.showMythic and UnitLevel("player") >= I.MaxLevelTable[TXUI.MetaFlavor] then
      mythic = backgroundFade:CreateFontString(nil, "OVERLAY")
      if E.db.TXUI.addons.gameMenuSkin.showCollections then
        -- Last item of collections
        mythic:Point("TOPLEFT", collections.achievs, "BOTTOMLEFT", 0, -48)
      else
        mythic:Point("TOPLEFT", 100, -100)
      end
      mythic:SetFont(titleFont, F.FontSizeScaled(24), "OUTLINE")
      mythic:SetTextColor(1, 1, 1, 1)
      mythic:SetText(F.String.GradientClass("Mythic+"))

      -- Mythic+ history
      mythic.history1 = backgroundFade:CreateFontString(nil, "OVERLAY")
      mythic.history1:SetPoint("TOPLEFT", mythic, "BOTTOMLEFT", 0, -24)
      mythic.history1:SetFont(primaryFont, F.FontSizeScaled(16), "OUTLINE")
      mythic.history1:SetTextColor(1, 1, 1, 1)
      mythic.history1:SetText("1: " .. F.String.ToxiUI("N/A"))

      mythic.history2 = backgroundFade:CreateFontString(nil, "OVERLAY")
      mythic.history2:SetPoint("TOPLEFT", mythic.history1, "BOTTOMLEFT", 0, -4)
      mythic.history2:SetFont(primaryFont, F.FontSizeScaled(16), "OUTLINE")
      mythic.history2:SetTextColor(1, 1, 1, 1)
      mythic.history2:SetText("2: " .. F.String.ToxiUI("N/A"))

      mythic.history3 = backgroundFade:CreateFontString(nil, "OVERLAY")
      mythic.history3:SetPoint("TOPLEFT", mythic.history2, "BOTTOMLEFT", 0, -4)
      mythic.history3:SetFont(primaryFont, F.FontSizeScaled(16), "OUTLINE")
      mythic.history3:SetTextColor(1, 1, 1, 1)
      mythic.history3:SetText("3: " .. F.String.ToxiUI("N/A"))

      mythic.history4 = backgroundFade:CreateFontString(nil, "OVERLAY")
      mythic.history4:SetPoint("TOPLEFT", mythic.history3, "BOTTOMLEFT", 0, -4)
      mythic.history4:SetFont(primaryFont, F.FontSizeScaled(16), "OUTLINE")
      mythic.history4:SetTextColor(1, 1, 1, 1)
      mythic.history4:SetText("4: " .. F.String.ToxiUI("N/A"))

      -- Mythic+ keystone
      mythic.keystone = backgroundFade:CreateFontString(nil, "OVERLAY")
      mythic.keystone:SetPoint("TOPLEFT", mythic.history4, "BOTTOMLEFT", 0, -12)
      mythic.keystone:SetFont(primaryFont, F.FontSizeScaled(16), "OUTLINE")
      mythic.keystone:SetTextColor(1, 1, 1, 1)
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

        self.backgroundFade.guildText:SetText(guildName and
          F.String.FastGradientHex("<" .. guildName .. ">", "06c910", "33ff3d") or "")
        self.backgroundFade.specIcon:SetText(specIcon)
        self.backgroundFade.levelText:SetText("Lv " .. E.mylevel)
        self.backgroundFade.classText:SetText(F.String.GradientClass(E.myLocalizedClass, nil, true))
      end

      if self.collections then
        self.collections.achievs:SetText("Achievement Points: " ..
          F.String.ToxiUI(E:FormatLargeNumber(GetTotalAchievementPoints(), ",")))
      end

      if self.mythic then
        -- Update M+ history
        local history = C_MythicPlus.GetRunHistory(false)

        table.sort(history, function(a, b)
          return a.completedTimestamp > b.completedTimestamp
        end)

        for i = 1, 4 do -- this could be configurable
          local historyFrame = self.mythic["history" .. i]
          if historyFrame then
            local historyRun = history[i]
            local historyText
            local historyTextPrefix = i .. ": "
            if historyRun then
              local historyDungeonName = C_ChallengeMode.GetMapUIInfo(historyRun.mapChallengeModeID)
              historyText = ("%s (+%d)"):format(historyDungeonName, historyRun.level)
            else
              historyText = "N/A"
            end

            historyFrame:SetText(historyTextPrefix .. F.String.ToxiUI(historyText))
          end
        end

        -- Update keystone text
        local keystoneMapID = C_MythicPlus.GetOwnedKeystoneChallengeMapID()
        local keystoneLevel = C_MythicPlus.GetOwnedKeystoneLevel()
        local keystoneTextPrefix = "Current Keystone: "
        if keystoneMapID and keystoneMapID > 0 then
          local keystoneDungeonName = C_ChallengeMode.GetMapUIInfo(keystoneMapID)
          self.mythic.keystone:SetText(keystoneTextPrefix ..
            F.String.ToxiUI(("%s (+%d)"):format(keystoneDungeonName, keystoneLevel)))
        else
          self.mythic.keystone:SetText(keystoneTextPrefix .. F.String.ToxiUI("N/A"))
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
        local year = date("%Y")         -- yyyy eg 2023
        local ToxiBirthday = monthDate == "01/06"
        local ToxiUiBirthday = monthDate == "10/18"
        local ToxiUiAge = year - 2020
        local holidays = { ["12/24"] = true, ["12/25"] = true, ["12/26"] = true }
        local holidayString = holidays[monthDate] and "\n\nThe " .. TXUI.Title .. " team wishes you Happy Holidays!" or
            ""
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
            "Did you know that today, October 18th, is " ..
            TXUI.Title .. "'s birthday? " .. TXUI.Title .. " is now " .. ToxiUiAge .. " years old!"
          )
        else
          self.backgroundFade.tipText:SetText(F.String.ToxiUI("Random tip #" .. randomIndex .. ": ") ..
            randomTip .. holidayString)
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
