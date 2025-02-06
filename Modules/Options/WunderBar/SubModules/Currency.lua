local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")
local DT = E:GetModule("DataTexts")
local ACH = LibStub("LibAceConfigHelper")

local ipairs = ipairs
local tostring = tostring

function O:WunderBar_SubModules_Currency()
  local dbEntry = "Currency"
  local options = self.options.wunderbar.args.submodules.args
  local isUsingToxiUIFont = E.db.general.font == "- ToxiUI"

  options.currency = ACH:Group((isUsingToxiUIFont and (F.String.ConvertGlyph(59705) .. " ") or "") .. "Currencies", nil, self:GetOrder(), nil, function(info)
    return E.db.TXUI.wunderbar.subModules[dbEntry][info[#info]]
  end, function(info, value)
    E.db.TXUI.wunderbar.subModules[dbEntry][info[#info]] = value
    TXUI:GetModule("WunderBar"):UpdateBar()
  end)

  local tab = options.currency.args
  local iconDisabled = function()
    return not E.db.TXUI.wunderbar.subModules[dbEntry].showIcon
  end

  local goldDisabled = function()
    return E.db.TXUI.wunderbar.subModules[dbEntry].displayedCurrency ~= "GOLD"
  end

  -- General
  tab.generalGroup = ACH:Group("General", nil, 1)
  tab.generalGroup.inline = true

  tab.generalGroup.args.displayedCurrency = ACH:Select("Displayed Currency", nil, 1, function()
    local list = E:CopyTable({}, DT.CurrencyList)
    list["BACKPACK"] = nil
    return list
  end)
  tab.generalGroup.args.displayedCurrency.sortByValue = true

  tab.generalGroup.args.showIcon = ACH:Toggle("Show Icon", nil, 2)
  tab.generalGroup.args.iconFontSize = ACH:Range("Icon Size", nil, 3, {
    min = 1,
    max = 100,
    step = 1,
  }, nil, nil, nil, iconDisabled)

  -- Display
  tab.displayGroup = ACH:Group("Display", nil, 2)
  tab.displayGroup.inline = true
  tab.displayGroup.args.showSmall = ACH:Toggle("Show Silver & Copper", nil, 1, nil, nil, nil, nil, nil, goldDisabled)
  tab.displayGroup.args.useGoldColors = ACH:Toggle("Use colors for letters", nil, 2, nil, nil, nil, nil, nil, goldDisabled)
  tab.displayGroup.args.showBagSpace = ACH:Toggle("Show Free Bag Space", nil, 3)

  tab.displayGroup.args.spacer1 = ACH:Spacer(3)

  -- Currencies
  tab.currencyGroup = ACH:Group("Currencies", nil, 3)
  tab.currencyGroup.inline = true

  tab.currencyGroup.args.spacer1 = ACH:Spacer(0)

  for i, info in ipairs(E.global.datatexts.settings.Currencies.tooltipData) do
    if not info[2] and info[1] then
      local Group = ACH:Group(F.String.Uppercase(info[1]), nil, i)
      Group.inline = true

      tab.currencyGroup.args[tostring(i)] = Group
    elseif info[3] and info[1] then
      local tabName = tostring(info[3])
      if tab.currencyGroup.args[tabName] then
        tab.currencyGroup.args[tabName].args[tostring(i)] = ACH:Toggle(info[1], nil, i, nil, nil, nil, function()
          return E.db.TXUI.wunderbar.subModules[dbEntry].enabledCurrencies[info[2]]
        end, function(_, value)
          E.db.TXUI.wunderbar.subModules[dbEntry].enabledCurrencies[info[2]] = value
        end)
      end
    end
  end
end
