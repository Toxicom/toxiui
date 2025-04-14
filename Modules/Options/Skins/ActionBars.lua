local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")

function O:Skins_ActionBars()
  -- Create Tab
  self.options.skins.args["actionBarsGroup"] = {
    order = self:GetOrder(),
    type = "group",
    name = "Action Bars",
    args = {},
  }

  -- Options
  local options = self.options.skins.args["actionBarsGroup"]["args"]

  self:AddInlineDesc(options, {
    name = "Description",
  }, {
    name = TXUI.Title .. " provides additional features to " .. F.String.ToxiUI("Action Bars") .. " which can be configured here.",
  })

  -- Spacer
  self:AddSpacer(options)

  -- ElvUI Global Fade Persist Mode
  local actionBarsAreDisabled = E.private.actionbar.enable ~= true
  do
    -- ElvUI Global Fade Persist Group
    local elvuiFadePersistGroup = self:AddInlineRequirementsDesc(options, {
      name = "Visibility",
    }, {
      name = "This option controls your ActionBars' visibility.\n\n"
        .. F.String.ToxiUI("Information: ")
        .. "The \"Show in Vehicles\" option is disabled and has no effect if you have VehicleBar enabled or you have set the Mode to \"ElvUI Default\"!\n\n"
        .. F.String.Warning("Warning: ")
        .. "Disabling this module will still not show Action Bars, as they are also faded out in the default ElvUI settings. We recommend using one of the available dropdown options.\n\n",
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
        .. " your modifier keys "
        .. F.String.ToxiUI("(ALT, SHIFT, etc.)")
        .. " to "
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

O:AddCallback("Skins_ActionBars")
