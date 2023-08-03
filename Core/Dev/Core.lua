local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local D = TXUI:NewModule("Dev", "AceHook-3.0", "AceEvent-3.0")

local _G = _G
local next = next
local tinsert = table.insert
local unpack = unpack
local xpcall = xpcall

D.callOnInit = {}

local function errorhandler(err)
  return _G.geterrorhandler()(err)
end

function D:RegisterSubModule(name, dev)
  tinsert(self.callOnInit, { name, dev })
end

-- Initialization
function D:Initialize()
  -- Don't init second time
  if self.Initialized then return end

  -- Don't init if its not a TXUI profile
  if not F.IsTXUIProfile() then return end

  local devFeatures = false

  -- Call registered submodules
  for index, info in next, self.callOnInit do
    local name, dev = unpack(info)

    if F.IsDeveloper(dev) then
      local module = self:GetModule(name)
      devFeatures = true

      TXUI:ModulePreInitialize(module)
      if module.Initialize then xpcall(module.Initialize, errorhandler, module) end
    end

    self.callOnInit[index] = nil
  end

  if TXUI.DevRelease and devFeatures then TXUI.DevTag = F.String.Error("[DEV+]") end

  -- We are done, hooray!
  self.Initialized = true
end

TXUI:RegisterModule(D:GetName())
