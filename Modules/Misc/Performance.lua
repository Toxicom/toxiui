local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local M = TXUI:GetModule("Misc")

function M:Performance()
  local db = E.db.TXUI.performance

  if not db then return end

  if TXUI.IsRetail then
    C_CVar.RegisterCVar("addonProfilerEnabled", "1")
    C_CVar.SetCVar("addonProfilerEnabled", db.profiler and 0 or 1)
  end
end

M:AddCallback("Performance")
