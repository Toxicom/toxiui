local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local PF = TXUI:GetModule("Profiles")

local defaultPadding = 4
local WAAnchorY = { 395, 479 }

function PF:ApplyMovers(pf, horizontal)
  local powerBarIsEnabled = E.db.unitframe.units.player.power.enable and true or false
  local powerMoverPosition = horizontal and F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 526) or F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 446)
  F.Table.Crush(
    pf.movers,
    {
      -- F.Position(1, 2, 3)
      -- 1 => Anchor position of SELECTED FRAME
      -- 2 => Anchor Parent
      -- 3 => Anchor position of PARENT FRAME

      -- Pop-ups
      MicrobarMover = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOMLEFT", 590, 40),
      LootFrameMover = F.Position("CENTER", "ElvUIParent", "CENTER", 360, 0),
      AlertFrameMover = F.Position("LEFT", "LootFrameMover", "RIGHT", 240, -60),

      -- ActionBars
      ElvAB_1 = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 50),
      ElvAB_6 = F.Position("BOTTOMRIGHT", "ElvAB_1", "BOTTOMLEFT", -defaultPadding * 4, 0), -- Close Left
      ElvAB_5 = F.Position("BOTTOMLEFT", "ElvAB_1", "BOTTOMRIGHT", defaultPadding * 4, 0), -- Close Right
      ElvAB_3 = F.Position("BOTTOMRIGHT", "ElvAB_6", "BOTTOMLEFT", -defaultPadding * 4, 0), -- Far Left
      ElvAB_4 = F.Position("BOTTOMLEFT", "ElvAB_5", "BOTTOMRIGHT", defaultPadding * 4, 0), -- Far Right

      ElvAB_2 = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -44, -480), -- Unused
      ElvAB_7 = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -88, -480), -- Unused
      ElvAB_8 = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -131, -480), -- Unused
      ElvAB_9 = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -173, -480), -- Unused
      ElvAB_10 = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -216, -480), -- Unused

      PetAB = F.Position("TOP", "ElvUF_Player", "BOTTOM", 0, -defaultPadding),
      VehicleLeaveButton = F.Position("BOTTOMLEFT", "ElvAB_4", "BOTTOMRIGHT", defaultPadding, 0),
      DurabilityFrameMover = F.Position("BOTTOMLEFT", "ElvAB_4", "BOTTOMRIGHT", 41, 0),
      ShiftAB = F.Position("BOTTOM", "ElvAB_1", "TOP", 0, defaultPadding),

      -- UnitFrames
      ElvUF_PlayerMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", -390, 420),
      ElvUF_PlayerCastbarMover = F.Position("TOPLEFT", "ElvUF_Player", "BOTTOMLEFT", 0, -defaultPadding),
      PlayerPowerBarMover = powerMoverPosition,
      ClassBarMover = powerBarIsEnabled and F.Position("BOTTOM", "PlayerPowerBarMover", "TOP", 0, defaultPadding / 2) or powerMoverPosition,

      ElvUF_TargetMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 390, 420),
      ElvUF_TargetCastbarMover = F.Position("TOPRIGHT", "ElvUF_Target", "BOTTOMRIGHT", 0, -defaultPadding),
      TargetPowerBarMover = F.Position("LEFT", "ElvUF_Target", "BOTTOMLEFT", 12, 0),

      ElvUF_TargetTargetMover = F.Position("TOPLEFT", "ElvUF_Target", "TOPRIGHT", defaultPadding, 0),

      ElvUF_PetMover = F.Position("TOPRIGHT", "ElvUF_Player", "TOPLEFT", -defaultPadding, 0),
      ElvUF_PetCastbarMover = F.Position("TOPLEFT", "ElvUF_Pet", "BOTTOMLEFT", 0, -1),

      ElvUF_FocusMover = F.Position("TOP", "ElvUF_Target", "BOTTOM", 0, -70),
      ElvUF_FocusCastbarMover = F.Position("TOPLEFT", "ElvUF_FocusMover", "BOTTOMLEFT", 0, -defaultPadding),
      FocusPowerBarMover = F.Position("LEFT", "ElvUF_FocusMover", "BOTTOMLEFT", 12, 0),

      ElvUF_PartyMover = F.Position("LEFT", "ElvUIParent", "LEFT", 360, 0, true),

      ElvUF_Raid1Mover = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOMLEFT", 20, 400),
      ElvUF_Raid2Mover = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOMLEFT", 20, 400),
      ElvUF_Raid3Mover = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOMLEFT", 20, 400),

      ArenaHeaderMover = F.Position("RIGHT", "ElvUIParent", "RIGHT", -360, 0, true, true),
      BossHeaderMover = F.Position("TOPRIGHT", "ArenaHeaderMover", "TOPRIGHT", 0, 0),

      ElvUF_TankMover = F.Position("TOPLEFT", "LeftChatMover", "TOPRIGHT", defaultPadding, 0),
      ElvUF_AssistMover = F.Position("TOPLEFT", "ElvUF_TankMover", "BOTTOMLEFT", 0, -defaultPadding),

      -- Chat
      LeftChatMover = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOMLEFT", defaultPadding, 70),
      RightChatMover = F.Position("BOTTOMRIGHT", "ElvUIParent", "BOTTOMRIGHT", -defaultPadding, 70),

      -- Bags
      ElvUIBagMover = F.Position("BOTTOMLEFT", "RightChatMover", "TOPLEFT", 0, defaultPadding),
      ElvUIBankMover = F.Position("BOTTOMRIGHT", "LeftChatMover", "TOPRIGHT", 0, defaultPadding),

      -- Buffs
      BuffsMover = F.Position("TOPLEFT", "ElvUIParent", "TOPLEFT", defaultPadding, -defaultPadding),
      DebuffsMover = F.Position("TOPLEFT", "BuffsMover", "BOTTOMLEFT", 0, -defaultPadding),

      -- Misc
      BelowMinimapContainerMover = F.Position("TOPLEFT", "ElvUIParent", "TOPLEFT", 230, -260),
      BNETMover = F.Position("TOPRIGHT", "MinimapMover", "TOPLEFT", -defaultPadding, 0),
      GMMover = F.Position("TOPRIGHT", "BNETMover", "BOTTOMRIGHT", 0, -defaultPadding),
      MinimapMover = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -defaultPadding, -defaultPadding),
      TooltipMover = F.Position("BOTTOMRIGHT", "RightChatMover", "TOPRIGHT", -20, 140),
      TopCenterContainerMover = F.Position("TOP", "ElvUIParent", "TOP", 0, -40),
      VOICECHAT = F.Position("TOPLEFT", "DebuffsMover", "BOTTOMLEFT", 0, -defaultPadding),
      QueueStatusMover = F.Position("BOTTOMRIGHT", "MinimapMover", "BOTTOMRIGHT", -defaultPadding * 2, defaultPadding * 2),
    },
    F.Table.If(TXUI.IsRetail, {
      -- Bars Retail Only
      AltPowerBarMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 220),
      AzeriteBarMover = F.Position("TOP", "ElvUIParent", "TOP", 420, -390),
      HonorBarMover = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -670, -510),
      WTExtraItemsBar1Mover = F.Position("BOTTOMRIGHT", "RightChatMover", "BOTTOMLEFT", -defaultPadding, 0),

      -- ActionBars Retail Only
      BossButton = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", -360, 240),
      ZoneAbility = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOMLEFT", 760, 240),

      -- Chat
      WTRaidMarkersBarAnchor = F.Position("BOTTOMLEFT", "LeftChatMover", "TOPLEFT", 0, F.IsAddOnEnabled("Chattynator") and defaultPadding + 72 or defaultPadding),

      -- Misc Retail Only
      LevelUpBossBannerMover = F.Position("TOP", "ElvUIParent", "TOP", 0, -200),
      LossControlMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 610),
      SocialMenuMover = F.Position("TOPLEFT", "ElvUIParent", "TOPLEFT", 5, -220),
      UIErrorsFrameMover = F.Position("TOP", "UIParent", "TOP", 0, -150),
      VehicleSeatMover = F.Position("BOTTOMRIGHT", "ElvUIParent", "BOTTOMRIGHT", -370, 400),
      PowerBarContainerMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 190),
      AddonCompartmentMover = F.Position("TOPRIGHT", "MinimapMover", "TOPRIGHT", -defaultPadding, -defaultPadding * 4),
    }),
    F.Table.If(horizontal, {
      -- Horizontal Layout
      AltPowerBarMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 390, 620),
      BossButton = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 680, 280),

      PlayerPowerBarMover = powerMoverPosition,
      ClassBarMover = powerBarIsEnabled and F.Position("BOTTOM", "PlayerPowerBarMover", "TOP", 0, defaultPadding / 2) or powerMoverPosition,

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
      MirrorTimer1Mover = F.Position("TOP", "ElvUIParent", "TOP", 0, -70),
      MirrorTimer2Mover = F.Position("TOP", "MirrorTimer1Mover", "BOTTOM", 0, -defaultPadding),
      MirrorTimer3Mover = F.Position("TOP", "MirrorTimer2Mover", "BOTTOM", 0, -defaultPadding),

      -- ToxiUI
      ToxiUIWAAnchorMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, WAAnchorY[1]),
    }),
    F.Table.If(not TXUI.IsRetail and horizontal, {
      ToxiUIWAAnchorMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, WAAnchorY[2]),
    }),
    F.Table.If(TXUI.IsMists, {
      ObjectiveFrameMover = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -80, -320),
    })
  )
end
