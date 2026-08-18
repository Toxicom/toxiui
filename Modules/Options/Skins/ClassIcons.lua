local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")
local M = TXUI:GetModule("Misc")

function O:Skins_ClassIcons()
  -- Create Tab
  self.options.skins.args["classIcons"] = {
    order = self:GetOrder(),
    type = "group",
    name = F.String.Class("Class") .. " & " .. F.String.Class("Spec") .. " Icons " .. E.NewSign,
    args = {},
  }

  -- Options
  local options = self.options.skins.args["classIcons"]["args"]

  -- ElvUI Group Description
  self:AddInlineDesc(options, {
    name = "Description",
  }, {
    name = TXUI.Title .. " provides Class and Specialization Icons. Choose a style to apply globally across all displays.",
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
        .. "Due to the way the API collects specialization data, sometimes it is missing, therefore occasionally no icon will be shown, or it will show the class icon instead of the spec icon.\nThis is known and no fix for now until Blizzard provides a proper Specialization API for units other than the player.",
    })
  end

  self:AddSpacer(options)

  do
    local styleGroup = self:AddInlineDesc(options, {
      name = "Icon Style " .. E.NewSign,
    }, {
      name = "Change the style for all "
        .. TXUI.Title
        .. " spec icons: UnitFrames ("
        .. F.String.ToxiUI("[tx:classicon]")
        .. "), Game Menu, AFK screen, and Blizzard Damage Meter.\n\n",
    }).args

    styleGroup.style = {
      order = self:GetOrder(),
      type = "select",
      width = 1.5,
      name = "Style",
      values = function()
        local tbl = M:GetClassIconStyleValues()

        if TXUI.IsRetail or TXUI.IsClassic then F.Table.Crush(tbl, M:GetSpecIconStyleValues()) end

        return tbl
      end,
      sorting = {
        "ToxiClasses",
        "UggColored",
        "UggColoredStroke",
        "UggWhiteStroke",
        "ToxiSpecStylized",
        "ToxiSpecWhite",
        "ToxiSpecWhiteStroke",
        "ToxiSpecColored",
        "ToxiSpecColoredStroke",
      },
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
    local classOrder = I.ClassOrder
    local classSpecOrder = I.ClassSpecOrder

    local previewGroup = self:AddInlineDesc(options, {
      name = "Preview " .. E.NewSign,
    }, {
      name = "Live preview of the currently selected icon style.\n\n",
    }).args

    previewGroup.icons = {
      order = self:GetOrder(),
      type = "description",
      name = function()
        local theme = E.db.TXUI.elvUIIcons.classIcons.theme or "ToxiClasses"
        local usingSpecIcons = theme:match("ToxiSpec")
        local classPath = M:GetClassIconPath(M:GetEffectiveClassIconTheme(theme))
        local specPath = usingSpecIcons and M:GetClassIconPath(theme) or nil

        local lines = {}

        for _, class in ipairs(classOrder) do
          if I.IsClassAvailable(class) then
            local classCoords = M.ClassIcons[class]
            if classCoords then
              local label = F.String.Class(string.upper(I.EnglishClassName[class] or class), class)
              local classIcon = string.format(classPath, classCoords)
              local icons = { classIcon }

              if usingSpecIcons and specPath then
                local specs = classSpecOrder[class]
                if specs then
                  for _, specId in ipairs(specs) do
                    local specCoords = M.SpecIcons[specId]
                    if specCoords then icons[#icons + 1] = string.format(specPath, specCoords) end
                  end
                end
              end

              lines[#lines + 1] = label .. "\n\n" .. table.concat(icons, " ")
            end
          end
        end

        return table.concat(lines, "\n\n")
      end,
    }
  end
end

O:AddCallback("Skins_ClassIcons")
