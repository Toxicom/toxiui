local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")

function O:WunderBar_SubModules()
  self:ResetOrder()

  self:WunderBar_SubModules_Currency()
  self:WunderBar_SubModules_DataBar()
  self:WunderBar_SubModules_Durability()
  self:WunderBar_SubModules_Hearthstone()
  self:WunderBar_SubModules_MicroMenu()
  self:WunderBar_SubModules_Profession()
  self:WunderBar_SubModules_SpecSwitch()
  self:WunderBar_SubModules_System()
  self:WunderBar_SubModules_Time()
  self:WunderBar_SubModules_Volume()
  self:WunderBar_SubModules_ElvUILDB()
end
