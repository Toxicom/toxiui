local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local PF = TXUI:GetModule("Profiles")

local next = next

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
    tooltip = {},
    unitframe = {
      colors = {},
      units = {},
    },
  }

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
  -- TODO: Update for Dragonflight
  local WAAnchorY

  if F.HiDpi() then
    WAAnchorY = { -128, -98 }
  else
    WAAnchorY = { -114, -114 }
  end

  local defaultPadding = 5

  -- Movers
  F.Table.Crush(
    pf.movers,
    {
      -- F.Position(1, 2, 3)
      -- 1 => Anchor position of SELECTED FRAME
      -- 2 => Anchor Parent
      -- 3 => Anchor position of PARENT FRAME

      -- Movers: Pop-ups
      MicrobarMover = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOMLEFT", 495, 30),
      AlertFrameMover = F.Position("TOP", "ElvUIParent", "TOP", 0, -50),
      LootFrameMover = F.Position("CENTER", "ElvUIParent", "CENTER", 300, 0),

      -- Movers: Bars
      ExperienceBarMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 43),
      ReputationBarMover = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -3, -264),
      ThreatBarMover = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -554, -363),

      MirrorTimer1Mover = F.Position("TOP", "AlertFrameMover", "BOTTOM", 0, -defaultPadding),
      MirrorTimer2Mover = F.Position("TOP", "MirrorTimer1", "BOTTOM", 0, -defaultPadding),
      MirrorTimer3Mover = F.Position("TOP", "MirrorTimer2", "BOTTOM", 0, -defaultPadding),

      -- Movers: Action Bars
      ElvAB_1 = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 45),
      ElvAB_6 = F.Position("BOTTOMRIGHT", "ElvAB_1", "BOTTOMLEFT", -defaultPadding, 0), -- Close Left
      ElvAB_5 = F.Position("BOTTOMLEFT", "ElvAB_1", "BOTTOMRIGHT", defaultPadding, 0), -- Close Right
      ElvAB_3 = F.Position("BOTTOMRIGHT", "ElvAB_6", "BOTTOMLEFT", -defaultPadding, 0), -- Far Left
      ElvAB_4 = F.Position("BOTTOMLEFT", "ElvAB_5", "BOTTOMRIGHT", defaultPadding, 0), -- Far Right

      ElvAB_2 = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -37, -401), -- Unused
      ElvAB_7 = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -73, -401), -- Unused
      ElvAB_8 = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -109, -401), -- Unused
      ElvAB_9 = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -144, -401), -- Unused
      ElvAB_10 = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -180, -401), -- Unused

      VehicleLeaveButton = F.Position("BOTTOMLEFT", "ElvAB_4", "BOTTOMRIGHT", defaultPadding, 0),
      DurabilityFrameMover = F.Position("BOTTOMLEFT", "ElvAB_4", "BOTTOMRIGHT", 34, 0),
      ShiftAB = F.Position("BOTTOM", "ElvAB_1", "TOP", 0, defaultPadding),

      -- Movers: UnitFrames
      ElvUF_PlayerMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", -325, 350),
      ElvUF_TargetMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 325, 350),

      PetAB = F.Position("TOP", "ElvUF_Player", "BOTTOM", 0, -defaultPadding),
      ElvUF_PetMover = F.Position("TOPRIGHT", "ElvUF_Player", "TOPLEFT", -defaultPadding, 0),
      ElvUF_PetCastbarMover = F.Position("TOPLEFT", "ElvUF_Pet", "BOTTOMLEFT", 0, -1),

      ElvUF_TargetTargetMover = F.Position("TOPLEFT", "ElvUF_Target", "TOPRIGHT", defaultPadding, 0),

      ElvUF_PlayerCastbarMover = F.Position("TOPLEFT", "ElvUF_Player", "BOTTOMLEFT", 0, -defaultPadding),
      ElvUF_TargetCastbarMover = F.Position("TOPRIGHT", "ElvUF_Target", "BOTTOMRIGHT", 0, -defaultPadding),

      ElvUF_FocusMover = F.Position("BOTTOM", "ElvAB_1", "TOP", 0, 60),
      FocusPowerBarMover = F.Position("TOP", "ElvUF_FocusMover", "BOTTOM", 0, defaultPadding),
      ElvUF_FocusCastbarMover = F.Position("TOPLEFT", "ElvUF_Focus", "BOTTOMLEFT", 0, -defaultPadding),

      ElvUF_PartyMover = F.Position("LEFT", "ElvUIParent", "LEFT", 300, 0),

      ElvUF_Raid1Mover = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOMLEFT", 60, 335),
      ElvUF_Raid2Mover = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOMLEFT", 60, 335),
      ElvUF_Raid3Mover = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOMLEFT", 60, 335),

      -- Arena Frames
      ArenaHeaderMover = F.Position("RIGHT", "ElvUIParent", "RIGHT", -300, 0),

      -- Boss Frames
      BossHeaderMover = F.Position("RIGHT", "ElvUIParent", "RIGHT", -300, 0),

      ElvUF_AssistMover = F.Position("BOTTOMLEFT", "LeftChatMover", "BOTTOMRIGHT", defaultPadding, 0),
      ElvUF_TankMover = F.Position("BOTTOMLEFT", "ElvUF_AssistMover", "TOPLEFT", 0, defaultPadding),

      -- Movers: Chat
      LeftChatMover = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOMLEFT", defaultPadding, 60),
      RightChatMover = F.Position("BOTTOMRIGHT", "ElvUIParent", "BOTTOMRIGHT", -defaultPadding, 60),

      -- Movers: Bags
      ElvUIBagMover = F.Position("BOTTOMLEFT", "RightChatMover", "TOPLEFT", 0, defaultPadding),
      ElvUIBankMover = F.Position("BOTTOMRIGHT", "LeftChatMover", "TOPRIGHT", 0, defaultPadding),

      -- Movers: Buffs
      BuffsMover = F.Position("TOPLEFT", "ElvUIParent", "TOPLEFT", defaultPadding, -defaultPadding),
      DebuffsMover = F.Position("TOPLEFT", "BuffsMover", "BOTTOMLEFT", 0, -defaultPadding),

      -- Movers: Misc
      BelowMinimapContainerMover = F.Position("TOPLEFT", "ElvUIParent", "TOPLEFT", 195, -220),
      BNETMover = F.Position("TOPRIGHT", "MinimapMover", "TOPLEFT", -defaultPadding, 0),
      GMMover = F.Position("TOPRIGHT", "BNETMover", "BOTTOMRIGHT", 0, -defaultPadding),
      MinimapMover = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -defaultPadding, -defaultPadding),
      ObjectiveFrameMover = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -70, -270),
      TooltipMover = F.Position("BOTTOMRIGHT", "RightChatMover", "TOPRIGHT", -15, 100),
      TopCenterContainerMover = F.Position("TOP", "ElvUIParent", "TOP", 0, -20),
      VOICECHAT = F.Position("TOPLEFT", "DebuffsMover", "BOTTOMLEFT", 0, -defaultPadding),

      -- Movers: ToxiUI
      ToxiUIWAAnchorMover = F.Position("TOP", "ElvUIParent", "CENTER", 0, WAAnchorY[1]),
    },
    F.Table.If(TXUI.IsRetail, {
      -- Movers: Bars Retail Only
      AltPowerBarMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 180),
      AzeriteBarMover = F.Position("TOP", "ElvUIParent", "TOP", 351, -324),
      ClassBarMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", -280, 317),
      HonorBarMover = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -573, -422),
      WTRaidMarkerBarAnchor = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -325, -4),

      -- Movers: Action Bars Retail Only
      BossButton = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", -300, 200),
      PetBattleABMover = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOMLEFT", 76, 313),
      ZoneAbility = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOMLEFT", 630, 200),

      -- Movers: Chat
      WTRaidMarkersBarAnchor = F.Position("BOTTOMLEFT", "LeftChatMover", "TOPLEFT", 0, defaultPadding),

      -- Movers: Misc Retail Only
      LevelUpBossBannerMover = F.Position("TOP", "ElvUIParent", "TOP", 0, -170),
      LossControlMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 505),
      PetBattleStatusMover = F.Position("TOP", "PetBattleFrame", "TOP", 0, 0),
      RaidUtility_Mover = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -550, -4),
      SocialMenuMover = F.Position("TOPLEFT", "ElvUIParent", "TOPLEFT", 4, -187),
      UIErrorsFrameMover = F.Position("TOP", "UIParent", "TOP", 0, -122),
      VehicleSeatMover = F.Position("BOTTOMRIGHT", "ElvUIParent", "BOTTOMRIGHT", -305, 330),
      PowerBarContainerMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 158),
    }),
    F.Table.If(E.db.TXUI.installer.layout == I.Enum.Layouts.HEALER, {

      -- Healer Layout
      AltPowerBarMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 326, 518),
      BossButton = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 565, 235),
      ClassBarMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", -280, 347),

      ElvUF_PlayerMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", -325, 380),
      ElvUF_TargetMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 325, 380),

      ElvUF_FocusMover = F.Position("BOTTOMLEFT", "ElvUF_PlayerMover", "TOPLEFT", 0, 160),
      FocusPowerBarMover = F.Position("TOP", "ElvUF_FocusMover", "BOTTOM", 0, defaultPadding),
      ElvUF_FocusCastbarMover = F.Position("TOPLEFT", "ElvUF_FocusMover", "BOTTOMLEFT", 0, -defaultPadding),

      ElvUF_PartyMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 220),
      ElvUF_Raid1Mover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 120),
      ElvUF_Raid2Mover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 120),
      ElvUF_Raid3Mover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 120),

      ZoneAbility = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOMLEFT", 565, 235),

      ToxiUIWAAnchorMover = F.Position("TOP", "ElvUIParent", "CENTER", 0, WAAnchorY[2]),
    })
  )

  -- General
  F.Table.Crush(pf.general, {
    -- General AFK Mode
    afk = true,

    -- General Options
    autoRepair = "PLAYER",
    bottomPanel = false,
    resurrectSound = true,
    stickyFrames = false,
    talkingHeadFrameBackdrop = true,
    talkingHeadFrameScale = F.DpiRaw(1),

    -- General Quest Tracker
    objectiveFrameAutoHideInKeystone = true,
    objectiveFrameHeight = F.Dpi(500),

    -- General Colors
    valuecolor = F.Table.HexToRGB("#ffffff"),
    backdropcolor = F.Table.HexToRGB("#1a1a1a"),
    backdropfadecolor = F.Table.HexToRGB("#282828cc"),
    bordercolor = F.Table.HexToRGB("#000000"),

    -- General MiniMap
    minimap = {
      -- General MiniMap Size
      size = F.Dpi(230),

      -- General MiniMap Icons
      icons = {
        -- General MiniMap Icons LFG Eye
        lfgEye = {
          xOffset = F.Dpi(0),
        },

        -- General MiniMap Icons Mail
        mail = {
          xOffset = F.Dpi(0),
          yOffset = F.Dpi(0),
        },
      },
    },

    -- Loot Roll
    lootRoll = {
      statusBarTexture = F.ChooseForGradient("- ToxiUI", "- Tx Mid"),
    },

    -- AltPowerBar
    altPowerBar = {
      statusBar = F.ChooseForGradient("- ToxiUI", "- Tx Mid"),
    },
  })

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
    bagSize = F.Dpi(44),
    bagWidth = F.Dpi(700),
    bankSize = F.Dpi(40),
    bankWidth = F.Dpi(700),

    -- Bags Options
    clearSearchOnClose = true,
    junkIcon = true,
    moneyCoins = false,
    scrapIcon = true,
    showBindType = true,
    vendorGrays = {
      enable = true,
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
    customTimeColor = F.Table.HexToRGB("#00c1e2"),
  })

  -- Auras Buffs
  F.Table.Crush(pf.auras.buffs, {
    -- Auras Buffs Size - Rounded to the next 2
    size = F.Dpi(34, 2),

    -- Auras Buffs Options
    fadeThreshold = 3,
    maxWraps = 1,
    wrapAfter = 18,
    seperateOwn = -1,
    growthDirection = "RIGHT_DOWN",
  })

  -- Auras Debuffs
  F.Table.Crush(pf.auras.debuffs, {
    -- Auras Debuffs Size
    size = F.Dpi(42, 2),

    -- Auras Debuffs Options
    growthDirection = "RIGHT_DOWN",
  })

  -- UnitFrames General
  F.Table.Crush(pf.unitframe, {
    -- UnitFrames Options
    smoothbars = true,
    maxAllowedGroups = false,
    statusbar = F.ChooseForGradient("- ToxiUI", "- Tx Mid"),
  })

  -- UnitFrames Colors
  F.Table.Crush(pf.unitframe.colors, {
    -- UnitFrames Colors CastBar
    castColor = F.Table.HexToRGB("#ffb300"),
    castNoInterrupt = F.Table.HexToRGB("#808080"),
    castInterruptedColor = F.Table.HexToRGB("#ff1a1a"),

    -- UnitFrames Colors
    borderColor = F.Table.HexToRGB("#000000"),
    disconnected = F.Table.HexToRGB("#ff9387"),
    health = F.ChooseForTheme(F.Table.HexToRGB("#000000"), F.Table.HexToRGB("#1d1d1d")),
    health_backdrop = F.ChooseForTheme(F.Table.HexToRGB("#000000"), F.Table.HexToRGB("#505050")),
    health_backdrop_dead = F.ChooseForTheme(F.Table.HexToRGB("#ff0015"), F.Table.HexToRGB("#9c0c00")),

    -- UnitFrames Colors Options
    classbackdrop = true,
    colorhealthbyvalue = false,
    useDeadBackdrop = true,
    transparentPower = false,
    healthclass = F.ChooseForTheme(true, false),
    customhealthbackdrop = F.ChooseForTheme(false, true),

    -- UnitFrames Colors heal prediction
    healPrediction = {
      absorbs = F.Table.HexToRGB("#ff00f180"),
      overabsorbs = F.Table.HexToRGB("#ff00c180"),
    },

    -- UnitFrame Colors MouseOver Glow
    frameGlow = {
      mouseoverGlow = {
        texture = F.ChooseForGradient("- ToxiUI", "- Tx Mid"),
      },
    },
  })

  local customTextTemplate = {
    -- Options
    enable = true,
    attachTextTo = "Health",
    justifyH = "LEFT",

    -- Ofset
    xOffset = F.Dpi(-10),
    yOffset = F.Dpi(27),
  }

  local createCustomText = function(db, ...)
    return F.Table.Join(db or {}, customTextTemplate, ...)
  end

  -- UnitFrame Player
  F.Table.Crush(pf.unitframe.units.player, {
    -- UnitFrame Player Size
    width = F.Dpi(250),
    height = F.ChooseForTheme(F.Dpi(30), F.Dpi(40)),
    threatStyle = "NONE",

    -- UnitFrame Player Options
    disableMouseoverGlow = true,

    -- UnitFrame Player Custom Texts
    customTexts = {
      -- UnitFrame Player Custom Texts Name
      ["!Name"] = createCustomText({}, {
        attachTextTo = "Health",
        text_format = "[tx:classcolor][name:medium]",
        xOffset = F.Dpi(5),
        yOffset = F.ChooseForTheme(F.Dpi(27), F.Dpi(0)),
      }),

      -- UnitFrame Player Custom Texts Health
      ["!Health"] = createCustomText({}, {
        justifyH = "RIGHT",
        text_format = "[tx:classcolor][health:current:shortvalue] || [perhp]",
        yOffset = F.ChooseForTheme(F.Dpi(27), F.Dpi(0)),
      }),
    },

    -- UnitFrame Player Debuffs
    debuffs = {
      anchorPoint = "TOPRIGHT",
      growthX = "LEFT",
      attachTo = "FRAME",
      durationPosition = "TOP",
      maxDuration = 0,
      perrow = 8,
      priority = "Blacklist,Boss,CCDebuffs,RaidDebuffs,CastByUnit,CastByNPC,Personal",
      sizeOverride = F.Dpi(30),
      spacing = F.Dpi(0),
      xOffset = F.Dpi(-3),
      yOffset = F.Dpi(25),
    },

    -- UnitFrame Player Fader
    fader = {
      enable = true,
      minAlpha = 0,
      power = true,
      vehicle = false,
    },

    -- UnitFrame Player RestIcon
    RestIcon = {
      enable = true,
      defaultColor = false,

      anchorPoint = "TOPLEFT",
      size = F.Dpi(36),
      xOffset = F.Dpi(25),
      yOffset = F.ChooseForTheme(F.Dpi(40), F.Dpi(18)),

      texture = "CUSTOM",
      customTexture = I.General.MediaPath .. "Textures\\Resting.tga",
    },

    -- UnitFrame Player CombatIcon
    CombatIcon = {
      enable = true,
      defaultColor = false,

      anchorPoint = "LEFT",
      size = F.Dpi(30),
      yOffset = -20, -- Not sure if this needs DPI

      color = F.Table.HexToRGB("#ffffff"),

      texture = "CUSTOM",
      customTexture = I.General.MediaPath .. "Textures\\Combat_Material.blp",
    },

    -- UnitFrame Player raidicon (Target Marker Icon)
    raidicon = {
      size = F.Dpi(24),
      yOffset = F.Dpi(0),
      attachTo = "CENTER",
    },

    -- UnitFrame Player Castbar
    castbar = {
      width = F.Dpi(250),
      height = F.Dpi(25),

      -- UnitFrame Player Castbar Options
      insideInfoPanel = false,
      icon = false,

      -- UnitFrame Player Castbar Text
      textColor = F.Table.HexToRGB("#ffffff"),
      xOffsetText = F.Dpi(5),
      xOffsetTime = F.Dpi(-10),
    },

    -- UnitFrame Player heal prediction
    healPrediction = {
      absorbStyle = "REVERSED",
    },

    -- Disable UnitFrame Player aurabar
    aurabar = { enable = false },
    -- Disable UnitFrame Player classbar
    classbar = { enable = false },
    -- Disable UnitFrame Player power
    power = { enable = false },
    -- Disable UnitFrame Player health text
    health = { text_format = "" },
    -- Disable UnitFrame Target name text
    name = { text_format = "" },
    -- Disable UnitFrame Player Buffs
    buffs = { enable = false },
  })

  -- UnitFrame Target
  F.Table.Crush(pf.unitframe.units.target, {
    -- UnitFrame Target Size
    width = F.Dpi(250),
    height = F.ChooseForTheme(F.Dpi(30), F.Dpi(40)),
    threatStyle = "NONE",

    -- UnitFrame Target Options
    disableMouseoverGlow = true,
    orientation = "LEFT",

    -- UnitFrame Target Custom Texts
    customTexts = {
      -- UnitFrame Target Custom Texts Health
      ["!Health"] = createCustomText({}, {
        text_format = "[tx:classcolor][perhp] || [health:current:shortvalue]",
        xOffset = F.Dpi(10),
        yOffset = F.ChooseForTheme(F.Dpi(27), F.Dpi(0)),
      }),

      -- UnitFrame Target Custom Texts Name
      ["!Name"] = createCustomText({}, {
        justifyH = "RIGHT",
        text_format = "[tx:classcolor][name:abbrev:medium]",
        xOffset = F.Dpi(-5),
        yOffset = F.ChooseForTheme(F.Dpi(27), F.Dpi(0)),
      }),
    },

    -- UnitFrame Target Debuffs
    buffs = {
      anchorPoint = "TOPLEFT",
      growthX = "RIGHT",
      perrow = 4,
      priority = "Blacklist,Personal,Boss,nonPersonal,CastByUnit",
      sizeOverride = F.Dpi(30),
      spacing = F.Dpi(0),
      xOffset = F.Dpi(3),
      yOffset = F.Dpi(25),
    },

    -- UnitFrame Target Debuffs
    debuffs = {
      anchorPoint = "TOPRIGHT",
      attachTo = "FRAME",
      durationPosition = "TOP",
      maxDuration = 0,
      perrow = 4,
      priority = "Blacklist,Boss,Personal,RaidDebuffs,CastByUnit,CCDebuffs",
      sizeOverride = F.Dpi(30),
      spacing = F.Dpi(0),
      xOffset = F.Dpi(-3),
      yOffset = F.Dpi(25),
    },

    -- UnitFrame Target raidicon (Target Marker Icon)
    raidicon = {
      size = F.Dpi(24),
      yOffset = F.Dpi(0),
      attachTo = "CENTER",
    },

    -- UnitFrame Target Castbar
    castbar = {
      width = F.Dpi(250),
      height = F.Dpi(25),

      -- UnitFrame Target Castbar Options
      insideInfoPanel = false,
      icon = false,

      -- UnitFrame Target Castbar Text
      textColor = F.Table.HexToRGB("#ffffff"),
      xOffsetText = F.Dpi(5),
      xOffsetTime = F.Dpi(-10),
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
    -- Disable UnitFrame Target power
    power = { enable = false },
    -- Disable UnitFrame Target health text
    health = { text_format = "" },
    -- Disable UnitFrame Target name text
    name = { text_format = "" },
  })

  -- UnitFrame Pet
  F.Table.Crush(pf.unitframe.units.pet, {
    width = F.Dpi(100),
    height = F.ChooseForTheme(F.Dpi(15), F.Dpi(20)),
    disableTargetGlow = false,
    threatStyle = "NONE",

    -- UnitFrame Pet Custom Texts
    customTexts = {
      -- UnitFrame Pet Custom Texts Name
      ["!Name"] = createCustomText({}, {
        text_format = "[tx:classcolor][name:short]",
        xOffset = F.Dpi(0),
        yOffset = F.ChooseForTheme(F.Dpi(15), F.Dpi(0)),
        justifyH = "CENTER",
      }),
    },

    -- UnitFrame Pet Castbar
    castbar = {
      height = F.Dpi(12),
      iconSize = F.Dpi(32),
      width = F.Dpi(100),
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
    },

    -- Disable UnitFrame Pet health text
    health = { text_format = "" },
    -- Disable UnitFrame Pet name text
    name = { text_format = "" },
    -- Disable UnitFrame Pet name text
    power = { enable = false },
    -- Disable UnitFrame Pet Debuffs
    debuffs = { enable = false },
  })

  -- UnitFrame Target-Target
  F.Table.Crush(pf.unitframe.units.targettarget, {
    width = F.Dpi(100),
    height = F.ChooseForTheme(F.Dpi(15), F.Dpi(20)),
    threatStyle = "NONE",
    disableMouseoverGlow = true,

    -- UnitFrame Target-Target Custom Texts
    customTexts = {
      -- UnitFrame Target-Target Custom Texts Name
      ["!Name"] = createCustomText({}, {
        text_format = "[tx:classcolor][name:short]",
        xOffset = F.Dpi(0),
        yOffset = F.ChooseForTheme(F.Dpi(15), F.Dpi(0)),
        justifyH = "CENTER",
      }),
    },

    -- UnitFrame Target-Target RaidIcon (Target Maker)
    raidicon = {
      size = F.Dpi(16),
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
  F.Table.Crush(pf.unitframe.units.focus, {
    width = F.Dpi(250),
    height = F.Dpi(30),
    threatStyle = "NONE",

    -- UnitFrame Focus Options
    orientation = "LEFT",
    disableMouseoverGlow = true,
    disableTargetGlow = true,

    -- UnitFrame Focus Custom Texts
    customTexts = {
      -- UnitFrame Focus Custom Texts Name
      ["!Name"] = createCustomText({}, {
        text_format = "[tx:classcolor][name:medium]",
        xOffset = F.Dpi(5),
        yOffset = F.ChooseForTheme(F.Dpi(25), F.Dpi(0)),
      }),

      -- UnitFrame Focus Custom Texts Health
      ["!Health"] = createCustomText({}, {
        justifyH = "RIGHT",
        text_format = "[tx:classcolor][health:current:shortvalue] || [perhp]",
        xOffset = F.Dpi(-10),
        yOffset = F.ChooseForTheme(F.Dpi(25), F.Dpi(0)),
      }),
    },

    -- UnitFrame Focus Buffs
    buffs = {
      enable = true,
      anchorPoint = "TOPLEFT",
      maxDuration = 0,
      perrow = 5,
      priority = "Blacklist,Personal,PlayerBuffs,Whitelist,blockNoDuration,nonPersonal",
      sizeOverride = F.Dpi(24),
      spacing = F.Dpi(0),
      xOffset = F.Dpi(3),
      yOffset = F.Dpi(25),
    },

    -- UnitFrame Focus Debuffs
    debuffs = {
      durationPosition = "TOP",
      maxDuration = 0,
      priority = "Blacklist,Personal,nonPersonal",
      sizeOverride = F.Dpi(24),
      spacing = F.Dpi(0),
      xOffset = F.Dpi(-3),
      yOffset = F.Dpi(25),
    },

    -- UnitFrame Focus raidicon (Target Marker Icon)
    raidicon = {
      size = F.Dpi(24),
      yOffset = F.Dpi(0),
      attachTo = "CENTER",
    },

    -- UnitFrame Focus Castbar
    castbar = {
      height = F.Dpi(20),
      width = F.Dpi(250),
      insideInfoPanel = false,
      icon = false,

      textColor = F.Table.HexToRGB("#ffffff"),
      xOffsetText = F.Dpi(5),
      xOffsetTime = F.Dpi(-10),

      -- UnitFrame Focus Castbar Classcolor
      customColor = {
        useClassColor = true,
      },
    },

    -- UnitFrame Focus Power
    power = {
      width = "spaced",
      text_format = "",
      detachedWidth = F.Dpi(120),
      detachFromFrame = true,
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
    {
      width = F.Dpi(200),
      height = F.Dpi(30),

      -- UnitFrame Party Options
      groupBy = "ROLE",
      growthDirection = "DOWN_LEFT",
      horizontalSpacing = F.Dpi(5),
      raidWideSorting = true,
      showPlayer = false,
      startFromCenter = true,
      verticalSpacing = F.Dpi(30),

      -- UnitFrame Party Custom Texts
      customTexts = {
        -- UnitFrame Party Custom Texts Name
        ["!Name"] = createCustomText({}, {
          text_format = "[tx:classcolor][name:medium]",
          xOffset = F.Dpi(10),
          yOffset = F.Dpi(25),
        }),

        -- UnitFrame Party Custom Texts Health
        ["!Health"] = createCustomText({}, {
          justifyH = "RIGHT",
          text_format = "[tx:classcolor][perhp]",
          xOffset = F.Dpi(-10),
          yOffset = F.Dpi(25),
        }),
      },

      -- UnitFrame Party BuffIndicator
      buffIndicator = {
        size = F.Dpi(10),
      },

      -- UnitFrame Party Buffs
      buffs = {
        enable = false,
        anchorPoint = "BOTTOMLEFT",
        perrow = 5,
        sizeOverride = F.Dpi(29),
        spacing = F.Dpi(1),
      },

      -- UnitFrame Party Debuffs
      debuffs = {
        attachTo = "HEALTH",
        anchorPoint = "RIGHT",
        perrow = 5,
        priority = "Blacklist,Dispellable,Boss,RaidDebuffs,CCDebuffs,Whitelist",
        sizeOverride = F.Dpi(29),
        spacing = F.Dpi(1),
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
        size = F.Dpi(26),
        xOffset = F.Dpi(-50),
        yOffset = F.Dpi(-10),
      },

      -- UnitFrame Party Role Icons
      raidRoleIcons = {
        position = "TOPRIGHT",
      },

      -- UnitFrame Party Raid Debuffs
      rdebuffs = {
        enable = false,
        size = F.Dpi(30),
        yOffset = F.Dpi(20),
      },

      -- UnitFrame Party Ready Check Icon
      readycheckIcon = {
        position = "CENTER",
        size = F.Dpi(40),
        yOffset = F.Dpi(0),
      },

      -- UnitFrame Party Role Icon
      roleIcon = {
        damager = true,
        position = "LEFT",
        size = F.Dpi(30),
        xOffset = F.Dpi(-35),
        yOffset = F.Dpi(0),
      },

      -- UnitFrame Party Power
      power = {
        width = "spaced",
        height = F.Dpi(10),
        text_format = "",
      },

      -- Disable UnitFrame Party health text
      health = { text_format = "" },
      -- Disable UnitFrame Party name text
      name = { text_format = "" },
      -- Disable UnitFrame Party CombatIcon
      CombatIcon = { enable = false },
    },
    F.Table.If(E.db.TXUI.installer.layout == I.Enum.Layouts.HEALER, {

      -- UnitFrame Party Healer Layout
      width = F.Dpi(150),
      height = F.Dpi(60),
      verticalSpacing = F.Dpi(5),
      horizontalSpacing = F.Dpi(5),
      growthDirection = "RIGHT_DOWN",
      showPlayer = true,

      -- UnitFrame Party Healer Layout Text
      customTexts = {
        ["!Health"] = {
          yOffset = F.Dpi(0),
        },

        ["!Name"] = {
          xOffset = F.Dpi(7),
          yOffset = F.Dpi(0),
        },
      },

      -- UnitFrame Party Heal Layout Power
      power = {
        width = "filled",
        height = F.Dpi(15),
      },

      -- UnitFrame Party Heal Layout Buffs
      buffs = {
        enable = true,
        anchorPoint = "BOTTOM",
      },

      -- UnitFrame Party Heal Layout Debuffs
      debuffs = {
        anchorPoint = "TOPLEFT",
      },

      -- UnitFrame Party Heal Layout Raid Debuffs
      rdebuffs = {
        enable = true,
      },

      -- UnitFrame Party Heal Layout Role Icon
      roleIcon = {
        position = "TOPLEFT",
        size = F.Dpi(22),
        xOffset = F.Dpi(-10),
        yOffset = F.Dpi(10),
        damager = false,
      },
    })
  )

  -- UnitFrame Raid1
  F.Table.Crush(
    pf.unitframe.units.raid1,
    {
      enable = true,
      width = F.Dpi(80),
      height = F.Dpi(35),

      -- UnitFrame Raid1 Options
      groupBy = "ROLE",
      groupSpacing = F.Dpi(0),
      groupsPerRowCol = 1,
      growthDirection = "RIGHT_UP",
      horizontalSpacing = F.Dpi(1),
      numGroups = 5,
      raidWideSorting = false,
      startFromCenter = false,
      verticalSpacing = F.Dpi(1),
      visibility = TXUI.Retail and "[@raid6,noexists][@raid21,exists] hide;show" or "[@raid6,noexists][@raid11,exists] hide;show",

      -- UnitFrame Raid1 Custom Texts
      customTexts = {
        -- UnitFrame Raid1 Custom Texts Name
        ["!Name"] = createCustomText({}, {
          attachTextTo = "Frame",
          text_format = "[tx:classcolor][name:short]",
          justifyH = "CENTER",
          xOffset = F.Dpi(0),
          yOffset = F.Dpi(0),
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
        size = F.Dpi(20),
        yOffset = F.Dpi(5),

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
        size = F.Dpi(24),
      },

      -- UnitFrame Raid1 Role Icon
      roleIcon = {
        enable = true,
        damager = false,
        position = "TOPLEFT",
        size = F.Dpi(20),
        xOffset = -5,
        yOffset = 5,
      },

      -- Disable UnitFrame Raid1 health text
      health = { text_format = "" },
      -- Disable UnitFrame Raid1 name text
      name = { text_format = "" },
      -- Disable UnitFrame Raid1 power
      power = { enable = false },
    },
    F.Table.If(E.db.TXUI.installer.layout == I.Enum.Layouts.HEALER, {
      -- UnitFrame Raid Healer Layout
      growthDirection = "RIGHT_DOWN",
    })
  )

  -- UnitFrame Raid2
  F.Table.Crush(
    pf.unitframe.units.raid2,
    {
      enable = true,
      width = F.Dpi(80),
      height = F.Dpi(35),

      -- UnitFrame Raid2 Options
      groupBy = "ROLE",
      groupSpacing = F.Dpi(0),
      groupsPerRowCol = 1,
      growthDirection = "RIGHT_UP",
      horizontalSpacing = F.Dpi(1),
      numGroups = 5,
      raidWideSorting = false,
      startFromCenter = false,
      verticalSpacing = F.Dpi(1),
      visibility = TXUI.Retail and "[@raid21,noexists][@raid31,exists] hide;show" or "[@raid11,noexists][@raid26,exists] hide;show",

      -- UnitFrame Raid2 Custom Texts
      customTexts = {
        -- UnitFrame Raid2 Custom Texts Name
        ["!Name"] = createCustomText({}, {
          attachTextTo = "Frame",
          text_format = "[tx:classcolor][name:short]",
          justifyH = "CENTER",
          xOffset = F.Dpi(0),
          yOffset = F.Dpi(0),
        }),
      },

      -- UnitFrame Raid2 Heal Prediction
      healPrediction = {
        enable = true,
        absorbStyle = "REVERSED",
      },

      -- UnitFrame Raid2 Raid Debuffs
      rdebuffs = {
        enable = true,
        size = F.Dpi(20),
        yOffset = F.Dpi(5),

        duration = {
          color = F.Table.HexToRGB("#fff0ea"),
        },

        stack = {
          color = F.Table.HexToRGB("#ffe900"),
          position = "BOTTOMRIGHT",
          yOffset = F.Dpi(0),
        },
      },

      -- UnitFrame Raid2 Ready Check Icon
      readycheckIcon = {
        size = F.Dpi(24),
      },

      -- UnitFrame Raid2 Role Icon
      roleIcon = {
        enable = true,
        damager = false,
        position = "TOPLEFT",
        size = F.Dpi(20),
        xOffset = -5,
        yOffset = 5,
      },

      -- Disable UnitFrame Raid2 health text
      health = { text_format = "" },
      -- Disable UnitFrame Raid2 name text
      name = { text_format = "" },
      -- Disable UnitFrame Raid2 power
      power = { enable = false },
    },
    F.Table.If(E.db.TXUI.installer.layout == I.Enum.Layouts.HEALER, {
      -- UnitFrame Raid2 Healer Layout
      growthDirection = "RIGHT_DOWN",
    })
  )

  -- UnitFrame Raid3
  F.Table.Crush(
    pf.unitframe.units.raid3,
    {
      enable = true,
      width = F.Dpi(80),
      height = F.Dpi(22),

      -- UnitFrame Raid3 Options
      groupBy = "ROLE",
      groupSpacing = F.Dpi(0),
      groupsPerRowCol = 1,
      growthDirection = "RIGHT_UP",
      horizontalSpacing = F.Dpi(1),
      raidWideSorting = false,
      startFromCenter = false,
      verticalSpacing = F.Dpi(1),
      visibility = TXUI.Retail and "[@raid31,noexists] hide;show" or "[@raid26,noexists] hide;show",

      -- UnitFrame Raid3 Custom Texts
      customTexts = {
        -- UnitFrame Raid3 Custom Texts Name
        ["!Name"] = createCustomText({}, {
          attachTextTo = "Frame",
          text_format = "[tx:classcolor][name:short]",
          justifyH = "CENTER",
          xOffset = F.Dpi(0),
          yOffset = F.Dpi(0),
        }),
      },

      -- UnitFrame Raid3 Heal Prediction
      healPrediction = {
        absorbStyle = "REVERSED",
        enable = true,
      },

      -- UnitFrame Raid3 Raid Debuffs
      rdebuffs = {
        enable = true,
        size = F.Dpi(18),
        xOffset = F.Dpi(0),
        yOffset = F.Dpi(4),

        duration = {
          color = F.Table.HexToRGB("#fff0ea"),
        },

        stack = {
          color = F.Table.HexToRGB("#ffe900"),
          position = "BOTTOMRIGHT",
          yOffset = F.Dpi(0),
        },
      },

      -- UnitFrame Raid3 Ready Check Icon
      readycheckIcon = {
        size = F.Dpi(24),
      },

      -- UnitFrame Raid3 Role Icon
      roleIcon = {
        enable = true,
        damager = false,
        position = "TOPLEFT",
        size = F.Dpi(20),
        xOffset = -5,
        yOffset = 5,
      },

      -- Disable UnitFrame Raid3 health text
      health = { text_format = "" },
      -- Disable UnitFrame Raid3 name text
      name = { text_format = "" },
      -- Disable UnitFrame Raid3 power
      power = { enable = false },
    },
    F.Table.If(E.db.TXUI.installer.layout == I.Enum.Layouts.HEALER, {
      -- UnitFrame Raid3 Healer Layout
      growthDirection = "RIGHT_DOWN",
    })
  )

  -- UnitFrame Tank
  F.Table.Crush(pf.unitframe.units.tank, {
    name = {
      text_format = "[name:medium]",
    },

    targetsGroup = {
      name = {
        text_format = "[name:medium]",
      },
    },

    -- Disable UnitFrame Tank health text
    health = { text_format = "" },
  })

  -- UnitFrame Assist
  F.Table.Crush(pf.unitframe.units.assist, {
    name = {
      text_format = "[name:medium]",
    },

    targetsGroup = {
      name = {
        text_format = "[name:medium]",
      },
    },
  })

  -- UnitFrame Arena
  F.Table.Crush(pf.unitframe.units.arena, {
    width = F.Dpi(250),
    height = F.Dpi(40),
    spacing = F.Dpi(40),

    -- UnitFrame Arena Custom Texts
    customTexts = {
      -- UnitFrame Arena Custom Texts Health
      ["!Health"] = createCustomText({}, {
        text_format = "[tx:classcolor][perhp] || [health:current:shortvalue]",
        xOffset = F.Dpi(5),
        yOffset = F.ChooseForTheme(F.Dpi(27), F.Dpi(0)),
      }),

      -- UnitFrame Arena Custom Texts Name
      ["!Name"] = createCustomText({}, {
        justifyH = "RIGHT",
        text_format = "[tx:classcolor][name:medium]",
        xOffset = F.Dpi(-5),
        yOffset = F.ChooseForTheme(F.Dpi(27), F.Dpi(0)),
      }),

      -- UnitFrame Arena Custom Texts Power
      ["!Power"] = createCustomText({}, {
        attachTextTo = "Power",
        text_format = "[perpp]",
        xOffset = F.Dpi(10),
        yOffset = F.Dpi(0),
      }),
    },

    -- UnitFrame Arena Buffs
    buffs = {
      priority = "Blacklist,CastByUnit,Dispellable,Whitelist,RaidBuffsElvUI",
      sizeOverride = F.Dpi(24),
    },

    -- UnitFrame Arena Debuffs
    debuffs = {
      desaturate = true,
      priority = "Blacklist,Boss,Personal,RaidDebuffs,CastByUnit,Whitelist",
      sizeOverride = F.Dpi(25),
    },

    -- UnitFrame Arena Trinket
    pvpTrinket = {
      size = F.Dpi(30),
    },

    -- UnitFrame Arena Castbar
    castbar = {
      width = F.Dpi(250),
    },

    -- UnitFrame Arena Power
    power = {
      height = F.Dpi(10),
      text_format = "",
    },

    -- Disable UnitFrame Arena health text
    health = { text_format = "" },
    -- Disable UnitFrame Arena name text
    name = { text_format = "" },
  })

  -- UnitFrame Boss
  F.Table.Crush(pf.unitframe.units.boss, {
    width = F.Dpi(200),
    height = F.Dpi(30),
    spacing = F.Dpi(45),

    -- UnitFrame Boss Custom Texts
    customTexts = {
      -- UnitFrame Boss Custom Texts Health
      ["!Health"] = createCustomText({}, {
        text_format = "[perhp]",
        xOffset = F.Dpi(5),
        yOffset = F.Dpi(25),
      }),

      -- UnitFrame Boss Custom Texts Name
      ["!Name"] = createCustomText({}, {
        justifyH = "RIGHT",
        text_format = "[name:abbrev:medium]",
        xOffset = F.Dpi(-5),
        yOffset = F.Dpi(25),
      }),

      -- UnitFrame Boss Custom Texts Power
      ["!Power"] = createCustomText({}, {
        attachTextTo = "Power",
        text_format = "[perpp]",
        xOffset = F.Dpi(70),
        yOffset = F.Dpi(0),
      }),
    },

    -- UnitFrame Boss Buffs
    buffs = {
      maxDuration = 300,
      sizeOverride = F.Dpi(25),
      yOffset = F.Dpi(16),
    },

    -- UnitFrame Boss Debuffs
    debuffs = {
      maxDuration = 300,
      sizeOverride = F.Dpi(25),
      yOffset = F.Dpi(-16),
    },

    -- UnitFrame Boss Castbar
    castbar = {
      width = F.Dpi(200),
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

  -- Action Bars
  F.Table.Crush(pf.actionbar, {
    transparent = true,
    globalFadeAlpha = 1,
    flyoutSize = F.Dpi(33),
    countTextYOffset = F.Dpi(0),

    -- Action Bars Cooldowns
    cooldown = {
      checkSeconds = true,
      hhmmThreshold = 11,
      mmssThreshold = 300,
    },

    -- Action Bars Extra Action Button
    extraActionButton = {
      scale = F.DpiRaw(1.25),
    },

    -- Action Bars Zone Button
    zoneActionButton = {
      scale = F.DpiRaw(1.25),
    },
  })

  -- ActionBar Base Template
  local actionbarTemplate = {
    point = "TOPLEFT",
    inheritGlobalFade = true,

    backdrop = false,

    buttons = 12,
    buttonSize = F.Dpi(30),
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
      elseif TXUI.IsWrath then
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

    buttonSize = F.Dpi(20),
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
    buttonSize = F.Dpi(26),
    inheritGlobalFade = true,
    hotkeyTextPosition = "TOP",
  }

  if TXUI.IsWrath then
    pf.actionbar.barPet.visibility = "[novehicleui,pet,nooverridebar,nopossessbar] show; hide"
    pf.actionbar.stanceBar.visibility = "[vehicleui] hide; show"
  else
    pf.actionbar.barPet.visibility = "[petbattle] hide; [novehicleui,pet,nooverridebar,nopossessbar] show; hide"
    pf.actionbar.stanceBar.visibility = "[vehicleui][petbattle] hide; show"
  end

  -- Cooldowns
  F.Table.Crush(pf.cooldown, {
    checkSeconds = true,

    -- Cooldowns Colors
    minutesColor = F.Table.HexToRGB("#2afff3"),
    mmssColor = F.Table.HexToRGB("#00ff7e"),
    secondsColor = F.Table.HexToRGB("#ffffff"),

    -- Cooldowns Thresholds
    threshold = -1,
    mmssThreshold = 300,

    -- Disable cheap WeakAuras attempt
    targetAura = false,
  })

  -- ! IMPORTANT ! --
  pf.dbConverted = E.version
  pf.actionbar.convertPages = false -- just don't !
  pf.convertPages = true -- don't you dare fuck the action bars up again
  pf.general.taintLog = false
  -- ! --

  -- ! Personal change
  if F.DevBuildProfile then F.Table.Crush(pf, F.DevBuildProfile(pf)) end

  return pf
end

function PF:ElvUIProfilePrivate()
  F.Table.Crush(E.private, {
    -- General
    general = {
      chatBubbles = "nobackdrop",
      raidUtility = true,
      totemTracker = false,
      glossTex = "- ToxiUI", -- Secondary Texture
      normTex = F.ChooseForGradient("- ToxiUI", "- Tx Mid"),

      minimap = {
        hideClassHallReport = false,
      },
    },

    -- NamePlates ElvUI
    nameplates = {
      enable = false,
    },

    -- Chat
    chat = {
      enable = true,
    },

    -- Skins
    skins = {
      parchmentRemoverEnable = true,
    },
  })
end

function PF:UpdateProfileForTheme()
  local pf = self:BuildProfile()

  -- Custom Text
  F.UpdateDBFromPath(pf, "unitframe.units.arena.customTexts.!Health", "yOffset")
  F.UpdateDBFromPath(pf, "unitframe.units.arena.customTexts.!Name", "yOffset")
  F.UpdateDBFromPath(pf, "unitframe.units.focus.customTexts.!Health", "yOffset")
  F.UpdateDBFromPath(pf, "unitframe.units.focus.customTexts.!Name", "yOffset")
  F.UpdateDBFromPath(pf, "unitframe.units.pet.customTexts.!Name", "yOffset")
  F.UpdateDBFromPath(pf, "unitframe.units.player.customTexts.!Health", "yOffset")
  F.UpdateDBFromPath(pf, "unitframe.units.player.customTexts.!Name", "yOffset")
  F.UpdateDBFromPath(pf, "unitframe.units.target.customTexts.!Health", "yOffset")
  F.UpdateDBFromPath(pf, "unitframe.units.target.customTexts.!Name", "yOffset")
  F.UpdateDBFromPath(pf, "unitframe.units.targettarget.customTexts.!Name", "yOffset")

  -- UnitFrame Heights
  F.UpdateDBFromPath(pf, "unitframe.units.pet", "height")
  F.UpdateDBFromPath(pf, "unitframe.units.player", "height")
  F.UpdateDBFromPath(pf, "unitframe.units.target", "height")
  F.UpdateDBFromPath(pf, "unitframe.units.targettarget", "height")

  -- Player Rest Icon
  F.UpdateDBFromPath(pf, "unitframe.units.player.RestIcon", "yOffset")

  -- UnitFrame Color Options
  F.UpdateDBFromPath(pf, "unitframe.colors", "customhealthbackdrop")
  F.UpdateDBFromPath(pf, "unitframe.colors", "healthclass")

  -- UnitFrame Colors
  F.UpdateDBFromPathRGB(pf, "unitframe.colors.health")
  F.UpdateDBFromPathRGB(pf, "unitframe.colors.health_backdrop")
  F.UpdateDBFromPathRGB(pf, "unitframe.colors.health_backdrop_dead")
end

function PF:UpdateProfileForGradient()
  local pf = self:BuildProfile()

  F.UpdateDBFromPath(pf, "general.altPowerBar", "statusBar")
  F.UpdateDBFromPath(pf, "general.lootRoll", "statusBarTexture")

  F.UpdateDBFromPath(pf, "unitframe", "statusbar")
  F.UpdateDBFromPath(pf, "unitframe.colors.frameGlow.mouseoverGlow", "texture")

  E.private.general.normTex = E.db.unitframe.statusbar
end
