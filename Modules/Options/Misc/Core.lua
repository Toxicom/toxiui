local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")

function O:Misc()
  -- Reset order for new page
  self:ResetOrder()
end

O:AddCallback("Misc")
