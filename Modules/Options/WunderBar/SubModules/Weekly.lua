local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")
local ACH = LibStub("LibAceConfigHelper")

function O:WunderBar_SubModules_Weekly()
  local dbEntry = "Weekly"
  local options = self.options.wunderbar.args.submodules.args
  local isUsingToxiUIFont = E.db.general.font == "- ToxiUI"

  options.weekly = ACH:Group((isUsingToxiUIFont and (F.String.ConvertGlyph(59715) .. " ") or "") .. "Weekly", nil, self:GetOrder(), nil, function(info)
    return E.db.TXUI.wunderbar.subModules[dbEntry][info[#info]]
  end, function(info, value)
    E.db.TXUI.wunderbar.subModules[dbEntry][info[#info]] = value
    TXUI:GetModule("WunderBar"):UpdateBar()
  end)

  local tab = options.weekly.args
  local iconDisabled = function()
    return not E.db.TXUI.wunderbar.subModules[dbEntry].showIcon
  end

  -- General
  tab.generalGroup = ACH:Group("General", nil, 1)
  tab.generalGroup.inline = true

  tab.generalGroup.args.textMode = ACH:Select("Text", "What the module shows on the bar.", 1, {
    ["KEY"] = "Keystone",
    ["RATING"] = "Mythic+ Rating",
    ["VAULT"] = "Great Vault Progress",
  })
  tab.generalGroup.args.showDungeonScores = ACH:Toggle("Dungeon Scores", "Show the score of every dungeon in the tooltip.", 2)
  tab.generalGroup.args.useUppercase = ACH:Toggle("Uppercase", nil, 3)
  tab.generalGroup.args.showIcon = ACH:Toggle("Show Icon", nil, 4)
  tab.generalGroup.args.iconFontSize = ACH:Range("Icon Size", nil, 5, {
    min = 1,
    max = 100,
    step = 1,
  }, nil, nil, nil, iconDisabled)
end
