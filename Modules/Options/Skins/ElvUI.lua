local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")

function O:Skins_ElvUI()
  -- Create Tab
  self.options.skins.args["elvuiGroup"] = {
    order = self:GetOrder(),
    type = "group",
    name = F.String.ElvUI(),
    args = {},
  }

  -- Options
  local options = self.options.skins.args["elvuiGroup"]["args"]

  -- ElvUI Group Description
  self:AddInlineDesc(options, {
    name = "Description",
  }, {
    name = TXUI.Title .. " provides additional features to " .. F.String.ElvUI("ElvUI") .. " which can be configured here.",
  })

  -- Spacer
  self:AddSpacer(options)

  -- ElvUI Theme
  do
    -- ElvUI Theme
    local elvuiTheme = self:AddInlineRequirementsDesc(options, {
      name = TXUI.Title .. " " .. F.String.ElvUI("ElvUI") .. " Skin",
      get = function(info)
        return E.db.TXUI.addons.elvUITheme[info[#info]]
      end,
      set = function(info, value)
        if E.db.TXUI.addons.elvUITheme[info[#info]] == value then return end
        E.db.TXUI.addons.elvUITheme[info[#info]] = value
        F.Event.TriggerEvent("Theme.SettingsUpdate")
      end,
    }, {
      name = "This module applies a grain background and shadows to all "
        .. F.String.ElvUI()
        .. " elements.\n\n"
        .. F.String.Warning("Warning: ")
        .. "This feature may increase your load times due to all the frames it has to skin. This should not however impact performance of the gameplay.\n\n",
    }, I.Requirements.ElvUITheme)

    -- ElvUI Theme Mode Enable
    elvuiTheme["args"]["enabled"] = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Toggling this on enables the " .. TXUI.Title .. " " .. F.String.ElvUI("ElvUI") .. " Skin.",
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
      desc = "Enable shadows for WeakAuras and most of ElvUI bars.",
      name = "Soft Shadows",
      disabled = optionsDisabled,
    }

    -- Shadow Alpha
    elvuiTheme["args"]["shadowAlpha"] = {
      order = self:GetOrder(),
      type = "range",
      name = "Shadow Opacity",
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
      name = "Shadow Size",
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

  -- ElvUI AFK Mode
  do
    -- ElvUI AFK Mode Group
    local elvuiAfkGroup = self:AddInlineDesc(options, {
      name = "AFK Mode",
      get = function(info)
        return E.db.TXUI.addons.afkMode[info[#info]]
      end,
      set = function(info, value)
        E.db.TXUI.addons.afkMode[info[#info]] = value
        F.Event.TriggerEvent("AFK.DatabaseUpdate")
      end,
    }, {
      name = "Toggling this on changes the " .. F.String.ElvUI() .. " AFK Module to have a  " .. TXUI.Title .. " skin.\n\n",
    }).args

    -- ElvUI AFK Mode Enable
    elvuiAfkGroup.enabled = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Toggling this on enables the " .. TXUI.Title .. " AFK mode.",
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
      desc = "Enabling this option will display random emotes on the Player model.",
      name = "Play Emotes",
      disabled = optionsDisabled,
    }

    -- Turn Camera while AFK
    elvuiAfkGroup.turnCamera = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Enabling this option turns the camera while the AFK Screen is active.",
      name = "Turn Camera",
      disabled = optionsDisabled,
    }

    elvuiAfkGroup.showChangelog = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Enabling this option displays the latest " .. TXUI.Title .. " changelog while the AFK screen is active.",
      name = "Show Changelog",
      disabled = optionsDisabled,
      set = function(_, value)
        E.db.TXUI.addons.afkMode.showChangelog = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
    }

    elvuiAfkGroup.showTips = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Enabling this option displays random " .. TXUI.Title .. " tips while the AFK screen is active.",
      name = "Show Tips",
      disabled = optionsDisabled,
      set = function(_, value)
        E.db.TXUI.addons.afkMode.showTips = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
    }

    elvuiAfkGroup.specIconStyle = {
      order = self:GetOrder(),
      type = "select",
      name = "Spec Icon Style",
      desc = "Choose between showing a class colored icon of your specialization, or a stylized specialization icon.",
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
      name = "Spec Icon Size",
      desc = "Change the size of the specialization icon.",
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

  -- ToxiUI Deconstruct
  if TXUI.IsRetail then
    -- Spacer
    self:AddSpacer(options)

    -- ToxiUI Deconstruct Group
    local deconstructGroup = self:AddInlineRequirementsDesc(options, {
      name = "Deconstruct",
      get = function(info)
        return E.db.TXUI.addons.deconstruct[info[#info]]
      end,
      set = function(info, value)
        E.db.TXUI.addons.deconstruct[info[#info]] = value
        F.Event.TriggerEvent("Deconstruct.SettingsUpdate")
      end,
    }, {
      name = "Button in your bags to easily deconstruct items: disenchanting, prospecting, milling..\n\n",
    }, I.Requirements.Deconstruct).args

    -- ToxiUI Deconstruct Enable
    deconstructGroup.enabled = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Toggle the " .. TXUI.Title .. " Deconstruct module.",
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
      name = "Highlight Usable",
      desc = "Highlight items in your bags that you can deconstruct.",
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
      desc = "Label items when you hover over them.",
      name = "Item Label",
      disabled = optionsDisabled,
    }

    deconstructGroup.glowEnabled = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Items glow when you hover over them.",
      name = "Item Glow",
      disabled = optionsDisabled,
    }

    deconstructGroup.glowAlpha = {
      order = self:GetOrder(),
      type = "range",
      name = "Glow Opacity",
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
      desc = "Toggling this on enables the " .. TXUI.Title .. " Deconstruct Animations.",
      name = "Animations",
      disabled = optionsDisabled,
    }

    local animationsDisabled = function()
      return optionsDisabled() or not E.db.TXUI.addons.deconstruct.animations
    end

    deconstructGroup.animationsMult = {
      order = self:GetOrder(),
      type = "range",
      name = "Animation Speed",
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

  -- Spacer
  self:AddSpacer(options)

  -- SmoothBars Toggle
  do
    -- Unit definitions by group
    local personalUnits = { "player", "target", "focus", "pet", "targettarget" }
    local groupUnits = { "party" }
    local raidUnits = { "raid1", "raid2", "raid3" }
    local allUnits = F.Table.Join(personalUnits, groupUnits, raidUnits)

    -- Display names for units
    local unitDisplayNames = {
      player = "Player",
      target = "Target",
      focus = "Focus",
      pet = "Pet",
      targettarget = "TargetTarget",
      party = "Party",
      raid1 = "Raid 1",
      raid2 = "Raid 2",
      raid3 = "Raid 3",
    }

    -- Helper to get smoothbars status
    local function getSmoothbarsStatus(unit, barType)
      local unitDB = E.db.unitframe.units[unit]
      if unitDB and unitDB[barType] then return unitDB[barType].smoothbars end
      return false
    end

    -- Helper to set smoothbars
    local function setSmoothbars(unit, barType, value)
      if not E.db.unitframe.units[unit] then return end
      if not E.db.unitframe.units[unit][barType] then E.db.unitframe.units[unit][barType] = {} end
      E.db.unitframe.units[unit][barType].smoothbars = value
    end

    -- Helper to check if all units in a group have smoothbars enabled for both health and power
    local function getGroupAllStatus(units)
      for _, unit in ipairs(units) do
        if not getSmoothbarsStatus(unit, "health") or not getSmoothbarsStatus(unit, "power") then return false end
      end
      return true
    end

    -- Helper to set all units in a group for both health and power
    local function setGroupAllSmoothbars(units, value)
      for _, unit in ipairs(units) do
        setSmoothbars(unit, "health", value)
        setSmoothbars(unit, "power", value)
      end
    end

    -- Helper to get status text
    local function getStatusText(enabled)
      if enabled then
        return F.String.Good("Enabled")
      else
        return F.String.Error("Disabled")
      end
    end

    -- Helper to create unit toggle
    local function createUnitToggle(group, unit, barType)
      local key = unit .. barType:gsub("^%l", string.upper)
      group[key] = {
        order = self:GetOrder(),
        type = "toggle",
        name = function()
          local status = getSmoothbarsStatus(unit, barType)
          return unitDisplayNames[unit] .. " " .. barType:gsub("^%l", string.upper) .. " - " .. getStatusText(status)
        end,
        desc = "Toggle smooth bars for " .. unitDisplayNames[unit] .. " " .. barType .. " bar.",
        get = function()
          return getSmoothbarsStatus(unit, barType)
        end,
        set = function(_, value)
          setSmoothbars(unit, barType, value)
        end,
      }
    end

    -- SmoothBars Group
    local smoothBarsGroup = self:AddInlineDesc(options, {
      name = "Smooth Bars " .. E.NewSign,
    }, {
      name = "Quick toggles to enable or disable smooth bar animations for health and power bars across different unit frames.\n\n"
        .. F.String.ToxiUI("Information: ")
        .. "These settings directly modify ElvUI's UnitFrame database settings. It is NOT a custom feature for smooth bars.\n\n"
        .. F.String.Warning("Warning: ")
        .. "These changes may impact performance on lower-end systems when enabled for multiple unit frames simultaneously.\n\n",
    }).args

    -- All Units Toggle Header
    smoothBarsGroup.allHeader = {
      order = self:GetOrder(),
      type = "header",
      name = "All Units",
    }

    -- All Toggle
    smoothBarsGroup.allToggle = {
      order = self:GetOrder(),
      type = "toggle",
      width = "full",
      name = function()
        local status = getGroupAllStatus(allUnits)
        return "Toggle All Smooth Bars - " .. getStatusText(status)
      end,
      desc = "Toggle smooth bars for ALL health and power bars.",
      get = function()
        return getGroupAllStatus(allUnits)
      end,
      set = function(_, value)
        setGroupAllSmoothbars(allUnits, value)
      end,
    }

    -- Personal Units Header
    smoothBarsGroup.personalHeader = {
      order = self:GetOrder(),
      type = "header",
      name = "Personal",
    }

    -- Personal All Toggle
    smoothBarsGroup.personalAllToggle = {
      order = self:GetOrder(),
      type = "toggle",
      width = "full",
      name = function()
        local status = getGroupAllStatus(personalUnits)
        return "All Personal - " .. getStatusText(status)
      end,
      desc = "Toggle smooth bars for all personal unit health and power bars.",
      get = function()
        return getGroupAllStatus(personalUnits)
      end,
      set = function(_, value)
        setGroupAllSmoothbars(personalUnits, value)
      end,
    }

    -- Individual personal unit toggles
    for _, unit in ipairs(personalUnits) do
      createUnitToggle(smoothBarsGroup, unit, "health")
      createUnitToggle(smoothBarsGroup, unit, "power")
    end

    -- Group Units Header
    smoothBarsGroup.groupHeader = {
      order = self:GetOrder(),
      type = "header",
      name = "Group",
    }

    -- Group All Toggle
    smoothBarsGroup.groupAllToggle = {
      order = self:GetOrder(),
      type = "toggle",
      width = "full",
      name = function()
        local status = getGroupAllStatus(groupUnits)
        return "All Group - " .. getStatusText(status)
      end,
      desc = "Toggle smooth bars for all group unit health and power bars.",
      get = function()
        return getGroupAllStatus(groupUnits)
      end,
      set = function(_, value)
        setGroupAllSmoothbars(groupUnits, value)
      end,
    }

    -- Individual group unit toggles
    for _, unit in ipairs(groupUnits) do
      createUnitToggle(smoothBarsGroup, unit, "health")
      createUnitToggle(smoothBarsGroup, unit, "power")
    end

    -- Raid Units Header
    smoothBarsGroup.raidHeader = {
      order = self:GetOrder(),
      type = "header",
      name = "Raid",
    }

    -- Raid All Toggle
    smoothBarsGroup.raidAllToggle = {
      order = self:GetOrder(),
      type = "toggle",
      width = "full",
      name = function()
        local status = getGroupAllStatus(raidUnits)
        return "All Raid - " .. getStatusText(status)
      end,
      desc = "Toggle smooth bars for all raid unit health and power bars.",
      get = function()
        return getGroupAllStatus(raidUnits)
      end,
      set = function(_, value)
        setGroupAllSmoothbars(raidUnits, value)
      end,
    }

    -- Individual raid unit toggles
    for _, unit in ipairs(raidUnits) do
      createUnitToggle(smoothBarsGroup, unit, "health")
      createUnitToggle(smoothBarsGroup, unit, "power")
    end
  end
end

O:AddCallback("Skins_ElvUI")
