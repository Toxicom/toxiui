local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")

function O:Skins_CooldownManager()
  -- Create Tab
  self.options.skins.args["cooldownManagerGroup"] = {
    order = self:GetOrder(),
    type = "group",
    name = "Cooldown Manager",
    args = {},
  }

  -- Options
  local options = self.options.skins.args["cooldownManagerGroup"]["args"]

  self:AddInlineDesc(options, {
    name = "Description",
  }, {
    name = TXUI.Title .. " provides additional features for " .. F.String.ToxiUI("Blizzard Cooldown Manager") .. " which can be configured here.\n\n",
  })

  -- Spacer
  self:AddSpacer(options)

  -- Fading
  do
    local fadingGroup = self:AddInlineRequirementsDesc(options, {
      name = "Fading",
    }, {
      name = "This option makes your Cooldown Manager bars "
        .. F.String.ToxiUI("(EssentialCooldownViewer, UtilityCooldownViewer)")
        .. " fade together with your Player UnitFrame.\n\n"
        .. F.String.Warning("Warning: ")
        .. "This requires a UI reload to take effect.\n\n",
    }, I.Requirements.CooldownManager).args

    fadingGroup.fading = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Enabling this makes the Cooldown Manager bars fade with the Player UnitFrame.",
      name = function()
        return self:GetEnableName(E.db.TXUI.addons.cooldownManager.fading, fadingGroup)
      end,
      get = function(_)
        return E.db.TXUI.addons.cooldownManager.fading
      end,
      set = function(_, value)
        E.db.TXUI.addons.cooldownManager.fading = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
    }
  end
end

if TXUI.IsRetail then O:AddCallback("Skins_CooldownManager") end
