local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")
local ACH = LibStub("LibAceConfigHelper")

function O:WunderBar_SubModules_DataBar()
  local dbEntry = "DataBar"
  local options = self.options.wunderbar.args.submodules.args

  local isUsingToxiUIFont = E.db.general.font == "- ToxiUI"

  options.databar = ACH:Group((isUsingToxiUIFont and (F.String.ConvertGlyph(59706) .. " ") or "") .. "DataBar", nil, self:GetOrder(), nil, function(info)
    return E.db.TXUI.wunderbar.subModules[dbEntry][info[#info]]
  end, function(info, value)
    E.db.TXUI.wunderbar.subModules[dbEntry][info[#info]] = value
    TXUI:GetModule("WunderBar"):UpdateBar()
  end)

  local tab = options.databar.args
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

  tab.generalGroup.args.mode = ACH:Select("Mode", nil, 3, {
    ["auto"] = "Smart (Experience under Max Level)",
    ["rep"] = "Reputation",
  }, nil, "double")

  -- Bar Group
  tab.barGroup = ACH:Group("Bar", nil, 2)
  tab.barGroup.inline = true

  tab.barGroup.args.barHeight = ACH:Range("Bar Height", nil, 2, {
    min = 1,
    max = 20,
    step = 1,
  })
  tab.barGroup.args.barOffset = ACH:Range("Vertical Offset", nil, 3, {
    min = -10,
    max = 10,
    step = 1,
  })
  tab.barGroup.args.showCompletedXP = ACH:Toggle("Completed Quests XP", nil, 4)

  -- Info Text
  tab.infoGroup = ACH:Group("Info Text Group", nil, 2)
  tab.infoGroup.inline = true

  local infoTextDisabled = function()
    return not E.db.TXUI.wunderbar.subModules[dbEntry].infoEnabled
  end

  tab.infoGroup.args.infoEnabled = ACH:Toggle(function()
    return infoTextDisabled() and "Disabled" or "Enabled"
  end, nil, 1)

  tab.infoGroup.args.infoUseAccent = ACH:Toggle("Accent Color", nil, 2, nil, nil, nil, nil, nil, infoTextDisabled)

  tab.infoGroup.args.infoFont = ACH:SharedMediaFont("Font", nil, 3, nil, nil, nil, infoTextDisabled)
  tab.infoGroup.args.infoFontSize = ACH:Range("Font Size", nil, 4, {
    min = 1,
    max = 100,
    step = 1,
  }, nil, nil, nil, infoTextDisabled)

  tab.infoGroup.args.infoOffset = ACH:Range("Vertical Offset", nil, 5, {
    min = 1,
    max = 100,
    step = 1,
  }, nil, nil, nil, infoTextDisabled)
end
