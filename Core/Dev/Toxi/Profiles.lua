local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local T = TXUI:GetModule("Dev"):GetModule("Toxi")

-- Looks like this file is not important ...
--@do-not-package@

local SetCVar = SetCVar
local disabledMenuIcons = { "chat", "quest", "shop", "spell", "talent", "pvp", "ach", "char", "lfg", "pet" }

function T:SetupCvars()
  -- CVars
  SetCVar("autoLootDefault", 1)
end

function T:SetupProfile()
  -- WunderBar: General
  E.db.TXUI.wunderbar.general.backgroundTexture = TXUI.IsClassic and "TX WorldState Score" or "WorldState Score"

  -- WunderBar: Modules
  E.db.TXUI.wunderbar.modules.LeftPanel[2] = "Profession"
  E.db.TXUI.wunderbar.modules.LeftPanel[3] = "DataBar"
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
  E.db.TXUI.wunderbar.subModules.Hearthstone.primaryHS = TXUI.IsRetail and 193588 or 6948

  -- Miscellaneous: Additional Scaling
  E.db.TXUI.misc.scaling.characterFrame.scale = 1.5
  E.db.TXUI.misc.scaling.syncInspect.enabled = true
  E.db.TXUI.misc.scaling.map.scale = 1.5
  if TXUI.IsRetail then
    E.db.TXUI.misc.scaling.collections.scale = 1.3
    E.db.TXUI.misc.scaling.wardrobe.scale = 1.3
  end

  -- Skins: WeakAuras
  E.db.TXUI.addons.weakAurasIcons.iconShape = TXUI.IsWrath and I.Enum.IconShape.SQUARE or I.Enum.IconShape.RECTANGLE

  -- ElvUI
  E.db.general.taintLog = false

  -- ElvUI: Movers
  E.db.movers.ToxiUIWAAnchorMover = "BOTTOM,ElvUIParent,BOTTOM,0,395"

  -- ElvUI: Bags
  E.db.bags.useBlizzardCleanup = true

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

  -- WindTools
  if TXUI.IsRetail then
    E.db.WT.item.inspect.enable = false -- clashes with narcissus talent inspect
  end
end

T:AddCallback("SetupCvars")
T:AddCallback("SetupProfile")

--@end-do-not-package@
