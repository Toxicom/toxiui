local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")

function O:Fonts_ElvUIFonts()
  local options = self.options.fonts.args.elvui_fonts.args

  -- Reset order for new page
  self:ResetOrder()

  -- General
  do
    -- General Group
    local generalGroup = self:AddInlineDesc(options, {
      name = "Description",
    }, {
      name = "This group allows to update all fonts used in the " .. TXUI.Title .. " " .. F.String.ElvUI() .. " Profile.\n\n" .. F.String.Error(
        "Warning: Some fonts might still not look ideal! The results will not be ideal, but it should help you customize the fonts :)\n"
      ),
    }).args

    generalGroup.applyButton = {
      order = self:GetOrder(),
      type = "execute",
      name = F.String.Good("Apply"),
      desc = "Applies all " .. TXUI.Title .. " font settings.",
      func = function()
        TXUI:GetModule("Profiles"):ApplyFontChange()
      end,
    }

    generalGroup.resetButton = {
      order = self:GetOrder(),
      type = "execute",
      name = F.String.Error("Reset"),
      desc = "Resets all " .. TXUI.Title .. " font settings.",
      func = function()
        E:CopyTable(E.db.TXUI.general.fontOverride, P.general.fontOverride)
        E:CopyTable(E.db.TXUI.general.fontStyleOverride, P.general.fontStyleOverride)
        E:CopyTable(E.db.TXUI.general.fontShadowOverride, P.general.fontShadowOverride)

        TXUI:GetModule("Profiles"):ApplyFontChange()
      end,
    }
  end

  -- Spacer
  self:AddTinySpacer(options)

  -- ElvUI Font Scale Group
  local elvuiFontScaleGroup = self:AddInlineDesc(options, {
    name = "Font Scale",
  }, {
    name = "This slider will scale most of " .. F.String.ElvUI("ElvUI") .. " fonts.\n",
  }).args

  -- ElvUI Font Scale Enable
  elvuiFontScaleGroup.fontScale = {
    order = self:GetOrder(),
    type = "range",
    min = -3,
    max = 3,
    step = 1,
    name = "",
    get = function(_)
      return E.db.TXUI.addons.fontScale
    end,
    set = function(_, value)
      E.db.TXUI.addons.fontScale = value
    end,
  }

  local defaultKey = "DEFAULT"
  local defaultFontOption = " " .. TXUI.Title .. " Default"
  local overrideForceEnable = "ON"
  local overrideForceDisable = "OFF"

  local function generateFontOption(fontKey, fontName)
    -- Font Group
    local fontGroup = self:AddInlineDesc(options, {
      name = fontName .. " Font",
    }, {
      name = F.String.Good(I.FontDescription[fontKey]) .. "\n\n" .. "Default font: " .. F.String.ToxiUI(fontKey),
    }).args

    -- Fonts Font
    fontGroup.font = {
      order = self:GetOrder(),
      type = "select",
      dialogControl = "LSM30_Font",
      name = "Font",
      desc = "Set the font.",
      values = self:GetAllFontsFunc {
        [defaultFontOption] = F.GetFontPath(I.Fonts.Primary),
      },
      get = function(_)
        local entry = E.db.TXUI.general.fontOverride[fontKey]
        return (entry == nil or entry == defaultKey) and defaultFontOption or entry
      end,
      set = function(_, value)
        if value == defaultFontOption then value = defaultKey end
        E.db.TXUI.general.fontOverride[fontKey] = value
      end,
    }

    -- Fonts Outline
    fontGroup.outline = {
      order = self:GetOrder(),
      type = "select",
      name = "Font Outline",
      desc = "Set the font outline.",
      values = self:GetAllFontOutlinesFunc {
        [defaultKey] = defaultFontOption,
      },
      get = function(_)
        local entry = E.db.TXUI.general.fontStyleOverride[fontKey]
        if entry == nil then return defaultKey end
        return entry
      end,
      set = function(_, value)
        E.db.TXUI.general.fontStyleOverride[fontKey] = value
      end,
    }

    -- Fonts Shadow
    fontGroup.shadow = {
      order = self:GetOrder(),
      type = "select",
      name = "Font Shadow",
      desc = "Set the font shadow.",
      values = function()
        return {
          [defaultKey] = defaultFontOption,
          [overrideForceDisable] = "Force " .. F.String.Error("Off"),
          [overrideForceEnable] = "Force " .. F.String.Good("On"),
        }
      end,
      get = function(_)
        local entry = E.db.TXUI.general.fontShadowOverride[fontKey]
        if entry == nil or type(entry) == "string" and entry == defaultKey then
          return defaultKey
        elseif entry == true then
          return overrideForceEnable
        elseif entry == false then
          return overrideForceDisable
        end
      end,
      set = function(_, value)
        if value == overrideForceEnable then
          value = true
        elseif value == overrideForceDisable then
          value = false
        end

        E.db.TXUI.general.fontShadowOverride[fontKey] = value
      end,
    }
  end

  for _, fontKey in ipairs(I.FontOrder) do
    generateFontOption(fontKey, I.FontNames[fontKey])
  end
end

O:AddCallback("Fonts_ElvUIFonts")
