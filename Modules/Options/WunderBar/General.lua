local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")
local ACH = LibStub("LibAceConfigHelper")

function O:WunderBar_General()
  -- Options
  local options = self.options.wunderbar.args["general"]["args"]
  local optionsHidden

  -- Wunderbar Group Description
  do
    -- Wunderbar Description Group
    local wunderBarDesc = self:AddInlineRequirementsDesc(options, {
      name = "Description",
    }, {
      name = F.String.Menu.WunderBar() .. " - a full replacement for old XIV Databar. Displays important information and offers buttons for easier life.\n\n",
    }, I.Requirements.WunderBar)

    -- Wunderbar Description Enable Toggle
    wunderBarDesc["args"]["enabled"] = {
      order = self:GetOrder(),
      type = "toggle",
      name = function()
        return self:GetEnableName(E.db.TXUI.wunderbar.general.enabled, wunderBarDesc)
      end,
      set = function(info, value)
        E.db.TXUI.wunderbar.general[info[#info]] = value
        TXUI:GetModule("WunderBar"):DatabaseUpdate()
      end,
    }

    -- Hidden helper
    optionsHidden = function()
      return self:GetEnabledState(E.db.TXUI.wunderbar.general.enabled, wunderBarDesc) ~= self.enabledState.YES
    end
  end

  -- Spacer
  self:AddSpacer(options)

  -- General
  do
    -- General Group
    local generalGroup = self:AddInlineGroup(options, {
      name = "General",
      hidden = optionsHidden,
    })

    -- No combat click
    generalGroup["args"]["noCombatClick"] = {
      order = self:GetOrder(),
      type = "toggle",
      name = "Block Combat Click",
      desc = "Blocks all click events while in combat.",
    }

    -- No combat hover
    generalGroup["args"]["noCombatHover"] = {
      order = self:GetOrder(),
      type = "toggle",
      name = "Block Combat Tooltip",
      desc = "Blocks datatext tooltip from showing in combat.",
    }

    -- No hover
    generalGroup["args"]["noHover"] = {
      order = self:GetOrder(),
      type = "toggle",
      name = "Always Hide Tooltips",
      desc = "Blocks datatext tooltips from showing.\n\n" .. F.String.Error("Warning: This also disables 'hover' colors."),
    }

    -- Spacer
    self:AddSpacer(generalGroup["args"])

    -- Position
    generalGroup["args"]["position"] = {
      order = self:GetOrder(),
      type = "select",
      name = "Position",
      desc = "Choose whether to display the " .. F.String.Menu.WunderBar() .. " at the top or bottom of the screen.",
      values = {
        TOP = "Top",
        BOTTOM = "Bottom",
      },
      set = function(_, value)
        E.db.TXUI.wunderbar.general.position = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
    }

    -- Visibility
    generalGroup["args"]["barVisibility"] = {
      order = self:GetOrder(),
      type = "select",
      name = "Visibility",
      values = {
        ALWAYS = "Always",
        NO_COMBAT = "Hide in Combat",
        RESTING = "Only in rested area",
        RESTING_AND_MOUSEOVER = "Resting & Mouseover",
      },
    }

    -- Mouseover Only
    generalGroup["args"]["barMouseOverOnly"] = {
      order = self:GetOrder(),
      type = "toggle",
      name = "Mouseover Only",
      desc = "Show the bar only on mouseover.",
      disabled = function()
        return (E.db.TXUI.wunderbar.general.barVisibility == "RESTING_AND_MOUSEOVER")
      end,
    }

    -- Spacer
    self:AddSpacer(generalGroup["args"])

    -- Height
    generalGroup["args"]["barHeight"] = {
      order = self:GetOrder(),
      type = "range",
      name = "Height",
      min = 1,
      max = 200,
      step = 1,
    }

    -- Height
    generalGroup["args"]["barWidth"] = {
      order = self:GetOrder(),
      type = "range",
      name = "Width",
      min = 1,
      max = E.physicalWidth,
      step = 1,
    }

    -- Spacing
    generalGroup["args"]["barSpacing"] = {
      order = self:GetOrder(),
      type = "range",
      name = "Spacing",
      desc = "Amount of spacing that " .. F.String.Menu.WunderBar() .. " should be offset from each side of the screen.",
      min = 1,
      max = 100,
      step = 1,
    }
  end

  -- Spacer
  self:AddSpacer(options)

  -- Font
  do
    -- Font Group
    local fontGroup = self:AddInlineGroup(options, {
      name = "Font",
      hidden = optionsHidden,
    })

    -- Fonts Font
    fontGroup["args"]["normalFont"] = {
      order = self:GetOrder(),
      type = "select",
      dialogControl = "LSM30_Font",
      name = "Font",
      desc = "Set the font.",
      values = self:GetAllFontsFunc(),
    }

    -- Fonts Outline
    fontGroup["args"]["normalFontOutline"] = {
      order = self:GetOrder(),
      type = "select",
      name = "Font Outline",
      desc = "Set the font outline.",
      values = self:GetAllFontOutlinesFunc(),
      disabled = function()
        return (E.db.TXUI.wunderbar.general["normalFontShadow"] == true)
      end,
    }

    -- Fonts Size
    fontGroup["args"]["normalFontSize"] = {
      order = self:GetOrder(),
      type = "range",
      name = "Font Size",
      desc = "Set the font size.",
      min = 1,
      max = 100,
      step = 1,
    }

    -- Fonts Shadow
    fontGroup["args"]["normalFontShadow"] = {
      order = self:GetOrder(),
      type = "toggle",
      name = "Font Shadow",
      desc = "Set font drop shadow.",
    }
  end

  -- Spacer
  self:AddSpacer(options)

  -- Color
  do
    -- Color Group
    local colorGroup = self:AddInlineGroup(options, {
      name = "Color",
      hidden = optionsHidden,
    })

    -- Background color select
    colorGroup["args"]["backgroundColor"] = {
      order = self:GetOrder(),
      type = "select",
      name = "Background Color",
      values = self:GetAllFontColorsFunc {
        RGB = F.String.Legendary("LEGENDARY: ") .. "|cffff0000R|r|cff00ff00G|r|cff0000ffB|r ",
      } or self:GetAllFontColorsFunc(),
    }

    -- Background Custom Color
    colorGroup["args"]["backgroundCustomColor"] = {
      order = self:GetOrder(),
      type = "color",
      name = "Custom Color",
      hasAlpha = true,
      get = self:GetFontColorGetter("TXUI.wunderbar.general", P.wunderbar.general),
      set = self:GetFontColorSetter("TXUI.wunderbar.general", function()
        TXUI:GetModule("WunderBar"):UpdateBar()
      end),
      hidden = function()
        return E.db.TXUI.wunderbar.general.backgroundColor ~= "CUSTOM"
      end,
    }

    -- Spacer
    self:AddSpacer(colorGroup["args"])

    -- Accent color select
    colorGroup["args"]["accentFontColor"] = {
      order = self:GetOrder(),
      type = "select",
      name = "Accent Color",
      values = self:GetAllFontColorsFunc(),
    }

    -- Accent Custom Color
    colorGroup["args"]["accentFontCustomColor"] = {
      order = self:GetOrder(),
      type = "color",
      name = "Custom Color",
      hasAlpha = true,
      get = self:GetFontColorGetter("TXUI.wunderbar.general", P.wunderbar.general),
      set = self:GetFontColorSetter("TXUI.wunderbar.general", function()
        TXUI:GetModule("WunderBar"):UpdateBar()
      end),
      hidden = function()
        return E.db.TXUI.wunderbar.general.accentFontColor ~= "CUSTOM"
      end,
    }

    -- Spacer
    self:AddSpacer(colorGroup["args"])

    -- Icon color select
    colorGroup["args"]["iconFontColor"] = {
      order = self:GetOrder(),
      type = "select",
      name = "Icon Color",
      values = self:GetAllFontColorsFunc(),
    }

    -- Icon Custom Color
    colorGroup["args"]["iconFontCustomColor"] = {
      order = self:GetOrder(),
      type = "color",
      name = "Custom Color",
      hasAlpha = true,
      get = self:GetFontColorGetter("TXUI.wunderbar.general", P.wunderbar.general),
      set = self:GetFontColorSetter("TXUI.wunderbar.general", function()
        TXUI:GetModule("WunderBar"):UpdateBar()
      end),
      hidden = function()
        return E.db.TXUI.wunderbar.general.iconFontColor ~= "CUSTOM"
      end,
    }

    -- Spacer
    self:AddSpacer(colorGroup["args"])

    -- Font color select
    colorGroup["args"]["normalFontColor"] = {
      order = self:GetOrder(),
      type = "select",
      name = "Font Color",
      values = self:GetAllFontColorsFunc(),
    }

    -- Font Custom Color
    colorGroup["args"]["normalFontCustomColor"] = {
      order = self:GetOrder(),
      type = "color",
      name = "Custom Color",
      hasAlpha = true,
      get = self:GetFontColorGetter("TXUI.wunderbar.general", P.wunderbar.general),
      set = self:GetFontColorSetter("TXUI.wunderbar.general", function()
        TXUI:GetModule("WunderBar"):UpdateBar()
      end),
      hidden = function()
        return E.db.TXUI.wunderbar.general.normalFontColor ~= "CUSTOM"
      end,
    }
  end

  -- Spacer
  self:AddSpacer(options)

  -- Animation
  do
    -- Animation Group
    local animationsGroup = self:AddInlineGroup(options, {
      name = "Animation",
      hidden = optionsHidden,
    })

    -- Animations Enable Toggle
    animationsGroup["args"]["animations"] = {
      order = self:GetOrder(),
      type = "toggle",
      name = function()
        return self:GetEnableName(E.db.TXUI.wunderbar.general.animations)
      end,
    }

    -- Disabled helper
    local animationsDisabled = function()
      return self:GetEnabledState(E.db.TXUI.wunderbar.general.animations) ~= self.enabledState.YES
    end

    -- Animate on Events Toggle
    animationsGroup["args"]["animationsEvents"] = {
      order = self:GetOrder(),
      type = "toggle",
      name = "Animate on Events",
      desc = "Plays a short animation when a SubModule recives an Event",
      disabled = animationsDisabled,
    }

    -- Animate on Events Toggle
    animationsGroup["args"]["animationsMult"] = {
      order = self:GetOrder(),
      type = "range",
      name = "Animation Speed",
      min = 0.5,
      max = 2,
      step = 0.1,
      isPercent = true,
      disabled = animationsDisabled,
      get = function()
        return 1 / E.db.TXUI.wunderbar.general.animationsMult
      end,
      set = function(_, value)
        E.db.TXUI.wunderbar.general.animationsMult = 1 / value
      end,
    }
  end

  -- Spacer
  self:AddSpacer(options)

  -- Background
  do
    -- Background Group
    local backgroundGroup = self:AddInlineGroup(options, {
      name = "Background",
      hidden = optionsHidden,
    })

    backgroundGroup["args"]["backgroundTexture"] = ACH:SharedMediaStatusbar("Background Texture", nil, self:GetOrder())

    -- Background Fade Toggle
    backgroundGroup["args"]["backgroundGradient"] = {
      order = self:GetOrder(),
      type = "toggle",
      name = "Background Fade",
      desc = "Fades the background near the top out.",
    }

    -- Background Fade Range
    backgroundGroup["args"]["backgroundGradientAlpha"] = {
      order = self:GetOrder(),
      type = "range",
      name = "Fade Strength",
      min = 0,
      max = 1,
      step = 0.01,
      disabled = function()
        return not E.db.TXUI.wunderbar.general.backgroundGradient
      end,
    }
  end

  self:AddSpacer(options)

  -- Flyout Backdrop
  do
    local flyoutGroup = self:AddInlineDesc(options, {
      name = "Flyouts",
      hidden = optionsHidden,
    }, {
      name = "Control the " .. F.String.Menu.WunderBar() .. " flyouts that show up in Profession and Hearthstone modules.\n\n",
    }).args

    flyoutGroup["enabled"] = {
      order = self:GetOrder(),
      type = "toggle",
      name = function()
        return self:GetEnableName(E.db.TXUI.wunderbar.general.flyoutBackdrop.enabled)
      end,
      get = function(info)
        return E.db.TXUI.wunderbar.general.flyoutBackdrop[info[#info]]
      end,
      set = function(info, value)
        E.db.TXUI.wunderbar.general.flyoutBackdrop[info[#info]] = value
      end,
    }

    local flyoutDisabled = function()
      return self:GetEnabledState(E.db.TXUI.wunderbar.general.flyoutBackdrop.enabled) ~= self.enabledState.YES
    end

    flyoutGroup["alpha"] = {
      order = self:GetOrder(),
      type = "range",
      name = "Alpha",
      desc = "Transparency of the flyout's backdrop.",
      min = 0,
      max = 1,
      step = 0.05,
      disabled = flyoutDisabled,
      get = function(info)
        return E.db.TXUI.wunderbar.general.flyoutBackdrop[info[#info]]
      end,
      set = function(info, value)
        E.db.TXUI.wunderbar.general.flyoutBackdrop[info[#info]] = value
      end,
    }

    flyoutGroup["classColor"] = {
      order = self:GetOrder(),
      type = "toggle",
      name = "Class Color",
      desc = "Enabling this will set the flyout's backdrop to your class color.",
      disabled = flyoutDisabled,
      get = function(info)
        return E.db.TXUI.wunderbar.general.flyoutBackdrop[info[#info]]
      end,
      set = function(info, value)
        E.db.TXUI.wunderbar.general.flyoutBackdrop[info[#info]] = value
      end,
    }

    flyoutGroup["borderSize"] = {
      order = self:GetOrder(),
      type = "range",
      name = "Border Size",
      desc = "Border size of the whole flyout backdrop.",
      min = 1,
      max = 6,
      step = 1,
      disabled = flyoutDisabled,
      get = function(info)
        return E.db.TXUI.wunderbar.general.flyoutBackdrop[info[#info]]
      end,
      set = function(info, value)
        E.db.TXUI.wunderbar.general.flyoutBackdrop[info[#info]] = value
      end,
    }

    flyoutGroup["padding"] = {
      order = self:GetOrder(),
      type = "range",
      name = "Padding",
      desc = "Padding for the flyout backdrop.",
      min = 0,
      max = 32,
      step = 1,
      disabled = flyoutDisabled,
      get = function(info)
        return E.db.TXUI.wunderbar.general.flyoutBackdrop[info[#info]]
      end,
      set = function(info, value)
        E.db.TXUI.wunderbar.general.flyoutBackdrop[info[#info]] = value
      end,
    }

    self:AddSpacer(flyoutGroup)

    flyoutGroup["width"] = {
      order = self:GetOrder(),
      type = "range",
      name = "Slot Width",
      desc = "Size of an individual slot. Height is going to change accordingly to maintain 4:3 aspect ratio.",
      min = 20,
      max = 80,
      step = 1,
      disabled = flyoutDisabled,
      get = function(info)
        return E.db.TXUI.wunderbar.general.flyoutBackdrop[info[#info]]
      end,
      set = function(info, value)
        E.db.TXUI.wunderbar.general.flyoutBackdrop[info[#info]] = value
      end,
    }

    flyoutGroup["spacing"] = {
      order = self:GetOrder(),
      type = "range",
      name = "Spacing",
      desc = "Spacing between slots.",
      min = 0,
      max = 16,
      step = 1,
      disabled = flyoutDisabled,
      get = function(info)
        return E.db.TXUI.wunderbar.general.flyoutBackdrop[info[#info]]
      end,
      set = function(info, value)
        E.db.TXUI.wunderbar.general.flyoutBackdrop[info[#info]] = value
      end,
    }

    flyoutGroup["labelFont"] = {
      order = self:GetOrder(),
      type = "select",
      dialogControl = "LSM30_Font",
      name = "Label Font",
      desc = "Set the font for M+ portal labels.",
      values = self:GetAllFontsFunc(),
      disabled = flyoutDisabled,
      get = function(info)
        return E.db.TXUI.wunderbar.general.flyoutBackdrop[info[#info]]
      end,
      set = function(info, value)
        E.db.TXUI.wunderbar.general.flyoutBackdrop[info[#info]] = value
      end,
    }

    flyoutGroup["labelFontSize"] = {
      order = self:GetOrder(),
      type = "range",
      name = "Label Font Size",
      desc = "Set the font size for M+ portal labels.",
      min = 8,
      max = 64,
      step = 1,
      disabled = flyoutDisabled,
      get = function(info)
        return E.db.TXUI.wunderbar.general.flyoutBackdrop[info[#info]]
      end,
      set = function(info, value)
        E.db.TXUI.wunderbar.general.flyoutBackdrop[info[#info]] = value
      end,
    }
  end
end
