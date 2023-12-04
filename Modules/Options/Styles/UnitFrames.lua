local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")
local ST = TXUI:GetModule("Styles")
local SS = TXUI:GetModule("SplashScreen")

function O:Styles_UnitFrames()
  -- Create Tab
  self.options.styles.args["unitFramesGroup"] = {
    order = self:GetOrder(),
    type = "group",
    name = "UnitFrames",
    args = {},
  }

  -- Options
  local options = self.options.styles.args["unitFramesGroup"]["args"]

  -- UnitFrames Group Description
  self:AddInlineDesc(options, {
    name = "Description",
  }, {
    name = TXUI.Title --
      .. " offers different styles for UnitFrames layouts, visibility and overall behavior."
      .. "\n\nYour current active style: "
      .. F.String.Good(E.db.TXUI.styles.unitFrames),
  })

  -- Spacer
  self:AddSpacer(options)

  -- New Style
  do
    local newStyle = self:AddInlineRequirementsDesc(options, {
      name = TXUI.Title .. " New Style",
    }, {
      name = "This style is the original style of "
        .. TXUI.Title
        .. " where we prioritize New for providing information, therefore the UnitFrames remain hidden and shown only when necessary to reduce visual clutter.\n\n"
        .. "With this style the UnitFrames are mouseover at the bottom, right above the WunderBar.\n\n"
        .. F.String.ToxiUI("Information: ")
        .. "If you'd still like to display UnitFrames while in New style, navigate to the "
        .. F.String.FastGradientHex("Miscellaneous", "#b085f5", "#4d2c91")
        .. " tab on the left and select "
        .. F.String.Class("Other")
        .. " to find UnitFrames Fade settings.\n\n",
    })

    newStyle["args"]["enable"] = {
      order = self:GetOrder(),
      type = "execute",
      name = F.String.Class("Apply", "MONK"),
      desc = "Applies the original " .. TXUI.Title .. " New style that is meant to be played with New.",
      func = function()
        SS:Wrap("Applying New Style ..", function()
          ST:ApplyStyle("unitFrames", "New")
        end, true)
      end,
    }

    newStyle["args"]["image"] = {
      order = self:GetOrder(),
      type = "description",
      name = "",
      image = function()
        return I.Media.Installer.Layouts, F.Dpi(512), F.Dpi(256)
      end,
    }
  end

  -- Old Style
  do
    local oldStyle = self:AddInlineRequirementsDesc(options, {
      name = TXUI.Title .. " Old Style",
    }, {
      name = "The Old "
        .. TXUI.Title
        .. " style for users who do not like New and prefer just ye' old reliable UnitFrames.\n\n"
        .. F.String.ToxiUI("Information: ")
        .. "This style is recommended for Old Era players, hence the naming of Old Style ;)\n\n",
    })

    oldStyle["args"]["enable"] = {
      order = self:GetOrder(),
      type = "execute",
      name = F.String.Class("Apply", "MONK"),
      desc = "Applies the Old " .. TXUI.Title .. " UnitFrames style for users that prefer playing without New.",
      func = function()
        SS:Wrap("Applying Old Style ..", function()
          ST:ApplyStyle("unitFrames", "Old")
        end, true)
      end,
    }

    oldStyle["args"]["image"] = {
      order = self:GetOrder(),
      type = "description",
      name = "",
      image = function()
        return I.Media.Installer.Layouts, F.Dpi(512), F.Dpi(256)
      end,
    }
  end
end

O:AddCallback("Styles_UnitFrames")
