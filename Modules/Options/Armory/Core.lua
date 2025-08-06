local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
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
      name = "Description",
    }, {
      name = TXUI.Title .. " Armory changes the appearance of your Character sheet.\n\n",
    }, I.Requirements.Armory).args

    -- Enable
    generalGroup.enabled = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Toggling this on enables the " .. TXUI.Title .. " Armory.",
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
          return "To disable " .. TXUI.Title .. " Armory you must reload your UI.\n\n Are you sure?"
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
      name = "General",
      hidden = optionsHidden,
    }).args

    -- Avg Item Level
    do
      -- Avg Item Level Group
      local itemLevelGroup = self:AddInlineDesc(tab, {
        name = "Item Level",
        get = function(info)
          return E.db.TXUI.armory.stats[info[#info]]
        end,
        set = function(info, value)
          E.db.TXUI.armory.stats[info[#info]] = value
          F.Event.TriggerEvent("Armory.SettingsUpdate")
        end,
      }, {
        name = "Settings for Item Level in " .. TXUI.Title .. " Armory.\n\n",
      }).args

      -- Show Avg Item Level of Best Items (in Bags)
      itemLevelGroup.showAvgItemLevel = {
        order = self:GetOrder(),
        type = "toggle",
        desc = "Enabling this will show the maximum possible item level you can achieve with items currently in your bags.",
        name = "Bags iLvl",
        disabled = not TXUI.IsRetail,
      }

      -- Formats
      itemLevelGroup.itemLevelFormat = {
        order = self:GetOrder(),
        type = "select",
        name = "Format",
        desc = "Decimal format",
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
        name = "Font",
        desc = "Set the font.",
        values = self:GetAllFontsFunc(),
      }

      -- Fonts Outline
      itemLevelGroup.itemLevelFontOutline = {
        order = self:GetOrder(),
        type = "select",
        name = "Font Outline",
        desc = "Set the font outline.",
        values = self:GetAllFontOutlinesFunc(),
        disabled = function()
          return (E.db.TXUI.armory.stats["itemLevelFontShadow"] == true)
        end,
      }

      -- Fonts Size
      itemLevelGroup.itemLevelFontSize = {
        order = self:GetOrder(),
        type = "range",
        name = "Font Size",
        desc = "Set the font size.",
        min = 1,
        max = 100,
        step = 1,
      }

      -- Fonts Shadow
      itemLevelGroup.itemLevelFontShadow = {
        order = self:GetOrder(),
        type = "toggle",
        name = "Font Shadow",
        desc = "Set font drop shadow.",
      }

      -- Font color select
      itemLevelGroup.itemLevelFontColor = {
        order = self:GetOrder(),
        type = "select",
        name = "Font Color",
        values = self:GetAllFontColorsFunc {
          ["GRADIENT"] = F.String.FastGradient("Gradient", 0, 0.6, 1, 0, 0.9, 1),
          ["CLASS_GRADIENT"] = F.String.FastGradient("Class Gradient", left.r, left.g, left.b, right.r, right.g, right.b),
        },
      }

      -- Font Custom Color
      itemLevelGroup.itemLevelFontCustomColor = {
        order = self:GetOrder(),
        type = "color",
        name = "Custom Color",
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
        name = "Animations",
      }, {
        name = "Armory animations when opening the Character sheet.\n\n",
      }).args

      -- Enable
      animationsGroup.animations = {
        order = self:GetOrder(),
        type = "toggle",
        desc = "Toggling this on enables the " .. TXUI.Title .. " Armory Animations.",
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
        name = "Animation Speed",
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
        name = "Background",
        get = function(info)
          return E.db.TXUI.armory.background[info[#info]]
        end,
        set = function(info, value)
          E.db.TXUI.armory.background[info[#info]] = value
          F.Event.TriggerEvent("Armory.SettingsUpdate")
        end,
      }, {
        name = "Settings for the custom " .. TXUI.Title .. " Armory background.\n\n",
      }).args

      -- Enable
      backgroundGroup.enabled = {
        order = self:GetOrder(),
        type = "toggle",
        desc = "Toggling this on enables the " .. TXUI.Title .. " Armory background.",
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
        name = "Alpha",
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
        name = "Style",
        desc = "Change the Background image.",
        values = {
          [1] = "1. Priory of the Sacred Flame",
          [2] = "2. Azj-Kahet",
          [3] = "3. Draenor",
        },
        disabled = function()
          return E.db.TXUI.armory.background.class or optionsDisabled()
        end,
      }

      backgroundGroup.class = {
        order = self:GetOrder(),
        type = "toggle",
        name = "Class Background",
        desc = "Use class specific backgrounds.",
        disabled = optionsDisabled,
        width = 1.2,
      }

      backgroundGroup.hideControls = {
        order = self:GetOrder(),
        type = "toggle",
        name = "Hide controls",
        desc = "Hides the camera controls when hovering the character model.",
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
        name = "Decorative Lines",
        get = function(info)
          return E.db.TXUI.armory.lines[info[#info]]
        end,
        set = function(info, value)
          E.db.TXUI.armory.lines[info[#info]] = value
          F.Event.TriggerEvent("Armory.SettingsUpdate")
        end,
      }, {
        name = "Settings for the custom " .. TXUI.Title .. " Armory decorative lines.\n\n",
      }).args

      -- Enable
      linesGroup.enabled = {
        order = self:GetOrder(),
        type = "toggle",
        desc = "Toggling this on enables the " .. TXUI.Title .. " Armory decorative lines.",
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
        name = "Alpha",
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
        name = "Line Height",
        min = 1,
        max = 5,
        step = 1,
        disabled = optionsDisabled,
      }

      linesGroup.color = {
        order = self:GetOrder(),
        type = "select",
        name = "Line Color",
        values = {
          CLASS = F.String.Class("Class"),
          GRADIENT = F.String.GradientClass("Gradient Class"),
        },
        disabled = optionsDisabled,
      }
    end
  end

  -- Title
  do
    -- Tab
    local tab = self:AddGroup(options, {
      name = "Header",
      hidden = optionsHidden,
    }).args

    -- Name Text
    do
      -- Font Group
      local fontGroup = self:AddInlineGroup(tab, {
        name = "Name Text",
      }).args

      -- Fonts Font
      fontGroup.nameTextFont = {
        order = self:GetOrder(),
        type = "select",
        dialogControl = "LSM30_Font",
        name = "Font",
        desc = "Set the font.",
        values = self:GetAllFontsFunc(),
      }

      -- Fonts Outline
      fontGroup.nameTextFontOutline = {
        order = self:GetOrder(),
        type = "select",
        name = "Font Outline",
        desc = "Set the font outline.",
        values = self:GetAllFontOutlinesFunc(),
        disabled = function()
          return (E.db.TXUI.armory["nameTextFontShadow"] == true)
        end,
      }

      -- Fonts Size
      fontGroup.nameTextFontSize = {
        order = self:GetOrder(),
        type = "range",
        name = "Font Size",
        desc = "Set the font size.",
        min = 1,
        max = 42,
        step = 1,
      }

      -- Fonts Shadow
      fontGroup.nameTextFontShadow = {
        order = self:GetOrder(),
        type = "toggle",
        name = "Font Shadow",
        desc = "Set font drop shadow.",
      }

      -- Font color select
      fontGroup.nameTextFontColor = {
        order = self:GetOrder(),
        type = "select",
        name = "Font Color",
        values = self:GetAllFontColorsFunc {
          ["GRADIENT"] = F.String.FastGradient("Gradient", 0, 0.6, 1, 0, 0.9, 1),
          ["CLASS_GRADIENT"] = F.String.FastGradient("Class Gradient", left.r, left.g, left.b, right.r, right.g, right.b),
        },
      }

      -- Font Custom Color
      fontGroup.nameTextFontCustomColor = {
        order = self:GetOrder(),
        type = "color",
        name = "Custom Color",
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
        name = "X Offset",
        min = -100,
        max = 100,
        step = 1,
      }

      -- Position Y
      fontGroup.nameTextOffsetY = {
        order = self:GetOrder(),
        type = "range",
        name = "Y Offset",
        min = -100,
        max = 100,
        step = 1,
      }
    end

    -- Title Text
    do
      -- Font Group
      local fontGroup = self:AddInlineGroup(tab, {
        name = "Title Text",
      }).args

      -- Fonts Font
      fontGroup.titleTextFont = {
        order = self:GetOrder(),
        type = "select",
        dialogControl = "LSM30_Font",
        name = "Font",
        desc = "Set the font.",
        values = self:GetAllFontsFunc(),
      }

      -- Fonts Outline
      fontGroup.titleTextFontOutline = {
        order = self:GetOrder(),
        type = "select",
        name = "Font Outline",
        desc = "Set the font outline.",
        values = self:GetAllFontOutlinesFunc(),
        disabled = function()
          return (E.db.TXUI.armory["titleTextFontShadow"] == true)
        end,
      }

      -- Fonts Size
      fontGroup.titleTextFontSize = {
        order = self:GetOrder(),
        type = "range",
        name = "Font Size",
        desc = "Set the font size.",
        min = 1,
        max = 42,
        step = 1,
      }

      -- Fonts Shadow
      fontGroup.titleTextFontShadow = {
        order = self:GetOrder(),
        type = "toggle",
        name = "Font Shadow",
        desc = "Set font drop shadow.",
      }

      -- Font color select
      fontGroup.titleTextFontColor = {
        order = self:GetOrder(),
        type = "select",
        name = "Font Color",
        values = self:GetAllFontColorsFunc {
          ["GRADIENT"] = F.String.FastGradient("Gradient", 0, 0.6, 1, 0, 0.9, 1),
          ["CLASS_GRADIENT"] = F.String.FastGradient("Class Gradient", left.r, left.g, left.b, right.r, right.g, right.b),
        },
      }

      -- Font Custom Color
      fontGroup.titleTextFontCustomColor = {
        order = self:GetOrder(),
        type = "color",
        name = "Custom Color",
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
        name = "X Offset",
        min = -100,
        max = 100,
        step = 1,
      }

      -- Position Y
      fontGroup.titleTextOffsetY = {
        order = self:GetOrder(),
        type = "range",
        name = "Y Offset",
        min = -100,
        max = 100,
        step = 1,
      }
    end

    -- Level Title Text
    do
      -- Font Group
      local fontGroup = self:AddInlineGroup(tab, {
        name = "Level Label",
      }).args

      -- Fonts Font
      fontGroup.levelTitleTextFont = {
        order = self:GetOrder(),
        type = "select",
        dialogControl = "LSM30_Font",
        name = "Font",
        desc = "Set the font.",
        values = self:GetAllFontsFunc(),
      }

      -- Fonts Outline
      fontGroup.levelTitleTextFontOutline = {
        order = self:GetOrder(),
        type = "select",
        name = "Font Outline",
        desc = "Set the font outline.",
        values = self:GetAllFontOutlinesFunc(),
        disabled = function()
          return (E.db.TXUI.armory["levelTitleTextFontShadow"] == true)
        end,
      }

      -- Fonts Size
      fontGroup.levelTitleTextFontSize = {
        order = self:GetOrder(),
        type = "range",
        name = "Font Size",
        desc = "Set the font size.",
        min = 1,
        max = 42,
        step = 1,
      }

      -- Fonts Shadow
      fontGroup.levelTitleTextFontShadow = {
        order = self:GetOrder(),
        type = "toggle",
        name = "Font Shadow",
        desc = "Set font drop shadow.",
      }

      -- Font color select
      fontGroup.levelTitleTextFontColor = {
        order = self:GetOrder(),
        type = "select",
        name = "Font Color",
        values = self:GetAllFontColorsFunc(),
      }

      -- Font Custom Color
      fontGroup.levelTitleTextFontCustomColor = {
        order = self:GetOrder(),
        type = "color",
        name = "Custom Color",
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
        name = "Abbreviate Label",
        desc = "Abbreviate the 'Level' text to 'Lv'.",
      }

      -- Spacer
      self:AddSpacer(fontGroup)

      -- Position X
      fontGroup.levelTitleTextOffsetX = {
        order = self:GetOrder(),
        type = "range",
        name = "X Offset",
        min = -100,
        max = 100,
        step = 1,
      }

      -- Position Y
      fontGroup.levelTitleTextOffsetY = {
        order = self:GetOrder(),
        type = "range",
        name = "Y Offset",
        min = -100,
        max = 100,
        step = 1,
      }
    end

    -- Level Text
    do
      -- Font Group
      local fontGroup = self:AddInlineGroup(tab, {
        name = "Level Value",
      }).args

      -- Fonts Font
      fontGroup.levelTextFont = {
        order = self:GetOrder(),
        type = "select",
        dialogControl = "LSM30_Font",
        name = "Font",
        desc = "Set the font.",
        values = self:GetAllFontsFunc(),
      }

      -- Fonts Outline
      fontGroup.levelTextFontOutline = {
        order = self:GetOrder(),
        type = "select",
        name = "Font Outline",
        desc = "Set the font outline.",
        values = self:GetAllFontOutlinesFunc(),
        disabled = function()
          return (E.db.TXUI.armory["levelTextFontShadow"] == true)
        end,
      }

      -- Fonts Size
      fontGroup.levelTextFontSize = {
        order = self:GetOrder(),
        type = "range",
        name = "Font Size",
        desc = "Set the font size.",
        min = 1,
        max = 42,
        step = 1,
      }

      -- Fonts Shadow
      fontGroup.levelTextFontShadow = {
        order = self:GetOrder(),
        type = "toggle",
        name = "Font Shadow",
        desc = "Set font drop shadow.",
      }

      -- Font color select
      fontGroup.levelTextFontColor = {
        order = self:GetOrder(),
        type = "select",
        name = "Font Color",
        values = self:GetAllFontColorsFunc(),
      }

      -- Font Custom Color
      fontGroup.levelTextFontCustomColor = {
        order = self:GetOrder(),
        type = "color",
        name = "Custom Color",
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
        name = "X Offset",
        min = -100,
        max = 100,
        step = 1,
      }

      -- Position Y
      fontGroup.levelTextOffsetY = {
        order = self:GetOrder(),
        type = "range",
        name = "Y Offset",
        min = -100,
        max = 100,
        step = 1,
      }
    end

    -- Class Text
    do
      -- Font Group
      local fontGroup = self:AddInlineGroup(tab, {
        name = "Class Text",
      }).args

      -- Fonts Font
      fontGroup.classTextFont = {
        order = self:GetOrder(),
        type = "select",
        dialogControl = "LSM30_Font",
        name = "Font",
        desc = "Set the font.",
        values = self:GetAllFontsFunc(),
      }

      -- Fonts Outline
      fontGroup.classTextFontOutline = {
        order = self:GetOrder(),
        type = "select",
        name = "Font Outline",
        desc = "Set the font outline.",
        values = self:GetAllFontOutlinesFunc(),
        disabled = function()
          return (E.db.TXUI.armory["classTextFontShadow"] == true)
        end,
      }

      -- Fonts Size
      fontGroup.classTextFontSize = {
        order = self:GetOrder(),
        type = "range",
        name = "Font Size",
        desc = "Set the font size.",
        min = 1,
        max = 42,
        step = 1,
      }

      -- Fonts Shadow
      fontGroup.classTextFontShadow = {
        order = self:GetOrder(),
        type = "toggle",
        name = "Font Shadow",
        desc = "Set font drop shadow.",
      }

      -- Font color select
      fontGroup.classTextFontColor = {
        order = self:GetOrder(),
        type = "select",
        name = "Font Color",
        values = self:GetAllFontColorsFunc {
          ["GRADIENT"] = F.String.FastGradient("Gradient", 0, 0.6, 1, 0, 0.9, 1),
        },
      }

      -- Font Custom Color
      fontGroup.classTextFontCustomColor = {
        order = self:GetOrder(),
        type = "color",
        name = "Custom Color",
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
        name = "X Offset",
        min = -100,
        max = 100,
        step = 1,
      }

      -- Position Y
      fontGroup.classTextOffsetY = {
        order = self:GetOrder(),
        type = "range",
        name = "Y Offset",
        min = -100,
        max = 100,
        step = 1,
      }
    end

    -- Spec Icon
    do
      -- Font Group
      local fontGroup = self:AddInlineGroup(tab, {
        name = "Spec Icon",
      }).args

      -- Fonts Outline
      fontGroup.specIconFontOutline = {
        order = self:GetOrder(),
        type = "select",
        name = "Font Outline",
        desc = "Set the font outline.",
        values = self:GetAllFontOutlinesFunc(),
        disabled = function()
          return (E.db.TXUI.armory["specIconFontShadow"] == true)
        end,
      }

      -- Fonts Size
      fontGroup.specIconFontSize = {
        order = self:GetOrder(),
        type = "range",
        name = "Font Size",
        desc = "Set the font size.",
        min = 1,
        max = 42,
        step = 1,
      }

      -- Fonts Shadow
      fontGroup.specIconFontShadow = {
        order = self:GetOrder(),
        type = "toggle",
        name = "Font Shadow",
        desc = "Set font drop shadow.",
      }

      -- Font color select
      fontGroup.specIconFontColor = {
        order = self:GetOrder(),
        type = "select",
        name = "Font Color",
        values = self:GetAllFontColorsFunc {
          ["GRADIENT"] = F.String.FastGradient("Gradient", 0, 0.6, 1, 0, 0.9, 1),
        },
      }

      -- Font Custom Color
      fontGroup.specIconFontCustomColor = {
        order = self:GetOrder(),
        type = "color",
        name = "Custom Color",
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
      name = "Item Slot",
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
        name = "Item Quality Gradient",
      }, {
        name = "Settings for the color coming out of your item slot.\n\n",
      }).args

      -- Enable
      gradientGroup.itemQualityGradientEnabled = {
        order = self:GetOrder(),
        type = "toggle",
        desc = "Toggling this on enables the Item Quality bars.",
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
        name = "Width",
        min = 10,
        max = 120,
        step = 1,
        disabled = optionsDisabled,
      }

      -- Gradient Height
      gradientGroup.itemQualityGradientHeight = {
        order = self:GetOrder(),
        type = "range",
        name = "Height",
        min = 1,
        max = 40,
        step = 1,
        disabled = optionsDisabled,
      }

      -- Start Alpha
      gradientGroup.itemQualityGradientStartAlpha = {
        order = self:GetOrder(),
        type = "range",
        name = "Start Alpha",
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
        name = "End Alpha",
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
        name = "Enchant & Socket Strings",
      }, {
        name = "Settings for strings displaying enchant and socket info about your item.\n\n",
      }).args

      -- Enable
      enchantGroup.enchantTextEnabled = {
        order = self:GetOrder(),
        type = "toggle",
        desc = "Toggling this on enables the " .. TXUI.Title .. " Armory Enchant strings.",
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
        desc = "Shows a warning when you're missing an enchant.",
        name = "Missing Enchants",
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

          return "Shows a warning when you're missing sockets on your necklace." .. (socketItem and (" Sockets can be added with " .. F.String.ToxiUI(socketItem)) or "")
        end,
        name = "Missing Sockets",
        hidden = not TXUI.IsRetail,
        disabled = optionsDisabled,
      }

      -- Abbreviate Enchant
      enchantGroup.abbreviateEnchantText = {
        order = self:GetOrder(),
        type = "toggle",
        desc = "Abbreviates the enchant strings.",
        name = "Short Enchants",
        disabled = optionsDisabled,
      }

      enchantGroup.useEnchantClassColor = {
        order = self:GetOrder(),
        type = "toggle",
        desc = "Use class color for the enchant strings.",
        name = "Class Color",
        disabled = optionsDisabled,
      }

      enchantGroup.moveSockets = {
        order = self:GetOrder(),
        type = "toggle",
        name = "Move Sockets",
        desc = "Crops and moves sockets above enchant text.",
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
        name = "Font",
        desc = "Set the font.",
        values = self:GetAllFontsFunc(),
        disabled = optionsDisabled,
      }

      -- Fonts Outline
      enchantGroup.enchantFontOutline = {
        order = self:GetOrder(),
        type = "select",
        name = "Font Outline",
        desc = "Set the font outline.",
        values = self:GetAllFontOutlinesFunc(),
        disabled = function()
          return (self:GetEnabledState(E.db.TXUI.armory.pageInfo.enchantTextEnabled) ~= self.enabledState.YES) or (E.db.TXUI.armory.pageInfo["enchantFontShadow"] == true)
        end,
      }

      -- Fonts Size
      enchantGroup.enchantFontSize = {
        order = self:GetOrder(),
        type = "range",
        name = "Font Size",
        desc = "Set the font size.",
        min = 1,
        max = 42,
        step = 1,
        disabled = optionsDisabled,
      }

      -- Fonts Shadow
      enchantGroup.enchantFontShadow = {
        order = self:GetOrder(),
        type = "toggle",
        name = "Font Shadow",
        desc = "Set font drop shadow.",
        disabled = optionsDisabled,
      }
    end

    -- Spacer
    self:AddSpacer(tab)

    -- Item Level
    do
      -- Item Level Group
      local itemLevelGroup = self:AddInlineDesc(tab, {
        name = "Item Level",
      }, {
        name = "Settings for Item level next to your item slots.\n\n",
      }).args

      -- Enable
      itemLevelGroup.itemLevelTextEnabled = {
        order = self:GetOrder(),
        type = "toggle",
        desc = "Toggle Item level display.",
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
        desc = "Toggle sockets & azerite traits.",
        name = "Sockets",
        disabled = optionsDisabled,
      }

      -- Spacer
      self:AddSpacer(itemLevelGroup)

      -- Fonts Font
      itemLevelGroup.iLvLFont = {
        order = self:GetOrder(),
        type = "select",
        dialogControl = "LSM30_Font",
        name = "Font",
        desc = "Set the font.",
        values = self:GetAllFontsFunc(),
        disabled = optionsDisabled,
      }

      -- Fonts Outline
      itemLevelGroup.iLvLFontOutline = {
        order = self:GetOrder(),
        type = "select",
        name = "Font Outline",
        desc = "Set the font outline.",
        values = self:GetAllFontOutlinesFunc(),
        disabled = function()
          return (self:GetEnabledState(E.db.TXUI.armory.pageInfo.itemLevelTextEnabled) ~= self.enabledState.YES) or (E.db.TXUI.armory.pageInfo["iLvLFontShadow"] == true)
        end,
      }

      -- Fonts Size
      itemLevelGroup.iLvLFontSize = {
        order = self:GetOrder(),
        type = "range",
        name = "Font Size",
        desc = "Set the font size.",
        min = 1,
        max = 42,
        step = 1,
        disabled = optionsDisabled,
      }

      -- Fonts Shadow
      itemLevelGroup.iLvLFontShadow = {
        order = self:GetOrder(),
        type = "toggle",
        name = "Font Shadow",
        desc = "Set font drop shadow.",
        disabled = optionsDisabled,
      }
    end
  end

  -- Stats
  if TXUI.IsRetail then
    -- Tab
    local tab = self:AddGroup(options, {
      name = "Attributes",
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
        name = "Background Bars",
      }).args

      -- Enable
      backgroundGroup.alternatingBackgroundEnabled = {
        order = self:GetOrder(),
        type = "toggle",
        desc = "Toggles the blue bars behind every second number.",
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
        name = "Alpha",
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
        name = "Category Header",
      }).args

      -- Fonts Font
      fontGroup.headerFont = {
        order = self:GetOrder(),
        type = "select",
        dialogControl = "LSM30_Font",
        name = "Font",
        desc = "Set the font.",
        values = self:GetAllFontsFunc(),
      }

      -- Fonts Outline
      fontGroup.headerFontOutline = {
        order = self:GetOrder(),
        type = "select",
        name = "Font Outline",
        desc = "Set the font outline.",
        values = self:GetAllFontOutlinesFunc(),
        disabled = function()
          return (E.db.TXUI.armory.stats["headerFontShadow"] == true)
        end,
      }

      -- Fonts Size
      fontGroup.headerFontSize = {
        order = self:GetOrder(),
        type = "range",
        name = "Font Size",
        desc = "Set the font size.",
        min = 1,
        max = 42,
        step = 1,
      }

      -- Fonts Shadow
      fontGroup.headerFontShadow = {
        order = self:GetOrder(),
        type = "toggle",
        name = "Font Shadow",
        desc = "Set font drop shadow.",
      }

      -- Font color select
      fontGroup.headerFontColor = {
        order = self:GetOrder(),
        type = "select",
        name = "Font Color",
        values = self:GetAllFontColorsFunc {
          ["GRADIENT"] = F.String.FastGradient("Gradient", 0, 0.6, 1, 0, 0.9, 1),
          ["CLASS_GRADIENT"] = F.String.FastGradient("Class Gradient", left.r, left.g, left.b, right.r, right.g, right.b),
        },
      }

      -- Font Custom Color
      fontGroup.headerFontCustomColor = {
        order = self:GetOrder(),
        type = "color",
        name = "Custom Color",
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
        name = "Attribute Label",
      }).args

      -- Fonts Font
      fontGroup.labelFont = {
        order = self:GetOrder(),
        type = "select",
        dialogControl = "LSM30_Font",
        name = "Font",
        desc = "Set the font.",
        values = self:GetAllFontsFunc(),
      }

      -- Fonts Outline
      fontGroup.labelFontOutline = {
        order = self:GetOrder(),
        type = "select",
        name = "Font Outline",
        desc = "Set the font outline.",
        values = self:GetAllFontOutlinesFunc(),
        disabled = function()
          return (E.db.TXUI.armory.stats["labelFontShadow"] == true)
        end,
      }

      -- Fonts Size
      fontGroup.labelFontSize = {
        order = self:GetOrder(),
        type = "range",
        name = "Font Size",
        desc = "Set the font size.",
        min = 1,
        max = 42,
        step = 1,
      }

      -- Fonts Shadow
      fontGroup.labelFontShadow = {
        order = self:GetOrder(),
        type = "toggle",
        name = "Font Shadow",
        desc = "Set font drop shadow.",
      }

      -- Font color select
      fontGroup.labelFontColor = {
        order = self:GetOrder(),
        type = "select",
        name = "Font Color",
        values = self:GetAllFontColorsFunc {
          ["GRADIENT"] = F.String.FastGradient("Gradient", 0, 0.6, 1, 0, 0.9, 1),
          ["CLASS_GRADIENT"] = F.String.FastGradient("Class Gradient", left.r, left.g, left.b, right.r, right.g, right.b),
        },
      }

      -- Font Custom Color
      fontGroup.labelFontCustomColor = {
        order = self:GetOrder(),
        type = "color",
        name = "Custom Color",
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
        name = "Short Labels",
        desc = "Shorten and abbreviate attribute labels.",
      }
    end

    self:AddSpacer(tab)

    -- Icon Text
    do
      -- Font Group
      local fontGroup = self:AddInlineDesc(tab, {
        name = "Attribute Icons",
      }, {
        name = "Show icons before the attribute labels. Only the main attributes are supported currently.\n\n",
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
        name = "Font Outline",
        desc = "Set the font outline.",
        values = self:GetAllFontOutlinesFunc(),
        disabled = function()
          return (E.db.TXUI.armory.stats["iconFontShadow"] == true)
        end,
      }

      -- Fonts Size
      fontGroup.iconFontSize = {
        order = self:GetOrder(),
        type = "range",
        name = "Font Size",
        desc = "Set the font size.",
        min = 1,
        max = 42,
        step = 1,
      }

      -- Fonts Shadow
      fontGroup.iconFontShadow = {
        order = self:GetOrder(),
        type = "toggle",
        name = "Font Shadow",
        desc = "Set font drop shadow.",
      }

      -- Font color select
      fontGroup.iconFontColor = {
        order = self:GetOrder(),
        type = "select",
        name = "Font Color",
        values = self:GetAllFontColorsFunc(),
      }

      -- Font Custom Color
      fontGroup.iconFontCustomColor = {
        order = self:GetOrder(),
        type = "color",
        name = "Custom Color",
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
        name = "Attribute Value",
      }).args

      -- Fonts Font
      fontGroup.valueFont = {
        order = self:GetOrder(),
        type = "select",
        dialogControl = "LSM30_Font",
        name = "Font",
        desc = "Set the font.",
        values = self:GetAllFontsFunc(),
      }

      -- Fonts Outline
      fontGroup.valueFontOutline = {
        order = self:GetOrder(),
        type = "select",
        name = "Font Outline",
        desc = "Set the font outline.",
        values = self:GetAllFontOutlinesFunc(),
        disabled = function()
          return (E.db.TXUI.armory.stats["valueFontShadow"] == true)
        end,
      }

      -- Fonts Size
      fontGroup.valueFontSize = {
        order = self:GetOrder(),
        type = "range",
        name = "Font Size",
        desc = "Set the font size.",
        min = 1,
        max = 42,
        step = 1,
      }

      -- Fonts Shadow
      fontGroup.valueFontShadow = {
        order = self:GetOrder(),
        type = "toggle",
        name = "Font Shadow",
        desc = "Set font drop shadow.",
      }

      -- Font color select
      fontGroup.valueFontColor = {
        order = self:GetOrder(),
        type = "select",
        name = "Font Color",
        values = self:GetAllFontColorsFunc {
          ["GRADIENT"] = F.String.FastGradient("Gradient", 0, 0.6, 1, 0, 0.9, 1),
        },
      }

      -- Font Custom Color
      fontGroup.valueFontCustomColor = {
        order = self:GetOrder(),
        type = "color",
        name = "Custom Color",
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
        name = "Attribute Visibility",
      }).args

      -- Mode
      for stat, _ in pairs(P.armory.stats.mode) do
        statsGroup[stat] = {
          order = self:GetOrder(),
          type = "select",
          name = F.String.LowercaseEnum(stat),
          values = {
            [0] = "Hide",
            [1] = "Show Only Relevant",
            [2] = "Show Above 0",
            [3] = "Always Show",
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
    name = "Description",
  }, {
    name = "Unfortunately this feature is available only for the Retail version of "
      .. TXUI.Title
      .. ".\n\n"
      .. "For "
      .. F.String.ToxiUI("Mists of Pandaria: Classic")
      .. " we recommend using "
      .. F.String.ReforgedArmory()
      .. " by "
      .. F.String.Class("Repooc", "DRUID")
      .. ".\n\n",
  }).args

  group.websiteUrl = {
    order = self:GetOrder(),
    type = "input",
    width = "full",
    name = "Copy this URL",
    get = function()
      return I.Strings.Branding.Links.ReforgedArmory
    end,
  }
end

if TXUI.IsRetail then
  O:AddCallback("Armory")
else
  O:AddCallback("Armory_OnlyRetailMessage")
end
