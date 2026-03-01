local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")

function O:Skins_ClassIcons()
  -- Create Tab
  self.options.skins.args["classIcons"] = {
    order = self:GetOrder(),
    type = "group",
    name = F.String.Class("Class") .. " Icons",
    args = {},
  }

  -- Options
  local options = self.options.skins.args["classIcons"]["args"]

  -- ElvUI Group Description
  self:AddInlineDesc(options, {
    name = "Description",
  }, {
    name = TXUI.Title .. " provides Class Icons which can be configured here.",
  })

  -- Spacer
  self:AddSpacer(options)

  do
    self:AddInlineDesc(options, {
      name = "Spec Icons Information",
    }, {
      name = "Spec Icons on "
        .. F.String.ElvUI()
        .. " UnitFrames are available only for Retail!\n\n"
        .. F.String.Warning("Warning: ")
        .. "Due to the way the API collects specialization data, sometimes it is missing, therefore occasionally no icon will be shown.\nThis is known and no fix for now until Blizzard provides a proper Specialization API for units other than the player.",
    })
  end

  self:AddSpacer(options)

  do
    local styleGroup = self:AddInlineDesc(options, {
      name = "Icon Style",
    }, {
      name = "Change the style for the " .. F.String.ToxiUI("[tx:classicon]") .. " tag used in UnitFrames.\n\n",
    }).args

    styleGroup.style = {
      order = self:GetOrder(),
      type = "select",
      name = "Style",
      values = function()
        local tbl = {
          ToxiClasses = F.String.ToxiUI("Stylized"),
          UggColored = F.String.Ugg() .. " " .. F.String.Rainbow("Colored"),
          UggColoredStroke = F.String.Ugg() .. " " .. F.String.Rainbow("Colored") .. " Stroke",
          UggWhiteStroke = F.String.Ugg() .. " White Stroke",
        }

        if TXUI.IsRetail then
          local retailTable = {
            ToxiSpecStylized = F.String.Class("Spec") .. " " .. F.String.ToxiUI("Stylized"),
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

  -- Spacer
  self:AddSpacer(options)

  do
    local imageGroup = self:AddInlineDesc(options, {
      name = "Images",
    }, {
      name = "See examples of all the different " .. TXUI.Title .. " icons available.\n\n",
    }).args

    imageGroup.class = {
      order = self:GetOrder(),
      type = "description",
      name = "",
      image = function()
        return I.Media.Style.ClassIconsPreview, 512, 128
      end,
    }
  end
end

O:AddCallback("Skins_ClassIcons")
