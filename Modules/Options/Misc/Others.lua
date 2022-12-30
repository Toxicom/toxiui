local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local O = TXUI:GetModule("Options")

function O:Plugins_Others()
  -- Create Tab
  self.options.misc.args["others"] = {
    order = self:GetOrder(),
    type = "group",
    name = "Other",
    args = {},
  }

  -- Options
  local options = self.options.misc.args["others"]["args"]

  -- General Group
  self:AddInlineDesc(options, {
    name = "Description",
  }, {
    name = "Miscellaneous forgotten stuff that has no place in any category :(\n\n"
      .. F.String.ToxiUI("P.S.")
      .. " Great job on exploring all the options we offer and finding this section!\n\n",
  })

  -- Spacer
  self:AddSpacer(options)

  -- Keys Command
  do
    local keysCommandGroup = self:AddInlineRequirementsDesc(options, {
      name = TXUI.Title .. " M+ Keys Chat Command",
    }, {
      name = "This feature scans your chat and will respond to the " .. F.String.ToxiUI("!keys") .. " command by linking your current Mythic Keystone.\n\n",
    }, I.Requirements.Keys).args

    keysCommandGroup.keysCommandButton = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "This feature scans your chat and will respond to the " .. F.String.ToxiUI("!keys") .. " command by linking your current Mythic Keystone.",
      name = "@TODO: Make this actually functional",
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
  do
    -- ElvUI Global Fade Persist Group
    local elvuiFadePersistGroup = self:AddInlineRequirementsDesc(options, {
      name = "ActionBar Fade",
    }, {
      name = "This option controls your Action Bars visibility.\n\n",
    }, I.Requirements.FadePersist).args

    -- ElvUI Global Fade Persist Enable
    elvuiFadePersistGroup.elvuiFadePersist = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "This option controls when should your Action Bars appear.",
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
      return self:GetEnabledState(E.db.TXUI.addons.fadePersist.enabled, elvuiFadePersistGroup) ~= self.enabledState.YES
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

  -- Spacer
  self:AddSpacer(options)

  -- ToxiUI Game Menu Button
  do
    -- ToxiUI Game Menu Button Group
    local gameMenuButtonGroup = self:AddInlineRequirementsDesc(options, {
      name = TXUI.Title .. " Game Menu Button",
    }, {
      name = "Enabling this option shows a " .. TXUI.Title .. " button in the Game Menu (ESC).\n\n",
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
  end
end

O:AddCallback("Plugins_Others")
