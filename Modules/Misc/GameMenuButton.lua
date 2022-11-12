local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local M = TXUI:GetModule("Misc")

local _G = _G
local CreateFrame = CreateFrame
local GameMenuButtonLogout = _G.GameMenuButtonLogout
local GameMenuFrame = GameMenuFrame
local HideUIPanel = HideUIPanel
local InCombatLockdown = InCombatLockdown
local IsAddOnLoaded = IsAddOnLoaded
local LibStub = LibStub

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

  -- ! Personal changes
  if F.IsDeveloper() then
    local backgroundFade = CreateFrame("Frame", nil, buttonHolder, "BackdropTemplate")
    backgroundFade:SetAllPoints(E.UIParent)
    backgroundFade:SetParent(GameMenuFrame)
    backgroundFade:SetFrameStrata("BACKGROUND")
    backgroundFade:SetFrameLevel(0)

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
      buttonHolder.backgroundFade.Animation:Stop()
      buttonHolder.backgroundFade:SetAlpha(0)
      buttonHolder.backgroundFade.Animation:Play()
    end
  end)

  -- Register button
  GameMenuFrame["GameMenu_TXUI"] = button
end

M:AddCallback("GameMenuButton")
