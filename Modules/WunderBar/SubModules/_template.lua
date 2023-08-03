local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local WB = TXUI:GetModule("WunderBar")
local TT = WB:NewModule("Template")

function TT:OnEvent(event, ...) end

function TT:OnUpdate(t) end

function TT:OnClick() end

function TT:OnEnter() end

function TT:OnLeave() end

function TT:OnWunderBarUpdate() end

function TT:OnInit(frame)
  -- Don't init second time
  if self.Initialized then return end

  -- Get our settings DB
  self.db = WB:GetSubModuleDB(self:GetName())

  -- We are done, hooray!
  self.Initialized = true
end

WB:RegisterSubModule(TT, { "UPDATE_INSTANCE_INFO" })
