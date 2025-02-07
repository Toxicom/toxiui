local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")
local ACH = LibStub("LibAceConfigHelper")

function O:WunderBar_SubModules_SpecSwitch()
  local dbEntry = "SpecSwitch"
  local options = self.options.wunderbar.args.submodules.args
  local isUsingToxiUIFont = E.db.general.font == "- ToxiUI"

  options.specswitch = ACH:Group((isUsingToxiUIFont and (F.String.ConvertGlyph(59707) .. " ") or "") .. "天赋切换", nil, self:GetOrder(), nil, function(info)
    return E.db.TXUI.wunderbar.subModules[dbEntry].general[info[#info]]
  end, function(info, value)
    E.db.TXUI.wunderbar.subModules[dbEntry].general[info[#info]] = value
    TXUI:GetModule("WunderBar"):UpdateBar()
  end)

  local tab = options.specswitch.args
  local iconsDisabled = function()
    return not E.db.TXUI.wunderbar.subModules[dbEntry].general.showIcons
  end

  local infoTextDisabledDueToSpec = function()
    return (E.db.TXUI.wunderbar.subModules[dbEntry].general.showSpec1 and E.db.TXUI.wunderbar.subModules[dbEntry].general.showSpec2)
  end

  local infoTextDisabled = function()
    return infoTextDisabledDueToSpec() or not E.db.TXUI.wunderbar.subModules[dbEntry].general.infoEnabled
  end

  -- General
  tab.generalGroup = ACH:Group("常规", nil, 1)
  tab.generalGroup.inline = true

  tab.generalGroup.args.showIcons = ACH:Toggle("显示图标", nil, 1)
  tab.generalGroup.args.iconFontSize = ACH:Range("图标大小", nil, 2, {
    min = 1,
    max = 100,
    step = 1,
  }, nil, nil, nil, iconsDisabled)

  tab.generalGroup.args.spacer1 = ACH:Spacer(3)

  tab.generalGroup.args.useUppercase = ACH:Toggle("大写名称", nil, 4)

  tab.generalGroup.args.spacer2 = ACH:Spacer(5)

  tab.generalGroup.args.showSpec1 = ACH:Toggle("显示天赋专精", nil, 6)
  tab.generalGroup.args.showSpec2 = ACH:Toggle("显示" .. (TXUI.IsRetail and "拾取专精" or "第二专精"), nil, 7)
  tab.generalGroup.args.showLoadout = ACH:Toggle("显示配装名称", nil, 8, nil, nil, nil, nil, nil, not TXUI.IsRetail)

  -- Info Text
  tab.infoGroup = ACH:Group("信息文本组", nil, 2)
  tab.infoGroup.inline = true

  local infoFontDisabled = function()
    return infoTextDisabled() or E.db.TXUI.wunderbar.subModules[dbEntry].general.infoShowIcon
  end

  local infoIconDisabled = function()
    return infoTextDisabled() or not E.db.TXUI.wunderbar.subModules[dbEntry].general.showSpec1
  end

  tab.infoGroup.args.infoEnabled = ACH:Toggle(function()
    return infoTextDisabled() and "禁用" or "启用"
  end, nil, 1, nil, nil, nil, nil, nil, infoTextDisabledDueToSpec)

  tab.infoGroup.args.infoUseAccent = ACH:Toggle("强调颜色", nil, 2, nil, nil, nil, nil, nil, infoTextDisabled)

  tab.infoGroup.args.infoShowIcon = ACH:Toggle("显示为图标", nil, 3, nil, nil, nil, nil, nil, infoIconDisabled)

  tab.infoGroup.args.spacer1 = ACH:Spacer(4)

  tab.infoGroup.args.infoFont = ACH:SharedMediaFont("字体", nil, 5, nil, nil, nil, infoFontDisabled)
  tab.infoGroup.args.infoFontSize = ACH:Range("字体大小", nil, 6, {
    min = 1,
    max = 100,
    step = 1,
  }, nil, nil, nil, infoTextDisabled)

  tab.infoGroup.args.infoOffset = ACH:Range("垂直偏移", nil, 7, {
    min = 1,
    max = 100,
    step = 1,
  }, nil, nil, nil, infoTextDisabled)
end
