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
      name = "This module applies a grain background and shadows to all " .. F.String.ElvUI() .. " elements.\n\n",
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

  -- ToxiUI Game Menu Button
  do
    -- ToxiUI Game Menu Button Group
    local gameMenuSkinGroup = self:AddInlineRequirementsDesc(options, {
      name = TXUI.Title .. " Game Menu Skin",
    }, {
      name = "This module skins the Game Menu (ESC) background with additional information.\n\n",
    }, I.Requirements.GameMenuButton).args

    -- ToxiUI Game Menu Button Enable
    gameMenuSkinGroup.gameMenuSkin = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Enabling this option enables the " .. TXUI.Title .. " Game Menu (ESC) skin.",
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
      name = "Show Player Info",
      desc = "Toggling this on displays player information in the game menu background. Requires Background Fade enabled.",
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
      name = "Show Random Tips",
      desc = "Toggling this on displays random tips in the game menu background. Requires Show Player Info enabled.",
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

    gameMenuSkinGroup.classColor = {
      order = self:GetOrder(),
      type = "toggle",
      name = "Class Color",
      desc = "Toggling this on will enable your current class' color for the background fade",
      get = function(_)
        return E.db.TXUI.addons.gameMenuSkin.classColor.enabled
      end,
      set = function(_, value)
        E.db.TXUI.addons.gameMenuSkin.classColor.enabled = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
      disabled = function()
        return not E.db.TXUI.addons.gameMenuSkin.enabled
      end,
    }

    gameMenuSkinGroup.bgColor = {
      order = self:GetOrder(),
      type = "color",
      name = "Background Color",
      hasAlpha = false,
      width = 1.1,
      get = self:GetFontColorGetter("TXUI.addons.gameMenuSkin", P.addons.gameMenuSkin, "color"),
      set = self:GetFontColorSetter("TXUI.addons.gameMenuSkin", function()
        E:StaticPopup_Show("CONFIG_RL")
      end, "color"),
      disabled = function()
        return not E.db.TXUI.addons.gameMenuSkin.enabled or E.db.TXUI.addons.gameMenuSkin.classColor.enabled
      end,
    }

    gameMenuSkinGroup.specIconStyle = {
      order = self:GetOrder(),
      type = "select",
      name = "Spec Icon Style " .. E.NewSign,
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
      name = "Spec Icon Size " .. E.NewSign,
      desc = "Change the size of the specialization icon.",
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
      name = "AFK Mode",
      get = function(info)
        return E.db.TXUI.addons.afkMode[info[#info]]
      end,
      set = function(info, value)
        E.db.TXUI.addons.afkMode[info[#info]] = value
        F.Event.TriggerEvent("AFK.DatabaseUpdate")
      end,
    }, {
      name = "Toggling this on enables the " .. TXUI.Title .. " AFK mode.\n\n",
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
      name = "Show Changelog " .. E.NewSign,
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
      name = "Show Tips " .. E.NewSign,
      disabled = optionsDisabled,
      set = function(_, value)
        E.db.TXUI.addons.afkMode.showTips = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
    }

    elvuiAfkGroup.specIconStyle = {
      order = self:GetOrder(),
      type = "select",
      name = "Spec Icon Style " .. E.NewSign,
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
      name = "Spec Icon Size " .. E.NewSign,
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

  -- Spacer
  self:AddSpacer(options)

  -- ToxiUI Deconstruct
  if TXUI.IsRetail then
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

  -- ElvUI Global Fade Persist Mode
  local actionBarsAreDisabled = E.private.actionbar.enable ~= true
  do
    -- ElvUI Global Fade Persist Group
    local elvuiFadePersistGroup = self:AddInlineRequirementsDesc(options, {
      name = "ActionBars Fade",
    }, {
      name = "This option controls your ActionBars visibility.\n\n"
        .. F.String.ToxiUI("Information: ")
        .. "The \"Show in Vehicles\" option is disabled and has no effect if you have VehicleBar enabled or you have set the Mode to \"ElvUI Default\"!\n\n",
    }, I.Requirements.FadePersist).args

    -- ElvUI Global Fade Persist Enable
    elvuiFadePersistGroup.elvuiFadePersist = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "This option controls when should your ActionBars appear.",
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
      name = "Mode",
      values = {
        MOUSEOVER = "Mouseover Only",
        NO_COMBAT = "Hide in Combat",
        IN_COMBAT = "Show in Combat",
        ELVUI = "ElvUI Default",
        ALWAYS = "Show Always",
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
      name = "Show in Vehicles",
      desc = "Enabling this option will show the ActionBars in Vehicles" .. (TXUI.IsRetail and " and/or while DragonRiding" or "") .. " regardless of the Mode you've selected.",
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
      name = "Color Modifier Keys",
    }, {
      name = "This option "
        .. F.String.Class("colors")
        .. " your modifier keys to "
        .. F.String.Class("class")
        .. " color.\n\n"
        .. F.String.Warning("Warning: ")
        .. "This option also increases the ActionBars Keybind width to match the Button's width.\n\n",
    }, I.Requirements.ColorModifiers).args

    colorModifiersGroup.enable = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Enabling this colors your modifier keys.",
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
