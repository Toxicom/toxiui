local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")

local pairs = pairs

local ReloadUI = ReloadUI

function O:Performance()
  local options = self.options.performance.args
  local M = TXUI:GetModule("Misc")
  local settingsMap = M:GetPerformanceSettingsMap()

  -- Reset order for new page
  self:ResetOrder()

  -- Description
  self:AddInlineDesc(options, {
    name = "Description",
  }, {
    name = "Performance Mode disables "
      .. TXUI.Title
      .. " features to reduce resource usage.\n\n"
      .. "When "
      .. F.String.Good("enabled")
      .. ", all currently active features are saved and then disabled.\n"
      .. "When "
      .. F.String.Error("disabled")
      .. ", your previously saved features are restored.\n\n",
  })

  -- Spacer
  self:AddSpacer(options)

  -- Status & Toggle
  do
    local statusGroup = self:AddInlineGroup(options, {
      name = "Performance Mode",
    }).args

    -- Current status
    statusGroup["status"] = {
      order = self:GetOrder(),
      type = "description",
      name = function()
        if E.db.TXUI.performance.enabled then
          return "Status: " .. F.String.Good("Active") .. "\n\n"
        else
          return "Status: " .. F.String.Error("Inactive") .. "\n\n"
        end
      end,
      fontSize = "medium",
    }

    -- Toggle button
    statusGroup["toggle"] = {
      order = self:GetOrder(),
      type = "execute",
      name = function()
        if E.db.TXUI.performance.enabled then
          return F.String.Error("Disable") .. " Performance Mode"
        else
          return F.String.Good("Enable") .. " Performance Mode"
        end
      end,
      desc = function()
        if E.db.TXUI.performance.enabled then
          return "Restore your saved features and disable Performance Mode."
        else
          return "Save currently enabled features, disable them, and activate Performance Mode."
        end
      end,
      func = function()
        M:PerformanceToggle()
        ReloadUI()
      end,
    }
  end

  -- Spacer
  self:AddSpacer(options)

  -- Saved Features (only shown when performance mode is active)
  do
    local savedGroup = self:AddInlineDesc(options, {
      name = "Saved Features",
      hidden = function()
        return not E.db.TXUI.performance.enabled
      end,
    }, {
      name = "These features were enabled before Performance Mode was activated. They will be restored when you disable Performance Mode.\n\n"
        .. F.String.GoodIconSpaced()
        .. F.String.Good("Saved")
        .. " - will be restored\n"
        .. F.String.ErrorIconSpaced()
        .. F.String.Silver("Was already disabled")
        .. "\n\n",
    }).args

    for id, entry in pairs(settingsMap) do
      savedGroup["saved_" .. id] = {
        order = self:GetOrder(),
        type = "description",
        hidden = function()
          return not E.db.TXUI.performance.enabled
        end,
        name = function()
          if E.db.TXUI.performance.savedSettings[id] then
            return F.String.GoodIconSpaced() .. entry.name .. "\n"
          else
            return F.String.ErrorIconSpaced() .. F.String.Silver(entry.name) .. "\n"
          end
        end,
      }
    end
  end

  -- Spacer
  self:AddSpacer(options)

  -- Feature List (only shown when performance mode is inactive)
  do
    local previewGroup = self:AddInlineDesc(options, {
      name = "Features",
      hidden = function()
        return E.db.TXUI.performance.enabled
      end,
    }, {
      name = "These features will be affected when Performance Mode is enabled.\n\n"
        .. F.String.GoodIconSpaced()
        .. F.String.Good("Enabled")
        .. " - will be disabled\n"
        .. F.String.ErrorIconSpaced()
        .. F.String.Silver("Already disabled")
        .. "\n\n",
    }).args

    for id, entry in pairs(settingsMap) do
      previewGroup["preview_" .. id] = {
        order = self:GetOrder(),
        type = "description",
        hidden = function()
          return E.db.TXUI.performance.enabled
        end,
        name = function()
          local parent = F.GetDBFromPath(entry.path)
          if parent and parent[entry.key] == true then
            return F.String.GoodIconSpaced() .. entry.name .. "\n"
          else
            return F.String.ErrorIconSpaced() .. F.String.Silver(entry.name) .. "\n"
          end
        end,
      }
    end
  end
end

O:AddCallback("Performance")
