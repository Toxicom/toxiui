local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")

function O:ToxiUI_Themes_DarkMode()
  -- Create Tab
  self.options.themes.args.darkMode = {
    order = self:GetOrder(),
    type = "group",
    name = "|cffbdbdbdDark Mode|r",
    get = function(info)
      return E.db.TXUI.themes.darkMode[info[#info]]
    end,
    set = function(info, value)
      E.db.TXUI.themes.darkMode[info[#info]] = value
      F.Event.TriggerEvent("ThemesDarkTransparency.SettingsUpdate")
      F.Event.TriggerEvent("SkinsDetailsDark.SettingsUpdate")
    end,
    args = {},
  }

  -- Options
  local options = self.options.themes.args.darkMode.args
  local optionsHidden

  -- General
  do
    -- General Group
    local generalGroup = self:AddInlineRequirementsDesc(options, {
      name = "Description",
    }, {
      name = "We provide different themes for " .. TXUI.Title .. ", you can enable or disable them below." .. "\n\n" .. F.String.Error(
        "Warning: Enabling one of these settings may overwrite colors or textures in ElvUI and Details, they also prevent you from changing certain settings in ElvUI!"
      ) .. "\n\n",
    }, I.Requirements.DarkMode).args

    -- Enable
    generalGroup.enabled = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Toggling this on enables the Dark theme for " .. TXUI.Title .. ".\n\n" .. F.String.Error(
        "Warning: Enabling this setting will overwrite textures in ElvUI and Details!!"
      ),
      name = function()
        return self:GetEnableName(E.db.TXUI.themes.darkMode.enabled, generalGroup)
      end,
      get = function()
        return E.db.TXUI.themes.darkMode.enabled
      end,
      set = function(_, value)
        TXUI:GetModule("Themes"):Toggle("darkMode", value)
      end,
    }

    -- Hidden helper
    optionsHidden = function()
      return self:GetEnabledState(E.db.TXUI.themes.darkMode.enabled, generalGroup) ~= self.enabledState.YES
    end
  end

  -- Spacer
  self:AddSpacer(options)

  -- Gradient Name
  do
    -- Gradient Group
    local gradientGroup = self:AddInlineRequirementsDesc(options, {
      name = "Gradient name",
      hidden = optionsHidden,
    }, {
      name = "Changes unitframe name to have gradient colors.\n\n",
    }, I.Requirements.DarkModeGradientName).args

    -- Gradient Toggle
    gradientGroup.toggle = {
      order = self:GetOrder(),
      type = "toggle",
      name = function()
        return self:GetEnableName(E.db.TXUI.themes.darkMode.gradientName)
      end,
      desc = "Toggling this on enables gradient names for " .. TXUI.Title .. " Dark Mode",
      get = function()
        return E.db.TXUI.themes.darkMode.gradientName
      end,
      set = function(_, value)
        TXUI:GetModule("Themes"):Toggle("darkModeGradientName", value)
      end,
      disabled = function()
        return not TXUI:HasRequirements(I.Requirements.DarkModeGradientName)
      end,
    }

    -- Gradient Toggle
    gradientGroup.detailsToggle = {
      order = self:GetOrder(),
      type = "toggle",
      name = "Details Gradient Text",
      desc = "Toggling this on enables gradient text for Details",
      get = function()
        return E.db.TXUI.themes.darkMode.detailsGradientText
      end,
      set = function(_, value)
        TXUI:GetModule("Themes"):Toggle("darkModeDetailsGradientText", value)
        E:StaticPopup_Show("CONFIG_RL")
      end,
      disabled = function()
        return not TXUI:HasRequirements(I.Requirements.DarkModeGradientName) or not E.db.TXUI.themes.darkMode.gradientName
      end,
    }
  end

  -- Transparency
  do
    -- Transparency Group
    local transparencyGroup = self:AddInlineDesc(options, {
      name = "Transparency",
      hidden = optionsHidden,
    }, {
      name = "Change the backdrop transparency (alpha).",
    }).args

    -- Dark Mode Theme Transparency Enable
    transparencyGroup.darkModeTransparency = {
      order = self:GetOrder(),
      type = "toggle",
      name = "Transparency",
      desc = "Toggling this on enables the Dark theme transparency for " .. TXUI.Title,
      get = function()
        return E.db.TXUI.themes.darkMode.transparency
      end,
      set = function(_, value)
        TXUI:GetModule("Themes"):Toggle("darkModeTransparency", value)
      end,
      disabled = function()
        return not TXUI:HasRequirements(I.Requirements.DarkModeTransparency)
      end,
    }

    -- Transparency Alpha Slider
    transparencyGroup.transparencyAlpha = {
      order = self:GetOrder(),
      type = "range",
      name = "Transparency Alpha",
      min = 0,
      max = 0.75,
      step = 0.01,
      disabled = function()
        return not E.db.TXUI.themes.darkMode.transparency
      end,
    }
  end
end

O:AddCallback("ToxiUI_Themes_DarkMode")
