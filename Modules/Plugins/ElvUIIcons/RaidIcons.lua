local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local RAI = TXUI:NewModule("RaidIcons", "AceHook-3.0")

function RAI:ChangeRaidIcon()
  local db = E.db and E.db.TXUI and E.db.TXUI.elvUIIcons and E.db.TXUI.elvUIIcons.raidIcons
  if db then
    self.db = F.GetDBFromPath("TXUI.elvUIIcons.raidIcons")

    local anchor = self:GetParent()
    local frame = anchor and anchor:GetParent():GetParent()
    if not frame then return end

    local leader = frame.LeaderIndicator
    local assistant = frame.AssistantIndicator
    local master = frame.MasterLooterIndicator
    -- local raid = frame.RaidRoleIndicator

    if frame.LeaderIndicator and db.leader.enabled then
      if db.leader.theme then
        leader:SetTexCoord(0, 1, 0, 1)
        leader:SetTexture(F.GetMedia(I.Media.StateIcons, I.ElvUIIcons.Leader[self.db.leader.theme]))
      end
    end

    if frame.AssistantIndicator and db.assist.enabled then
      if db.assist.theme then
        assistant:SetTexCoord(0, 1, 0, 1)
        assistant:SetTexture(F.GetMedia(I.Media.StateIcons, I.ElvUIIcons.Assist[self.db.assist.theme]))
      end
    end

    if frame.MasterLooterIndicator then
      if db.looter.theme then
        master:SetTexCoord(0, 1, 0, 1)
        master:SetTexture(F.GetMedia(I.Media.StateIcons, I.ElvUIIcons.Looter[self.db.theme]))
      end
    end

    -- if frame.RaidRoleIndicator then
    --   if db.theme then
    --     raid:SetTexCoord(0, 1, 0, 1)
    --     raid:SetTexture(F.GetMedia(I.Media.StateIcons, I.ElvUIIcons.Leader[self.db.theme]))
    --   end
    -- end
  end
end

function RAI:Initialize()
  -- Don't init second time
  if self.Initialized then return end

  local UF = E:GetModule("UnitFrames")
  hooksecurefunc(UF, "RaidRoleUpdate", RAI.ChangeRaidIcon)

  -- We are done, hooray!
  self.Initialized = true
end

TXUI:RegisterModule(RAI:GetName())
