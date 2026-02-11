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
    },

    -- UnitFrame Colors MouseOver Glow
    frameGlow = {
      mouseoverGlow = {
        texture = "- ToxiUI",
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

  -- Special Case: ToxiUIWAAnchor
  local WAAnchorY = { 395, 479 }

  local defaultPadding = 4
  local IsHorizontalLayout = E.db.TXUI.installer.layout == I.Enum.Layouts.HORIZONTAL

  -- Movers
  F.Table.Crush(
    pf.movers,
    {
      -- F.Position(1, 2, 3)
      -- 1 => Anchor position of SELECTED FRAME
      -- 2 => Anchor Parent
      -- 3 => Anchor position of PARENT FRAME

      -- Movers: Pop-ups
      MicrobarMover = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOMLEFT", 594, 36),
      LootFrameMover = F.Position("CENTER", "ElvUIParent", "CENTER", 360, 0),
      AlertFrameMover = F.Position("LEFT", "LootFrameMover", "RIGHT", 240, -60),

      -- Movers: Bars
      ExperienceBarMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 52),
      ReputationBarMover = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -4, -317),
      ThreatBarMover = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -665, -436),

      -- Movers: ActionBars
      ElvAB_1 = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 54),
      ElvAB_6 = F.Position("BOTTOMRIGHT", "ElvAB_1", "BOTTOMLEFT", -defaultPadding * 4, 0), -- Close Left
      ElvAB_5 = F.Position("BOTTOMLEFT", "ElvAB_1", "BOTTOMRIGHT", defaultPadding * 4, 0), -- Close Right
      ElvAB_3 = F.Position("BOTTOMRIGHT", "ElvAB_6", "BOTTOMLEFT", -defaultPadding * 4, 0), -- Far Left
      ElvAB_4 = F.Position("BOTTOMLEFT", "ElvAB_5", "BOTTOMRIGHT", defaultPadding * 4, 0), -- Far Right

      ElvAB_2 = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -44, -481), -- Unused
      ElvAB_7 = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -88, -481), -- Unused
      ElvAB_8 = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -131, -481), -- Unused
      ElvAB_9 = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -173, -481), -- Unused
      ElvAB_10 = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -216, -481), -- Unused

      PetAB = F.Position("TOP", "ElvUF_Player", "BOTTOM", 0, -defaultPadding),
      VehicleLeaveButton = F.Position("BOTTOMLEFT", "ElvAB_4", "BOTTOMRIGHT", defaultPadding, 0),
      DurabilityFrameMover = F.Position("BOTTOMLEFT", "ElvAB_4", "BOTTOMRIGHT", 41, 0),
      ShiftAB = F.Position("BOTTOM", "ElvAB_1", "TOP", 0, defaultPadding),

      -- Movers: UnitFrames
      ElvUF_PlayerMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", -390, 420),
      ElvUF_PlayerCastbarMover = F.Position("TOPLEFT", "ElvUF_Player", "BOTTOMLEFT", 0, -defaultPadding),
      PlayerPowerBarMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 446),
      ClassBarMover = F.Position("BOTTOM", "PlayerPowerBarMover", "TOP", 0, defaultPadding / 2),

      ElvUF_TargetMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 390, 420),
      ElvUF_TargetCastbarMover = F.Position("TOPRIGHT", "ElvUF_Target", "BOTTOMRIGHT", 0, -defaultPadding),
      TargetPowerBarMover = F.Position("LEFT", "ElvUF_Target", "BOTTOMLEFT", 12, 0),

      ElvUF_TargetTargetMover = F.Position("TOPLEFT", "ElvUF_Target", "TOPRIGHT", defaultPadding, 0),

      ElvUF_PetMover = F.Position("TOPRIGHT", "ElvUF_Player", "TOPLEFT", -defaultPadding, 0),
      ElvUF_PetCastbarMover = F.Position("TOPLEFT", "ElvUF_Pet", "BOTTOMLEFT", 0, -1),

      ElvUF_FocusMover = F.Position("TOP", "ElvUF_Target", "BOTTOM", 0, -72),
      ElvUF_FocusCastbarMover = F.Position("TOPLEFT", "ElvUF_FocusMover", "BOTTOMLEFT", 0, -defaultPadding),
      FocusPowerBarMover = F.Position("LEFT", "ElvUF_FocusMover", "BOTTOMLEFT", 12, 0),

      ElvUF_PartyMover = F.Position("LEFT", "ElvUIParent", "LEFT", 360, 0, true),

      ElvUF_Raid1Mover = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOMLEFT", 72, 402),
      ElvUF_Raid2Mover = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOMLEFT", 72, 402),
      ElvUF_Raid3Mover = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOMLEFT", 72, 402),

      ArenaHeaderMover = F.Position("RIGHT", "ElvUIParent", "RIGHT", -360, 0, true, true),
      BossHeaderMover = F.Position("TOPRIGHT", "ArenaHeaderMover", "TOPRIGHT", 0, 0),

      ElvUF_TankMover = F.Position("TOPLEFT", "LeftChatMover", "TOPRIGHT", defaultPadding, 0),
      ElvUF_AssistMover = F.Position("TOPLEFT", "ElvUF_TankMover", "BOTTOMLEFT", 0, -defaultPadding),

      -- Movers: Chat
      LeftChatMover = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOMLEFT", defaultPadding, 72),
      RightChatMover = F.Position("BOTTOMRIGHT", "ElvUIParent", "BOTTOMRIGHT", -defaultPadding, 54),

      -- Movers: Bags
      ElvUIBagMover = F.Position("BOTTOMLEFT", "RightChatMover", "TOPLEFT", 0, defaultPadding),
      ElvUIBankMover = F.Position("BOTTOMRIGHT", "LeftChatMover", "TOPRIGHT", 0, defaultPadding),

      -- Movers: Buffs
      BuffsMover = F.Position("TOPLEFT", "ElvUIParent", "TOPLEFT", defaultPadding, -defaultPadding),
      DebuffsMover = F.Position("TOPLEFT", "BuffsMover", "BOTTOMLEFT", 0, -defaultPadding),

      -- Movers: Misc
      BelowMinimapContainerMover = F.Position("TOPLEFT", "ElvUIParent", "TOPLEFT", 234, -264),
      BNETMover = F.Position("TOPRIGHT", "MinimapMover", "TOPLEFT", -defaultPadding, 0),
      GMMover = F.Position("TOPRIGHT", "BNETMover", "BOTTOMRIGHT", 0, -defaultPadding),
      MinimapMover = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -defaultPadding, -defaultPadding),
      ObjectiveFrameMover = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -84, -324),
      TooltipMover = F.Position("BOTTOMRIGHT", "RightChatMover", "TOPRIGHT", -18, 138),
      TopCenterContainerMover = F.Position("TOP", "ElvUIParent", "TOP", 0, -42),
      VOICECHAT = F.Position("TOPLEFT", "DebuffsMover", "BOTTOMLEFT", 0, -defaultPadding),
      QueueStatusMover = F.Position("BOTTOMRIGHT", "MinimapMover", "BOTTOMRIGHT", -defaultPadding * 2, defaultPadding * 2),

      -- Movers: ToxiUI
      ToxiUIWAAnchorMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, WAAnchorY[1]),
    },
    F.Table.If(TXUI.IsRetail, {
      -- Movers: Bars Retail Only
      AltPowerBarMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 216),
      AzeriteBarMover = F.Position("TOP", "ElvUIParent", "TOP", 421, -389),
      HonorBarMover = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -688, -506),
      WTExtraItemsBar1Mover = F.Position("BOTTOMRIGHT", "RightChatMover", "BOTTOMLEFT", -defaultPadding, 0),

      -- Movers: ActionBars Retail Only
      BossButton = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", -360, 240),
      PetBattleABMover = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOMLEFT", 91, 376),
      ZoneAbility = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOMLEFT", 756, 240),

      -- Movers: Chat
      WTRaidMarkersBarAnchor = F.Position("BOTTOMLEFT", "LeftChatMover", "TOPLEFT", 0, F.IsAddOnEnabled("Chattynator") and defaultPadding + 72 or defaultPadding),

      -- Movers: Misc Retail Only
      LevelUpBossBannerMover = F.Position("TOP", "ElvUIParent", "TOP", 0, -204),
      LossControlMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 606),
      PetBattleStatusMover = F.Position("TOP", "PetBattleFrame", "TOP", 0, 0),
      RaidUtility_Mover = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -660, -5),
      SocialMenuMover = F.Position("TOPLEFT", "ElvUIParent", "TOPLEFT", 5, -224),
      UIErrorsFrameMover = F.Position("TOP", "UIParent", "TOP", 0, -146),
      VehicleSeatMover = F.Position("BOTTOMRIGHT", "ElvUIParent", "BOTTOMRIGHT", -366, 396),
      PowerBarContainerMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 190),
      AddonCompartmentMover = F.Position("TOPRIGHT", "MinimapMover", "TOPRIGHT", -defaultPadding, -defaultPadding * 4),
    }),
    F.Table.If(IsHorizontalLayout, {
      -- Horizontal Layout
      AltPowerBarMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 391, 622),
      BossButton = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 678, 282),

      PlayerPowerBarMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 482),
      ClassBarMover = F.Position("BOTTOM", "PlayerPowerBarMover", "TOP", 0, defaultPadding / 2),

      ElvUF_PlayerMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", -390, 504),
      ElvUF_TargetMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 390, 504),

      ElvUF_FocusMover = F.Position("BOTTOMLEFT", "ElvUF_Target", "TOPLEFT", 0, 192),

      ElvUF_PartyMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 240),
      ElvUF_Raid1Mover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 144),
      ElvUF_Raid2Mover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 144),
      ElvUF_Raid3Mover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 144),

      ZoneAbility = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOMLEFT", 678, 282),

      ToxiUIWAAnchorMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, WAAnchorY[2]),
    }),
    F.Table.If(TXUI.IsClassic, {
      TotemBarMover = F.Position("BOTTOM", "ElvAB_1", "TOP", 0, defaultPadding),
    }),
    F.Table.If(not TXUI.IsRetail, {
      MirrorTimer1Mover = F.Position("TOP", "ElvUIParent", "TOP", 0, -72),
      MirrorTimer2Mover = F.Position("TOP", "MirrorTimer1Mover", "BOTTOM", 0, -defaultPadding),
      MirrorTimer3Mover = F.Position("TOP", "MirrorTimer2Mover", "BOTTOM", 0, -defaultPadding),
    })
  )

  -- General
  F.Table.Crush(pf.general, {
    -- General AFK Mode
    afk = true,
    gameMenuScale = 0.8,

    -- General Options
    autoRepair = "PLAYER",
    bottomPanel = false,
    resurrectSound = true,
    stickyFrames = false,
    talkingHeadFrameBackdrop = true,
    talkingHeadFrameScale = F.DpiRaw(1),

    -- General Quest Tracker
    objectiveFrameAutoHide = false,
    objectiveFrameAutoHideInKeystone = false,
    objectiveFrameHeight = F.Dpi(600),

    -- General Colors
    valuecolor = F.Table.CurrentClassColor(),
    backdropcolor = F.Table.HexToRGB("#1a1a1a"),
    backdropfadecolor = F.Table.HexToRGB("#292929CC"),
    bordercolor = F.Table.HexToRGB("#000000"),

    -- General MiniMap
    minimap = {
      -- General MiniMap Size
      size = F.Dpi(276),

      -- General MiniMap Icons
      icons = {
        -- General MiniMap Icons LFG Eye
        lfgEye = {
          xOffset = F.Dpi(0),
          scale = 0.8,
        },

        -- General MiniMap Icons Mail
        mail = {
          xOffset = F.Dpi(0),
          yOffset = F.Dpi(0),
        },
      },
    },

    queueStatus = {
      xOffset = 0,
      yOffset = 0,
    },

    -- Loot Roll
    lootRoll = {
      statusBarTexture = F.ChooseForGradient("- ToxiUI", "- Tx Right"),
      buttonSize = 30,
      leftButtons = true,
    },

    -- AltPowerBar
    altPowerBar = {
      statusBar = "- ToxiUI",
    },

    -- AddOn Compartment
    addonCompartment = {
      size = 24,
    },

    -- Default ElvUI
    customGlow = {
      style = "Pixel Glow",
      color = { r = 0.95, g = 0.95, b = 0, a = 0.9 },
      startAnimation = true,
      useColor = false,
      duration = 1,
      speed = 0.3,
      lines = 8,
      size = 1,
    },

    classColors = {
      ["SHAMAN"] = F.Table.HexToRGB("#006edb"),
    },
  })

  -- Cooldown
  do
    local whiteText = { colors = { text = F.Table.HexToRGB("#ffffff") } }

    F.Table.Crush(pf.cooldown, {
      actionbar = whiteText,
      aurabars = whiteText,
      auraindicator = whiteText,
      bags = whiteText,
      bossbutton = whiteText,
      global = whiteText,
      nameplates = { reverse = true, colors = { text = F.Table.HexToRGB("#ffffff") } },
      totemtracker = whiteText,
      unitframe = { reverse = true, colors = { text = F.Table.HexToRGB("#ffffff") } },
      zonebutton = whiteText,
      cdmanager = { reverse = true, colors = { text = F.Table.HexToRGB("#ffffff") } },
      auras = {
        colors = { text = F.Table.CurrentClassColor() },
        offsetY = -10,
      },
    })
  end

  -- Tooltip
  F.Table.Crush(pf.tooltip, {
    -- Tooltip Options
    colorAlpha = 0.75,
    guildRanks = false,
    playerTitles = false,

    -- Tooltip Healthbar
    healthBar = {
      height = 3,
    },

    -- Tooltip Visibility
    visibility = {
      combatOverride = "SHOW",
    },
  })

  -- Bags
  F.Table.Crush(pf.bags, {
    -- Bags Size
    bagSize = F.Dpi(53),
    bagWidth = F.Dpi(840),
    bankSize = F.Dpi(48),
    bankWidth = F.Dpi(840),

    -- Bags Options
    useBlizzardCleanup = false,
    clearSearchOnClose = true,
    junkIcon = true,
    moneyCoins = false,
    scrapIcon = true,
    showBindType = true,
    vendorGrays = {
      enable = true,
    },

    -- Sort Spinner
    spinner = {
      enable = true,
      size = 80,
      color = I.Strings.Branding.ColorRGB,
    },
  })

  -- Chat
  F.Table.Crush(pf.chat, {
    -- Chat Options
    hideCopyButton = true,
    hideVoiceButtons = true,
    inactivityTimer = 15,
    keywords = "ElvUI, %MYNAME%, Toxi, ToxiUI",
    timeStampFormat = "%H:%M ",
    emotionIcons = false,
    numScrollMessages = 1,
    scrollDownInterval = 120,

    tabSelector = "NONE",
    tabSelectedTextColor = F.Table.CurrentClassColor(),

    -- Chat Panels
    separateSizes = true,
    panelTabBackdrop = true,
    panelBackdrop = "HIDEBOTH",
    panelHeight = 200,
    panelHeightRight = 200,
    panelWidth = 450,
    panelWidthRight = 450,
    panelColor = F.Table.RGB(0, 0, 0, 0),

    -- Chat Time Color
    useCustomTimeColor = true,
    customTimeColor = I.Strings.Branding.ColorRGB,
  })

  -- Auras Buffs
  F.Table.Crush(pf.auras.buffs, {
    size = F.Dpi(38),
    -- Auras Buffs Options
    fadeThreshold = 3,
    maxWraps = 2,
    wrapAfter = 18,
    seperateOwn = -1,
    growthDirection = "RIGHT_DOWN",

    -- ElvUI_RatioMinimapAuras
    keepSizeRatio = false,
    height = F.Dpi(25),
  })

  -- Auras Debuffs
  F.Table.Crush(pf.auras.debuffs, {
    -- Auras Debuffs Size
    size = F.Dpi(48),

    -- Auras Debuffs Options
    growthDirection = "RIGHT_DOWN",

    -- ElvUI_RatioMinimapAuras
    keepSizeRatio = false,
    height = F.Dpi(32),
  })

  -- Nameplates
  F.Table.Crush(pf.nameplates, {
    highlight = false,
    statusbar = "- ToxiUI",

    units = {
      ["ENEMY_NPC"] = {
        auras = {
          height = F.Dpi(20),
          keepSizeRatio = false,
          size = F.Dpi(30),
          xOffset = 15,
        },
        buffs = {
          anchorPoint = "TOPRIGHT",
          attachTo = "DEBUFFS",
          growthX = "LEFT",
          height = F.Dpi(20),
          keepSizeRatio = false,
          size = F.Dpi(30),
          yOffset = F.Dpi(8),
        },
        castbar = {
          anchorPoint = "BOTTOM",
          iconOffsetX = F.Dpi(2),
          iconOffsetY = F.Dpi(-2),
          iconSize = F.Dpi(24),
          showIcon = false,
          textYOffset = F.Dpi(-2),
          timeYOffset = F.Dpi(-2),
          yOffset = F.Dpi(8),
        },
        debuffs = {
          anchorPoint = "TOPLEFT",
          growthX = "RIGHT",
          height = F.Dpi(20),
          keepSizeRatio = false,
          size = F.Dpi(30),
          xOffset = F.Dpi(-1),
          yOffset = F.Dpi(5),
        },
        health = {
          text = {
            position = "TOPRIGHT",
            yOffset = F.Dpi(-10),
          },
          width = F.Dpi(150),
          height = F.Dpi(10),
        },
        level = {
          enable = true,
          position = "TOPLEFT",
          xOffset = F.Dpi(-13),
          yOffset = F.Dpi(-10),
        },
        name = {
          yOffset = F.Dpi(-10),
        },
        raidTargetIndicator = {
          size = F.Dpi(16),
          xOffset = -15,
        },
      },

      ["FRIENDLY_NPC"] = {
        auras = {
          height = F.Dpi(20),
          keepSizeRatio = false,
          size = F.Dpi(30),
          xOffset = 15,
        },
        buffs = {
          anchorPoint = "TOPRIGHT",
          attachTo = "DEBUFFS",
          growthX = "LEFT",
          height = F.Dpi(20),
          keepSizeRatio = false,
          size = F.Dpi(30),
          yOffset = F.Dpi(8),
        },
        castbar = {
          anchorPoint = "BOTTOM",
          iconOffsetX = F.Dpi(2),
          iconOffsetY = F.Dpi(-2),
          iconSize = F.Dpi(24),
          showIcon = false,
          textYOffset = F.Dpi(-2),
          timeYOffset = F.Dpi(-2),
          yOffset = F.Dpi(8),
        },
        debuffs = {
          anchorPoint = "TOPLEFT",
          growthX = "RIGHT",
          height = F.Dpi(20),
          keepSizeRatio = false,
          size = F.Dpi(30),
          xOffset = F.Dpi(-1),
          yOffset = F.Dpi(5),
        },
        health = {
          text = {
            position = "TOPRIGHT",
            yOffset = F.Dpi(-10),
          },
          width = F.Dpi(150),
          height = F.Dpi(10),
        },
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
        raidTargetIndicator = {
          size = F.Dpi(16),
          xOffset = -15,
        },
      },

      ["ENEMY_PLAYER"] = {
        auras = {
          height = F.Dpi(20),
          keepSizeRatio = false,
          size = F.Dpi(30),
          xOffset = 15,
        },
        buffs = {
          anchorPoint = "TOPRIGHT",
          attachTo = "DEBUFFS",
          growthX = "LEFT",
          height = F.Dpi(20),
          keepSizeRatio = false,
          size = F.Dpi(30),
          yOffset = F.Dpi(8),
        },
        castbar = {
          anchorPoint = "BOTTOM",
          iconOffsetX = F.Dpi(2),
          iconOffsetY = F.Dpi(-2),
          iconSize = F.Dpi(24),
          showIcon = false,
          textYOffset = F.Dpi(-2),
          timeYOffset = F.Dpi(-2),
          yOffset = F.Dpi(8),
        },
        debuffs = {
          anchorPoint = "TOPLEFT",
          growthX = "RIGHT",
          height = F.Dpi(20),
          keepSizeRatio = false,
          size = F.Dpi(30),
          xOffset = F.Dpi(-1),
          yOffset = F.Dpi(5),
        },
        health = {
          text = {
            position = "TOPRIGHT",
            yOffset = F.Dpi(-10),
          },
          width = F.Dpi(150),
          height = F.Dpi(10),
        },
        level = {
          enable = false,
        },
        name = {
          yOffset = F.Dpi(-10),
        },
        raidTargetIndicator = {
          size = F.Dpi(16),
          xOffset = -15,
        },
      },

      ["FRIENDLY_PLAYER"] = {
        nameOnly = true,

        auras = {
          height = F.Dpi(20),
          keepSizeRatio = false,
          size = F.Dpi(30),
          xOffset = 15,
        },
        buffs = {
          anchorPoint = "TOPRIGHT",
          attachTo = "DEBUFFS",
          growthX = "LEFT",
          height = F.Dpi(20),
          keepSizeRatio = false,
          size = F.Dpi(30),
          yOffset = F.Dpi(8),
        },
        castbar = {
          anchorPoint = "BOTTOM",
          iconOffsetX = F.Dpi(2),
          iconOffsetY = F.Dpi(-2),
          iconSize = F.Dpi(24),
          showIcon = false,
          textYOffset = F.Dpi(-2),
          timeYOffset = F.Dpi(-2),
          yOffset = F.Dpi(8),
        },
        debuffs = {
          anchorPoint = "TOPLEFT",
          growthX = "RIGHT",
          height = F.Dpi(20),
          keepSizeRatio = false,
          size = F.Dpi(30),
          xOffset = F.Dpi(-1),
          yOffset = F.Dpi(5),
        },
        health = {
          text = {
            position = "TOPRIGHT",
            yOffset = F.Dpi(-10),
          },
          width = F.Dpi(150),
          height = F.Dpi(10),
        },
        level = {
          enable = false,
        },
        name = {
          yOffset = F.Dpi(-10),
        },
        raidTargetIndicator = {
          size = F.Dpi(16),
          xOffset = -15,
        },
        title = {
          ["enable"] = true,
        },
      },

      ["TARGET"] = {
        arrow = "Arrow0",
        arrowScale = 0.2,
        arrowSpacing = 4,
        glowStyle = "style4",
      },
    },
  })

  -- UnitFrames General
  F.Table.Crush(pf.unitframe, {
    -- UnitFrames Options
    smoothbars = true,
    maxAllowedGroups = false,
    statusbar = "- ToxiUI",
  })

  -- UnitFrames Colors
  F.Table.Crush(pf.unitframe.colors, colors.unitframe.colors)

  -- Nameplates Colors
  F.Table.Crush(pf.nameplates.colors, colors.nameplates.colors)

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

  -- UnitFrame Player
  F.Table.Crush(pf.unitframe.units.player, { -- Player
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
  })

  -- UnitFrame Target
  F.Table.Crush(
    pf.unitframe.units.target,
    { -- Target
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
    },
    F.Table.If(IsHorizontalLayout, {
      fader = { enable = true, range = true },
    })
  )

  -- UnitFrame Pet
  F.Table.Crush(
    pf.unitframe.units.pet,
    { -- Pet
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
    },
    F.Table.If(not TXUI.IsRetail, { -- Pet
      health = {
        colorHappiness = false,
      },
    })
  )

  -- UnitFrame Target-Target
  F.Table.Crush(pf.unitframe.units.targettarget, { -- ToT
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
  })

  -- UnitFrame Focus
  F.Table.Crush(pf.unitframe.units.focus, { -- Focus
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
  })

  -- UnitFrame Party
  F.Table.Crush(
    pf.unitframe.units.party,
    { -- Party
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
        enable = false,
        anchorPoint = "BOTTOMLEFT",
        perrow = 5,
        numrows = 1,
        spacing = 1,
        yOffset = 0,

        -- Stack Counter
        countPosition = "BOTTOM",
        countYOffset = F.Dpi(-7),

        keepSizeRatio = false,
        sizeOverride = F.Dpi(38),
        height = F.Dpi(25),
      },

      -- UnitFrame Party Debuffs
      debuffs = {
        attachTo = "HEALTH",
        anchorPoint = "RIGHT",
        perrow = 5,
        numrows = 1,
        priority = "Blacklist,Dispellable,Boss,RaidDebuffs,CCDebuffs,Whitelist",
        spacing = 1,
        yOffset = 0,

        -- Stack Counter
        countPosition = "BOTTOM",
        countYOffset = F.Dpi(-7),

        keepSizeRatio = false,
        sizeOverride = F.Dpi(38),
        height = F.Dpi(25),
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
    },
    F.Table.If(IsHorizontalLayout, { -- Party

      -- UnitFrame Party Horizontal Layout
      width = F.Dpi(150),
      height = F.Dpi(72),
      verticalSpacing = F.Dpi(6),
      horizontalSpacing = F.Dpi(6),
      growthDirection = "RIGHT_DOWN",
      showPlayer = true,

      -- UnitFrame Party Horizontal Layout Text
      customTexts = {
        ["toxiui:health"] = {
          yOffset = F.Dpi(0),
        },

        ["toxiui:name"] = {
          xOffset = F.Dpi(8),
          yOffset = F.Dpi(0),
        },

        ["toxiui:level"] = {
          xOffset = F.Dpi(24),
          yOffset = F.Dpi(-20),
        },

        ["toxiui:power"] = {
          justifyH = "RIGHT",
          xOffset = F.Dpi(-12),
        },

        ["toxiui:class-icon"] = {
          enable = false,
        },
      },

      -- UnitFrame Party Horizontal Layout Power
      power = {
        width = "filled",
        height = F.Dpi(18),
      },

      -- UnitFrame Party Horizontal Layout Buffs
      buffs = {
        perrow = 4,
        numrows = 2,
        enable = true,
        anchorPoint = "BOTTOM",
        yOffset = F.Dpi(-6),
        spacing = 2,
      },

      -- UnitFrame Party Horizontal Layout Debuffs
      debuffs = {
        anchorPoint = "TOP",
        perrow = 4,
        numrows = 2,
        yOffset = F.Dpi(22),
        spacing = 2,
      },

      -- UnitFrame Party Horizontal Layout Raid Debuffs
      rdebuffs = {
        enable = true,
      },

      -- UnitFrame Party Horizontal Layout Role Icon
      roleIcon = {
        position = "TOPLEFT",
        size = F.Dpi(22),
        xOffset = F.Dpi(-12),
        yOffset = F.Dpi(12),
        damager = false,
      },
    })
  )

  local raidFramesTable = {
    enable = true,
    width = F.Dpi(96),
    height = F.Dpi(42),

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
  }

  -- UnitFrame Raid1
  F.Table.Crush(
    pf.unitframe.units.raid1,
    raidFramesTable,
    {
      visibility = TXUI.IsRetail and "[@raid1,noexists][@raid21,exists] hide;show" or "[@raid1,noexists][@raid11,exists] hide;show",
    },
    F.Table.If(IsHorizontalLayout, {
      -- UnitFrame Raid Horizontal Layout
      growthDirection = "DOWN_RIGHT",
    })
  )

  -- UnitFrame Raid2
  F.Table.Crush(
    pf.unitframe.units.raid2,
    raidFramesTable,
    {
      visibility = TXUI.IsRetail and "[@raid21,noexists][@raid31,exists] hide;show" or "[@raid11,noexists][@raid26,exists] hide;show",
    },
    F.Table.If(IsHorizontalLayout, {
      -- UnitFrame Raid2 Horizontal Layout
      growthDirection = "DOWN_RIGHT",
    })
  )

  -- UnitFrame Raid3
  F.Table.Crush(
    pf.unitframe.units.raid3,
    raidFramesTable,
    {
      visibility = TXUI.IsRetail and "[@raid31,noexists] hide;show" or "[@raid26,noexists] hide;show",
    },
    F.Table.If(IsHorizontalLayout, {
      -- UnitFrame Raid3 Horizontal Layout
      growthDirection = "DOWN_RIGHT",
    })
  )

  -- UnitFrame Tank
  F.Table.Crush(pf.unitframe.units.tank, {
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
  })

  -- UnitFrame Assist
  F.Table.Crush(pf.unitframe.units.assist, {
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
  })

  -- UnitFrame Arena
  F.Table.Crush(pf.unitframe.units.arena, {
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
  })

  -- UnitFrame Boss
  F.Table.Crush(pf.unitframe.units.boss, {
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
  })

  -- ActionBars
  F.Table.Crush(
    pf.actionbar,
    {
      transparent = true,
      globalFadeAlpha = 1,
      flyoutSize = F.Dpi(40),
      countTextYOffset = F.Dpi(0),

      -- ActionBars Cooldowns
      cooldown = {
        checkSeconds = true,
        hhmmThreshold = -1,
        mmssThreshold = 180,
      },

      -- ActionBars Extra Action Button
      extraActionButton = {
        scale = F.DpiRaw(1.25),
      },

      -- ActionBars Zone Button
      zoneActionButton = {
        scale = F.DpiRaw(1.25),
      },
    },
    F.Table.If(TXUI.IsClassic, {
      totemBar = {
        mouseover = true,
        keepSizeRatio = false,
        flyoutDirection = "UP",

        buttonSize = F.Dpi(38), -- Width
        buttonHeight = F.Dpi(25),

        flyoutSize = F.Dpi(38), -- Width
        flyoutHeight = F.Dpi(25),

        spacing = F.Dpi(1),
        flyoutSpacing = F.Dpi(1),
      },
    })
  )

  -- ActionBar Base Template
  local actionbarTemplate = {
    point = "TOPLEFT",
    inheritGlobalFade = true,

    backdrop = false,
    keepSizeRatio = false,
    mouseover = false,

    buttons = 12,
    buttonSize = F.Dpi(38), -- Width
    buttonHeight = F.Dpi(25),
    buttonsPerRow = 6,

    hotkeytext = true,
    hotkeyTextPosition = "TOPRIGHT",
    hotkeyTextYOffset = F.Dpi(0),
  }

  -- ActionBar Helper
  local createActionBar = function(...)
    local tbl = F.Table.Join({}, actionbarTemplate, ...)

    if not tbl.visibility then
      if TXUI.IsRetail then
        tbl.visibility = "[vehicleui][petbattle][overridebar] hide; show"
      elseif TXUI.IsClassic then
        tbl.visibility = "[vehicleui][overridebar] hide; show"
      else
        tbl.visibility = "[overridebar] hide; show"
      end
    end

    return tbl
  end

  -- Main Action Bar Template
  local mainActionBarTemplate = {
    showGrid = true,

    counttext = true,
    countTextPosition = "BOTTOMLEFT",

    macrotext = true,
    macroTextPosition = "BOTTOM",
    macroTextYOffset = F.Dpi(0),

    visibility = TXUI.IsRetail and "[petbattle] hide; show" or "show",
  }

  local createMainActionBar = function(...)
    return F.Table.Join({}, actionbarTemplate, mainActionBarTemplate, ...)
  end

  -- ActionBar Bar1
  pf.actionbar.bar1 = createMainActionBar {
    enabled = true,
    buttonSize = F.Dpi(38),
    buttonHeight = F.Dpi(25),
  }

  -- ActionBar Bar2
  pf.actionbar.bar2 = createMainActionBar {
    enabled = false,
  }

  -- ActionBar Bar3
  pf.actionbar.bar3 = createMainActionBar {
    enabled = true,
    buttonsPerRow = 4,
  }

  -- ActionBar Bar4
  pf.actionbar.bar4 = createMainActionBar {
    enabled = true,
    buttonsPerRow = 4,
  }

  -- ActionBar Bar5
  pf.actionbar.bar5 = createMainActionBar {
    enabled = true,
  }

  -- ActionBar Bar6
  pf.actionbar.bar6 = createMainActionBar {
    enabled = true,
  }

  -- ActionBar Bar7 (Stance Bar)
  pf.actionbar.bar7 = createMainActionBar {
    enabled = false,
  }

  -- ActionBar Bar8 (Stance Bar)
  pf.actionbar.bar8 = createMainActionBar {
    enabled = false,
  }

  -- ActionBar Bar9 (Stance Bar)
  pf.actionbar.bar9 = createMainActionBar {
    enabled = false,
  }

  -- ActionBar Bar10 (Stance Bar)
  pf.actionbar.bar10 = createMainActionBar {
    enabled = false,
  }

  -- ActionBar Bar13
  pf.actionbar.bar13 = createMainActionBar {
    enabled = false,
  }

  -- ActionBar Bar14
  pf.actionbar.bar14 = createMainActionBar {
    enabled = false,
  }

  -- ActionBar Bar15
  pf.actionbar.bar15 = createMainActionBar {
    enabled = false,
  }

  -- ActionBar Pet Bar
  pf.actionbar.barPet = createActionBar {
    mouseover = true,
    backdrop = false,
    backdropSpacing = F.Dpi(1),

    buttonSize = F.Dpi(29),
    buttonHeight = F.Dpi(19),
    buttonSpacing = F.Dpi(1),
    buttonsPerRow = 10,

    counttext = true,
    countTextPosition = "BOTTOMLEFT",

    hotkeyTextPosition = "TOPLEFT",
    hotkeyTextXOffset = F.Dpi(2),
    hotkeyTextYOffset = F.Dpi(-2),
  }

  -- ActionBar Stance Bar
  pf.actionbar.stanceBar = createActionBar {
    alpha = 0.8,
    mouseover = true,
    buttonSize = F.Dpi(31),
    inheritGlobalFade = true,
    hotkeyTextPosition = "TOP",
  }

  if TXUI.IsRetail then
    pf.actionbar.barPet.visibility = "[petbattle] hide; [novehicleui,pet,nooverridebar,nopossessbar] show; hide"
    pf.actionbar.stanceBar.visibility = "[vehicleui][petbattle] hide; show"
  elseif TXUI.IsClassic then
    pf.actionbar.barPet.visibility = "[novehicleui,pet,nooverridebar,nopossessbar] show; hide"
    pf.actionbar.stanceBar.visibility = "[vehicleui] hide; show"
  else
    pf.actionbar.barPet.visibility = "[pet,nooverridebar] show; hide"
    pf.actionbar.stanceBar.visibility = "show"
  end

  -- Cooldowns
  F.Table.Crush(pf.cooldown, {
    useIndicatorColor = true,
    checkSeconds = true,

    -- Cooldowns Colors
    -- Text color (30)m
    minutesColor = F.Table.HexToRGB("#ffffff"),
    mmssColor = F.Table.HexToRGB("#ffffff"),
    secondsColor = F.Table.HexToRGB("#ffffff"),

    -- Indicator color 30(m)
    daysIndicator = F.Table.CurrentClassColor(),
    hhmmColorIndicator = F.Table.CurrentClassColor(),
    hoursIndicator = F.Table.CurrentClassColor(),
    minutesIndicator = F.Table.CurrentClassColor(),
    mmssColorIndicator = F.Table.CurrentClassColor(),
    secondsIndicator = F.Table.CurrentClassColor(),

    -- Cooldowns Thresholds
    threshold = -1,
    mmssThreshold = 180,

    -- Disable cheap WeakAuras attempt
    targetAura = false,
  })

  -- ! IMPORTANT ! --
  pf.dbConverted = E.version
  pf.actionbar.convertPages = false -- just don't !
  pf.convertPages = true -- don't you dare fuck the action bars up again
  pf.general.taintLog = false
  -- ! --
  return pf
end

function PF:ElvUIProfilePrivate()
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

  F.Table.Crush(E.private, {
    -- General
    general = {
      chatBubbles = "nobackdrop",
      raidUtility = true,
      totemTracker = false,
      glossTex = "- ToxiUI", -- Secondary Texture
      normTex = "- ToxiUI",
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
  })
end

function PF:ElvUIProfileGlobal()
  F.Table.Crush(E.global, {
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
  })
end

function PF:UpdateProfileForGradient()
  local pf = self:BuildProfile()

  F.UpdateDBFromPath(pf, "general.altPowerBar", "statusBar")
  F.UpdateDBFromPath(pf, "general.lootRoll", "statusBarTexture")

  F.UpdateDBFromPath(pf, "unitframe", "statusbar")
  F.UpdateDBFromPath(pf, "unitframe.colors.frameGlow.mouseoverGlow", "texture")

  E.private.general.normTex = E.db.unitframe.statusbar
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
