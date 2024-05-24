local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local M = TXUI:GetModule("Misc")

local _G = _G

function M:HideFrames()
  self.db = E and E.db and E.db.TXUI and E.db.TXUI.misc and E.db.TXUI.misc.hide or nil

  if not self.db then return end
  if not self.db.enabled then return end

  local lootFrame = _G.GroupLootHistoryFrame
  if self.db.lootFrame then
    if lootFrame then lootFrame:SetScript("OnShow", function()
      lootFrame:Hide()
    end) end
  else
    if lootFrame then lootFrame:SetScript("OnShow", nil) end
  end
end

M:AddCallback("HideFrames")
