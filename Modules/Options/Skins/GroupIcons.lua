local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")

function O:Skins_GroupIcons()
  -- Create Tab
  self.options.skins.args["groupIconsGroup"] = {
    order = self:GetOrder(),
    type = "group",
    name = "组图标",
    args = {},
  }

  -- Options
  local options = self.options.skins.args["groupIconsGroup"]["args"]

  -- ElvUI Group Description
  self:AddInlineDesc(options, {
    name = "描述",
  }, {
    name = TXUI.Title .. " 添加了自定义组图标，可以在这里配置。\n",
  })

  -- Spacer
  self:AddSpacer(options)

  -- Role Icons
  do
    -- Role Icon Group
    local roleIconGroup = self:AddInlineRequirementsDesc(options, {
      name = "角色图标",
      get = function(info)
        return E.db.TXUI.elvUIIcons.roleIcons[info[#info]]
      end,
      set = function(info, value)
        E.db.TXUI.elvUIIcons.roleIcons[info[#info]] = value
        F.Event.TriggerEvent("RoleIcons.SettingsUpdate")
      end,
    }, {
      name = "将 " .. F.String.ElvUI("ElvUI") .. " 的角色图标更改为新的彩色 " .. TXUI.Title .. " 图标。\n\n"
        .. F.String.ToxiUI("信息: ") .. "有关大小和位置设置，请转到单位的 " .. F.String.Class("角色图标") .. " 设置。\n\n",
    }, I.Requirements.RoleIcons)

    -- Enable
    roleIconGroup["args"]["enabled"] = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "启用此选项将启用 " .. TXUI.Title .. " 角色图标。",
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
      name = "样式",
      desc = "更改图标",
      values = {
        ["TXUI"] = TXUI.Title .. " 彩色",
        ["TXUI_WHITE"] = TXUI.Title .. " 白色",
        ["TXUI_MATERIAL"] = TXUI.Title .. " 材质",
        ["TXUI_STYLIZED"] = TXUI.Title .. " 风格化",
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
      name = "死亡图标",
      get = function(info)
        return E.db.TXUI.elvUIIcons.deadIcons[info[#info]]
      end,
      set = function(info, value)
        E.db.TXUI.elvUIIcons.deadIcons[info[#info]] = value
        F.Event.TriggerEvent("DeadIcons.SettingsUpdate")
      end,
    }, {
      name = "为 " .. F.String.ElvUI("ElvUI") .. " 添加一个 " .. TXUI.Title .. " 的 '死亡' 指示器。\n\n",
    }, I.Requirements.RoleIcons)

    -- Enable
    deadIconGroup["args"]["enabled"] = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "启用此选项将启用 " .. TXUI.Title .. " '死亡' 图标。",
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
      name = "样式",
      desc = "更改图标",
      values = {
        ["TXUI"] = TXUI.Title,
        ["TXUI_MATERIAL"] = TXUI.Title .. " 材质",
        ["TXUI_STYLIZED"] = TXUI.Title .. " 风格化",
        ["BLIZZARD"] = "暴雪",
      },
      hidden = deadIconDisabled,
    }

    -- Size
    deadIconGroup["args"]["size"] = {
      order = self:GetOrder(),
      type = "range",
      name = "大小",
      desc = "设置图标大小。",
      min = 1,
      max = 100,
      step = 1,
      hidden = deadIconDisabled,
    }

    -- Position X
    deadIconGroup["args"]["xOffset"] = {
      order = self:GetOrder(),
      type = "range",
      name = "X 偏移",
      min = -300,
      max = 300,
      step = 1,
      hidden = deadIconDisabled,
    }

    -- Position Y
    deadIconGroup["args"]["yOffset"] = {
      order = self:GetOrder(),
      type = "range",
      name = "Y 偏移",
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
      name = "离线图标",
      get = function(info)
        return E.db.TXUI.elvUIIcons.offlineIcons[info[#info]]
      end,
      set = function(info, value)
        E.db.TXUI.elvUIIcons.offlineIcons[info[#info]] = value
        F.Event.TriggerEvent("OfflineIcons.SettingsUpdate")
      end,
    }, {
      name = "为 " .. F.String.ElvUI("ElvUI") .. " 添加一个 " .. TXUI.Title .. " 的 '离线' 指示器。\n\n",
    }, I.Requirements.RoleIcons)

    -- Enable
    offlineIconGroup["args"]["enabled"] = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "启用此选项将启用 " .. TXUI.Title .. " '离线' 图标。",
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
      name = "样式",
      desc = "更改图标",
      values = {
        ["TXUI"] = TXUI.Title,
        ["TXUI_MATERIAL"] = TXUI.Title .. " 材质",
        ["TXUI_STYLIZED"] = TXUI.Title .. " 风格化",
        ["ALERT"] = "暴雪 - '警报'",
        ["ARTHAS"] = "暴雪 - '阿尔萨斯'",
        ["PASS"] = "暴雪 - '通过'",
        ["NOTREADY"] = "暴雪 - '未准备好'",
      },
      hidden = offlineIconDisabled,
    }

    -- Size
    offlineIconGroup["args"]["size"] = {
      order = self:GetOrder(),
      type = "range",
      name = "大小",
      desc = "设置图标大小。",
      min = 1,
      max = 100,
      step = 1,
      hidden = offlineIconDisabled,
    }

    -- Position X
    offlineIconGroup["args"]["xOffset"] = {
      order = self:GetOrder(),
      type = "range",
      name = "X 偏移",
      min = -300,
      max = 300,
      step = 1,
      hidden = offlineIconDisabled,
    }

    -- Position Y
    offlineIconGroup["args"]["yOffset"] = {
      order = self:GetOrder(),
      type = "range",
      name = "Y 偏移",
      min = -300,
      max = 300,
      step = 1,
      hidden = offlineIconDisabled,
    }
  end
end

O:AddCallback("Skins_GroupIcons")
