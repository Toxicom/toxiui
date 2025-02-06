local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local AFK = TXUI:NewModule("AFK", "AceHook-3.0", "AceTimer-3.0")
local O = TXUI:GetModule("Options")
local CL = TXUI:GetModule("Changelog")
local M = TXUI:GetModule("Misc")

-- Globals
local CloseAllWindows = CloseAllWindows
local floor = math.floor
local format = string.format
local GetTime = GetTime
local MoveViewLeftStart = MoveViewLeftStart
local MoveViewLeftStop = MoveViewLeftStop
local pairs = pairs
local PVEFrame = PVEFrame
local PVEFrame_ToggleFrame = PVEFrame_ToggleFrame
local random = random
local tinsert = table.insert
local UIParent = UIParent

-- Vars
AFK.randomAnimations = {
  [60] = true, -- EmoteTalk
  [66] = true, -- EmoteBow
  [67] = true, -- EmoteWave
  [68] = true, -- EmoteCheer
  [69] = true, -- EmoteDance
  [70] = true, -- EmoteLaugh
  [71] = true, -- EmoteSleep
  [73] = true, -- EmoteRude
  [74] = true, -- EmoteRoar
  [75] = true, -- EmoteKneel
  [76] = true, -- EmoteKiss
  [77] = true, -- EmoteCry
  [78] = true, -- EmoteChicken
  [79] = true, -- EmoteBeg
  [80] = true, -- EmoteApplaud
  [81] = true, -- EmoteShout
  [82] = true, -- EmoteFlex
  [83] = true, -- EmoteShy
  [84] = true, -- EmotePoint
  [113] = true, -- EmoteSalute
  [185] = true, -- EmoteYes
  [186] = true, -- EmoteNo
  [195] = true, -- EmoteTrain
  [196] = true, -- EmoteDead
  [506] = true, -- EmoteSniff
}

function AFK:ResetPlayedAnimations()
  for animation, _ in pairs(self.randomAnimations) do
    self.randomAnimations[animation] = true
  end
end

function AFK:GetAnimationCount(remaining)
  local count = 0
  for _, enabled in pairs(AFK.randomAnimations) do
    if not remaining or (remaining and enabled) then count = count + 1 end
  end
  return count
end

function AFK:GetAvailableAnimations()
  local availableAnimation = {}

  for randomAnimation, enabled in pairs(self.randomAnimations) do
    if enabled and (self.frame.bottom.model:HasAnimation(randomAnimation)) then tinsert(availableAnimation, randomAnimation) end
  end

  return availableAnimation
end

function AFK:PlayRandomAnimation()
  if not self.elvUIAfk.isAFK then return end

  -- Get not played and animations that the model supports
  local availableAnimation = self:GetAvailableAnimations()

  -- No Animations available, reset all used ones
  if #availableAnimation == 0 then
    self:ResetPlayedAnimations()
    availableAnimation = self:GetAvailableAnimations()
  end

  -- Still no Animation available, don't do anything, try next time
  if #availableAnimation == 0 then
    self:StartAnimationCycle()
    return
  end

  -- Get random animations from the once available
  local newAnimation = availableAnimation[random(1, #availableAnimation)]

  -- Mark animation as played
  self.randomAnimations[newAnimation] = false

  -- Set Animation!
  self.frame.bottom.model:SetAnimation(newAnimation)

  -- Start Timer for next animation
  self:StartAnimationCycle()
end

function AFK:StartAnimationCycle()
  if not self.elvUIAfk.isAFK then return end

  self:CancelTimer(self.animationTimer)
  self.animationTimer = self:ScheduleTimer("PlayRandomAnimation", random(15, 30))
end

function AFK:PlayIdleAnimation()
  self.frame.bottom.model:SetAnimation(0, random(1, 4), 1)
end

function AFK:UpdateTimer()
  local time = GetTime() - self.startTime
  local formattedText = format("%02d:%02d", floor(time / 60), time % 60)
  self.frame.bottom.logoText:SetText(F.String.GradientClass(formattedText))
end

function AFK:SetAFK(_, status)
  self.screenActive = status

  self:CancelAllTimers()

  if status and not self.elvUIAfk.isAFK then
    local guildName = GetGuildInfo("player")
    local specIcon, iconsFont = M:GenerateSpecIcon(E.db.TXUI.addons.afkMode.specIconStyle)

    self.elvUIAfk.isAFK = true

    if self.db.turnCamera then
      MoveViewLeftStart(0.035) -- Turns camera smoothly
    end

    self.frame:Show()
    CloseAllWindows()
    UIParent:Hide()

    self.frame.bottom:SetAlpha(0)
    self.frame.bottom.anim:Play()

    self.startTime = GetTime()
    self.timerUpdate = self:ScheduleRepeatingTimer("UpdateTimer", 0.32)

    self.frame.chat:RegisterEvent("CHAT_MSG_WHISPER")
    self.frame.chat:RegisterEvent("CHAT_MSG_BN_WHISPER")
    self.frame.chat:RegisterEvent("CHAT_MSG_GUILD")

    self.frame.bottom.model:SetUnit("player")
    self.frame.bottom.model:SetScript("OnAnimFinished", function()
      self:PlayIdleAnimation()
    end)

    self.frame.bottom.specIcon:SetFont(iconsFont, F.FontSizeScaled(E.db.TXUI.addons.afkMode.specIconSize), "")
    self.frame.bottom.specIcon:SetTextColor(1, 1, 1, 1)

    self.frame.bottom.guildText:SetText(guildName and F.String.FastGradientHex("<" .. guildName .. ">", "06c910", "33ff3d") or "")
    self.frame.bottom.specIcon:SetText(specIcon)
    self.frame.bottom.levelText:SetText("Lv " .. E.mylevel)
    self.frame.bottom.classText:SetText(F.String.GradientClass(E.myLocalizedClass, nil, true))

    if self.db.playEmotes then
      self:ResetPlayedAnimations()
      self:PlayRandomAnimation()
    else
      self:PlayIdleAnimation()
    end
  elseif not status and self.elvUIAfk.isAFK then
    self.elvUIAfk.isAFK = false

    UIParent:Show()
    self.frame:Hide()

    if self.db.turnCamera then
      MoveViewLeftStop() -- turn off camera movement
    end

    self.frame.bottom.model:SetScript("OnAnimFinished", nil)
    self.frame.bottom.model:SetAnimation(0, 0, 1)
    self.frame.bottom.logoText:SetText(" ")

    self.frame.chat:UnregisterAllEvents()
    self.frame.chat:Clear()

    if PVEFrame and PVEFrame:IsShown() then
      PVEFrame_ToggleFrame()
      PVEFrame_ToggleFrame()
    end
  end
end

function AFK:SetupFrames()
  -- Vars
  local padding = 20
  self.frame = self.elvUIAfk.AFKMode

  local changelog = TXUI.Changelog[TXUI.Version]
  local changelogText = O:FormatChangelog(nil, nil, nil, changelog, true)
  local changelogHeader = "Latest changelog for " .. F.String.ToxiUI(CL:FormattedVersion(TXUI.Version))

  -- Set frame.bottom to full screen
  self.frame.bottom:ClearAllPoints()
  self.frame.bottom:SetAllPoints(E.UIParent)

  -- Cancel ElvUI timers
  self.elvUIAfk:CancelAllTimers()

  -- Move the chat lower
  self.frame.chat:ClearAllPoints()
  self.frame.chat:SetPoint("BOTTOMLEFT", self.frame.bottom, "BOTTOMLEFT", padding, padding)

  -- Bottom Frame Animation
  self.frame.bottom.anim = TXUI:CreateAnimationGroup(self.frame.bottom):CreateAnimation("Fade")
  self.frame.bottom.anim:SetChange(1)
  self.frame.bottom.anim:SetDuration(1)
  self.frame.bottom.anim:SetEasing("out-quadratic")

  -- ToxiUI logo1
  self.frame.bottom.faction:SetTexture(I.Media.Logos.Logo)
  self.frame.bottom.faction:ClearAllPoints()
  self.frame.bottom.faction:Size(256, 128)
  self.frame.bottom.faction:SetPoint("TOP", self.frame.bottom, "TOP", 0, -padding * 5)

  if self.db.showChangelog then
    self.frame.bottom.changelogHeader = self.frame.bottom:CreateFontString(nil, "OVERLAY")
    self.frame.bottom.changelogHeader:SetPoint("TOPLEFT", self.frame.bottom, "TOPLEFT", padding, -padding * 5)
    self.frame.bottom.changelogHeader:SetFont(self.titleFont, F.FontSizeScaled(24), "SHADOWOUTLINE")
    self.frame.bottom.changelogHeader:SetJustifyH("LEFT")
    self.frame.bottom.changelogHeader:SetTextColor(1, 1, 1, 0.8)
    self.frame.bottom.changelogHeader:SetText(changelogHeader)

    self.frame.bottom.changelog = self.frame.bottom:CreateFontString(nil, "OVERLAY")
    self.frame.bottom.changelog:SetPoint("TOPLEFT", self.frame.bottom.changelogHeader, "BOTTOMLEFT", 0, -padding / 2)
    self.frame.bottom.changelog:SetFont(self.primaryFont, F.FontSizeScaled(16), "SHADOWOUTLINE")
    self.frame.bottom.changelog:SetJustifyH("LEFT")
    self.frame.bottom.changelog:SetTextColor(1, 1, 1, 0.8)
    self.frame.bottom.changelog:SetText(changelogText)
  end

  -- Add ElvUI name
  self.frame.bottom.logoText = self.frame.bottom:CreateFontString(nil, "OVERLAY")
  self.frame.bottom.logoText:SetPoint("TOP", self.frame.bottom.faction, "BOTTOM", 0, -padding)
  self.frame.bottom.logoText:SetFont(self.titleFont, F.FontSizeScaled(32), "SHADOWOUTLINE")
  self.frame.bottom.logoText:SetTextColor(1, 1, 1, 1)
  self.frame.bottom.logoText:SetText(" ")

  -- Player Model
  self.frame.bottom.model:SetPoint("CENTER", self.frame.bottom.modelHolder, "CENTER", F.Dpi(-100), F.Dpi(100))
  self.frame.bottom.model:SetCamDistanceScale(4) -- Lower number => bigger model. Higher number => smaller model.
  self.frame.bottom.model:SetScript("OnUpdate", nil)

  -- Bottom text promotion
  self.frame.bottom.bottomText = self.frame.bottom:CreateFontString(nil, "OVERLAY")
  self.frame.bottom.bottomText:Point("BOTTOM", 0, padding)
  self.frame.bottom.bottomText:SetFont(self.primaryFont, F.FontSizeScaled(14), "OUTLINE")
  self.frame.bottom.bottomText:SetTextColor(1, 1, 1, 0.6)
  self.frame.bottom.bottomText:SetText("You can find all the relevant " .. TXUI.Title .. " information at " .. I.Strings.Branding.Links.Website)

  -- Player Name
  self.frame.bottom.nameText = self.frame.bottom:CreateFontString(nil, "OVERLAY")
  self.frame.bottom.nameText:SetPoint("TOP", self.frame.bottom.logoText, "BOTTOM", 0, -30)
  self.frame.bottom.nameText:SetFont(self.titleFont, F.FontSizeScaled(28), "OUTLINE")
  self.frame.bottom.nameText:SetTextColor(1, 1, 1, 1)
  self.frame.bottom.nameText:SetText(F.String.GradientClass(E.myname))

  -- Player Guild
  self.frame.bottom.guildText = self.frame.bottom:CreateFontString(nil, "OVERLAY")
  self.frame.bottom.guildText:SetPoint("TOP", self.frame.bottom.nameText, "BOTTOM", 0, 0)
  self.frame.bottom.guildText:SetFont(self.primaryFont, F.FontSizeScaled(16), "OUTLINE")
  self.frame.bottom.guildText:SetTextColor(1, 1, 1, 1)

  self.frame.bottom.specIcon = self.frame.bottom:CreateFontString(nil, "OVERLAY")
  self.frame.bottom.specIcon:SetPoint("TOP", self.frame.bottom.guildText, "BOTTOM", 0, -25)

  self.frame.bottom.levelText = self.frame.bottom:CreateFontString(nil, "OVERLAY")
  self.frame.bottom.levelText:SetPoint("RIGHT", self.frame.bottom.specIcon, "LEFT", -4, 0)
  self.frame.bottom.levelText:SetFont(self.primaryFont, F.FontSizeScaled(20), "OUTLINE")
  self.frame.bottom.levelText:SetTextColor(1, 1, 1, 1)

  self.frame.bottom.classText = self.frame.bottom:CreateFontString(nil, "OVERLAY")
  self.frame.bottom.classText:SetPoint("LEFT", self.frame.bottom.specIcon, "RIGHT", 4, 0)
  self.frame.bottom.classText:SetFont(self.primaryFont, F.FontSizeScaled(20), "OUTLINE")
  self.frame.bottom.classText:SetTextColor(1, 1, 1, 1)

  -- Random tips
  if self.db.showTips then
    local randomTips = I.Constants.RandomTips

    local indexOne = math.random(1, #randomTips)
    local indexTwo = math.random(1, #randomTips)
    local indexThree = math.random(1, #randomTips)
    -- For debugging
    -- randomIndex = 4
    local tipOne = randomTips[indexOne]
    local tipTwo = randomTips[indexTwo]
    local tipThree = randomTips[indexThree]

    self.frame.bottom.tipHeader = self.frame.bottom:CreateFontString(nil, "OVERLAY")
    self.frame.bottom.tipHeader:SetPoint("TOPRIGHT", self.frame.bottom, "TOPRIGHT", -padding, -padding * 5)
    self.frame.bottom.tipHeader:SetFont(self.titleFont, F.FontSizeScaled(24), "OUTLINE")
    self.frame.bottom.tipHeader:SetTextColor(1, 1, 1, 0.8)
    self.frame.bottom.tipHeader:SetJustifyH("RIGHT")
    self.frame.bottom.tipHeader:SetText("Random Tips")

    self.frame.bottom.tipText = self.frame.bottom:CreateFontString(nil, "OVERLAY")
    self.frame.bottom.tipText:SetPoint("TOPRIGHT", self.frame.bottom.tipHeader, "BOTTOMRIGHT", 0, -padding / 2)
    self.frame.bottom.tipText:SetFont(self.primaryFont, F.FontSizeScaled(16), "OUTLINE")
    self.frame.bottom.tipText:SetTextColor(1, 1, 1, 0.8)
    self.frame.bottom.tipText:SetJustifyH("RIGHT")

    self.frame.bottom.tipText:SetText(tipOne .. "\n\n\n" .. tipTwo .. "\n\n\n" .. tipThree)

    self.frame.bottom.tipText:SetWidth(600)
  end

  -- Sush
  F.CreateSoftShadow(self.frame.bottom, E.physicalHeight)

  -- Hide Stuff
  self.frame.bottom.time:Kill()
  self.frame.bottom.name:Kill()
  self.frame.bottom.LogoTop:Kill()
  self.frame.bottom.LogoBottom:Kill()
  self.frame.bottom.guild:Kill()
end

function AFK:Disable()
  if not self.Initialized then return end
  if not self:IsHooked(self.elvUIAfk, "SetAFK") then return end

  self:CancelAllTimers()
  self:UnhookAll()
end

function AFK:Enable()
  if not self.Initialized then return end
  if self:IsHooked(self.elvUIAfk, "SetAFK") then return end

  -- Force set settings
  E.db["general"]["afk"] = E.db.TXUI.addons.afkMode.enabled

  -- Get ElvUI Module
  self.elvUIAfk = E:GetModule("AFK")

  -- Hook SetAFK
  self:RawHook(self.elvUIAfk, "SetAFK", "SetAFK")

  -- Call setup if elvui already ran
  if self.elvUIAfk.Initialized then
    self:SetupFrames()
  else
    self:SecureHook(self.elvUIAfk, "Initialize", "SetupFrames")
  end
end

function AFK:DatabaseUpdate()
  -- Set db
  self.db = F.GetDBFromPath("TXUI.addons.afkMode")

  F.Event.ContinueOutOfCombat(function()
    -- Disable only out of combat
    self:Disable()

    -- Enable only out of combat
    if self.db and self.db.enabled then self:Enable() end
  end)
end

function AFK:Initialize()
  -- Don't init second time
  if self.Initialized then return end

  -- Register for updates
  F.Event.RegisterOnceCallback("TXUI.InitializedSafe", F.Event.GenerateClosure(self.DatabaseUpdate, self))
  F.Event.RegisterCallback("TXUI.DatabaseUpdate", self.DatabaseUpdate, self)
  F.Event.RegisterCallback("AFK.DatabaseUpdate", self.DatabaseUpdate, self)

  -- Get font
  self.primaryFont = F.GetFontPath(I.Fonts.Primary)
  self.titleFont = F.GetFontPath(I.Fonts.TitleRaid)

  -- We are done, hooray!
  self.Initialized = true
end

TXUI:RegisterModule(AFK:GetName())
