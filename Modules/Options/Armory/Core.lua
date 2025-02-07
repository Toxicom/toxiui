local TXUI, F, E, I, V, P, G, I18n = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")

local ReloadUI = ReloadUI

function O:Armory()
  -- Reset order for new page
  self:ResetOrder()

  -- Add Options for Tab
  self.options.armory.childGroups = "tab"

  self.options.armory.get = function(info)
    return E.db.TXUI.armory[info[#info]]
  end

  self.options.armory.set = function(info, value)
    E.db.TXUI.armory[info[#info]] = value
    F.Event.TriggerEvent("Armory.SettingsUpdate")
  end

  -- Options
  local options = self.options.armory.args
  local optionsHidden

  local unitClass = E.myclass
  local colorMap = E.db.TXUI.themes.gradientMode.classColorMap
  local left = colorMap[1][unitClass] -- Left (player UF)
  local right = colorMap[2][unitClass] -- Right (player UF)

  -- General
  do
    -- General Group
    local generalGroup = self:AddInlineRequirementsDesc(options, {
      name = "描述",
    }, {
      name = TXUI.Title
        .. " 军械库 改变了你的角色面板的外观。\n\n"
        .. (TXUI.IsCata and (F.String.Error("[测试版]") .. ": 此模块在大灾变经典版上尚不稳定！\n\n") or ""),
    }, I.Requirements.Armory).args

    -- Enable
    generalGroup.enabled = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "启用此选项将启用 " .. TXUI.Title .. " 军械库",
      name = function()
        return self:GetEnableName(E.db.TXUI.armory.enabled, generalGroup)
      end,
      set = function(info, value)
        E.db.TXUI.armory[info[#info]] = value

        if value == false then
          ReloadUI()
        else
          F.Event.TriggerEvent("Armory.DatabaseUpdate")
        end
      end,
      confirm = function(_, value)
        if value == false then
          return "禁用 " .. TXUI.Title .. " 军械库 需要重新加载你的 UI。\n\n 你确定吗？"
        else
          return false
        end
      end,
    }

    -- Hidden helper
    optionsHidden = function()
      return self:GetEnabledState(E.db.TXUI.armory.enabled, generalGroup) ~= self.enabledState.YES
    end
  end

  -- General Tab
  do
    -- Tab
    local tab = self:AddGroup(options, {
      name = "常规",
      hidden = optionsHidden,
    }).args

    -- Avg Item Level
    do
      -- Avg Item Level Group
      local itemLevelGroup = self:AddInlineDesc(tab, {
        name = "物品等级",
        get = function(info)
          return E.db.TXUI.armory.stats[info[#info]]
        end,
        set = function(info, value)
          E.db.TXUI.armory.stats[info[#info]] = value
          F.Event.TriggerEvent("Armory.SettingsUpdate")
        end,
      }, {
        name = TXUI.Title .. " 军械库 中物品等级的设置。\n\n",
      }).args

      -- Show Avg Item Level of Best Items (in Bags)
      itemLevelGroup.showAvgItemLevel = {
        order = self:GetOrder(),
        type = "toggle",
        desc = "启用此选项将显示你当前背包中可以达到的最高物品等级。",
        name = "背包物品等级",
        disabled = not TXUI.IsRetail,
      }

      -- Formats
      itemLevelGroup.itemLevelFormat = {
        order = self:GetOrder(),
        type = "select",
        name = "格式",
        desc = "小数格式",
        values = {
          ["%.0f"] = "42",
          ["%.1f"] = "42.0",
          ["%.2f"] = "42.01",
          ["%.3f"] = "42.012",
        },
      }

      -- Spacer
      self:AddSpacer(itemLevelGroup)

      -- Fonts Font
      itemLevelGroup.itemLevelFont = {
        order = self:GetOrder(),
        type = "select",
        dialogControl = "LSM30_Font",
        name = "字体",
        desc = "设置字体。",
        values = self:GetAllFontsFunc(),
      }

      -- Fonts Outline
      itemLevelGroup.itemLevelFontOutline = {
        order = self:GetOrder(),
        type = "select",
        name = "字体轮廓",
        desc = "设置字体轮廓。",
        values = self:GetAllFontOutlinesFunc(),
        disabled = function()
          return (E.db.TXUI.armory.stats["itemLevelFontShadow"] == true)
        end,
      }

      -- Fonts Size
      itemLevelGroup.itemLevelFontSize = {
        order = self:GetOrder(),
        type = "range",
        name = "字体大小",
        desc = "设置字体大小。",
        min = 1,
        max = 100,
        step = 1,
      }

      -- Fonts Shadow
      itemLevelGroup.itemLevelFontShadow = {
        order = self:GetOrder(),
        type = "toggle",
        name = "字体阴影",
        desc = "设置字体阴影。",
      }

      -- Font color select
      itemLevelGroup.itemLevelFontColor = {
        order = self:GetOrder(),
        type = "select",
        name = "字体颜色",
        values = self:GetAllFontColorsFunc {
          ["GRADIENT"] = F.String.FastGradient("渐变", 0, 0.6, 1, 0, 0.9, 1),
          ["CLASS_GRADIENT"] = F.String.FastGradient("职业渐变", left.r, left.g, left.b, right.r, right.g, right.b),
        },
      }

      -- Font Custom Color
      itemLevelGroup.itemLevelFontCustomColor = {
        order = self:GetOrder(),
        type = "color",
        name = "自定义颜色",
        hasAlpha = true,
        get = self:GetFontColorGetter("TXUI.armory.stats", P.armory.stats),
        set = self:GetFontColorSetter("TXUI.armory.stats", function()
          F.Event.TriggerEvent("Armory.SettingsUpdate")
        end),
        hidden = function()
          return E.db.TXUI.armory.stats.itemLevelFontColor ~= "CUSTOM"
        end,
      }
    end

    -- Animations
    if TXUI.IsRetail then
      -- General Group
      local animationsGroup = self:AddInlineDesc(tab, {
        name = "动画",
      }, {
        name = "打开角色面板时的 军械库 动画。\n\n",
      }).args

      -- Enable
      animationsGroup.animations = {
        order = self:GetOrder(),
        type = "toggle",
        desc = "启用此选项将启用 " .. TXUI.Title .. " 军械库 动画。",
        name = function()
          return self:GetEnableName(E.db.TXUI.armory.animations)
        end,
      }

      local animationsDisabled = function()
        return not E.db.TXUI.armory.animations
      end

      -- Animation Speed
      animationsGroup.animationsMult = {
        order = self:GetOrder(),
        type = "range",
        name = "动画速度",
        min = 0.1,
        max = 2,
        step = 0.1,
        isPercent = true,
        get = function()
          return 1 / E.db.TXUI.armory.animationsMult
        end,
        set = function(_, value)
          E.db.TXUI.armory.animationsMult = 1 / value
        end,
        disabled = animationsDisabled,
      }
    end

    -- Background
    do
      -- Background Group
      local backgroundGroup = self:AddInlineDesc(tab, {
        name = "背景",
        get = function(info)
          return E.db.TXUI.armory.background[info[#info]]
        end,
        set = function(info, value)
          E.db.TXUI.armory.background[info[#info]] = value
          F.Event.TriggerEvent("Armory.SettingsUpdate")
        end,
      }, {
        name = TXUI.Title .. " 军械库 自定义背景的设置。\n\n",
      }).args

      -- Enable
      backgroundGroup.enabled = {
        order = self:GetOrder(),
        type = "toggle",
        desc = "启用此选项将启用 " .. TXUI.Title .. " 军械库 背景。",
        name = function()
          return self:GetEnableName(E.db.TXUI.armory.background.enabled)
        end,
      }

      local optionsDisabled = function()
        return self:GetEnabledState(E.db.TXUI.armory.background.enabled) ~= self.enabledState.YES
      end

      -- Alpha
      backgroundGroup.alpha = {
        order = self:GetOrder(),
        type = "range",
        name = "透明度",
        min = 0,
        max = 1,
        step = 0.01,
        isPercent = true,
        disabled = optionsDisabled,
      }

      -- Style
      backgroundGroup.style = {
        order = self:GetOrder(),
        type = "select",
        name = "样式",
        desc = "更改背景图像。",
        values = {
          [1] = "1. 神圣火焰修道院",
          [2] = "2. 阿兹卡赫特",
          [3] = "3. 德拉诺",
        },
        disabled = function()
          return E.db.TXUI.armory.background.class or optionsDisabled()
        end,
      }

      backgroundGroup.class = {
        order = self:GetOrder(),
        type = "toggle",
        name = "职业背景 " .. E.NewSign,
        desc = "使用职业特定背景。",
        disabled = optionsDisabled,
        width = 1.2,
      }

      backgroundGroup.hideControls = {
        order = self:GetOrder(),
        type = "toggle",
        name = "隐藏控制 " .. E.NewSign,
        desc = "在悬停角色模型时隐藏相机控制。",
        set = function(_, value)
          E.db.TXUI.armory.background.hideControls = value
          if value == false then E:StaticPopup_Show("CONFIG_RL") end
        end,
        disabled = optionsDisabled,
      }
    end

    -- Lines
    do
      -- Lines Group
      local linesGroup = self:AddInlineDesc(tab, {
        name = "装饰线条",
        get = function(info)
          return E.db.TXUI.armory.lines[info[#info]]
        end,
        set = function(info, value)
          E.db.TXUI.armory.lines[info[#info]] = value
          F.Event.TriggerEvent("Armory.SettingsUpdate")
        end,
      }, {
        name = TXUI.Title .. " 军械库 自定义装饰线条的设置。\n\n",
      }).args

      -- Enable
      linesGroup.enabled = {
        order = self:GetOrder(),
        type = "toggle",
        desc = "启用此选项将启用 " .. TXUI.Title .. " 军械库 装饰线条。",
        name = function()
          return self:GetEnableName(E.db.TXUI.armory.lines.enabled)
        end,
      }

      local optionsDisabled = function()
        return self:GetEnabledState(E.db.TXUI.armory.lines.enabled) ~= self.enabledState.YES
      end

      -- Alpha
      linesGroup.alpha = {
        order = self:GetOrder(),
        type = "range",
        name = "透明度",
        min = 0,
        max = 1,
        step = 0.01,
        isPercent = true,
        disabled = optionsDisabled,
      }

      -- Line Height
      linesGroup.height = {
        order = self:GetOrder(),
        type = "range",
        name = "线条高度",
        min = 1,
        max = 5,
        step = 1,
        disabled = optionsDisabled,
      }

      linesGroup.color = {
        order = self:GetOrder(),
        type = "select",
        name = "线条颜色",
        values = {
          CLASS = F.String.Class("职业"),
          GRADIENT = F.String.GradientClass("渐变职业"),
        },
        disabled = optionsDisabled,
      }
    end
  end

  -- Title
  do
    -- Tab
    local tab = self:AddGroup(options, {
      name = "标题",
      hidden = optionsHidden,
    }).args

    -- Name Text
    do
      -- Font Group
      local fontGroup = self:AddInlineGroup(tab, {
        name = "名称文本",
      }).args

      -- Fonts Font
      fontGroup.nameTextFont = {
        order = self:GetOrder(),
        type = "select",
        dialogControl = "LSM30_Font",
        name = "字体",
        desc = "设置字体。",
        values = self:GetAllFontsFunc(),
      }

      -- Fonts Outline
      fontGroup.nameTextFontOutline = {
        order = self:GetOrder(),
        type = "select",
        name = "字体轮廓",
        desc = "设置字体轮廓。",
        values = self:GetAllFontOutlinesFunc(),
        disabled = function()
          return (E.db.TXUI.armory["nameTextFontShadow"] == true)
        end,
      }

      -- Fonts Size
      fontGroup.nameTextFontSize = {
        order = self:GetOrder(),
        type = "range",
        name = "字体大小",
        desc = "设置字体大小。",
        min = 1,
        max = 42,
        step = 1,
      }

      -- Fonts Shadow
      fontGroup.nameTextFontShadow = {
        order = self:GetOrder(),
        type = "toggle",
        name = "字体阴影",
        desc = "设置字体阴影。",
      }

      -- Font color select
      fontGroup.nameTextFontColor = {
        order = self:GetOrder(),
        type = "select",
        name = "字体颜色",
        values = self:GetAllFontColorsFunc {
          ["GRADIENT"] = F.String.FastGradient("渐变", 0, 0.6, 1, 0, 0.9, 1),
          ["CLASS_GRADIENT"] = F.String.FastGradient("职业渐变", left.r, left.g, left.b, right.r, right.g, right.b),
        },
      }

      -- Font Custom Color
      fontGroup.nameTextFontCustomColor = {
        order = self:GetOrder(),
        type = "color",
        name = "自定义颜色",
        hasAlpha = true,
        get = self:GetFontColorGetter("TXUI.armory", P.armory),
        set = self:GetFontColorSetter("TXUI.armory", function()
          F.Event.TriggerEvent("Armory.SettingsUpdate")
        end),
        hidden = function()
          return E.db.TXUI.armory["nameTextFontColor"] ~= "CUSTOM"
        end,
      }

      -- Spacer
      self:AddSpacer(fontGroup)

      -- Position X
      fontGroup.nameTextOffsetX = {
        order = self:GetOrder(),
        type = "range",
        name = "X 偏移",
        min = -100,
        max = 100,
        step = 1,
      }

      -- Position Y
      fontGroup.nameTextOffsetY = {
        order = self:GetOrder(),
        type = "range",
        name = "Y 偏移",
        min = -100,
        max = 100,
        step = 1,
      }
    end

    -- Title Text
    do
      -- Font Group
      local fontGroup = self:AddInlineGroup(tab, {
        name = "标题文本",
      }).args

      -- Fonts Font
      fontGroup.titleTextFont = {
        order = self:GetOrder(),
        type = "select",
        dialogControl = "LSM30_Font",
        name = "字体",
        desc = "设置字体。",
        values = self:GetAllFontsFunc(),
      }

      -- Fonts Outline
      fontGroup.titleTextFontOutline = {
        order = self:GetOrder(),
        type = "select",
        name = "字体轮廓",
        desc = "设置字体轮廓。",
        values = self:GetAllFontOutlinesFunc(),
        disabled = function()
          return (E.db.TXUI.armory["titleTextFontShadow"] == true)
        end,
      }

      -- Fonts Size
      fontGroup.titleTextFontSize = {
        order = self:GetOrder(),
        type = "range",
        name = "字体大小",
        desc = "设置字体大小。",
        min = 1,
        max = 42,
        step = 1,
      }

      -- Fonts Shadow
      fontGroup.titleTextFontShadow = {
        order = self:GetOrder(),
        type = "toggle",
        name = "字体阴影",
        desc = "设置字体阴影。",
      }

      -- Font color select
      fontGroup.titleTextFontColor = {
        order = self:GetOrder(),
        type = "select",
        name = "字体颜色",
        values = self:GetAllFontColorsFunc {
          ["GRADIENT"] = F.String.FastGradient("渐变", 0, 0.6, 1, 0, 0.9, 1),
          ["CLASS_GRADIENT"] = F.String.FastGradient("职业渐变", left.r, left.g, left.b, right.r, right.g, right.b),
        },
      }

      -- Font Custom Color
      fontGroup.titleTextFontCustomColor = {
        order = self:GetOrder(),
        type = "color",
        name = "自定义颜色",
        hasAlpha = true,
        get = self:GetFontColorGetter("TXUI.armory", P.armory),
        set = self:GetFontColorSetter("TXUI.armory", function()
          F.Event.TriggerEvent("Armory.SettingsUpdate")
        end),
        hidden = function()
          return E.db.TXUI.armory["titleTextFontColor"] ~= "CUSTOM"
        end,
      }

      -- Spacer
      self:AddSpacer(fontGroup)

      -- Position X
      fontGroup.titleTextOffsetX = {
        order = self:GetOrder(),
        type = "range",
        name = "X 偏移",
        min = -100,
        max = 100,
        step = 1,
      }

      -- Position Y
      fontGroup.titleTextOffsetY = {
        order = self:GetOrder(),
        type = "range",
        name = "Y 偏移",
        min = -100,
        max = 100,
        step = 1,
      }
    end

    -- Level Title Text
    do
      -- Font Group
      local fontGroup = self:AddInlineGroup(tab, {
        name = "等级标签",
      }).args

      -- Fonts Font
      fontGroup.levelTitleTextFont = {
        order = self:GetOrder(),
        type = "select",
        dialogControl = "LSM30_Font",
        name = "字体",
        desc = "设置字体。",
        values = self:GetAllFontsFunc(),
      }

      -- Fonts Outline
      fontGroup.levelTitleTextFontOutline = {
        order = self:GetOrder(),
        type = "select",
        name = "字体轮廓",
        desc = "设置字体轮廓。",
        values = self:GetAllFontOutlinesFunc(),
        disabled = function()
          return (E.db.TXUI.armory["levelTitleTextFontShadow"] == true)
        end,
      }

      -- Fonts Size
      fontGroup.levelTitleTextFontSize = {
        order = self:GetOrder(),
        type = "range",
        name = "字体大小",
        desc = "设置字体大小。",
        min = 1,
        max = 42,
        step = 1,
      }

      -- Fonts Shadow
      fontGroup.levelTitleTextFontShadow = {
        order = self:GetOrder(),
        type = "toggle",
        name = "字体阴影",
        desc = "设置字体阴影。",
      }

      -- Font color select
      fontGroup.levelTitleTextFontColor = {
        order = self:GetOrder(),
        type = "select",
        name = "字体颜色",
        values = self:GetAllFontColorsFunc(),
      }

      -- Font Custom Color
      fontGroup.levelTitleTextFontCustomColor = {
        order = self:GetOrder(),
        type = "color",
        name = "自定义颜色",
        hasAlpha = true,
        get = self:GetFontColorGetter("TXUI.armory", P.armory),
        set = self:GetFontColorSetter("TXUI.armory", function()
          F.Event.TriggerEvent("Armory.SettingsUpdate")
        end),
        hidden = function()
          return E.db.TXUI.armory.levelTitleTextFontColor ~= "CUSTOM"
        end,
      }

      -- Spacer
      self:AddSpacer(fontGroup)

      fontGroup.levelTitleTextShort = {
        order = self:GetOrder(),
        type = "toggle",
        name = "缩写标签",
        desc = "将“等级”文本缩写为“Lv”。",
      }

      -- Spacer
      self:AddSpacer(fontGroup)

      -- Position X
      fontGroup.levelTitleTextOffsetX = {
        order = self:GetOrder(),
        type = "range",
        name = "X 偏移",
        min = -100,
        max = 100,
        step = 1,
      }

      -- Position Y
      fontGroup.levelTitleTextOffsetY = {
        order = self:GetOrder(),
        type = "range",
        name = "Y 偏移",
        min = -100,
        max = 100,
        step = 1,
      }
    end

    -- Level Text
    do
      -- Font Group
      local fontGroup = self:AddInlineGroup(tab, {
        name = "等级值",
      }).args

      -- Fonts Font
      fontGroup.levelTextFont = {
        order = self:GetOrder(),
        type = "select",
        dialogControl = "LSM30_Font",
        name = "字体",
        desc = "设置字体。",
        values = self:GetAllFontsFunc(),
      }

      -- Fonts Outline
      fontGroup.levelTextFontOutline = {
        order = self:GetOrder(),
        type = "select",
        name = "字体轮廓",
        desc = "设置字体轮廓。",
        values = self:GetAllFontOutlinesFunc(),
        disabled = function()
          return (E.db.TXUI.armory["levelTextFontShadow"] == true)
        end,
      }

      -- Fonts Size
      fontGroup.levelTextFontSize = {
        order = self:GetOrder(),
        type = "range",
        name = "字体大小",
        desc = "设置字体大小。",
        min = 1,
        max = 42,
        step = 1,
      }

      -- Fonts Shadow
      fontGroup.levelTextFontShadow = {
        order = self:GetOrder(),
        type = "toggle",
        name = "字体阴影",
        desc = "设置字体阴影。",
      }

      -- Font color select
      fontGroup.levelTextFontColor = {
        order = self:GetOrder(),
        type = "select",
        name = "字体颜色",
        values = self:GetAllFontColorsFunc(),
      }

      -- Font Custom Color
      fontGroup.levelTextFontCustomColor = {
        order = self:GetOrder(),
        type = "color",
        name = "自定义颜色",
        hasAlpha = true,
        get = self:GetFontColorGetter("TXUI.armory", P.armory),
        set = self:GetFontColorSetter("TXUI.armory", function()
          F.Event.TriggerEvent("Armory.SettingsUpdate")
        end),
        hidden = function()
          return E.db.TXUI.armory.levelTextFontColor ~= "CUSTOM"
        end,
      }

      -- Spacer
      self:AddSpacer(fontGroup)

      -- Position X
      fontGroup.levelTextOffsetX = {
        order = self:GetOrder(),
        type = "range",
        name = "X 偏移",
        min = -100,
        max = 100,
        step = 1,
      }

      -- Position Y
      fontGroup.levelTextOffsetY = {
        order = self:GetOrder(),
        type = "range",
        name = "Y 偏移",
        min = -100,
        max = 100,
        step = 1,
      }
    end

    -- Class Text
    do
      -- Font Group
      local fontGroup = self:AddInlineGroup(tab, {
        name = "职业文本",
      }).args

      -- Fonts Font
      fontGroup.classTextFont = {
        order = self:GetOrder(),
        type = "select",
        dialogControl = "LSM30_Font",
        name = "字体",
        desc = "设置字体。",
        values = self:GetAllFontsFunc(),
      }

      -- Fonts Outline
      fontGroup.classTextFontOutline = {
        order = self:GetOrder(),
        type = "select",
        name = "字体轮廓",
        desc = "设置字体轮廓。",
        values = self:GetAllFontOutlinesFunc(),
        disabled = function()
          return (E.db.TXUI.armory["classTextFontShadow"] == true)
        end,
      }

      -- Fonts Size
      fontGroup.classTextFontSize = {
        order = self:GetOrder(),
        type = "range",
        name = "字体大小",
        desc = "设置字体大小。",
        min = 1,
        max = 42,
        step = 1,
      }

      -- Fonts Shadow
      fontGroup.classTextFontShadow = {
        order = self:GetOrder(),
        type = "toggle",
        name = "字体阴影",
        desc = "设置字体阴影。",
      }

      -- Font color select
      fontGroup.classTextFontColor = {
        order = self:GetOrder(),
        type = "select",
        name = "字体颜色",
        values = self:GetAllFontColorsFunc {
          ["GRADIENT"] = F.String.FastGradient("渐变", 0, 0.6, 1, 0, 0.9, 1),
        },
      }

      -- Font Custom Color
      fontGroup.classTextFontCustomColor = {
        order = self:GetOrder(),
        type = "color",
        name = "自定义颜色",
        hasAlpha = true,
        get = self:GetFontColorGetter("TXUI.armory", P.armory),
        set = self:GetFontColorSetter("TXUI.armory", function()
          F.Event.TriggerEvent("Armory.SettingsUpdate")
        end),
        hidden = function()
          return E.db.TXUI.armory["classTextFontColor"] ~= "CUSTOM"
        end,
      }

      -- Spacer
      self:AddSpacer(fontGroup)

      -- Position X
      fontGroup.classTextOffsetX = {
        order = self:GetOrder(),
        type = "range",
        name = "X 偏移",
        min = -100,
        max = 100,
        step = 1,
      }

      -- Position Y
      fontGroup.classTextOffsetY = {
        order = self:GetOrder(),
        type = "range",
        name = "Y 偏移",
        min = -100,
        max = 100,
        step = 1,
      }
    end

    -- Spec Icon
    do
      -- Font Group
      local fontGroup = self:AddInlineGroup(tab, {
        name = "专精图标",
      }).args

      -- Fonts Outline
      fontGroup.specIconFontOutline = {
        order = self:GetOrder(),
        type = "select",
        name = "字体轮廓",
        desc = "设置字体轮廓。",
        values = self:GetAllFontOutlinesFunc(),
        disabled = function()
          return (E.db.TXUI.armory["specIconFontShadow"] == true)
        end,
      }

      -- Fonts Size
      fontGroup.specIconFontSize = {
        order = self:GetOrder(),
        type = "range",
        name = "字体大小",
        desc = "设置字体大小。",
        min = 1,
        max = 42,
        step = 1,
      }

      -- Fonts Shadow
      fontGroup.specIconFontShadow = {
        order = self:GetOrder(),
        type = "toggle",
        name = "字体阴影",
        desc = "设置字体阴影。",
      }

      -- Font color select
      fontGroup.specIconFontColor = {
        order = self:GetOrder(),
        type = "select",
        name = "字体颜色",
        values = self:GetAllFontColorsFunc {
          ["GRADIENT"] = F.String.FastGradient("渐变", 0, 0.6, 1, 0, 0.9, 1),
        },
      }

      -- Font Custom Color
      fontGroup.specIconFontCustomColor = {
        order = self:GetOrder(),
        type = "color",
        name = "自定义颜色",
        hasAlpha = true,
        get = self:GetFontColorGetter("TXUI.armory", P.armory),
        set = self:GetFontColorSetter("TXUI.armory", function()
          F.Event.TriggerEvent("Armory.SettingsUpdate")
        end),
        hidden = function()
          return E.db.TXUI.armory["specIconFontColor"] ~= "CUSTOM"
        end,
      }
    end
  end

  -- Item Slot
  do
    -- Tab
    local tab = self:AddGroup(options, {
      name = "物品栏",
      get = function(info)
        return E.db.TXUI.armory.pageInfo[info[#info]]
      end,
      set = function(info, value)
        E.db.TXUI.armory.pageInfo[info[#info]] = value
        F.Event.TriggerEvent("Armory.SettingsUpdate")
      end,
      hidden = optionsHidden,
    }).args

    -- Item Quality Gradient
    do
      -- Item Level Group
      local gradientGroup = self:AddInlineDesc(tab, {
        name = "物品品质渐变",
      }, {
        name = "设置物品栏颜色渐变。\n\n",
      }).args

      -- Enable
      gradientGroup.itemQualityGradientEnabled = {
        order = self:GetOrder(),
        type = "toggle",
        desc = "启用此选项将启用物品品质条。",
        name = function()
          return self:GetEnableName(E.db.TXUI.armory.pageInfo.itemQualityGradientEnabled)
        end,
      }

      local optionsDisabled = function()
        return self:GetEnabledState(E.db.TXUI.armory.pageInfo.itemQualityGradientEnabled) ~= self.enabledState.YES
      end

      -- Gradient Width
      gradientGroup.itemQualityGradientWidth = {
        order = self:GetOrder(),
        type = "range",
        name = "宽度",
        min = 10,
        max = 120,
        step = 1,
        disabled = optionsDisabled,
      }

      -- Gradient Height
      gradientGroup.itemQualityGradientHeight = {
        order = self:GetOrder(),
        type = "range",
        name = "高度",
        min = 1,
        max = 40,
        step = 1,
        disabled = optionsDisabled,
      }

      -- Start Alpha
      gradientGroup.itemQualityGradientStartAlpha = {
        order = self:GetOrder(),
        type = "range",
        name = "起始透明度",
        min = 0,
        max = 1,
        step = 0.01,
        isPercent = true,
        disabled = optionsDisabled,
      }

      -- End Alpha
      gradientGroup.itemQualityGradientEndAlpha = {
        order = self:GetOrder(),
        type = "range",
        name = "结束透明度",
        min = 0,
        max = 1,
        step = 0.01,
        isPercent = true,
        disabled = optionsDisabled,
      }
    end

    -- Spacer
    self:AddSpacer(tab)

    -- Enchant
    do
      -- Enchant Group
      local enchantGroup = self:AddInlineDesc(tab, {
        name = "附魔和插槽字符串",
      }, {
        name = "设置显示物品附魔和插槽信息的字符串。\n\n",
      }).args

      -- Enable
      enchantGroup.enchantTextEnabled = {
        order = self:GetOrder(),
        type = "toggle",
        desc = "启用此选项将启用 " .. TXUI.Title .. " 军械库 附魔字符串。",
        name = function()
          return self:GetEnableName(E.db.TXUI.armory.pageInfo.enchantTextEnabled)
        end,
      }

      local optionsDisabled = function()
        return self:GetEnabledState(E.db.TXUI.armory.pageInfo.enchantTextEnabled) ~= self.enabledState.YES
      end

      -- Missing Enchant
      enchantGroup.missingEnchantText = {
        order = self:GetOrder(),
        type = "toggle",
        desc = "当你缺少附魔时显示警告。",
        name = "缺少附魔",
        disabled = optionsDisabled,
      }

      -- Missing Socket
      enchantGroup.missingSocketText = {
        order = self:GetOrder(),
        type = "toggle",
        desc = function()
          local socketItem = nil

          if C_Item and C_Item.GetItemInfo then
            local itemName = C_Item.GetItemInfo(213777)
            if itemName then socketItem = itemName end
          end

          return "当你的项链缺少插槽时显示警告。" .. (socketItem and (" 插槽可以通过 " .. F.String.ToxiUI(socketItem) .. " 添加") or "")
        end,
        name = "缺少插槽",
        hidden = not TXUI.IsRetail,
        disabled = optionsDisabled,
      }

      -- Abbreviate Enchant
      enchantGroup.abbreviateEnchantText = {
        order = self:GetOrder(),
        type = "toggle",
        desc = "缩写附魔字符串。",
        name = "短附魔",
        disabled = optionsDisabled,
      }

      enchantGroup.useEnchantClassColor = {
        order = self:GetOrder(),
        type = "toggle",
        desc = "使用职业颜色显示附魔字符串。",
        name = "职业颜色",
        disabled = optionsDisabled,
      }

      enchantGroup.moveSockets = {
        order = self:GetOrder(),
        type = "toggle",
        name = "移动插槽 " .. E.NewSign,
        desc = "裁剪并将插槽移动到附魔文本上方。",
        disabled = optionsDisabled,
        set = function(_, value)
          E.db.TXUI.armory.pageInfo.moveSockets = value
          if value == false then E:StaticPopup_Show("CONFIG_RL") end
        end,
      }

      -- Spacer
      self:AddSpacer(enchantGroup)

      -- Fonts Font
      enchantGroup.enchantFont = {
        order = self:GetOrder(),
        type = "select",
        dialogControl = "LSM30_Font",
        name = "字体",
        desc = "设置字体。",
        values = self:GetAllFontsFunc(),
        disabled = optionsDisabled,
      }

      -- Fonts Outline
      enchantGroup.enchantFontOutline = {
        order = self:GetOrder(),
        type = "select",
        name = "字体轮廓",
        desc = "设置字体轮廓。",
        values = self:GetAllFontOutlinesFunc(),
        disabled = function()
          return (self:GetEnabledState(E.db.TXUI.armory.pageInfo.enchantTextEnabled) ~= self.enabledState.YES) or (E.db.TXUI.armory.pageInfo["enchantFontShadow"] == true)
        end,
      }

      -- Fonts Size
      enchantGroup.enchantFontSize = {
        order = self:GetOrder(),
        type = "range",
        name = "字体大小",
        desc = "设置字体大小。",
        min = 1,
        max = 42,
        step = 1,
        disabled = optionsDisabled,
      }

      -- Fonts Shadow
      enchantGroup.enchantFontShadow = {
        order = self:GetOrder(),
        type = "toggle",
        name = "字体阴影",
        desc = "设置字体阴影。",
        disabled = optionsDisabled,
      }
    end

    -- Spacer
    self:AddSpacer(tab)

    -- Item Level
    do
      -- Item Level Group
      local itemLevelGroup = self:AddInlineDesc(tab, {
        name = "物品等级",
      }, {
        name = "设置物品栏旁边的物品等级。\n\n",
      }).args

      -- Enable
      itemLevelGroup.itemLevelTextEnabled = {
        order = self:GetOrder(),
        type = "toggle",
        desc = "切换物品等级显示。",
        name = function()
          return self:GetEnableName(E.db.TXUI.armory.pageInfo.itemLevelTextEnabled)
        end,
      }

      local optionsDisabled = function()
        return self:GetEnabledState(E.db.TXUI.armory.pageInfo.itemLevelTextEnabled) ~= self.enabledState.YES
      end

      -- Gem/Azerite Icons
      itemLevelGroup.iconsEnabled = {
        order = self:GetOrder(),
        type = "toggle",
        desc = "切换插槽和艾泽里特特质。",
        name = "插槽",
        disabled = optionsDisabled,
      }

      -- Spacer
      self:AddSpacer(itemLevelGroup)

      -- Fonts Font
      itemLevelGroup.iLvLFont = {
        order = self:GetOrder(),
        type = "select",
        dialogControl = "LSM30_Font",
        name = "字体",
        desc = "设置字体。",
        values = self:GetAllFontsFunc(),
        disabled = optionsDisabled,
      }

      -- Fonts Outline
      itemLevelGroup.iLvLFontOutline = {
        order = self:GetOrder(),
        type = "select",
        name = "字体轮廓",
        desc = "设置字体轮廓。",
        values = self:GetAllFontOutlinesFunc(),
        disabled = function()
          return (self:GetEnabledState(E.db.TXUI.armory.pageInfo.itemLevelTextEnabled) ~= self.enabledState.YES) or (E.db.TXUI.armory.pageInfo["iLvLFontShadow"] == true)
        end,
      }

      -- Fonts Size
      itemLevelGroup.iLvLFontSize = {
        order = self:GetOrder(),
        type = "range",
        name = "字体大小",
        desc = "设置字体大小。",
        min = 1,
        max = 42,
        step = 1,
        disabled = optionsDisabled,
      }

      -- Fonts Shadow
      itemLevelGroup.iLvLFontShadow = {
        order = self:GetOrder(),
        type = "toggle",
        name = "字体阴影",
        desc = "设置字体阴影。",
        disabled = optionsDisabled,
      }
    end
  end

  -- Stats
  if TXUI.IsRetail then
    -- Tab
    local tab = self:AddGroup(options, {
      name = "属性",
      get = function(info)
        return E.db.TXUI.armory.stats[info[#info]]
      end,
      set = function(info, value)
        E.db.TXUI.armory.stats[info[#info]] = value
        F.Event.TriggerEvent("Armory.SettingsUpdate")
      end,
      hidden = optionsHidden,
    }).args

    -- Alternating Background
    do
      -- General Group
      local backgroundGroup = self:AddInlineGroup(tab, {
        name = "背景条",
      }).args

      -- Enable
      backgroundGroup.alternatingBackgroundEnabled = {
        order = self:GetOrder(),
        type = "toggle",
        desc = "切换每隔一个数字的蓝色条。",
        name = function()
          return self:GetEnableName(E.db.TXUI.armory.stats.alternatingBackgroundEnabled)
        end,
      }

      local optionsDisabled = function()
        return self:GetEnabledState(E.db.TXUI.armory.stats.alternatingBackgroundEnabled) ~= self.enabledState.YES
      end

      -- Alpha
      backgroundGroup.alternatingBackgroundAlpha = {
        order = self:GetOrder(),
        type = "range",
        name = "透明度",
        min = 0,
        max = 1,
        step = 0.01,
        isPercent = true,
        disabled = optionsDisabled,
      }
    end

    self:AddSpacer(tab)

    -- Category Header Text
    do
      -- Font Group
      local fontGroup = self:AddInlineGroup(tab, {
        name = "类别标题",
      }).args

      -- Fonts Font
      fontGroup.headerFont = {
        order = self:GetOrder(),
        type = "select",
        dialogControl = "LSM30_Font",
        name = "字体",
        desc = "设置字体。",
        values = self:GetAllFontsFunc(),
      }

      -- Fonts Outline
      fontGroup.headerFontOutline = {
        order = self:GetOrder(),
        type = "select",
        name = "字体轮廓",
        desc = "设置字体轮廓。",
        values = self:GetAllFontOutlinesFunc(),
        disabled = function()
          return (E.db.TXUI.armory.stats["headerFontShadow"] == true)
        end,
      }

      -- Fonts Size
      fontGroup.headerFontSize = {
        order = self:GetOrder(),
        type = "range",
        name = "字体大小",
        desc = "设置字体大小。",
        min = 1,
        max = 42,
        step = 1,
      }

      -- Fonts Shadow
      fontGroup.headerFontShadow = {
        order = self:GetOrder(),
        type = "toggle",
        name = "字体阴影",
        desc = "设置字体阴影。",
      }

      -- Font color select
      fontGroup.headerFontColor = {
        order = self:GetOrder(),
        type = "select",
        name = "字体颜色",
        values = self:GetAllFontColorsFunc {
          ["GRADIENT"] = F.String.FastGradient("渐变", 0, 0.6, 1, 0, 0.9, 1),
          ["CLASS_GRADIENT"] = F.String.FastGradient("职业渐变", left.r, left.g, left.b, right.r, right.g, right.b),
        },
      }

      -- Font Custom Color
      fontGroup.headerFontCustomColor = {
        order = self:GetOrder(),
        type = "color",
        name = "自定义颜色",
        hasAlpha = true,
        get = self:GetFontColorGetter("TXUI.armory.stats", P.armory.stats),
        set = self:GetFontColorSetter("TXUI.armory.stats", function()
          F.Event.TriggerEvent("Armory.SettingsUpdate")
        end),
        hidden = function()
          return E.db.TXUI.armory.stats["headerFontColor"] ~= "CUSTOM"
        end,
      }
    end

    self:AddSpacer(tab)

    -- Label Text
    do
      -- Font Group
      local fontGroup = self:AddInlineGroup(tab, {
        name = "属性标签",
      }).args

      -- Fonts Font
      fontGroup.labelFont = {
        order = self:GetOrder(),
        type = "select",
        dialogControl = "LSM30_Font",
        name = "字体",
        desc = "设置字体。",
        values = self:GetAllFontsFunc(),
      }

      -- Fonts Outline
      fontGroup.labelFontOutline = {
        order = self:GetOrder(),
        type = "select",
        name = "字体轮廓",
        desc = "设置字体轮廓。",
        values = self:GetAllFontOutlinesFunc(),
        disabled = function()
          return (E.db.TXUI.armory.stats["labelFontShadow"] == true)
        end,
      }

      -- Fonts Size
      fontGroup.labelFontSize = {
        order = self:GetOrder(),
        type = "range",
        name = "字体大小",
        desc = "设置字体大小。",
        min = 1,
        max = 42,
        step = 1,
      }

      -- Fonts Shadow
      fontGroup.labelFontShadow = {
        order = self:GetOrder(),
        type = "toggle",
        name = "字体阴影",
        desc = "设置字体阴影。",
      }

      -- Font color select
      fontGroup.labelFontColor = {
        order = self:GetOrder(),
        type = "select",
        name = "字体颜色",
        values = self:GetAllFontColorsFunc {
          ["GRADIENT"] = F.String.FastGradient("渐变", 0, 0.6, 1, 0, 0.9, 1),
          ["CLASS_GRADIENT"] = F.String.FastGradient("职业渐变", left.r, left.g, left.b, right.r, right.g, right.b),
        },
      }

      -- Font Custom Color
      fontGroup.labelFontCustomColor = {
        order = self:GetOrder(),
        type = "color",
        name = "自定义颜色",
        hasAlpha = true,
        get = self:GetFontColorGetter("TXUI.armory.stats", P.armory.stats),
        set = self:GetFontColorSetter("TXUI.armory.stats", function()
          F.Event.TriggerEvent("Armory.SettingsUpdate")
        end),
        hidden = function()
          return E.db.TXUI.armory.stats["labelFontColor"] ~= "CUSTOM"
        end,
      }

      fontGroup.abbreviateLabels = {
        order = self:GetOrder(),
        type = "toggle",
        name = "短标签 " .. E.NewSign,
        desc = "缩短和缩写属性标签。",
      }
    end

    self:AddSpacer(tab)

    -- Icon Text
    do
      -- Font Group
      local fontGroup = self:AddInlineDesc(tab, {
        name = "属性图标 " .. E.NewSign,
      }, {
        name = "在属性标签前显示图标。目前仅支持主要属性。\n\n",
      }).args

      fontGroup.showIcons = {
        order = self:GetOrder(),
        type = "toggle",
        name = function()
          return self:GetEnableName(E.db.TXUI.armory.stats.showIcons, fontGroup)
        end,
      }

      -- Fonts Outline
      fontGroup.iconFontOutline = {
        order = self:GetOrder(),
        type = "select",
        name = "字体轮廓",
        desc = "设置字体轮廓。",
        values = self:GetAllFontOutlinesFunc(),
        disabled = function()
          return (E.db.TXUI.armory.stats["iconFontShadow"] == true)
        end,
      }

      -- Fonts Size
      fontGroup.iconFontSize = {
        order = self:GetOrder(),
        type = "range",
        name = "字体大小",
        desc = "设置字体大小。",
        min = 1,
        max = 42,
        step = 1,
      }

      -- Fonts Shadow
      fontGroup.iconFontShadow = {
        order = self:GetOrder(),
        type = "toggle",
        name = "字体阴影",
        desc = "设置字体阴影。",
      }

      -- Font color select
      fontGroup.iconFontColor = {
        order = self:GetOrder(),
        type = "select",
        name = "字体颜色",
        values = self:GetAllFontColorsFunc(),
      }

      -- Font Custom Color
      fontGroup.iconFontCustomColor = {
        order = self:GetOrder(),
        type = "color",
        name = "自定义颜色",
        hasAlpha = true,
        get = self:GetFontColorGetter("TXUI.armory.stats", P.armory.stats),
        set = self:GetFontColorSetter("TXUI.armory.stats", function()
          F.Event.TriggerEvent("Armory.SettingsUpdate")
        end),
        hidden = function()
          return E.db.TXUI.armory.stats["iconFontColor"] ~= "CUSTOM"
        end,
      }
    end

    self:AddSpacer(tab)

    -- Value Text
    do
      -- Font Group
      local fontGroup = self:AddInlineGroup(tab, {
        name = "属性值",
      }).args

      -- Fonts Font
      fontGroup.valueFont = {
        order = self:GetOrder(),
        type = "select",
        dialogControl = "LSM30_Font",
        name = "字体",
        desc = "设置字体。",
        values = self:GetAllFontsFunc(),
      }

      -- Fonts Outline
      fontGroup.valueFontOutline = {
        order = self:GetOrder(),
        type = "select",
        name = "字体轮廓",
        desc = "设置字体轮廓。",
        values = self:GetAllFontOutlinesFunc(),
        disabled = function()
          return (E.db.TXUI.armory.stats["valueFontShadow"] == true)
        end,
      }

      -- Fonts Size
      fontGroup.valueFontSize = {
        order = self:GetOrder(),
        type = "range",
        name = "字体大小",
        desc = "设置字体大小。",
        min = 1,
        max = 42,
        step = 1,
      }

      -- Fonts Shadow
      fontGroup.valueFontShadow = {
        order = self:GetOrder(),
        type = "toggle",
        name = "字体阴影",
        desc = "设置字体阴影。",
      }

      -- Font color select
      fontGroup.valueFontColor = {
        order = self:GetOrder(),
        type = "select",
        name = "字体颜色",
        values = self:GetAllFontColorsFunc {
          ["GRADIENT"] = F.String.FastGradient("渐变", 0, 0.6, 1, 0, 0.9, 1),
        },
      }

      -- Font Custom Color
      fontGroup.valueFontCustomColor = {
        order = self:GetOrder(),
        type = "color",
        name = "自定义颜色",
        hasAlpha = true,
        get = self:GetFontColorGetter("TXUI.armory.stats", P.armory.stats),
        set = self:GetFontColorSetter("TXUI.armory.stats", function()
          F.Event.TriggerEvent("Armory.SettingsUpdate")
        end),
        hidden = function()
          return E.db.TXUI.armory.stats["valueFontColor"] ~= "CUSTOM"
        end,
      }
    end

    self:AddSpacer(tab)

    -- Stats Mode
    do
      -- Stats Mode Group
      local statsGroup = self:AddInlineGroup(tab, {
        name = "属性可见性",
      }).args

      -- Mode
      for stat, _ in pairs(P.armory.stats.mode) do
        statsGroup[stat] = {
          order = self:GetOrder(),
          type = "select",
          name = F.String.LowercaseEnum(I18n.armory.stats.mode[stat]),
          values = {
            [0] = "隐藏",
            [1] = "仅显示相关",
            [2] = "显示大于 0",
            [3] = "始终显示",
          },
          get = function(info)
            return E.db.TXUI.armory.stats.mode[info[#info]].mode
          end,
          set = function(info, value)
            E.db.TXUI.armory.stats.mode[info[#info]].mode = value
            F.Event.TriggerEvent("Armory.SettingsUpdate")
          end,
        }
      end
    end
  end
end

function O:Armory_OnlyRetailMessage()
  -- Reset order for new page
  self:ResetOrder()

  -- Options
  local options = self.options.armory.args

  -- General Group
  local group = self:AddInlineDesc(options, {
    name = "描述",
  }, {
    name = "不幸的是，此功能仅适用于 " .. TXUI.Title .. " 的正式版。\n\n"
      .. "对于 " .. F.String.ToxiUI("巫妖王之怒：经典版") .. "，我们推荐使用 " .. F.String.WrathArmory() .. " 由 " .. F.String.Class("Repooc", "DRUID") .. " 制作。\n\n",
  }).args

  group.websiteUrl = {
    order = self:GetOrder(),
    type = "input",
    width = "full",
    name = "复制此 URL",
    get = function()
      return I.Strings.Branding.Links.WrathArmory
    end,
  }
end

if not TXUI.IsVanilla then
  O:AddCallback("Armory")
else
  O:AddCallback("Armory_OnlyRetailMessage")
end
