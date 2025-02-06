local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")
local ST = TXUI:GetModule("Styles")
local SS = TXUI:GetModule("SplashScreen")

function O:Styles_ActionBars()
  -- Create Tab
  self.options.styles.args["actionBarsGroup"] = {
    order = self:GetOrder(),
    type = "group",
    name = "ActionBars",
    args = {},
  }

  -- Options
  local options = self.options.styles.args["actionBarsGroup"]["args"]

  -- ActionBars Group Description
  self:AddInlineDesc(options, {
    name = "Description",
  }, {
    name = TXUI.Title --
      .. " offers different styles for ActionBars layouts, visibility and overall behavior."
      .. "\n\nYour current active style: "
      .. F.String.Good(E.db.TXUI.styles.actionBars),
  })

  -- Spacer
  self:AddSpacer(options)

  -- WeakAuras Style
  do
    local weakAurasStyle = self:AddInlineRequirementsDesc(options, {
      name = TXUI.Title .. " WeakAuras Style",
    }, {
      name = "This style is the original style of "
        .. TXUI.Title
        .. " where we prioritize WeakAuras for providing information, therefore the ActionBars remain hidden and shown only when necessary to reduce visual clutter.\n\n"
        .. "With this style the ActionBars are mouseover at the bottom, right above the WunderBar.\n\n"
        .. F.String.ToxiUI("Information: ")
        .. "If you'd still like to display ActionBars while in WeakAuras style, navigate to the "
        .. F.String.Menu.Skins()
        .. " tab on the left and select "
        .. F.String.Class("ElvUI")
        .. " to find ActionBars Fade settings.\n\n",
    })

    weakAurasStyle["args"]["enable"] = {
      order = self:GetOrder(),
      type = "execute",
      name = F.String.Class("Apply", "MONK"),
      desc = "Applies the original " .. TXUI.Title .. " WeakAuras style that is meant to be played with WeakAuras.",
      func = function()
        SS:Wrap("Applying WeakAuras Style ..", function()
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
      name = TXUI.Title .. " Classic Style",
    }, {
      name = "The Classic "
        .. TXUI.Title
        .. " style for users who do not like WeakAuras and prefer just ye' old reliable ActionBars.\n\n"
        .. F.String.ToxiUI("Information: ")
        .. "This style is recommended for Vanilla players, hence the naming of Classic Style ;)\n\n",
    })

    classicStyle["args"]["enable"] = {
      order = self:GetOrder(),
      type = "execute",
      name = F.String.Class("Apply", "MONK"),
      desc = "Applies the Classic " .. TXUI.Title .. " ActionBars style for users that prefer playing without WeakAuras.",
      func = function()
        SS:Wrap("Applying Classic Style ..", function()
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
