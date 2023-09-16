local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local LI = TXUI:NewModule("LeaderIcons", "AceHook-3.0")

function LI:ChangeLeaderIcon()
  local db = E.db and E.db.TXUI and E.db.TXUI.elvUIIcons and E.db.TXUI.elvUIIcons.leaderIcons
  if db then
    if db.enabled == false then return end

    self.db = F.GetDBFromPath("TXUI.elvUIIcons.leaderIcons")

    local anchor = self:GetParent()
    local frame = anchor and anchor:GetParent():GetParent()
    if not frame then return end

    local leader = frame.LeaderIndicator
    -- local assistant = frame.AssistantIndicator
    -- local master = frame.MasterLooterIndicator
    -- local raid = frame.RaidRoleIndicator

    if frame.LeaderIndicator then
      if db.theme then
        leader:SetTexCoord(0, 1, 0, 1)
        leader:SetTexture(F.GetMedia(I.Media.StateIcons, I.ElvUIIcons.Leader[self.db.theme]))
      end
    end

    -- if frame.AssistantIndicator then
    --   if db.theme then
    --     assistant:SetTexCoord(0, 1, 0, 1)
    --     assistant:SetTexture(F.GetMedia(I.Media.StateIcons, I.ElvUIIcons.Leader[self.db.theme]))
    --   end
    -- end

    -- if frame.MasterLooterIndicator then
    --   if db.theme then
    --     master:SetTexCoord(0, 1, 0, 1)
    --     master:SetTexture(F.GetMedia(I.Media.StateIcons, I.ElvUIIcons.Leader[self.db.theme]))
    --   end
    -- end

    -- if frame.RaidRoleIndicator then
    --   if db.theme then
    --     raid:SetTexCoord(0, 1, 0, 1)
    --     raid:SetTexture(F.GetMedia(I.Media.StateIcons, I.ElvUIIcons.Leader[self.db.theme]))
    --   end
    -- end
  end
end

function LI:Initialize()
  -- Don't init second time
  if self.Initialized then return end

  local UF = E:GetModule("UnitFrames")
  hooksecurefunc(UF, "RaidRoleUpdate", LI.ChangeLeaderIcon)

  -- We are done, hooray!
  self.Initialized = true
end

TXUI:RegisterModule(LI:GetName())
