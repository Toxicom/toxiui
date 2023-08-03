local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

-- Defaults
P.installer = {
  layout = I.Enum.Layouts.DPS,
}

P.changelog = {
  seenVersion = 0,
  releaseVersion = 0,
  lastLayoutVersion = 0,
  lastDBConversion = 0,
}

-- General
P.general = {
  overrideDevMode = true, -- force disable dev mode
  chatBadgeOverride = false,

  fontOverride = {
    [I.Fonts.Primary] = "DEFAULT",
    [I.Fonts.PrimaryBold] = "DEFAULT",
    [I.Fonts.Title] = "DEFAULT",
    [I.Fonts.TitleSecondary] = "DEFAULT",
    [I.Fonts.Number] = "DEFAULT",
    [I.Fonts.BigNumber] = "DEFAULT",
  },

  fontStyleOverride = {
    [I.Fonts.Primary] = "DEFAULT",
    [I.Fonts.PrimaryBold] = "DEFAULT",
    [I.Fonts.Title] = "DEFAULT",
    [I.Fonts.TitleSecondary] = "DEFAULT",
    [I.Fonts.Number] = "DEFAULT",
    [I.Fonts.BigNumber] = "DEFAULT",
  },

  fontShadowOverride = {
    [I.Fonts.Primary] = "DEFAULT",
    [I.Fonts.PrimaryBold] = "DEFAULT",
    [I.Fonts.Title] = "DEFAULT",
    [I.Fonts.TitleSecondary] = "DEFAULT",
    [I.Fonts.Number] = "DEFAULT",
    [I.Fonts.BigNumber] = "DEFAULT",
  },
}

-- Themes
P.themes = {
  darkMode = {
    enabled = false, -- Disabled by default
    transparency = false, -- Disabled by default
    transparencyAlpha = 0.7, -- Alpha of Background
  },
  gradientMode = {
    enabled = true, -- Enabled by default

    texture = E.media.blankTex,
    backgroundMultiplier = 0.35,

    interruptCDEnabled = false,
    interruptSoonEnabled = false,

    saturationBoost = false,

    reactionColorMap = {
      [I.Enum.GradientMode.Color.NORMAL] = { -- RIGHT
        BAD = F.Table.HexToRGB("#d94040"), -- enemy
        NEUTRAL = F.Table.HexToRGB("#dec24a"), -- neutral
        GOOD = F.Table.HexToRGB("#85d92b"), -- friendly
      },
      [I.Enum.GradientMode.Color.SHIFT] = { -- LEFT
        BAD = F.Table.HexToRGB("#c72121"), -- enemy
        NEUTRAL = F.Table.HexToRGB("#cf9145"), -- neutral
        GOOD = F.Table.HexToRGB("#2f9706"), -- friendly
      },
    },

    castColorMap = {
      [I.Enum.GradientMode.Color.NORMAL] = { -- RIGHT
        DEFAULT = F.Table.HexToRGB("#ffbf00"), -- cast def.
        NOINTERRUPT = F.Table.HexToRGB("#8f8c8c"), -- cast non.
        INTERRUPTED = F.Table.HexToRGB("#d94040"), -- cast was stopped
        INTERRUPTCD = F.Table.HexToRGB("#8591b0"), -- interrupt is on cd, and will not come off cd during cast
        INTERRUPTSOON = F.Table.HexToRGB("#de7000"), -- interrupt is on cd, but will be ready inside the cast
      },
      [I.Enum.GradientMode.Color.SHIFT] = { -- LEFT
        DEFAULT = F.Table.HexToRGB("#ffad00"), -- cast def.
        NOINTERRUPT = F.Table.HexToRGB("#737070"), -- cast non.
        INTERRUPTED = F.Table.HexToRGB("#991f1f"), -- cast was stopped
        INTERRUPTCD = F.Table.HexToRGB("#4f5c7a"), -- interrupt is on cd, and will not come off cd during cast
        INTERRUPTSOON = F.Table.HexToRGB("#8f4700"), -- interrupt is on cd, but will be ready inside the cast
      },
    },

    powerColorMap = {
      [I.Enum.GradientMode.Color.NORMAL] = { -- RIGHT
        ALT_POWER = F.Table.HexToRGB("#2175d4"), -- swap alt
        MANA = F.Table.HexToRGB("#42d9d1"), -- mana
        RAGE = F.Table.HexToRGB("#ed3333"), -- rage
        FOCUS = F.Table.HexToRGB("#db753b"), -- focus
        ENERGY = F.Table.HexToRGB("#d9d92b"), -- energy
        RUNIC_POWER = F.Table.HexToRGB("#1cd6ff"), -- runic
        PAIN = F.Table.HexToRGB("#f5f5f5"), -- pain
        FURY = F.Table.HexToRGB("#e81ff5"), -- fury
        LUNAR_POWER = F.Table.HexToRGB("#9c54ff"), -- astral
        INSANITY = F.Table.HexToRGB("#9629bd"), -- insanity
        MAELSTROM = F.Table.HexToRGB("#0096ff"), -- maelstrom
      },
      [I.Enum.GradientMode.Color.SHIFT] = { -- LEFT
        ALT_POWER = F.Table.HexToRGB("#264ad1"), -- swap alt
        MANA = F.Table.HexToRGB("#0ac7de"), -- mana
        RAGE = F.Table.HexToRGB("#cf1717"), -- rage
        FOCUS = F.Table.HexToRGB("#cf591f"), -- focus
        ENERGY = F.Table.HexToRGB("#d1b800"), -- energy
        RUNIC_POWER = F.Table.HexToRGB("#009cff"), -- runic
        PAIN = F.Table.HexToRGB("#cccccc"), -- pain
        FURY = F.Table.HexToRGB("#c414b5"), -- fury
        LUNAR_POWER = F.Table.HexToRGB("#9e4fe8"), -- astral
        INSANITY = F.Table.HexToRGB("#850ab0"), -- insanity
        MAELSTROM = F.Table.HexToRGB("#0073ff"), -- maelstrom
      },
    },

    specialColorMap = {
      [I.Enum.GradientMode.Color.NORMAL] = { -- RIGHT
        DISCONNECTED = F.Table.HexToRGB("#ff6b59"), -- disconnect
        TAPPED = F.Table.HexToRGB("#a3a6b0"), -- tapped
        DEAD = F.Table.HexToRGB("#cd001c"), -- dead
      },
      [I.Enum.GradientMode.Color.SHIFT] = { -- LEFT
        DISCONNECTED = F.Table.HexToRGB("#e85747"), -- disconnect
        TAPPED = F.Table.HexToRGB("#7d828f"), -- tapped
        DEAD = F.Table.HexToRGB("#61000e"), -- dead
      },
    },

    classColorMap = {
      [I.Enum.GradientMode.Color.NORMAL] = { -- RIGHT
        DEATHKNIGHT = F.Table.HexToRGB("#f52652"),
        DEMONHUNTER = F.Table.HexToRGB("#ba00f5"),
        DRUID = F.Table.HexToRGB("#ff7d0a"),
        EVOKER = F.Table.HexToRGB("#44c5aa"),
        HUNTER = F.Table.HexToRGB("#abed4f"),
        MAGE = F.Table.HexToRGB("#33c7fc"),
        MONK = F.Table.HexToRGB("#00ff96"),
        PALADIN = F.Table.HexToRGB("#f58cba"),
        PRIEST = F.Table.HexToRGB("#ffffff"),
        ROGUE = F.Table.HexToRGB("#fff368"),
        SHAMAN = F.Table.HexToRGB("#0a7ded"),
        WARLOCK = F.Table.HexToRGB("#8561ed"),
        WARRIOR = F.Table.HexToRGB("#e0a361"),
      },
      [I.Enum.GradientMode.Color.SHIFT] = { -- LEFT
        DEATHKNIGHT = F.Table.HexToRGB("#ba1c2b"),
        DEMONHUNTER = F.Table.HexToRGB("#b3008a"),
        DRUID = F.Table.HexToRGB("#ff5e0a"),
        EVOKER = F.Table.HexToRGB("#2c7e6c"),
        HUNTER = F.Table.HexToRGB("#99cc54"),
        MAGE = F.Table.HexToRGB("#0599cf"),
        MONK = F.Table.HexToRGB("#05bf73"),
        PALADIN = F.Table.HexToRGB("#d9548f"),
        PRIEST = F.Table.HexToRGB("#d1d1d1"),
        ROGUE = F.Table.HexToRGB("#ffb759"),
        SHAMAN = F.Table.HexToRGB("#0061bf"),
        WARLOCK = F.Table.HexToRGB("#634aad"),
        WARRIOR = F.Table.HexToRGB("#c78c4a"),
      },
    },
  },
}

-- AddOn Skinning
P.addons = {
  -- ElvUI Theme
  elvUITheme = {
    enabled = false, -- Disabled by default

    shadowEnabled = true,
    shadowAlpha = 0.65,
    shadowSize = 3,
  },

  -- ElvUI Fonts
  fontScale = 0,

  -- AFK Mode
  afkMode = {
    enabled = true, -- Enabled by default
    turnCamera = true,
    playEmotes = true,
  },

  -- Deconstruct
  deconstruct = {
    enabled = true, -- Enabled by default
    highlightMode = "DARK", -- DARK by default, possible "NONE", "DARK", "ALPHA"

    animations = true,
    animationsMult = 1, -- Animation speed, higher than 1 => slower, lower than 1 => faster
    -- This applies to bar combat fadeIn/fadeOut and "normal" font color changes (not clock/txui button etc)

    glowEnabled = true, -- Enabled by default
    glowAlpha = 1,

    labelEnabled = true, -- Enabled by default
    labelFont = I.Fonts.Number,
    labelFontSize = 20,
    labelFontShadow = false,
    labelFontOutline = "OUTLINE",
  },

  -- Game Menu Button
  gameMenuButton = {
    enabled = true, -- Enabled by default
  },

  -- Fade Persist
  fadePersist = {
    enabled = true, -- Enabled by default
    mode = "MOUSEOVER", -- MOUSEOVER, NO_COMBAT, IN_COMBAT, ELVUI, ALWAYS
  },

  -- WeakAuras
  weakAurasBars = {
    enabled = true, -- Enabled by default
  },
  weakAurasIcons = {
    enabled = true, -- Enabled by default
    iconShape = I.Enum.IconShape.RECTANGLE,
  },
}

-- ElvUI Icons
P.elvUIIcons = {
  roleIcons = {
    enabled = true, -- Enabled by default
    theme = "TXUI_MATERIAL",
  },

  deadIcons = {
    enabled = true, -- Enabled by default
    theme = "TXUI_STYLIZED",
    size = 28, -- 36 for material/original
    xOffset = 0,
    yOffset = 5,
  },

  offlineIcons = {
    enabled = true, -- Enabled by default
    theme = "TXUI_STYLIZED",
    size = 28, -- 36 for material/original
    xOffset = 0,
    yOffset = 5,
  },
}

-- Blizzard Fonts
P.blizzardFonts = {
  enabled = true, -- Enabled by default

  -- Zone
  zoneFont = I.Fonts.Primary,
  zoneFontSize = 33,
  zoneFontShadow = true,
  zoneFontOutline = "NONE",

  -- Sub-Zone
  subZoneFont = I.Fonts.Primary,
  subZoneFontSize = 32,
  subZoneFontShadow = true,
  subZoneFontOutline = "NONE",

  -- PvP-Zone
  pvpZoneFont = I.Fonts.Primary,
  pvpZoneFontSize = 22,
  pvpZoneFontShadow = true,
  pvpZoneFontOutline = "NONE",

  -- Mail Text
  mailFont = I.Fonts.Primary,
  mailFontSize = 14,
  mailFontShadow = false, -- dosen't support shadows
  mailFontOutline = "NONE",

  -- Gossip/Quest Text
  gossipFont = I.Fonts.Primary,
  gossipFontSize = 14,
  gossipFontShadow = false, -- dosen't support shadows
  gossipFontOutline = "NONE",
}

-- VehicleBar
P.vehicleBar = {
  enabled = true,
  animations = true,
  animationsMult = 1, -- Animation speed, higher than 1 => slower, lower than 1 => faster
  -- This applies to bar combat fadeIn/fadeOut and "normal" font color changes (not clock/txui button etc)
  dragonRiding = true,

  position = "BOTTOM,ElvUIParent,BOTTOM,0,210",
}

-- MiniMapCoords
P.miniMapCoords = {
  enabled = true,
  xOffset = 0,
  yOffset = -115,
  format = "%.0f",

  coordFont = I.Fonts.Number,
  coordFontSize = 22,
  coordFontShadow = false,
  coordFontOutline = "OUTLINE",
  coordFontColor = "CUSTOM", -- CLASS, TXUI, VALUE (ElvUI), CUSTOM
  coordFontCustomColor = F.Table.HexToRGB("#ffffffff"),
}

-- Armory
P.armory = {
  enabled = true, -- Enabled by default

  animations = true,
  animationsMult = 3.3333, -- Animation speed, higher than 1 => slower, lower than 1 => faster
  -- This applies to bar combat fadeIn/fadeOut and "normal" font color changes (not clock/txui button etc)

  background = {
    enabled = true, -- Enabled by default
    alpha = 0.5,
    style = 1,
  },

  stats = {
    showAvgItemLevel = true, -- Enabled by default
    itemLevelFormat = "%.2f",

    itemLevelFont = I.Fonts.Title,
    itemLevelFontSize = 30,
    itemLevelFontShadow = true,
    itemLevelFontOutline = "NONE",
    itemLevelFontColor = "GRADIENT", -- CLASS, TXUI, VALUE (ElvUI), CUSTOM, GRADIENT
    itemLevelFontCustomColor = F.Table.HexToRGB("#ffffffff"),

    headerFont = I.Fonts.Title,
    headerFontSize = 22,
    headerFontShadow = true,
    headerFontOutline = "NONE",
    headerFontColor = "GRADIENT", -- CLASS, TXUI, VALUE (ElvUI), CUSTOM
    headerFontCustomColor = F.Table.HexToRGB("#ffffffff"),

    labelFont = I.Fonts.Primary,
    labelFontSize = 12,
    labelFontShadow = true,
    labelFontOutline = "NONE",
    labelFontColor = "GRADIENT", -- CLASS, TXUI, VALUE (ElvUI), CUSTOM, GRADIENT
    labelFontCustomColor = F.Table.HexToRGB("#ffffffff"),

    valueFont = I.Fonts.Primary,
    valueFontSize = 15,
    valueFontShadow = true,
    valueFontOutline = "NONE",
    valueFontColor = "CUSTOM", -- CLASS, TXUI, VALUE (ElvUI), CUSTOM
    valueFontCustomColor = F.Table.HexToRGB("#ffffffff"),

    alternatingBackgroundEnabled = true, -- Enabled by default
    alternatingBackgroundAlpha = 0.5,

    -- Sets the mode for stats
    -- 0 (Hide), 1 (Smart/Blizzard), 2 (Always Show if not 0), 3 (Always Show)
    mode = {
      -- Attributes Category
      STRENGTH = {
        mode = 1,
      },
      AGILITY = {
        mode = 1,
      },
      INTELLECT = {
        mode = 1,
      },
      STAMINA = {
        mode = 1,
      },
      HEALTH = {
        mode = 0,
      },
      POWER = {
        mode = 0,
      },
      ARMOR = {
        mode = 0,
      },
      STAGGER = {
        mode = 0,
      },
      MANAREGEN = {
        mode = 0,
      },
      ENERGY_REGEN = {
        mode = 0,
      },
      RUNE_REGEN = {
        mode = 0,
      },
      FOCUS_REGEN = {
        mode = 0,
      },
      MOVESPEED = {
        mode = 1,
      },

      -- Enhancements Category
      ATTACK_DAMAGE = {
        mode = 0,
      },
      ATTACK_AP = {
        mode = 0,
      },
      ATTACK_ATTACKSPEED = {
        mode = 0,
      },
      SPELLPOWER = {
        mode = 0,
      },
      CRITCHANCE = {
        mode = 1,
      },
      HASTE = {
        mode = 1,
      },
      MASTERY = {
        mode = 1,
      },
      VERSATILITY = {
        mode = 1,
      },
      LIFESTEAL = {
        mode = 0,
      },
      AVOIDANCE = {
        mode = 0,
      },
      SPEED = {
        mode = 0,
      },
      DODGE = {
        mode = 0,
      },
      PARRY = {
        mode = 0,
      },
      BLOCK = {
        mode = 0,
      },
    },
  },

  pageInfo = {
    itemLevelTextEnabled = true,
    iconsEnabled = true,

    enchantTextEnabled = true,
    abbreviateEnchantText = true,
    missingEnchantText = true,
    missingSocketText = true,

    itemQualityGradientEnabled = true,
    itemQualityGradientWidth = 65,
    itemQualityGradientHeight = 3,
    itemQualityGradientStartAlpha = 1,
    itemQualityGradientEndAlpha = 0,

    iLvLFont = I.Fonts.Primary,
    iLvLFontSize = 14,
    iLvLFontShadow = true,
    iLvLFontOutline = "NONE",

    enchantFont = I.Fonts.Primary,
    enchantFontSize = 12,
    enchantFontShadow = true,
    enchantFontOutline = "NONE",
  },

  nameTextOffsetX = 0,
  nameTextOffsetY = 0,
  nameTextFont = I.Fonts.Title,
  nameTextFontSize = 22,
  nameTextFontShadow = true,
  nameTextFontOutline = "NONE",
  nameTextFontColor = "GRADIENT", -- CLASS, TXUI, VALUE (ElvUI), CUSTOM, GRADIENT
  nameTextFontCustomColor = F.Table.HexToRGB("#d6ba00ff"),

  titleTextOffsetX = 5,
  titleTextOffsetY = -2,
  titleTextFont = I.Fonts.Title,
  titleTextFontSize = 16,
  titleTextFontShadow = true,
  titleTextFontOutline = "NONE",
  titleTextFontColor = "GRADIENT", -- CLASS, TXUI, VALUE (ElvUI), CUSTOM, GRADIENT
  titleTextFontCustomColor = F.Table.HexToRGB("#d6ba00ff"),

  levelTitleTextOffsetX = 0,
  levelTitleTextOffsetY = -1,
  levelTitleTextFont = I.Fonts.Title,
  levelTitleTextFontSize = 20,
  levelTitleTextFontShadow = true,
  levelTitleTextFontOutline = "NONE",
  levelTitleTextFontColor = "CUSTOM", -- CLASS, TXUI, VALUE (ElvUI), CUSTOM
  levelTitleTextFontCustomColor = F.Table.HexToRGB("#d6ba00ff"),

  levelTextOffsetX = 0,
  levelTextOffsetY = -1,
  levelTextFont = I.Fonts.Title,
  levelTextFontSize = 24,
  levelTextFontShadow = true,
  levelTextFontOutline = "NONE",
  levelTextFontColor = "CUSTOM", -- CLASS, TXUI, VALUE (ElvUI), CUSTOM
  levelTextFontCustomColor = F.Table.HexToRGB("#d6ba00ff"),

  specIconFont = I.Fonts.Icons,
  specIconFontSize = 18,
  specIconFontShadow = true,
  specIconFontOutline = "NONE",
  specIconFontColor = "GRADIENT", -- CLASS, TXUI, VALUE (ElvUI), CUSTOM, GRADIENT
  specIconFontCustomColor = F.Table.HexToRGB("#d6ba00ff"),

  classTextOffsetX = 0,
  classTextOffsetY = -2,
  classTextFont = I.Fonts.Title,
  classTextFontSize = 20,
  classTextFontShadow = true,
  classTextFontOutline = "NONE",
  classTextFontColor = "GRADIENT", -- CLASS, TXUI, VALUE (ElvUI), CUSTOM, GRADIENT
  classTextFontCustomColor = F.Table.HexToRGB("#d6ba00ff"),
}

-- Wunderbar
P.wunderbar = {
  general = {
    enabled = true,

    experimentalDynamicSize = true,

    animations = true,
    animationsEvents = false,
    animationsMult = 1, -- Animation speed, higher than 1 => slower, lower than 1 => faster
    -- This applies to bar combat fadeIn/fadeOut and "normal" font color changes (not clock/txui button etc)

    barWidth = E.physicalWidth,
    barHeight = 30,
    barSpacing = 20, -- spacing from the screen edges, reduces the size of the 3 panels
    barVisibility = "NO_COMBAT", -- ALWAYS, NO_COMBAT, RESTING
    barMouseOverOnly = false,

    noCombatClick = true,
    noCombatHover = false,
    noHover = false,

    backgroundTexture = "TX WorldState Score",
    backgroundColor = "CLASS", -- NONE, CLASS, VALUE (ElvUI), CUSTOM
    backgroundCustomColor = F.Table.HexToRGB("#ffffff00"),
    backgroundGradient = true,
    backgroundGradientAlpha = 1,

    accentFontColor = "TXUI", -- CLASS, TXUI, VALUE (ElvUI), CUSTOM
    accentFontCustomColor = F.Table.HexToRGB("#ffffffff"),

    iconFont = I.Fonts.Icons,
    iconFontColor = "NONE", -- CLASS, TXUI, VALUE (ElvUI), CUSTOM
    iconFontCustomColor = F.Table.HexToRGB("#ffffffff"),

    normalFont = I.Fonts.Primary,
    normalFontSize = 14,
    normalFontShadow = true,
    normalFontOutline = "NONE",
    normalFontColor = "NONE", -- NONE, CLASS, TXUI, VALUE (ElvUI), CUSTOM
    normalFontCustomColor = F.Table.HexToRGB("#ffffffff"),
  },
  modules = {
    LeftPanel = { "MicroMenu", "", "" },
    MiddlePanel = { "SpecSwitch", "Time", "Profession" },
    RightPanel = { "Currency", "System", "Hearthstone" },
  },
  subModules = {
    Time = {
      localTime = true, -- this should be in sync with ElvUI profile for better tooltips
      twentyFour = GetCurrentRegion() ~= 1, -- sets 24h for everyone, except US
      timeFormat = "HH:MM", -- valid are HH:MM, H:MM, H:M

      showRestingAnimation = true,
      experimentalDynamicSize = false,

      textOffset = 1,
      mainFontSize = 32,
      useAccent = true,

      flashColon = true,
      flashOnInvite = true,

      infoEnabled = true,
      infoFont = I.Fonts.Primary,
      infoFontSize = 16,
      infoOffset = 24,
      infoUseAccent = true,
      infoTextDisplayed = {
        mail = true,
        date = true,
        ampm = false,
      },
    },
    System = {
      iconLatency = "",
      iconFramerate = "",
      iconColor = true,
      iconFontSize = 18,

      textColor = true,
      textColorFadeFromNormal = true,
      textColorLatencyThreshold = 60, -- or above
      textColorFramerateThreshold = 60, -- or under

      showIcons = true,
      fastUpdate = true,

      useWorldLatency = false,
    },
    DataBar = {
      mode = "auto",

      icon = "",
      iconFontSize = 18,

      infoEnabled = false,
      infoFont = I.Fonts.Primary,
      infoFontSize = 17,
      infoOffset = 13,
      infoUseAccent = true,

      showCompletedXP = false,
      showIcon = true,
      barHeight = 10,
      barOffset = 0,
    },
    Profession = {
      general = {
        useUppercase = true,

        selectedProf1 = 1, -- 0 = Disabled, 1 = Prof1, anything else = override
        selectedProf2 = 1, -- 0 = Disabled, 1 = Prof2, anything else = override

        iconFontSize = 18,

        showIcons = true,
        showBars = true,

        barHeight = 2,
        barOffset = -4,
        barSpacing = 4,
      },
      icons = {
        [164] = "", -- Blacksmithing
        [165] = "", -- Leatherworking
        [171] = "", -- Alchemy
        [182] = "", -- Herbalism
        [185] = "", -- Cooking
        [186] = "", -- Mining
        [202] = "", -- Engineering
        [333] = "", -- Enchanting
        [356] = "", -- Fishing
        [755] = "", -- Jewelcrafting
        [773] = "", -- Inscription
        [197] = "", -- Tailoring
        [393] = "", -- Skinning
        [794] = "", -- Archaeology
      },
    },
    Currency = {
      icon = "",
      iconFontSize = 18,

      displayedCurrency = "GOLD", -- NEEDS to be GOLD
      enabledCurrencies = {
        [1767] = true, -- Stygia
        [1828] = true, -- Soul Ash
        [1813] = true, -- Reservoir Anima
      }, -- Format: [currencyID] = true,

      showIcon = true,
      showSmall = true,
      showBagSpace = true,
      useGoldColors = true,
    },
    Volume = {
      showIcon = true,
      useUppercase = true,
      textColor = "GREEN", -- NONE, GREEN, ACCENT

      icon = "",
      iconColor = false,
      iconFontSize = 18,
    },
    Hearthstone = {
      showIcon = true,

      icon = "",
      iconColor = false,
      iconFontSize = 18,

      cooldownEnabled = true,
      cooldownFont = I.Fonts.Primary,
      cooldownFontSize = 18,
      cooldownOffset = 16,
      cooldownUseAccent = true,

      useUppercase = true,

      textColor = true,
      textColorFadeToNormal = true,

      primaryHS = 6948,
      secondaryHS = TXUI.IsRetail and 110560 or 6948,
      additionaHS = {},
    },
    Durability = {
      icon = "",
      iconColor = false,
      iconFontSize = 18,

      textColor = true,
      textColorFadeFromNormal = true,

      showIcon = true,
      showPerc = true,
      showItemLevel = true,
      itemLevelShort = true, -- hides decimal places

      animateLow = true,
      animateThreshold = 20,
    },
    SpecSwitch = {
      general = {
        useUppercase = true,

        showIcons = true,
        showSpec1 = true, -- active spec
        showSpec2 = false, -- loot spec

        iconFontSize = 18,

        infoEnabled = true,
        infoShowIcon = false,
        infoFont = I.Fonts.Primary,
        infoIcon = "",
        infoFontSize = 12,
        infoOffset = 18,
        infoUseAccent = true,
      },
      icons = {
        -- Retail
        [0] = "", -- unknown
        [62] = "", -- mage arcane
        [63] = "", -- mage fire
        [64] = "", -- mage frost
        [65] = "", -- pala holy
        [66] = "", -- pala prot
        [70] = "", -- pala ret
        [71] = "", -- warr arms
        [72] = "", -- warr fury
        [73] = "", -- warr prot
        [102] = "", -- drui balance
        [103] = "", -- drui feral
        [104] = "", -- drui bear
        [105] = "", -- drui resto
        [250] = "", -- dk blood
        [251] = "", -- dk frost
        [252] = "", -- dk unholy
        [253] = "", -- hun bm
        [254] = "", -- hun mm
        [255] = "", -- hun sv
        [256] = "", -- pri disc
        [257] = "", -- pri holy
        [258] = "", -- pri shadow
        [259] = "", -- rog ass
        [260] = "", -- rog outlaw
        [261] = "", -- rog sub
        [262] = "", -- sha ele
        [263] = "", -- sha enha
        [264] = "", -- sha resto
        [265] = "", -- lock affl
        [266] = "", -- lock demo
        [267] = "", -- lock destro
        [268] = "", -- monk brew
        [269] = "", -- monk wind
        [270] = "", -- monk mist
        [577] = "", -- dh havoc
        [581] = "", -- dh veng
        [1467] = "", -- ev devastation
        [1468] = "", -- ev preservation

        -- Wrath
        -- TODO: convert to spec ids
        [135932] = "", -- mage arcane
        [135810] = "", -- mage fire
        [135846] = "", -- mage frost
        [135920] = "", -- pala holy
        [135893] = "", -- pala prot
        [135873] = "", -- pala ret
        [132292] = "", -- warr arms
        [132347] = "", -- warr fury
        [134952] = "", -- warr prot
        [136096] = "", -- drui balance
        [132276] = "", -- drui feral
        -- [104] = "", -- drui bear, could be both for feral
        [136041] = "", -- drui resto
        [135770] = "", -- dk blood
        [135773] = "", -- dk frost
        [135775] = "", -- dk unholy
        [132164] = "", -- hun bm
        [132222] = "", -- hun mm
        [132215] = "", -- hun sv
        [135987] = "", -- pri disc
        -- [135920] = "", -- pri holy
        [136207] = "", -- pri shadow
        -- [132292] = "", -- rog ass
        [132090] = "", -- rog outlaw
        [132320] = "", -- rog sub
        [136048] = "", -- sha ele
        [136051] = "", -- sha enha
        [136052] = "", -- sha resto
        [136145] = "", -- lock affl
        [136172] = "", -- lock demo
        [136186] = "", -- lock destro
      },
    },
    MicroMenu = {
      general = {
        infoEnabled = true,
        infoFont = I.Fonts.Primary,
        infoFontSize = 18,
        infoOffset = 15,
        infoUseAccent = true,

        iconFontSize = 20,
        iconSpacing = 4,

        additionalTooltips = true,
        newbieToolips = true,
        onlyFriendsWoW = false,
        onlyFriendsWoWRetail = false,
      },
      icons = {
        menu = {
          enabled = true,
          icon = "",
        },
        chat = {
          enabled = true,
          icon = "",
        },
        guild = {
          enabled = true,
          icon = "",
        },
        social = {
          enabled = true,
          icon = "",
        },
        char = {
          enabled = true,
          icon = "",
        },
        spell = {
          enabled = true,
          icon = "",
        },
        talent = {
          enabled = true,
          icon = "",
        },
        ach = {
          enabled = true,
          icon = "",
        },
        quest = {
          enabled = true,
          icon = "",
        },
        lfg = {
          enabled = true,
          icon = "",
        },
        journal = {
          enabled = true,
          icon = "",
        },
        pvp = {
          enabled = true,
          icon = "",
          icon_a = "",
          icon_h = "",
        },
        pet = {
          enabled = true,
          icon = "",
        },
        shop = {
          enabled = true,
          icon = "",
        },
        help = {
          enabled = false,
          icon = "",
        },
        txui = {
          enabled = true,
          icon = "",
        },
      },
    },
    ElvUILDB = {
      useUppercase = true,
      textColor = false,
    },
  },
}
