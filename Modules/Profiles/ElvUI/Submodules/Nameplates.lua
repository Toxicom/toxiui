local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local PF = TXUI:GetModule("Profiles")

local sharedAuras = {
  height = F.Dpi(20),
  keepSizeRatio = false,
  size = F.Dpi(30),
  xOffset = F.Dpi(15),
}

local sharedBuffs = {
  anchorPoint = "TOPRIGHT",
  attachTo = "DEBUFFS",
  growthX = "LEFT",
  keepSizeRatio = false,
  size = F.Dpi(30),
  height = F.Dpi(20),
  yOffset = F.Dpi(8),
  countYOffset = F.Dpi(-5),
  countPosition = "BOTTOM",
  sourceText = {
    enable = false,
  },
}

local sharedCastbar = {
  anchorPoint = "BOTTOM",
  iconOffsetX = F.Dpi(2),
  iconOffsetY = F.Dpi(-2),
  iconSize = F.Dpi(24),
  showIcon = false,
  textYOffset = F.Dpi(-2),
  timeYOffset = F.Dpi(-2),
  yOffset = F.Dpi(8),
  width = F.Dpi(150),
  height = F.Dpi(8),
}

local sharedDebuffs = {
  anchorPoint = "TOPLEFT",
  growthX = "RIGHT",
  keepSizeRatio = false,
  size = F.Dpi(30),
  height = F.Dpi(20),
  xOffset = F.Dpi(-1),
  yOffset = F.Dpi(5),
  countYOffset = F.Dpi(-5),
  countPosition = "BOTTOM",
}

local sharedHealth = {
  text = {
    position = "TOPRIGHT",
    yOffset = F.Dpi(-10),
  },
  width = F.Dpi(150),
  height = F.Dpi(10),

  useClassificationColor = true,
  useClassificationColorInInstance = true,
}

local sharedRaidTarget = {
  size = F.Dpi(16),
  xOffset = F.Dpi(-15),
}

local nameplates = {
  highlight = false,
  statusbar = I.Textures.Primary,
  classColorNames = true,

  visibility = {
    friendly = {
      npcs = false,
    },
  },

  enviromentConditions = {
    friendlyEnabled = false,
    friendly = {
      arena = true,
      party = true, -- dungeons
      resting = false,
      world = false,
      pvp = false, -- battlegrounds
      scenario = true,
      raid = false,
    },

    stackingEnabled = true,
    stackingNameplates = {
      arena = true,
      party = true, -- dungeons
      resting = true,
      world = true,
      pvp = true, -- battlegrounds
      scenario = true,
      raid = true,
    },
  },

  units = {
    ["ENEMY_NPC"] = {
      auras = sharedAuras,
      buffs = sharedBuffs,
      castbar = sharedCastbar,
      debuffs = sharedDebuffs,
      health = sharedHealth,
      level = {
        enable = true,
        position = "TOPLEFT",
        xOffset = F.Dpi(-13),
        yOffset = F.Dpi(-10),
      },
      name = {
        yOffset = F.Dpi(-10),
      },
      raidTargetIndicator = sharedRaidTarget,
    },

    ["FRIENDLY_NPC"] = {
      auras = sharedAuras,
      buffs = sharedBuffs,
      castbar = sharedCastbar,
      debuffs = sharedDebuffs,
      health = sharedHealth,
      level = {
        enable = false,
      },
      name = {
        yOffset = F.Dpi(-10),
      },
      title = {
        enable = true,
        yOffset = F.Dpi(-10),
      },
      raidTargetIndicator = sharedRaidTarget,
    },

    ["ENEMY_PLAYER"] = {
      auras = sharedAuras,
      buffs = sharedBuffs,
      castbar = sharedCastbar,
      debuffs = sharedDebuffs,
      health = sharedHealth,
      level = {
        enable = false,
      },
      name = {
        yOffset = F.Dpi(-10),
      },
      raidTargetIndicator = sharedRaidTarget,
    },

    ["FRIENDLY_PLAYER"] = {
      nameOnly = true,

      auras = sharedAuras,
      buffs = sharedBuffs,
      castbar = sharedCastbar,
      debuffs = sharedDebuffs,
      health = sharedHealth,
      level = {
        enable = false,
      },
      name = {
        yOffset = F.Dpi(-10),
      },
      raidTargetIndicator = sharedRaidTarget,
      title = {
        enable = true,
      },
    },

    ["TARGET"] = {
      arrow = "Arrow0",
      arrowScale = 0.2,
      arrowSpacing = 4,
      glowStyle = "style4",
    },
  },
}

function PF:ApplyNameplates(pf, colors)
  F.Table.Crush(pf.nameplates, nameplates)
  F.Table.Crush(pf.nameplates.colors, colors.nameplates.colors)
end
