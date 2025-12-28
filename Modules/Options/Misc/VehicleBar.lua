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
    name = "VehicleBar",
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

  -- General
  do
    -- General Group
    local generalGroup = self:AddInlineRequirementsDesc(options, {
      name = "General",
    }, {
      name = "An additional Vehicle Bar that doesn't get affected by Global Fade.\n\n"
        .. F.String.Warning("Warning: ")
        .. "This feature is currently known to sometimes bug out, use it with caution.\n\n",
    }, I.Requirements.VehicleBar).args

    -- Enable
    generalGroup.enabled = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Toggling this on enables the " .. TXUI.Title .. " Vehicle Bar.",
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
  end

  self:AddSpacer(options)

  -- Buttons
  do
    -- Button Group
    local buttonGroup = self:AddInlineRequirementsDesc(options, {
      name = "Buttons",
      hidden = optionsDisabled,
    }, {
      name = "Settings for the Action Bar Buttons of the Vehicle Bar.\n\n",
    }, I.Requirements.VehicleBar).args

    buttonGroup.buttonSize = {
      order = self:GetOrder(),
      type = "range",
      name = "Button Width",
      desc = "Change the Vehicle Bar's Button width. The height will scale accordingly in a 4:3 aspect ratio.",
      get = function()
        return E.db.TXUI.vehicleBar.buttonWidth
      end,
      set = function(_, value)
        E.db.TXUI.vehicleBar.buttonWidth = value
        F.Event.TriggerEvent("VehicleBar.SettingsUpdate")
      end,
      min = 24,
      max = 64,
      step = 4,
    }

    buttonGroup.showKeybinds = {
      order = self:GetOrder(),
      type = "toggle",
      name = "Show Keybinds",
      desc = "Toggle whether to show keybinds of an action bar button on the Vehicle Bar.",
      get = function()
        return E.db.TXUI.vehicleBar.showKeybinds
      end,
      set = function(_, value)
        E.db.TXUI.vehicleBar.showKeybinds = value
        F.Event.TriggerEvent("VehicleBar.SettingsUpdate")
      end,
    }

    buttonGroup.showMacro = {
      order = self:GetOrder(),
      type = "toggle",
      name = "Show Macro Text",
      desc = "Toggle whether to show macro text of an action bar button on the Vehicle Bar.",
      get = function()
        return E.db.TXUI.vehicleBar.showMacro
      end,
      set = function(_, value)
        E.db.TXUI.vehicleBar.showMacro = value
        F.Event.TriggerEvent("VehicleBar.SettingsUpdate")
      end,
    }
  end

  self:AddSpacer(options)

  -- Vigor Bar
  do
    -- Vigor Group
    local vigorGroup = self:AddInlineRequirementsDesc(options, {
      name = "Skyriding Bar",
      hidden = optionsDisabled,
    }, {
      name = "A Skyriding bar displaying your current Skyward Ascent spell charges.\n\n",
    }, I.Requirements.VehicleBar).args

    -- Enable
    vigorGroup.enabled = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Toggling this on enables the " .. TXUI.Title .. " Skyriding Bar.",
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
    }

    local vigorDisabled = function()
      return isVehicleBarDisabled() or self:GetEnabledState(E.db.TXUI.vehicleBar.vigorBar.enabled, vigorGroup) ~= self.enabledState.YES
    end

    vigorGroup.height = {
      order = self:GetOrder(),
      type = "range",
      name = "Bar Height",
      desc = "Change the Skyriding Bar's height.",
      get = function()
        return E.db.TXUI.vehicleBar.vigorBar.height
      end,
      set = function(_, value)
        E.db.TXUI.vehicleBar.vigorBar.height = value
        F.Event.TriggerEvent("VehicleBar.SettingsUpdate")
      end,
      min = 4,
      max = 20,
      step = 1,
      disabled = vigorDisabled,
    }

    vigorGroup.normalTexture = ACH:SharedMediaStatusbar("Normal Texture", "Vigor bar texture for Normal and Gradient Mode", self:GetOrder(), 200, function()
      return E.db.TXUI.vehicleBar.vigorBar.normalTexture
    end, function(_, value)
      E.db.TXUI.vehicleBar.vigorBar.normalTexture = value
      E:StaticPopup_Show("CONFIG_RL")
    end, vigorDisabled)

    vigorGroup.darkTexture = ACH:SharedMediaStatusbar("Dark Texture", "Vigor bar texture for Dark Mode", self:GetOrder(), 200, function()
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
      name = "Animations",
      hidden = optionsDisabled,
    }, {
      name = "Vehicle Bar animations when entering or leaving a vehicle.\n\n",
    }).args

    -- Enable
    animationsGroup.animations = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Toggling this on enables the " .. TXUI.Title .. " Vehicle Bar Animations.",
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
      name = "Animation Speed",
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
