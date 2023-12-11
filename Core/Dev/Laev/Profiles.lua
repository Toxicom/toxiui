local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local LAEV = TXUI:GetModule("Dev"):GetModule("Laev")

-- Looks like this file is not important ...
--@do-not-package@

-- local SetCVar = SetCVar

-- function LAEV:SetupCvars()
--   -- CVars
-- end

function LAEV:SetupProfile()
  -- Do something here
end

-- LAEV:AddCallback("SetupCvars")
LAEV:AddCallback("SetupProfile")

--@end-do-not-package@
