local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local T = TXUI:GetModule("Dev"):GetModule("Toxi")

-- Looks like this file is not important ...
--@do-not-package@

local splitUnitframes = { "player", "focus", "targettarget", "pet" }
local splitAbbrevUnitframes = { "party", "target" }

function T:SetupCvars()
  -- CVars
  E:SetCVar("autoLootDefault", 1)
end

function T:SetupProfile()
  -- Misc
  E.db.TXUI.vehicleBar.enabled = true

  -- Miscellaneous: Additional Scaling
  E.db.TXUI.misc.scaling.enabled = true
  E.db.TXUI.misc.scaling.characterFrame.scale = 1.5
  E.db.TXUI.misc.scaling.syncInspect.enabled = true
  E.db.TXUI.misc.scaling.map.scale = 1.5
  if TXUI.IsRetail then E.db.TXUI.misc.scaling.collections.scale = 1.3 end

  -- ElvUI
  E.db.general.taintLog = false

  -- ElvUI: UnitFrames
  for _, unit in ipairs(splitUnitframes) do
    E.db.unitframe.units[unit].customTexts["toxiui:name"].text_format = "[tx:name:medium:split{Toxi}]"
  end
  for _, unit in ipairs(splitAbbrevUnitframes) do
    E.db.unitframe.units[unit].customTexts["toxiui:name"].text_format = "[tx:name:abbrev:medium:split{Toxi}]"
  end

  -- WindTools
  if TXUI.IsRetail and F.IsAddOnEnabled("ElvUI_WindTools") then
    E.db.WT.item.inspect.enable = false -- clashes with narcissus talent inspect
    E.db.WT.quest.turnIn.enable = true
    E.db.WT.combat.raidMarkers.enable = false
  end
end

function T:SetupPrivate()
  if TXUI.IsRetail and F.IsAddOnEnabled("ElvUI_WindTools") then E.private.WT.misc.moveFrames.rememberPositions = true end
end

T:AddCallback("SetupCvars")
T:AddCallback("SetupProfile")
T:AddCallback("SetupPrivate")

--@end-do-not-package@
