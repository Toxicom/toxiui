local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local LI = TXUI:NewModule("LeaderIcons", "AceHook-3.0")

local _G = _G

function LI:Something()
  local db = E.db and E.db.TXUI and E.db.TXUI.elvUIIcons and E.db.TXUI.elvUIIcons.leaderIcons
  if db then
    if not db.enabled then return end

    self.db = F.GetDBFromPath("TXUI.elvUIIcons.leaderIcons")

    local anchor = self:GetParent()
    local frame = anchor and anchor:GetParent():GetParent()
    if not frame then return end

    local leader = frame.LeaderIndicator

    if frame.LeaderIndicator then
      if db.theme then leader:SetTexture(F.GetMedia(I.Media.StateIcons, I.ElvUIIcons.Leader[self.db.theme])) end
    end
  end
end

function LI:Initialize()
  -- Don't init second time
  if self.Initialized then return end

  -- Get Frameworks
  UF = E:GetModule("UnitFrames")
  hooksecurefunc(UF, "RaidRoleUpdate", LI.Something)

  -- We are done, hooray!
  self.Initialized = true
end

TXUI:RegisterModule(LI:GetName())
