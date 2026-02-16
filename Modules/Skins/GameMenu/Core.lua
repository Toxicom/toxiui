local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local GM = TXUI:NewModule("GameMenu", "AceHook-3.0", "AceEvent-3.0")

local CreateFrame = CreateFrame
local GameMenuFrame = GameMenuFrame

function GM:Enable()
  if self.isEnabled then return end
  self.isEnabled = true

  local outerSpacing = 100

  -- Cache fonts for section files
  self.primaryFont = F.GetFontPath(I.Fonts.Primary)
  self.titleFont = F.GetFontPath(I.Fonts.TitleRaid)

  -- Background fade frame
  local backgroundFade = CreateFrame("Frame", nil, E.UIParent)
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

  self.backgroundFade = backgroundFade
  self.outerSpacing = outerSpacing

  -- Create sections based on DB settings
  if self.db.showInfo then self:CreatePlayerInfo() end
  if self.db.showTips then self:CreateTips() end
  if self.db.showCollections then self:CreateCollections() end
  if self.db.showMythic and UnitLevel("player") >= I.MaxLevelTable[TXUI.MetaFlavor] then self:CreateMythic() end
  if self.db.showPlayed then self:CreatePlayed() end

  -- Animation
  backgroundFade.Animation = TXUI:CreateAnimationGroup(backgroundFade):CreateAnimation("Fade")
  backgroundFade.Animation:SetEasing("out-quintic")
  backgroundFade.Animation:SetChange(1)
  backgroundFade.Animation:SetDuration(1)

  backgroundFade:Hide()

  -- OnShow hook
  self:SecureHookScript(GameMenuFrame, "OnShow", function()
    if not (self.backgroundFade and self.backgroundFade.Animation) then return end

    -- Background color
    local alpha = self.db.bgColor.a
    local bgColor = self.db.classColor.enabled and E:ClassColor(E.myclass, true) or self.db.bgColor
    self.backgroundFade.bg:SetVertexColor(bgColor.r, bgColor.g, bgColor.b, alpha)

    -- Update sections (each guards with nil check)
    self:UpdatePlayerInfo()
    self:UpdateCollections()
    self:UpdateMythic()
    self:ReanchorPlayed()
    self:UpdatePlayed()
    self:UpdateTips()

    -- Animate in
    self.backgroundFade:Show()
    self.backgroundFade.Animation:Stop()
    self.backgroundFade:SetAlpha(0)
    self.backgroundFade.Animation:Play()
  end)

  -- OnHide hook
  self:SecureHookScript(GameMenuFrame, "OnHide", function()
    if self.backgroundFade then self.backgroundFade:Hide() end
  end)

  -- Request /played on login
  self:RegisterEvent("PLAYER_ENTERING_WORLD", "OnPlayerEnteringWorld")
end

function GM:Disable()
  if not self.isEnabled then return end
  self.isEnabled = false

  self:UnhookAll()

  if self.backgroundFade then
    self.backgroundFade:Hide()
  end
end

function GM:DatabaseUpdate()
  self.db = F.GetDBFromPath("TXUI.addons.gameMenuSkin")

  F.Event.ContinueOutOfCombat(function()
    self:Disable()

    if not TXUI:HasRequirements(I.Requirements.GameMenu) then return end
    if not self.db or not self.db.enabled then return end

    self:Enable()
  end)
end

function GM:Initialize()
  if self.Initialized then return end

  self.isEnabled = false

  F.Event.RegisterOnceCallback("TXUI.InitializedSafe", F.Event.GenerateClosure(self.DatabaseUpdate, self))
  F.Event.RegisterCallback("TXUI.DatabaseUpdate", self.DatabaseUpdate, self)

  self.Initialized = true
end

TXUI:RegisterModule(GM:GetName())
