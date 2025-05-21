local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local M = TXUI:GetModule("Misc")

local _G = _G
local CreateFrame = CreateFrame

function M:WeakAuraAnchorLoad()
  local frame = CreateFrame("Frame", "ToxiUIWAAnchor", E.UIParent, "BackdropTemplate")
  frame:SetParent(_G["ElvUF_Player"])
  frame:SetPoint("CENTER", E.UIParent, "CENTER", F.Dpi(0), F.Dpi(-200))
  frame:SetFrameStrata("BACKGROUND")
  frame:SetSize(F.Dpi(300), F.Dpi(100))

  E:CreateMover(frame, "ToxiUIWAAnchorMover", TXUI.Title .. " WA Anchor", nil, nil, nil, "ALL,TXUI")
end

-- Created dummy WeakAura Anchor, for use by advanced users
function M:WeakAuraAnchor()
  -- Get Frameworks
  local uf = E:GetModule("UnitFrames")

  -- Enable!
  if uf.unitstoload ~= nil then
    self:SecureHook(uf, "LoadUnits", "WeakAuraAnchorLoad")
  else
    self:WeakAuraAnchorLoad()
  end
end

M:AddCallback("WeakAuraAnchor")
