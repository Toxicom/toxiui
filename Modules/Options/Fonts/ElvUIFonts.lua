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
      name = "描述",
    }, {
      name = "此组允许更新 " .. TXUI.Title .. " " .. F.String.ElvUI() .. " 配置文件中使用的所有字体。\n\n" .. F.String.Error(
        "警告：某些字体可能仍然看起来不理想！结果不会理想，但它应该可以帮助您自定义字体 :)\n"
      ),
    }).args

    generalGroup.applyButton = {
      order = self:GetOrder(),
      type = "execute",
      name = F.String.Good("应用"),
      desc = "应用所有 " .. TXUI.Title .. " 字体设置。",
      func = function()
        TXUI:GetModule("Profiles"):ApplyFontChange()
      end,
    }

    generalGroup.resetButton = {
      order = self:GetOrder(),
      type = "execute",
      name = F.String.Error("重置"),
      desc = "重置所有 " .. TXUI.Title .. " 字体设置。",
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
    name = "字体缩放",
  }, {
    name = "此滑块将缩放大多数 " .. F.String.ElvUI("ElvUI") .. " 字体。\n",
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

  local defaultKey = "默认"
  local defaultFontOption = " " .. TXUI.Title .. " 默认"
  local overrideForceEnable = "开启"
  local overrideForceDisable = "关闭"

  local function generateFontOption(fontKey, fontName)
    -- Font Group
    local fontGroup = self:AddInlineDesc(options, {
      name = fontName .. " 字体",
    }, {
      name = F.String.Good(I.FontDescription[fontKey]) .. "\n\n" .. "默认字体: " .. F.String.ToxiUI(fontKey),
    }).args

    -- Fonts Font
    fontGroup.font = {
      order = self:GetOrder(),
      type = "select",
      dialogControl = "LSM30_Font",
      name = "字体",
      desc = "设置字体。",
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
      name = "字体轮廓",
      desc = "设置字体轮廓。",
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
      name = "字体阴影",
      desc = "设置字体阴影。",
      values = function()
        return {
          [defaultKey] = defaultFontOption,
          [overrideForceDisable] = "强制 " .. F.String.Error("关闭"),
          [overrideForceEnable] = "强制 " .. F.String.Good("开启"),
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
