local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local RAI = TXUI:NewModule("RaidIcons", "AceHook-3.0")

local GetPartyAssignment = _G.GetPartyAssignment

-- oUF's LeaderIndicator resets its texture on every update and ElvUI doesn't give it a PostUpdate
function RAI:UpdateLeaderIcon()
  local db = E.db and E.db.TXUI and E.db.TXUI.elvUIIcons and E.db.TXUI.elvUIIcons.raidIcons
  if not (db and db.leader.enabled and db.leader.theme) then return end

  self:SetTexCoord(0, 1, 0, 1)
  self:SetTexture(F.GetMedia(I.Media.StateIcons, I.ElvUIIcons.Leader[db.leader.theme]))
end

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
    local raid = frame.RaidRoleIndicator

    if leader then
      if not leader.PostUpdate then leader.PostUpdate = RAI.UpdateLeaderIcon end
      RAI.UpdateLeaderIcon(leader)
    end

    if assistant and db.assist.enabled then
      if db.assist.theme then
        assistant:SetTexCoord(0, 1, 0, 1)
        assistant:SetTexture(F.GetMedia(I.Media.StateIcons, I.ElvUIIcons.Assist[self.db.assist.theme]))
      end
    end

    if master and db.looter.enabled then
      if db.looter.theme then
        master:SetTexCoord(0, 1, 0, 1)
        master:SetTexture(F.GetMedia(I.Media.StateIcons, I.ElvUIIcons.Looter[self.db.looter.theme]))
      end
    end

    if raid and (db.mainAssist.enabled or db.mainTank.enabled) then
      if db.leader.theme then
        raid:SetTexCoord(0, 1, 0, 1)
        if GetPartyAssignment("MAINTANK", frame.__unit) and db.mainTank.enabled then
          raid:SetTexture(F.GetMedia(I.Media.StateIcons, I.ElvUIIcons.MainTank[self.db.mainTank.theme]))
        elseif GetPartyAssignment("MAINASSIST", frame.__unit) and db.mainAssist.enabled then
          raid:SetTexture(F.GetMedia(I.Media.StateIcons, I.ElvUIIcons.MainAssist[self.db.mainAssist.theme]))
        end
      end
    end
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
