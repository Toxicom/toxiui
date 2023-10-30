local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")

function O:Skins_RaidRoleIcons()
  -- Create Tab
  self.options.skins.args["raidRoleIconsGroup"] = {
    order = self:GetOrder(),
    type = "group",
    name = "Raid Role Icons",
    args = {},
  }

  -- Options
  local options = self.options.skins.args["raidRoleIconsGroup"]["args"]

  -- ElvUI Group Description
  self:AddInlineDesc(options, {
    name = "Description",
  }, {
    name = TXUI.Title
      .. " provides custom icons for Raid Role Indicators, you can change them or revert back to Blizzard defaults below.\n\n"
      .. F.String.ToxiUI("Information: ")
      .. "For size and position settings, go to the unit's "
      .. F.String.Class("Raid Role Indicator")
      .. " settings.\n\n"
      .. F.String.Warning("Important:")
      .. " For changes to take effect you must reload your UI!\n",
  })

  -- Spacer
  self:AddSpacer(options)

  -- Function to generate the Raid Icon groups
  local function createIconGroup(iconType, iconName, description, enableDesc)
    -- Icon Group
    local iconGroup = self:AddInlineRequirementsDesc(options, {
      name = iconName .. " Icon",
      get = function(info)
        return E.db.TXUI.elvUIIcons.raidIcons[iconType][info[#info]]
      end,
      set = function(info, value)
        E.db.TXUI.elvUIIcons.raidIcons[iconType][info[#info]] = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
    }, {
      name = description,
    }, I.Requirements.RoleIcons)

    -- Enable
    iconGroup["args"]["enabled"] = {
      order = self:GetOrder(),
      type = "toggle",
      desc = enableDesc,
      name = function()
        return self:GetEnableName(E.db.TXUI.elvUIIcons.raidIcons[iconType].enabled, iconGroup)
      end,
      get = function(_)
        return E.db.TXUI.elvUIIcons.raidIcons[iconType].enabled
      end,
      set = function(_, value)
        E.db.TXUI.elvUIIcons.raidIcons[iconType].enabled = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
    }

    -- Hidden helper
    local iconDisabled = function()
      return self:GetEnabledState(E.db.TXUI.elvUIIcons.raidIcons[iconType].enabled, iconGroup) ~= self.enabledState.YES
    end

    -- Theme
    iconGroup["args"]["theme"] = {
      order = self:GetOrder(),
      type = "select",
      name = "Style",
      desc = "Change the icon",
      values = {
        ["TXUI_MATERIAL"] = TXUI.Title .. " Material",
        ["TXUI_STYLIZED"] = TXUI.Title .. " Stylized",
        ["BLIZZARD"] = "Blizzard",
      },
      hidden = iconDisabled,
    }

    -- Spacer
    self:AddSpacer(options)
  end

  -- Call the function for each icon group
  createIconGroup("leader", "Raid Leader", "Changes the raid leader indicator icon.", "Toggling this on enables the " .. TXUI.Title .. " skin for Raid Leader Indicator")
  createIconGroup("assist", "Raid Assist", "Changes the raid assist indicator icon.", "Toggling this on enables the " .. TXUI.Title .. " skin for Raid Assistant Indicator")
  createIconGroup("looter", "Master Looter", "Changes the master looter indicator icon.", "Toggling this on enables the " .. TXUI.Title .. " skin for Raid Master Looter Indicator")
  createIconGroup("mainAssist", "Main Assist", "Changes the main assist indicator icon.", "Toggling this on enables the " .. TXUI.Title .. " skin for Raid Main Assist Indicator")
  createIconGroup("mainTank", "Main Tank", "Changes the main tank indicator icon.", "Toggling this on enables the " .. TXUI.Title .. " skin for Raid Main Tank Indicator")
end

O:AddCallback("Skins_RaidRoleIcons")
