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
end

O:AddCallback("Skins_ElvUI")
