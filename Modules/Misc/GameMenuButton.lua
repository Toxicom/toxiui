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

    -- Player information texts
    if E.db.TXUI.addons.gameMenuSkin.showInfo then
      local primaryFont = F.GetFontPath(I.Fonts.Primary)
      local titleFont = F.GetFontPath(I.Fonts.TitleRaid)

      -- Bottom text promotion
      backgroundFade.bottomText = backgroundFade:CreateFontString(nil, "OVERLAY")
      backgroundFade.bottomText:Point("BOTTOM", 0, 100)
      backgroundFade.bottomText:SetFont(primaryFont, F.FontSizeScaled(14), "OUTLINE")
      backgroundFade.bottomText:SetTextColor(1, 1, 1, 0.6)
      backgroundFade.bottomText:SetText("你可以在 " .. TXUI.Title .. " 的官方网站找到所有相关信息: " .. I.Strings.Branding.Links.Website)

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
      backgroundFade.specIcon:SetPoint("TOP", backgroundFade.guildText, "BOTTOM", 0, -25)

      backgroundFade.levelText = backgroundFade:CreateFontString(nil, "OVERLAY")
      backgroundFade.levelText:SetPoint("RIGHT", backgroundFade.specIcon, "LEFT", -4, 0)
      backgroundFade.levelText:SetFont(primaryFont, F.FontSizeScaled(20), "OUTLINE")
      backgroundFade.levelText:SetTextColor(1, 1, 1, 1)

      backgroundFade.classText = backgroundFade:CreateFontString(nil, "OVERLAY")
      backgroundFade.classText:SetPoint("LEFT", backgroundFade.specIcon, "RIGHT", 4, 0)
      backgroundFade.classText:SetFont(primaryFont, F.FontSizeScaled(20), "OUTLINE")
      backgroundFade.classText:SetTextColor(1, 1, 1, 1)

      if E.db.TXUI.addons.gameMenuSkin.showCollections then
        collections = backgroundFade:CreateFontString(nil, "OVERLAY")
        collections:Point("TOPLEFT", 100, -100)
        collections:SetFont(titleFont, F.FontSizeScaled(24), "OUTLINE")
        collections:SetTextColor(1, 1, 1, 1)
        collections:SetText(F.String.GradientClass("收藏"))

        collections.mount = backgroundFade:CreateFontString(nil, "OVERLAY")
        collections.mount:SetPoint("TOPLEFT", collections, "BOTTOMLEFT", 0, -25)
        collections.mount:SetFont(primaryFont, F.FontSizeScaled(16), "OUTLINE")
        collections.mount:SetTextColor(1, 1, 1, 1)
        collections.mount:SetText("坐骑: " .. F.String.ToxiUI(collectedMounts))

        collections.toys = backgroundFade:CreateFontString(nil, "OVERLAY")
        collections.toys:SetPoint("TOPLEFT", collections.mount, "BOTTOMLEFT", 0, -4)
        collections.toys:SetFont(primaryFont, F.FontSizeScaled(16), "OUTLINE")
        collections.toys:SetTextColor(1, 1, 1, 1)
        collections.toys:SetText("玩具: " .. F.String.ToxiUI(C_ToyBox.GetNumLearnedDisplayedToys()))

        local _, petsOwned = C_PetJournal.GetNumPets()
        collections.pets = backgroundFade:CreateFontString(nil, "OVERLAY")
        collections.pets:SetPoint("TOPLEFT", collections.toys, "BOTTOMLEFT", 0, -4)
        collections.pets:SetFont(primaryFont, F.FontSizeScaled(16), "OUTLINE")
        collections.pets:SetTextColor(1, 1, 1, 1)
        collections.pets:SetText("宠物: " .. F.String.ToxiUI(petsOwned))

        collections.achievs = backgroundFade:CreateFontString(nil, "OVERLAY")
        collections.achievs:SetPoint("TOPLEFT", collections.pets, "BOTTOMLEFT", 0, -12)
        collections.achievs:SetFont(primaryFont, F.FontSizeScaled(16), "OUTLINE")
        collections.achievs:SetTextColor(1, 1, 1, 1)
        collections.achievs:SetText("成就点数: " .. F.String.ToxiUI(E:FormatLargeNumber(GetTotalAchievementPoints(), ",")))
      end

      -- Random tip
      if E.db.TXUI.addons.gameMenuSkin.showTips then
        backgroundFade.tipText = backgroundFade:CreateFontString(nil, "OVERLAY")
        backgroundFade.tipText:SetPoint("TOP", backgroundFade.specIcon, "BOTTOM", 0, -25)
        backgroundFade.tipText:SetFont(primaryFont, F.FontSizeScaled(16), "OUTLINE")
        backgroundFade.tipText:SetTextColor(1, 1, 1, 1)

        backgroundFade.tipText:SetWidth(700)
      end
    end

    backgroundFade.Animation = TXUI:CreateAnimationGroup(backgroundFade):CreateAnimation("Fade")
    backgroundFade.Animation:SetEasing("out-quintic")
    backgroundFade.Animation:SetChange(1)
    backgroundFade.Animation:SetDuration(1)

    self.backgroundFade = backgroundFade
    self.collections = collections
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

      if self.collections then self.collections.achievs:SetText("成就点数: " .. F.String.ToxiUI(E:FormatLargeNumber(GetTotalAchievementPoints(), ","))) end

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
        local holidayString = holidays[monthDate] and "\n\n" .. TXUI.Title .. " 团队祝你节日快乐!" or ""
        -- let's call it an easter egg
        if ToxiBirthday then
          self.backgroundFade.tipText:SetText(
            "你知道吗，今天是1月6日，是 " .. F.String.ToxiUI("Toxi") .. " 的生日?\n" .. F.String.ToxiUI("有趣的事实:") .. " 第一版 " .. TXUI.Title .. " 安装程序是在2021年的今天发布的!"
          )
        elseif ToxiUiBirthday then
          self.backgroundFade.tipText:SetText(
            "你知道吗，今天是10月18日，是 " .. TXUI.Title .. " 的生日? " .. TXUI.Title .. " 现在已经 " .. ToxiUiAge .. " 岁了!"
          )
        else
          self.backgroundFade.tipText:SetText(F.String.ToxiUI("随机提示 #" .. randomIndex .. ": ") .. randomTip .. holidayString)
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
