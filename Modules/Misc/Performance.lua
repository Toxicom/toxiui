local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local M = TXUI:GetModule("Misc")

local RegisterCVar = (C_CVar and C_CVar.RegisterCVar) or nil
local SetCVar = (C_CVar and C_CVar.SetCVar) or nil
local IsEnabled = (C_AddOnProfiler and C_AddOnProfiler.IsEnabled) or nil

function M:Performance()
  local db = E.db.TXUI.performance

  if not db then return end

  if TXUI.IsRetail then
    RegisterCVar("addonProfilerEnabled", "1")
    SetCVar("addonProfilerEnabled", db.profiler and 0 or 1)

    local profiler = IsEnabled()
    local profilerState = "Profiler not found" -- in case it's nil

    if profiler == true then profilerState = F.String.Error("ON") end
    if profiler == false then profilerState = F.String.Good("OFF") end

    TXUI:LogInfo("Blizzard AddOn profiling is: " .. profilerState)
  end
end

M:AddCallback("Performance")
