local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local BF = TXUI:NewModule("BlizzardFonts", "AceHook-3.0")

local _G = _G
local FadingFrame_Show = FadingFrame_Show

function BF:UpdateFont(name, font, multi)
  local obj = _G[name]
  if obj == nil then return self:LogDebug("UpdateFont > obj is nil: " .. name) end

  F.SetFontFromDB(E.db.TXUI.blizzardFonts, font, obj, false)

  if multi ~= nil then
    local fontPath, fontSize, fontOutline = obj:GetFont()
    obj:SetFont(fontPath, fontSize * multi, fontOutline or "NONE")
  end
end

function BF:SettingsUpdate()
  if not self.Initialized then return end

  local enormous = 1.9
  local mega = 1.7
  local huge = 1.5
  local large = 1.3
  local medium = 1.1
  local small = 0.9

  -- Zone Text
  self:UpdateFont("ZoneTextString", "zone")
  self:UpdateFont("SubZoneTextString", "subZone")
  self:UpdateFont("PVPArenaTextString", "pvpZone")
  self:UpdateFont("PVPInfoTextString", "pvpZone")

  -- Mail Text
  self:UpdateFont("MailTextFontNormal", "mail")

  if TXUI.IsRetail then
    self:UpdateFont("InvoiceTextFontNormal", "mail")
  else
    self:UpdateFont("InvoiceFont_Med", "mail", medium)
    self:UpdateFont("InvoiceFont_Small", "mail", small)
    self:UpdateFont("MailFont_Large", "mail", large)
  end

  -- Gossip Text
  self:UpdateFont("QuestFont", "gossip")
  self:UpdateFont("QuestFont_Enormous", "gossip", enormous)
  self:UpdateFont("QuestFont_Huge", "gossip", huge)
  self:UpdateFont("QuestFont_Large", "gossip", large)
  self:UpdateFont("QuestFont_Shadow_Huge", "gossip", huge)
  self:UpdateFont("QuestFont_Shadow_Small", "gossip")
  self:UpdateFont("QuestFont_Super_Huge", "gossip", mega)
end

function BF:ShowPreviewText()
  if not self.Initialized or not self.isEnabled then return end

  _G["ZoneTextString"]:SetText("Zone Text")
  _G["PVPInfoTextString"]:SetText("PvP Info Text")
  _G["PVPArenaTextString"]:SetText("PvP Arena Text")
  _G["SubZoneTextString"]:SetText("SubZone Text")

  FadingFrame_Show(_G["ZoneTextFrame"])
  FadingFrame_Show(_G["SubZoneTextFrame"])
end

function BF:Disable()
  if not self.Initialized then return end

  self:UnhookAll()
end

function BF:Enable()
  if not self.Initialized or not self.isEnabled then return end

  self:SettingsUpdate()

  if not self:IsHooked(E, "UpdateBlizzardFonts") then
    self:SecureHook(E, "UpdateBlizzardFonts", F.Event.GenerateClosure(self.SettingsUpdate, self)) -- Secure Hook is fine
  end
end

function BF:DatabaseUpdate()
  -- Disable
  self:Disable()

  -- Set db
  self.db = F.GetDBFromPath("TXUI.blizzardFonts")
  self.isEnabled = TXUI:HasRequirements(I.Requirements.BlizzardFonts) and (self.db and self.db.enabled)

  -- Enable only out of combat
  F.Event.ContinueOutOfCombat(function()
    if self.isEnabled then self:Enable() end
  end)
end

function BF:Initialize()
  -- Don't init second time
  if self.Initialized then return end

  -- Register for updates
  F.Event.RegisterOnceCallback("TXUI.InitializedSafe", F.Event.GenerateClosure(self.DatabaseUpdate, self))
  F.Event.RegisterCallback("TXUI.DatabaseUpdate", self.DatabaseUpdate, self)
  F.Event.RegisterCallback("BlizzardFonts.DatabaseUpdate", self.DatabaseUpdate, self)
  F.Event.RegisterCallback("BlizzardFonts.SettingsUpdate", self.SettingsUpdate, self)
  F.Event.RegisterCallback("BlizzardFonts.ShowPreview", self.ShowPreviewText, self)

  -- We are done, hooray!
  self.Initialized = true
end

TXUI:RegisterModule(BF:GetName())
