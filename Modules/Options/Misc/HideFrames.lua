local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")
local Misc = TXUI:GetModule("Misc")

function O:Plugins_HideFrames()
  -- Create Tab
  self.options.misc.args["hideFrames"] = {
    order = self:GetOrder(),
    type = "group",
    name = "Hide Frames",
    args = {},
  }

  -- Options
  local options = self.options.misc.args["hideFrames"]["args"]
  local optionsHidden

  -- General
  do
    -- General Group
    local generalGroup = self:AddInlineRequirementsDesc(options, {
      name = "Description",
    }, {
      name = "These options allow you to completely hide some frames.\n\nOnce an option is enabled, the frame will never show until disabled again.\n\n",
    }, I.Requirements.HideFrames).args

    -- Enable
    generalGroup.enabled = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Toggling this on enables the " .. TXUI.Title .. " Hide Frames module.\n\n",
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
      name = "Retail Only",
      hidden = optionsHidden,
      disabled = retailDisabled,
    }, {
      name = "Hide Retail only frames.\n\n",
    }).args

    -- Character Group: Sync Inspect
    retailGroup.lootFrame = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "This Loot Frame automatically shows up in raids after killing a boss, or by manually typing " .. F.String.ToxiUI("/loot") .. ".",
      name = "Loot Frame",
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
