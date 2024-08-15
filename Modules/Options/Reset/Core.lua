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
    name = "Description",
    args = {
      ["generalWelcomeDesc"] = {
        order = self:GetOrder(),
        type = "description",
        name = "Choose which settings of " .. TXUI.Title .. " you want to " .. F.String.Error("reset") .. " back to their default state.",
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
        name = "This will reset only "
          .. TXUI.Title
          .. " settings back to their default state. That does "
          .. F.String.Error("NOT")
          .. " include "
          .. F.String.ElvUI("ElvUI")
          .. ", Details, Plater and so on..\n\n",
      },
      ["resetButton"] = {
        order = self:GetOrder(),
        type = "execute",
        name = F.String.Error("All Settings"),
        desc = "Reset all " .. TXUI.Title .. " Settings.",
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
        desc = "Reset all " .. F.String.Error("WunderBar") .. " Settings.",
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
    name = "Plugins",
    args = {
      ["armory"] = {
        order = self:GetOrder(),
        type = "execute",
        name = F.String.Error("Armory"),
        desc = "Reset all " .. F.String.Error("Armory") .. " settings.",
        func = function()
          E:StaticPopup_Show("TXUI_RESET_MODULE_PROFILE", "Armory", nil, "armory")
        end,
      },
      ["miniMapCoords"] = {
        order = self:GetOrder(),
        type = "execute",
        name = F.String.Error("Minimap Coordinates"),
        desc = "Reset all " .. F.String.Error("Minimap Coordinates") .. "settings.",
        func = function()
          E:StaticPopup_Show("TXUI_RESET_MODULE_PROFILE", "MiniMapCoords", nil, "miniMapCoords")
        end,
      },
      ["vehicleBar"] = {
        order = self:GetOrder(),
        type = "execute",
        name = F.String.Error("VehicleBar"),
        desc = "Reset all " .. F.String.Error("VehicleBar") .. " settings.",
        func = function()
          E:StaticPopup_Show("TXUI_RESET_MODULE_PROFILE", "VehicleBar", nil, "vehicleBar")
        end,
      },
      ["additionalScaling"] = {
        order = self:GetOrder(),
        type = "execute",
        name = F.String.Error("Additional Scaling"),
        desc = "Reset all " .. F.String.Error("Additional Scaling") .. " settings.",
        func = function()
          E:StaticPopup_Show("TXUI_RESET_MISC_PROFILE", "Additional Scaling", nil, "scaling")
        end,
      },
    },
  })
end

O:AddCallback("Reset")
