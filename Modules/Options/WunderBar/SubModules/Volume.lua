local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")
local ACH = LibStub("LibAceConfigHelper")

function O:WunderBar_SubModules_Volume()
  local dbEntry = "Volume"
  local options = self.options.wunderbar.args.submodules.args
  local isUsingToxiUIFont = E.db.general.font == "- ToxiUI"

  options.volume = ACH:Group((isUsingToxiUIFont and (F.String.ConvertGlyph(59724) .. " ") or "") .. "Volume", nil, self:GetOrder(), nil, function(info)
    return E.db.TXUI.wunderbar.subModules[dbEntry][info[#info]]
  end, function(info, value)
    E.db.TXUI.wunderbar.subModules[dbEntry][info[#info]] = value
    TXUI:GetModule("WunderBar"):UpdateBar()
  end)

  local tab = options.volume.args
  local iconDisabled = function()
    return not E.db.TXUI.wunderbar.subModules[dbEntry].showIcon
  end

  -- General
  tab.generalGroup = ACH:Group("General", nil, 1)
  tab.generalGroup.inline = true

  tab.generalGroup.args.useUppercase = ACH:Toggle("Uppercase", nil, 1)
  tab.generalGroup.args.showIcon = ACH:Toggle("Show Icon", nil, 2)
  tab.generalGroup.args.iconFontSize = ACH:Range("Icon Size", nil, 3, {
    min = 1,
    max = 100,
    step = 1,
  }, nil, nil, nil, iconDisabled)

  -- Colors
  tab.colorGroup = ACH:Group("Colors", nil, 2)
  tab.colorGroup.inline = true

  tab.colorGroup.args.textColor = ACH:Select("Text Color", nil, 1, {
    ["NONE"] = "Default Color",
    ["ACCENT"] = "Accent Color",
    ["GREEN"] = "Green",
  }, nil, "double")
  tab.colorGroup.args.textColor.style = "radio"
end
