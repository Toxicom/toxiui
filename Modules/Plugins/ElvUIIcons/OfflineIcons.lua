local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local OI = TXUI:NewModule("OfflineIcons", "AceHook-3.0")

-- Globals
local _G = _G
local UnitIsConnected = UnitIsConnected

-- Vars
local UF
local OUF

function OI.ElementUpdate(frame, _, unit)
  local element = frame.TXOffline
  if not element then return end

  if unit and unit ~= frame.unit then return end
  if not unit then unit = frame.unit end

  local isOffline = frame.isForced or (not UnitIsConnected(unit))

  if isOffline then
    element:Show()
  else
    element:Hide()
  end
end

function OI.ElementEnable(frame)
  local element = frame.TXOffline
  if not element then return end

  element.__owner = frame

  F.Event.RegisterCallback("OfflineIcons.SettingsUpdate", F.Event.GenerateClosure(OI.UpdateOfflineIcon, OI), frame)

  frame:RegisterEvent("UNIT_FLAGS", OI.ElementUpdate)
  frame:RegisterEvent("UNIT_CONNECTION", OI.ElementUpdate)
  frame:RegisterEvent("PARTY_MEMBER_ENABLE", OI.ElementUpdate)
  frame:RegisterEvent("PARTY_MEMBER_DISABLE", OI.ElementUpdate)
  element:Hide()

  OI.ElementUpdate(frame)

  return true
end

function OI.ElementDisable(frame)
  local element = frame.TXOffline
  if not element then return end

  F.Event.UnregisterCallback("OfflineIcons.SettingsUpdate", element)

  frame:UnregisterEvent("UNIT_FLAGS", OI.ElementUpdate)
  frame:UnregisterEvent("UNIT_CONNECTION", OI.ElementUpdate)
  frame:UnregisterEvent("PARTY_MEMBER_ENABLE", OI.ElementUpdate)
  frame:UnregisterEvent("PARTY_MEMBER_DISABLE", OI.ElementUpdate)
  element:Hide()
end

function OI:UpdateOfflineIcon(frame)
  frame.TXOffline:SetSize(F.Dpi(self.db.size), F.Dpi(self.db.size))
  frame.TXOffline:SetPoint("CENTER", frame, "CENTER", F.Dpi(self.db.xOffset), F.Dpi(self.db.yOffset))
  frame.TXOffline:SetTexture(F.GetMedia(I.Media.StateIcons, I.ElvUIIcons.Offline[self.db.theme]))

  -- Update Hide/Show
  OI.ElementUpdate(frame)
end

function OI:UpdatePartyFrames(_, frame)
  -- Update Element
  if self.db.enabled then
    -- Construct Dead Icon if needed
    if not frame.TXOffline then frame.TXOffline = frame.RaisedElementParent.TextureParent:CreateTexture(frame:GetName() .. "TXOfflineIcon", "OVERLAY") end

    -- Enable element
    if not frame:IsElementEnabled("TXOffline") then frame:EnableElement("TXOffline") end

    -- Set settings
    self:UpdateOfflineIcon(frame)
  elseif frame:IsElementEnabled("TXOffline") then
    frame:DisableElement("TXOffline")
  end
end

function OI:Disable()
  if not self.Initialized then return end
  if not self:IsHooked(UF, "Update_PartyFrames") then return end

  -- We call an update before unhooking, in case we are active and hooked to replace the old override
  if UF then UF:Update_AllFrames() end
  self:UnhookAll()

  E:GetModule("UnitFrames"):Update_AllFrames()
end

function OI:Enable()
  if not self.Initialized then return end
  if self:IsHooked(UF, "Update_PartyFrames") then return end

  self:SecureHook(UF, "Update_PartyFrames", "UpdatePartyFrames")
  UF:Update_AllFrames()
end

function OI:DatabaseUpdate()
  -- Set db
  self.db = F.GetDBFromPath("TXUI.elvUIIcons.offlineIcons")

  F.Event.ContinueOutOfCombat(function()
    -- Disable only out of combat
    self:Disable()

    -- Enable only out of combat
    if TXUI:HasRequirements(I.Requirements.RoleIcons) and (self.db and self.db.enabled) then self:Enable() end
  end)
end

function OI:Initialize()
  -- Don't init second time
  if self.Initialized then return end

  -- Register for updates
  F.Event.RegisterOnceCallback("TXUI.InitializedSafe", F.Event.GenerateClosure(self.DatabaseUpdate, self))
  F.Event.RegisterCallback("TXUI.DatabaseUpdate", self.DatabaseUpdate, self)
  F.Event.RegisterCallback("OfflineIcons.DatabaseUpdate", self.DatabaseUpdate, self)

  -- Get Frameworks
  UF = E:GetModule("UnitFrames")
  OUF = E.oUF or _G.oUF

  -- Register ourself
  OUF:AddElement("TXOffline", self.ElementUpdate, self.ElementEnable, self.ElementDisable)

  -- We are done, hooray!
  self.Initialized = true
end

TXUI:RegisterModule(OI:GetName())
