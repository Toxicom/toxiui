local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")

function O:Skins_ElvUI()
  -- Create Tab
  self.options.skins.args["elvuiGroup"] = {
    order = self:GetOrder(),
    type = "group",
    name = "ElvUI",
    args = {},
  }

  -- Options
  local options = self.options.skins.args["elvuiGroup"]["args"]

  -- ElvUI Group Description
  self:AddInlineDesc(options, {
    name = "Description",
  }, {
    name = TXUI.Title .. " 提供了额外的功能给 " .. F.String.ElvUI("ElvUI") .. "，可以在这里配置。",
  })

  -- Spacer
  self:AddSpacer(options)

  -- ElvUI Theme
  do
    -- ElvUI Theme
    local elvuiTheme = self:AddInlineRequirementsDesc(options, {
      name = TXUI.Title .. " " .. F.String.ElvUI("ElvUI") .. " 皮肤",
      get = function(info)
        return E.db.TXUI.addons.elvUITheme[info[#info]]
      end,
      set = function(info, value)
        if E.db.TXUI.addons.elvUITheme[info[#info]] == value then return end
        E.db.TXUI.addons.elvUITheme[info[#info]] = value
        F.Event.TriggerEvent("Theme.SettingsUpdate")
      end,
    }, {
      name = "此模块为所有 "
        .. F.String.ElvUI()
        .. " 元素应用了颗粒背景和阴影。\n\n"
        .. F.String.Warning("警告: ")
        .. "此功能可能会增加加载时间，因为它需要为所有框架应用皮肤。但这不应影响游戏性能。\n\n",
    }, I.Requirements.ElvUITheme)

    -- ElvUI Theme Mode Enable
    elvuiTheme["args"]["enabled"] = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "启用此选项将启用 " .. TXUI.Title .. " " .. F.String.ElvUI("ElvUI") .. " 皮肤。",
      name = function()
        return self:GetEnableName(E.db.TXUI.addons.elvUITheme.enabled)
      end,
      set = function(info, value)
        if E.db.TXUI.addons.elvUITheme[info[#info]] == value then return end
        E.db.TXUI.addons.elvUITheme[info[#info]] = value

        TXUI:GetModule("SplashScreen"):Wrap("Applying Theme ...", function()
          F.Event.TriggerEvent("Theme.DatabaseUpdate")
        end)
      end,
    }

    -- Disabled helper
    local optionsDisabled = function()
      return self:GetEnabledState(E.db.TXUI.addons.elvUITheme.enabled, elvuiTheme) ~= self.enabledState.YES
    end

    -- Shadow Toggle
    elvuiTheme["args"]["shadowEnabled"] = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "为 WeakAuras 和大多数 ElvUI 条启用阴影。",
      name = "柔和阴影",
      disabled = optionsDisabled,
    }

    -- Shadow Alpha
    elvuiTheme["args"]["shadowAlpha"] = {
      order = self:GetOrder(),
      type = "range",
      name = "阴影不透明度",
      min = 0.1,
      max = 1,
      step = 0.01,
      isPercent = true,
      disabled = function()
        return optionsDisabled() or not E.db.TXUI.addons.elvUITheme.shadowEnabled
      end,
    }

    -- Shadow Size
    elvuiTheme["args"]["shadowSize"] = {
      order = self:GetOrder(),
      type = "range",
      name = "阴影大小",
      min = 1,
      max = 10,
      step = 1,
      disabled = function()
        return optionsDisabled() or not E.db.TXUI.addons.elvUITheme.shadowEnabled
      end,
    }
  end

  -- Spacer
  self:AddSpacer(options)

  -- ToxiUI Game Menu Button
  do
    -- ToxiUI Game Menu Button Group
    local gameMenuSkinGroup = self:AddInlineRequirementsDesc(options, {
      name = TXUI.Title .. " 游戏菜单皮肤",
    }, {
      name = "此模块为游戏菜单 (ESC) 背景应用了额外的信息。\n\n",
    }, I.Requirements.GameMenuButton).args

    -- ToxiUI Game Menu Button Enable
    gameMenuSkinGroup.gameMenuSkin = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "启用此选项将启用 " .. TXUI.Title .. " 游戏菜单 (ESC) 皮肤。",
      name = function()
        return self:GetEnableName(E.db.TXUI.addons.gameMenuSkin.enabled, gameMenuSkinGroup)
      end,
      get = function(_)
        return E.db.TXUI.addons.gameMenuSkin.enabled
      end,
      set = function(_, value)
        E.db.TXUI.addons.gameMenuSkin.enabled = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
    }

    gameMenuSkinGroup.showInfo = {
      order = self:GetOrder(),
      type = "toggle",
      name = "显示玩家信息",
      desc = "启用此选项将在游戏菜单背景中显示玩家信息。需要启用背景淡化。",
      get = function(_)
        return E.db.TXUI.addons.gameMenuSkin.showInfo
      end,
      set = function(_, value)
        E.db.TXUI.addons.gameMenuSkin.showInfo = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
      disabled = function()
        return not E.db.TXUI.addons.gameMenuSkin.enabled
      end,
    }

    gameMenuSkinGroup.showTips = {
      order = self:GetOrder(),

      type = "toggle",
      name = "显示随机提示",
      desc = "启用此选项将在游戏菜单背景中显示随机提示。需要启用显示玩家信息。",
      get = function(_)
        return E.db.TXUI.addons.gameMenuSkin.showTips
      end,
      set = function(_, value)
        E.db.TXUI.addons.gameMenuSkin.showTips = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
      disabled = function()
        return not E.db.TXUI.addons.gameMenuSkin.enabled or not E.db.TXUI.addons.gameMenuSkin.showInfo
      end,
    }

    gameMenuSkinGroup.showCollections = {
      order = self:GetOrder(),
      type = "toggle",
      name = "显示收藏",
      desc = "启用此选项将在游戏菜单背景中显示您的收藏信息。需要启用显示玩家信息。",
      get = function()
        return E.db.TXUI.addons.gameMenuSkin.showCollections
      end,
      set = function(_, value)
        E.db.TXUI.addons.gameMenuSkin.showCollections = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
      disabled = function()
        return not E.db.TXUI.addons.gameMenuSkin.enabled or not E.db.TXUI.addons.gameMenuSkin.showInfo
      end,
      hidden = not TXUI.IsRetail,
    }

    gameMenuSkinGroup.classColor = {
      order = self:GetOrder(),
      type = "toggle",
      name = "职业颜色",
      desc = "启用此选项将为背景淡化启用当前职业的颜色。",
      get = function(_)
        return E.db.TXUI.addons.gameMenuSkin.classColor.enabled
      end,
      set = function(_, value)
        E.db.TXUI.addons.gameMenuSkin.classColor.enabled = value
      end,
      disabled = function()
        return not E.db.TXUI.addons.gameMenuSkin.enabled
      end,
    }

    gameMenuSkinGroup.bgColor = {
      order = self:GetOrder(),
      type = "color",
      name = "背景颜色",
      hasAlpha = true,
      width = 1.1,
      get = self:GetFontColorGetter("TXUI.addons.gameMenuSkin", P.addons.gameMenuSkin),
      set = self:GetFontColorSetter("TXUI.addons.gameMenuSkin"),
      disabled = function()
        return not E.db.TXUI.addons.gameMenuSkin.enabled
      end,
    }

    gameMenuSkinGroup.specIconStyle = {
      order = self:GetOrder(),
      type = "select",
      name = "专精图标样式 " .. E.NewSign,
      desc = "选择显示职业颜色的专精图标或样式化的专精图标。",
      width = 1.5,
      values = {
        ToxiSpecColored = TXUI.Title .. F.String.Class(" Class Colored "),
        ToxiSpecColoredStroke = TXUI.Title .. F.String.Class(" Class Colored ") .. F.String.ToxiUI("[STROKE]"),
        ToxiSpecStylized = TXUI.Title .. " Stylized",
        ToxiSpecWhite = TXUI.Title .. " White",
        ToxiSpecWhiteStroke = TXUI.Title .. " White " .. F.String.ToxiUI("[STROKE]"),
      },
      get = function()
        return E.db.TXUI.addons.gameMenuSkin.specIconStyle
      end,
      set = function(_, value)
        E.db.TXUI.addons.gameMenuSkin.specIconStyle = value
      end,
      disabled = function()
        return not E.db.TXUI.addons.gameMenuSkin.enabled or not E.db.TXUI.addons.gameMenuSkin.showInfo
      end,
    }

    gameMenuSkinGroup.specIconSize = {
      order = self:GetOrder(),
      type = "range",
      name = "专精图标大小 " .. E.NewSign,
      desc = "更改专精图标的大小。",
      min = 8,
      max = 64,
      step = 1,
      get = function()
        return E.db.TXUI.addons.gameMenuSkin.specIconSize
      end,
      set = function(_, value)
        E.db.TXUI.addons.gameMenuSkin.specIconSize = value
      end,
      disabled = function()
        return not E.db.TXUI.addons.gameMenuSkin.enabled or not E.db.TXUI.addons.gameMenuSkin.showInfo
      end,
    }
  end

  -- Spacer
  self:AddSpacer(options)

  -- ElvUI AFK Mode
  do
    -- ElvUI AFK Mode Group
    local elvuiAfkGroup = self:AddInlineDesc(options, {
      name = "AFK 模式",
      get = function(info)
        return E.db.TXUI.addons.afkMode[info[#info]]
      end,
      set = function(info, value)
        E.db.TXUI.addons.afkMode[info[#info]] = value
        F.Event.TriggerEvent("AFK.DatabaseUpdate")
      end,
    }, {
      name = "启用此选项将启用 " .. TXUI.Title .. " AFK 模式。\n\n",
    }).args

    -- ElvUI AFK Mode Enable
    elvuiAfkGroup.enabled = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "启用此选项将启用 " .. TXUI.Title .. " AFK 模式。",
      name = function()
        return self:GetEnableName(E.db.TXUI.addons.afkMode.enabled)
      end,
    }

    -- Disabled helper
    local optionsDisabled = function()
      return self:GetEnabledState(E.db.TXUI.addons.afkMode.enabled, elvuiAfkGroup) ~= self.enabledState.YES
    end

    -- Play Random Emotes
    elvuiAfkGroup.playEmotes = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "启用此选项将在玩家模型上显示随机表情。",
      name = "播放表情",
      disabled = optionsDisabled,
    }

    -- Turn Camera while AFK
    elvuiAfkGroup.turnCamera = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "启用此选项将在 AFK 屏幕激活时旋转摄像头。",
      name = "旋转摄像头",
      disabled = optionsDisabled,
    }

    elvuiAfkGroup.showChangelog = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "启用此选项将在 AFK 屏幕激活时显示最新的 " .. TXUI.Title .. " 更新日志。",
      name = "显示更新日志 " .. E.NewSign,
      disabled = optionsDisabled,
      set = function(_, value)
        E.db.TXUI.addons.afkMode.showChangelog = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
    }

    elvuiAfkGroup.showTips = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "启用此选项将在 AFK 屏幕激活时显示随机 " .. TXUI.Title .. " 提示。",
      name = "显示提示 " .. E.NewSign,
      disabled = optionsDisabled,
      set = function(_, value)
        E.db.TXUI.addons.afkMode.showTips = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
    }

    elvuiAfkGroup.specIconStyle = {
      order = self:GetOrder(),
      type = "select",
      name = "专精图标样式 " .. E.NewSign,
      desc = "选择显示职业颜色的专精图标或样式化的专精图标。",
      width = 1.5,
      values = {
        ToxiSpecColored = TXUI.Title .. F.String.Class(" Class Colored "),
        ToxiSpecColoredStroke = TXUI.Title .. F.String.Class(" Class Colored ") .. F.String.ToxiUI("[STROKE]"),
        ToxiSpecStylized = TXUI.Title .. " Stylized",
        ToxiSpecWhite = TXUI.Title .. " White",
        ToxiSpecWhiteStroke = TXUI.Title .. " White " .. F.String.ToxiUI("[STROKE]"),
      },
      get = function()
        return E.db.TXUI.addons.afkMode.specIconStyle
      end,
      set = function(_, value)
        E.db.TXUI.addons.afkMode.specIconStyle = value
      end,
      disabled = function()
        return not E.db.TXUI.addons.afkMode.enabled
      end,
    }

    elvuiAfkGroup.specIconSize = {
      order = self:GetOrder(),
      type = "range",
      name = "专精图标大小 " .. E.NewSign,
      desc = "更改专精图标的大小。",
      min = 8,
      max = 64,
      step = 1,
      get = function()
        return E.db.TXUI.addons.afkMode.specIconSize
      end,
      set = function(_, value)
        E.db.TXUI.addons.afkMode.specIconSize = value
      end,
      disabled = function()
        return not E.db.TXUI.addons.afkMode.enabled
      end,
    }
  end

  -- Spacer
  self:AddSpacer(options)

  -- ToxiUI Deconstruct
  if TXUI.IsRetail then
    -- ToxiUI Deconstruct Group
    local deconstructGroup = self:AddInlineRequirementsDesc(options, {
      name = "分解",
      get = function(info)
        return E.db.TXUI.addons.deconstruct[info[#info]]
      end,
      set = function(info, value)
        E.db.TXUI.addons.deconstruct[info[#info]] = value
        F.Event.TriggerEvent("Deconstruct.SettingsUpdate")
      end,
    }, {
      name = "在您的背包中添加一个按钮以轻松分解物品：分解、勘探、研磨..\n\n",
    }, I.Requirements.Deconstruct).args

    -- ToxiUI Deconstruct Enable
    deconstructGroup.enabled = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "启用 " .. TXUI.Title .. " 分解模块。",
      name = function()
        return self:GetEnableName(E.db.TXUI.addons.deconstruct.enabled, deconstructGroup)
      end,
      get = function(_)
        return E.db.TXUI.addons.deconstruct.enabled
      end,
      set = function(_, value)
        E.db.TXUI.addons.deconstruct.enabled = value
        F.Event.TriggerEvent("Deconstruct.DatabaseUpdate")
      end,
    }

    -- Disabled helper
    local optionsDisabled = function()
      return self:GetEnabledState(E.db.TXUI.addons.deconstruct.enabled, deconstructGroup) ~= self.enabledState.YES
    end

    deconstructGroup.highlightMode = {
      order = self:GetOrder(),
      type = "select",
      name = "高亮可用物品",
      desc = "高亮背包中可以分解的物品。",
      values = {
        ["NONE"] = "None",
        ["DARK"] = "Dark",
        ["ALPHA"] = "Light",
      },
      disabled = optionsDisabled,
    }

    deconstructGroup.labelEnabled = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "当您悬停在物品上时标记物品。",
      name = "物品标签",
      disabled = optionsDisabled,
    }

    deconstructGroup.glowEnabled = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "当您悬停在物品上时物品会发光。",
      name = "物品发光",
      disabled = optionsDisabled,
    }

    deconstructGroup.glowAlpha = {
      order = self:GetOrder(),
      type = "range",
      name = "发光不透明度",
      min = 0.1,
      max = 1,
      step = 0.01,
      isPercent = true,
      disabled = function()
        return optionsDisabled() or not E.db.TXUI.addons.deconstruct.glowEnabled
      end,
    }

    -- Spacer
    self:AddSpacer(deconstructGroup)

    deconstructGroup.animations = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "启用此选项将启用 " .. TXUI.Title .. " 分解动画。",
      name = "动画",
      disabled = optionsDisabled,
    }

    local animationsDisabled = function()
      return optionsDisabled() or not E.db.TXUI.addons.deconstruct.animations
    end

    deconstructGroup.animationsMult = {
      order = self:GetOrder(),
      type = "range",
      name = "动画速度",
      min = 0.1,
      max = 2,
      step = 0.1,
      isPercent = true,
      get = function()
        return 1 / E.db.TXUI.addons.deconstruct.animationsMult
      end,
      set = function(_, value)
        E.db.TXUI.addons.deconstruct.animationsMult = 1 / value
      end,
      disabled = animationsDisabled,
    }

    -- Spacer
    self:AddSpacer(options)
  end

  -- ElvUI Global Fade Persist Mode
  local actionBarsAreDisabled = E.private.actionbar.enable ~= true
  do
    -- ElvUI Global Fade Persist Group
    local elvuiFadePersistGroup = self:AddInlineRequirementsDesc(options, {
      name = "动作条淡化",
    }, {
      name = "此选项控制您的动作条的可见性。\n\n"
        .. F.String.ToxiUI("信息: ")
        .. "如果启用了载具条或将模式设置为“ElvUI 默认”，则“在载具中显示”选项将被禁用且无效！\n\n"
        .. F.String.Warning("警告: ")
        .. "禁用此模块仍然不会显示动作条，因为它们在默认的 ElvUI 设置中也被淡化。我们建议使用可用的下拉选项之一。\n\n",
    }, I.Requirements.FadePersist).args

    -- ElvUI Global Fade Persist Enable
    elvuiFadePersistGroup.elvuiFadePersist = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "此选项控制何时显示您的动作条。",
      name = function()
        return self:GetEnableName(E.db.TXUI.addons.fadePersist.enabled, elvuiFadePersistGroup)
      end,
      get = function(_)
        return E.db.TXUI.addons.fadePersist.enabled
      end,
      set = function(_, value)
        E.db.TXUI.addons.fadePersist.enabled = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
    }

    -- Disabled helper
    local optionsDisabled = function()
      return actionBarsAreDisabled or self:GetEnabledState(E.db.TXUI.addons.fadePersist.enabled, elvuiFadePersistGroup) ~= self.enabledState.YES
    end

    -- Mode
    elvuiFadePersistGroup.elvuiFadePersistMode = {
      order = self:GetOrder(),
      type = "select",
      name = "模式",
      values = {
        MOUSEOVER = "仅鼠标悬停",
        NO_COMBAT = "战斗中隐藏",
        IN_COMBAT = "战斗中显示",
        ELVUI = "ElvUI 默认",
        ALWAYS = "始终显示",
      },
      disabled = optionsDisabled,
      get = function(_)
        return E.db.TXUI.addons.fadePersist.mode
      end,
      set = function(_, value)
        E.db.TXUI.addons.fadePersist.mode = value
        F.Event.TriggerEvent("FadePersist.DatabaseUpdate")
      end,
    }

    -- Show in Vehicles
    elvuiFadePersistGroup.showInVehicles = {
      order = self:GetOrder(),
      type = "toggle",
      name = "在载具中显示",
      desc = "启用此选项将在载具中显示动作条" .. (TXUI.IsRetail and " 和/或在驭龙时" or "") .. "，无论您选择了哪种模式。",
      disabled = function()
        return actionBarsAreDisabled
          or self:GetEnabledState(E.db.TXUI.addons.fadePersist.enabled, elvuiFadePersistGroup) ~= self.enabledState.YES
          or E.db.TXUI.addons.fadePersist.mode == "ELVUI"
          or E.db.TXUI.vehicleBar.enabled
      end,
      get = function(_)
        return E.db.TXUI.addons.fadePersist.showInVehicles
      end,
      set = function(_, value)
        E.db.TXUI.addons.fadePersist.showInVehicles = value
        F.Event.TriggerEvent("FadePersist.DatabaseUpdate")
      end,
    }
  end

  -- Spacer
  self:AddSpacer(options)

  -- Color Modifier Keys
  do
    local colorModifiersGroup = self:AddInlineRequirementsDesc(options, {
      name = "颜色修饰键",
    }, {
      name = "此选项将您的修饰键颜色更改为职业颜色。\n\n"
        .. F.String.Warning("警告: ")
        .. "此选项还会增加动作条键绑定的宽度以匹配按钮的宽度。\n\n",
    }, I.Requirements.ColorModifiers).args

    colorModifiersGroup.enable = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "启用此选项将您的修饰键颜色更改为职业颜色。",
      name = function()
        return self:GetEnableName(E.db.TXUI.addons.colorModifiers.enabled, colorModifiersGroup)
      end,
      get = function()
        return E.db.TXUI.addons.colorModifiers.enabled
      end,
      set = function(_, value)
        E.db.TXUI.addons.colorModifiers.enabled = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
    }
  end
end

O:AddCallback("Skins_ElvUI")
