local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")
local ACH = LibStub("LibAceConfigHelper")

local ipairs = ipairs
local tostring = tostring

local dbEntry = "MicroMenu"

function O:WunderBar_SubModules_MicroMenu_Buttons(group)
  local MM = TXUI:GetModule("WunderBar"):GetModule("MicroMenu")

  for i, name in ipairs(MM.microMenuOrder) do
    local info = MM.microMenu[name]
    if info.available ~= false then
      local config = E.db.TXUI.wunderbar.subModules[dbEntry]["icons"][name]
      group.args[tostring(i)] = ACH:Toggle(info.name, nil, i, nil, nil, nil, function()
        return config.enabled
      end, function(_, value)
        config.enabled = value
        TXUI:GetModule("WunderBar"):UpdateBar()
      end, function()
        return info.special
      end)
    end
  end
end

function O:WunderBar_SubModules_MicroMenu()
  local options = self.options.wunderbar.args.submodules.args
  local isUsingToxiUIFont = E.db.general.font == "- ToxiUI"

  options.micromenu = ACH:Group((isUsingToxiUIFont and (F.String.ConvertGlyph(59714) .. " ") or "") .. "MicroMenu", nil, self:GetOrder(), nil, function(info)
    return E.db.TXUI.wunderbar.subModules[dbEntry]["general"][info[#info]]
  end, function(info, value)
    E.db.TXUI.wunderbar.subModules[dbEntry]["general"][info[#info]] = value
    TXUI:GetModule("WunderBar"):UpdateBar()
  end)

  local tab = options.micromenu.args

  -- General
  tab.generalGroup = ACH:Group("General", nil, 1)
  tab.generalGroup.inline = true

  tab.generalGroup.args.iconFontSize = ACH:Range("Icon Size", nil, 1, {
    min = 1,
    max = 100,
    step = 1,
  })
  tab.generalGroup.args.iconSpacing = ACH:Range("Spacing", nil, 2, {
    min = 1,
    max = 100,
    step = 1,
  })

  tab.generalGroup.args.spacer1 = ACH:Spacer(3)

  local tooltipsDisabled = function()
    return not E.db.TXUI.wunderbar.subModules[dbEntry].general.additionalTooltips
  end

  tab.generalGroup.args.additionalTooltips = ACH:Toggle("Additional Tooltips", nil, 4)
  tab.generalGroup.args.newbieToolips = ACH:Toggle("Newbie Tooltips", nil, 5, nil, nil, nil, nil, nil, tooltipsDisabled)

  -- Info Text
  tab.infoGroup = ACH:Group("Info Text Group", nil, 2)
  tab.infoGroup.inline = true

  local infoTextDisabled = function()
    return not E.db.TXUI.wunderbar.subModules[dbEntry].general.infoEnabled
  end

  tab.infoGroup.args.infoEnabled = ACH:Toggle(function()
    return infoTextDisabled() and "Disabled" or "Enabled"
  end, nil, 1)

  tab.infoGroup.args.infoUseAccent = ACH:Toggle("Accent Color", nil, 2, nil, nil, nil, nil, nil, infoTextDisabled)

  tab.infoGroup.args.onlyFriendsWoW = ACH:Toggle("Only WoW Friends", nil, 3, nil, nil, nil, nil, nil, infoTextDisabled)

  local onlyFriendsWoWDisabled = function()
    return (infoTextDisabled()) or not E.db.TXUI.wunderbar.subModules[dbEntry].general.onlyFriendsWoW
  end

  tab.infoGroup.args.onlyFriendsWoWRetail = ACH:Toggle("Only Retail WoW", nil, 4, nil, nil, nil, nil, nil, onlyFriendsWoWDisabled)

  tab.infoGroup.args.spacer1 = ACH:Spacer(5)

  tab.infoGroup.args.infoFont = ACH:SharedMediaFont("Font", nil, 6, nil, nil, nil, infoTextDisabled)
  tab.infoGroup.args.infoFontSize = ACH:Range("Font Size", nil, 7, {
    min = 1,
    max = 100,
    step = 1,
  }, nil, nil, nil, infoTextDisabled)

  tab.infoGroup.args.infoOffset = ACH:Range("Vertical Offset", nil, 8, {
    min = 1,
    max = 100,
    step = 1,
  }, nil, nil, nil, infoTextDisabled)

  -- Buttons
  tab.buttonGroup = ACH:Group("Button Group", nil, 3)
  tab.buttonGroup.inline = true
  self:WunderBar_SubModules_MicroMenu_Buttons(tab.buttonGroup)
end
