local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")
local ACH = LibStub("LibAceConfigHelper")

local select = select

function O:WunderBar_SubModules_Profession()
  local dbEntry = "Profession"
  local options = self.options.wunderbar.args.submodules.args
  local isUsingToxiUIFont = E.db.general.font == "- ToxiUI"

  options.profession = ACH:Group((isUsingToxiUIFont and (F.String.ConvertGlyph(59708) .. " ") or "") .. "专业", nil, self:GetOrder(), nil, function(info)
    return E.db.TXUI.wunderbar.subModules[dbEntry].general[info[#info]]
  end, function(info, value)
    E.db.TXUI.wunderbar.subModules[dbEntry].general[info[#info]] = value
    TXUI:GetModule("WunderBar"):UpdateBar()
  end)

  local tab = options.profession.args
  local iconDisabled = function()
    return not E.db.TXUI.wunderbar.subModules[dbEntry].general.showIcons
  end

  -- General
  tab.generalGroup = ACH:Group("常规", nil, 1)
  tab.generalGroup.inline = true

  tab.generalGroup.args.showIcons = ACH:Toggle("显示图标", nil, 1)
  tab.generalGroup.args.iconFontSize = ACH:Range("图标大小", nil, 2, {
    min = 1,
    max = 100,
    step = 1,
  }, nil, nil, nil, iconDisabled)

  tab.generalGroup.args.spacer1 = ACH:Spacer(3)

  tab.generalGroup.args.useUppercase = ACH:Toggle("名称大写", nil, 4)
  tab.generalGroup.args.abbreviate = ACH:Toggle("缩写名称 " .. E.NewSign, "这将把名称缩写为自定义字符串，例如：'BS'，'LW'，'Ench' 等等。", 5)
  tab.generalGroup.args.abbreviate.width = 1.2
  tab.generalGroup.args.limitChar = ACH:Range("名称长度 " .. E.NewSign, "专业名称的最大字符长度", 6)
  tab.generalGroup.args.limitChar.step = 1
  tab.generalGroup.args.limitChar.min = 1
  tab.generalGroup.args.limitChar.max = 32
  tab.generalGroup.args.limitChar.disabled = function()
    return E.db.TXUI.wunderbar.subModules[dbEntry].general.abbreviate
  end

  tab.generalGroup.args.spacer2 = ACH:Spacer(7)

  local professionValues = function(number)
    return function()
      local PR = TXUI:GetModule("WunderBar"):GetModule("Profession")

      local prof1, prof2, archaeology, fishing, cooking, first_aid = PR:GetProfessions()
      local mainProfName

      if number == 1 then
        mainProfName = prof1 and select(2, PR:GetProfessionInfo(prof1)) or "专业 " .. number
      else
        mainProfName = prof2 and select(2, PR:GetProfessionInfo(prof2)) or "专业 " .. number
      end

      local values = {
        [0] = "隐藏",
        [1] = mainProfName,
      }

      if archaeology then values[archaeology] = select(2, PR:GetProfessionInfo(archaeology)) end
      if fishing then values[fishing] = select(2, PR:GetProfessionInfo(fishing)) end
      if cooking then values[cooking] = select(2, PR:GetProfessionInfo(cooking)) end
      if first_aid then values[first_aid] = select(2, PR:GetProfessionInfo(first_aid)) end

      return values
    end
  end

  tab.generalGroup.args.selectedProf1 = ACH:Select("专业 1", nil, 8, professionValues(1), nil, 2)
  tab.generalGroup.args.selectedProf2 = ACH:Select("专业 2", nil, 9, professionValues(2), nil, 2)

  tab.barGroup = ACH:Group("进度条", nil, 2)
  tab.barGroup.inline = true

  local barsDisabled = function()
    return not E.db.TXUI.wunderbar.subModules[dbEntry].general.showBars
  end

  tab.barGroup.args.showBars = ACH:Toggle(function()
    return barsDisabled() and "禁用" or "启用"
  end, nil, 1)

  tab.barGroup.args.barHeight = ACH:Range("进度条高度", nil, 2, {
    min = 1,
    max = 20,
    step = 1,
  }, nil, nil, nil, barsDisabled)

  tab.barGroup.args.barOffset = ACH:Range("垂直偏移", nil, 3, {
    min = -10,
    max = 10,
    step = 1,
  }, nil, nil, nil, barsDisabled)

  tab.barGroup.args.barSpacing = ACH:Range("垂直间距", nil, 4, {
    min = 0,
    max = 10,
    step = 1,
  }, nil, nil, nil, barsDisabled)
end
