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

  options.durability = ACH:Group((isUsingToxiUIFont and (F.String.ConvertGlyph(59721) .. " ") or "") .. "Durability", nil, self:GetOrder(), nil, function(info)
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
  tab.generalGroup = ACH:Group("General", nil, 1)
  tab.generalGroup.inline = true

  tab.generalGroup.args.showIcon = ACH:Toggle("Show Icon", nil, 1)
  tab.generalGroup.args.iconFontSize = ACH:Range("Icon Size", nil, 2, {
    min = 1,
    max = 100,
    step = 1,
  }, nil, nil, nil, iconDisabled)

  tab.generalGroup.args.spacer1 = ACH:Spacer(3)

  local itemLevelDisabled = function()
    return not E.db.TXUI.wunderbar.subModules[dbEntry].showItemLevel
  end

  tab.generalGroup.args.showItemLevel = ACH:Toggle("Show Item Level", nil, 4)
  tab.generalGroup.args.itemLevelShort = ACH:Toggle("Short Item Level", nil, 5, nil, nil, nil, nil, nil, itemLevelDisabled)

  -- Repair Mount
  tab.mountGroup = ACH:Group("Repair Mount", nil, 2)
  tab.mountGroup.inline = true
  tab.mountGroup.args.description = ACH:Description("Select which repair mount will be summoned when right-clicking the module.\n\n", 1)
  tab.mountGroup.args.repairMount = ACH:Select("Select Mount", nil, 2, getMounts)
  tab.mountGroup.args.repairMount.width = 2
  tab.mountGroup.args.repairMount.disabled = function()
    return not (C_MountJournal and C_MountJournal.GetMountInfoByID) or F.Table.IsEmpty(getMounts())
  end
  tab.mountGroup.args.repairMount.sortByValue = true

  -- Colors
  tab.colorGroup = ACH:Group("Colors", nil, 3)
  tab.colorGroup.inline = true
  tab.colorGroup.args.iconColor = ACH:Toggle("Color Icon", nil, 1, nil, nil, nil, nil, nil, iconDisabled)
  tab.colorGroup.args.textColor = ACH:Toggle("Color Text", nil, 2)
  tab.colorGroup.args.textColorFadeFromNormal = ACH:Toggle("Text Color as Base", nil, 3)

  -- Animations
  tab.animateGroup = ACH:Group("Animations", nil, 4)
  tab.animateGroup.inline = true

  tab.animateGroup.args.animateLow = ACH:Toggle("Animate Low", nil, 1)
  tab.animateGroup.args.animateThreshold = ACH:Range("Animate Threshold", nil, 2, {
    min = 1,
    max = 100,
    step = 1,
  })
end
