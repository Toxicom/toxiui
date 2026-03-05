local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local PF = TXUI:GetModule("Profiles")

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

local general = {
  smoothbars = true,
  maxAllowedGroups = false,
  statusbar = I.Textures.Primary,

  altManaPowers = {
    DRUID = {
      Energy = false,
      LunarPower = false,
      Rage = false,
    },
  },
}

local player = {
  width = F.Dpi(300),
  height = F.Dpi(36),
  threatStyle = "NONE",

  disableMouseoverGlow = true,

  customTexts = {
    ["toxiui:name"] = createCustomText({}, {
      attachTextTo = "Health",
      text_format = "[tx:name:medium:split]",
      xOffset = F.Dpi(6),
      yOffset = F.Dpi(32),
    }),

    ["toxiui:level"] = createCustomText({}, {
      justifyH = "LEFT",
      text_format = "[tx:level]",
      xOffset = F.Dpi(22),
      yOffset = F.Dpi(-18),
    }),

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

    ["toxiui:power"] = createCustomText({}, {
      attachTextTo = "Power",
      text_format = "[tx:power]",
      xOffset = 0,
      yOffset = 10,
      justifyH = "CENTER",
    }),

    ["toxiui:power-classbar"] = createCustomText({}, {
      attachTextTo = "ClassPower",
      text_format = "[tx:power:classbar]",
      xOffset = 0,
      yOffset = 10,
      justifyH = "CENTER",
    }),

    ["toxiui:class-icon"] = createCustomText({}, {
      justifyH = "LEFT",
      attachTextTo = "Health",
      text_format = "[tx:classicon]",
      xOffset = F.Dpi(6),
      yOffset = F.Dpi(0),
    }),
  },

  debuffs = {
    anchorPoint = "TOPRIGHT",
    growthX = "LEFT",
    attachTo = "FRAME",
    durationPosition = "CENTER",
    maxDuration = 0,
    perrow = 7,
    priority = "Blacklist,Boss,CCDebuffs,RaidDebuffs,CastByUnit,CastByNPC,Personal",
    spacing = F.Dpi(2),
    xOffset = 0,
    yOffset = F.Dpi(30),

    countPosition = "BOTTOM",
    countYOffset = F.Dpi(-7),

    keepSizeRatio = false,
    sizeOverride = F.Dpi(41),
    height = F.Dpi(27),
  },

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

  raidRoleIcons = {
    enable = true,
    scale = 2,
    xOffset = F.Dpi(6),
    yOffset = F.Dpi(25),
  },

  partyIndicator = {
    enable = false,
  },

  CombatIcon = {
    enable = true,

    anchorPoint = "CENTER",
    size = F.Dpi(30),
    yOffset = F.Dpi(-20),

    defaultColor = true,
    color = F.Table.HexToRGB("#ffffff"),

    texture = "CUSTOM",
    customTexture = I.General.MediaPath .. "Textures\\Icons\\CombatStylized.blp",
  },

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

  castbar = {
    width = F.Dpi(300),
    height = F.Dpi(24),

    insideInfoPanel = false,
    icon = true,
    iconAttached = true,

    textColor = F.Table.HexToRGB("#ffffff"),
    xOffsetText = F.Dpi(6),
    xOffsetTime = F.Dpi(-12),

    strataAndLevel = {
      frameLevel = 1,
      useCustomLevel = true,
    },
  },

  healPrediction = {
    absorbStyle = "REVERSED",
  },

  aurabar = { enable = false },
  health = { text_format = "" },
  name = { text_format = "" },
  buffs = { enable = false },
}

local function getTarget(horizontal)
  return {
    width = F.Dpi(300),
    height = F.Dpi(36),
    threatStyle = "NONE",

    disableMouseoverGlow = true,
    orientation = "LEFT",

    customTexts = {
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

      ["toxiui:name"] = createCustomText({}, {
        justifyH = "RIGHT",
        text_format = "[tx:name:abbrev:medium:split]",
        xOffset = F.Dpi(-6),
        yOffset = F.Dpi(32),
      }),

      ["toxiui:level"] = createCustomText({}, {
        justifyH = "RIGHT",
        text_format = "[tx:level:difficulty]",
        xOffset = F.Dpi(-18),
        yOffset = F.Dpi(-18),
      }),

      ["toxiui:power"] = createCustomText({}, {
        attachTextTo = "Power",
        text_format = "[tx:power:percent:nosign]",
        xOffset = F.Dpi(102),
        yOffset = F.Dpi(0),
      }),

      ["toxiui:class-icon"] = createCustomText({}, {
        justifyH = "RIGHT",
        attachTextTo = "Health",
        text_format = "[tx:classicon:reverse:player]",
        xOffset = F.Dpi(-6),
        yOffset = F.Dpi(0),
      }),

      ["toxiui:classification"] = createCustomText({}, {
        justifyH = "RIGHT",
        attachTextTo = "Health",
        text_format = "[tx:classification]",
        xOffset = F.Dpi(18),
        yOffset = F.Dpi(30),
      }),
    },

    buffs = {
      anchorPoint = "TOPRIGHT",
      growthX = "LEFT",
      perrow = 7,
      priority = "Blacklist,Personal,Boss,NonPersonal,CastByUnit",
      spacing = F.Dpi(2),
      xOffset = 0,
      yOffset = F.Dpi(72),

      countPosition = "BOTTOM",
      countYOffset = F.Dpi(-7),

      keepSizeRatio = false,
      sizeOverride = F.Dpi(41),
      height = F.Dpi(27),
    },

    debuffs = {
      anchorPoint = "TOPLEFT",
      growthX = "RIGHT",
      attachTo = "FRAME",
      durationPosition = "CENTER",
      maxDuration = 0,
      perrow = 7,
      priority = "Blacklist,Boss,Personal,RaidDebuffs,CastByUnit,CCDebuffs",
      spacing = 2,
      xOffset = 0,
      yOffset = F.Dpi(30),

      countPosition = "BOTTOM",
      countYOffset = F.Dpi(-7),

      keepSizeRatio = false,
      sizeOverride = F.Dpi(41),
      height = F.Dpi(27),

      -- Filters (ElvUI Default)
      isAuraRaid = true,
      isAuraRaidPlayer = true,
    },

    -- New "Custom" tab introduced in ElvUI 14.00
    auras = {
      enable = false,
    },

    raidicon = {
      attachTo = "TOPRIGHT",
      size = F.Dpi(24),
      yOffset = F.Dpi(27),
      xOffset = F.Dpi(27),
    },

    raidRoleIcons = {
      enable = true,
      scale = 2,
      position = "TOPRIGHT",
      xOffset = F.Dpi(-6),
      yOffset = F.Dpi(25),
    },

    castbar = {
      width = F.Dpi(300),
      height = F.Dpi(24),

      insideInfoPanel = false,
      icon = true,
      iconAttached = true,

      textColor = F.Table.HexToRGB("#ffffff"),
      xOffsetText = F.Dpi(6),
      xOffsetTime = F.Dpi(-12),

      strataAndLevel = {
        frameLevel = 1,
        useCustomLevel = true,
      },
    },

    healPrediction = {
      absorbStyle = "REVERSED",
    },

    CombatIcon = { enable = false },
    aurabar = { enable = false },
    fader = { enable = horizontal, range = horizontal },

    power = {
      enable = true,
      detachFromFrame = true,
      autoHide = true,
      detachedWidth = F.Dpi(144),
      text_format = "",
    },

    health = { text_format = "" },
    name = { text_format = "" },
  }
end

local pet = {
  width = F.Dpi(120),
  height = F.Dpi(18),
  disableTargetGlow = false,
  threatStyle = "NONE",

  customTexts = {
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

  castbar = {
    textColor = F.Table.HexToRGB("#ffffff"),
    height = F.Dpi(14),
    width = F.Dpi(120),

    icon = true,
    iconAttached = true,
  },

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

  health = { text_format = "", colorHappiness = false },
  name = { text_format = "" },
  power = { enable = false },
  debuffs = { enable = false },
}

local targettarget = {
  width = F.Dpi(120),
  height = F.Dpi(18),
  threatStyle = "NONE",
  disableMouseoverGlow = true,

  customTexts = {
    ["toxiui:name"] = createCustomText({}, {
      text_format = "[tx:name:short:split]",
      xOffset = F.Dpi(0),
      yOffset = F.Dpi(18),
      justifyH = "CENTER",
    }),
  },

  raidicon = {
    size = F.Dpi(19),
    attachTo = "CENTER",
    yOffset = F.Dpi(0),
  },

  health = { text_format = "" },
  name = { text_format = "" },
  power = { enable = false },
  debuffs = { enable = false },
}

local focus = {
  width = F.Dpi(300),
  height = F.Dpi(36),
  threatStyle = "NONE",

  orientation = "LEFT",
  disableMouseoverGlow = true,
  disableTargetGlow = true,

  customTexts = {
    ["toxiui:name"] = createCustomText({}, {
      justifyH = "RIGHT",
      text_format = "[tx:name:medium:split]",
      xOffset = F.Dpi(-6),
      yOffset = F.Dpi(32),
    }),

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

    ["toxiui:power"] = createCustomText({}, {
      attachTextTo = "Power",
      text_format = "[tx:power:percent:nosign]",
      xOffset = F.Dpi(102),
      yOffset = F.Dpi(0),
    }),

    ["toxiui:class-icon"] = createCustomText({}, {
      justifyH = "RIGHT",
      attachTextTo = "Health",
      text_format = "[tx:classicon:reverse]",
      xOffset = F.Dpi(-6),
      yOffset = F.Dpi(0),
    }),
  },

  buffs = {
    enable = false,
    anchorPoint = "TOPLEFT",
    maxDuration = 0,
    perrow = 5,
    priority = "Blacklist,Personal,PlayerBuffs,Whitelist,blockNoDuration,NonPersonal",
    sizeOverride = F.Dpi(29),

    countPosition = "BOTTOM",
    countYOffset = F.Dpi(-7),

    spacing = F.Dpi(2),
    xOffset = F.Dpi(4),
    yOffset = F.Dpi(30),

    -- Filters (ElvUI Default)
    isAuraBigDefensive = true,
    isAuraExternalDefensive = true,
    isAuraExternalDefensivePlayer = true,
  },

  debuffs = {
    durationPosition = "CENTER",
    maxDuration = 0,
    priority = "Blacklist,Personal,NonPersonal",
    spacing = F.Dpi(0),
    xOffset = F.Dpi(-4),
    yOffset = F.Dpi(30),

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

  castbar = {
    height = F.Dpi(24),
    width = F.Dpi(300),
    insideInfoPanel = false,

    icon = true,
    iconAttached = true,

    textColor = F.Table.HexToRGB("#ffffff"),
    xOffsetText = F.Dpi(6),
    xOffsetTime = F.Dpi(-12),

    customColor = {
      useClassColor = true,
    },

    -- Puts castbar below Combat Icon and Class Icon
    strataAndLevel = {
      frameLevel = 1,
      useCustomLevel = true,
    },
  },

  power = {
    width = "spaced",
    text_format = "",
    detachedWidth = F.Dpi(144),
    detachFromFrame = true,
    autoHide = true,
    position = "RIGHT",
    xOffset = F.Dpi(-2),
  },

  CombatIcon = { enable = false },
  health = { text_format = "" },
  name = { text_format = "" },
}

local function getParty(horizontal)
  return {
    width = horizontal and F.Dpi(150) or F.Dpi(240),
    height = horizontal and F.Dpi(72) or F.Dpi(36),

    visibility = "[@raid1,exists][@party1,noexists] hide;show",

    groupBy = "ROLE",
    growthDirection = horizontal and "RIGHT_DOWN" or "DOWN_LEFT",
    horizontalSpacing = F.Dpi(6),
    raidWideSorting = true,
    showPlayer = horizontal,
    startFromCenter = true,
    verticalSpacing = horizontal and F.Dpi(6) or F.Dpi(48),

    customTexts = {
      ["toxiui:name"] = createCustomText({}, {
        text_format = "[tx:name:abbrev:medium:split]",
        xOffset = horizontal and F.Dpi(8) or F.Dpi(6),
        yOffset = horizontal and F.Dpi(0) or F.Dpi(32),
      }),

      ["toxiui:health"] = createCustomText({}, {
        justifyH = "RIGHT",
        text_format = "[tx:health:percent:nosign]",
        xOffset = F.Dpi(-12),
        yOffset = horizontal and F.Dpi(0) or F.Dpi(18),
      }),

      ["toxiui:level"] = createCustomText({}, {
        justifyH = "LEFT",
        text_format = "[tx:level:difficulty]",
        xOffset = horizontal and F.Dpi(24) or F.Dpi(22),
        yOffset = horizontal and F.Dpi(-20) or F.Dpi(-12),
      }),

      ["toxiui:power"] = createCustomText({}, {
        justifyH = horizontal and "RIGHT" or "LEFT",
        attachTextTo = "Power",
        text_format = "[tx:power:percent:nosign]",
        xOffset = horizontal and F.Dpi(-12) or F.Dpi(12),
        yOffset = F.Dpi(0),
      }),

      ["toxiui:class-icon"] = createCustomText({}, {
        enable = not horizontal,
        justifyH = "LEFT",
        attachTextTo = "Health",
        text_format = "[tx:classicon]",
        xOffset = F.Dpi(6),
        yOffset = F.Dpi(0),
      }),
    },

    buffIndicator = {
      size = F.Dpi(12),
    },

    buffs = {
      enable = true,
      anchorPoint = horizontal and "BOTTOM" or "LEFT",
      growthX = "LEFT",
      perrow = horizontal and 4 or 5,
      numrows = horizontal and 2 or 1,
      spacing = 2,
      yOffset = horizontal and F.Dpi(-6) or 0,
      xOffset = horizontal and 0 or F.Dpi(-40),

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

    debuffs = {
      attachTo = "HEALTH",
      anchorPoint = horizontal and "TOP" or "RIGHT",
      perrow = horizontal and 4 or 5,
      numrows = horizontal and 2 or 1,
      priority = "Blacklist,Dispellable,Boss,RaidDebuffs,CCDebuffs,Whitelist",
      spacing = 2,
      yOffset = horizontal and F.Dpi(22) or 0,
      xOffset = horizontal and 0 or 10,

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

    healPrediction = {
      enable = true,
      absorbStyle = "REVERSED",
    },

    phaseIndicator = {
      scale = F.DpiRaw(1),
    },

    raidicon = {
      attachTo = "TOPLEFT",
      size = F.Dpi(24),
      xOffset = F.Dpi(-27),
      yOffset = F.Dpi(27),
    },

    raidRoleIcons = {
      enable = true,
      scale = 2,
      position = "TOPLEFT",
      xOffset = F.Dpi(12),
      yOffset = F.Dpi(25),
    },

    rdebuffs = {
      enable = horizontal,
      size = F.Dpi(36),
      yOffset = F.Dpi(24),
    },

    readycheckIcon = {
      position = "CENTER",
      size = F.Dpi(48),
      yOffset = F.Dpi(0),
    },

    roleIcon = {
      damager = not horizontal,
      position = horizontal and "TOPLEFT" or "LEFT",
      size = horizontal and F.Dpi(22) or F.Dpi(36),
      xOffset = horizontal and F.Dpi(-12) or F.Dpi(-35),
      yOffset = horizontal and F.Dpi(12) or F.Dpi(0),
    },

    power = {
      width = horizontal and "filled" or "spaced",
      height = horizontal and F.Dpi(18) or F.Dpi(12),
      text_format = "",
    },

    health = { text_format = "" },
    name = { text_format = "" },
    CombatIcon = { enable = false },
  }
end

local function getRaid(horizontal)
  return {
    enable = true,
    width = F.Dpi(120),
    height = F.Dpi(50),

    groupBy = "GROUP",
    groupSpacing = 10,
    groupsPerRowCol = 1,
    growthDirection = horizontal and "DOWN_RIGHT" or "RIGHT_UP",
    horizontalSpacing = F.Dpi(1),
    numGroups = 8,
    raidWideSorting = false,
    startFromCenter = false,
    verticalSpacing = F.Dpi(1),

    customTexts = {
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

    healPrediction = {
      enable = true,
      absorbStyle = "REVERSED",
    },

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

    readycheckIcon = {
      size = F.Dpi(29),
    },

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

    health = { text_format = "" },
    name = { text_format = "" },
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
end

local tank = {
  name = {
    text_format = "",
  },

  customTexts = {
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

  health = { text_format = "" },
}

local assist = {
  name = {
    text_format = "",
  },

  customTexts = {
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

  health = { text_format = "" },
}

local arena = {
  width = F.Dpi(240),
  height = F.Dpi(36),
  spacing = F.Dpi(48),
  pvpSpecIcon = false,

  customTexts = {
    ["toxiui:health"] = createCustomText({}, {
      text_format = "[tx:health:percent:nosign]",
      xOffset = F.Dpi(12),
      yOffset = F.Dpi(18),
    }),

    ["toxiui:name"] = createCustomText({}, {
      justifyH = "RIGHT",
      text_format = "[tx:name:medium:split]",
      xOffset = F.Dpi(-6),
      yOffset = F.Dpi(32),
    }),

    ["toxiui:power"] = createCustomText({}, {
      attachTextTo = "Power",
      text_format = "[tx:power:percent:nosign]",
      xOffset = F.Dpi(102),
      yOffset = F.Dpi(0),
    }),

    ["toxiui:class-icon"] = createCustomText({}, {
      justifyH = "RIGHT",
      attachTextTo = "Health",
      text_format = "[tx:classicon:reverse]",
      xOffset = F.Dpi(-6),
      yOffset = F.Dpi(0),
    }),
  },

  buffs = {
    priority = "Blacklist,CastByUnit,Dispellable,Whitelist,RaidBuffsElvUI",

    countPosition = "BOTTOM",
    countYOffset = F.Dpi(-7),

    keepSizeRatio = false,
    sizeOverride = F.Dpi(29),
    height = F.Dpi(19),
  },

  debuffs = {
    desaturate = true,
    priority = "Blacklist,Boss,Personal,RaidDebuffs,CastByUnit,Whitelist",

    countPosition = "BOTTOM",
    countYOffset = F.Dpi(-7),

    keepSizeRatio = false,
    sizeOverride = F.Dpi(29),
    height = F.Dpi(19),
  },

  pvpTrinket = {
    size = F.Dpi(36),
  },

  castbar = {
    width = F.Dpi(300),

    icon = true,
    iconAttached = true,

    strataAndLevel = {
      frameLevel = 1,
      useCustomLevel = true,
    },
  },

  raidicon = {
    attachTo = "TOPRIGHT",
    size = F.Dpi(24),
    yOffset = F.Dpi(27),
    xOffset = F.Dpi(27),
  },

  power = {
    height = F.Dpi(12),
    text_format = "",
  },

  health = { text_format = "" },
  name = { text_format = "" },
}

local boss = {
  width = F.Dpi(240),
  height = F.Dpi(36),
  spacing = F.Dpi(48),

  customTexts = {
    ["toxiui:health"] = createCustomText({}, {
      text_format = "[tx:health:percent:nosign]",
      xOffset = F.Dpi(6),
      yOffset = F.Dpi(18),
    }),

    ["toxiui:health-small"] = createCustomText({}, {
      text_format = TXUI.IsRetail and "[tx:health:current:shortvalue:absorb]" or "[tx:health:current:shortvalue]",
      xOffset = F.Dpi(6),
      yOffset = F.Dpi(-18),
    }),

    ["toxiui:name"] = createCustomText({}, {
      justifyH = "RIGHT",
      text_format = "[tx:name:abbrev:medium:split]",
      xOffset = F.Dpi(-6),
      yOffset = F.Dpi(32),
    }),

    ["toxiui:power"] = createCustomText({}, {
      attachTextTo = "Power",
      text_format = "[tx:power:percent:nosign]",
      xOffset = F.Dpi(84),
      yOffset = F.Dpi(0),
    }),
  },

  buffs = {
    maxDuration = 300,
    yOffset = F.Dpi(19),

    countPosition = "BOTTOM",
    countYOffset = F.Dpi(-7),

    keepSizeRatio = false,
    sizeOverride = F.Dpi(29),
    height = F.Dpi(19),
  },

  debuffs = {
    maxDuration = 300,
    yOffset = F.Dpi(-19),

    countPosition = "BOTTOM",
    countYOffset = F.Dpi(-7),

    keepSizeRatio = false,
    sizeOverride = F.Dpi(29),
    height = F.Dpi(19),
  },

  castbar = {
    width = F.Dpi(240),

    icon = true,
    iconAttached = true,

    strataAndLevel = {
      frameLevel = 1,
      useCustomLevel = true,
    },
  },

  raidicon = {
    attachTo = "TOPRIGHT",
    size = F.Dpi(24),
    yOffset = F.Dpi(27),
    xOffset = F.Dpi(27),
  },

  power = {
    width = "spaced",
    text_format = "",
  },

  health = { text_format = "" },
  name = { text_format = "" },
}

function PF:ApplyUnitframes(pf, colors, IsHorizontalLayout)
  -- UnitFrames General
  F.Table.Crush(pf.unitframe, general)

  -- UnitFrames Colors
  F.Table.Crush(pf.unitframe.colors, colors.unitframe.colors)

  -- UnitFrame Units
  F.Table.Crush(pf.unitframe.units.player, player)
  F.Table.Crush(pf.unitframe.units.target, getTarget(IsHorizontalLayout))
  F.Table.Crush(pf.unitframe.units.pet, pet)
  F.Table.Crush(pf.unitframe.units.targettarget, targettarget)
  F.Table.Crush(pf.unitframe.units.focus, focus)
  F.Table.Crush(pf.unitframe.units.party, getParty(IsHorizontalLayout))
  F.Table.Crush(pf.unitframe.units.tank, tank)
  F.Table.Crush(pf.unitframe.units.assist, assist)
  F.Table.Crush(pf.unitframe.units.arena, arena)
  F.Table.Crush(pf.unitframe.units.boss, boss)

  -- UnitFrame Raid Groups (shared base config, per-group name/visibility)
  local raidBase = getRaid(IsHorizontalLayout)

  F.Table.Crush(pf.unitframe.units.raid1, raidBase, {
    customName = TXUI.IsRetail and "1 to 20" or "1 to 10",
    visibility = TXUI.IsRetail and "[@raid1,noexists][@raid21,exists] hide;show" or "[@raid1,noexists][@raid11,exists] hide;show",
  })

  F.Table.Crush(pf.unitframe.units.raid2, raidBase, {
    customName = TXUI.IsRetail and "21 to 30" or "11 to 25",
    visibility = TXUI.IsRetail and "[@raid21,noexists][@raid31,exists] hide;show" or "[@raid11,noexists][@raid26,exists] hide;show",
  })

  F.Table.Crush(pf.unitframe.units.raid3, raidBase, {
    customName = TXUI.IsRetail and "31+" or "26+",
    visibility = TXUI.IsRetail and "[@raid31,noexists] hide;show" or "[@raid26,noexists] hide;show",
  })
end
