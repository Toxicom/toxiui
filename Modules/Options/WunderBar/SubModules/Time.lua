local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")
local ACH = LibStub("LibAceConfigHelper")

function O:WunderBar_SubModules_Time()
  local dbEntry = "Time"
  local options = self.options.wunderbar.args.submodules.args
  local isUsingToxiUIFont = E.db.general.font == "- ToxiUI"

  options.time = ACH:Group((isUsingToxiUIFont and (F.String.ConvertGlyph(59734) .. " ") or "") .. "Time", nil, self:GetOrder(), nil, function(info)
    return E.db.TXUI.wunderbar.subModules[dbEntry][info[#info]]
  end, function(info, value)
    E.db.TXUI.wunderbar.subModules[dbEntry][info[#info]] = value
    TXUI:GetModule("WunderBar"):UpdateBar()
  end)

  local tab = options.time.args

  -- General
  tab.generalGroup = ACH:Group("General", nil, 1)
  tab.generalGroup.inline = true

  tab.generalGroup.args.localTime = ACH:Toggle("Locale Time", nil, 1)
  tab.generalGroup.args.twentyFour = ACH:Toggle("24h Format", nil, 2)
  tab.generalGroup.args.timeFormat = ACH:Select("Format", nil, 3, {
    ["HH:MM"] = "04:02",
    ["HH:M"] = "04:2",
    ["H:MM"] = "4:02",
    ["H:M"] = "4:2",
  }, nil)

  -- Fonts
  tab.textGroup = ACH:Group("Text Group", nil, 2)
  tab.textGroup.inline = true

  tab.textGroup.args.useAccent = ACH:Toggle("Colon Accent Color", nil, 1)
  tab.textGroup.args.spacer1 = ACH:Spacer(2)

  tab.textGroup.args.mainFontSize = ACH:Range("Font Size", nil, 3, {
    min = 1,
    max = function()
      return E:Round(E.db.TXUI.wunderbar.general.barHeight * 1.5)
    end,
    step = 1,
  })
  tab.textGroup.args.textOffset = ACH:Range("Text Offset", nil, 4, {
    min = -50,
    max = 100,
    step = 1,
  })

  -- Info Text
  tab.infoGroup = ACH:Group("Info Text Group", nil, 3)
  tab.infoGroup.inline = true

  local infoTextDisabled = function()
    return not E.db.TXUI.wunderbar.subModules[dbEntry].infoEnabled
  end

  tab.infoGroup.args.infoEnabled = ACH:Toggle(function()
    return infoTextDisabled() and "Disabled" or "Enabled"
  end, nil, 1)

  tab.infoGroup.args.infoUseAccent = ACH:Toggle("Accent Color", nil, 2, nil, nil, nil, nil, nil, infoTextDisabled)

  tab.infoGroup.args.spacer1 = ACH:Spacer(4)

  tab.infoGroup.args.infoFont = ACH:SharedMediaFont("Font", nil, 5, nil, nil, nil, infoTextDisabled)
  tab.infoGroup.args.infoFontSize = ACH:Range("Font Size", nil, 6, {
    min = 1,
    max = 100,
    step = 1,
  }, nil, nil, nil, infoTextDisabled)

  tab.infoGroup.args.infoOffset = ACH:Range("Vertical Offset", nil, 7, {
    min = -50,
    max = 50,
    step = 1,
  }, nil, nil, nil, infoTextDisabled)

  tab.infoGroup.args.infoTextDisplayed = ACH:MultiSelect(
    "Display Information",
    nil,
    8,
    {
      ["mail"] = "Mail",
      ["date"] = "Current Date",
      ["ampm"] = "AM/PM",
    },
    nil,
    "fill",
    function(_, key)
      return E.db.TXUI.wunderbar.subModules[dbEntry].infoTextDisplayed[key]
    end,
    function(_, key, value)
      E.db.TXUI.wunderbar.subModules[dbEntry].infoTextDisplayed[key] = value
      TXUI:GetModule("WunderBar"):UpdateBar()
    end,
    infoTextDisabled
  )

  -- Animations
  tab.animationGroup = ACH:Group("Animation Group", nil, 5)
  tab.animationGroup.inline = true

  tab.animationGroup.args.flashColon = ACH:Toggle("Pulse Colon", nil, 1)
  tab.animationGroup.args.flashOnInvite = ACH:Toggle("Pulse on Invite", nil, 2)

  -- Experimental
  tab.experimentalGroup = ACH:Group("Additional", nil, 6)
  tab.experimentalGroup.inline = true

  tab.experimentalGroup.args.experimentalDynamicSize = ACH:Toggle("Dynamic Width", nil, 1)
  tab.experimentalGroup.args.showRestingAnimation = ACH:Toggle(F.String.Legendary("LEGENDARY:") .. " Resting Animation", nil, 2, false, false, 2)
end
