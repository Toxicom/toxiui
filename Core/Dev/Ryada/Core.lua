local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local D = TXUI:GetModule("Dev")
local RY = D:NewModule("Ryada")

local _G = _G
local next = next
local tinsert = table.insert
local xpcall = xpcall

RY.callOnInit = {}

local function errorhandler(err)
  return _G.geterrorhandler()(err)
end

function RY:AddCallback(name, func)
  tinsert(self.callOnInit, func or self[name])
end

-- Initialization
function RY:Initialize()
  -- Don't init second time
  if self.Initialized then return end

  -- Don't init if its not a TXUI profile
  if not F.IsTXUIProfile() then return end

  -- Call registered submodules
  for index, func in next, self.callOnInit do
    xpcall(func, errorhandler, self)
    self.callOnInit[index] = nil
  end

  -- Print out that dev modules ran
  self:LogInfo(F.String.FastGradient("Ryada you lazy person, you are now in DEV+ mode!", 0.57, 0.92, 0.49, 0.38, 0.81, 0.43))

  -- We are done, hooray!
  self.Initialized = true
end

D:RegisterSubModule(RY:GetName(), I.Enum.Developers.RYADA)
