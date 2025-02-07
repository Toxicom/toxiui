local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")

function O:Reset()
  local options = self.options.reset.args

  -- Reset order for new page
  self:ResetOrder()

  -- Welcome Description
  options["generalWelcome"] = {
    order = self:GetOrder(),
    inline = true,
    type = "group",
    name = "描述",
    args = {
      ["generalWelcomeDesc"] = {
        order = self:GetOrder(),
        type = "description",
        name = "选择你想要将 " .. TXUI.Title .. " 的哪些设置 " .. F.String.Error("重置") .. " 回默认状态。",
      },
    },
  }

  -- Spacer
  self:AddSpacer(options)

  -- ToxiUI
  self:AddInlineGroup(options, {
    name = "ToxiUI",
    args = {
      ["globalResetDesc"] = {
        order = self:GetOrder(),
        type = "description",
        name = "这将仅重置 "
          .. TXUI.Title
          .. " 的设置回默认状态。这"
          .. F.String.Error("不")
          .. "包括 "
          .. F.String.ElvUI("ElvUI")
          .. "，Details，Plater 等等。\n\n",
      },
      ["resetButton"] = {
        order = self:GetOrder(),
        type = "execute",
        name = F.String.Error("所有设置"),
        desc = "重置所有 " .. TXUI.Title .. " 设置。",
        func = function()
          E:ToggleOptions()
          E:StaticPopup_Show("TXUI_RESET_TXUI_PROFILE")
        end,
      },
    },
  })

  -- Spacer
  self:AddSpacer(options)

  -- WunderBar
  self:AddInlineGroup(options, {
    name = "WunderBar",
    args = {
      ["resetButton"] = {
        order = self:GetOrder(),
        type = "execute",
        name = F.String.Error("WunderBar"),
        desc = "重置所有 " .. F.String.Error("WunderBar") .. " 设置。",
        func = function()
          E:StaticPopup_Show("TXUI_RESET_MODULE_PROFILE", "WunderBar", nil, "wunderbar")
        end,
      },
    },
  })

  -- Spacer
  self:AddSpacer(options)

  -- Plugins
  self:AddInlineGroup(options, {
    name = "插件",
    args = {
      ["armory"] = {
        order = self:GetOrder(),
        type = "execute",
        name = F.String.Error("军械库"),
        desc = "重置所有 " .. F.String.Error("军械库") .. " 设置。",
        func = function()
          E:StaticPopup_Show("TXUI_RESET_MODULE_PROFILE", "军械库", nil, "armory")
        end,
      },
      ["miniMapCoords"] = {
        order = self:GetOrder(),
        type = "execute",
        name = F.String.Error("小地图坐标"),
        desc = "重置所有 " .. F.String.Error("小地图坐标") .. " 设置。",
        func = function()
          E:StaticPopup_Show("TXUI_RESET_MODULE_PROFILE", "小地图坐标", nil, "miniMapCoords")
        end,
      },
      ["vehicleBar"] = {
        order = self:GetOrder(),
        type = "execute",
        name = F.String.Error("VehicleBar"),
        desc = "重置所有 " .. F.String.Error("VehicleBar") .. " 设置。",
        func = function()
          E:StaticPopup_Show("TXUI_RESET_MODULE_PROFILE", "VehicleBar", nil, "vehicleBar")
        end,
      },
      ["additionalScaling"] = {
        order = self:GetOrder(),
        type = "execute",
        name = F.String.Error("附加缩放"),
        desc = "重置所有 " .. F.String.Error("附加缩放") .. " 设置。",
        func = function()
          E:StaticPopup_Show("TXUI_RESET_MISC_PROFILE", "附加缩放", nil, "scaling")
        end,
      },
    },
  })
end

O:AddCallback("Reset")
