local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")

function O:Skins_ClassIcons()
  -- Create Tab
  self.options.skins.args["classIcons"] = {
    order = self:GetOrder(),
    type = "group",
    name = F.String.Class("职业") .. " 图标 " .. E.NewSign,
    args = {},
  }

  -- Options
  local options = self.options.skins.args["classIcons"]["args"]

  -- ElvUI Group Description
  self:AddInlineDesc(options, {
    name = "描述",
  }, {
    name = TXUI.Title .. " 提供可以在此配置的职业图标。",
  })

  -- Spacer
  self:AddSpacer(options)

  do
    self:AddInlineDesc(options, {
      name = "专精图标信息",
    }, {
      name = "在 "
        .. F.String.ElvUI()
        .. " 单位框架上的专精图标仅适用于正式服！\n\n"
        .. F.String.Warning("警告: ")
        .. "由于 API 收集专精数据的方式，有时会丢失数据，因此偶尔不会显示图标。\n这是已知问题，直到暴雪为玩家以外的单位提供适当的专精 API 之前，无法修复。",
    })
  end

  self:AddSpacer(options)

  do
    local detailsGroup = self:AddInlineDesc(options, {
      name = "Details 图标",
    }, {
      name = "我们无法自动更改 "
        .. F.String.Details()
        .. " 自定义图标。\n\n您需要在 "
        .. F.String.ToxiUI("/details config")
        .. " -> Bars: General -> Icons -> Texture 中自行更改\n\n",
    }).args

    detailsGroup.button = {
      order = self:GetOrder(),
      type = "execute",
      name = F.String.Details("打开 Details"),
      desc = "打开 " .. F.String.Details() .. " 配置窗口",
      disabled = function()
        return not F.IsAddOnEnabled("Details")
      end,
      func = function()
        -- instance = which details window
        local instance = Details:GetInstance(1)
        Details:OpenOptionsWindow(instance)
        E:ToggleOptions()
      end,
    }
  end

  self:AddSpacer(options)

  do
    local styleGroup = self:AddInlineDesc(options, {
      name = "图标样式",
    }, {
      name = "更改单位框架中使用的 " .. F.String.ToxiUI("[tx:classicon]") .. " 标签的样式。\n\n",
    }).args

    styleGroup.style = {
      order = self:GetOrder(),
      type = "select",
      name = "样式",
      values = function()
        local tbl = {
          ToxiClasses = F.String.ToxiUI("风格化"),
          UggColored = F.String.Ugg() .. " " .. F.String.Rainbow("彩色"),
          UggColoredStroke = F.String.Ugg() .. " " .. F.String.Rainbow("彩色") .. " 描边",
          UggWhiteStroke = F.String.Ugg() .. " 白色描边",
        }

        if TXUI.IsRetail then
          local retailTable = {
            ToxiSpecStylized = F.String.Class("专精") .. " " .. F.String.ToxiUI("风格化"),
            ToxiSpecColored = F.String.Class("专精") .. " " .. F.String.Rainbow("彩色"),
            ToxiSpecColoredStroke = F.String.Class("专精") .. " " .. F.String.Rainbow("彩色") .. " 描边",
            ToxiSpecWhite = F.String.Class("专精") .. " 白色",
            ToxiSpecWhiteStroke = F.String.Class("专精") .. " 白色描边",
          }

          F.Table.Crush(tbl, retailTable)
        end

        return tbl
      end,
      get = function()
        return E.db.TXUI.elvUIIcons.classIcons.theme
      end,
      set = function(_, value)
        E.db.TXUI.elvUIIcons.classIcons.theme = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
    }
  end

  do
    local imageGroup = self:AddInlineDesc(options, {
      name = "图像",
    }, {
      name = "查看所有可用的 " .. TXUI.Title .. " 图标示例。\n\n",
    }).args

    imageGroup.class = {
      order = self:GetOrder(),
      type = "description",
      name = "",
      image = function()
        return I.Media.Style.ClassIconsPreview, 512, 128
      end,
    }

    self:AddSpacer(imageGroup)

    imageGroup.spec = {
      order = self:GetOrder(),
      type = "description",
      name = "",
      hidden = not TXUI.IsRetail,
      image = function()
        return I.Media.Style.SpecIconsPreview, 512, 128
      end,
    }
  end
end

O:AddCallback("Skins_ClassIcons")
