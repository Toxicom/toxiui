local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local DI = TXUI:NewModule("DeadIcons", "AceHook-3.0")

-- Globals
local _G = _G
local UnitIsDead = UnitIsDead
local UnitIsGhost = UnitIsGhost

-- Vars
local UF
local OUF

function DI.ElementUpdate(frame, _, unit)
  local element = frame.Dead
  if not element then return end

  if unit and unit ~= frame.unit then return end
  if not unit then unit = frame.unit end

  local isDead = frame.isForced or UnitIsDead(unit) or UnitIsGhost(unit)

  if isDead then
    element:Show()
  else
    element:Hide()
  end
end

function DI.ElementEnable(frame)
  local element = frame.Dead
  if not element then return end

  element.__owner = frame

  F.Event.RegisterCallback("DeadIcons.SettingsUpdate", F.Event.GenerateClosure(DI.UpdateDeadIcon, DI), frame)

  frame:RegisterEvent("UNIT_HEALTH", DI.ElementUpdate)
  element:Hide()

  DI.ElementUpdate(frame)

  return true
end

function DI.ElementDisable(frame)
  local element = frame.Dead
  if not element then return end

  F.Event.UnregisterCallback("DeadIcons.SettingsUpdate", element)

  frame:UnregisterEvent("UNIT_HEALTH", DI.ElementUpdate)
  element:Hide()
end

function DI:UpdateDeadIcon(frame)
  frame.Dead:SetSize(F.Dpi(self.db.size), F.Dpi(self.db.size))
  frame.Dead:SetPoint("CENTER", frame, "CENTER", F.Dpi(self.db.xOffset), F.Dpi(self.db.yOffset))
  frame.Dead:SetTexture(F.GetMedia(I.Media.StateIcons, I.ElvUIIcons.Dead[self.db.theme]))

  -- Update Hide/Show
  DI.ElementUpdate(frame)
end

function DI:UpdatePartyFrames(_, frame)
  -- Update Element
  if self.db.enabled then
    -- Construct Dead Icon if needed
    if not frame.Dead then frame.Dead = frame.RaisedElementParent.TextureParent:CreateTexture(frame:GetName() .. "DeadIcon", "OVERLAY") end

    -- Enable element
    if not frame:IsElementEnabled("TXDead") then frame:EnableElement("TXDead") end

    -- Set settings
    self:UpdateDeadIcon(frame)
  elseif frame:IsElementEnabled("TXDead") then
    frame:DisableElement("TXDead")
  end
end

function DI:Disable()
  if not self.Initialized then return end
  if not self:IsHooked(UF, "Update_PartyFrames") then return end

  -- We call an update before unhooking, in case we are active and hooked to replace the old override
  if UF then UF:Update_AllFrames() end
  self:UnhookAll()

  E:GetModule("UnitFrames"):Update_AllFrames()
end

function DI:Enable()
  if not self.Initialized then return end
  if self:IsHooked(UF, "Update_PartyFrames") then return end

  self:SecureHook(UF, "Update_PartyFrames", "UpdatePartyFrames")
  UF:Update_AllFrames()
end

function DI:DatabaseUpdate()
  -- Set db
  self.db = F.GetDBFromPath("TXUI.elvUIIcons.deadIcons")

  F.Event.ContinueOutOfCombat(function()
    -- Disable only out of combat
    self:Disable()

    -- Enable only out of combat
    if TXUI:HasRequirements(I.Requirements.RoleIcons) and (self.db and self.db.enabled) then self:Enable() end
  end)
end

function DI:Initialize()
  -- Don't init second time
  if self.Initialized then return end

  -- Register for updates
  F.Event.RegisterOnceCallback("TXUI.InitializedSafe", F.Event.GenerateClosure(self.DatabaseUpdate, self))
  F.Event.RegisterCallback("TXUI.DatabaseUpdate", self.DatabaseUpdate, self)
  F.Event.RegisterCallback("DeadIcons.DatabaseUpdate", self.DatabaseUpdate, self)

  -- Get Frameworks
  UF = E:GetModule("UnitFrames")
  OUF = E.oUF or _G.oUF

  -- Register ourself
  OUF:AddElement("TXDead", self.ElementUpdate, self.ElementEnable, self.ElementDisable)

  -- We are done, hooray!
  self.Initialized = true
end

TXUI:RegisterModule(DI:GetName())
