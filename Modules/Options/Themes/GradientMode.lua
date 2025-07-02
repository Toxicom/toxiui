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
      name = "Description",
    }, {
      name = "We provide different themes for "
        .. TXUI.Title
        .. ", you can enable or disable them below."
        .. "\n\n"
        .. "Some colors (like Details dark mode gradient text) will update only after a reload."
        .. "\n\n"
        .. F.String.Error(
          "Warning: Enabling one of these settings may overwrite colors or textures in ElvUI and Details, they also prevent you from changing certain settings in ElvUI!"
        )
        .. "\n\n",
    }, I.Requirements.GradientMode).args

    -- Enable
    generalGroup.enabled = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Toggling this on enables fancy gradients for " .. TXUI.Title .. ".\n\n" .. F.String.Error(
        "Warning: Enabling this setting will overwrite textures in ElvUI and Details!!"
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
      name = "Class Colors",
    }).args

    -- Colors Group
    local colorGroup = self:AddInlineDesc(tab, {
      name = "Class Colors",
    }, {
      name = TXUI.Title
        .. " Gradient theme "
        .. F.String.Class("shifts", "MONK")
        .. " from one color to another. You can change the "
        .. F.String.Class("shifts", "MONK")
        .. " below.\n\n",
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
    local name = "NPC Colors"

    -- Tab
    local tab = self:AddGroup(options, {
      name = name,
    }).args

    -- Colors Group
    local colorGroup = self:AddInlineDesc(tab, {
      name = name,
    }, {
      name = "Here you can change the " .. F.String.Class("gradient shifts", "MONK") .. " of NPC colors.\n\n",
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
    local name = "Power Colors"

    -- Tab
    local tab = self:AddGroup(options, {
      name = name,
    }).args

    -- Power Color Group
    local colorGroup = self:AddInlineDesc(tab, {
      name = name,
    }, {
      name = "Here you can change the " .. F.String.Class("gradient shifts", "MONK") .. " of Power colors.\n\n",
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
      if TXUI.IsRetail or (TXUI.IsMists and wrathExcluded[power] == nil) then generatePowerColors(power) end
    end
  end

  -- Other Colors
  do
    -- Tab
    local tab = self:AddGroup(options, {
      name = "Other Colors",
    }).args

    -- State Group
    local stateGroup = self:AddInlineDesc(tab, {
      name = "State Colors",
    }, {
      name = "Here you can change the " .. F.String.Class("gradient shifts", "MONK") .. " of State colors.\n\n",
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
      name = "Castbar Colors",
    }, {
      name = "Here you can change the " .. F.String.Class("gradient shifts", "MONK") .. " of Castbar colors.\n\n",
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
    local name = "Settings"

    -- Tab
    local tab = self:AddGroup(options, {
      name = name,
    }).args

    -- Settings Group
    self:AddInlineDesc(tab, {
      name = name,
    }, {
      name = "Here you can change additional settings for the " .. gradientTitle .. " Mode|r.\n\n",
    })

    -- Spacer
    self:AddSpacer(tab)

    do
      local texturesGroup = self:AddInlineDesc(tab, {
        name = "UnitFrame Textures",
      }, {
        name = "Change the textures used for UnitFrame's Health, Power and Cast status bars.",
      }).args

      texturesGroup.health = ACH:SharedMediaStatusbar("Health Texture", "Health bar texture for UnitFrames", self:GetOrder(), 200, function()
        return E.db.TXUI.themes.gradientMode.textures.health
      end, function(_, value)
        E.db.TXUI.themes.gradientMode.textures.health = value
        F.Event.TriggerEvent("ThemesGradients.TexturesUpdate")
      end)

      texturesGroup.power = ACH:SharedMediaStatusbar("Power Texture", "Power bar texture for UnitFrames", self:GetOrder(), 200, function()
        return E.db.TXUI.themes.gradientMode.textures.power
      end, function(_, value)
        E.db.TXUI.themes.gradientMode.textures.power = value
        F.Event.TriggerEvent("ThemesGradients.TexturesUpdate")
      end)

      texturesGroup.cast = ACH:SharedMediaStatusbar("Castbar Texture", "Castbar texture for UnitFrames", self:GetOrder(), 200, function()
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
        name = "Background Brightness",
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
        name = "This controls the strength of the background colors.\n\nLower value means a darker background, higher value means a lighter background.\n\n",
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
        name = "Health Color Tags",
      }, {
        name = "Colors the health value of "
          .. TXUI.Title
          .. " text tags used in UnitFrames.\n\n"
          .. F.String.Error("Important: ")
          .. "This option only works for "
          .. F.String.ToxiUI("tx:health:percent")
          .. " and "
          .. F.String.ToxiUI("tx:health:percent:nosign")
          .. " tags!\n\n",
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
        name = F.String.Warning("Yellow") .. " Threshold",
        desc = "This slider determines the threshold for when the health should be colored " .. F.String.Warning("yellow"),
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
        name = F.String.Error("Red") .. " Threshold",
        desc = "This slider determines the threshold for when the health should be colored " .. F.String.Error("red"),
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
      name = "Saturation Boost",
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
      name = "Boosts the saturation and darkens " .. gradientTitle .. " Colors|r\nFor people that like it a bit more extreme\n\n",
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
      name = "Shift Lightness",
      desc = "Control the Lightness value of HSL for the Shift color.",
      min = 0.1,
      max = 2,
      step = 0.01,
    }

    saturationGroup.shiftSat = {
      order = self:GetOrder(),
      type = "range",
      name = "Shift Saturation",
      desc = "Control the Saturation value of HSL for the Shift color.",
      min = 0.1,
      max = 1,
      step = 0.01,
    }

    saturationGroup.normalLight = {
      order = self:GetOrder(),
      type = "range",
      name = "Normal Lightness",
      desc = "Control the Lightness value of HSL for the Normal color.",
      min = 0.1,
      max = 2,
      step = 0.01,
    }

    saturationGroup.normalSat = {
      order = self:GetOrder(),
      type = "range",
      name = "Normal Saturation",
      desc = "Control the Saturation value of HSL for the Normal color.",
      min = 0.1,
      max = 1,
      step = 0.01,
    }

    -- Spacer
    self:AddSpacer(tab)
  end
end

O:AddCallback("ToxiUI_Themes_GradientMode")
