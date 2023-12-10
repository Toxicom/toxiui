local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")

function O:Skins_ElvUI()
  -- Create Tab
  self.options.skins.args["elvuiGroup"] = {
    order = self:GetOrder(),
    type = "group",
    name = "ElvUI " .. E.NewSign,
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
      name = TXUI.Title .. " " .. F.String.ElvUI("ElvUI") .. " Theme",
      get = function(info)
        return E.db.TXUI.addons.elvUITheme[info[#info]]
      end,
      set = function(info, value)
        if E.db.TXUI.addons.elvUITheme[info[#info]] == value then return end
        E.db.TXUI.addons.elvUITheme[info[#info]] = value
        F.Event.TriggerEvent("Theme.SettingsUpdate")
      end,
    }, {
      name = TXUI.Title .. " " .. F.String.ElvUI() .. " Theme applies a grain background and shadows to all " .. F.String.ElvUI() .. " elements.\n\n",
    }, I.Requirements.ElvUITheme)

    -- ElvUI Theme Mode Enable
    elvuiTheme["args"]["enabled"] = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Toggling this on enables the " .. TXUI.Title .. " ElvUI Theme.",
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
    local optionsDisabled

    -- ToxiUI Game Menu Button Group
    local gameMenuButtonGroup = self:AddInlineRequirementsDesc(options, {
      name = TXUI.Title .. " Game Menu Skin",
    }, {
      name = "Enabling this option adds a " .. TXUI.Title .. " button in the Game Menu (ESC). This also adds a background with additional information.\n\n",
    }, I.Requirements.GameMenuButton).args

    -- ToxiUI Game Menu Button Enable
    gameMenuButtonGroup.gameMenuButton = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Enabling this option shows a " .. TXUI.Title .. " button in the Game Menu (ESC).",
      name = function()
        return self:GetEnableName(E.db.TXUI.addons.gameMenuButton.enabled, gameMenuButtonGroup)
      end,
      get = function(_)
        return E.db.TXUI.addons.gameMenuButton.enabled
      end,
      set = function(_, value)
        E.db.TXUI.addons.gameMenuButton.enabled = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
    }

    gameMenuButtonGroup.backgroundFade = {
      order = self:GetOrder(),
      type = "toggle",
      name = "Background Fade",
      desc = "Toggling this on fades the background when opening the Game Menu",
      get = function(_)
        return E.db.TXUI.addons.gameMenuButton.backgroundFade.enabled
      end,
      set = function(_, value)
        E.db.TXUI.addons.gameMenuButton.backgroundFade.enabled = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
    }

    optionsDisabled = function()
      return self:GetEnabledState(E.db.TXUI.addons.gameMenuButton.backgroundFade.enabled, gameMenuButtonGroup) ~= self.enabledState.YES
    end

    gameMenuButtonGroup.showInfo = {
      order = self:GetOrder(),
      disabled = optionsDisabled,
      type = "toggle",
      name = "Show Player Info",
      desc = "Toggling this on displays player information in the game menu background. Requires Background Fade enabled.",
      get = function(_)
        return E.db.TXUI.addons.gameMenuButton.backgroundFade.showInfo
      end,
      set = function(_, value)
        E.db.TXUI.addons.gameMenuButton.backgroundFade.showInfo = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
    }

    gameMenuButtonGroup.showTips = {
      order = self:GetOrder(),
      disabled = function()
        return not E.db.TXUI.addons.gameMenuButton.backgroundFade.enabled or not E.db.TXUI.addons.gameMenuButton.backgroundFade.showInfo
      end,
      type = "toggle",
      name = "Show Random Tips",
      desc = "Toggling this on displays random tips in the game menu background. Requires Show Player Info enabled.",
      get = function(_)
        return E.db.TXUI.addons.gameMenuButton.backgroundFade.showTips
      end,
      set = function(_, value)
        E.db.TXUI.addons.gameMenuButton.backgroundFade.showTips = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
    }

    gameMenuButtonGroup.classColor = {
      order = self:GetOrder(),
      disabled = optionsDisabled,
      type = "toggle",
      name = "Class Color",
      desc = "Toggling this on will enable your current class' color for the background fade",
      get = function(_)
        return E.db.TXUI.addons.gameMenuButton.backgroundFade.classColor.enabled
      end,
      set = function(_, value)
        E.db.TXUI.addons.gameMenuButton.backgroundFade.classColor.enabled = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
    }

    gameMenuButtonGroup.bgColor = {
      order = self:GetOrder(),
      disabled = optionsDisabled,
      type = "color",
      name = "Background Color",
      hasAlpha = false,
      width = 1,
      get = self:GetFontColorGetter("TXUI.addons.gameMenuButton.backgroundFade", P.addons.gameMenuButton.backgroundFade, "color"),
      set = self:GetFontColorSetter("TXUI.addons.gameMenuButton.backgroundFade", function()
        E:StaticPopup_Show("CONFIG_RL")
      end, "color"),
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
      name = "This option controls your ActionBars visibility.\n\n",
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
        F.Event.TriggerEvent("FadePersist.DatabaseUpdate")
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
  end

  -- Color Modifier Keys
  do
    local colorModifiersGroup = self:AddInlineRequirementsDesc(options, {
      name = "Color Modifier Keys",
    }, {
      name = "This option "
        .. F.String.Class("colors")
        .. " your modifier keys to "
        .. F.String.Class("class")
        .. " color.\n\nSupported modifiers: SHIFT, CTRL, ALT, NUMPAD, MOUSEBUTTON\n\n",
    }, I.Requirements.ColorModifiers).args

    colorModifiersGroup.enable = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Enabling this colors your modifier keys.",
      name = function()
        return self:GetEnableName(E.db.TXUI.addons.colorModifiers, colorModifiersGroup)
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
