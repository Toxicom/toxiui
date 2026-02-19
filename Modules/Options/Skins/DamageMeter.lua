local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")

function O:Skins_DamageMeter()
  -- Create Tab
  self.options.skins.args["damageMeterGroup"] = {
    order = self:GetOrder(),
    type = "group",
    name = "Damage Meter " .. E.NewSign,
    args = {},
  }

  -- Options
  local options = self.options.skins.args["damageMeterGroup"]["args"]

  self:AddInlineDesc(options, {
    name = "Description",
  }, {
    name = TXUI.Title .. " provides custom skinning for the " .. F.String.ToxiUI("Blizzard Damage Meter") .. " which can be configured here.\n\n",
  })

  -- Spacer
  self:AddSpacer(options)

  -- General
  do
    local generalGroup = self:AddInlineRequirementsDesc(options, {
      name = "General",
    }, {
      name = "Enable or disable all " .. TXUI.Title .. " skinning for the Blizzard Damage Meter.\n\n",
    }, I.Requirements.DamageMeter).args

    generalGroup.enabled = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Enable " .. TXUI.Title .. " skinning for the Blizzard Damage Meter.",
      name = function()
        return self:GetEnableName(E.db.TXUI.addons.damageMeter.enabled, generalGroup)
      end,
      get = function(_)
        return E.db.TXUI.addons.damageMeter.enabled
      end,
      set = function(_, value)
        E.db.TXUI.addons.damageMeter.enabled = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
    }
  end

  -- Spacer
  self:AddSpacer(options)

  -- Icons
  do
    local iconsGroup = self:AddInlineRequirementsDesc(options, {
      name = "Spec Icons",
    }, {
      name = "Replace the default Blizzard spec icons with " .. TXUI.Title .. " styled icons.\n\n",
    }, I.Requirements.DamageMeter).args

    iconsGroup.icons = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Use " .. TXUI.Title .. " spec icons instead of the default Blizzard icons.",
      name = function()
        return self:GetEnableName(E.db.TXUI.addons.damageMeter.icons, iconsGroup)
      end,
      disabled = function()
        return not TXUI:HasRequirements(I.Requirements.DamageMeter) or not E.db.TXUI.addons.damageMeter.enabled
      end,
      get = function(_)
        return E.db.TXUI.addons.damageMeter.icons
      end,
      set = function(_, value)
        E.db.TXUI.addons.damageMeter.icons = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
    }
  end

  -- Spacer
  self:AddSpacer(options)

  -- Gradients
  do
    local gradientsGroup = self:AddInlineRequirementsDesc(options, {
      name = "Gradient Bars",
    }, {
      name = "Apply " .. TXUI.Title .. " gradient colors to the damage meter bars.\n\n",
    }, I.Requirements.DamageMeter).args

    gradientsGroup.gradients = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Apply gradient colors to damage meter bars.",
      name = function()
        return self:GetEnableName(E.db.TXUI.addons.damageMeter.gradients, gradientsGroup)
      end,
      disabled = function()
        return not TXUI:HasRequirements(I.Requirements.DamageMeter) or not E.db.TXUI.addons.damageMeter.enabled
      end,
      get = function(_)
        return E.db.TXUI.addons.damageMeter.gradients
      end,
      set = function(_, value)
        E.db.TXUI.addons.damageMeter.gradients = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
    }
  end

  -- Spacer
  self:AddSpacer(options)

  -- Header Fade
  do
    local headerFadeGroup = self:AddInlineRequirementsDesc(options, {
      name = "Header Fade",
    }, {
      name = "Fade the header (dropdowns and backdrop) based on mouse hover.\n\n",
    }, I.Requirements.DamageMeter).args

    headerFadeGroup.headerFade = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Fade the header when not hovering over the damage meter.",
      name = function()
        return self:GetEnableName(E.db.TXUI.addons.damageMeter.headerFade, headerFadeGroup)
      end,
      disabled = function()
        return not TXUI:HasRequirements(I.Requirements.DamageMeter) or not E.db.TXUI.addons.damageMeter.enabled
      end,
      get = function(_)
        return E.db.TXUI.addons.damageMeter.headerFade
      end,
      set = function(_, value)
        E.db.TXUI.addons.damageMeter.headerFade = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
    }

    headerFadeGroup.headerFadeMinAlpha = {
      order = self:GetOrder(),
      type = "range",
      name = "Minimum Alpha",
      desc = "Alpha when not hovering over the damage meter.",
      min = 0,
      max = 1,
      step = 0.05,
      disabled = function()
        return not TXUI:HasRequirements(I.Requirements.DamageMeter) or not E.db.TXUI.addons.damageMeter.enabled or not E.db.TXUI.addons.damageMeter.headerFade
      end,
      get = function(_)
        return E.db.TXUI.addons.damageMeter.headerFadeMinAlpha
      end,
      set = function(_, value)
        E.db.TXUI.addons.damageMeter.headerFadeMinAlpha = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
    }

    headerFadeGroup.headerFadeMaxAlpha = {
      order = self:GetOrder(),
      type = "range",
      name = "Maximum Alpha",
      desc = "Alpha when hovering over the damage meter.",
      min = 0,
      max = 1,
      step = 0.05,
      disabled = function()
        return not TXUI:HasRequirements(I.Requirements.DamageMeter) or not E.db.TXUI.addons.damageMeter.enabled or not E.db.TXUI.addons.damageMeter.headerFade
      end,
      get = function(_)
        return E.db.TXUI.addons.damageMeter.headerFadeMaxAlpha
      end,
      set = function(_, value)
        E.db.TXUI.addons.damageMeter.headerFadeMaxAlpha = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
    }
  end

  -- Spacer
  self:AddSpacer(options)

  -- Hide Local Player Entry
  do
    local hideLocalPlayerGroup = self:AddInlineRequirementsDesc(options, {
      name = "Hide Local Player Entry",
    }, {
      name = "Hide your own character's entry from the Blizzard Damage Meter.\n\n",
    }, I.Requirements.DamageMeter).args

    hideLocalPlayerGroup.hideLocalPlayerEntry = {
      order = self:GetOrder(),
      type = "toggle",
      name = function()
        return self:GetEnableName(E.db.TXUI.addons.damageMeter.hideLocalPlayerEntry, hideLocalPlayerGroup)
      end,
      desc = "Hide your own character's entry from the Blizzard Damage Meter.",
      disabled = function()
        return not TXUI:HasRequirements(I.Requirements.DamageMeter) or not E.db.TXUI.addons.damageMeter.enabled
      end,
      get = function(_)
        return E.db.TXUI.addons.damageMeter.hideLocalPlayerEntry
      end,
      set = function(_, value)
        E.db.TXUI.addons.damageMeter.hideLocalPlayerEntry = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
    }
  end
end

if TXUI.IsRetail then O:AddCallback("Skins_DamageMeter") end
