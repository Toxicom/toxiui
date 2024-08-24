local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")
local ACH = LibStub("LibAceConfigHelper")

function O:WunderBar_SubModules_ElvUILDB()
  local dbEntry = "ElvUILDB"
  local options = self.options.wunderbar.args.submodules.args
  local isUsingToxiUIFont = E.db.general.font == "- ToxiUI"

  options.elvuildb = ACH:Group((isUsingToxiUIFont and (F.String.ConvertGlyph(59692) .. " ") or "") .. "ElvUI & LDB", nil, self:GetOrder(), nil, function(info)
    return E.db.TXUI.wunderbar.subModules[dbEntry][info[#info]]
  end, function(info, value)
    E.db.TXUI.wunderbar.subModules[dbEntry][info[#info]] = value
    TXUI:GetModule("WunderBar"):UpdateBar()
  end)

  local tab = options.elvuildb.args

  -- General
  tab.generalGroup = ACH:Group("General", nil, 1)
  tab.generalGroup.inline = true

  tab.generalGroup.args.useUppercase = ACH:Toggle("Uppercase", nil, 1)
  tab.generalGroup.args.textColor = ACH:Toggle("Allow Text Color", nil, 2)
end
