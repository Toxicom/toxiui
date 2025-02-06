local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")
local ACH = LibStub("LibAceConfigHelper")

function O:WunderBar_General()
  -- Options
  local options = self.options.wunderbar.args["general"]["args"]
  local optionsHidden

  -- Wunderbar Group Description
  do
    -- Wunderbar Description Group
    local wunderBarDesc = self:AddInlineRequirementsDesc(options, {
      name = "描述",
    }, {
      name = F.String.Menu.WunderBar() .. " - 旧 XIV 数据栏的完整替代品。显示重要信息并提供按钮以简化生活。\n\n",
    }, I.Requirements.WunderBar)

    -- Wunderbar Description Enable Toggle
    wunderBarDesc["args"]["enabled"] = {
      order = self:GetOrder(),
      type = "toggle",
      name = function()
        return self:GetEnableName(E.db.TXUI.wunderbar.general.enabled, wunderBarDesc)
      end,
      set = function(info, value)
        E.db.TXUI.wunderbar.general[info[#info]] = value
        TXUI:GetModule("WunderBar"):DatabaseUpdate()
      end,
    }

    -- Hidden helper
    optionsHidden = function()
      return self:GetEnabledState(E.db.TXUI.wunderbar.general.enabled, wunderBarDesc) ~= self.enabledState.YES
    end
  end

  -- Spacer
  self:AddSpacer(options)

  -- General
  do
    -- General Group
    local generalGroup = self:AddInlineGroup(options, {
      name = "常规",
      hidden = optionsHidden,
    })

    -- No combat click
    generalGroup["args"]["noCombatClick"] = {
      order = self:GetOrder(),
      type = "toggle",
      name = "阻止战斗点击",
      desc = "在战斗中阻止所有点击事件。",
    }

    -- No combat hover
    generalGroup["args"]["noCombatHover"] = {
      order = self:GetOrder(),
      type = "toggle",
      name = "阻止战斗提示",
      desc = "在战斗中阻止显示数据文本提示。",
    }

    -- No hover
    generalGroup["args"]["noHover"] = {
      order = self:GetOrder(),
      type = "toggle",
      name = "始终隐藏提示",
      desc = "阻止显示数据文本提示。\n\n" .. F.String.Error("警告：这也会禁用“悬停”颜色。"),
    }

    -- Spacer
    self:AddSpacer(generalGroup["args"])

    -- Position
    generalGroup["args"]["position"] = {
      order = self:GetOrder(),
      type = "select",
      name = "位置",
      desc = "选择是否在屏幕顶部或底部显示 " .. F.String.Menu.WunderBar() .. "。",
      values = {
        TOP = "顶部",
        BOTTOM = "底部",
      },
      set = function(_, value)
        E.db.TXUI.wunderbar.general.position = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
    }

    -- Visibility
    generalGroup["args"]["barVisibility"] = {
      order = self:GetOrder(),
      type = "select",
      name = "可见性",
      values = {
        ALWAYS = "始终",
        NO_COMBAT = "战斗中隐藏",
        RESTING = "仅在休息区",
        RESTING_AND_MOUSEOVER = "休息区和鼠标悬停",
      },
    }

    -- Mouseover Only
    generalGroup["args"]["barMouseOverOnly"] = {
      order = self:GetOrder(),
      type = "toggle",
      name = "仅鼠标悬停",
      desc = "仅在鼠标悬停时显示栏。",
      disabled = function()
        return (E.db.TXUI.wunderbar.general.barVisibility == "RESTING_AND_MOUSEOVER")
      end,
    }

    -- Spacer
    self:AddSpacer(generalGroup["args"])

    -- Height
    generalGroup["args"]["barHeight"] = {
      order = self:GetOrder(),
      type = "range",
      name = "高度",
      min = 1,
      max = 200,
      step = 1,
    }

    -- Height
    generalGroup["args"]["barWidth"] = {
      order = self:GetOrder(),
      type = "range",
      name = "宽度",
      min = 1,
      max = E.physicalWidth,
      step = 1,
    }

    -- Spacing
    generalGroup["args"]["barSpacing"] = {
      order = self:GetOrder(),
      type = "range",
      name = "间距",
      desc = F.String.Menu.WunderBar() .. " 应该从屏幕每侧偏移的间距量。",
      min = 1,
      max = 100,
      step = 1,
    }
  end

  -- Spacer
  self:AddSpacer(options)

  -- Font
  do
    -- Font Group
    local fontGroup = self:AddInlineGroup(options, {
      name = "字体",
      hidden = optionsHidden,
    })

    -- Fonts Font
    fontGroup["args"]["normalFont"] = {
      order = self:GetOrder(),
      type = "select",
      dialogControl = "LSM30_Font",
      name = "字体",
      desc = "设置字体。",
      values = self:GetAllFontsFunc(),
    }

    -- Fonts Outline
    fontGroup["args"]["normalFontOutline"] = {
      order = self:GetOrder(),
      type = "select",
      name = "字体轮廓",
      desc = "设置字体轮廓。",
      values = self:GetAllFontOutlinesFunc(),
      disabled = function()
        return (E.db.TXUI.wunderbar.general["normalFontShadow"] == true)
      end,
    }

    -- Fonts Size
    fontGroup["args"]["normalFontSize"] = {
      order = self:GetOrder(),
      type = "range",
      name = "字体大小",
      desc = "设置字体大小。",
      min = 1,
      max = 100,
      step = 1,
    }

    -- Fonts Shadow
    fontGroup["args"]["normalFontShadow"] = {
      order = self:GetOrder(),
      type = "toggle",
      name = "字体阴影",
      desc = "设置字体阴影。",
    }
  end

  -- Spacer
  self:AddSpacer(options)

  -- Color
  do
    -- Color Group
    local colorGroup = self:AddInlineGroup(options, {
      name = "颜色",
      hidden = optionsHidden,
    })

    -- Background color select
    colorGroup["args"]["backgroundColor"] = {
      order = self:GetOrder(),
      type = "select",
      name = "背景颜色",
      values = self:GetAllFontColorsFunc {
        RGB = F.String.Legendary("LEGENDARY: ") .. "|cffff0000R|r|cff00ff00G|r|cff0000ffB|r ",
      } or self:GetAllFontColorsFunc(),
    }

    -- Background Custom Color
    colorGroup["args"]["backgroundCustomColor"] = {
      order = self:GetOrder(),
      type = "color",
      name = "自定义颜色",
      hasAlpha = true,
      get = self:GetFontColorGetter("TXUI.wunderbar.general", P.wunderbar.general),
      set = self:GetFontColorSetter("TXUI.wunderbar.general", function()
        TXUI:GetModule("WunderBar"):UpdateBar()
      end),
      hidden = function()
        return E.db.TXUI.wunderbar.general.backgroundColor ~= "CUSTOM"
      end,
    }

    -- Spacer
    self:AddSpacer(colorGroup["args"])

    -- Accent color select
    colorGroup["args"]["accentFontColor"] = {
      order = self:GetOrder(),
      type = "select",
      name = "强调颜色",
      values = self:GetAllFontColorsFunc(),
    }

    -- Accent Custom Color
    colorGroup["args"]["accentFontCustomColor"] = {
      order = self:GetOrder(),
      type = "color",
      name = "自定义颜色",
      hasAlpha = true,
      get = self:GetFontColorGetter("TXUI.wunderbar.general", P.wunderbar.general),
      set = self:GetFontColorSetter("TXUI.wunderbar.general", function()
        TXUI:GetModule("WunderBar"):UpdateBar()
      end),
      hidden = function()
        return E.db.TXUI.wunderbar.general.accentFontColor ~= "CUSTOM"
      end,
    }

    -- Spacer
    self:AddSpacer(colorGroup["args"])

    -- Icon color select
    colorGroup["args"]["iconFontColor"] = {
      order = self:GetOrder(),
      type = "select",
      name = "图标颜色",
      values = self:GetAllFontColorsFunc(),
    }

    -- Icon Custom Color
    colorGroup["args"]["iconFontCustomColor"] = {
      order = self:GetOrder(),
      type = "color",
      name = "自定义颜色",
      hasAlpha = true,
      get = self:GetFontColorGetter("TXUI.wunderbar.general", P.wunderbar.general),
      set = self:GetFontColorSetter("TXUI.wunderbar.general", function()
        TXUI:GetModule("WunderBar"):UpdateBar()
      end),
      hidden = function()
        return E.db.TXUI.wunderbar.general.iconFontColor ~= "CUSTOM"
      end,
    }

    -- Spacer
    self:AddSpacer(colorGroup["args"])

    -- Font color select
    colorGroup["args"]["normalFontColor"] = {
      order = self:GetOrder(),
      type = "select",
      name = "字体颜色",
      values = self:GetAllFontColorsFunc(),
    }

    -- Font Custom Color
    colorGroup["args"]["normalFontCustomColor"] = {
      order = self:GetOrder(),
      type = "color",
      name = "自定义颜色",
      hasAlpha = true,
      get = self:GetFontColorGetter("TXUI.wunderbar.general", P.wunderbar.general),
      set = self:GetFontColorSetter("TXUI.wunderbar.general", function()
        TXUI:GetModule("WunderBar"):UpdateBar()
      end),
      hidden = function()
        return E.db.TXUI.wunderbar.general.normalFontColor ~= "CUSTOM"
      end,
    }
  end

  -- Spacer
  self:AddSpacer(options)

  -- Animation
  do
    -- Animation Group
    local animationsGroup = self:AddInlineGroup(options, {
      name = "动画",
      hidden = optionsHidden,
    })

    -- Animations Enable Toggle
    animationsGroup["args"]["animations"] = {
      order = self:GetOrder(),
      type = "toggle",
      name = function()
        return self:GetEnableName(E.db.TXUI.wunderbar.general.animations)
      end,
    }

    -- Disabled helper
    local animationsDisabled = function()
      return self:GetEnabledState(E.db.TXUI.wunderbar.general.animations) ~= self.enabledState.YES
    end

    -- Animate on Events Toggle
    animationsGroup["args"]["animationsEvents"] = {
      order = self:GetOrder(),
      type = "toggle",
      name = "事件动画",
      desc = "当子模块接收到事件时播放短动画",
      disabled = animationsDisabled,
    }

    -- Animate on Events Toggle
    animationsGroup["args"]["animationsMult"] = {
      order = self:GetOrder(),
      type = "range",
      name = "动画速度",
      desc = "设置动画速度。",
      min = 0.5,
      max = 2,
      step = 0.1,
      isPercent = true,
      disabled = animationsDisabled,
      get = function()
        return 1 / E.db.TXUI.wunderbar.general.animationsMult
      end,
      set = function(_, value)
        E.db.TXUI.wunderbar.general.animationsMult = 1 / value
      end,
    }
  end

  -- Spacer
  self:AddSpacer(options)

  -- Background
  do
    -- Background Group
    local backgroundGroup = self:AddInlineGroup(options, {
      name = "背景",
      hidden = optionsHidden,
    })

    backgroundGroup["args"]["backgroundTexture"] = ACH:SharedMediaStatusbar("背景纹理", nil, self:GetOrder())

    -- Background Fade Toggle
    backgroundGroup["args"]["backgroundGradient"] = {
      order = self:GetOrder(),
      type = "toggle",
      name = "背景渐变",
      desc = "在顶部附近淡出背景。",
    }

    -- Background Fade Range
    backgroundGroup["args"]["backgroundGradientAlpha"] = {
      order = self:GetOrder(),
      type = "range",
      name = "渐变强度",
      desc = "设置渐变强度。",
      min = 0,
      max = 1,
      step = 0.01,
      disabled = function()
        return not E.db.TXUI.wunderbar.general.backgroundGradient
      end,
    }
  end

  self:AddSpacer(options)

  -- Flyout Backdrop
  do
    local flyoutGroup = self:AddInlineDesc(options, {
      name = "弹出框",
      hidden = optionsHidden,
    }, {
      name = "控制 " .. F.String.Menu.WunderBar() .. " 在专业和炉石模块中显示的弹出框。\n\n",
    }).args

    flyoutGroup["enabled"] = {
      order = self:GetOrder(),
      type = "toggle",
      name = function()
        return self:GetEnableName(E.db.TXUI.wunderbar.general.flyoutBackdrop.enabled)
      end,
      get = function(info)
        return E.db.TXUI.wunderbar.general.flyoutBackdrop[info[#info]]
      end,
      set = function(info, value)
        E.db.TXUI.wunderbar.general.flyoutBackdrop[info[#info]] = value
      end,
    }

    local flyoutDisabled = function()
      return self:GetEnabledState(E.db.TXUI.wunderbar.general.flyoutBackdrop.enabled) ~= self.enabledState.YES
    end

    flyoutGroup["alpha"] = {
      order = self:GetOrder(),
      type = "range",
      name = "透明度",
      desc = "设置弹出框背景的透明度。",
      min = 0,
      max = 1,
      step = 0.05,
      disabled = flyoutDisabled,
      get = function(info)
        return E.db.TXUI.wunderbar.general.flyoutBackdrop[info[#info]]
      end,
      set = function(info, value)
        E.db.TXUI.wunderbar.general.flyoutBackdrop[info[#info]] = value
      end,
    }

    flyoutGroup["classColor"] = {
      order = self:GetOrder(),
      type = "toggle",
      name = "职业颜色",
      desc = "启用此选项将设置弹出框背景为您的职业颜色。",
      disabled = flyoutDisabled,
      get = function(info)
        return E.db.TXUI.wunderbar.general.flyoutBackdrop[info[#info]]
      end,
      set = function(info, value)
        E.db.TXUI.wunderbar.general.flyoutBackdrop[info[#info]] = value
      end,
    }

    flyoutGroup["borderSize"] = {
      order = self:GetOrder(),
      type = "range",
      name = "边框大小",
      desc = "设置整个弹出框背景的边框大小。",
      min = 1,
      max = 6,
      step = 1,
      disabled = flyoutDisabled,
      get = function(info)
        return E.db.TXUI.wunderbar.general.flyoutBackdrop[info[#info]]
      end,
      set = function(info, value)
        E.db.TXUI.wunderbar.general.flyoutBackdrop[info[#info]] = value
      end,
    }

    flyoutGroup["padding"] = {
      order = self:GetOrder(),
      type = "range",
      name = "填充 " .. E.NewSign,
      desc = "设置弹出框背景的填充。",
      min = 0,
      max = 32,
      step = 1,
      disabled = flyoutDisabled,
      get = function(info)
        return E.db.TXUI.wunderbar.general.flyoutBackdrop[info[#info]]
      end,
      set = function(info, value)
        E.db.TXUI.wunderbar.general.flyoutBackdrop[info[#info]] = value
      end,
    }

    self:AddSpacer(flyoutGroup)

    flyoutGroup["width"] = {
      order = self:GetOrder(),
      type = "range",
      name = "槽宽度 " .. E.NewSign,
      desc = "设置单个槽的大小。高度将相应变化以保持 4:3 的宽高比。",
      min = 20,
      max = 80,
      step = 1,
      disabled = flyoutDisabled,
      get = function(info)
        return E.db.TXUI.wunderbar.general.flyoutBackdrop[info[#info]]
      end,
      set = function(info, value)
        E.db.TXUI.wunderbar.general.flyoutBackdrop[info[#info]] = value
      end,
    }

    flyoutGroup["spacing"] = {
      order = self:GetOrder(),
      type = "range",
      name = "间距 " .. E.NewSign,
      desc = "设置槽之间的间距。",
      min = 0,
      max = 16,
      step = 1,
      disabled = flyoutDisabled,
      get = function(info)
        return E.db.TXUI.wunderbar.general.flyoutBackdrop[info[#info]]
      end,
      set = function(info, value)
        E.db.TXUI.wunderbar.general.flyoutBackdrop[info[#info]] = value
      end,
    }

    flyoutGroup["labelFont"] = {
      order = self:GetOrder(),
      type = "select",
      dialogControl = "LSM30_Font",
      name = "标签字体 " .. E.NewSign,
      desc = "设置 M+ 传送门标签的字体。",
      values = self:GetAllFontsFunc(),
      disabled = flyoutDisabled,
      get = function(info)
        return E.db.TXUI.wunderbar.general.flyoutBackdrop[info[#info]]
      end,
      set = function(info, value)
        E.db.TXUI.wunderbar.general.flyoutBackdrop[info[#info]] = value
      end,
    }

    flyoutGroup["labelFontSize"] = {
      order = self:GetOrder(),
      type = "range",
      name = "标签字体大小 " .. E.NewSign,
      desc = "设置 M+ 传送门标签的字体大小。",
      min = 8,
      max = 64,
      step = 1,
      disabled = flyoutDisabled,
      get = function(info)
        return E.db.TXUI.wunderbar.general.flyoutBackdrop[info[#info]]
      end,
      set = function(info, value)
        E.db.TXUI.wunderbar.general.flyoutBackdrop[info[#info]] = value
      end,
    }
  end
end
