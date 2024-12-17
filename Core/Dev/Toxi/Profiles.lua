local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local T = TXUI:GetModule("Dev"):GetModule("Toxi")

-- Looks like this file is not important ...
--@do-not-package@

local SetCVar = SetCVar
local disabledMenuIcons = { "chat", "quest", "shop", "spell", "talent", "pvp", "ach", "char", "pet", "lfg" }
local splitUnitframes = { "player", "party", "focus", "targettarget", "pet" }

function T:SetupCvars()
  if E.TimerunningID and UnitLevel("player") < 70 then
    return
  else
    -- CVars
    SetCVar("autoLootDefault", 1)
  end
end

function T:SetupProfile()
  -- Misc
  E.db.TXUI.vehicleBar.enabled = true

  -- WunderBar: General
  E.db.TXUI.wunderbar.general.backgroundTexture = TXUI.IsVanilla and "TX WorldState Score" or "WorldState Score"

  -- WunderBar: Modules
  E.db.TXUI.wunderbar.modules.LeftPanel[2] = "Profession"
  E.db.TXUI.wunderbar.modules.LeftPanel[3] = UnitLevel("player") < 80 and "DataBar" or "Durability"
  E.db.TXUI.wunderbar.modules.MiddlePanel[3] = "Volume"

  -- WunderBar: Submodules
  -- WunderBar: MicroMenu
  for _, icon in ipairs(disabledMenuIcons) do
    E.db.TXUI.wunderbar.subModules.MicroMenu.icons[icon].enabled = false
  end

  -- WunderBar: DataBar
  E.db.TXUI.wunderbar.subModules.DataBar.infoEnabled = true
  E.db.TXUI.wunderbar.subModules.DataBar.showCompletedXP = true

  -- WunderBar: Profession
  E.db.TXUI.wunderbar.subModules.Profession.general.showIcons = true

  -- WunderBar: Hearthstone
  E.db.TXUI.wunderbar.subModules.Hearthstone.primaryHS = TXUI.IsRetail and 209035 or 6948

  -- Miscellaneous: Additional Scaling
  E.db.TXUI.misc.scaling.enabled = true
  E.db.TXUI.misc.scaling.characterFrame.scale = 1.5
  E.db.TXUI.misc.scaling.syncInspect.enabled = true
  E.db.TXUI.misc.scaling.map.scale = 1.5
  if TXUI.IsRetail then
    E.db.TXUI.misc.scaling.collections.scale = 1.3
    E.db.TXUI.misc.scaling.wardrobe.scale = 1.3
  end

  -- ElvUI
  E.db.general.taintLog = false

  -- ElvUI: UnitFrames
  for _, unit in ipairs(splitUnitframes) do
    E.db.unitframe.units[unit].customTexts["toxiui:name"].text_format = "[tx:name:medium:split{Toxi}]"
  end
  E.db.unitframe.units.target.customTexts["toxiui:name"].text_format = "[tx:name:abbrev:medium:split{Toxi}]"

  E.db.bags.bagSize = TXUI.IsRetail and 50 or 60
  E.db.bags.bagButtonSpacing = 2
  E.db.bags.split.player = true

  -- Enable split for bags 1 - 11
  for i = 1, 11 do
    E.db.bags.split["bag" .. i] = true
  end

  E.db.bags.split.bagSpacing = 10
  E.db.bags.split.bankSpacing = 10
  E.db.bags.bank = true
  E.db.bags.bankSize = TXUI.IsRetail and 50 or 60
  E.db.bags.bankButtonSpacing = 2

  if F.IsAddOnEnabled("BetterBags") or F.IsAddOnEnabled("Sorted") then E.private.bags.enable = false end

  -- WindTools
  if TXUI.IsRetail and F.IsAddOnEnabled("ElvUI_WindTools") then
    E.db.WT.item.inspect.enable = false -- clashes with narcissus talent inspect
    E.db.WT.quest.turnIn.enable = false
  end
end

T:AddCallback("SetupCvars")
T:AddCallback("SetupProfile")

--@end-do-not-package@
