local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

-- Defaults
P.installer = {
  layout = I.Enum.Layouts.VERTICAL,
}

-- Debug table
-- P.temp = {}

P.changelog = {
  seenVersion = 0,
  releaseVersion = 0,
  lastLayoutVersion = 0,
  lastDBConversion = 0,
}

P.disabledAddOns = {}

-- General
P.general = {
  overrideDevMode = true, -- force disable dev mode
  chatBadgeOverride = false,

  fontOverride = {
    [I.Fonts.Primary] = "DEFAULT",
    [I.Fonts.Title] = "DEFAULT",
    [I.Fonts.TitleBlack] = "DEFAULT",
    [I.Fonts.TitleRaid] = "DEFAULT",
  },

  fontStyleOverride = {
    [I.Fonts.Primary] = "DEFAULT",
    [I.Fonts.Title] = "DEFAULT",
    [I.Fonts.TitleBlack] = "DEFAULT",
    [I.Fonts.TitleRaid] = "DEFAULT",
  },

  fontShadowOverride = {
    [I.Fonts.Primary] = "DEFAULT",
    [I.Fonts.Title] = "DEFAULT",
    [I.Fonts.TitleBlack] = "DEFAULT",
    [I.Fonts.TitleRaid] = "DEFAULT",
  },
}

-- Styles
P.styles = {
  actionBars = "WeakAuras",
}

-- Themes
P.themes = {
  darkMode = {
    enabled = false, -- Disabled by default
    transparency = true, -- Enabled by default
    transparencyAlpha = 0.25, -- Alpha of Background
    gradientName = true,
    detailsGradientText = true,
  },
  gradientMode = {
    enabled = true, -- Enabled by default

    textures = {
      health = "- ToxiUI",
      power = "- ToxiUI",
      cast = "- ToxiUI",
    },

    backgroundMultiplier = 0.35,

    interruptCDEnabled = false,
    interruptSoonEnabled = false,

    colorHealth = {
      enabled = true,
      yellowThreshold = 75,
      redThreshold = 35,
    },

    saturationBoost = {
      enabled = false,
      shiftLight = 0.7,
      shiftSat = 1,
      normalLight = 1.3,
      normalSat = 0.9,
    },

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
      [I.Enum.GradientMode.Color.SHIFT] = { -- LEFT
        ALT_POWER = F.Table.HexToRGB("#264ad1"), -- swap alt
        MANA = F.Table.HexToRGB("#0040b3"), -- mana
        RAGE = F.Table.HexToRGB("#cf1717"), -- rage
        FOCUS = F.Table.HexToRGB("#cf591f"), -- focus
        ENERGY = F.Table.HexToRGB("#d9721a"), -- energy
        RUNIC_POWER = F.Table.HexToRGB("#009cff"), -- runic
        PAIN = F.Table.HexToRGB("#cccccc"), -- pain
        FURY = F.Table.HexToRGB("#c414b5"), -- fury
        LUNAR_POWER = F.Table.HexToRGB("#9e4fe8"), -- astral
        INSANITY = F.Table.HexToRGB("#850ab0"), -- insanity
        MAELSTROM = F.Table.HexToRGB("#0073ff"), -- maelstrom
      },

      [I.Enum.GradientMode.Color.NORMAL] = { -- RIGHT
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
        HUNTER = F.Table.HexToRGB("#4acc35"),
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
    enabled = true, -- Enabled by default

    shadowEnabled = true,
    shadowAlpha = 0.6,
    shadowSize = 4,
  },

  -- Color Modifier Keys
  colorModifiers = {
    enabled = true,
  },

  -- ElvUI Fonts
  fontScale = 0,

  -- AFK Mode
  afkMode = {
    enabled = true, -- Enabled by default
    turnCamera = true,
    playEmotes = true,
    showChangelog = true,
    showTips = true,

    specIconStyle = "ToxiSpecStylized",
    specIconSize = 20,
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
    labelFont = I.Fonts.Primary,
    labelFontSize = 16,
    labelFontShadow = false,
    labelFontOutline = "OUTLINE",
  },

  -- Game Menu Button
  gameMenuSkin = {
    enabled = true, -- Enabled by default

    bgColor = F.Table.HexToRGB("#00000080"),

    classColor = {
      enabled = false,
    },

    showInfo = true,
    showTips = true,
    showCollections = TXUI.IsRetail,

    showMythic = TXUI.IsRetail,
    showMythicScore = TXUI.IsRetail,
    mythicHistoryLimit = 4,

    specIconStyle = "ToxiSpecStylized",
    specIconSize = 20,
  },

  -- Fade Persist
  fadePersist = {
    enabled = true, -- Enabled by default
    mode = "MOUSEOVER", -- MOUSEOVER, NO_COMBAT, IN_COMBAT, ELVUI, ALWAYS
    showInVehicles = true,
  },
}

P.misc = {
  scaling = {
    enabled = false,

    characterFrame = {
      scale = 1,
    },

    dressingRoom = {
      scale = 1,
    },

    syncInspect = {
      enabled = false,
    },

    inspectFrame = {
      scale = 1,
    },

    map = {
      scale = 1,
    },

    wardrobe = {
      scale = 1,
    },

    itemUpgrade = {
      scale = 1,
    },

    equipmentFlyout = {
      scale = 2,
    },

    groupFinder = {
      scale = 1,
    },

    collections = {
      scale = 1,
    },

    talents = {
      scale = 1,
    },

    spellbook = {
      scale = 1,
    },

    vendor = {
      scale = 1,
    },

    gossip = {
      scale = 1,
    },

    quest = {
      scale = 1,
    },

    mailbox = {
      scale = 1,
    },

    profession = {
      scale = 1,
    },

    classTrainer = {
      scale = 1,
    },

    taxi = {
      scale = 1,
    },

    auctionHouse = {
      scale = 1,
    },

    retailTransmog = {
      enabled = true,
    },

    friends = {
      scale = 1,
    },
  },

  hide = {
    enabled = false,
    lootFrame = false,
  },

  raidInfo = {
    enabled = true,
    position = "TOP,ElvUIParent,TOP,0,0",
    size = 16,
    spacing = 4,
    padding = 6,
    backdropColor = { r = 0, g = 0, b = 0, a = 0.5 },
  },
}

-- ElvUI Icons
P.elvUIIcons = {
  roleIcons = {
    enabled = true, -- Enabled by default
    theme = "TXUI_MATERIAL",
  },

  raidIcons = {
    leader = {
      enabled = true, -- Enabled by default
      theme = "TXUI_MATERIAL",
    },

    assist = {
      enabled = true, -- Enabled by default
      theme = "TXUI_MATERIAL",
    },

    looter = {
      enabled = true, -- Enabled by default
      theme = "TXUI_MATERIAL",
    },

    mainAssist = {
      enabled = true, -- Enabled by default
      theme = "TXUI_MATERIAL",
    },

    mainTank = {
      enabled = true, -- Enabled by default
      theme = "TXUI_MATERIAL",
    },
  },

  classIcons = {
    theme = TXUI.IsRetail and "ToxiSpecStylized" or "ToxiClasses",
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
  enabled = false,
  buttonWidth = 48,
  animations = true,
  animationsMult = 1, -- Animation speed, higher than 1 => slower, lower than 1 => faster

  position = "BOTTOM,ElvUIParent,BOTTOM,0,210",

  vigorBar = {
    enabled = true,
    thrillColor = F.Table.HexToRGB("#00caff"),
    normalTexture = "- ToxiUI",
    darkTexture = "- Tx Half",
  },
}

-- MiniMapCoords
P.miniMapCoords = {
  enabled = true,
  xOffset = 0,
  yOffset = -115,
  format = "%.0f",

  coordFont = I.Fonts.TitleBlack,
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
    style = 2,
    class = true,
    hideControls = true,
  },

  lines = {
    enabled = true,
    alpha = 0.6,
    height = 1,
    color = "GRADIENT",
  },

  stats = {
    showAvgItemLevel = true, -- Enabled by default
    itemLevelFormat = "%.1f",

    itemLevelFont = TXUI.IsRetail and I.Fonts.TitleBlack or I.Fonts.Primary,
    itemLevelFontSize = TXUI.IsRetail and 20 or 12,
    itemLevelFontShadow = true,
    itemLevelFontOutline = "OUTLINE",
    itemLevelFontColor = "GRADIENT", -- CLASS, TXUI, VALUE (ElvUI), CUSTOM, GRADIENT
    itemLevelFontCustomColor = F.Table.HexToRGB("#ffffffff"),

    showIcons = true,
    iconFont = I.Fonts.Icons,
    iconFontSize = 14,
    iconFontShadow = false,
    iconFontOutline = "OUTLINE",
    iconFontColor = "TXUI",
    iconFontCustomColor = F.Table.HexToRGB("#ffffffff"),

    headerFont = I.Fonts.TitleRaid,
    headerFontSize = 14,
    headerFontShadow = false,
    headerFontOutline = "OUTLINE",
    headerFontColor = "CLASS_GRADIENT", -- CLASS, TXUI, VALUE (ElvUI), CUSTOM, CLASS_GRADIENT
    headerFontCustomColor = F.Table.HexToRGB("#ffffffff"),

    labelFont = I.Fonts.Primary,
    labelFontSize = 12,
    labelFontShadow = false,
    labelFontOutline = "OUTLINE",
    labelFontColor = "GRADIENT", -- CLASS, TXUI, VALUE (ElvUI), CUSTOM, GRADIENT
    labelFontCustomColor = F.Table.HexToRGB("#ffffffff"),
    abbreviateLabels = true,

    valueFont = I.Fonts.Primary,
    valueFontSize = 15,
    valueFontShadow = false,
    valueFontOutline = "OUTLINE",
    valueFontColor = "GRADIENT", -- CLASS, TXUI, VALUE (ElvUI), CUSTOM, GRADIENT
    valueFontCustomColor = F.Table.HexToRGB("#ffffffff"),

    alternatingBackgroundEnabled = true, -- Enabled by default
    alternatingBackgroundAlpha = 0.5,

    -- Sets the mode for stats
    -- 0 (Hide), 1 (Smart/Blizzard), 2 (Always Show if not 0), 3 (Always Show)
    mode = {
      -- Attributes Category
      STRENGTH = {
        mode = 1,
        icon = F.String.ConvertGlyph(59728),
      },
      AGILITY = {
        mode = 1,
        icon = F.String.ConvertGlyph(59729),
      },
      INTELLECT = {
        mode = 1,
        icon = F.String.ConvertGlyph(59730),
      },
      STAMINA = {
        mode = 1,
        icon = F.String.ConvertGlyph(59731),
      },
      HEALTH = {
        mode = 0,
        icon = F.String.ConvertGlyph(59731),
      },
      POWER = {
        mode = 0,
      },
      ARMOR = {
        mode = 0,
        icon = F.String.ConvertGlyph(59737),
      },
      STAGGER = {
        mode = 0,
      },
      MANAREGEN = {
        mode = 0,
        icon = F.String.ConvertGlyph(59739),
      },
      ENERGY_REGEN = {
        mode = 0,
        icon = F.String.ConvertGlyph(59739),
      },
      RUNE_REGEN = {
        mode = 0,
        icon = F.String.ConvertGlyph(59739),
      },
      FOCUS_REGEN = {
        mode = 0,
        icon = F.String.ConvertGlyph(59739),
      },
      MOVESPEED = {
        mode = 1,
        icon = F.String.ConvertGlyph(59732),
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
        icon = F.String.ConvertGlyph(59730),
      },
      CRITCHANCE = {
        mode = 1,
        icon = F.String.ConvertGlyph(59733),
      },
      HASTE = {
        mode = 1,
        icon = F.String.ConvertGlyph(59734),
      },
      MASTERY = {
        mode = 1,
        icon = F.String.ConvertGlyph(59735),
      },
      VERSATILITY = {
        mode = 1,
        icon = F.String.ConvertGlyph(59736),
      },
      LIFESTEAL = {
        mode = 0,
        icon = F.String.ConvertGlyph(59738),
      },
      AVOIDANCE = {
        mode = 0,
        icon = F.String.ConvertGlyph(59740),
      },
      SPEED = {
        mode = 0,
        icon = F.String.ConvertGlyph(59732),
      },
      DODGE = {
        mode = 0,
        icon = F.String.ConvertGlyph(59740),
      },
      PARRY = {
        mode = 0,
        icon = F.String.ConvertGlyph(59712),
      },
      BLOCK = {
        mode = 0,
        icon = F.String.ConvertGlyph(59683),
      },
    },
  },

  pageInfo = {
    itemLevelTextEnabled = true,
    iconsEnabled = true,

    moveSockets = false,

    enchantTextEnabled = true,
    abbreviateEnchantText = true,
    useEnchantClassColor = true,
    missingEnchantText = true,
    missingSocketText = true,

    itemQualityGradientEnabled = true,
    itemQualityGradientWidth = 65,
    itemQualityGradientHeight = 3,
    itemQualityGradientStartAlpha = 1,
    itemQualityGradientEndAlpha = 0,

    iLvLFont = I.Fonts.Primary,
    iLvLFontSize = 12,
    iLvLFontShadow = false,
    iLvLFontOutline = "OUTLINE",

    enchantFont = I.Fonts.Primary,
    enchantFontSize = 9,
    enchantFontShadow = false,
    enchantFontOutline = "OUTLINE",
  },

  nameTextOffsetX = 0,
  nameTextOffsetY = 0,
  nameTextFont = I.Fonts.TitleRaid,
  nameTextFontSize = 18,
  nameTextFontShadow = false,
  nameTextFontOutline = "OUTLINE",
  nameTextFontColor = "CLASS_GRADIENT", -- CLASS, TXUI, VALUE (ElvUI), CUSTOM, GRADIENT, CLASS_GRADIENT
  nameTextFontCustomColor = F.Table.HexToRGB("#d6ba00ff"),

  titleTextOffsetX = 5,
  titleTextOffsetY = -2,
  titleTextFont = I.Fonts.TitleRaid,
  titleTextFontSize = 10,
  titleTextFontShadow = false,
  titleTextFontOutline = "OUTLINE",
  titleTextFontColor = "CLASS_GRADIENT", -- CLASS, TXUI, VALUE (ElvUI), CUSTOM, GRADIENT, CLASS_GRADIENT
  titleTextFontCustomColor = F.Table.HexToRGB("#d6ba00ff"),

  levelTitleTextOffsetX = 0,
  levelTitleTextOffsetY = -1,
  levelTitleTextShort = true,
  levelTitleTextFont = I.Fonts.Primary,
  levelTitleTextFontSize = 14,
  levelTitleTextFontShadow = false,
  levelTitleTextFontOutline = "OUTLINE",
  levelTitleTextFontColor = "CUSTOM", -- CLASS, TXUI, VALUE (ElvUI), CUSTOM
  levelTitleTextFontCustomColor = F.Table.HexToRGB("#ffffffff"),

  levelTextOffsetX = 0,
  levelTextOffsetY = -1,
  levelTextFont = I.Fonts.Primary,
  levelTextFontSize = 16,
  levelTextFontShadow = false,
  levelTextFontOutline = "OUTLINE",
  levelTextFontColor = "CUSTOM", -- CLASS, TXUI, VALUE (ElvUI), CUSTOM
  levelTextFontCustomColor = F.Table.HexToRGB("#ffffffff"),

  specIconFont = I.Fonts.Icons,
  specIconFontSize = 18,
  specIconFontShadow = false,
  specIconFontOutline = "OUTLINE",
  specIconFontColor = "GRADIENT", -- CLASS, TXUI, VALUE (ElvUI), CUSTOM, GRADIENT
  specIconFontCustomColor = F.Table.HexToRGB("#d6ba00ff"),

  classTextOffsetX = 0,
  classTextOffsetY = -2,
  classTextFont = I.Fonts.Primary,
  classTextFontSize = 14,
  classTextFontShadow = false,
  classTextFontOutline = "OUTLINE",
  classTextFontColor = "GRADIENT", -- CLASS, TXUI, VALUE (ElvUI), CUSTOM, GRADIENT
  classTextFontCustomColor = F.Table.HexToRGB("#d6ba00ff"),
}

-- Wunderbar
P.wunderbar = {
  general = {
    enabled = true,

    position = "BOTTOM",

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

    flyoutBackdrop = {
      enabled = true,
      alpha = 0.8,
      classColor = false,
      borderSize = 2,
      width = 48,
      spacing = 4,
      padding = 16,

      labelFont = I.Fonts.Primary,
      labelFontSize = 14,
    },

    accentFontColor = "CLASS", -- CLASS, TXUI, VALUE (ElvUI), CUSTOM
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
    LeftPanel = { "MicroMenu", "", "DataBar" },
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
      iconLatency = F.String.ConvertGlyph(59718),
      iconFramerate = F.String.ConvertGlyph(59704),
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

      icon = F.String.ConvertGlyph(59706),
      iconFontSize = 18,

      infoEnabled = true,
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

        abbreviate = false,
        limitChar = 16,

        showIcons = true,
        showBars = true,

        barHeight = 2,
        barOffset = -4,
        barSpacing = 4,
      },
      icons = {
        [164] = F.String.ConvertGlyph(59689), -- Blacksmithing
        [165] = F.String.ConvertGlyph(59697), -- Leatherworking
        [171] = F.String.ConvertGlyph(59686), -- Alchemy
        [182] = F.String.ConvertGlyph(59694), -- Herbalism
        [185] = F.String.ConvertGlyph(59690), -- Cooking
        [186] = F.String.ConvertGlyph(59698), -- Mining
        [197] = F.String.ConvertGlyph(59700), -- Tailoring
        [202] = F.String.ConvertGlyph(59692), -- Engineering
        [333] = F.String.ConvertGlyph(59691), -- Enchanting
        [356] = F.String.ConvertGlyph(59693), -- Fishing
        [393] = F.String.ConvertGlyph(59699), -- Skinning
        [755] = F.String.ConvertGlyph(59696), -- Jewelcrafting
        [773] = F.String.ConvertGlyph(59695), -- Inscription
        [794] = F.String.ConvertGlyph(59688), -- Archaeology
      },
      abbreviations = {
        [164] = "BS",
        [165] = "LW",
        [171] = "Alch",
        [182] = "Herb",
        [185] = "Cook",
        [186] = "Min",
        [197] = "Tail",
        [202] = "Engi",
        [333] = "Ench",
        [356] = "Fish",
        [393] = "Skin",
        [755] = "JC",
        [773] = "Insc",
        [794] = "Arch",
      },
    },
    Currency = {
      icon = F.String.ConvertGlyph(59705),
      iconFontSize = 18,

      displayedCurrency = "GOLD", -- NEEDS to be GOLD
      enabledCurrencies = {
        [3008] = true, --               Valorstones
        [3290] = true, --     Gilded Ethereal Crest
        [3288] = true, --      Runed Ethereal Crest
        [3286] = true, --     Carved Ethereal Crest
        [3284] = true, --  Weathered Ethereal Crest
        [2815] = true, --        Resonance Crystals
        [3028] = true, --       Restored Coffer Key
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

      icon = F.String.ConvertGlyph(59724),
      iconColor = false,
      iconFontSize = 18,
    },
    Hearthstone = {
      showIcon = true,

      icon = F.String.ConvertGlyph(59717),
      iconColor = false,
      iconFontSize = 18,

      seasonMythics = false,
      showLabels = true,
      showMageLabels = true,

      cooldownEnabled = true,
      cooldownFont = I.Fonts.Primary,
      cooldownFontSize = 18,
      cooldownOffset = 16,
      cooldownUseAccent = true,

      useUppercase = true,

      textColor = true,
      textColorFadeToNormal = true,

      randomPrimaryHs = true,
      primaryHS = 6948,
      secondaryHS = TXUI.IsRetail and 140192 or 6948,
      additionalHS = {},
    },
    Durability = {
      icon = F.String.ConvertGlyph(59721),
      iconColor = false,
      iconFontSize = 18,

      repairMount = 460,

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

        showLoadout = true, -- Retail only, show current selected talent loadout

        iconFontSize = 18,

        infoEnabled = true,
        infoShowIcon = false,
        infoFont = I.Fonts.Primary,
        infoIcon = F.String.ConvertGlyph(59722),
        infoFontSize = 12,
        infoOffset = 18,
        infoUseAccent = true,
      },
      icons = {
        -- Retail
        [0] = F.String.ConvertGlyph(59712), -- Unknown
        [62] = F.String.ConvertGlyph(59660), -- Mage Arcane
        [63] = F.String.ConvertGlyph(59661), -- Mage Fire
        [64] = F.String.ConvertGlyph(59662), -- Mage Frost
        [65] = F.String.ConvertGlyph(59666), -- Paladin Holy
        [66] = F.String.ConvertGlyph(59667), -- Paladin Protection
        [70] = F.String.ConvertGlyph(59668), -- Paladin Retribution
        [71] = F.String.ConvertGlyph(59681), -- Warrior Arms
        [72] = F.String.ConvertGlyph(59682), -- Warrior Fury
        [73] = F.String.ConvertGlyph(59683), -- Warrior Protection
        [102] = F.String.ConvertGlyph(59653), -- Druid Balance
        [103] = F.String.ConvertGlyph(59654), -- Druid Feral
        [104] = F.String.ConvertGlyph(59655), -- Druid Guardian
        [105] = F.String.ConvertGlyph(59656), -- Druid Restoration
        [250] = F.String.ConvertGlyph(59648), -- Death Knight Blood
        [251] = F.String.ConvertGlyph(59649), -- Death Knight Frost
        [252] = F.String.ConvertGlyph(59650), -- Death Knight Unholy
        [253] = F.String.ConvertGlyph(59657), -- Hunter Beast Master
        [254] = F.String.ConvertGlyph(59658), -- Hunter Marksmanship
        [255] = F.String.ConvertGlyph(59659), -- Hunter Survival
        [256] = F.String.ConvertGlyph(59669), -- Priest Discipline
        [257] = F.String.ConvertGlyph(59670), -- Priest Holy
        [258] = F.String.ConvertGlyph(59671), -- Priest Shadow
        [259] = F.String.ConvertGlyph(59672), -- Rogue Assassination
        [260] = F.String.ConvertGlyph(59673), -- Rogue Outlaw
        [261] = F.String.ConvertGlyph(59674), -- Rogue Subtlety
        [262] = F.String.ConvertGlyph(59675), -- Shaman Elemental
        [263] = F.String.ConvertGlyph(59676), -- Shaman Enhancement
        [264] = F.String.ConvertGlyph(59677), -- Shaman Restoration
        [265] = F.String.ConvertGlyph(59678), -- Warlock Affliction
        [266] = F.String.ConvertGlyph(59679), -- Warlock Demonology
        [267] = F.String.ConvertGlyph(59680), -- Warlock Destruction
        [268] = F.String.ConvertGlyph(59663), -- Monk Brewmaster
        [269] = F.String.ConvertGlyph(59665), -- Monk Windwalker
        [270] = F.String.ConvertGlyph(59664), -- Monk Mistweaver
        [577] = F.String.ConvertGlyph(59651), -- Demon Hunter Havoc
        [581] = F.String.ConvertGlyph(59652), -- Demon Hunter Vengeance
        [1467] = F.String.ConvertGlyph(59725), -- Evoker Devastation
        [1468] = F.String.ConvertGlyph(59726), -- Evoker Preservation
        [1473] = F.String.ConvertGlyph(59727), -- Evoker Augmentation

        -- Wrath
        ["MageArcane"] = F.String.ConvertGlyph(59660),
        ["MageFire"] = F.String.ConvertGlyph(59661),
        ["MageFrost"] = F.String.ConvertGlyph(59662),

        ["PaladinHoly"] = F.String.ConvertGlyph(59666),
        ["PaladinProtection"] = F.String.ConvertGlyph(59667),
        ["PaladinCombat"] = F.String.ConvertGlyph(59668),
        -- Cata??
        ["PALADINCOMBAT"] = F.String.ConvertGlyph(59668),
        ["PALADINPROTECTION"] = F.String.ConvertGlyph(59667),
        ["PALADINHOLY"] = F.String.ConvertGlyph(59666),

        ["WarriorArms"] = F.String.ConvertGlyph(59681),
        ["WarriorFury"] = F.String.ConvertGlyph(59682),
        ["WarriorProtection"] = F.String.ConvertGlyph(59683),

        ["DruidBalance"] = F.String.ConvertGlyph(59653),
        ["DruidFeralCombat"] = F.String.ConvertGlyph(59654),
        ["DruidRestoration"] = F.String.ConvertGlyph(59656),

        ["DeathKnightBlood"] = F.String.ConvertGlyph(59648),
        ["DeathKnightFrost"] = F.String.ConvertGlyph(59649),
        ["DeathKnightUnholy"] = F.String.ConvertGlyph(59650),

        ["HunterBeastMastery"] = F.String.ConvertGlyph(59657),
        ["HunterMarksmanship"] = F.String.ConvertGlyph(59658),
        ["HunterSurvival"] = F.String.ConvertGlyph(59659),

        ["PriestDiscipline"] = F.String.ConvertGlyph(59669),
        ["PriestHoly"] = F.String.ConvertGlyph(59670),
        ["PriestShadow"] = F.String.ConvertGlyph(59671),

        ["RogueAssassination"] = F.String.ConvertGlyph(59672),
        ["RogueCombat"] = F.String.ConvertGlyph(59673),
        ["RogueSubtlety"] = F.String.ConvertGlyph(59674),

        ["ShamanElementalCombat"] = F.String.ConvertGlyph(59675),
        ["ShamanEnhancement"] = F.String.ConvertGlyph(59676),
        ["ShamanRestoration"] = F.String.ConvertGlyph(59677),

        ["WarlockCurses"] = F.String.ConvertGlyph(59678),
        ["WarlockSummoning"] = F.String.ConvertGlyph(59679),
        ["WarlockDestruction"] = F.String.ConvertGlyph(59680),
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
          icon = F.String.ConvertGlyph(59714),
        },
        chat = {
          enabled = true,
          icon = F.String.ConvertGlyph(59703),
        },
        guild = {
          enabled = true,
          icon = F.String.ConvertGlyph(59720),
        },
        social = {
          enabled = true,
          icon = F.String.ConvertGlyph(59709),
        },
        char = {
          enabled = true,
          icon = F.String.ConvertGlyph(59702),
        },
        spell = {
          enabled = true,
          icon = F.String.ConvertGlyph(59708),
        },
        talent = {
          enabled = true,
          icon = F.String.ConvertGlyph(59707),
        },
        ach = {
          enabled = true,
          icon = F.String.ConvertGlyph(59701),
        },
        quest = {
          enabled = true,
          icon = F.String.ConvertGlyph(59711),
        },
        lfg = {
          enabled = true,
          icon = F.String.ConvertGlyph(59715),
        },
        journal = {
          enabled = true,
          icon = F.String.ConvertGlyph(59716),
        },
        pvp = {
          enabled = true,
          icon = F.String.ConvertGlyph(59712),
          icon_a = F.String.ConvertGlyph(59684),
          icon_h = F.String.ConvertGlyph(59685),
        },
        pet = {
          enabled = true,
          icon = F.String.ConvertGlyph(59713),
        },
        shop = {
          enabled = true,
          icon = F.String.ConvertGlyph(59710),
        },
        help = {
          enabled = false,
          icon = F.String.ConvertGlyph(59719),
        },
        txui = {
          enabled = true,
          icon = F.String.ConvertGlyph(59687),
        },
      },
    },
    ElvUILDB = {
      useUppercase = true,
      textColor = false,
    },
  },
}
