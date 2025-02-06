local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")

function O:ToxiUI_Themes_DarkMode()
  -- Create Tab
  self.options.themes.args.darkMode = {
    order = self:GetOrder(),
    type = "group",
    name = "|cffbdbdbd暗黑模式|r",
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
      name = "描述",
    }, {
      name = "我们为 " .. TXUI.Title .. " 提供了不同的主题，您可以在下面启用或禁用它们。" .. "\n\n" .. F.String.Error(
        "警告：启用这些设置之一可能会覆盖 ElvUI 和 Details 中的颜色或纹理，它们还会阻止您更改 ElvUI 中的某些设置！"
      ) .. "\n\n",
    }, I.Requirements.DarkMode).args

    -- Enable
    generalGroup.enabled = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "启用此选项将为 " .. TXUI.Title .. " 启用暗黑主题。\n\n" .. F.String.Error(
        "警告：启用此设置将覆盖 ElvUI 和 Details 中的纹理！"
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
      name = "渐变名称",
      hidden = optionsHidden,
    }, {
      name = "将单位框架名称更改为渐变颜色。\n\n",
    }, I.Requirements.DarkModeGradientName).args

    -- Gradient Toggle
    gradientGroup.toggle = {
      order = self:GetOrder(),
      type = "toggle",
      name = function()
        return self:GetEnableName(E.db.TXUI.themes.darkMode.gradientName)
      end,
      desc = "启用此选项将为 " .. TXUI.Title .. " 暗黑模式启用渐变名称",
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
      name = "Details 渐变文本",
      desc = "启用此选项将为 Details 启用渐变文本",
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
      name = "透明度",
      hidden = optionsHidden,
    }, {
      name = "更改背景透明度（alpha）。",
    }).args

    -- Dark Mode Theme Transparency Enable
    transparencyGroup.darkModeTransparency = {
      order = self:GetOrder(),
      type = "toggle",
      name = "透明度",
      desc = "启用此选项将为 " .. TXUI.Title .. " 启用暗黑主题透明度",
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
      name = "透明度 Alpha",
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
