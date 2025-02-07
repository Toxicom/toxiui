local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")
local ACH = LibStub("LibAceConfigHelper")

function O:WunderBar_SubModules_System()
  local options = self.options.wunderbar.args.submodules.args
  local isUsingToxiUIFont = E.db.general.font == "- ToxiUI"

  options.system = ACH:Group((isUsingToxiUIFont and (F.String.ConvertGlyph(59718) .. " ") or "") .. "系统", nil, self:GetOrder(), nil, function(info)
    return E.db.TXUI.wunderbar.subModules["System"][info[#info]]
  end, function(info, value)
    E.db.TXUI.wunderbar.subModules["System"][info[#info]] = value
    TXUI:GetModule("WunderBar"):UpdateBar()
  end)

  local tab = options.system.args
  local iconsDisabled = function()
    return not E.db.TXUI.wunderbar.subModules["System"].showIcons
  end

  local colorsDisabled = function()
    return not (E.db.TXUI.wunderbar.subModules["System"].textColor or (E.db.TXUI.wunderbar.subModules["System"].showIcons and E.db.TXUI.wunderbar.subModules["System"].iconColor))
  end

  -- General
  tab.generalGroup = ACH:Group("常规", nil, 1)
  tab.generalGroup.inline = true

  tab.generalGroup.args.fastUpdate = ACH:Toggle("快速更新", nil, 1)
  tab.generalGroup.args.useWorldLatency = ACH:Toggle("使用世界延迟", nil, 2)
  tab.generalGroup.args.showIcons = ACH:Toggle("显示图标", nil, 3)
  tab.generalGroup.args.iconFontSize = ACH:Range("图标大小", nil, 4, {
    min = 1,
    max = 100,
    step = 1,
  }, nil, nil, nil, iconsDisabled)

  -- Colors
  tab.colorGroup = ACH:Group("颜色", nil, 2)
  tab.colorGroup.inline = true
  tab.colorGroup.args.iconColor = ACH:Toggle("图标颜色", nil, 1, nil, nil, nil, nil, nil, iconsDisabled)
  tab.colorGroup.args.textColor = ACH:Toggle("文字颜色", nil, 2)
  tab.colorGroup.args.textColorFadeFromNormal = ACH:Toggle("文字颜色作为基础", nil, 3, nil, nil, nil, nil, nil, colorsDisabled)

  tab.colorGroup.args.spacer1 = ACH:Spacer(4)

  tab.colorGroup.args.textColorFramerateThreshold = ACH:Range("帧率阈值", nil, 5, {
    min = 1,
    max = 1000,
    step = 1,
  }, nil, nil, nil, colorsDisabled)
  tab.colorGroup.args.textColorLatencyThreshold = ACH:Range("延迟阈值", nil, 6, {
    min = 1,
    max = 1000,
    step = 1,
  }, nil, nil, nil, colorsDisabled)
end
