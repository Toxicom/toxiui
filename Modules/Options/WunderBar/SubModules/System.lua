local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")
local ACH = LibStub("LibAceConfigHelper")

function O:WunderBar_SubModules_System()
  local options = self.options.wunderbar.args.submodules.args
  local isUsingToxiUIFont = E.db.general.font == "- ToxiUI"

  options.system = ACH:Group((isUsingToxiUIFont and (F.String.ConvertGlyph(59718) .. " ") or "") .. "System", nil, self:GetOrder(), nil, function(info)
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
  tab.generalGroup = ACH:Group("General", nil, 1)
  tab.generalGroup.inline = true

  tab.generalGroup.args.fastUpdate = ACH:Toggle("Fast Updates", nil, 1)
  tab.generalGroup.args.useWorldLatency = ACH:Toggle("Use World Latency", nil, 2)
  tab.generalGroup.args.showIcons = ACH:Toggle("Show Icons", nil, 3)
  tab.generalGroup.args.iconFontSize = ACH:Range("Icon Size", nil, 4, {
    min = 1,
    max = 100,
    step = 1,
  }, nil, nil, nil, iconsDisabled)

  -- Colors
  tab.colorGroup = ACH:Group("Colors", nil, 2)
  tab.colorGroup.inline = true
  tab.colorGroup.args.iconColor = ACH:Toggle("Color Icon", nil, 1, nil, nil, nil, nil, nil, iconsDisabled)
  tab.colorGroup.args.textColor = ACH:Toggle("Color Text", nil, 2)
  tab.colorGroup.args.textColorFadeFromNormal = ACH:Toggle("Text Color as Base", nil, 3, nil, nil, nil, nil, nil, colorsDisabled)

  tab.colorGroup.args.spacer1 = ACH:Spacer(4)

  tab.colorGroup.args.textColorFramerateThreshold = ACH:Range("Framerate Threshold", nil, 5, {
    min = 1,
    max = 1000,
    step = 1,
  }, nil, nil, nil, colorsDisabled)
  tab.colorGroup.args.textColorLatencyThreshold = ACH:Range("Latency Threshold", nil, 6, {
    min = 1,
    max = 1000,
    step = 1,
  }, nil, nil, nil, colorsDisabled)
end
