local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")
local Misc = TXUI:GetModule("Misc")

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
  local optionsHidden

  -- General
  do
    -- General Group
    local generalGroup = self:AddInlineRequirementsDesc(options, {
      name = "Description",
    }, {
      name = "These options allow you to apply additional scaling to UI elements that might otherwise be a little bit too small.\n\n",
    }, I.Requirements.AdditionalScaling).args

    -- Enable
    generalGroup.enabled = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Toggling this on enables the " .. TXUI.Title .. " Additional Scaling.",
      name = function()
        return self:GetEnableName(E.db.TXUI.misc.scaling.enabled, generalGroup)
      end,
      get = function(_)
        return E.db.TXUI.misc.scaling.enabled
      end,
      set = function(_, value)
        E.db.TXUI.misc.scaling.enabled = value
        Misc:AdditionalScaling()
      end,
    }

    -- Hidden helper
    optionsHidden = function()
      return self:GetEnabledState(E.db.TXUI.misc.scaling.enabled, generalGroup) ~= self.enabledState.YES
    end
  end

  -- Spacer
  self:AddSpacer(options)

  -- Character
  do
    -- Character Group
    local characterGroup = self:AddInlineDesc(options, {
      name = "Character",
      hidden = optionsHidden,
    }, {
      name = "Scale character specific frames.\n\n",
    }).args

    -- Character Group: Character Frame
    characterGroup.characterFrame = {
      order = self:GetOrder(),
      type = "range",
      name = "Character Frame",
      get = function(_)
        return E.db.TXUI.misc.scaling.characterFrame.scale
      end,
      set = function(_, value)
        E.db.TXUI.misc.scaling.characterFrame.scale = value
        Misc:AdditionalScaling()
      end,
      min = 0.5,
      max = 2,
      step = 0.05,
    }

    -- Character Group: Dressing Room
    characterGroup.dressingRoom = {
      order = self:GetOrder(),
      type = "range",
      name = "Dressing Room",
      get = function(_)
        return E.db.TXUI.misc.scaling.dressingRoom.scale
      end,
      set = function(_, value)
        E.db.TXUI.misc.scaling.dressingRoom.scale = value
        Misc:AdditionalScaling()
      end,
      min = 0.5,
      max = 2,
      step = 0.05,
    }

    -- Character Group: Inspect Frame
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
        Misc:AdditionalScaling()
      end,
      min = 0.5,
      max = 2,
      step = 0.05,
    }

    -- Character Group: Sync Inspect
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
        Misc:AdditionalScaling()
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
      hidden = optionsHidden,
    }, {
      name = "Scale other frames.\n\n",
    }).args

    -- Other Group: Map
    otherGroup.map = {
      order = self:GetOrder(),
      type = "range",
      name = "Map",
      get = function(_)
        return E.db.TXUI.misc.scaling.map.scale
      end,
      set = function(_, value)
        E.db.TXUI.misc.scaling.map.scale = value
        Misc:AdditionalScaling()
      end,
      min = 0.5,
      max = 2,
      step = 0.05,
    }

    -- Other Group: Talents
    otherGroup.talents = {
      order = self:GetOrder(),
      type = "range",
      name = "Talents",
      get = function(_)
        return E.db.TXUI.misc.scaling.talents.scale
      end,
      set = function(_, value)
        E.db.TXUI.misc.scaling.talents.scale = value
        Misc:AdditionalScaling()
      end,
      min = 0.5,
      max = 2,
      step = 0.05,
    }
  end

  -- Spacer
  self:AddSpacer(options)

  -- Retail
  do
    -- Retail Group
    local retailGroup = self:AddInlineDesc(options, {
      name = "Retail Only",
      hidden = optionsHidden,
    }, {
      name = "Scale Retail only frames.\n\n",
    }).args

    -- Retail Group: Wardrobe
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
        Misc:AdditionalScaling()
      end,
      min = 0.5,
      max = 2,
      step = 0.05,
    }

    -- Retail Group: Collections
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
        Misc:AdditionalScaling()
      end,
      min = 0.5,
      max = 2,
      step = 0.05,
    }
  end
end

O:AddCallback("Plugins_AdditionalScaling")
