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

      -- Movers: ActionBars
      ElvAB_1 = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 50),
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

      ElvUF_Raid1Mover = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOMLEFT", 70, 400),
      ElvUF_Raid2Mover = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOMLEFT", 70, 400),
      ElvUF_Raid3Mover = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOMLEFT", 70, 400),

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
      AltPowerBarMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 390, 620),
      BossButton = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 680, 280),

      PlayerPowerBarMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 526),
      ClassBarMover = F.Position("BOTTOM", "PlayerPowerBarMover", "TOP", 0, defaultPadding / 2),

      ElvUF_PlayerMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", -390, 500),
      ElvUF_TargetMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 390, 500),

      ElvUF_FocusMover = F.Position("BOTTOMLEFT", "ElvUF_Target", "TOPLEFT", 0, 190),

      ElvUF_PartyMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 240),
      ElvUF_Raid1Mover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 140),
      ElvUF_Raid2Mover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 140),
      ElvUF_Raid3Mover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 140),

      ZoneAbility = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOMLEFT", 678, 280),
    }),
    F.Table.If(TXUI.IsClassic, {
      TotemBarMover = F.Position("BOTTOM", "ElvAB_1", "TOP", 0, defaultPadding),
    }),
    F.Table.If(not TXUI.IsRetail, {
      MirrorTimer1Mover = F.Position("TOP", "ElvUIParent", "TOP", 0, -72),
      MirrorTimer2Mover = F.Position("TOP", "MirrorTimer1Mover", "BOTTOM", 0, -defaultPadding),
      MirrorTimer3Mover = F.Position("TOP", "MirrorTimer2Mover", "BOTTOM", 0, -defaultPadding),

      -- Movers: ToxiUI
      ToxiUIWAAnchorMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, WAAnchorY[1]),
    }),
    F.Table.If(not TXUI.IsRetail and IsHorizontalLayout, {
      ToxiUIWAAnchorMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, WAAnchorY[2]),
    })
  )

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
