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
      .. " offers different styles for UnitFrames."
      .. "\n\nYour current active style: "
      .. F.String.Good(E.db.TXUI.styles.unitFrames),
  })

  -- Spacer
  self:AddSpacer(options)

  do
    local healthTag = self:AddInlineRequirementsDesc(options, {
      name = TXUI.Title .. " Health Tag",
    }, {
      name = "This option will change the default ToxiUI health tag to show full health value instead of percentage.\n\n"
        .. "This only works for these tags: "
        .. F.String.ToxiUI("[tx:health:percent:nosign]")
        .. ", "
        .. F.String.ToxiUI("[tx:health:percent]")
        .. ".\n\n"
        .. F.String.ToxiUI("Information: ")
        .. "If you enable this setting, the font size for health will definitely be too big. It's up to you to adjust that!\nVisit the "
        .. TXUI.Title
        .. " Website's FAQ if you're not sure how to change UnitFrame texts.\n\n",
    })

    healthTag["args"]["enable"] = {
      order = self:GetOrder(),
      type = "toggle",
      name = function()
        return self:GetEnableName(E.db.TXUI.styles.healthTag.enabled, healthTag)
      end,
      get = function()
        return E.db.TXUI.styles.healthTag.enabled
      end,
      set = function(_, value)
        E.db.TXUI.styles.healthTag.enabled = value
      end,
    }

    healthTag["args"]["style"] = {
      order = self:GetOrder(),
      type = "select",
      name = "Style",
      get = function()
        return E.db.TXUI.styles.healthTag.style
      end,
      set = function(_, value)
        E.db.TXUI.styles.healthTag.style = value
      end,
      values = {
        ["Full"] = "127.3K",
        ["FullPercent"] = "127.3K l 100",
      },
    }
  end

  -- Spacer
  self:AddSpacer(options)

  -- New Style
  do
    local newStyle = self:AddInlineRequirementsDesc(options, {
      name = TXUI.Title .. " New Style",
    }, {
      name = "This style was introduced in "
        .. TXUI.Title
        .. " patch 6.3.0 which went for a more artistic approach of UnitFrames prioritising a single number for unit's health percentage.\n\n",
    })

    newStyle["args"]["enable"] = {
      order = self:GetOrder(),
      type = "execute",
      name = F.String.Class("Apply", "MONK"),
      desc = "Applies the New " .. TXUI.Title .. " UnitFrames style.",
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
        return I.Media.Style.New, F.Dpi(256), F.Dpi(128)
      end,
    }
  end

  -- Old Style
  do
    local oldStyle = self:AddInlineRequirementsDesc(options, {
      name = TXUI.Title .. " Old Style",
    }, {
      name = "The Old " .. TXUI.Title .. " style for users who want more information displayed on their UnitFrames.\n\n",
    })

    oldStyle["args"]["enable"] = {
      order = self:GetOrder(),
      type = "execute",
      name = F.String.Class("Apply", "MONK"),
      desc = "Applies the Old " .. TXUI.Title .. " UnitFrames style.",
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
        return I.Media.Style.Old, F.Dpi(256), F.Dpi(128)
      end,
    }
  end
end

O:AddCallback("Styles_UnitFrames")
