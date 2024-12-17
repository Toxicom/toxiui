local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local RY = TXUI:GetModule("Dev"):GetModule("Ryada")

-- Looks like this file is not important ...
--@do-not-package@

-- local SetCVar = SetCVar

local materialElvUIIcons = { "roleIcons", "deadIcons", "offlineIcons" }
local materialRaidIcons = { "leader", "assist", "looter" }
local classIconUnits = { "player", "target", "focus", "party" }

function RY:SetupCvars()
  -- CVars
  -- SetCVar("autoLootDefault", 1)
end

function RY:SetupProfile()
  -- Set ElvUI Icons to Material
  for _, icon in ipairs(materialElvUIIcons) do
    E.db.TXUI.elvUIIcons[icon].theme = "TXUI_MATERIAL"
  end

  -- Set Raid Icons to Material
  for _, icon in ipairs(materialRaidIcons) do
    E.db.TXUI.elvUIIcons.raidIcons[icon].theme = "TXUI_MATERIAL"
  end

  -- Disable UnitFrame Class Icons
  for _, unit in ipairs(classIconUnits) do
    E.db.unitframe.units[unit].customTexts["toxiui:class-icon"].text_format = ""
  end
end

-- RY:AddCallback("SetupCvars")
RY:AddCallback("SetupProfile")

--@end-do-not-package@
