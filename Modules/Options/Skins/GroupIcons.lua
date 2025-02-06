local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")

function O:Skins_GroupIcons()
  -- Create Tab
  self.options.skins.args["groupIconsGroup"] = {
    order = self:GetOrder(),
    type = "group",
    name = "Group Icons",
    args = {},
  }

  -- Options
  local options = self.options.skins.args["groupIconsGroup"]["args"]

  -- ElvUI Group Description
  self:AddInlineDesc(options, {
    name = "Description",
  }, {
    name = TXUI.Title .. " adds custom Group Icons which can be configured here.\n",
  })

  -- Spacer
  self:AddSpacer(options)

  -- Role Icons
  do
    -- Role Icon Group
    local roleIconGroup = self:AddInlineRequirementsDesc(options, {
      name = "Role Icons",
      get = function(info)
        return E.db.TXUI.elvUIIcons.roleIcons[info[#info]]
      end,
      set = function(info, value)
        E.db.TXUI.elvUIIcons.roleIcons[info[#info]] = value
        F.Event.TriggerEvent("RoleIcons.SettingsUpdate")
      end,
    }, {
      name = "Change the Role icons of "
        .. F.String.ElvUI("ElvUI")
        .. " to new colorful "
        .. TXUI.Title
        .. " icons.\n\n"
        .. F.String.ToxiUI("Information: ")
        .. "For size and position settings, go to the unit's "
        .. F.String.Class("Role Icon")
        .. " settings.\n\n",
    }, I.Requirements.RoleIcons)

    -- Enable
    roleIconGroup["args"]["enabled"] = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Toggling this on enables the " .. TXUI.Title .. " Role Icons.",
      name = function()
        return self:GetEnableName(E.db.TXUI.elvUIIcons.roleIcons.enabled, roleIconGroup)
      end,
      get = function(_)
        return E.db.TXUI.elvUIIcons.roleIcons.enabled
      end,
      set = function(_, value)
        E.db.TXUI.elvUIIcons.roleIcons.enabled = value
        F.Event.TriggerEvent("RoleIcons.DatabaseUpdate")
      end,
    }

    -- Hidden helper
    local roleIconDisabled = function()
      return self:GetEnabledState(E.db.TXUI.elvUIIcons.roleIcons.enabled, roleIconGroup) ~= self.enabledState.YES
    end

    -- Theme
    roleIconGroup["args"]["theme"] = {
      order = self:GetOrder(),
      type = "select",
      name = "Style",
      desc = "Change the icons",
      values = {
        ["TXUI"] = TXUI.Title .. " Colored",
        ["TXUI_WHITE"] = TXUI.Title .. " White",
        ["TXUI_MATERIAL"] = TXUI.Title .. " Material",
        ["TXUI_STYLIZED"] = TXUI.Title .. " Stylized",
      },
      hidden = roleIconDisabled,
    }
  end

  -- Spacer
  self:AddSpacer(options)

  -- Dead Icons
  do
    -- Dead Icon Group
    local deadIconGroup = self:AddInlineRequirementsDesc(options, {
      name = "Dead Icon",
      get = function(info)
        return E.db.TXUI.elvUIIcons.deadIcons[info[#info]]
      end,
      set = function(info, value)
        E.db.TXUI.elvUIIcons.deadIcons[info[#info]] = value
        F.Event.TriggerEvent("DeadIcons.SettingsUpdate")
      end,
    }, {
      name = "Adds a 'Dead' indicator to " .. F.String.ElvUI("ElvUI") .. " with " .. TXUI.Title .. " icons.\n\n",
    }, I.Requirements.RoleIcons)

    -- Enable
    deadIconGroup["args"]["enabled"] = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Toggling this on enables the " .. TXUI.Title .. " 'Dead' icon.",
      name = function()
        return self:GetEnableName(E.db.TXUI.elvUIIcons.deadIcons.enabled, deadIconGroup)
      end,
      get = function(_)
        return E.db.TXUI.elvUIIcons.deadIcons.enabled
      end,
      set = function(_, value)
        E.db.TXUI.elvUIIcons.deadIcons.enabled = value
        F.Event.TriggerEvent("DeadIcons.DatabaseUpdate")
      end,
    }

    -- Hidden helper
    local deadIconDisabled = function()
      return self:GetEnabledState(E.db.TXUI.elvUIIcons.deadIcons.enabled, deadIconGroup) ~= self.enabledState.YES
    end

    -- Theme
    deadIconGroup["args"]["theme"] = {
      order = self:GetOrder(),
      type = "select",
      name = "Style",
      desc = "Change the icon",
      values = {
        ["TXUI"] = TXUI.Title,
        ["TXUI_MATERIAL"] = TXUI.Title .. " Material",
        ["TXUI_STYLIZED"] = TXUI.Title .. " Stylized",
        ["BLIZZARD"] = "Blizzard",
      },
      hidden = deadIconDisabled,
    }

    -- Size
    deadIconGroup["args"]["size"] = {
      order = self:GetOrder(),
      type = "range",
      name = "Size",
      desc = "Set the icon size.",
      min = 1,
      max = 100,
      step = 1,
      hidden = deadIconDisabled,
    }

    -- Position X
    deadIconGroup["args"]["xOffset"] = {
      order = self:GetOrder(),
      type = "range",
      name = "X Offset",
      min = -300,
      max = 300,
      step = 1,
      hidden = deadIconDisabled,
    }

    -- Position Y
    deadIconGroup["args"]["yOffset"] = {
      order = self:GetOrder(),
      type = "range",
      name = "Y Offset",
      min = -300,
      max = 300,
      step = 1,
      hidden = deadIconDisabled,
    }
  end

  -- Spacer
  self:AddSpacer(options)

  -- Offline Icons
  do
    -- Offline Icon Group
    local offlineIconGroup = self:AddInlineRequirementsDesc(options, {
      name = "Offline Icon",
      get = function(info)
        return E.db.TXUI.elvUIIcons.offlineIcons[info[#info]]
      end,
      set = function(info, value)
        E.db.TXUI.elvUIIcons.offlineIcons[info[#info]] = value
        F.Event.TriggerEvent("OfflineIcons.SettingsUpdate")
      end,
    }, {
      name = "Adds a 'Offline' indicator to " .. F.String.ElvUI("ElvUI") .. " with " .. TXUI.Title .. " icons.\n\n",
    }, I.Requirements.RoleIcons)

    -- Enable
    offlineIconGroup["args"]["enabled"] = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Toggling this on enables the " .. TXUI.Title .. " 'Offline' icon.",
      name = function()
        return self:GetEnableName(E.db.TXUI.elvUIIcons.offlineIcons.enabled, offlineIconGroup)
      end,
      get = function(_)
        return E.db.TXUI.elvUIIcons.offlineIcons.enabled
      end,
      set = function(_, value)
        E.db.TXUI.elvUIIcons.offlineIcons.enabled = value
        F.Event.TriggerEvent("OfflineIcons.DatabaseUpdate")
      end,
    }

    -- Hidden helper
    local offlineIconDisabled = function()
      return self:GetEnabledState(E.db.TXUI.elvUIIcons.offlineIcons.enabled, offlineIconGroup) ~= self.enabledState.YES
    end

    -- Theme
    offlineIconGroup["args"]["theme"] = {
      order = self:GetOrder(),
      type = "select",
      name = "Style",
      desc = "Change the icon",
      values = {
        ["TXUI"] = TXUI.Title,
        ["TXUI_MATERIAL"] = TXUI.Title .. " Material",
        ["TXUI_STYLIZED"] = TXUI.Title .. " Stylized",
        ["ALERT"] = "Blizzard - 'Alert'",
        ["ARTHAS"] = "Blizzard - 'Arthas'",
        ["PASS"] = "Blizzard - 'Pass'",
        ["NOTREADY"] = "Blizzard - 'Not Ready'",
      },
      hidden = offlineIconDisabled,
    }

    -- Size
    offlineIconGroup["args"]["size"] = {
      order = self:GetOrder(),
      type = "range",
      name = "Size",
      desc = "Set the icon size.",
      min = 1,
      max = 100,
      step = 1,
      hidden = offlineIconDisabled,
    }

    -- Position X
    offlineIconGroup["args"]["xOffset"] = {
      order = self:GetOrder(),
      type = "range",
      name = "X Offset",
      min = -300,
      max = 300,
      step = 1,
      hidden = offlineIconDisabled,
    }

    -- Position Y
    offlineIconGroup["args"]["yOffset"] = {
      order = self:GetOrder(),
      type = "range",
      name = "Y Offset",
      min = -300,
      max = 300,
      step = 1,
      hidden = offlineIconDisabled,
    }
  end
end

O:AddCallback("Skins_GroupIcons")
