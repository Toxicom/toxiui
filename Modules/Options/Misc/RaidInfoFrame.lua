local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")
local RIF = TXUI:GetModule("RaidInfoFrame")

function O:Plugins_RaidInfoFrame()
  -- Create Tab
  self.options.misc.args["raidInfo"] = {
    order = self:GetOrder(),
    type = "group",
    name = "Raid Info Frame",
    args = {},
  }

  -- Options
  local options = self.options.misc.args["raidInfo"]["args"]
  local optionsHidden

  -- Description + Enable Group
  do
    local generalGroup = self:AddInlineRequirementsDesc(options, {
      name = "Description",
    }, {
      name = TXUI.Title
        .. " provides a Raid Info Frame that shows a list of players per role in your raid."
        .. "\n\n"
        .. F.String.ToxiUI("Information: ")
        .. "You can move it in ElvUI Movers."
        .. "\n\n",
    }, I.Requirements.RaidInfoFrame).args

    -- Enable toggle
    generalGroup.enabled = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Enable the Raid Info Frame module.",
      name = function()
        return self:GetEnableName(E.db.TXUI.misc.raidInfo.enabled, generalGroup)
      end,
      get = function()
        return E.db.TXUI.misc.raidInfo.enabled
      end,
      set = function(_, value)
        E.db.TXUI.misc.raidInfo.enabled = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
    }

    -- Hidden helper
    optionsHidden = function()
      return self:GetEnabledState(E.db.TXUI.misc.raidInfo.enabled, generalGroup) ~= self.enabledState.YES
    end

    -- Show while configuring
    generalGroup.toggle = {
      order = self:GetOrder(),
      type = "execute",
      name = "Toggle Frame",
      desc = "Temporarily shows the frame even outside of a raid for easier customization.",
      func = function()
        RIF:ToggleFrame()
      end,
      disabled = optionsHidden,
    }
  end

  -- Spacer
  self:AddSpacer(options)

  -- Customization Group
  do
    local customizationGroup = self:AddInlineDesc(options, {
      name = "Customization",
      hidden = optionsHidden,
    }, {
      name = "Adjust the appearance of the Raid Info Frame.\n\n",
    }).args

    -- Size
    customizationGroup.size = {
      order = self:GetOrder(),
      type = "range",
      name = "Size",
      desc = "Set the size of the text and icons.",
      min = 8,
      max = 64,
      step = 1,
      get = function()
        return E.db.TXUI.misc.raidInfo.size
      end,
      set = function(_, value)
        E.db.TXUI.misc.raidInfo.size = value
        RIF:UpdateSize()
      end,
    }

    -- Padding
    customizationGroup.padding = {
      order = self:GetOrder(),
      type = "range",
      name = "Padding",
      desc = "Set the outside padding of the frame.",
      min = 0,
      max = 32,
      step = 1,
      get = function()
        return E.db.TXUI.misc.raidInfo.padding
      end,
      set = function(_, value)
        E.db.TXUI.misc.raidInfo.padding = value
        RIF:UpdateSpacing()
      end,
    }

    -- Spacing
    customizationGroup.spacing = {
      order = self:GetOrder(),
      type = "range",
      name = "Spacing",
      desc = "Set the spacing between icon and text.",
      min = 0,
      max = 32,
      step = 1,
      get = function()
        return E.db.TXUI.misc.raidInfo.spacing
      end,
      set = function(_, value)
        E.db.TXUI.misc.raidInfo.spacing = value
        RIF:UpdateSpacing()
      end,
    }

    -- Backdrop Color
    customizationGroup.backdropColor = {
      order = self:GetOrder(),
      type = "color",
      hasAlpha = true,
      name = "Backdrop Color",
      desc = "Set the background color of the frame.",
      get = function()
        local c = E.db.TXUI.misc.raidInfo.backdropColor
        return c.r, c.g, c.b, c.a
      end,
      set = function(_, r, g, b, a)
        local c = E.db.TXUI.misc.raidInfo.backdropColor
        c.r, c.g, c.b, c.a = r, g, b, a
        RIF:UpdateBackdrop()
      end,
    }
  end
end

O:AddCallback("Plugins_RaidInfoFrame")
