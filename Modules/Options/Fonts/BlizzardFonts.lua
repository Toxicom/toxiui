local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")

function O:Fonts_BlizzardFonts()
  local options = self.options.fonts.args.blizzard_fonts.args
  local optionsHidden

  -- Reset order for new page
  self:ResetOrder()

  -- General
  do
    -- General Group
    local generalGroup = self:AddInlineRequirementsDesc(options, {
      name = "Description",
    }, {
      name = "Replaces various fonts from Blizzard with the settings below.\n\n",
    }, I.Requirements.BlizzardFonts).args

    -- Enable
    generalGroup.enabled = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Toggling this on enables the " .. TXUI.Title .. " BlizzardFonts.",
      name = function()
        return self:GetEnableName(E.db.TXUI.blizzardFonts.enabled, generalGroup)
      end,
      get = function(_)
        return E.db.TXUI.blizzardFonts.enabled
      end,
      set = function(_, value)
        E.db.TXUI.blizzardFonts.enabled = value
        F.Event.TriggerEvent("BlizzardFonts.DatabaseUpdate")
      end,
    }

    -- Hidden helper
    optionsHidden = function()
      return self:GetEnabledState(E.db.TXUI.blizzardFonts.enabled, generalGroup) ~= self.enabledState.YES
    end
  end

  -- Spacer
  self:AddSpacer(options)

  -- Zone Text
  do
    -- Zone Text Group
    local zoneTextGroup = self:AddInlineDesc(options, {
      name = "Zone Text",
      hidden = optionsHidden,
    }, {
      name = "This will change the text in the middle of your screen when you enter a new zone/subzone\n\n",
    }).args

    zoneTextGroup.previewButton = {
      order = self:GetOrder(),
      type = "execute",
      name = "Preview",
      desc = "Display a preview of the Zone Text",
      func = function()
        F.Event.TriggerEvent("BlizzardFonts.ShowPreview")
      end,
    }

    -- Spacer
    self:AddSpacer(zoneTextGroup)

    -- Main Zone Text
    do
      local fontGroup = self:AddInlineGroup(zoneTextGroup, {
        name = "Zone Text",
      }).args

      -- Fonts Font
      fontGroup.zoneFont = {
        order = self:GetOrder(),
        type = "select",
        dialogControl = "LSM30_Font",
        name = "Font",
        desc = "Set the font.",
        values = self:GetAllFontsFunc(),
      }

      -- Fonts Outline
      fontGroup.zoneFontOutline = {
        order = self:GetOrder(),
        type = "select",
        name = "Font Outline",
        desc = "Set the font outline.",
        values = self:GetAllFontOutlinesFunc(),
        disabled = function()
          return (E.db.TXUI.blizzardFonts.zoneFontShadow == true)
        end,
      }

      -- Fonts Size
      fontGroup.zoneFontSize = {
        order = self:GetOrder(),
        type = "range",
        name = "Font Size",
        desc = "Set the font size.",
        min = 1,
        max = 100,
        step = 1,
      }

      -- Fonts Shadow
      fontGroup.zoneFontShadow = {
        order = self:GetOrder(),
        type = "toggle",
        name = "Font Shadow",
        desc = "Set font drop shadow.",
      }
    end

    -- Subzone Text
    do
      local fontGroup = self:AddInlineGroup(zoneTextGroup, {
        name = "Subzone Text",
      }).args

      -- Fonts Font
      fontGroup.subZoneFont = {
        order = self:GetOrder(),
        type = "select",
        dialogControl = "LSM30_Font",
        name = "Font",
        desc = "Set the font.",
        values = self:GetAllFontsFunc(),
      }

      -- Fonts Outline
      fontGroup.subZoneFontOutline = {
        order = self:GetOrder(),
        type = "select",
        name = "Font Outline",
        desc = "Set the font outline.",
        values = self:GetAllFontOutlinesFunc(),
        disabled = function()
          return (E.db.TXUI.blizzardFonts.subZoneFontShadow == true)
        end,
      }

      -- Fonts Size
      fontGroup.subZoneFontSize = {
        order = self:GetOrder(),
        type = "range",
        name = "Font Size",
        desc = "Set the font size.",
        min = 1,
        max = 100,
        step = 1,
      }

      -- Fonts Shadow
      fontGroup.subZoneFontShadow = {
        order = self:GetOrder(),
        type = "toggle",
        name = "Font Shadow",
        desc = "Set font drop shadow.",
      }
    end

    -- PvP Zone Info Text
    do
      local fontGroup = self:AddInlineGroup(zoneTextGroup, {
        name = "PvP Text",
      }).args

      -- Fonts Font
      fontGroup.pvpZoneFont = {
        order = self:GetOrder(),
        type = "select",
        dialogControl = "LSM30_Font",
        name = "Font",
        desc = "Set the font.",
        values = self:GetAllFontsFunc(),
      }

      -- Fonts Outline
      fontGroup.pvpZoneFontOutline = {
        order = self:GetOrder(),
        type = "select",
        name = "Font Outline",
        desc = "Set the font outline.",
        values = self:GetAllFontOutlinesFunc(),
        disabled = function()
          return (E.db.TXUI.blizzardFonts.pvpZoneFontShadow == true)
        end,
      }

      -- Fonts Size
      fontGroup.pvpZoneFontSize = {
        order = self:GetOrder(),
        type = "range",
        name = "Font Size",
        desc = "Set the font size.",
        min = 1,
        max = 100,
        step = 1,
      }

      -- Fonts Shadow
      fontGroup.pvpZoneFontShadow = {
        order = self:GetOrder(),
        type = "toggle",
        name = "Font Shadow",
        desc = "Set font drop shadow.",
      }
    end
  end

  -- Spacer
  self:AddSpacer(options)

  -- Misc Text
  do
    -- Misc Text Group
    local miscTextGroup = self:AddInlineDesc(options, {
      name = "Misc Text",
      hidden = optionsHidden,
    }, {
      name = "This will change dialog frame texts.",
    }).args

    -- Spacer
    self:AddSpacer(miscTextGroup)

    -- Mail Text
    do
      local fontGroup = self:AddInlineGroup(miscTextGroup, {
        name = "Mail Text",
      }).args

      -- Fonts Font
      fontGroup.mailFont = {
        order = self:GetOrder(),
        type = "select",
        dialogControl = "LSM30_Font",
        name = "Font",
        desc = "Set the font.",
        values = self:GetAllFontsFunc(),
      }

      -- Fonts Outline
      fontGroup.mailFontOutline = {
        order = self:GetOrder(),
        type = "select",
        name = "Font Outline",
        desc = "Set the font outline.",
        values = self:GetAllFontOutlinesFunc(),
      }

      -- Fonts Size
      fontGroup.mailFontSize = {
        order = self:GetOrder(),
        type = "range",
        name = "Font Size",
        desc = "Set the font size.",
        min = 1,
        max = 100,
        step = 1,
      }
    end

    -- Gossip/Quest Text
    do
      local fontGroup = self:AddInlineGroup(miscTextGroup, {
        name = "Gossip/Quest Text",
      }).args

      -- Fonts Font
      fontGroup.gossipFont = {
        order = self:GetOrder(),
        type = "select",
        dialogControl = "LSM30_Font",
        name = "Font",
        desc = "Set the font.",
        values = self:GetAllFontsFunc(),
      }

      -- Fonts Outline
      fontGroup.gossipFontOutline = {
        order = self:GetOrder(),
        type = "select",
        name = "Font Outline",
        desc = "Set the font outline.",
        values = self:GetAllFontOutlinesFunc(),
      }

      -- Fonts Size
      fontGroup.gossipFontSize = {
        order = self:GetOrder(),
        type = "range",
        name = "Font Size",
        desc = "Set the font size.",
        min = 1,
        max = 100,
        step = 1,
      }
    end
  end
end

O:AddCallback("Fonts_BlizzardFonts")
