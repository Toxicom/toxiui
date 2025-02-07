local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")

function O:Plugins_MiniMapCoords()
  -- Create Tab
  self.options.misc.args.miniMapCoords = {
    order = self:GetOrder(),
    type = "group",
    name = "小地图坐标",
    get = function(info)
      return E.db.TXUI.miniMapCoords[info[#info]]
    end,
    set = function(info, value)
      E.db.TXUI.miniMapCoords[info[#info]] = value
      F.Event.TriggerEvent("MiniMapCoords.SettingsUpdate")
    end,
    args = {},
  }

  -- Options
  local options = self.options.misc.args.miniMapCoords.args
  local optionsHidden

  -- General
  do
    -- General Group
    local generalGroup = self:AddInlineRequirementsDesc(options, {
      name = "描述",
    }, {
      name = "显示在小地图上的坐标。\n\n",
    }, I.Requirements.MiniMapCoords).args

    -- Enable
    generalGroup.enabled = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "启用此选项将启用 " .. TXUI.Title .. " 小地图坐标。",
      name = function()
        return self:GetEnableName(E.db.TXUI.miniMapCoords.enabled, generalGroup)
      end,
      get = function(_)
        return E.db.TXUI.miniMapCoords.enabled
      end,
      set = function(_, value)
        E.db.TXUI.miniMapCoords.enabled = value
        F.Event.TriggerEvent("MiniMapCoords.DatabaseUpdate")
      end,
    }

    -- Hidden helper
    optionsHidden = function()
      return self:GetEnabledState(E.db.TXUI.miniMapCoords.enabled, generalGroup) ~= self.enabledState.YES
    end
  end

  -- Spacer
  self:AddSpacer(options)

  -- Position
  do
    -- Position Group
    local positionGroup = self:AddInlineDesc(options, {
      name = "位置",
      hidden = optionsHidden,
    }, {
      name = "相对于小地图的坐标位置 -- 两个设置都为0将是中心。",
    }).args

    -- Position X
    positionGroup.xOffset = {
      order = self:GetOrder(),
      type = "range",
      name = "X 偏移",
      min = -300,
      max = 300,
      step = 1,
    }

    -- Position Y
    positionGroup.yOffset = {
      order = self:GetOrder(),
      type = "range",
      name = "Y 偏移",
      min = -300,
      max = 300,
      step = 1,
    }
  end

  -- Spacer
  self:AddSpacer(options)

  -- Fonts
  do
    -- Fonts Group
    local fontGroup = self:AddInlineDesc(options, {
      name = "字体",
      hidden = optionsHidden,
    }, {
      name = "小地图坐标的字体设置。",
    }).args

    -- Fonts Font
    fontGroup.coordFont = {
      order = self:GetOrder(),
      type = "select",
      dialogControl = "LSM30_Font",
      name = "字体",
      desc = "设置字体。",
      values = self:GetAllFontsFunc(),
    }

    -- Fonts Outline
    fontGroup.coordFontOutline = {
      order = self:GetOrder(),
      type = "select",
      name = "字体轮廓",
      desc = "设置字体轮廓。",
      values = self:GetAllFontOutlinesFunc(),
      disabled = function()
        return (E.db.TXUI.miniMapCoords["coordFontShadow"] == true)
      end,
    }

    -- Fonts Size
    fontGroup.coordFontSize = {
      order = self:GetOrder(),
      type = "range",
      name = "字体大小",
      desc = "设置字体大小。",
      min = 1,
      max = 100,
      step = 1,
    }

    -- Fonts Shadow
    fontGroup.coordFontShadow = {
      order = self:GetOrder(),
      type = "toggle",
      name = "字体阴影",
      desc = "设置字体阴影。",
    }

    -- Spacer
    self:AddSpacer(fontGroup)

    -- Font color select
    fontGroup.coordFontColor = {
      order = self:GetOrder(),
      type = "select",
      name = "字体颜色",
      values = self:GetAllFontColorsFunc(),
    }

    -- Font Custom Color
    fontGroup.coordFontCustomColor = {
      order = self:GetOrder(),
      type = "color",
      name = "自定义颜色",
      hasAlpha = true,
      get = self:GetFontColorGetter("TXUI.miniMapCoords", P.miniMapCoords),
      set = self:GetFontColorSetter("TXUI.miniMapCoords", function()
        F.Event.TriggerEvent("MiniMapCoords.SettingsUpdate")
      end),
      hidden = function()
        return E.db.TXUI.miniMapCoords.coordFontColor ~= "CUSTOM"
      end,
    }
  end

  -- Spacer
  self:AddSpacer(options)

  -- Format
  do
    -- Format Group
    local formatGroup = self:AddInlineDesc(options, {
      name = "格式",
      hidden = optionsHidden,
    }, {
      name = "小地图坐标的小数格式",
    }).args

    -- Formats
    formatGroup.format = {
      order = self:GetOrder(),
      type = "select",
      name = "格式",
      desc = "小数格式",
      values = {
        ["%.0f"] = "42",
        ["%.1f"] = "42.0",
        ["%.2f"] = "42.01",
        ["%.3f"] = "42.012",
      },
    }
  end
end

O:AddCallback("Plugins_MiniMapCoords")
