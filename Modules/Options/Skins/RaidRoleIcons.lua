local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")

function O:Skins_RaidRoleIcons()
  -- Create Tab
  self.options.skins.args["raidRoleIconsGroup"] = {
    order = self:GetOrder(),
    type = "group",
    name = "团队角色图标",
    args = {},
  }

  -- Options
  local options = self.options.skins.args["raidRoleIconsGroup"]["args"]

  -- ElvUI Group Description
  self:AddInlineDesc(options, {
    name = "描述",
  }, {
    name = TXUI.Title
      .. " 提供自定义团队角色指示器图标，您可以在下面更改它们或恢复为暴雪默认图标。\n\n"
      .. F.String.ToxiUI("信息: ")
      .. "有关大小和位置设置，请转到单位的 "
      .. F.String.Class("团队角色指示器")
      .. " 设置。\n\n"
      .. F.String.Warning("重要: ")
      .. " 要使更改生效，您必须重新加载您的用户界面！\n",
  })

  -- Spacer
  self:AddSpacer(options)

  -- Function to generate the Raid Icon groups
  local function createIconGroup(iconType, iconName, description, enableDesc)
    -- Icon Group
    local iconGroup = self:AddInlineRequirementsDesc(options, {
      name = iconName .. " 图标",
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
      name = "样式",
      desc = "更改图标",
      values = {
        ["TXUI_MATERIAL"] = TXUI.Title .. " 材质",
        ["TXUI_STYLIZED"] = TXUI.Title .. " 风格化",
        ["BLIZZARD"] = "暴雪",
      },
      hidden = iconDisabled,
    }

    -- Spacer
    self:AddSpacer(options)
  end

  -- Call the function for each icon group
  createIconGroup("leader", "团队领袖", "更改团队领袖指示器图标。", "启用此选项将启用 " .. TXUI.Title .. " 皮肤用于团队领袖指示器")
  createIconGroup("assist", "团队助理", "更改团队助理指示器图标。", "启用此选项将启用 " .. TXUI.Title .. " 皮肤用于团队助理指示器")
  createIconGroup("looter", "拾取分配者", "更改拾取分配者指示器图标。", "启用此选项将启用 " .. TXUI.Title .. " 皮肤用于拾取分配者指示器")
  createIconGroup("mainAssist", "主助理", "更改主助理指示器图标。", "启用此选项将启用 " .. TXUI.Title .. " 皮肤用于主助理指示器")
  createIconGroup("mainTank", "主坦克", "更改主坦克指示器图标。", "启用此选项将启用 " .. TXUI.Title .. " 皮肤用于主坦克指示器")
end

O:AddCallback("Skins_RaidRoleIcons")
