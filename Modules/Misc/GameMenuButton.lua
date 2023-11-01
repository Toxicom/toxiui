local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local M = TXUI:GetModule("Misc")
local WB = TXUI:GetModule("WunderBar")
local SS = WB:GetModule("SpecSwitch")

local _G = _G
local CreateFrame = CreateFrame
local GameMenuButtonLogout = _G.GameMenuButtonLogout
local GameMenuFrame = GameMenuFrame
local HideUIPanel = HideUIPanel
local InCombatLockdown = InCombatLockdown
local IsAddOnLoaded = IsAddOnLoaded
local LibStub = LibStub
local GetSpecialization = GetSpecialization
local GetSpecializationInfoForClassID = GetSpecializationInfoForClassID

function M:GameMenuButton_ADDON_LOADED(addonName)
  if addonName ~= "ElvUI_SLE" then return end

  local GM = LibStub("LibElv-GameMenu-1.0")
  if not GM then return self:LogDebug("GameMenuButton_ADDON_LOADED > GM is nil") end

  GM:AddMenuButton {
    ["name"] = "TXUI_GAME_BUTTON",
    ["text"] = TXUI.Title,
    ["func"] = function()
      E:ToggleOptions("TXUI")
      if not InCombatLockdown() then HideUIPanel(GameMenuFrame) end
    end,
  }

  GM:UpdateHolder()
end

function M:GameMenuButton()
  -- Don't init if its not a TXUI profile or requirements are not met
  if not TXUI:HasRequirements(I.Requirements.GameMenuButton) then return end

  -- Don't do anything if disabled
  if not E.db.TXUI.addons.gameMenuButton.enabled then return end

  -- Skip own logic and use lib
  if F.IsAddOnEnabled("ElvUI_SLE") then
    local _, isFinished = IsAddOnLoaded("ElvUI_SLE")

    if isFinished then
      self:GameMenuButton_ADDON_LOADED("ElvUI_SLE")
    else
      self:RegisterEvent("ADDON_LOADED", "GameMenuButton_ADDON_LOADED", self)
    end

    return
  end

  -- Vars
  local buttonWidth, buttonHeight = GameMenuButtonLogout:GetSize()

  local db = E.db.TXUI.wunderbar.subModules["SpecSwitch"].icons

  -- ToxiUI Button Holder
  local buttonHolder = CreateFrame("Frame", nil, GameMenuFrame)
  buttonHolder:SetSize(buttonWidth, buttonHeight)
  buttonHolder:SetPoint("TOP", GameMenuFrame[E.name], "BOTTOM", 0, -1)

  -- ToxiUI Button
  local button = CreateFrame("Button", nil, GameMenuFrame, "GameMenuButtonTemplate, BackdropTemplate")
  button:SetPoint("TOPLEFT", buttonHolder, "TOPLEFT", 0, 0)
  button:SetSize(buttonWidth, buttonHeight)
  button:SetText(TXUI.Title)
  button:SetScript("OnClick", function()
    E:ToggleOptions("TXUI")
    if not InCombatLockdown() then HideUIPanel(GameMenuFrame) end
  end)

  -- Skin if skinning is active
  if E.private.skins.blizzard.enable and E.private.skins.blizzard.misc then E:GetModule("Skins"):HandleButton(button) end

  -- Background Fade
  if E.db.TXUI.addons.gameMenuButton.backgroundFade.enabled then
    local backgroundFade = CreateFrame("Frame", nil, buttonHolder, "BackdropTemplate")
    backgroundFade:SetAllPoints(E.UIParent)
    backgroundFade:SetParent(GameMenuFrame)
    backgroundFade:SetFrameStrata("BACKGROUND")
    backgroundFade:SetFrameLevel(0)

    local bgColor

    if E.db.TXUI.addons.gameMenuButton.backgroundFade.classColor.enabled then
      -- Custom Colors for priest
      if E.myclass == "PRIEST" then
        bgColor = I.PriestColors
      else
        bgColor = E:ClassColor(E.myclass, true)
      end
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

      -- Player Level & Class
      backgroundFade.levelText = backgroundFade:CreateFontString(nil, "OVERLAY")
      backgroundFade.levelText:SetPoint("TOP", backgroundFade.guildText, "BOTTOM", 0, -25)
      backgroundFade.levelText:SetFont(primaryFont, F.FontSizeScaled(20), "OUTLINE")
      backgroundFade.levelText:SetTextColor(1, 1, 1, 1)

      -- Random tip
      if E.db.TXUI.addons.gameMenuButton.backgroundFade.showTips then
        -- I have a suspicion that if it's defined outside it can cause gradient issues, not sure
        local randomTips = {
          TXUI.Title .. " has three different themes to choose from. You can swap to Normal mode or Dark Mode in " .. TXUI.Title .. " Themes settings",
          "The bar at the bottom is called WunderBar. It is heavily customizable and you can play around with it in " .. TXUI.Title .. " settings",
          "There is a "
            .. TXUI.Title
            .. " website that has a lot of useful information and also articles about what's happening in "
            .. TXUI.Title
            .. "! Check it out at "
            .. F.String.ToxiUI(I.Strings.Branding.Links.Website),
          "There is a " --
            .. TXUI.Title
            .. " Discord server if you ever need help or just want to chat! Check out the "
            .. TXUI.Title
            .. " settings "
            .. F.String.Class("Contacts", "DRUID")
            .. " tab for links.",
          "The same " .. TXUI.Title .. " AddOn can be installed on all three versions: Retail, Wrath of the Lich King & Classic Era",
          "The first version of "
            .. TXUI.Title
            .. " was released on "
            .. F.String.GradientClass("October 18, 2020")
            .. " and the Discord server was created a week later, on "
            .. F.String.GradientClass("October 24, 2020"),
          "If you want to support " .. TXUI.Title .. " visit the " .. TXUI.Title .. " website's FAQ page at " .. I.Strings.Branding.Links.Website .. "/faq/",
          "You can change Gradient colors in " .. TXUI.Title .. " Theme settings",
          TXUI.Title
            .. " like many other AddOns is being constantly updated. Remember to update your AddOns every day! See the changelog in "
            .. TXUI.Title
            .. " settings to find out what's new",
          "To easily manage your AddOns all in one client, we recommend using the CurseForge version of " .. F.String.ToxiUI("WowUp.io"),
          "Keeping your Action Bars hidden and relying on WeakAuras will improve your gameplay and remove unnecessary clutter from your screen!",
          "All UnitFrame texts are Custom Texts. To edit them go to ElvUI UnitFrame settings -> Select which unit -> Custom Texts. "
            .. F.String.GradientClass("Class Icons")
            .. " are also Custom Texts!",
          "Most elements are hidden until you hover over them with your mouse. One example of that is the Pet ActionBar, which is under your Player UnitFrame.",
          "If you're finding some UI elements too small, check out the "
            .. F.String.Scaling()
            .. " in "
            .. TXUI.Title
            .. " settings. If an element is missing, let us know and we might add it!",
          "These tips change each time you reload your UI or log in. Make sure to check them out since we keep adding new ones. Never know when you might learn something new! ;)",
        }

        -- local randomIndex = math.random(1, #randomTips)
        -- For debugging
        local randomIndex = 12
        local randomTip = randomTips[randomIndex]

        backgroundFade.tipText = backgroundFade:CreateFontString(nil, "OVERLAY")
        backgroundFade.tipText:SetPoint("TOP", backgroundFade.levelText, "BOTTOM", 0, -25)
        backgroundFade.tipText:SetFont(primaryFont, F.FontSizeScaled(16), "OUTLINE")
        backgroundFade.tipText:SetTextColor(1, 1, 1, 1)
        backgroundFade.tipText:SetText(F.String.ToxiUI("Random tip #" .. randomIndex .. ": ") .. randomTip)
        backgroundFade.tipText:SetWidth(600)
      end
    end

    backgroundFade.Animation = TXUI:CreateAnimationGroup(backgroundFade):CreateAnimation("Fade")
    backgroundFade.Animation:SetEasing("out-quintic")
    backgroundFade.Animation:SetChange(1)
    backgroundFade.Animation:SetDuration(1)
    backgroundFade:SetTemplate("Transparent")

    buttonHolder.backgroundFade = backgroundFade
  end

  -- Hook show event cause blizzard resizes the menu
  self:SecureHookScript(GameMenuFrame, "OnShow", function()
    GameMenuButtonLogout:ClearAllPoints()
    GameMenuButtonLogout:SetPoint("TOP", buttonHolder, "BOTTOM", 0, -buttonHeight)
    GameMenuFrame:SetHeight(GameMenuFrame:GetHeight() + GameMenuButtonLogout:GetHeight() + 4)

    if buttonHolder.backgroundFade and buttonHolder.backgroundFade.Animation then
      if buttonHolder.backgroundFade.guildText and buttonHolder.backgroundFade.levelText then
        local guildName = GetGuildInfo("player")

        local specIcon = db and db[0] or ""

        if TXUI.IsRetail then
          local _, classId = UnitClassBase("player")
          local specIndex = GetSpecialization()
          local id = GetSpecializationInfoForClassID(classId, specIndex)

          if id and db then specIcon = db[id] end
        else
          local spec
          local talents = GetActiveTalentGroup()

          if talents then spec = SS:GetWrathCacheForSpec(talents) end

          if spec.id and db then specIcon = db[spec.id] end
        end

        buttonHolder.backgroundFade.guildText:SetText(guildName and F.String.FastGradientHex("<" .. guildName .. ">", "06c910", "33ff3d") or "")
        buttonHolder.backgroundFade.levelText:SetText("Lv " .. E.mylevel .. " " .. F.String.GradientClass(specIcon .. " " .. E.myLocalizedClass, nil, true))
      end
      buttonHolder.backgroundFade.Animation:Stop()
      buttonHolder.backgroundFade:SetAlpha(0)
      buttonHolder.backgroundFade.Animation:Play()
    end
  end)

  -- Register button
  GameMenuFrame["GameMenu_TXUI"] = button
end

M:AddCallback("GameMenuButton")
