local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")

function O:Skins_DamageMeter()
  -- Create Tab
  self.options.skins.args["damageMeterGroup"] = {
    order = self:GetOrder(),
    type = "group",
    name = "Damage Meter " .. E.NewSign,
    args = {},
  }

  -- Options
  local options = self.options.skins.args["damageMeterGroup"]["args"]

  self:AddInlineDesc(options, {
    name = "Description",
  }, {
    name = TXUI.Title .. " provides custom skinning for the " .. F.String.ToxiUI("Blizzard Damage Meter") .. " which can be configured here.\n\n",
  })

  -- Spacer
  self:AddSpacer(options)

  -- General
  do
    local generalGroup = self:AddInlineRequirementsDesc(options, {
      name = "General",
    }, {
      name = "Enable or disable all " .. TXUI.Title .. " skinning for the Blizzard Damage Meter.\n\n",
    }, I.Requirements.DamageMeter).args

    generalGroup.enabled = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Enable " .. TXUI.Title .. " skinning for the Blizzard Damage Meter.",
      name = function()
        return self:GetEnableName(E.db.TXUI.addons.damageMeter.enabled, generalGroup)
      end,
      get = function(_)
        return E.db.TXUI.addons.damageMeter.enabled
      end,
      set = function(_, value)
        E.db.TXUI.addons.damageMeter.enabled = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
    }
  end

  -- Spacer
  self:AddSpacer(options)

  -- Features
  do
    local featuresGroup = self:AddInlineRequirementsDesc(options, {
      name = "Features",
    }, {
      name = "Enable or disable individual features of the " .. TXUI.Title .. " Damage Meter skin.\n\n",
    }, I.Requirements.DamageMeter).args

    local isDisabled = function()
      return not TXUI:HasRequirements(I.Requirements.DamageMeter) or not E.db.TXUI.addons.damageMeter.enabled
    end

    featuresGroup.icons = {
      order = self:GetOrder(),
      type = "toggle",
      name = "Spec Icons",
      desc = "Use " .. TXUI.Title .. " spec icons instead of the default Blizzard icons.",
      disabled = isDisabled,
      get = function(_)
        return E.db.TXUI.addons.damageMeter.icons
      end,
      set = function(_, value)
        E.db.TXUI.addons.damageMeter.icons = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
    }

    featuresGroup.gradients = {
      order = self:GetOrder(),
      type = "toggle",
      name = "Gradient Bars",
      desc = "Apply gradient colors to damage meter bars.",
      disabled = isDisabled,
      get = function(_)
        return E.db.TXUI.addons.damageMeter.gradients
      end,
      set = function(_, value)
        E.db.TXUI.addons.damageMeter.gradients = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
    }

    featuresGroup.hideLocalPlayerEntry = {
      order = self:GetOrder(),
      type = "toggle",
      name = "Hide Floating Player Entry",
      desc = "Hide your own character's entry from floating over the Blizzard Damage Meter.",
      disabled = isDisabled,
      get = function(_)
        return E.db.TXUI.addons.damageMeter.hideLocalPlayerEntry
      end,
      set = function(_, value)
        E.db.TXUI.addons.damageMeter.hideLocalPlayerEntry = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
    }

    featuresGroup.resetOnNewInstance = {
      order = self:GetOrder(),
      type = "toggle",
      name = "Auto Reset",
      desc = "Automatically reset the Damage Meter when entering a new instance.\n\nThis option simply enables Blizzard's toggle for this functionality, so you don't have to set it up for every character.",
      disabled = isDisabled,
      get = function(_)
        return E.db.TXUI.addons.damageMeter.resetOnNewInstance
      end,
      set = function(_, value)
        E.db.TXUI.addons.damageMeter.resetOnNewInstance = value
        E:SetCVar("damageMeterResetOnNewInstance", value and "1" or "0")
      end,
    }
  end
end

if TXUI.IsRetail then O:AddCallback("Skins_DamageMeter") end
