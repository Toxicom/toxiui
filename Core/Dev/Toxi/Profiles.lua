local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local T = TXUI:GetModule("Dev"):GetModule("Toxi")

-- Looks like this file is not important ...
--@do-not-package@

local SetCVar = SetCVar
local unitframeTypes = { "player", "party", "focus", "target", "arena", "boss" }
local disabledMenuIcons = { "chat", "quest", "shop", "spell", "talent", "pvp", "ach", "char", "lfg", "pet" }

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

  -- Enable split for bags 1 - 11
  for i = 1, 11 do
    E.db.bags.split["bag" .. i] = true
  end

  E.db.bags.split.bagSpacing = 10
  E.db.bags.split.bankSpacing = 10
  E.db.bags.bank = true
  E.db.bags.bankSize = TXUI.IsRetail and 50 or 60
  E.db.bags.bankButtonSpacing = 2

  -- ElvUI: UnitFrames
  for _, ufType in ipairs(unitframeTypes) do
    E.db.unitframe.units[ufType].customTexts["!Health"].font = "- Personal"
    E.db.unitframe.units[ufType].customTexts["!Health"].fontOutline = "OUTLINE"
    E.db.unitframe.units[ufType].customTexts["!Health"].size = 36
    E.db.unitframe.units[ufType].customTexts["!Health"].text_format = "[tx:classcolor][perhp]"
    E.db.unitframe.units[ufType].customTexts["!Health"].yOffset = 15
  end

  -- WindTools
  E.db.WT.item.inspect.enable = false -- clashes with narcissus talent inspect
end

T:AddCallback("SetupCvars")
T:AddCallback("SetupProfile")

--@end-do-not-package@
