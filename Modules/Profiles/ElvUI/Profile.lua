local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local PF = TXUI:GetModule("Profiles")

local ipairs = ipairs
local next = next

function PF:BuildColorsProfile()
  local pf = {
    unitframe = {
      colors = {},
    },
    nameplates = {
      colors = {},
    },
  }

  local castColor = F.Table.HexToRGB("#ffb300")
  local castNoInterrupt = F.Table.HexToRGB("#808080")
  local castInterruptedColor = F.Table.HexToRGB("#ff1a1a")

  -- Power colors (for Dark and Normal modes)
  -- Should be the same as colors in Core/Profile.lua
  -- [I.Enum.GradientMode.Color.NORMAL]
  local power = {
    ALT_POWER = F.Table.HexToRGB("#2175d4"), -- swap alt
    MANA = F.Table.HexToRGB("#35a4ff"), -- mana
    RAGE = F.Table.HexToRGB("#ed3333"), -- rage
    FOCUS = F.Table.HexToRGB("#db753b"), -- focus
    ENERGY = F.Table.HexToRGB("#ffe169"), -- energy
    RUNIC_POWER = F.Table.HexToRGB("#1cd6ff"), -- runic
    PAIN = F.Table.HexToRGB("#f5f5f5"), -- pain
    FURY = F.Table.HexToRGB("#e81ff5"), -- fury
    LUNAR_POWER = F.Table.HexToRGB("#9c54ff"), -- astral
    INSANITY = F.Table.HexToRGB("#9629bd"), -- insanity
    MAELSTROM = F.Table.HexToRGB("#0096ff"), -- maelstrom
  }

  local classResources = {
    ["DEATHKNIGHT"] = {
      [1] = F.Table.HexToRGB("#e51a46"), -- Blood
      [2] = F.Table.HexToRGB("#00acff"), -- Frost
      [3] = F.Table.HexToRGB("#09d858"), -- Unholy
    },
  }

  F.Table.Crush(pf.unitframe.colors, {
    -- UnitFrames Colors CastBar
    castColor = castColor,
    castNoInterrupt = castNoInterrupt,
    castInterruptedColor = castInterruptedColor,

    -- UnitFrames Colors
    borderColor = F.Table.HexToRGB("#000000"),
    disconnected = F.Table.HexToRGB("#ff9387"),
    health = F.ChooseForTheme(F.Table.HexToRGB("#000000"), F.Table.HexToRGB("#1d1d1d")),
    health_backdrop = F.ChooseForTheme(F.Table.HexToRGB("#000000"), F.Table.HexToRGB("#505050")),
    health_backdrop_dead = F.ChooseForTheme(F.Table.HexToRGB("#61000e"), F.Table.HexToRGB("#9c0c00")),

    -- UnitFrames Colors Options
    classbackdrop = F.ChooseForTheme(false, true),
    colorhealthbyvalue = false,
    useDeadBackdrop = true,
    transparentPower = false,
    healthclass = F.ChooseForTheme(true, false),
    customhealthbackdrop = false,
    castClassColor = true,

    -- UnitFrames Colors heal prediction
    healPrediction = {
      absorbs = F.Table.HexToRGB("#ff00f180"),
      overabsorbs = F.Table.HexToRGB("#ff00c180"),
      maxOverflow = 1,
    },

    -- UnitFrame Colors MouseOver Glow
    frameGlow = {
      mouseoverGlow = {
        texture = I.Textures.Primary,
      },
    },

    power = power,
    classResources = classResources,
  })

  -- Nameplates Colors
  F.Table.Crush(pf.nameplates.colors, {
    castColor = castColor,
    castNoInterruptColor = castNoInterrupt,
    castInterruptedColor = castInterruptedColor,
    power = power,
    classResources = classResources,
  })

  return pf
end

function PF:BuildProfile()
  -- Setup Local Tables
  local pf = {
    actionbar = {},
    auras = {
      buffs = {},
      debuffs = {},
    },
    bags = {},
    chat = {},
    cooldown = {},
    databars = {},
    datatexts = {
      panels = {},
    },
    general = {},
    movers = {},
    nameplates = {
      colors = {},
    },
    tooltip = {},
    unitframe = {
      colors = {},
      units = {},
    },
  }

  local colors = self:BuildColorsProfile()

  -- Setup Unit Tables & Disable Info Panel
  for _, unit in
    next,
    {
      "player",
      "target",
      "targettarget",
      "targettargettarget",
      "focus",
      "focustarget",
      "pet",
      "pettarget",
      "boss",
      "arena",
      "party",
      "raid1",
      "raid2",
      "raid3",
      "raidpet",
      "tank",
      "assist",
    }
  do
    pf.unitframe.units[unit] = {
      infoPanel = {
        enable = false,
      },
    }
  end

  -- Setup DataBars Tables & Disable DataBars
  for _, databar in next, { "experience", "reputation", "honor", "threat", "azerite", "petExperience" } do
    pf.databars[databar] = {
      enable = false,
    }
  end

  -- Setup DataText Panels Tables & Disable Panels
  for _, panel in next, { "LeftChatDataPanel", "RightChatDataPanel", "MinimapPanel" } do
    pf.datatexts.panels[panel] = {
      enable = false,
    }
  end

  local IsHorizontalLayout = E.db.TXUI.installer.layout == I.Enum.Layouts.HORIZONTAL

  -- Movers
  self:ApplyMovers(pf, IsHorizontalLayout)

  -- General
  self:ApplyGeneral(pf)

  -- Cooldowns
  self:ApplyCooldowns(pf)

  -- Tooltip
  self:ApplyTooltip(pf)

  -- Bags
  self:ApplyBags(pf)

  -- Chat
  self:ApplyChat(pf)

  -- Auras
  self:ApplyAuras(pf)

  -- Nameplates
  self:ApplyNameplates(pf, colors)

  -- UnitFrames
  self:ApplyUnitframes(pf, colors, IsHorizontalLayout)

  -- ActionBars
  self:ApplyActionbars(pf)

  -- ! IMPORTANT ! --
  pf.dbConverted = E.version
  pf.actionbar.convertPages = false -- just don't !
  pf.convertPages = true -- don't you dare fuck the action bars up again
  pf.general.taintLog = false
  -- ! --
  return pf
end

function PF:BuildPrivateProfile()
  local isBagsEnabled = true
  local isChatEnabled = true

  local BAG_ADDONS = { "Bagnon", "BetterBags", "Baggins", "Sorted", "Inventorian", "Baganator", "ArkInventory", "OneBag3", "Combuctor" }
  local CHAT_ADDONS = { "Chattynator" }

  for _, addon in ipairs(BAG_ADDONS) do
    if F.IsAddOnEnabled(addon) then isBagsEnabled = false end
  end

  for _, addon in ipairs(CHAT_ADDONS) do
    if F.IsAddOnEnabled(addon) then isChatEnabled = false end
  end

  return {
    -- General
    general = {
      chatBubbles = "nobackdrop",
      raidUtility = true,
      totemTracker = false,
      glossTex = I.Textures.Primary, -- Secondary Texture
      normTex = I.Textures.Primary,
      classColors = TXUI.IsClassicEra,

      minimap = {
        hideClassHallReport = false,
        hideTracking = true,
      },
    },

    -- NamePlates ElvUI
    nameplates = {
      enable = true,
    },

    -- Chat
    chat = {
      enable = isChatEnabled,
    },

    bags = {
      enable = isBagsEnabled,
    },

    -- Skins
    skins = {
      parchmentRemoverEnable = true,

      blizzard = {
        weeklyRewards = false,
        damageMeter = true,
        cooldownManager = true,
      },
    },
  }
end

function PF:ElvUIProfilePrivate()
  F.Table.Crush(E.private, self:BuildPrivateProfile())
end

function PF:BuildGlobalProfile()
  return {
    -- General
    general = {
      ultrawide = false,

      WorldMapCoordinates = {
        position = "BOTTOMRIGHT",
      },

      AceGUI = {
        width = 1440,
        height = 810,
      },
    },
  }
end

function PF:ElvUIProfileGlobal()
  F.Table.Crush(E.global, self:BuildGlobalProfile())
end

function PF:UpdateProfileForGradient()
  -- Set fade directions based on current layout
  local layouts = I.GradientMode.Layouts[E.db.TXUI.installer.layout]
  if layouts then
    for unitType in pairs(P.themes.gradientMode.fadeDirection) do
      if layouts.Left[unitType] then
        E.db.TXUI.themes.gradientMode.fadeDirection[unitType] = I.Enum.GradientMode.Direction.LEFT
      else
        E.db.TXUI.themes.gradientMode.fadeDirection[unitType] = I.Enum.GradientMode.Direction.RIGHT
      end
    end
  end
end

function PF:UpdateProfileForTheme()
  local pf = self:BuildProfile()

  -- UnitFrame Color Options
  F.UpdateDBFromPath(pf, "unitframe.colors", "classbackdrop")
  F.UpdateDBFromPath(pf, "unitframe.colors", "healthclass")
  -- UnitFrame Colors
  F.UpdateDBFromPathRGB(pf, "unitframe.colors.health")
  F.UpdateDBFromPathRGB(pf, "unitframe.colors.health_backdrop")
  F.UpdateDBFromPathRGB(pf, "unitframe.colors.health_backdrop_dead")
end
