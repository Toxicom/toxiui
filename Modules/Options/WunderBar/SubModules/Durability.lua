local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")
local ACH = LibStub("LibAceConfigHelper")

function O:WunderBar_SubModules_Durability()
  local dbEntry = "Durability"
  local options = self.options.wunderbar.args.submodules.args
  local isUsingToxiUIFont = E.db.general.font == "- ToxiUI"

  local getMounts = function()
    local repairMounts = {}

    for _, mountID in ipairs(I.RepairMounts) do
      local name, _, _, _, isUsable = C_MountJournal.GetMountInfoByID(mountID)

      if isUsable then repairMounts[mountID] = name end
    end

    return repairMounts
  end

  options.durability = ACH:Group((isUsingToxiUIFont and (F.String.ConvertGlyph(59721) .. " ") or "") .. "耐久度", nil, self:GetOrder(), nil, function(info)
    return E.db.TXUI.wunderbar.subModules[dbEntry][info[#info]]
  end, function(info, value)
    E.db.TXUI.wunderbar.subModules[dbEntry][info[#info]] = value
    TXUI:GetModule("WunderBar"):UpdateBar()
  end)

  local tab = options.durability.args
  local iconDisabled = function()
    return not E.db.TXUI.wunderbar.subModules[dbEntry].showIcon
  end

  -- General
  tab.generalGroup = ACH:Group("常规", nil, 1)
  tab.generalGroup.inline = true

  tab.generalGroup.args.showIcon = ACH:Toggle("显示图标", nil, 1)
  tab.generalGroup.args.iconFontSize = ACH:Range("图标大小", nil, 2, {
    min = 1,
    max = 100,
    step = 1,
  }, nil, nil, nil, iconDisabled)

  tab.generalGroup.args.spacer1 = ACH:Spacer(3)

  local itemLevelDisabled = function()
    return not E.db.TXUI.wunderbar.subModules[dbEntry].showItemLevel
  end

  tab.generalGroup.args.showItemLevel = ACH:Toggle("显示物品等级", nil, 4)
  tab.generalGroup.args.itemLevelShort = ACH:Toggle("简短物品等级", nil, 5, nil, nil, nil, nil, nil, itemLevelDisabled)

  -- Repair Mount
  tab.mountGroup = ACH:Group("修理坐骑", nil, 2)
  tab.mountGroup.inline = true
  tab.mountGroup.args.description = ACH:Description("选择右键点击模块时召唤的修理坐骑。\n\n", 1)
  tab.mountGroup.args.repairMount = ACH:Select("选择坐骑", nil, 2, getMounts)
  tab.mountGroup.args.repairMount.width = 2
  tab.mountGroup.args.repairMount.disabled = function()
    return not (C_MountJournal and C_MountJournal.GetMountInfoByID) or F.Table.IsEmpty(getMounts())
  end
  tab.mountGroup.args.repairMount.sortByValue = true

  -- Colors
  tab.colorGroup = ACH:Group("颜色", nil, 3)
  tab.colorGroup.inline = true
  tab.colorGroup.args.iconColor = ACH:Toggle("图标颜色", nil, 1, nil, nil, nil, nil, nil, iconDisabled)
  tab.colorGroup.args.textColor = ACH:Toggle("文字颜色", nil, 2)
  tab.colorGroup.args.textColorFadeFromNormal = ACH:Toggle("文字颜色作为基础", nil, 3)

  -- Animations
  tab.animateGroup = ACH:Group("动画", nil, 4)
  tab.animateGroup.inline = true

  tab.animateGroup.args.animateLow = ACH:Toggle("低耐久动画", nil, 1)
  tab.animateGroup.args.animateThreshold = ACH:Range("动画阈值", nil, 2, {
    min = 1,
    max = 100,
    step = 1,
  })
end
