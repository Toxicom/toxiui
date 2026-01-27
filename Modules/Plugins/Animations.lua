local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local AN = TXUI:NewModule("Animations", "AceHook-3.0", "AceEvent-3.0")

-- Globals
local pairs = pairs

-- Frame mappings: key = settings key, value = global frame name
AN.FrameMap = {
  characterFrame = "CharacterFrame",
  dressingRoom = "DressUpFrame",
  inspectFrame = "InspectFrame",
  friendsFrame = "FriendsFrame",
  groupFinder = TXUI.IsRetail and "PVEFrame" or nil,
  collectionsJournal = TXUI.IsRetail and "CollectionsJournal" or nil,
  encounterJournal = TXUI.IsRetail and "EncounterJournal" or nil,
  map = "WorldMapFrame",
  spellbook = TXUI.IsRetail and "PlayerSpellsFrame" or "SpellBookFrame",
  professionsBook = TXUI.IsRetail and "ProfessionsBookFrame" or nil,
  professions = TXUI.IsRetail and "ProfessionsFrame" or "TradeSkillFrame",
  auctionHouse = "AuctionHouseFrame",
  mailbox = "MailFrame",
  merchant = "MerchantFrame",
  gossip = "GossipFrame",
  quest = "QuestFrame",
  questLog = (not TXUI.IsRetail) and "QuestLogFrame" or nil,
  achievementFrame = "AchievementFrame",
  weeklyRewards = TXUI.IsRetail and "WeeklyRewardsFrame" or nil,
  talents = (not TXUI.IsRetail) and "PlayerTalentFrame" or nil,
}

function AN:GetFrameSettings(frameKey)
  if not self.db or not self.db.frames then return nil end
  return self.db.frames[frameKey]
end

function AN:CreateFadeAnimation(frame, frameKey)
  if not frame then return end

  local settings = self:GetFrameSettings(frameKey)
  if not settings or not settings.enabled then return end

  -- Create animation group if it doesn't exist
  if not frame.txAnimGroup then frame.txAnimGroup = TXUI:CreateAnimationGroup(frame) end

  local group = frame.txAnimGroup

  -- Clear existing animations
  if group.Animations then
    for i = #group.Animations, 1, -1 do
      group.Animations[i] = nil
    end
  end
  group.Animations = {}
  group.MaxOrder = 1
  group.Order = 1

  local duration = (settings.duration or 0.3) * (self.db.animationsMult or 1)

  -- Create fade animation using TXUI animation system
  local fade = group:CreateAnimation("fade")
  if fade then
    fade:SetDuration(duration)
    fade:SetEasing(settings.easing or "out-cubic")
    fade:SetChange(1)
    fade:SetOrder(1)
  end

  return group
end

function AN:PlayAnimation(frame, frameKey)
  if not frame or not self.db or not self.db.enabled then return end

  local settings = self:GetFrameSettings(frameKey)
  if not settings or not settings.enabled then return end

  -- Stop any existing animation
  if frame.txAnimGroup and frame.txAnimGroup:IsPlaying() then frame.txAnimGroup:Stop() end

  -- Set initial state - start invisible
  frame:SetAlpha(0)

  -- Create and play fade animation
  local group = self:CreateFadeAnimation(frame, frameKey)
  if group then group:Play() end
end

function AN:HookFrame(frameKey, frameName)
  -- Skip if frameName is nil (e.g., talents in Retail shares with spellbook)
  if not frameName then return end

  local frame = _G[frameName]

  if frame then
    -- Hook the Show method
    if not self:IsHooked(frame, "Show") then self:SecureHook(frame, "Show", function(f)
      self:PlayAnimation(f, frameKey)
    end) end
  else
    -- Frame doesn't exist yet, hook when it gets created
    local function OnFrameCreated()
      local f = _G[frameName]
      if f and not self:IsHooked(f, "Show") then self:SecureHook(f, "Show", function(fr)
        self:PlayAnimation(fr, frameKey)
      end) end
    end

    -- Try to hook the frame creation
    if not self.pendingHooks then self.pendingHooks = {} end
    self.pendingHooks[frameName] = { frameKey = frameKey, callback = OnFrameCreated }
  end
end

function AN:CheckPendingHooks()
  if not self.pendingHooks then return end

  for frameName, hookData in pairs(self.pendingHooks) do
    local frame = _G[frameName]
    if frame then
      hookData.callback()
      self.pendingHooks[frameName] = nil
    end
  end
end

function AN:SettingsUpdate()
  if not self.Initialized then return end

  -- Re-check pending hooks
  self:CheckPendingHooks()
end

function AN:Disable()
  if not self.Initialized then return end

  self:UnhookAll()

  if self.pendingHooksTimer then
    self:CancelTimer(self.pendingHooksTimer)
    self.pendingHooksTimer = nil
  end

  F.Event.UnregisterFrameEventAndCallback("ADDON_LOADED", self)
end

function AN:Enable()
  if not self.Initialized then return end

  -- Hook all configured frames
  for frameKey, frameName in pairs(self.FrameMap) do
    local settings = self:GetFrameSettings(frameKey)
    if settings and settings.enabled then self:HookFrame(frameKey, frameName) end
  end

  -- Register for addon loaded to catch lazy-loaded frames
  F.Event.RegisterFrameEventAndCallback("ADDON_LOADED", self.CheckPendingHooks, self, "ADDON_LOADED")
end

function AN:DatabaseUpdate()
  -- Disable
  self:Disable()

  -- Set db
  self.db = F.GetDBFromPath("TXUI.animations")

  -- Enable only out of combat
  F.Event.ContinueOutOfCombat(function()
    if TXUI:HasRequirements(I.Requirements.Animations) and (self.db and self.db.enabled) then self:Enable() end
  end)
end

function AN:Initialize()
  -- Don't init second time
  if self.Initialized then return end

  -- Register for updates
  F.Event.RegisterOnceCallback("TXUI.InitializedSafe", F.Event.GenerateClosure(self.DatabaseUpdate, self))
  F.Event.RegisterCallback("TXUI.DatabaseUpdate", self.DatabaseUpdate, self)
  F.Event.RegisterCallback("Animations.DatabaseUpdate", self.DatabaseUpdate, self)
  F.Event.RegisterCallback("Animations.SettingsUpdate", self.SettingsUpdate, self)

  -- We are done, hooray!
  self.Initialized = true
end

TXUI:RegisterModule(AN:GetName())
