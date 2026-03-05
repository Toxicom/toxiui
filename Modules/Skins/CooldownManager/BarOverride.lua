local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local CM = TXUI:GetModule("CooldownManager")

local function RefreshPlayerUF()
  F.Event.ContinueOutOfCombat(function()
    local uf = E:GetModule("UnitFrames")
    if uf and uf.CreateAndUpdateUF then uf:CreateAndUpdateUF("player") end
  end)
end

function CM:ApplyClassBarOverride()
  local db = self.db and self.db.classBarOverride
  if not db or not db.enabled then return end

  local playerDB = E.db.unitframe and E.db.unitframe.units and E.db.unitframe.units.player
  if not playerDB or not playerDB.classbar then return end

  local shouldDisable = db.specs and db.specs[E.myspecID]
  playerDB.classbar.enable = not shouldDisable
end

function CM:ApplyPowerBarOverride()
  local db = self.db and self.db.powerBarOverride
  if not db or not db.enabled then return end

  local playerDB = E.db.unitframe and E.db.unitframe.units and E.db.unitframe.units.player
  if not playerDB or not playerDB.power then return end

  local shouldDisable = db.specs and db.specs[E.myspecID]
  playerDB.power.enable = not shouldDisable
end

function CM:ApplyBarOverrides()
  self:ApplyClassBarOverride()
  self:ApplyPowerBarOverride()
  RefreshPlayerUF()
end

function CM:EnableBarOverrides()
  self:ApplyBarOverrides()
  self:SecureHook(E, "CheckRole", "ApplyBarOverrides")
end

function CM:DisableBarOverrides()
  if self:IsHooked(E, "CheckRole") then self:Unhook(E, "CheckRole") end
end
