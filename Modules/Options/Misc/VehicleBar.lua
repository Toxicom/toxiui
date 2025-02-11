local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")
local ACH = LibStub("LibAceConfigHelper")

function O:Plugins_VehicleBar()
  local isVehicleBarDisabled = function()
    return not E.db.TXUI.vehicleBar.enabled or not E.private.actionbar.enable
  end

  -- Create Tab
  self.options.misc.args.vehicleBar = {
    order = self:GetOrder(),
    type = "group",
    name = "载具栏 " .. E.NewSign,
    get = function(info)
      return E.db.TXUI.vehicleBar[info[#info]]
    end,
    set = function(info, value)
      E.db.TXUI.vehicleBar[info[#info]] = value
      F.Event.TriggerEvent("VehicleBar.SettingsUpdate")
    end,
    args = {},
  }

  -- Options
  local options = self.options.misc.args.vehicleBar.args
  local optionsDisabled
  local vigorDisabled

  -- General
  do
    -- General Group
    local generalGroup = self:AddInlineRequirementsDesc(options, {
      name = "常规",
    }, {
      name = "一个不受全局淡出影响的额外载具栏。\n\n" .. F.String.Warning("警告: ") .. "此功能目前已知有时会出现问题，请谨慎使用。\n\n",
    }, I.Requirements.VehicleBar).args

    -- Enable
    generalGroup.enabled = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "启用此选项将启用 " .. TXUI.Title .. " 载具栏。",
      name = function()
        return self:GetEnableName(E.db.TXUI.vehicleBar.enabled, generalGroup)
      end,
      get = function(_)
        return E.db.TXUI.vehicleBar.enabled
      end,
      set = function(_, value)
        E.db.TXUI.vehicleBar.enabled = value
        F.Event.TriggerEvent("VehicleBar.DatabaseUpdate")
      end,
    }

    optionsDisabled = function()
      return isVehicleBarDisabled() or self:GetEnabledState(E.db.TXUI.vehicleBar.enabled, generalGroup) ~= self.enabledState.YES
    end

    generalGroup.buttonSize = {
      order = self:GetOrder(),
      type = "range",
      name = "按钮宽度",
      desc = "更改载具栏的按钮宽度。高度将按 4:3 的宽高比进行缩放。",
      get = function()
        return E.db.TXUI.vehicleBar.buttonWidth
      end,
      set = function(_, value)
        E.db.TXUI.vehicleBar.buttonWidth = value
        F.Event.TriggerEvent("VehicleBar.DatabaseUpdate")
      end,
      min = 24,
      max = 64,
      step = 4,
      disabled = optionsDisabled,
    }
  end

  self:AddSpacer(options)

  -- Vigor
  do
    -- Vigor Group
    local vigorGroup = self:AddInlineRequirementsDesc(options, {
      name = "飞行条",
      hidden = optionsDisabled,
    }, {
      name = "一个显示当前活力、速度百分比以及是否激活了刺激增益的飞行条。\n\n",
    }, I.Requirements.VehicleBar).args

    -- Enable
    vigorGroup.enabled = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "启用此选项将启用 " .. TXUI.Title .. " 飞行条。",
      name = function()
        return self:GetEnableName(E.db.TXUI.vehicleBar.vigorBar.enabled, vigorGroup)
      end,
      get = function(_)
        return E.db.TXUI.vehicleBar.vigorBar.enabled
      end,
      set = function(_, value)
        E.db.TXUI.vehicleBar.vigorBar.enabled = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
      disabled = optionsDisabled,
    }

    vigorDisabled = function()
      return isVehicleBarDisabled() or self:GetEnabledState(E.db.TXUI.vehicleBar.vigorBar.enabled, vigorGroup) ~= self.enabledState.YES
    end

    vigorGroup.thrillColor = {
      order = self:GetOrder(),
      type = "color",
      name = "刺激颜色",
      desc = "当你恢复活力时，活力条速度文本的颜色。",
      hasAlpha = false,
      get = self:GetFontColorGetter("TXUI.vehicleBar.vigorBar", P.vehicleBar.vigorBar),
      set = self:GetFontColorSetter("TXUI.vehicleBar.vigorBar", function()
        F.Event.TriggerEvent("VehicleBar.DatabaseUpdate")
      end),
      disabled = vigorDisabled,
    }

    -- function ACH:SharedMediaStatusbar(name, desc, order, width, get, set, disabled, hidden)
    vigorGroup.normalTexture = ACH:SharedMediaStatusbar("普通纹理", "普通和渐变模式下的活力条纹理", self:GetOrder(), 200, function()
      return E.db.TXUI.vehicleBar.vigorBar.normalTexture
    end, function(_, value)
      E.db.TXUI.vehicleBar.vigorBar.normalTexture = value
      E:StaticPopup_Show("CONFIG_RL")
    end, vigorDisabled)

    vigorGroup.darkTexture = ACH:SharedMediaStatusbar("暗黑纹理", "暗黑模式下的活力条纹理", self:GetOrder(), 200, function()
      return E.db.TXUI.vehicleBar.vigorBar.darkTexture
    end, function(_, value)
      E.db.TXUI.vehicleBar.vigorBar.darkTexture = value
      E:StaticPopup_Show("CONFIG_RL")
    end, vigorDisabled)
  end

  -- Spacer
  self:AddSpacer(options)

  -- Animations
  do
    -- Animations Group
    local animationsGroup = self:AddInlineDesc(options, {
      name = "动画",
      hidden = optionsDisabled,
    }, {
      name = "进入或离开载具时的载具栏动画。\n\n",
    }).args

    -- Enable
    animationsGroup.animations = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "启用此选项将启用 " .. TXUI.Title .. " 载具栏动画。",
      name = function()
        return self:GetEnableName(E.db.TXUI.vehicleBar.animations)
      end,
    }

    local animationsDisabled = function()
      return not E.db.TXUI.vehicleBar.animations
    end

    -- Animation Speed
    animationsGroup.animationsMult = {
      order = self:GetOrder(),
      type = "range",
      name = "动画速度",
      min = 0.5,
      max = 2,
      step = 0.1,
      isPercent = true,
      get = function()
        return 1 / E.db.TXUI.vehicleBar.animationsMult
      end,
      set = function(_, value)
        E.db.TXUI.vehicleBar.animationsMult = 1 / value
      end,
      disabled = animationsDisabled,
    }
  end
end

O:AddCallback("Plugins_VehicleBar")
