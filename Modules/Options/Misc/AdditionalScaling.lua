local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")

function O:Plugins_AdditionalScaling()
  -- Create Tab
  self.options.misc.args["additionalScaling"] = {
    order = self:GetOrder(),
    type = "group",
    name = "Additional Scaling",
    args = {},
  }

  -- Options
  local options = self.options.misc.args["additionalScaling"]["args"]

  -- General Group
  self:AddInlineDesc(options, {
    name = "Description",
  }, {
    name = "These options allow you to apply additional scaling to UI elements that might otherwise be a little bit too small.\n\n",
  })

  -- Spacer
  self:AddSpacer(options)

  -- Additional Scaling
  do
    -- Additional Scaling Group
    local additionalScalingGroup = self:AddInlineDesc(options, {
      name = "Scale",
    }, {
      name = "Scaling will apply only after a reload.\n\n",
    }).args

    -- Additional Scaling Character Frame
    additionalScalingGroup.characterFrame = {
      order = self:GetOrder(),
      type = "range",
      name = "Character Frame",
      get = function(_)
        return E.db.TXUI.addons.additionalScaling.characterFrame.scale
      end,
      set = function(_, value)
        E.db.TXUI.addons.additionalScaling.characterFrame.scale = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
      min = 0.5,
      max = 2,
      step = 0.1,
    }

    -- Additional Scaling Map
    additionalScalingGroup.map = {
      order = self:GetOrder(),
      type = "range",
      name = "Map",
      get = function(_)
        return E.db.TXUI.addons.additionalScaling.map.scale
      end,
      set = function(_, value)
        E.db.TXUI.addons.additionalScaling.map.scale = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
      min = 0.5,
      max = 2,
      step = 0.1,
    }

    -- Additional Scaling Wardrobe
    additionalScalingGroup.wardrobe = {
      order = self:GetOrder(),
      type = "range",
      name = "Wardrobe",
      disabled = function()
        return not TXUI.IsRetail
      end,
      get = function(_)
        return E.db.TXUI.addons.additionalScaling.wardrobe.scale
      end,
      set = function(_, value)
        E.db.TXUI.addons.additionalScaling.wardrobe.scale = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
      min = 0.5,
      max = 2,
      step = 0.1,
    }

    -- Additional Scaling Collections
    additionalScalingGroup.collections = {
      order = self:GetOrder(),
      type = "range",
      name = "Collections",
      disabled = function()
        return not TXUI.IsRetail
      end,
      get = function(_)
        return E.db.TXUI.addons.additionalScaling.collections.scale
      end,
      set = function(_, value)
        E.db.TXUI.addons.additionalScaling.collections.scale = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
      min = 0.5,
      max = 2,
      step = 0.1,
    }
  end
end

O:AddCallback("Plugins_AdditionalScaling")
