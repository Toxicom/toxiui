local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")
local ST = TXUI:GetModule("Styles")
local SS = TXUI:GetModule("SplashScreen")

function O:Styles_ActionBars()
  -- Create Tab
  self.options.styles.args["actionBarsGroup"] = {
    order = self:GetOrder(),
    type = "group",
    name = "动作条",
    args = {},
  }

  -- Options
  local options = self.options.styles.args["actionBarsGroup"]["args"]

  -- ActionBars Group Description
  self:AddInlineDesc(options, {
    name = "描述",
  }, {
    name = TXUI.Title --
      .. " 提供了不同的动作条布局、可见性和整体行为的样式。"
      .. "\n\n您当前的激活样式: "
      .. F.String.Good(E.db.TXUI.styles.actionBars),
  })

  -- Spacer
  self:AddSpacer(options)

  -- WeakAuras Style
  do
    local weakAurasStyle = self:AddInlineRequirementsDesc(options, {
      name = TXUI.Title .. " WeakAuras 样式",
    }, {
      name = "这种样式是 "
        .. TXUI.Title
        .. " 的原始样式，我们优先考虑 WeakAuras 提供信息，因此动作条保持隐藏，仅在必要时显示以减少视觉混乱。\n\n"
        .. "在这种样式下，动作条在底部鼠标悬停，位于 WunderBar 之上。\n\n"
        .. F.String.ToxiUI("信息: ")
        .. "如果您仍希望在 WeakAuras 样式下显示动作条，请导航到左侧的 "
        .. F.String.Menu.Skins()
        .. " 选项卡并选择 "
        .. F.String.Class("ElvUI")
        .. " 以找到动作条淡出设置。\n\n",
    })

    weakAurasStyle["args"]["enable"] = {
      order = self:GetOrder(),
      type = "execute",
      name = F.String.Class("应用", "MONK"),
      desc = "应用原始的 " .. TXUI.Title .. " WeakAuras 样式，适合与 WeakAuras 一起使用。",
      func = function()
        SS:Wrap("应用 WeakAuras 样式中 ..", function()
          ST:ApplyStyle("actionBars", "WeakAuras")
        end, true)
      end,
    }

    weakAurasStyle["args"]["image"] = {
      order = self:GetOrder(),
      type = "description",
      name = "",
      image = function()
        return I.Media.Style.WeakAuras, F.Dpi(512), F.Dpi(256)
      end,
    }
  end

  -- Classic Style
  do
    local classicStyle = self:AddInlineRequirementsDesc(options, {
      name = TXUI.Title .. " 经典样式",
    }, {
      name = "经典的 "
        .. TXUI.Title
        .. " 样式，适合不喜欢 WeakAuras 而更喜欢传统动作条的用户。\n\n"
        .. F.String.ToxiUI("信息: ")
        .. "这种样式推荐给怀旧服玩家，因此命名为经典样式 ;)\n\n",
    })

    classicStyle["args"]["enable"] = {
      order = self:GetOrder(),
      type = "execute",
      name = F.String.Class("应用", "MONK"),
      desc = "应用经典的 " .. TXUI.Title .. " 动作条样式，适合不使用 WeakAuras 的用户。",
      func = function()
        SS:Wrap("应用经典样式中 ..", function()
          ST:ApplyStyle("actionBars", "Classic")
        end, true)
      end,
    }

    classicStyle["args"]["image"] = {
      order = self:GetOrder(),
      type = "description",
      name = "",
      image = function()
        return I.Media.Style.Classic, F.Dpi(512), F.Dpi(256)
      end,
    }
  end
end

O:AddCallback("Styles_ActionBars")
