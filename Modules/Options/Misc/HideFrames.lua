local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")
local Misc = TXUI:GetModule("Misc")

function O:Plugins_HideFrames()
  -- Create Tab
  self.options.misc.args["hideFrames"] = {
    order = self:GetOrder(),
    type = "group",
    name = "隐藏框体",
    args = {},
  }

  -- Options
  local options = self.options.misc.args["hideFrames"]["args"]
  local optionsHidden

  -- General
  do
    -- General Group
    local generalGroup = self:AddInlineRequirementsDesc(options, {
      name = "描述",
    }, {
      name = "这些选项允许您完全隐藏某些框体。\n\n一旦启用选项，框体将不会显示，直到再次禁用。\n\n",
    }, I.Requirements.HideFrames).args

    -- Enable
    generalGroup.enabled = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "启用此选项将启用 " .. TXUI.Title .. " 隐藏框体模块。\n\n",
      name = function()
        return self:GetEnableName(E.db.TXUI.misc.hide.enabled, generalGroup)
      end,
      get = function(_)
        return E.db.TXUI.misc.hide.enabled
      end,
      set = function(_, value)
        E.db.TXUI.misc.hide.enabled = value
        if value then
          Misc:HideFrames()
        else
          E:StaticPopup_Show("CONFIG_RL")
        end
      end,
    }

    -- Hidden helper
    optionsHidden = function()
      return self:GetEnabledState(E.db.TXUI.misc.hide.enabled, generalGroup) ~= self.enabledState.YES
    end
  end

  -- Spacer
  self:AddSpacer(options)

  local retailDisabled = function()
    return not TXUI.IsRetail
  end

  -- Retail
  do
    -- Character Group
    local retailGroup = self:AddInlineDesc(options, {
      name = "仅限正式服",
      hidden = optionsHidden,
      disabled = retailDisabled,
    }, {
      name = "隐藏仅限正式服的框体。\n\n",
    }).args

    -- Character Group: Sync Inspect
    retailGroup.lootFrame = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "此战利品框体会在团队副本击败首领后自动显示，或通过手动输入 " .. F.String.ToxiUI("/loot") .. " 显示。",
      name = "战利品框体",
      get = function(_)
        return E.db.TXUI.misc.hide.lootFrame
      end,
      set = function(_, value)
        E.db.TXUI.misc.hide.lootFrame = value
        Misc:HideFrames()
      end,
    }
  end
end

O:AddCallback("Plugins_HideFrames")
