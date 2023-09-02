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
    name = "These options allow you to apply additional scaling to UI elements that might otherwise be a little bit too small.\n\n"
      .. F.String.ToxiUI("Information: ")
      .. " Scaling will apply only after a reload.\n\n",
  })

  -- Spacer
  self:AddSpacer(options)

  -- Character
  do
    -- Character Group
    local characterGroup = self:AddInlineDesc(options, {
      name = "Character",
    }, {
      name = "Scale character specific frames.\n\n",
    }).args

    -- Character Frame
    characterGroup.characterFrame = {
      order = self:GetOrder(),
      type = "range",
      name = "Character Frame",
      get = function(_)
        return E.db.TXUI.misc.scaling.characterFrame.scale
      end,
      set = function(_, value)
        E.db.TXUI.misc.scaling.characterFrame.scale = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
      min = 0.5,
      max = 2,
      step = 0.1,
    }

    -- Inspect Frame
    characterGroup.inspectFrame = {
      order = self:GetOrder(),
      type = "range",
      name = "Inspect Frame",
      disabled = function()
        return E.db.TXUI.misc.scaling.syncInspect.enabled
      end,
      get = function(_)
        return E.db.TXUI.misc.scaling.inspectFrame.scale
      end,
      set = function(_, value)
        E.db.TXUI.misc.scaling.inspectFrame.scale = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
      min = 0.5,
      max = 2,
      step = 0.1,
    }

    -- Sync Inspect
    characterGroup.syncInspect = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Toggling this on makes your inspect frame scale have the same value as the character frame scale.",
      name = "Sync Inspect",
      get = function(_)
        return E.db.TXUI.misc.scaling.syncInspect.enabled
      end,
      set = function(_, value)
        E.db.TXUI.misc.scaling.syncInspect.enabled = value

        E:StaticPopup_Show("CONFIG_RL")
      end,
    }
  end

  -- Spacer
  self:AddSpacer(options)

  -- Other
  do
    -- Other Group
    local otherGroup = self:AddInlineDesc(options, {
      name = "Other",
    }, {
      name = "Scale other frames.\n\n",
    }).args
    -- Other Group
    otherGroup.map = {
      order = self:GetOrder(),
      type = "range",
      name = "Map",
      get = function(_)
        return E.db.TXUI.misc.scaling.map.scale
      end,
      set = function(_, value)
        E.db.TXUI.misc.scaling.map.scale = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
      min = 0.5,
      max = 2,
      step = 0.1,
    }
  end

  -- Spacer
  self:AddSpacer(options)

  -- Retail
  do
    -- Retail Group
    local retailGroup = self:AddInlineDesc(options, {
      name = "Retail Only",
    }, {
      name = "Scale retail only frames.\n\n",
    }).args
    -- Retail Group
    retailGroup.wardrobe = {
      order = self:GetOrder(),
      type = "range",
      name = "Wardrobe",
      disabled = function()
        return not TXUI.IsRetail
      end,
      get = function(_)
        return E.db.TXUI.misc.scaling.wardrobe.scale
      end,
      set = function(_, value)
        E.db.TXUI.misc.scaling.wardrobe.scale = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
      min = 0.5,
      max = 2,
      step = 0.1,
    }

    -- Additional Scaling Collections
    retailGroup.collections = {
      order = self:GetOrder(),
      type = "range",
      name = "Collections",
      disabled = function()
        return not TXUI.IsRetail
      end,
      get = function(_)
        return E.db.TXUI.misc.scaling.collections.scale
      end,
      set = function(_, value)
        E.db.TXUI.misc.scaling.collections.scale = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
      min = 0.5,
      max = 2,
      step = 0.1,
    }
  end
end

O:AddCallback("Plugins_AdditionalScaling")
