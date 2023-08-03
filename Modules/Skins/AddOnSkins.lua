local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local S = TXUI:GetModule("Skins")

-- Globals
local _G = _G
local unpack = unpack

-- Vars
local AS

-- InFlight
function S:AddOnSkins_InFlight()
  local InFlight = _G.InFlight
  if self:IsHooked(InFlight, "UpdateLook") then return end

  self:SecureHook(InFlight, "UpdateLook", function(inFlight)
    if not _G.InFlightBar then inFlight:CreateBar() end
    local bar = _G.InFlightBar

    local backdrop = AS:FindChildFrameByPoint(bar, "Frame", "TOPLEFT", bar, "TOPLEFT", -5, 5)
    if backdrop then backdrop:Kill() end

    bar:CreateBackdrop("Transparent")
  end)
end

function S:AddOnSkins()
  -- Get Frameworks
  AS = unpack(_G.AddOnSkins)

  -- AddOnSkins not found?
  if not AS then return self:LogDebug("Could not find AddOnSkins") end

  -- InFlight
  if AS:CheckAddOn("InFlight_Load") then
    local title = TXUI.Title .. ": InFlight"

    AS:RegisterSkin(title, S.AddOnSkins_InFlight)
    if AS:CheckOption(title) then F.Event.ContinueOnAddOnLoaded("InFlight", F.Event.GenerateClosure(self.AddOnSkins_InFlight, self)) end
  end
end
