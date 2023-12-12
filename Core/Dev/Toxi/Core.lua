local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local D = TXUI:GetModule("Dev")
local T = D:NewModule("Toxi")

local _G = _G
local next = next
local tinsert = table.insert
local xpcall = xpcall

T.callOnInit = {}

local function errorhandler(err)
  return _G.geterrorhandler()(err)
end

function T:AddCallback(name, func)
  tinsert(self.callOnInit, func or self[name])
end

-- Initialization
function T:Initialize()
  -- Don't init second time
  if self.Initialized then return end

  -- Don't init if its not a TXUI profile
  if not F.IsTXUIProfile() then return end

  -- Call registered submodules
  for index, func in next, self.callOnInit do
    xpcall(func, errorhandler, self)
    self.callOnInit[index] = nil
  end

  E:UpdateFontTemplates()

  -- Print out that dev modules ran
  self:LogInfo(F.String.FastGradient("Turbo mode initialized. You are now in DEV+ mode!", 0.57, 0.92, 0.49, 0.38, 0.81, 0.43))

  -- We are done, hooray!
  self.Initialized = true
end

D:RegisterSubModule(T:GetName(), I.Enum.Developers.TOXI)
