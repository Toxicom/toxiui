local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")
local ACH = LibStub("LibAceConfigHelper")

function O:WunderBar_SubModules_SpecSwitch()
  local dbEntry = "SpecSwitch"
  local options = self.options.wunderbar.args.submodules.args
  local isUsingToxiUIFont = E.db.general.font == "- ToxiUI"

  options.specswitch = ACH:Group((isUsingToxiUIFont and (F.String.ConvertGlyph(59707) .. " ") or "") .. "SpecSwitch", nil, self:GetOrder(), nil, function(info)
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
  tab.generalGroup = ACH:Group("General", nil, 1)
  tab.generalGroup.inline = true

  tab.generalGroup.args.showIcons = ACH:Toggle("Show Icons", nil, 1)
  tab.generalGroup.args.iconFontSize = ACH:Range("Icon Size", nil, 2, {
    min = 1,
    max = 100,
    step = 1,
  }, nil, nil, nil, iconsDisabled)

  tab.generalGroup.args.spacer1 = ACH:Spacer(3)

  tab.generalGroup.args.useUppercase = ACH:Toggle("Uppercase Names", nil, 4)

  tab.generalGroup.args.spacer2 = ACH:Spacer(5)

  tab.generalGroup.args.showSpec1 = ACH:Toggle("Show Talent Spec", nil, 6)
  tab.generalGroup.args.showSpec2 = ACH:Toggle("Show " .. (TXUI.IsRetail and "Loot Spec" or "Secondary Spec"), nil, 7)
  tab.generalGroup.args.showLoadout = ACH:Toggle("Show Loadout Name", nil, 8, nil, nil, nil, nil, nil, not TXUI.IsRetail)

  -- Info Text
  tab.infoGroup = ACH:Group("Info Text Group", nil, 2)
  tab.infoGroup.inline = true

  local infoFontDisabled = function()
    return infoTextDisabled() or E.db.TXUI.wunderbar.subModules[dbEntry].general.infoShowIcon
  end

  local infoIconDisabled = function()
    return infoTextDisabled() or not E.db.TXUI.wunderbar.subModules[dbEntry].general.showSpec1
  end

  tab.infoGroup.args.infoEnabled = ACH:Toggle(function()
    return infoTextDisabled() and "Disabled" or "Enabled"
  end, nil, 1, nil, nil, nil, nil, nil, infoTextDisabledDueToSpec)

  tab.infoGroup.args.infoUseAccent = ACH:Toggle("Accent Color", nil, 2, nil, nil, nil, nil, nil, infoTextDisabled)

  tab.infoGroup.args.infoShowIcon = ACH:Toggle("Show as Icon", nil, 3, nil, nil, nil, nil, nil, infoIconDisabled)

  tab.infoGroup.args.spacer1 = ACH:Spacer(4)

  tab.infoGroup.args.infoFont = ACH:SharedMediaFont("Font", nil, 5, nil, nil, nil, infoFontDisabled)
  tab.infoGroup.args.infoFontSize = ACH:Range("Font Size", nil, 6, {
    min = 1,
    max = 100,
    step = 1,
  }, nil, nil, nil, infoTextDisabled)

  tab.infoGroup.args.infoOffset = ACH:Range("Vertical Offset", nil, 7, {
    min = 1,
    max = 100,
    step = 1,
  }, nil, nil, nil, infoTextDisabled)
end
