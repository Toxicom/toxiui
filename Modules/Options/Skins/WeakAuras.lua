local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local O = TXUI:GetModule("Options")

function O:Skins_WeakAuras()
  -- Create Tab
  self.options.skins.args["weakAurasGroup"] = {
    order = self:GetOrder(),
    type = "group",
    name = "WeakAuras",
    get = function(info)
      return E.db.TXUI.addons[info[#info]].enabled
    end,
    set = function(info, value)
      E.db.TXUI.addons[info[#info]].enabled = value
      E:StaticPopup_Show("CONFIG_RL")
    end,
    args = {},
  }

  -- Options
  local options = self.options.skins.args["weakAurasGroup"]["args"]

  -- WeakAuras Group Description
  self:AddInlineDesc(options, {
    name = "Description",
  }, {
    name = TXUI.Title .. " provides certain additional changes to WeakAuras which can be changed here.",
  })

  -- Spacer
  self:AddSpacer(options)

  -- WeakAuras Icon Skins
  do
    -- WeakAuras Icon Skins Group
    local weakAurasIconsGroup = self:AddInlineRequirementsDesc(options, {
      name = "Icon Skins",
      get = function(info)
        return E.db.TXUI.addons.weakAurasIcons[info[#info]]
      end,
      set = function(info, value)
        E.db.TXUI.addons.weakAurasIcons[info[#info]] = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
    }, {
      name = "Makes the icons cropped, adds a border and also forces " .. F.String.ElvUI("ElvUI") .. " Cooldowns.\n\n",
    }, I.Requirements.WeakAurasIcons)

    -- WeakAuras Icon Skins Enable
    weakAurasIconsGroup["args"]["enabled"] = {
      order = self:GetOrder(),
      type = "toggle",
      name = function()
        return self:GetEnableName(E.db.TXUI.addons.weakAurasIcons.enabled, weakAurasIconsGroup)
      end,
      desc = "Toggling this on changes the shape of your WeakAuras Icons and also adds borders. It also forces " .. F.String.ElvUI("ElvUI") .. " to skin the Cooldown Text.",
    }

    -- Disabled helper
    local optionsDisabled = function()
      return self:GetEnabledState(E.db.TXUI.addons.weakAurasIcons.enabled, weakAurasIconsGroup) ~= self.enabledState.YES
    end

    -- WeakAuras Icon Skins Shape
    weakAurasIconsGroup["args"]["iconShape"] = {
      order = self:GetOrder(),
      type = "select",
      name = "Icon Shape",
      desc = "Select if the icon should be a square or a rectangle.",
      values = {
        [I.Enum.IconShape.SQUARE] = "Square",
        [I.Enum.IconShape.RECTANGLE] = "Rectangle",
      },
      disabled = optionsDisabled,
    }
  end

  -- Spacer
  self:AddSpacer(options)

  -- WeakAuras Bar Borders
  do
    -- WeakAuras Bar Borders Group
    local weakAurasBarsGroup = self:AddInlineRequirementsDesc(options, {
      name = "Bar Borders",
    }, {
      name = "Adds a border for every single WA progress bar.\n\n",
    }, I.Requirements.WeakAurasBars)

    -- WeakAuras Bar Borders Enable
    weakAurasBarsGroup["args"]["weakAurasBars"] = {
      order = self:GetOrder(),
      type = "toggle",
      name = function()
        return self:GetEnableName(E.db.TXUI.addons.weakAurasBars.enabled, weakAurasBarsGroup)
      end,
      desc = "Toggling this on draws borders for your WeakAuras Bars.",
    }
  end

  -- Spacer
  self:AddSpacer(options)
end

O:AddCallback("Skins_WeakAuras")
