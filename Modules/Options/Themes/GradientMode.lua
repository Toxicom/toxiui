local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")
local ACH = LibStub("LibAceConfigHelper")

local _G = _G
local FACTION_BAR_COLORS = _G.FACTION_BAR_COLORS
local LOCALIZED_CLASS_NAMES_FEMALE = _G.LOCALIZED_CLASS_NAMES_FEMALE
local LOCALIZED_CLASS_NAMES_MALE = _G.LOCALIZED_CLASS_NAMES_MALE
local PowerBarColor = _G.PowerBarColor

function O:ToxiUI_Themes_GradientMode()
  local gradientTitle = "|cffff97f6G|r|cfff8b0f2ra|r|cfff5c6f1di|r|cfff3d9f1en|r|cffffeafdt"

  -- Create Tab
  self.options.themes.args.gradientMode = {
    order = self:GetOrder(),
    type = "group",
    childGroups = "tab",
    name = gradientTitle .. " Mode|r",
    get = function(info)
      return E.db.TXUI.themes.gradientMode[info[#info]]
    end,
    set = function(info, value)
      E.db.TXUI.themes.gradientMode[info[#info]] = value
      F.Event.TriggerEvent("ThemesGradients.DatabaseUpdate")
    end,
    args = {},
  }

  -- Options
  local options = self.options.themes.args.gradientMode.args

  -- General
  do
    -- General Group
    local generalGroup = self:AddInlineRequirementsDesc(options, {
      name = "Description",
    }, {
      name = "We provide different themes for "
        .. TXUI.Title
        .. ", you can enable or disable them below."
        .. "\n\n"
        .. "Some colors (like Details dark mode gradient text) will update only after a reload."
        .. "\n\n"
        .. F.String.Error(
          "Warning: Enabling one of these settings may overwrite colors or textures in ElvUI and Details, they also prevent you from changing certain settings in ElvUI!"
        )
        .. "\n\n",
    }, I.Requirements.GradientMode).args

    -- Enable
    generalGroup.enabled = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Toggling this on enables fancy gradients for " .. TXUI.Title .. ".\n\n" .. F.String.Error(
        "Warning: Enabling this setting will overwrite textures in ElvUI and Details!!"
      ),
      name = function()
        return self:GetEnableName(E.db.TXUI.themes.gradientMode.enabled, generalGroup)
      end,
      get = function()
        return E.db.TXUI.themes.gradientMode.enabled
      end,
      set = function(_, value)
        TXUI:GetModule("Themes"):Toggle("gradientMode", value)
      end,
    }
  end

  -- Shared description for every color group
  local shiftsDesc = function(what)
    return "Here you can change the " .. F.String.Class("gradient shifts", "MONK") .. " of " .. what .. ".\n\n"
  end

  -- Units
  do
    local tab = self:AddGroup(options, {
      name = "Units",
    }).args

    -- Class Colors
    do
      local colorGroup = self:AddInlineDesc(tab, {
        name = "Class Colors",
      }, {
        name = TXUI.Title
          .. " Gradient theme "
          .. F.String.Class("shifts", "MONK")
          .. " from one color to another. You can change the "
          .. F.String.Class("shifts", "MONK")
          .. " below.\n\n",
      }).args

      -- Get correct classname table
      local classNames = LOCALIZED_CLASS_NAMES_MALE
      if UnitSex("player") == 3 then classNames = LOCALIZED_CLASS_NAMES_FEMALE end

      local rows = {}
      for class, _ in pairs(P.themes.gradientMode.classColorMap[I.Enum.GradientMode.Color.SHIFT]) do
        if classNames[class] ~= nil then rows[#rows + 1] = { key = class, label = F.String.Class(classNames[class], class), sort = classNames[class] } end
      end

      self:AddGradientColorRows(colorGroup, "classColorMap", rows, "ThemesGradients.SettingsUpdate.Health")
    end

    self:AddSpacer(tab)

    -- NPC Colors
    do
      local colorGroup = self:AddInlineDesc(tab, {
        name = "NPC Colors",
      }, {
        name = shiftsDesc("NPC colors"),
      }).args

      -- Blizzard faction bar colors for the labels
      self:AddGradientColorRows(colorGroup, "reactionColorMap", {
        { key = "GOOD", label = F.String.RGB("Friendly", FACTION_BAR_COLORS[5]), sort = 1 },
        { key = "NEUTRAL", label = F.String.RGB("Neutral", FACTION_BAR_COLORS[4]), sort = 2 },
        { key = "BAD", label = F.String.RGB("Enemy", FACTION_BAR_COLORS[1]), sort = 3 },
      }, "ThemesGradients.SettingsUpdate.Health")
    end

    self:AddSpacer(tab)

    -- State Colors
    do
      local colorGroup = self:AddInlineDesc(tab, {
        name = "State Colors",
      }, {
        name = shiftsDesc("State colors"),
      }).args

      local rows = {}
      for special, _ in pairs(P.themes.gradientMode.specialColorMap[I.Enum.GradientMode.Color.SHIFT]) do
        local nameColor = P.themes.gradientMode.specialColorMap[I.Enum.GradientMode.Color.NORMAL][special]
        if special == "DEAD" then nameColor = F.Table.HexToRGB("#ffffff") end

        local label = F.String.LowercaseEnum(special)
        rows[#rows + 1] = { key = special, label = F.String.RGB(label, nameColor), sort = label }
      end

      self:AddGradientColorRows(colorGroup, "specialColorMap", rows, "ThemesGradients.SettingsUpdate.Health")
    end
  end

  -- Bars
  do
    local tab = self:AddGroup(options, {
      name = "Bars",
    }).args

    -- Power Colors
    do
      local colorGroup = self:AddInlineDesc(tab, {
        name = "Power Colors",
      }, {
        name = shiftsDesc("Power colors"),
      }).args

      local wrathExcluded = {
        ["PAIN"] = true,
        ["FURY"] = true,
        ["LUNAR_POWER"] = true,
        ["INSANITY"] = true,
        ["MAELSTROM"] = true,
      }

      local rows = {}
      for power, _ in pairs(P.themes.gradientMode.powerColorMap[I.Enum.GradientMode.Color.SHIFT]) do
        if TXUI.IsRetail or (TXUI.IsClassic and wrathExcluded[power] == nil) then
          local colorIndex = (power == "ALT_POWER") and "MANA" or power
          local label = F.String.LowercaseEnum(power)
          rows[#rows + 1] = { key = power, label = F.String.RGB(label, { F.CalculateMultiplierColorArray(1.35, PowerBarColor[colorIndex]) }), sort = label }
        end
      end

      self:AddGradientColorRows(colorGroup, "powerColorMap", rows, "ThemesGradients.SettingsUpdate.Power")
    end

    self:AddSpacer(tab)

    -- Castbar Colors
    do
      local colorGroup = self:AddInlineDesc(tab, {
        name = "Castbar Colors",
      }, {
        name = shiftsDesc("Castbar colors"),
      }).args

      local castNormal = P.themes.gradientMode.castColorMap[I.Enum.GradientMode.Color.NORMAL]
      self:AddGradientColorRows(colorGroup, "castColorMap", {
        { key = "DEFAULT", label = F.String.RGB("Regular", castNormal.DEFAULT), sort = 1 },
        { key = "NOINTERRUPT", label = F.String.RGB("Non-interruptible", castNormal.NOINTERRUPT), sort = 2 },
      }, "ThemesGradients.SettingsUpdate")
    end
  end

  -- Fade Direction
  do
    local name = "Fade Direction"

    -- Tab
    local tab = self:AddGroup(options, {
      name = name,
    }).args

    local directionValues = {
      [I.Enum.GradientMode.Direction.LEFT] = "Left",
      [I.Enum.GradientMode.Direction.RIGHT] = "Right",
    }

    local function directionGet(unitType)
      return function()
        return E.db.TXUI.themes.gradientMode.fadeDirection[unitType]
      end
    end

    local function directionSet(unitType)
      return function(_, value)
        if E.db.TXUI.themes.gradientMode.fadeDirection[unitType] == value then return end
        E.db.TXUI.themes.gradientMode.fadeDirection[unitType] = value
        F.Event.TriggerEvent("ThemesGradients.SettingsUpdate")
        F.Event.TriggerEvent("ThemesGradients.SettingsUpdate.Health")
        F.Event.TriggerEvent("ThemesGradients.SettingsUpdate.Power", true)
      end
    end

    -- Player & Target
    do
      local group = self:AddInlineDesc(tab, {
        name = "Player & Target",
      }, {
        name = "Control the gradient fade direction for player and target unitframes.\n\n",
      }).args

      group.player = {
        order = self:GetOrder(),
        type = "select",
        name = "Player",
        values = directionValues,
        get = directionGet("player"),
        set = directionSet("player"),
      }

      group.pet = {
        order = self:GetOrder(),
        type = "select",
        name = "Pet",
        values = directionValues,
        get = directionGet("pet"),
        set = directionSet("pet"),
      }

      group.target = {
        order = self:GetOrder(),
        type = "select",
        name = "Target",
        values = directionValues,
        get = directionGet("target"),
        set = directionSet("target"),
      }

      group.targettarget = {
        order = self:GetOrder(),
        type = "select",
        name = "Target of Target",
        values = directionValues,
        get = directionGet("targettarget"),
        set = directionSet("targettarget"),
      }

      group.focus = {
        order = self:GetOrder(),
        type = "select",
        name = "Focus",
        values = directionValues,
        get = directionGet("focus"),
        set = directionSet("focus"),
      }
    end

    -- Spacer
    self:AddSpacer(tab)

    -- Group Frames
    do
      local group = self:AddInlineDesc(tab, {
        name = "Group Frames",
      }, {
        name = "Control the gradient fade direction for party and raid unitframes.\n\n",
      }).args

      group.party = {
        order = self:GetOrder(),
        type = "select",
        name = "Party",
        values = directionValues,
        get = directionGet("party"),
        set = directionSet("party"),
      }

      group.raid1 = {
        order = self:GetOrder(),
        type = "select",
        name = "Raid 1",
        values = directionValues,
        get = directionGet("raid1"),
        set = directionSet("raid1"),
      }

      group.raid2 = {
        order = self:GetOrder(),
        type = "select",
        name = "Raid 2",
        values = directionValues,
        get = directionGet("raid2"),
        set = directionSet("raid2"),
      }

      group.raid3 = {
        order = self:GetOrder(),
        type = "select",
        name = "Raid 3",
        values = directionValues,
        get = directionGet("raid3"),
        set = directionSet("raid3"),
      }
    end

    -- Spacer
    self:AddSpacer(tab)

    -- Boss & Arena
    do
      local group = self:AddInlineDesc(tab, {
        name = "Boss & Arena",
      }, {
        name = "Control the gradient fade direction for boss and arena unitframes.\n\n",
      }).args

      group.boss = {
        order = self:GetOrder(),
        type = "select",
        name = "Boss",
        values = directionValues,
        get = directionGet("boss"),
        set = directionSet("boss"),
      }

      group.arena = {
        order = self:GetOrder(),
        type = "select",
        name = "Arena",
        values = directionValues,
        get = directionGet("arena"),
        set = directionSet("arena"),
      }
    end

    -- Spacer
    self:AddSpacer(tab)

    -- Role Frames
    do
      local group = self:AddInlineDesc(tab, {
        name = "Role Frames",
      }, {
        name = "Control the gradient fade direction for tank and assist unitframes.\n\n",
      }).args

      group.tank = {
        order = self:GetOrder(),
        type = "select",
        name = "Tank",
        values = directionValues,
        get = directionGet("tank"),
        set = directionSet("tank"),
      }

      group.tanktarget = {
        order = self:GetOrder(),
        type = "select",
        name = "Tank Target",
        values = directionValues,
        get = directionGet("tanktarget"),
        set = directionSet("tanktarget"),
      }

      group.assist = {
        order = self:GetOrder(),
        type = "select",
        name = "Assist",
        values = directionValues,
        get = directionGet("assist"),
        set = directionSet("assist"),
      }

      group.assisttarget = {
        order = self:GetOrder(),
        type = "select",
        name = "Assist Target",
        values = directionValues,
        get = directionGet("assisttarget"),
        set = directionSet("assisttarget"),
      }
    end
  end

  -- Settings
  do
    local name = "Settings"

    -- Tab
    local tab = self:AddGroup(options, {
      name = name,
    }).args

    -- Settings Group
    self:AddInlineDesc(tab, {
      name = name,
    }, {
      name = "Here you can change additional settings for the " .. gradientTitle .. " Mode|r.\n\n",
    })

    -- Spacer
    self:AddSpacer(tab)

    do
      local texturesGroup = self:AddInlineDesc(tab, {
        name = "UnitFrame Textures",
      }, {
        name = "Change the textures used for UnitFrame's Health, Power and Cast status bars.",
      }).args

      texturesGroup.health = ACH:SharedMediaStatusbar("Health Texture", "Health bar texture for UnitFrames", self:GetOrder(), 200, function()
        return E.db.TXUI.themes.gradientMode.textures.health
      end, function(_, value)
        E.db.TXUI.themes.gradientMode.textures.health = value
        F.Event.TriggerEvent("ThemesGradients.TexturesUpdate")
      end)

      texturesGroup.power = ACH:SharedMediaStatusbar("Power Texture", "Power bar texture for UnitFrames", self:GetOrder(), 200, function()
        return E.db.TXUI.themes.gradientMode.textures.power
      end, function(_, value)
        E.db.TXUI.themes.gradientMode.textures.power = value
        F.Event.TriggerEvent("ThemesGradients.TexturesUpdate")
      end)

      texturesGroup.cast = ACH:SharedMediaStatusbar("Castbar Texture", "Castbar texture for UnitFrames", self:GetOrder(), 200, function()
        return E.db.TXUI.themes.gradientMode.textures.cast
      end, function(_, value)
        E.db.TXUI.themes.gradientMode.textures.cast = value
        F.Event.TriggerEvent("ThemesGradients.TexturesUpdate")
      end)
    end

    -- Spacer
    self:AddSpacer(tab)

    do
      local brightnessGroup = self:AddInlineDesc(tab, {
        name = "Background Brightness",
        get = function(info)
          return E.db.TXUI.themes.gradientMode[info[#info]]
        end,
        set = function(info, value)
          if E.db.TXUI.themes.gradientMode[info[#info]] == value then return end

          E.db.TXUI.themes.gradientMode[info[#info]] = value
          F.Event.TriggerEvent("ThemesGradients.SettingsUpdate.Health")
          F.Event.TriggerEvent("ThemesGradients.SettingsUpdate.Power", true)
        end,
      }, {
        name = "This controls the strength of the background colors.\n\nLower value means a darker background, higher value means a lighter background.\n\n",
      }).args

      -- Background Multiplier Size
      brightnessGroup.backgroundMultiplier = {
        order = self:GetOrder(),
        type = "range",
        name = "",
        min = 0,
        max = 0.5,
        step = 0.01,
        isPercent = true,
        width = 2,
      }
    end

    -- Spacer
    self:AddSpacer(tab)

    -- Saturation Boost
    local saturationGroup = self:AddInlineDesc(tab, {
      name = "Saturation Boost",
      get = function(info)
        return E.db.TXUI.themes.gradientMode.saturationBoost[info[#info]]
      end,
      set = function(info, value)
        if E.db.TXUI.themes.gradientMode.saturationBoost[info[#info]] == value then return end

        E.db.TXUI.themes.gradientMode.saturationBoost[info[#info]] = value
        F.Event.TriggerEvent("ThemesGradients.SettingsUpdate.Health")
        F.Event.TriggerEvent("ThemesGradients.SettingsUpdate.Power", true)
      end,
    }, {
      name = "Boosts the saturation and darkens " .. gradientTitle .. " Colors|r\nFor people that like it a bit more extreme\n\n",
    }).args

    saturationGroup.enabled = {
      order = self:GetOrder(),
      type = "toggle",
      name = function()
        return self:GetEnableName(E.db.TXUI.themes.gradientMode.saturationBoost.enabled, saturationGroup)
      end,
    }

    saturationGroup.shiftLight = {
      order = self:GetOrder(),
      type = "range",
      name = "Shift Lightness",
      desc = "Control the Lightness value of HSL for the Shift color.",
      min = 0.1,
      max = 2,
      step = 0.01,
    }

    saturationGroup.shiftSat = {
      order = self:GetOrder(),
      type = "range",
      name = "Shift Saturation",
      desc = "Control the Saturation value of HSL for the Shift color.",
      min = 0.1,
      max = 1,
      step = 0.01,
    }

    saturationGroup.normalLight = {
      order = self:GetOrder(),
      type = "range",
      name = "Normal Lightness",
      desc = "Control the Lightness value of HSL for the Normal color.",
      min = 0.1,
      max = 2,
      step = 0.01,
    }

    saturationGroup.normalSat = {
      order = self:GetOrder(),
      type = "range",
      name = "Normal Saturation",
      desc = "Control the Saturation value of HSL for the Normal color.",
      min = 0.1,
      max = 1,
      step = 0.01,
    }

    -- Spacer
    self:AddSpacer(tab)
  end
end

O:AddCallback("ToxiUI_Themes_GradientMode")
