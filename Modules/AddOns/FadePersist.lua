local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local FP = TXUI:NewModule("FadePersist", "AceHook-3.0")

local _G = _G
local UnitAffectingCombat = UnitAffectingCombat
local IsPossessBarVisible, HasOverrideActionBar = IsPossessBarVisible, HasOverrideActionBar

local canGlide = false
function FP:OnEvent(parent, event, arg1)
  -- If disabled but still hooked, call original method
  if not self.db.enabled or (self.db.mode == "ELVUI") then
    self.hooks[parent].OnEvent(parent, event)
    return
  end

  local fadeIn = self.fadeOverride

  if not fadeIn then
    if self.db.mode == "ALWAYS" then
      fadeIn = true
    elseif self.db.mode == "IN_COMBAT" then
      fadeIn = (UnitAffectingCombat("player")) or (event == "PLAYER_REGEN_DISABLED")
    elseif self.db.mode == "NO_COMBAT" then
      fadeIn = (not UnitAffectingCombat("player")) and (event ~= "PLAYER_REGEN_DISABLED")
    end

    -- If vehicle bar is disabled we want to see bars in vehicle
    if not E.db.TXUI.vehicleBar.enabled and self.db.showInVehicles then
      if event == "PLAYER_CAN_GLIDE_CHANGED" then canGlide = arg1 end

      if canGlide or UnitInVehicle("player") or IsPossessBarVisible() or HasOverrideActionBar() then fadeIn = true end
    end
  end

  if fadeIn then
    parent.mouseLock = true
    E:UIFrameFadeIn(parent, 0.2, parent:GetAlpha(), 1)
    self.ab:FadeBlings(1)
  else
    parent.mouseLock = false
    E:UIFrameFadeOut(parent, 0.2, parent:GetAlpha(), 0)
    self.ab:FadeBlings(0)
  end
end

function FP:ToggleOverride(enabled, key)
  if enabled then
    self.fadeOverrides[key] = true
  else
    self.fadeOverrides[key] = nil
  end

  self.fadeOverride = F.Table.HasAnyEntries(self.fadeOverrides)
  self:OnEvent(self.ab.fadeParent, "FADE_OVERRIDE")
end

function FP:Disable()
  if not self.Initialized then return end

  self:UnhookAll()

  if E.private.actionbar.enable and self.ab then
    self.ab.fadeParent:GetScript("OnEvent")(self.ab.fadeParent)
    self.ab.fadeParent:RegisterEvent("PLAYER_REGEN_DISABLED")
    self.ab.fadeParent:RegisterEvent("PLAYER_REGEN_ENABLED")
    self.ab.fadeParent:RegisterEvent("PLAYER_TARGET_CHANGED")
    if not TXUI.IsVanilla then
      self.ab.fadeParent:RegisterEvent("UPDATE_OVERRIDE_ACTIONBAR")
      self.ab.fadeParent:RegisterEvent("UPDATE_POSSESS_BAR")
    end
    self.ab.fadeParent:RegisterEvent("VEHICLE_UPDATE")
    self.ab.fadeParent:RegisterUnitEvent("UNIT_ENTERED_VEHICLE", "player")
    self.ab.fadeParent:RegisterUnitEvent("UNIT_EXITED_VEHICLE", "player")
    self.ab.fadeParent:RegisterUnitEvent("UNIT_SPELLCAST_START", "player")
    self.ab.fadeParent:RegisterUnitEvent("UNIT_SPELLCAST_STOP", "player")
    self.ab.fadeParent:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", "player")
    self.ab.fadeParent:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", "player")
    self.ab.fadeParent:RegisterUnitEvent("UNIT_HEALTH", "player")
    self.ab.fadeParent:RegisterEvent("PLAYER_FOCUS_CHANGED")
  end
end

function FP:Enable()
  if not self.Initialized or not E.private.actionbar.enable then return end

  -- Don't unregister for combat or ElvUI mode
  if (self.db.mode ~= "IN_COMBAT") and (self.db.mode ~= "NO_COMBAT") and (self.db.mode ~= "ELVUI") then
    self.ab.fadeParent:UnregisterEvent("PLAYER_REGEN_DISABLED")
    self.ab.fadeParent:UnregisterEvent("PLAYER_REGEN_ENABLED")
  end

  -- Don't unregister for default ElvUI mode
  if self.db.mode ~= "ELVUI" then
    self.ab.fadeParent:UnregisterEvent("PLAYER_TARGET_CHANGED")
    if not TXUI.IsVanilla then
      self.ab.fadeParent:UnregisterEvent("UPDATE_OVERRIDE_ACTIONBAR")
      self.ab.fadeParent:UnregisterEvent("UPDATE_POSSESS_BAR")
    end
    self.ab.fadeParent:UnregisterEvent("VEHICLE_UPDATE")
    self.ab.fadeParent:UnregisterEvent("UNIT_ENTERED_VEHICLE")
    self.ab.fadeParent:UnregisterEvent("UNIT_EXITED_VEHICLE")
    self.ab.fadeParent:UnregisterEvent("UNIT_SPELLCAST_START")
    self.ab.fadeParent:UnregisterEvent("UNIT_SPELLCAST_STOP")
    self.ab.fadeParent:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_START")
    self.ab.fadeParent:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
    self.ab.fadeParent:UnregisterEvent("UNIT_HEALTH")
    self.ab.fadeParent:UnregisterEvent("PLAYER_FOCUS_CHANGED")
  end

  -- Hook main event script if not hooked already
  self:RawHookScript(self.ab.fadeParent, "OnEvent", F.Event.GenerateClosure(self.OnEvent, self))

  -- Hook Keybind Mode
  self:SecureHook(self.ab, "ActivateBindMode", F.Event.GenerateClosure(self.ToggleOverride, self, true, "kb"))
  self:SecureHook(self.ab, "DeactivateBindMode", F.Event.GenerateClosure(self.ToggleOverride, self, false, "kb"))

  -- Hook Macro Window on Load
  F.Event.ContinueOnAddOnLoaded("Blizzard_MacroUI", function()
    if not TXUI:HasRequirements(I.Requirements.FadePersist) or not (self.db and self.db.enabled) then return end

    local macroFrame = _G["MacroFrame"]
    self:SecureHookScript(macroFrame, "OnShow", F.Event.GenerateClosure(self.ToggleOverride, self, true, "macro"))
    self:SecureHookScript(macroFrame, "OnHide", F.Event.GenerateClosure(self.ToggleOverride, self, false, "macro"))
  end)

  -- Hook Spellbook
  if TXUI.IsRetail then
    F.Event.ContinueOnAddOnLoaded("Blizzard_PlayerSpells", function()
      if not TXUI:HasRequirements(I.Requirements.FadePersist) or not (self.db and self.db.enabled) then return end

      local spellBookFrame = _G["PlayerSpellsFrame"]
      if spellBookFrame then
        self:SecureHookScript(spellBookFrame, "OnShow", F.Event.GenerateClosure(self.ToggleOverride, self, true, "spell"))
        self:SecureHookScript(spellBookFrame, "OnHide", F.Event.GenerateClosure(self.ToggleOverride, self, false, "spell"))
      else
        self:LogDebug("PlayerSpellsFrame could not be found")
      end
    end)
  else
    local spellBookFrame = _G["SpellBookFrame"]
    if spellBookFrame then
      self:SecureHookScript(spellBookFrame, "OnShow", F.Event.GenerateClosure(self.ToggleOverride, self, true, "spell"))
      self:SecureHookScript(spellBookFrame, "OnHide", F.Event.GenerateClosure(self.ToggleOverride, self, false, "spell"))
    else
      self:LogDebug("SpellBookFrame could not be found")
    end
  end
  -- Re-register so command gets updated with new reference
  E:UnregisterChatCommand("kb")
  E:RegisterChatCommand("kb", self.ab.ActivateBindMode)

  -- Force refresh
  self:OnEvent(self.ab.fadeParent)
end

function FP:DatabaseUpdate()
  -- Set db
  self.db = F.GetDBFromPath("TXUI.addons.fadePersist")

  F.Event.ContinueOutOfCombat(function()
    -- Disable only out of combat
    self:Disable()

    -- Enable only out of combat
    if TXUI:HasRequirements(I.Requirements.FadePersist) and (self.db and self.db.enabled) and E.private.actionbar.enable then self:Enable() end
  end)
end

function FP:Initialize()
  -- Don't init second time
  if self.Initialized then return end

  -- Register for updates
  F.Event.RegisterOnceCallback("TXUI.InitializedSafe", F.Event.GenerateClosure(self.DatabaseUpdate, self))
  F.Event.RegisterCallback("TXUI.DatabaseUpdate", self.DatabaseUpdate, self)
  F.Event.RegisterCallback("FadePersist.DatabaseUpdate", self.DatabaseUpdate, self)

  -- Get ActionBars
  self.ab = E:GetModule("ActionBars")

  -- Vars
  self.fadeOverride = false
  self.fadeOverrides = {}

  -- We are done, hooray!
  self.Initialized = true
end

TXUI:RegisterModule(FP:GetName())
