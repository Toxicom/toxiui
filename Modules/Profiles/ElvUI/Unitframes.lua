local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local PF = TXUI:GetModule("Profiles")

PF.unitframes = {
  player = {},
  target = {},
  party = {},
  focus = {},
  pet = {},
  targettarget = {},
  arena = {},
  boss = {},
  raid = {},
  tank = {},
  assist = {},
}

local customTextTemplate = {
  -- Options
  enable = true,
  attachTextTo = "Health",
  justifyH = "LEFT",

  -- Offset
  xOffset = F.Dpi(-12),
  yOffset = F.Dpi(32),
}

local createCustomText = function(db, ...)
  return F.Table.Join(db or {}, customTextTemplate, ...)
end

local player = {
  -- UnitFrame Player Size
  width = F.Dpi(300),
  height = F.Dpi(36),
  threatStyle = "NONE",

  -- UnitFrame Player Options
  disableMouseoverGlow = true,

  -- UnitFrame Player Custom Texts
  customTexts = {
    -- UnitFrame Player Custom Texts Name
    ["toxiui:name"] = createCustomText({}, {
      attachTextTo = "Health",
      text_format = "[tx:name:medium:split]",
      xOffset = F.Dpi(6),
      yOffset = F.Dpi(32),
    }),

    -- UnitFrame Player Custom Texts Level
    ["toxiui:level"] = createCustomText({}, {
      justifyH = "LEFT",
      text_format = "[tx:level]",
      xOffset = F.Dpi(22),
      yOffset = F.Dpi(-18),
    }),

    -- UnitFrame Player Custom Texts Health
    ["toxiui:health"] = createCustomText({}, {
      justifyH = "RIGHT",
      text_format = "[tx:health:percent:nosign]",
      xOffset = F.Dpi(-12),
      yOffset = F.Dpi(18),
    }),

    ["toxiui:health-small"] = createCustomText({}, {
      justifyH = "RIGHT",
      text_format = TXUI.IsRetail and "[tx:health:current:shortvalue:absorb]" or "[tx:health:current:shortvalue]",
      xOffset = F.Dpi(-12),
      yOffset = F.Dpi(-18),
    }),

    -- UnitFrame Player Custom Texts Power
    ["toxiui:power"] = createCustomText({}, {
      attachTextTo = "Power",
      text_format = "[tx:power]",
      xOffset = 0,
      yOffset = 10,
      justifyH = "CENTER",
    }),

    -- UnitFrame Player Custom Texts Class Icon
    ["toxiui:class-icon"] = createCustomText({}, {
      justifyH = "LEFT",
      attachTextTo = "Health",
      text_format = "[tx:classicon]",
      xOffset = F.Dpi(6),
      yOffset = F.Dpi(0),
    }),
  },

  -- UnitFrame Player Debuffs
  debuffs = {
    anchorPoint = "TOPRIGHT",
    growthX = "LEFT",
    attachTo = "FRAME",
    durationPosition = "CENTER",
    maxDuration = 0,
    perrow = 7,
    priority = "Blacklist,Boss,CCDebuffs,RaidDebuffs,CastByUnit,CastByNPC,Personal",
    spacing = 0,
    xOffset = 0,
    yOffset = F.Dpi(30),

    -- Stack Counter
    countPosition = "BOTTOM",
    countYOffset = F.Dpi(-7),

    keepSizeRatio = false,
    sizeOverride = F.Dpi(43),
    height = F.Dpi(29),
  },

  -- UnitFrame Player Fader
  fader = {
    enable = true,
    minAlpha = 0,
    power = true,
    vehicle = false,

    instanceDifficulties = {
      dungeonNormal = true,
      dungeonHeroic = true,
      dungeonMythic = true,

      raidNormal = true,
      raidHeroic = true,
      raidMythic = true,
    },
  },

  -- UnitFrame Player RestIcon
  RestIcon = {
    enable = true,
    defaultColor = false,

    anchorPoint = "TOPRIGHT",
    size = F.Dpi(43),
    xOffset = F.Dpi(12),
    yOffset = F.Dpi(22),

    texture = "CUSTOM",
    customTexture = I.General.MediaPath .. "Textures\\Resting.tga",
  },

  -- UnitFrame Player Raid Role Icon
  raidRoleIcons = {
    enable = true,
    scale = 2,
    xOffset = F.Dpi(6),
    yOffset = F.Dpi(25),
  },

  partyIndicator = {
    enable = false,
  },

  -- UnitFrame Player CombatIcon
  CombatIcon = {
    enable = true,

    anchorPoint = "CENTER",
    size = F.Dpi(29),
    yOffset = -20, -- Not sure if this needs DPI

    defaultColor = true,
    color = F.Table.HexToRGB("#ffffff"),

    texture = "CUSTOM",
    customTexture = I.General.MediaPath .. "Textures\\Icons\\CombatStylized.blp",
  },

  -- UnitFrame Player raidicon (Target Marker Icon)
  raidicon = {
    attachTo = "TOPLEFT",
    size = F.Dpi(24),
    xOffset = F.Dpi(-27),
    yOffset = F.Dpi(27),
  },

  power = {
    enable = true,
    detachFromFrame = true,
    autoHide = false,
    detachedWidth = F.Dpi(292),
    text_format = "",
    height = 10,
  },

  classbar = {
    enable = true,
    detachFromFrame = true,
    detachedWidth = F.Dpi(292),
    height = 10,
  },

  -- UnitFrame Player Castbar
  castbar = {
    width = F.Dpi(300),
    height = F.Dpi(24),

    -- UnitFrame Player Castbar Options
    insideInfoPanel = false,
    icon = true,
    iconAttached = true,

    -- UnitFrame Player Castbar Text
    textColor = F.Table.HexToRGB("#ffffff"),
    xOffsetText = F.Dpi(6),
    xOffsetTime = F.Dpi(-12),

    -- Puts castbar below Combat Icon and Class Icon
    strataAndLevel = {
      frameLevel = 1,
      useCustomLevel = true,
    },
  },

  -- UnitFrame Player heal prediction
  healPrediction = {
    absorbStyle = "REVERSED",
  },

  -- Disable UnitFrame Player aurabar
  aurabar = { enable = false },
  -- Disable UnitFrame Player health text
  health = { text_format = "" },
  -- Disable UnitFrame Target name text
  name = { text_format = "" },
  -- Disable UnitFrame Player Buffs
  buffs = { enable = false },
}

local target = {
  -- UnitFrame Target Size
  width = F.Dpi(300),
  height = F.Dpi(36),
  threatStyle = "NONE",

  -- UnitFrame Target Options
  disableMouseoverGlow = true,
  orientation = "LEFT",

  -- UnitFrame Target Custom Texts
  customTexts = {
    -- UnitFrame Target Custom Texts Health
    ["toxiui:health"] = createCustomText({}, {
      justifyH = "LEFT",
      text_format = "[tx:health:percent:nosign]",
      xOffset = F.Dpi(12),
      yOffset = F.Dpi(18),
    }),

    ["toxiui:health-small"] = createCustomText({}, {
      justifyH = "LEFT",
      text_format = TXUI.IsRetail and "[tx:health:current:shortvalue:absorb]" or "[tx:health:current:shortvalue]",
      xOffset = F.Dpi(12),
      yOffset = F.Dpi(-18),
    }),

    -- UnitFrame Target Custom Texts Name
    ["toxiui:name"] = createCustomText({}, {
      justifyH = "RIGHT",
      text_format = "[tx:name:abbrev:medium:split]",
      xOffset = F.Dpi(-6),
      yOffset = F.Dpi(32),
    }),

    -- UnitFrame Target Custom Texts Level
    ["toxiui:level"] = createCustomText({}, {
      justifyH = "RIGHT",
      text_format = "[tx:level:difficulty]",
      xOffset = F.Dpi(-18),
      yOffset = F.Dpi(-18),
    }),

    -- UnitFrame Target Custom Texts Power
    ["toxiui:power"] = createCustomText({}, {
      attachTextTo = "Power",
      text_format = "[tx:power:percent:nosign]",
      xOffset = F.Dpi(102),
      yOffset = F.Dpi(0),
    }),

    -- UnitFrame Target Custom Texts Class Icon
    ["toxiui:class-icon"] = createCustomText({}, {
      justifyH = "RIGHT",
      attachTextTo = "Health",
      text_format = "[tx:classicon:reverse]",
      xOffset = F.Dpi(-6),
      yOffset = F.Dpi(0),
    }),

    -- UnitFrame Target Custom Texts Classification
    ["toxiui:classification"] = createCustomText({}, {
      justifyH = "RIGHT",
      attachTextTo = "Health",
      text_format = "[tx:classification]",
      xOffset = F.Dpi(18),
      yOffset = F.Dpi(30),
    }),
  },

  -- UnitFrame Target Buffs
  buffs = {
    anchorPoint = "TOPRIGHT",
    growthX = "LEFT",
    perrow = 7,
    priority = "Blacklist,Personal,Boss,NonPersonal,CastByUnit",
    spacing = 0,
    xOffset = 0,
    yOffset = F.Dpi(72),

    -- Stack Counter
    countPosition = "BOTTOM",
    countYOffset = F.Dpi(-7),

    keepSizeRatio = false,
    sizeOverride = F.Dpi(43),
    height = F.Dpi(29),
  },

  -- UnitFrame Target Debuffs
  debuffs = {
    anchorPoint = "TOPLEFT",
    growthX = "RIGHT",
    attachTo = "FRAME",
    durationPosition = "CENTER",
    maxDuration = 0,
    perrow = 7,
    priority = "Blacklist,Boss,Personal,RaidDebuffs,CastByUnit,CCDebuffs",
    spacing = 0,
    xOffset = 0,
    yOffset = F.Dpi(30),

    -- Stack Counter
    countPosition = "BOTTOM",
    countYOffset = F.Dpi(-7),

    keepSizeRatio = false,
    sizeOverride = F.Dpi(43),
    height = F.Dpi(29),

    -- Filters (ElvUI Default)
    isAuraRaid = true,
    isAuraRaidPlayer = true,
  },

  -- New "Custom" tab introduced in ElvUI 14.00
  auras = {
    enable = false,
  },

  -- UnitFrame Target raidicon (Target Marker Icon)
  raidicon = {
    attachTo = "TOPRIGHT",
    size = F.Dpi(24),
    yOffset = F.Dpi(27),
    xOffset = F.Dpi(27),
  },

  -- UnitFrame Target Raid Role Icon
  raidRoleIcons = {
    enable = true,
    scale = 2,
    position = "TOPRIGHT",
    xOffset = F.Dpi(-6),
    yOffset = F.Dpi(25),
  },

  -- UnitFrame Target Castbar
  castbar = {
    width = F.Dpi(300),
    height = F.Dpi(24),

    -- UnitFrame Target Castbar Options
    insideInfoPanel = false,
    icon = true,
    iconAttached = true,

    -- UnitFrame Target Castbar Text
    textColor = F.Table.HexToRGB("#ffffff"),
    xOffsetText = F.Dpi(6),
    xOffsetTime = F.Dpi(-12),

    -- Puts castbar below Combat Icon and Class Icon
    strataAndLevel = {
      frameLevel = 1,
      useCustomLevel = true,
    },
  },

  -- UnitFrame Target heal prediction
  healPrediction = {
    absorbStyle = "REVERSED",
  },

  -- Disable UnitFrame Target CombatIcon
  CombatIcon = { enable = false },
  -- Disable UnitFrame Target aurabar
  aurabar = { enable = false },
  -- Disable UnitFrame Target fader
  fader = { enable = false },

  -- UnitFrame Target Power
  power = {
    enable = true,
    detachFromFrame = true,
    autoHide = true,
    detachedWidth = F.Dpi(144),
    text_format = "",
  },

  -- Disable UnitFrame Target health text
  health = { text_format = "" },
  -- Disable UnitFrame Target name text
  name = { text_format = "" },
}

local pet = { -- Pet
  width = F.Dpi(120),
  height = F.Dpi(18),
  disableTargetGlow = false,
  threatStyle = "NONE",

  -- UnitFrame Pet Custom Texts
  customTexts = {
    -- UnitFrame Pet Custom Texts Name
    ["toxiui:name"] = createCustomText({}, {
      text_format = "[tx:name:short:split]",
      xOffset = F.Dpi(0),
      yOffset = F.Dpi(18),
      justifyH = "CENTER",
    }),

    ["toxiui:pet-happiness"] = createCustomText({}, {
      text_format = (TXUI.IsClassicEra or TXUI.IsAnniversary) and "[happiness:discord]" or "",
      xOffset = -25,
      yOffset = 0,
      justifyH = "LEFT",
    }),
  },

  -- UnitFrame Pet Castbar
  castbar = {
    textColor = F.Table.HexToRGB("#ffffff"),
    height = F.Dpi(14),
    width = F.Dpi(120),

    icon = true,
    iconAttached = true,
  },

  -- UnitFrame Pet Fader
  fader = {
    enable = true,
    combat = true,
    health = true,
    hover = true,
    minAlpha = 0,
    playertarget = true,
    range = false,
    unittarget = true,

    instanceDifficulties = {
      dungeonNormal = true,
      dungeonHeroic = true,
      dungeonMythic = true,

      raidNormal = true,
      raidHeroic = true,
      raidMythic = true,
    },
  },

  -- Disable UnitFrame Pet health text
  health = { text_format = "" },
  -- Disable UnitFrame Pet name text
  name = { text_format = "" },
  -- Disable UnitFrame Pet name text
  power = { enable = false },
  -- Disable UnitFrame Pet Debuffs
  debuffs = { enable = false },
}

local targettarget = { -- ToT
  width = F.Dpi(120),
  height = F.Dpi(18),
  threatStyle = "NONE",
  disableMouseoverGlow = true,

  -- UnitFrame Target-Target Custom Texts
  customTexts = {
    -- UnitFrame Target-Target Custom Texts Name
    ["toxiui:name"] = createCustomText({}, {
      text_format = "[tx:name:short:split]",
      xOffset = F.Dpi(0),
      yOffset = F.Dpi(18),
      justifyH = "CENTER",
    }),
  },

  -- UnitFrame Target-Target RaidIcon (Target Maker)
  raidicon = {
    size = F.Dpi(19),
    attachTo = "CENTER",
    yOffset = F.Dpi(0),
  },

  -- Disable UnitFrame Target-Target health text
  health = { text_format = "" },
  -- Disable UnitFrame Target-Target name text
  name = { text_format = "" },
  -- Disable UnitFrame Target-Target name text
  power = { enable = false },
  -- Disable UnitFrame Target-Target debuffs
  debuffs = { enable = false },
}

local focus = { -- Focus
  width = F.Dpi(300),
  height = F.Dpi(36),
  threatStyle = "NONE",

  -- UnitFrame Focus Options
  orientation = "LEFT",
  disableMouseoverGlow = true,
  disableTargetGlow = true,

  -- UnitFrame Focus Custom Texts
  customTexts = {
    -- UnitFrame Focus Custom Texts Name
    ["toxiui:name"] = createCustomText({}, {
      justifyH = "RIGHT",
      text_format = "[tx:name:medium:split]",
      xOffset = F.Dpi(-6),
      yOffset = F.Dpi(32),
    }),

    -- UnitFrame Focus Custom Texts Health
    ["toxiui:health"] = createCustomText({}, {
      justifyH = "LEFT",
      text_format = "[tx:health:percent:nosign]",
      xOffset = F.Dpi(12),
      yOffset = F.Dpi(18),
    }),

    -- UnitFrame Focus Custom Texts Health
    ["toxiui:health-small"] = createCustomText({}, {
      justifyH = "LEFT",
      text_format = TXUI.IsRetail and "[tx:health:current:shortvalue:absorb]" or "[tx:health:current:shortvalue]",
      xOffset = F.Dpi(12),
      yOffset = F.Dpi(-18),
    }),

    -- UnitFrame Focus Custom Texts Power
    ["toxiui:power"] = createCustomText({}, {
      attachTextTo = "Power",
      text_format = "[tx:power:percent:nosign]",
      xOffset = F.Dpi(102),
      yOffset = F.Dpi(0),
    }),

    -- UnitFrame Focus Custom Texts Class Icon
    ["toxiui:class-icon"] = createCustomText({}, {
      justifyH = "RIGHT",
      attachTextTo = "Health",
      text_format = "[tx:classicon:reverse]",
      xOffset = F.Dpi(-6),
      yOffset = F.Dpi(0),
    }),
  },

  -- UnitFrame Focus Buffs
  buffs = {
    enable = false,
    anchorPoint = "TOPLEFT",
    maxDuration = 0,
    perrow = 5,
    priority = "Blacklist,Personal,PlayerBuffs,Whitelist,blockNoDuration,NonPersonal",
    sizeOverride = F.Dpi(29),

    -- Stack Counter
    countPosition = "BOTTOM",
    countYOffset = F.Dpi(-7),

    spacing = F.Dpi(0),
    xOffset = F.Dpi(4),
    yOffset = F.Dpi(30),

    -- Filters (ElvUI Default)
    isAuraBigDefensive = true,
    isAuraExternalDefensive = true,
    isAuraExternalDefensivePlayer = true,
  },

  -- UnitFrame Focus Debuffs
  debuffs = {
    durationPosition = "CENTER",
    maxDuration = 0,
    priority = "Blacklist,Personal,NonPersonal",
    spacing = F.Dpi(0),
    xOffset = F.Dpi(-4),
    yOffset = F.Dpi(30),

    -- Stack Counter
    countPosition = "BOTTOM",
    countYOffset = F.Dpi(-7),

    keepSizeRatio = false,
    sizeOverride = F.Dpi(29),
    height = F.Dpi(19),

    -- Filters (ElvUI Default)
    isAuraPlayer = true,
    isAuraRaid = true,
    isAuraBigDefensive = true,
    isAuraExternalDefensive = true,
  },

  -- UnitFrame Focus raidicon (Target Marker Icon)
  raidicon = {
    attachTo = "TOPRIGHT",
    size = F.Dpi(24),
    yOffset = F.Dpi(27),
    xOffset = F.Dpi(27),
  },

  -- UnitFrame Focus Castbar
  castbar = {
    height = F.Dpi(24),
    width = F.Dpi(300),
    insideInfoPanel = false,

    icon = true,
    iconAttached = true,

    textColor = F.Table.HexToRGB("#ffffff"),
    xOffsetText = F.Dpi(6),
    xOffsetTime = F.Dpi(-12),

    -- UnitFrame Focus Castbar Classcolor
    customColor = {
      useClassColor = true,
    },

    -- Puts castbar below Combat Icon and Class Icon
    strataAndLevel = {
      frameLevel = 1,
      useCustomLevel = true,
    },
  },

  -- UnitFrame Focus Power
  power = {
    width = "spaced",
    text_format = "",
    detachedWidth = F.Dpi(144),
    detachFromFrame = true,
    autoHide = true,
    position = "RIGHT",
    xOffset = F.Dpi(-2),
  },

  -- Disable UnitFrame Focus CombatIcon
  CombatIcon = { enable = false },
  -- Disable UnitFrame Focus health text
  health = { text_format = "" },
  -- Disable UnitFrame Focus name text
  name = { text_format = "" },
}

local party = { -- Party
  width = F.Dpi(240),
  height = F.Dpi(36),

  visibility = "[@raid1,exists][@party1,noexists] hide;show",

  -- UnitFrame Party Options
  groupBy = "ROLE",
  growthDirection = "DOWN_LEFT",
  horizontalSpacing = F.Dpi(6),
  raidWideSorting = true,
  showPlayer = false,
  startFromCenter = true,
  verticalSpacing = F.Dpi(48),

  -- UnitFrame Party Custom Texts
  customTexts = {
    -- UnitFrame Party Custom Texts Name
    ["toxiui:name"] = createCustomText({}, {
      text_format = "[tx:name:abbrev:medium:split]",
      xOffset = F.Dpi(6),
      yOffset = F.Dpi(32),
    }),

    -- UnitFrame Party Custom Texts Health
    ["toxiui:health"] = createCustomText({}, {
      justifyH = "RIGHT",
      text_format = "[tx:health:percent:nosign]",
      xOffset = F.Dpi(-12),
      yOffset = F.Dpi(18),
    }),

    -- UnitFrame Party Custom Texts Level
    ["toxiui:level"] = createCustomText({}, {
      justifyH = "LEFT",
      text_format = "[tx:level:difficulty]",
      xOffset = F.Dpi(22),
      yOffset = F.Dpi(-12),
    }),

    -- UnitFrame Party Custom Texts Power
    ["toxiui:power"] = createCustomText({}, {
      justifyH = "LEFT",
      attachTextTo = "Power",
      text_format = "[tx:power:percent:nosign]",
      xOffset = F.Dpi(12),
      yOffset = F.Dpi(0),
    }),

    -- UnitFrame Party Custom Texts Class Icon
    ["toxiui:class-icon"] = createCustomText({}, {
      justifyH = "LEFT",
      attachTextTo = "Health",
      text_format = "[tx:classicon]",
      xOffset = F.Dpi(6),
      yOffset = F.Dpi(0),
    }),
  },

  -- UnitFrame Party BuffIndicator
  buffIndicator = {
    size = F.Dpi(12),
  },

  -- UnitFrame Party Buffs
  buffs = {
    enable = true,
    anchorPoint = "LEFT",
    growthX = "LEFT",
    perrow = 5,
    numrows = 1,
    spacing = 2,
    yOffset = 0,
    xOffset = F.Dpi(-40),

    -- Stack Counter
    countPosition = "BOTTOM",
    countYOffset = F.Dpi(-5),

    keepSizeRatio = false,
    sizeOverride = F.Dpi(36),
    height = F.Dpi(24),

    -- Filters (ElvUI Default)
    isAuraBigDefensive = true,
    isAuraBigDefensivePlayer = true,
    isAuraRaidInCombatPlayer = true,
    isAuraExternalDefensive = true,
    isAuraExternalDefensivePlayer = true,
  },

  -- UnitFrame Party Debuffs
  debuffs = {
    attachTo = "HEALTH",
    anchorPoint = "RIGHT",
    perrow = 5,
    numrows = 1,
    priority = "Blacklist,Dispellable,Boss,RaidDebuffs,CCDebuffs,Whitelist",
    spacing = 2,
    yOffset = 0,
    xOffset = 10,

    -- Stack Counter
    countPosition = "BOTTOM",
    countYOffset = F.Dpi(-5),

    keepSizeRatio = false,
    sizeOverride = F.Dpi(36),
    height = F.Dpi(24),

    -- Filters (ElvUI Default)
    isAuraImportant = true,
    isAuraImportantPlayer = true,
    isAuraRaidPlayerDispellable = true,
  },

  -- UnitFrame Party Heal Prediction
  healPrediction = {
    enable = true,
    absorbStyle = "REVERSED",
  },

  -- UnitFrame Party Phase Indicator
  phaseIndicator = {
    scale = F.DpiRaw(1),
  },

  -- UnitFrame Party RaidIcon (Target Marker)
  raidicon = {
    attachTo = "TOPLEFT",
    size = F.Dpi(24),
    xOffset = F.Dpi(-27),
    yOffset = F.Dpi(27),
  },

  -- UnitFrame Party Role Icons
  raidRoleIcons = {
    enable = true,
    scale = 2,
    position = "TOPLEFT",
    xOffset = F.Dpi(12),
    yOffset = F.Dpi(25),
  },

  -- UnitFrame Party Raid Debuffs
  rdebuffs = {
    enable = false,
    size = F.Dpi(36),
    yOffset = F.Dpi(24),
  },

  -- UnitFrame Party Ready Check Icon
  readycheckIcon = {
    position = "CENTER",
    size = F.Dpi(48),
    yOffset = F.Dpi(0),
  },

  -- UnitFrame Party Role Icon
  roleIcon = {
    damager = true,
    position = "LEFT",
    size = F.Dpi(36),
    xOffset = F.Dpi(-35),
    yOffset = F.Dpi(0),
  },

  -- UnitFrame Party Power
  power = {
    width = "spaced",
    height = F.Dpi(12),
    text_format = "",
  },

  -- Disable UnitFrame Party health text
  health = { text_format = "" },
  -- Disable UnitFrame Party name text
  name = { text_format = "" },
  -- Disable UnitFrame Party CombatIcon
  CombatIcon = { enable = false },
}

local raid = {
  enable = true,
  width = F.Dpi(120),
  height = F.Dpi(50),

  -- UnitFrame Raid1 Options
  groupBy = "GROUP",
  groupSpacing = 10,
  groupsPerRowCol = 1,
  growthDirection = "RIGHT_UP",
  horizontalSpacing = F.Dpi(1),
  numGroups = 8,
  raidWideSorting = false,
  startFromCenter = false,
  verticalSpacing = F.Dpi(1),

  -- UnitFrame Raid1 Custom Texts
  customTexts = {
    -- UnitFrame Raid1 Custom Texts Name
    ["toxiui:name"] = createCustomText({}, {
      attachTextTo = "Frame",
      text_format = "[tx:name:veryshort]",
      justifyH = "CENTER",
      xOffset = F.Dpi(0),
      yOffset = F.Dpi(0),
    }),

    ["toxiui:raid-group"] = createCustomText({}, {
      attachTextTo = "Frame",
      text_format = "[group:raid]",
      justifyH = "RIGHT",
      xOffset = -2,
      yOffset = -10,
    }),
  },

  -- UnitFrame Raid1 Heal Prediction
  healPrediction = {
    enable = true,
    absorbStyle = "REVERSED",
  },

  -- UnitFrame Raid1 Raid Debuffs
  rdebuffs = {
    enable = true,
    size = F.Dpi(24),
    yOffset = F.Dpi(6),

    duration = {
      color = F.Table.HexToRGB("#fff0ea"),
    },

    stack = {
      color = F.Table.HexToRGB("#ffe900"),
      position = "BOTTOMRIGHT",
      yOffset = F.Dpi(0),
    },
  },

  -- UnitFrame Raid1 Ready Check Icon
  readycheckIcon = {
    size = F.Dpi(29),
  },

  -- UnitFrame Raid1 Role Icon
  roleIcon = {
    enable = true,
    damager = false,
    position = "BOTTOMLEFT",
    size = F.Dpi(24),
    xOffset = 0,
    yOffset = 2,
  },

  raidRoleIcons = {
    enable = true,
    scale = 2,
    yOffset = F.Dpi(7),
  },

  -- Disable UnitFrame Raid1 health text
  health = { text_format = "" },
  -- Disable UnitFrame Raid1 name text
  name = { text_format = "" },
  -- Disable UnitFrame Raid1 power
  power = { enable = false },

  buffs = {
    enable = true,
    anchorPoint = "TOPLEFT",
    growthX = "RIGHT",

    keepSizeRatio = false,
    sizeOverride = F.Dpi(18),
    height = F.Dpi(12),

    perrow = 6,
    xOffset = F.Dpi(4),
    yOffset = F.Dpi(-18),

    -- Filters (ElvUI Default)
    isAuraBigDefensive = true,
    isAuraBigDefensivePlayer = true,
    isAuraRaidInCombatPlayer = true,
    isAuraExternalDefensive = true,
    isAuraExternalDefensivePlayer = true,
  },

  debuffs = {
    enable = true,
    anchorPoint = "BOTTOMRIGHT",
    growthX = "LEFT",

    keepSizeRatio = false,
    sizeOverride = F.Dpi(18),
    height = F.Dpi(12),

    perrow = 6,
    xOffset = F.Dpi(-4),
    yOffset = F.Dpi(4),

    isAuraImportant = true,
    isAuraImportantPlayer = true,
    isAuraRaidPlayerDispellable = true,
  },
}

local tank = {
  name = {
    text_format = "",
  },

  customTexts = {
    -- UnitFrame Tank Custom Texts Name
    ["toxiui:name"] = createCustomText({}, {
      attachTextTo = "Frame",
      text_format = "[tx:name:short]",
      justifyH = "CENTER",
      xOffset = F.Dpi(0),
      yOffset = F.Dpi(0),
    }),
  },

  targetsGroup = {
    name = {
      text_format = "[tx:name:short]",
    },
  },

  -- Disable UnitFrame Tank health text
  health = { text_format = "" },
}

local assist = {
  name = {
    text_format = "",
  },

  customTexts = {
    -- UnitFrame Assist Custom Texts Name
    ["toxiui:name"] = createCustomText({}, {
      attachTextTo = "Frame",
      text_format = "[tx:name:short]",
      justifyH = "CENTER",
      xOffset = F.Dpi(0),
      yOffset = F.Dpi(0),
    }),
  },

  targetsGroup = {
    name = {
      text_format = "[tx:name:short]",
    },
  },

  -- Disable UnitFrame Assist health text
  health = { text_format = "" },
}

local arena = {
  width = F.Dpi(240),
  height = F.Dpi(36),
  spacing = F.Dpi(48),
  pvpSpecIcon = false,

  -- UnitFrame Arena Custom Texts
  customTexts = {
    -- UnitFrame Arena Custom Texts Health
    ["toxiui:health"] = createCustomText({}, {
      text_format = "[tx:health:percent:nosign]",
      xOffset = F.Dpi(12),
      yOffset = F.Dpi(18),
    }),

    -- UnitFrame Arena Custom Texts Name
    ["toxiui:name"] = createCustomText({}, {
      justifyH = "RIGHT",
      text_format = "[tx:name:medium:split]",
      xOffset = F.Dpi(-6),
      yOffset = F.Dpi(32),
    }),

    -- UnitFrame Arena Custom Texts Power
    ["toxiui:power"] = createCustomText({}, {
      attachTextTo = "Power",
      text_format = "[tx:power:percent:nosign]",
      xOffset = F.Dpi(102),
      yOffset = F.Dpi(0),
    }),

    -- UnitFrame Arena Custom Texts Class Icon
    ["toxiui:class-icon"] = createCustomText({}, {
      justifyH = "RIGHT",
      attachTextTo = "Health",
      text_format = "[tx:classicon:reverse]",
      xOffset = F.Dpi(-6),
      yOffset = F.Dpi(0),
    }),
  },

  -- UnitFrame Arena Buffs
  buffs = {
    priority = "Blacklist,CastByUnit,Dispellable,Whitelist,RaidBuffsElvUI",

    -- Stack Counter
    countPosition = "BOTTOM",
    countYOffset = F.Dpi(-7),

    keepSizeRatio = false,
    sizeOverride = F.Dpi(29),
    height = F.Dpi(19),
  },

  -- UnitFrame Arena Debuffs
  debuffs = {
    desaturate = true,
    priority = "Blacklist,Boss,Personal,RaidDebuffs,CastByUnit,Whitelist",

    -- Stack Counter
    countPosition = "BOTTOM",
    countYOffset = F.Dpi(-7),

    keepSizeRatio = false,
    sizeOverride = F.Dpi(29),
    height = F.Dpi(19),
  },

  -- UnitFrame Arena Trinket
  pvpTrinket = {
    size = F.Dpi(36),
  },

  -- UnitFrame Arena Castbar
  castbar = {
    width = F.Dpi(300),

    icon = true,
    iconAttached = true,

    -- Puts castbar below Combat Icon and Class Icon
    strataAndLevel = {
      frameLevel = 1,
      useCustomLevel = true,
    },
  },

  -- UnitFrame Arena raidicon (Target Marker Icon)
  raidicon = {
    attachTo = "TOPRIGHT",
    size = F.Dpi(24),
    yOffset = F.Dpi(27),
    xOffset = F.Dpi(27),
  },

  -- UnitFrame Arena Power
  power = {
    height = F.Dpi(12),
    text_format = "",
  },

  -- Disable UnitFrame Arena health text
  health = { text_format = "" },
  -- Disable UnitFrame Arena name text
  name = { text_format = "" },
}

local boss = {
  width = F.Dpi(240),
  height = F.Dpi(36),
  spacing = F.Dpi(48),

  -- UnitFrame Boss Custom Texts
  customTexts = {
    -- UnitFrame Boss Custom Texts Health
    ["toxiui:health"] = createCustomText({}, {
      text_format = "[tx:health:percent:nosign]",
      xOffset = F.Dpi(6),
      yOffset = F.Dpi(18),
    }),

    -- UnitFrame Boss Custom Texts Health
    ["toxiui:health-small"] = createCustomText({}, {
      text_format = TXUI.IsRetail and "[tx:health:current:shortvalue:absorb]" or "[tx:health:current:shortvalue]",
      xOffset = F.Dpi(6),
      yOffset = F.Dpi(-18),
    }),

    -- UnitFrame Boss Custom Texts Name
    ["toxiui:name"] = createCustomText({}, {
      justifyH = "RIGHT",
      text_format = "[tx:name:abbrev:medium:split]",
      xOffset = F.Dpi(-6),
      yOffset = F.Dpi(32),
    }),

    -- UnitFrame Boss Custom Texts Power
    ["toxiui:power"] = createCustomText({}, {
      attachTextTo = "Power",
      text_format = "[tx:power:percent:nosign]",
      xOffset = F.Dpi(84),
      yOffset = F.Dpi(0),
    }),
  },

  -- UnitFrame Boss Buffs
  buffs = {
    maxDuration = 300,
    yOffset = F.Dpi(19),

    -- Stack Counter
    countPosition = "BOTTOM",
    countYOffset = F.Dpi(-7),

    keepSizeRatio = false,
    sizeOverride = F.Dpi(29),
    height = F.Dpi(19),
  },

  -- UnitFrame Boss Debuffs
  debuffs = {
    maxDuration = 300,
    yOffset = F.Dpi(-19),

    -- Stack Counter
    countPosition = "BOTTOM",
    countYOffset = F.Dpi(-7),

    keepSizeRatio = false,
    sizeOverride = F.Dpi(29),
    height = F.Dpi(19),
  },

  -- UnitFrame Boss Castbar
  castbar = {
    width = F.Dpi(240),

    icon = true,
    iconAttached = true,

    -- Puts castbar below Combat Icon and Class Icon
    strataAndLevel = {
      frameLevel = 1,
      useCustomLevel = true,
    },
  },

  -- UnitFrame Boss raidicon (Target Marker Icon)
  raidicon = {
    attachTo = "TOPRIGHT",
    size = F.Dpi(24),
    yOffset = F.Dpi(27),
    xOffset = F.Dpi(27),
  },

  -- UnitFrame Boss Power
  power = {
    width = "spaced",
    text_format = "",
  },

  -- Disable UnitFrame Boss health text
  health = { text_format = "" },
  -- Disable UnitFrame Boss name text
  name = { text_format = "" },
}

PF.unitframes.player = player
PF.unitframes.target = target
PF.unitframes.pet = pet
PF.unitframes.targettarget = targettarget
PF.unitframes.focus = focus
PF.unitframes.party = party
PF.unitframes.raid = raid
PF.unitframes.tank = tank
PF.unitframes.assist = assist
PF.unitframes.arena = arena
PF.unitframes.boss = boss
