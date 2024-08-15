local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local M = TXUI:GetModule("Misc")
local WB = TXUI:GetModule("WunderBar")
local SS = WB:GetModule("SpecSwitch")

local CreateFrame = CreateFrame
local GameMenuFrame = GameMenuFrame
local GetSpecialization = GetSpecialization
local GetSpecializationInfoForClassID = GetSpecializationInfoForClassID

function M:GameMenuButton()
  -- Don't init if its not a TXUI profile or requirements are not met
  if not TXUI:HasRequirements(I.Requirements.GameMenuButton) then return end

  -- Don't do anything if disabled
  if not E.db.TXUI.addons.gameMenuButton.enabled then return end

  -- Background Fade
  if E.db.TXUI.addons.gameMenuButton.backgroundFade.enabled then
    local backgroundFade = CreateFrame("Frame", nil, E.UIParent, "BackdropTemplate")
    backgroundFade:SetAllPoints(E.UIParent)
    backgroundFade:SetFrameStrata("HIGH")
    backgroundFade:SetFrameLevel(GameMenuFrame:GetFrameLevel() - 1)
    backgroundFade:EnableMouse(true)

    local bgColor

    if E.db.TXUI.addons.gameMenuButton.backgroundFade.classColor.enabled then
      bgColor = E:ClassColor(E.myclass, true)
    else
      bgColor = E.db.TXUI.addons.gameMenuButton.backgroundFade.color
    end

    backgroundFade.bg = backgroundFade:CreateTexture(nil, "BACKGROUND")
    backgroundFade.bg:SetAllPoints(backgroundFade)
    backgroundFade.bg:SetTexture(I.Media.Textures["ToxiUI-clean"])
    backgroundFade.bg:SetVertexColor(bgColor.r, bgColor.g, bgColor.b, 0.2)

    backgroundFade.logo = backgroundFade:CreateTexture(nil, "OVERLAY")
    backgroundFade.logo:Size(256, 128)
    backgroundFade.logo:SetTexture(I.Media.Logos.Logo)
    backgroundFade.logo:Point("TOP", 0, -100)

    -- Player information texts
    if E.db.TXUI.addons.gameMenuButton.backgroundFade.showInfo then
      local primaryFont = F.GetFontPath(I.Fonts.Primary)
      local titleFont = F.GetFontPath(I.Fonts.TitleRaid)

      -- Bottom text promotion
      backgroundFade.bottomText = backgroundFade:CreateFontString(nil, "OVERLAY")
      backgroundFade.bottomText:Point("BOTTOM", 0, 100)
      backgroundFade.bottomText:SetFont(primaryFont, F.FontSizeScaled(14), "OUTLINE")
      backgroundFade.bottomText:SetTextColor(1, 1, 1, 0.6)
      backgroundFade.bottomText:SetText("You can find all the relevant " .. TXUI.Title .. " information at " .. I.Strings.Branding.Links.Website)

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

      -- Random tip
      if E.db.TXUI.addons.gameMenuButton.backgroundFade.showTips then
        -- I have a suspicion that if it's defined outside it can cause gradient issues, not sure
        local randomTips = I.Constants.RandomTips

        local randomIndex = math.random(1, #randomTips)
        -- For debugging
        -- randomIndex = 4
        local randomTip = randomTips[randomIndex]

        local monthDate = date("%m/%d") -- mm/dd eg 10/24 (oct 24)
        local year = date("%Y") -- yyyy eg 2023
        local ToxiBirthday = monthDate == "01/06"
        local ToxiUiBirthday = monthDate == "10/18"
        local ToxiUiAge = year - 2020
        local holidays = { ["12/24"] = true, ["12/25"] = true, ["12/26"] = true }
        local holidayString = holidays[monthDate] and "\n\nThe " .. TXUI.Title .. " team wishes you Happy Holidays!" or ""

        backgroundFade.tipText = backgroundFade:CreateFontString(nil, "OVERLAY")
        backgroundFade.tipText:SetPoint("TOP", backgroundFade.levelText, "BOTTOM", 0, -25)
        backgroundFade.tipText:SetFont(primaryFont, F.FontSizeScaled(16), "OUTLINE")
        backgroundFade.tipText:SetTextColor(1, 1, 1, 1)

        -- let's call it an easter egg
        if ToxiBirthday then
          backgroundFade.tipText:SetText(
            "Did you know that today, January 6th, is "
              .. F.String.ToxiUI("Toxi")
              .. "'s birthday?\n"
              .. F.String.ToxiUI("Fun fact:")
              .. " First version of the "
              .. TXUI.Title
              .. " installer was released on this day back in 2021!"
          )
        elseif ToxiUiBirthday then
          backgroundFade.tipText:SetText("Did you know that today, October 18th, is " .. TXUI.Title .. "'s birthday? " .. TXUI.Title .. " is now " .. ToxiUiAge .. " years old!")
        else
          backgroundFade.tipText:SetText(F.String.ToxiUI("Random tip #" .. randomIndex .. ": ") .. randomTip .. holidayString)
        end

        backgroundFade.tipText:SetWidth(600)
      end
    end

    backgroundFade.Animation = TXUI:CreateAnimationGroup(backgroundFade):CreateAnimation("Fade")
    backgroundFade.Animation:SetEasing("out-quintic")
    backgroundFade.Animation:SetChange(1)
    backgroundFade.Animation:SetDuration(1)
    backgroundFade:SetTemplate("Transparent")

    self.backgroundFade = backgroundFade
    self.backgroundFade:Hide()
  end

  -- Hook show event cause blizzard resizes the menu
  self:SecureHookScript(GameMenuFrame, "OnShow", function()
    if self.backgroundFade and self.backgroundFade.Animation then
      if self.backgroundFade.guildText and self.backgroundFade.levelText then
        local guildName = GetGuildInfo("player")

        local fallback = M.SpecIcons and M.SpecIcons[0] or ""
        local specIcon
        local iconPath = self:GetClassIconPath(E.db.TXUI.addons.gameMenuButton.backgroundFade.specIconStyle or "ToxiSpecStylized")
        local iconsFont = F.GetFontPath(I.Fonts.Icons)

        if TXUI.IsRetail then
          local _, classId = UnitClassBase("player")
          local specIndex = GetSpecialization()
          local id = GetSpecializationInfoForClassID(classId, specIndex)

          if id and M.SpecIcons then specIcon = format(iconPath, M.SpecIcons[id]) end
        else
          local spec
          local talents = GetActiveTalentGroup()

          if talents then spec = SS:GetWrathCacheForSpec(talents) end

          if spec.id and M.SpecIcons then specIcon = format(iconPath, M.SpecIcons[spec.id]) end
        end

        F.Log.Dev(specIcon)

        self.backgroundFade.specIcon:SetFont(iconsFont, F.FontSizeScaled(E.db.TXUI.addons.gameMenuButton.backgroundFade.specIconSize), "")
        self.backgroundFade.specIcon:SetTextColor(1, 1, 1, 1)

        self.backgroundFade.guildText:SetText(guildName and F.String.FastGradientHex("<" .. guildName .. ">", "06c910", "33ff3d") or "")
        self.backgroundFade.specIcon:SetText(specIcon and specIcon or fallback)
        self.backgroundFade.levelText:SetText("Lv " .. E.mylevel)
        self.backgroundFade.classText:SetText(F.String.GradientClass(E.myLocalizedClass, nil, true))
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
