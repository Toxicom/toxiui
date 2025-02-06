local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local M = TXUI:NewModule("Misc", "AceHook-3.0", "AceEvent-3.0")

local _G = _G
local next = next
local tinsert = table.insert
local xpcall = xpcall

M.callOnInit = {}

local function errorhandler(err)
  return _G.geterrorhandler()(err)
end

function M:AddCallback(name, func)
  tinsert(self.callOnInit, func or self[name])
end

-- Initialization
function M:Initialize()
  -- Don't init second time
  if self.Initialized then return end

  -- Call registered submodules
  for index, func in next, self.callOnInit do
    xpcall(func, errorhandler, self)
    self.callOnInit[index] = nil
  end

  -- We are done, hooray!
  self.Initialized = true
end

TXUI:RegisterModule(M:GetName())
