local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local AFK = TXUI:NewModule("AFK", "AceHook-3.0", "AceTimer-3.0")

-- Globals
local CloseAllWindows = CloseAllWindows
local CreateFrame = CreateFrame
local floor = math.floor
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
AFK.timerText = "AWAY FOR "
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

function AFK:GetAvaibleAnimations()
  local avaibleAnimation = {}

  for randomAnimation, enabled in pairs(self.randomAnimations) do
    if enabled and (self.frame.bottom.model:HasAnimation(randomAnimation)) then tinsert(avaibleAnimation, randomAnimation) end
  end

  return avaibleAnimation
end

function AFK:PlayRandomAnimation()
  if not self.elvUIAfk.isAFK then return end

  -- Get not played and animations that the model supports
  local avaibleAnimation = self:GetAvaibleAnimations()

  -- No Animations avaible, reset all used ones
  if #avaibleAnimation == 0 then
    self:ResetPlayedAnimations()
    avaibleAnimation = self:GetAvaibleAnimations()
  end

  -- Still no Animation avaible, don't do anything, try next time
  if #avaibleAnimation == 0 then
    self:StartAnimationCycle()
    return
  end

  -- Get random animations from the once avaible
  local newAnimation = avaibleAnimation[random(1, #avaibleAnimation)]

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
  self.frame.bottom.logoText:SetFormattedText("%s %02d:%02d", self.timerText, floor(time / 60), time % 60)
end

function AFK:SetAFK(_, status)
  self.screenActive = status

  self:CancelAllTimers()

  if status and not self.elvUIAfk.isAFK then
    self.elvUIAfk.isAFK = true

    if self.db.turnCamera then
      MoveViewLeftStart(0.035) -- Turns camera smoothly
    end

    self.frame:Show()
    CloseAllWindows()
    UIParent:Hide()

    self.frame.bottom:SetHeight(0)
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
  local bottomHeight = E.physicalHeight * (1 / 9)
  self.frame = self.elvUIAfk.AFKMode

  -- Cancel ElvUI timers
  self.elvUIAfk:CancelAllTimers()

  -- Move the chat lower
  self.frame.chat:ClearAllPoints()
  self.frame.chat:SetPoint("TOPLEFT", self.frame.bottom, "BOTTOMLEFT", F.Dpi(4), F.Dpi(-10))

  -- Bottom Frame Animation
  self.frame.bottom.anim = TXUI:CreateAnimationGroup(self.frame.bottom):CreateAnimation("Height")
  self.frame.bottom.anim:SetChange(bottomHeight)
  self.frame.bottom.anim:SetDuration(1)
  self.frame.bottom.anim:SetEasing("out-bounce")

  -- ToxiUI logo
  self.frame.bottom.logoBackground = CreateFrame("Frame", nil, self.frame)
  self.frame.bottom.logoBackground:SetPoint("CENTER", self.frame.bottom, "CENTER", 0, 0)
  self.frame.bottom.logoBackground:SetFrameStrata("MEDIUM")
  self.frame.bottom.logoBackground:SetFrameLevel(10)
  self.frame.bottom.logoBackground:SetSize(F.Dpi(220), F.Dpi(120))
  self.frame.bottom.faction:SetTexture(I.Media.Logos.Logo)
  self.frame.bottom.faction:ClearAllPoints()
  self.frame.bottom.faction:SetParent(self.frame.bottom.logoBackground)
  self.frame.bottom.faction:SetInside()

  -- Add ElvUI name
  self.frame.bottom.logoText = self.frame.bottom:CreateFontString(nil, "OVERLAY")
  self.frame.bottom.logoText:SetPoint("LEFT", self.frame.bottom, "LEFT", F.Dpi(25), 0)
  self.frame.bottom.logoText:SetFont(self.mainFont, F.FontSizeScaled(48), "NONE")
  self.frame.bottom.logoText:SetTextColor(1, 1, 1, 1)
  self.frame.bottom.logoText:SetText(" ")

  -- Player Model
  self.frame.bottom.model:SetPoint("CENTER", self.frame.bottom.modelHolder, "CENTER", F.Dpi(-50), F.Dpi(150))
  self.frame.bottom.model:SetCamDistanceScale(3) -- Lower number => bigger model. Higher number => smaller model.
  self.frame.bottom.model:SetScript("OnUpdate", nil)

  -- Sush
  F.CreateSoftShadow(self.frame.bottom, bottomHeight)

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
  self.mainFont = F.GetFontPath(I.Fonts.Title)

  -- We are done, hooray!
  self.Initialized = true
end

TXUI:RegisterModule(AFK:GetName())
