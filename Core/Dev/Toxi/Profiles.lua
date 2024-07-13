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
  E.db.TXUI.wunderbar.subModules.Hearthstone.primaryHS = TXUI.IsRetail and 208704 or 6948

  -- Miscellaneous: Additional Scaling
  E.db.TXUI.misc.scaling.enabled = true
  E.db.TXUI.misc.scaling.characterFrame.scale = 1.5
  E.db.TXUI.misc.scaling.syncInspect.enabled = true
  E.db.TXUI.misc.scaling.map.scale = 1.5
  if TXUI.IsRetail then
    E.db.TXUI.misc.scaling.collections.scale = 1.3
    E.db.TXUI.misc.scaling.wardrobe.scale = 1.3
  end

  -- Class colors
  E.db.TXUI.themes.gradientMode.textures.health = "- ToxiUI"
  E.db.TXUI.themes.gradientMode.textures.power = "- ToxiUI"
  E.db.TXUI.themes.gradientMode.textures.cast = "- ToxiUI"
  E.db["TXUI"]["themes"]["gradientMode"]["classColorMap"][1]["MAGE"] = F.Table.HexToRGB("#9400e3")
  E.db["TXUI"]["themes"]["gradientMode"]["classColorMap"][2]["MAGE"] = F.Table.HexToRGB("#00b1fc")
  E.db["TXUI"]["themes"]["gradientMode"]["classColorMap"][1]["PALADIN"] = F.Table.HexToRGB("#b831d9")
  E.db["TXUI"]["themes"]["gradientMode"]["classColorMap"][2]["PALADIN"] = F.Table.HexToRGB("#f567ab")
  E.db["TXUI"]["themes"]["gradientMode"]["classColorMap"][1]["SHAMAN"] = F.Table.HexToRGB("#00bf87")
  E.db["TXUI"]["themes"]["gradientMode"]["classColorMap"][2]["SHAMAN"] = F.Table.HexToRGB("#0059ed")
  E.db["TXUI"]["themes"]["gradientMode"]["classColorMap"][1]["HUNTER"] = F.Table.HexToRGB("#00cc59")
  E.db["TXUI"]["themes"]["gradientMode"]["classColorMap"][2]["HUNTER"] = F.Table.HexToRGB("#d9ff00")
  E.db["TXUI"]["themes"]["gradientMode"]["classColorMap"][1]["ROGUE"] = F.Table.HexToRGB("#ff00bd")
  E.db["TXUI"]["themes"]["gradientMode"]["classColorMap"][2]["ROGUE"] = F.Table.HexToRGB("#ffd200")
  E.db["TXUI"]["themes"]["gradientMode"]["classColorMap"][1]["WARRIOR"] = F.Table.HexToRGB("#fb00a9")
  E.db["TXUI"]["themes"]["gradientMode"]["classColorMap"][2]["WARRIOR"] = F.Table.HexToRGB("#ffba6e")
  E.db["TXUI"]["themes"]["gradientMode"]["classColorMap"][1]["DEATHKNIGHT"] = F.Table.HexToRGB("#7c00ba")
  E.db["TXUI"]["themes"]["gradientMode"]["classColorMap"][2]["DEATHKNIGHT"] = F.Table.HexToRGB("#f52b00")
  E.db["TXUI"]["themes"]["gradientMode"]["classColorMap"][1]["DEMONHUNTER"] = F.Table.HexToRGB("#000fb3")
  E.db["TXUI"]["themes"]["gradientMode"]["classColorMap"][2]["DEMONHUNTER"] = F.Table.HexToRGB("#ba00f5")
  E.db["TXUI"]["themes"]["gradientMode"]["classColorMap"][1]["MONK"] = F.Table.HexToRGB("#0080bf")
  E.db["TXUI"]["themes"]["gradientMode"]["classColorMap"][2]["MONK"] = F.Table.HexToRGB("#00ff96")
  E.db["TXUI"]["themes"]["gradientMode"]["classColorMap"][1]["EVOKER"] = F.Table.HexToRGB("#2c7e6c")
  E.db["TXUI"]["themes"]["gradientMode"]["classColorMap"][2]["EVOKER"] = F.Table.HexToRGB("#008dff")
  E.db["TXUI"]["themes"]["gradientMode"]["classColorMap"][1]["DRUID"] = F.Table.HexToRGB("#ad47ff")
  E.db["TXUI"]["themes"]["gradientMode"]["classColorMap"][2]["DRUID"] = F.Table.HexToRGB("#ff7d0a")
  E.db["TXUI"]["themes"]["gradientMode"]["classColorMap"][1]["PRIEST"] = F.Table.HexToRGB("#ffc29e")
  E.db["TXUI"]["themes"]["gradientMode"]["classColorMap"][2]["PRIEST"] = F.Table.HexToRGB("#a68eff")
  E.db["TXUI"]["themes"]["gradientMode"]["classColorMap"][1]["WARLOCK"] = F.Table.HexToRGB("#ad003a")
  E.db["TXUI"]["themes"]["gradientMode"]["classColorMap"][2]["WARLOCK"] = F.Table.HexToRGB("#8561ed")

  -- ElvUI
  E.db.general.taintLog = false

  -- ElvUI: UnitFrames
  for _, unit in ipairs(splitUnitframes) do
    E.db.unitframe.units[unit].customTexts["!Name"].text_format = "[tx:name:medium:split{Toxi}]"
  end
  E.db.unitframe.units.target.customTexts["!Name"].text_format = "[tx:name:abbrev:medium:split{Toxi}]"

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

  if F.IsAddOnEnabled("BetterBags") then E.private.bags.enable = false end

  -- WindTools
  if TXUI.IsRetail then
    E.db.WT.item.inspect.enable = false -- clashes with narcissus talent inspect
    E.db.WT.quest.turnIn.enable = true
  end
end

T:AddCallback("SetupCvars")
T:AddCallback("SetupProfile")

--@end-do-not-package@
