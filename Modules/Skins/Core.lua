local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local S = TXUI:GetModule("Skins")

function S:Enable()
  if self.isEnabled or not self.Initialized then return end
  self.isEnabled = true

  F.Event.ContinueOnAddOnLoaded("AddOnSkins", F.Event.GenerateClosure(self.AddOnSkins, self))
  F.Event.ContinueOnAddOnLoaded("ElvUI_WindTools", F.Event.GenerateClosure(self.ElvUI_WindTools, self))
end

function S:DatabaseUpdate()
  if self.isEnabled or not self.Initialized then return end

  F.Event.ContinueOutOfCombat(function()
    -- Enable only out of combat
    if F.IsTXUIProfile() then self:Enable() end
  end)
end

function S:Initialize()
  -- Don't init second time
  if self.Initialized then return end

  -- Vars
  self.isEnabled = false

  -- Register for updates
  F.Event.RegisterOnceCallback("TXUI.InitializedSafe", F.Event.GenerateClosure(self.DatabaseUpdate, self))
  F.Event.RegisterCallback("TXUI.DatabaseUpdate", self.DatabaseUpdate, self)

  -- We are done, hooray!
  self.Initialized = true
end

TXUI:RegisterModule(S:GetName())
