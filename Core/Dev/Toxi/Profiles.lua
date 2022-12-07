local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local T = TXUI:GetModule("Dev"):GetModule("Toxi")

-- Looks like this file is not important ...
--@do-not-package@

local SetCVar = SetCVar

function T:SetupCvars()
  -- CVars
  SetCVar("autoLootDefault", 1)
end

function T:SetupProfile()
  -- Font Overrides
  E.db.TXUI.general.fontOverride[I.Fonts.Primary] = "- Personal"
  E.db.TXUI.general.fontOverride[I.Fonts.PrimaryBold] = "- Personal"
  E.db.TXUI.general.fontStyleOverride[I.Fonts.Primary] = "OUTLINE"
  E.db.TXUI.general.fontStyleOverride[I.Fonts.PrimaryBold] = "OUTLINE"

  -- WunderBar: General
  E.db.TXUI.wunderbar.general.backgroundTexture = "TX WorldState Score"

  -- WunderBar: Modules
  E.db.TXUI.wunderbar.modules.LeftPanel[2] = "Profession"
  E.db.TXUI.wunderbar.modules.LeftPanel[3] = "DataBar"
  E.db.TXUI.wunderbar.modules.MiddlePanel[3] = "Volume"

  -- WunderBar: Submodules
  -- WunderBar: MicroMenu
  E.db.TXUI.wunderbar.subModules.MicroMenu.icons.chat.enabled = false
  E.db.TXUI.wunderbar.subModules.MicroMenu.icons.journal.enabled = false
  E.db.TXUI.wunderbar.subModules.MicroMenu.icons.quest.enabled = false
  E.db.TXUI.wunderbar.subModules.MicroMenu.icons.shop.enabled = false
  E.db.TXUI.wunderbar.subModules.MicroMenu.icons.spell.enabled = false
  E.db.TXUI.wunderbar.subModules.MicroMenu.icons.talent.enabled = false
  E.db.TXUI.wunderbar.subModules.MicroMenu.icons.pvp.enabled = false
  E.db.TXUI.wunderbar.subModules.MicroMenu.icons.ach.enabled = false
  E.db.TXUI.wunderbar.subModules.MicroMenu.icons.char.enabled = false
  E.db.TXUI.wunderbar.subModules.MicroMenu.icons.lfg.enabled = false
  E.db.TXUI.wunderbar.subModules.MicroMenu.icons.pet.enabled = false

  E.db.TXUI.wunderbar.subModules.MicroMenu.icons.journal.enabled = true

  -- WunderBar: DataBar
  E.db.TXUI.wunderbar.subModules.DataBar.infoEnabled = true
  E.db.TXUI.wunderbar.subModules.DataBar.showCompletedXP = true

  -- WunderBar: Profession
  E.db.TXUI.wunderbar.subModules.Profession.general.showIcons = true

  -- WunderBar: Hearthstone
  E.db.TXUI.wunderbar.subModules.Hearthstone.primaryHS = TXUI.IsRetail and 193588 or 6948

  -- Themes: Gradient Mode
  E.db.TXUI.themes.gradientMode.classColorMap[1]["DEATHKNIGHT"] = F.Table.HexToRGB("#6e1234")

  -- Skins: ElvUI
  E.db.TXUI.addons.elvUITheme.enabled = true
  E.db.TXUI.addons.elvUITheme.shadowEnabled = true
  E.db.TXUI.addons.elvUITheme.shadowAlpha = 0.75
  E.db.TXUI.addons.elvUITheme.shadowSize = 6

  -- ElvUI
  E.db.general.taintLog = false

  -- ElvUI: Movers
  E.db.movers.ToxiUIWAAnchorMover = "BOTTOM,ElvUIParent,BOTTOM,0,395"

  -- ElvUI: Bags
  E.db.bags.useBlizzardCleanup = true

  E.db.bags.bagSize = TXUI.IsRetail and 50 or 60
  E.db.bags.bagButtonSpacing = 2
  E.db.bags.split.player = true
  E.db.bags.split.bag1 = true
  E.db.bags.split.bag2 = true
  E.db.bags.split.bag3 = true
  E.db.bags.split.bag4 = true
  E.db.bags.split.bagSpacing = 10

  E.db.bags.bankSize = TXUI.IsRetail and 50 or 60
  E.db.bags.bankButtonSpacing = 2
  E.db.bags.bank = true
  E.db.bags.split.bag5 = true
  E.db.bags.split.bag6 = true
  E.db.bags.split.bag7 = true
  E.db.bags.split.bag8 = true
  E.db.bags.split.bag9 = true
  E.db.bags.split.bag10 = true
  E.db.bags.split.bag11 = true
  E.db.bags.split.bankSpacing = 10

  -- WindTools
  E.db.WT.item.inspect.enable = false -- clashes with narcissus talent inspect
end

T:AddCallback("SetupCvars")
T:AddCallback("SetupProfile")

--@end-do-not-package@
