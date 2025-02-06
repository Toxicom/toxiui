local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")
local ACH = LibStub("LibAceConfigHelper")

local _G = _G
local FACTION_BAR_COLORS = _G.FACTION_BAR_COLORS
local LOCALIZED_CLASS_NAMES_FEMALE = _G.LOCALIZED_CLASS_NAMES_FEMALE
local LOCALIZED_CLASS_NAMES_MALE = _G.LOCALIZED_CLASS_NAMES_MALE
local PowerBarColor = _G.PowerBarColor

function O:ToxiUI_Themes_GradientMode()
  local gradientTitle = "|cffff97f6G|r|cfff8b0f2ra|r|cfff5c6f1di|r|cfff3d9f1en|r|cffffeafdt"

  -- Create Tab
  self.options.themes.args.gradientMode = {
    order = self:GetOrder(),
    type = "group",
    childGroups = "tab",
    name = gradientTitle .. " Mode|r",
    get = function(info)
      return E.db.TXUI.themes.gradientMode[info[#info]]
    end,
    set = function(info, value)
      E.db.TXUI.themes.gradientMode[info[#info]] = value
      F.Event.TriggerEvent("ThemesGradients.DatabaseUpdate")
    end,
    args = {},
  }

  -- Options
  local options = self.options.themes.args.gradientMode.args

  -- General
  do
    -- General Group
    local generalGroup = self:AddInlineRequirementsDesc(options, {
      name = "描述",
    }, {
      name = "我们为 " .. TXUI.Title .. " 提供了不同的主题，您可以在下面启用或禁用它们。"
        .. "\n\n"
        .. "某些颜色（如 Details 暗模式渐变文本）仅在重新加载后更新。"
        .. "\n\n"
        .. F.String.Error(
          "警告：启用这些设置之一可能会覆盖 ElvUI 和 Details 中的颜色或纹理，它们还会阻止您更改 ElvUI 中的某些设置！"
        )
        .. "\n\n",
    }, I.Requirements.GradientMode).args

    -- Enable
    generalGroup.enabled = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "启用此选项可为 " .. TXUI.Title .. " 启用炫酷的渐变效果。\n\n" .. F.String.Error(
        "警告：启用此设置将覆盖 ElvUI 和 Details 中的纹理！"
      ),
      name = function()
        return self:GetEnableName(E.db.TXUI.themes.gradientMode.enabled, generalGroup)
      end,
      get = function()
        return E.db.TXUI.themes.gradientMode.enabled
      end,
      set = function(_, value)
        TXUI:GetModule("Themes"):Toggle("gradientMode", value)
      end,
    }
  end

  -- Colors
  do
    -- Tab
    local tab = self:AddGroup(options, {
      name = "职业颜色",
    }).args

    -- Colors Group
    local colorGroup = self:AddInlineDesc(tab, {
      name = "职业颜色",
    }, {
      name = TXUI.Title
        .. " 渐变主题 "
        .. F.String.Class("从一种颜色", "MONK")
        .. " 过渡到另一种颜色。您可以在下面更改 "
        .. F.String.Class("过渡", "MONK")
        .. "。\n\n",
    }).args

    -- Get correct classname table
    local classNames = LOCALIZED_CLASS_NAMES_MALE
    if UnitSex("player") == 3 then classNames = LOCALIZED_CLASS_NAMES_FEMALE end

    local function generateClassOptions(class)
      -- Class Name
      self:AddInlineSoloDesc(colorGroup, {
        width = 1,
        customWidth = 120,
        name = F.String.Class(classNames[class], class),
      })

      -- Shift Color
      colorGroup[class .. "shift"] = {
        order = self:GetOrder(),
        type = "color",
        name = "",
        hasAlpha = false,
        width = 1,
        customWidth = 30,
        get = self:GetFontColorGetter(
          "TXUI.themes.gradientMode.classColorMap." .. I.Enum.GradientMode.Color.SHIFT,
          P.themes.gradientMode.classColorMap[I.Enum.GradientMode.Color.SHIFT],
          class
        ),
        set = self:GetFontColorSetter("TXUI.themes.gradientMode.classColorMap." .. I.Enum.GradientMode.Color.SHIFT, function()
          F.Event.TriggerEvent("ThemesGradients.SettingsUpdate.Health")
          F.Event.TriggerEvent("SkinsDetailsGradients.SettingsUpdate")
        end, class),
      }

      -- Spacer for arrow & arrow
      self:AddInlineSoloDesc(colorGroup, {
        width = 1,
        customWidth = 30,
        name = "",
      })
      self:AddInlineSoloDesc(colorGroup, {
        width = 1,
        customWidth = 30,
        name = F.String.Class(">", "MONK"),
      })

      -- Normal Color
      colorGroup[class .. "normal"] = {
        order = self:GetOrder(),
        type = "color",
        name = "",
        hasAlpha = false,
        width = 1,
        customWidth = 30,
        get = self:GetFontColorGetter(
          "TXUI.themes.gradientMode.classColorMap." .. I.Enum.GradientMode.Color.NORMAL,
          P.themes.gradientMode.classColorMap[I.Enum.GradientMode.Color.NORMAL],
          class
        ),
        set = self:GetFontColorSetter("TXUI.themes.gradientMode.classColorMap." .. I.Enum.GradientMode.Color.NORMAL, function()
          F.Event.TriggerEvent("ThemesGradients.SettingsUpdate.Health")
          F.Event.TriggerEvent("SkinsDetailsGradients.SettingsUpdate")
        end, class),
      }

      -- Spacer
      self:AddTinySpacer(colorGroup)
    end

    -- Class Colors
    for class, _ in pairs(P.themes.gradientMode.classColorMap[I.Enum.GradientMode.Color.SHIFT]) do
      if classNames[class] ~= nil then generateClassOptions(class) end
    end
  end

  -- Reaction Colors
  do
    local name = "NPC 颜色"

    -- Tab
    local tab = self:AddGroup(options, {
      name = name,
    }).args

    -- Colors Group
    local colorGroup = self:AddInlineDesc(tab, {
      name = name,
    }, {
      name = "在这里您可以更改 NPC 颜色的 " .. F.String.Class("渐变过渡", "MONK") .. "。\n\n",
    }).args

    -- Reaction Colors
    for reaction, _ in pairs(P.themes.gradientMode.reactionColorMap[I.Enum.GradientMode.Color.SHIFT]) do
      -- Get correct color index for blizzard colors
      local colorIndex = 1
      if reaction == "GOOD" then
        colorIndex = 5
      elseif reaction == "NEUTRAL" then
        colorIndex = 4
      end

      -- Reaction Name
      local npcColorName = "Neutral"
      if reaction == "GOOD" then
        npcColorName = "Friendly"
      elseif reaction == "BAD" then
        npcColorName = "Enemy"
      end

      -- Reaction Name
      self:AddInlineSoloDesc(colorGroup, {
        width = 1,
        customWidth = 120,
        name = F.String.RGB(npcColorName, FACTION_BAR_COLORS[colorIndex]),
      })

      -- Shift Color
      colorGroup[reaction .. "shift"] = {
        order = self:GetOrder(),
        type = "color",
        name = "",
        hasAlpha = false,
        width = 1,
        customWidth = 30,
        get = self:GetFontColorGetter(
          "TXUI.themes.gradientMode.reactionColorMap." .. I.Enum.GradientMode.Color.SHIFT,
          P.themes.gradientMode.reactionColorMap[I.Enum.GradientMode.Color.SHIFT],
          reaction
        ),
        set = self:GetFontColorSetter("TXUI.themes.gradientMode.reactionColorMap." .. I.Enum.GradientMode.Color.SHIFT, function()
          F.Event.TriggerEvent("ThemesGradients.SettingsUpdate.Health")
          F.Event.TriggerEvent("SkinsDetailsGradients.SettingsUpdate")
        end, reaction),
      }

      -- Spacer for arrow & arrow
      self:AddInlineSoloDesc(colorGroup, {
        width = 1,
        customWidth = 30,
        name = "",
      })
      self:AddInlineSoloDesc(colorGroup, {
        width = 1,
        customWidth = 30,
        name = F.String.Class(">", "MONK"),
      })

      -- Normal Color
      colorGroup[reaction .. "normal"] = {
        order = self:GetOrder(),
        type = "color",
        name = "",
        hasAlpha = false,
        width = 1,
        customWidth = 30,
        get = self:GetFontColorGetter(
          "TXUI.themes.gradientMode.reactionColorMap." .. I.Enum.GradientMode.Color.NORMAL,
          P.themes.gradientMode.reactionColorMap[I.Enum.GradientMode.Color.NORMAL],
          reaction
        ),
        set = self:GetFontColorSetter("TXUI.themes.gradientMode.reactionColorMap." .. I.Enum.GradientMode.Color.NORMAL, function()
          F.Event.TriggerEvent("ThemesGradients.SettingsUpdate.Health")
          F.Event.TriggerEvent("SkinsDetailsGradients.SettingsUpdate")
        end, reaction),
      }

      -- Spacer
      self:AddTinySpacer(colorGroup)
    end
  end

  -- Power Colors
  do
    local name = "能量颜色"

    -- Tab
    local tab = self:AddGroup(options, {
      name = name,
    }).args

    -- Power Color Group
    local colorGroup = self:AddInlineDesc(tab, {
      name = name,
    }, {
      name = "在这里您可以更改能量颜色的 " .. F.String.Class("渐变过渡", "MONK") .. "。\n\n",
    }).args

    -- Power Colors
    local function generatePowerColors(power)
      local colorIndex = power
      if colorIndex == "ALT_POWER" then colorIndex = "MANA" end

      -- Class Name
      self:AddInlineSoloDesc(colorGroup, {
        width = 1,
        customWidth = 120,
        name = F.String.RGB(F.String.LowercaseEnum(power), { F.CalculateMultiplierColorArray(1.35, PowerBarColor[colorIndex]) }),
      })

      -- Shift Color
      colorGroup[power .. "shift"] = {
        order = self:GetOrder(),
        type = "color",
        name = "",
        hasAlpha = false,
        width = 1,
        customWidth = 30,
        get = self:GetFontColorGetter(
          "TXUI.themes.gradientMode.powerColorMap." .. I.Enum.GradientMode.Color.SHIFT,
          P.themes.gradientMode.powerColorMap[I.Enum.GradientMode.Color.SHIFT],
          power
        ),
        set = self:GetFontColorSetter("TXUI.themes.gradientMode.powerColorMap." .. I.Enum.GradientMode.Color.SHIFT, function()
          F.Event.TriggerEvent("ThemesGradients.SettingsUpdate.Power")
          F.Event.TriggerEvent("SkinsDetailsGradients.SettingsUpdate")
        end, power),
      }

      -- Spacer for arrow & arrow
      self:AddInlineSoloDesc(colorGroup, {
        width = 1,
        customWidth = 30,
        name = "",
      })
      self:AddInlineSoloDesc(colorGroup, {
        width = 1,
        customWidth = 30,
        name = F.String.Class(">", "MONK"),
      })

      -- Normal Color
      colorGroup[power .. "normal"] = {
        order = self:GetOrder(),
        type = "color",
        name = "",
        hasAlpha = false,
        width = 1,
        customWidth = 30,
        get = self:GetFontColorGetter(
          "TXUI.themes.gradientMode.powerColorMap." .. I.Enum.GradientMode.Color.NORMAL,
          P.themes.gradientMode.powerColorMap[I.Enum.GradientMode.Color.NORMAL],
          power
        ),
        set = self:GetFontColorSetter("TXUI.themes.gradientMode.powerColorMap." .. I.Enum.GradientMode.Color.NORMAL, function()
          F.Event.TriggerEvent("ThemesGradients.SettingsUpdate.Power")
          F.Event.TriggerEvent("SkinsDetailsGradients.SettingsUpdate")
        end, power),
      }

      -- Spacer
      self:AddTinySpacer(colorGroup)
    end

    local wrathExcluded = {
      ["PAIN"] = true,
      ["FURY"] = true,
      ["LUNAR_POWER"] = true,
      ["INSANITY"] = true,
      ["MAELSTROM"] = true,
    }

    for power, _ in pairs(P.themes.gradientMode.powerColorMap[I.Enum.GradientMode.Color.SHIFT]) do
      if TXUI.IsRetail or (TXUI.IsCata and wrathExcluded[power] == nil) then generatePowerColors(power) end
    end
  end

  -- Other Colors
  do
    -- Tab
    local tab = self:AddGroup(options, {
      name = "其他颜色",
    }).args

    -- State Group
    local stateGroup = self:AddInlineDesc(tab, {
      name = "状态颜色",
    }, {
      name = "在这里您可以更改状态颜色的 " .. F.String.Class("渐变过渡", "MONK") .. "。\n\n",
    }).args

    -- State Colors
    for special, _ in pairs(P.themes.gradientMode.specialColorMap[I.Enum.GradientMode.Color.SHIFT]) do
      local nameColor = P.themes.gradientMode.specialColorMap[I.Enum.GradientMode.Color.NORMAL][special]
      if special == "DEAD" then nameColor = F.Table.HexToRGB("#ffffff") end

      -- State Description
      self:AddInlineSoloDesc(stateGroup, {
        width = 1,
        customWidth = 120,
        name = F.String.RGB(F.String.LowercaseEnum(special), nameColor),
      })

      -- Shift Color
      stateGroup[special .. "shift"] = {
        order = self:GetOrder(),
        type = "color",
        name = "",
        hasAlpha = false,
        width = 1,
        customWidth = 30,
        get = self:GetFontColorGetter(
          "TXUI.themes.gradientMode.specialColorMap." .. I.Enum.GradientMode.Color.SHIFT,
          P.themes.gradientMode.specialColorMap[I.Enum.GradientMode.Color.SHIFT],
          special
        ),
        set = self:GetFontColorSetter("TXUI.themes.gradientMode.specialColorMap." .. I.Enum.GradientMode.Color.SHIFT, function()
          F.Event.TriggerEvent("ThemesGradients.SettingsUpdate.Health")
          F.Event.TriggerEvent("SkinsDetailsGradients.SettingsUpdate")
        end, special),
      }

      -- Spacer for arrow & arrow
      self:AddInlineSoloDesc(stateGroup, {
        width = 1,
        customWidth = 30,
        name = "",
      })
      self:AddInlineSoloDesc(stateGroup, {
        width = 1,
        customWidth = 30,
        name = F.String.Class(">", "MONK"),
      })

      -- Normal Color
      stateGroup[special .. "normal"] = {
        order = self:GetOrder(),
        type = "color",
        name = "",
        hasAlpha = false,
        width = 1,
        customWidth = 30,
        get = self:GetFontColorGetter(
          "TXUI.themes.gradientMode.specialColorMap." .. I.Enum.GradientMode.Color.NORMAL,
          P.themes.gradientMode.specialColorMap[I.Enum.GradientMode.Color.NORMAL],
          special
        ),
        set = self:GetFontColorSetter("TXUI.themes.gradientMode.specialColorMap." .. I.Enum.GradientMode.Color.NORMAL, function()
          F.Event.TriggerEvent("ThemesGradients.SettingsUpdate.Health")
          F.Event.TriggerEvent("SkinsDetailsGradients.SettingsUpdate")
        end, special),
      }

      -- Spacer
      self:AddTinySpacer(stateGroup)
    end

    self:AddSpacer(tab)

    -- Cast Group
    local castGroup = self:AddInlineDesc(tab, {
      name = "施法条颜色",
    }, {
      name = "在这里您可以更改施法条颜色的 " .. F.String.Class("渐变过渡", "MONK") .. "。\n\n",
    }).args

    -- Cast Colors
    for cast, _ in pairs(P.themes.gradientMode.castColorMap[I.Enum.GradientMode.Color.SHIFT]) do
      if (cast == "NOINTERRUPT") or (cast == "DEFAULT") then
        -- Name
        local settingsName
        if cast == "NOINTERRUPT" then
          settingsName = "Non-interruptible"
        elseif cast == "DEFAULT" then
          settingsName = "Regular"
        else
          settingsName = F.String.LowercaseEnum(cast)
        end

        -- Cast Description
        self:AddInlineSoloDesc(castGroup, {
          width = 1,
          customWidth = 120,
          name = F.String.RGB(settingsName, P.themes.gradientMode.castColorMap[I.Enum.GradientMode.Color.NORMAL][cast]),
        })

        -- Shift Color
        castGroup[cast .. "shift"] = {
          order = self:GetOrder(),
          type = "color",
          name = "",
          hasAlpha = false,
          width = 1,
          customWidth = 30,
          get = self:GetFontColorGetter(
            "TXUI.themes.gradientMode.castColorMap." .. I.Enum.GradientMode.Color.SHIFT,
            P.themes.gradientMode.castColorMap[I.Enum.GradientMode.Color.SHIFT],
            cast
          ),
          set = self:GetFontColorSetter("TXUI.themes.gradientMode.castColorMap." .. I.Enum.GradientMode.Color.SHIFT, function()
            F.Event.TriggerEvent("ThemesGradients.SettingsUpdate")
            F.Event.TriggerEvent("SkinsDetailsGradients.SettingsUpdate")
          end, cast),
        }

        -- Spacer for arrow & arrow
        self:AddInlineSoloDesc(castGroup, {
          width = 1,
          customWidth = 30,
          name = "",
        })
        self:AddInlineSoloDesc(castGroup, {
          width = 1,
          customWidth = 30,
          name = F.String.Class(">", "MONK"),
        })

        -- Normal Color
        castGroup[cast .. "normal"] = {
          order = self:GetOrder(),
          type = "color",
          name = "",
          hasAlpha = false,
          width = 1,
          customWidth = 30,
          get = self:GetFontColorGetter(
            "TXUI.themes.gradientMode.castColorMap." .. I.Enum.GradientMode.Color.NORMAL,
            P.themes.gradientMode.castColorMap[I.Enum.GradientMode.Color.NORMAL],
            cast
          ),
          set = self:GetFontColorSetter("TXUI.themes.gradientMode.castColorMap." .. I.Enum.GradientMode.Color.NORMAL, function()
            F.Event.TriggerEvent("ThemesGradients.SettingsUpdate")
            F.Event.TriggerEvent("SkinsDetailsGradients.SettingsUpdate")
          end, cast),
        }

        -- Spacer
        self:AddTinySpacer(castGroup)
      end
    end
  end

  -- Settings
  do
    local name = "设置"

    -- Tab
    local tab = self:AddGroup(options, {
      name = name,
    }).args

    -- Settings Group
    self:AddInlineDesc(tab, {
      name = name,
    }, {
      name = "在这里您可以更改 " .. gradientTitle .. " 模式|r 的其他设置。\n\n",
    })

    -- Spacer
    self:AddSpacer(tab)

    do
      local texturesGroup = self:AddInlineDesc(tab, {
        name = "单位框架纹理",
      }, {
        name = "更改用于单位框架的生命值、能量值和施法状态条的纹理。",
      }).args

      texturesGroup.health = ACH:SharedMediaStatusbar("生命值纹理", "单位框架的生命值条纹理", self:GetOrder(), 200, function()
        return E.db.TXUI.themes.gradientMode.textures.health
      end, function(_, value)
        E.db.TXUI.themes.gradientMode.textures.health = value
        F.Event.TriggerEvent("ThemesGradients.TexturesUpdate")
      end)

      texturesGroup.power = ACH:SharedMediaStatusbar("能量值纹理", "单位框架的能量值条纹理", self:GetOrder(), 200, function()
        return E.db.TXUI.themes.gradientMode.textures.power
      end, function(_, value)
        E.db.TXUI.themes.gradientMode.textures.power = value
        F.Event.TriggerEvent("ThemesGradients.TexturesUpdate")
      end)

      texturesGroup.cast = ACH:SharedMediaStatusbar("施法条纹理", "单位框架的施法条纹理", self:GetOrder(), 200, function()
        return E.db.TXUI.themes.gradientMode.textures.cast
      end, function(_, value)
        E.db.TXUI.themes.gradientMode.textures.cast = value
        F.Event.TriggerEvent("ThemesGradients.TexturesUpdate")
      end)
    end

    -- Spacer
    self:AddSpacer(tab)

    do
      local brightnessGroup = self:AddInlineDesc(tab, {
        name = "背景亮度",
        get = function(info)
          return E.db.TXUI.themes.gradientMode[info[#info]]
        end,
        set = function(info, value)
          if E.db.TXUI.themes.gradientMode[info[#info]] == value then return end

          E.db.TXUI.themes.gradientMode[info[#info]] = value
          F.Event.TriggerEvent("ThemesGradients.SettingsUpdate.Health")
          F.Event.TriggerEvent("ThemesGradients.SettingsUpdate.Power", true)
          F.Event.TriggerEvent("SkinsDetailsGradients.SettingsUpdate")
        end,
      }, {
        name = "此选项控制背景颜色的强度。\n\n较低的值表示较暗的背景，较高的值表示较亮的背景。\n\n",
      }).args

      -- Background Multiplier Size
      brightnessGroup.backgroundMultiplier = {
        order = self:GetOrder(),
        type = "range",
        name = "",
        min = 0,
        max = 0.5,
        step = 0.01,
        isPercent = true,
        width = 2,
      }
    end

    -- Spacer
    self:AddSpacer(tab)

    do
      local healthGroup = self:AddInlineDesc(tab, {
        name = "生命值颜色标签",
      }, {
        name = "为单位框架中使用的 " .. TXUI.Title .. " 文本标签着色生命值。\n\n"
          .. F.String.Error("重要提示：")
          .. "此选项仅适用于 "
          .. F.String.ToxiUI("tx:health:percent")
          .. " 和 "
          .. F.String.ToxiUI("tx:health:percent:nosign")
          .. " 标签！\n\n",
      }).args

      healthGroup.enable = {
        order = self:GetOrder(),
        type = "toggle",
        get = function()
          return E.db.TXUI.themes.gradientMode.colorHealth.enabled
        end,
        set = function(_, value)
          if E.db.TXUI.themes.gradientMode.colorHealth.enabled == value then return end

          E.db.TXUI.themes.gradientMode.colorHealth.enabled = value
        end,
        name = function()
          return self:GetEnableName(E.db.TXUI.themes.gradientMode.colorHealth.enabled, healthGroup)
        end,
      }

      local thresholdDisabled = function()
        return self:GetEnabledState(E.db.TXUI.themes.gradientMode.colorHealth.enabled) ~= self.enabledState.YES
      end

      healthGroup.yellow = {
        order = self:GetOrder(),
        type = "range",
        name = F.String.Warning("黄色") .. " 阈值",
        desc = "此滑块确定何时应将生命值着色为 " .. F.String.Warning("黄色"),
        min = 35,
        max = 75,
        step = 1,
        disabled = thresholdDisabled,
        get = function()
          return E.db.TXUI.themes.gradientMode.colorHealth.yellowThreshold
        end,
        set = function(_, value)
          if E.db.TXUI.themes.gradientMode.colorHealth.yellowThreshold == value then return end

          E.db.TXUI.themes.gradientMode.colorHealth.yellowThreshold = value
        end,
      }

      healthGroup.red = {
        order = self:GetOrder(),
        type = "range",
        name = F.String.Error("红色") .. " 阈值",
        desc = "此滑块确定何时应将生命值着色为 " .. F.String.Error("红色"),
        min = 10,
        max = 35,
        step = 1,
        disabled = thresholdDisabled,
        get = function()
          return E.db.TXUI.themes.gradientMode.colorHealth.redThreshold
        end,
        set = function(_, value)
          if E.db.TXUI.themes.gradientMode.colorHealth.redThreshold == value then return end

          E.db.TXUI.themes.gradientMode.colorHealth.redThreshold = value
        end,
      }
    end

    -- Spacer
    self:AddSpacer(tab)

    -- Saturation Boost
    local saturationGroup = self:AddInlineDesc(tab, {
      name = "饱和度增强 " .. E.NewSign,
      get = function(info)
        return E.db.TXUI.themes.gradientMode.saturationBoost[info[#info]]
      end,
      set = function(info, value)
        if E.db.TXUI.themes.gradientMode.saturationBoost[info[#info]] == value then return end

        E.db.TXUI.themes.gradientMode.saturationBoost[info[#info]] = value
        F.Event.TriggerEvent("ThemesGradients.SettingsUpdate.Health")
        F.Event.TriggerEvent("ThemesGradients.SettingsUpdate.Power", true)
        F.Event.TriggerEvent("SkinsDetailsGradients.SettingsUpdate")
      end,
    }, {
      name = "增强 " .. gradientTitle .. " 颜色|r 的饱和度并使其变暗\n适合喜欢更极端效果的人\n\n",
    }).args

    saturationGroup.enabled = {
      order = self:GetOrder(),
      type = "toggle",
      name = function()
        return self:GetEnableName(E.db.TXUI.themes.gradientMode.saturationBoost.enabled, saturationGroup)
      end,
    }

    saturationGroup.shiftLight = {
      order = self:GetOrder(),
      type = "range",
      name = "亮度调整",
      desc = "控制 HSL 中 Shift 颜色的亮度值。",
      min = 0.1,
      max = 2,
      step = 0.01,
    }

    saturationGroup.shiftSat = {
      order = self:GetOrder(),
      type = "range",
      name = "饱和度调整",
      desc = "控制 HSL 中 Shift 颜色的饱和度值。",
      min = 0.1,
      max = 1,
      step = 0.01,
    }

    saturationGroup.normalLight = {
      order = self:GetOrder(),
      type = "range",
      name = "正常亮度",
      desc = "控制 HSL 中正常颜色的亮度值。",
      min = 0.1,
      max = 2,
      step = 0.01,
    }

    saturationGroup.normalSat = {
      order = self:GetOrder(),
      type = "range",
      name = "正常饱和度",
      desc = "控制 HSL 中正常颜色的饱和度值。",
      min = 0.1,
      max = 1,
      step = 0.01,
    }

    -- Spacer
    self:AddSpacer(tab)
  end
end

O:AddCallback("ToxiUI_Themes_GradientMode")
