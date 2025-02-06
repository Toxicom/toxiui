local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local ST = TXUI:GetModule("Styles")

function ST:BuildActionBarsProfile()
  local style = E.db.TXUI.styles.actionBars

  if not style or style == "" then
    TXUI:LogDebug("Style ActionBars > Invalid style provided")
    return
  end

  local pf = E.db
  local IsHorizontalLayout = E.db.TXUI.installer.layout == I.Enum.Layouts.HORIZONTAL
  local defaultPadding = 4

  local customTextTemplate = {
    -- Options
    enable = true,
    attachTextTo = "Health",
    justifyH = "LEFT",

    -- Offset
    xOffset = F.Dpi(-10),
    yOffset = F.Dpi(27),
  }

  local createCustomText = function(db, ...)
    return F.Table.Join(db or {}, customTextTemplate, ...)
  end

  if style == "Classic" then
    -- ToxiUI specifics
    F.Table.Crush(pf.TXUI, {
      addons = {
        fadePersist = {
          mode = "ELVUI",
        },
      },
    })

    -- UnitFrame Player
    F.Table.Crush(pf.unitframe.units.player, {
      power = {
        enable = true,
        autoHide = false,
        detachFromFrame = true,
        text_format = "",
        detachedWidth = F.Dpi(248),
        height = 10,
      },

      classbar = {
        enable = true,
        detachFromFrame = true,
        detachedWidth = F.Dpi(248),
        height = 10,
      },

      customTexts = {
        ["toxiui:power"] = createCustomText({}, {
          attachTextTo = "Power",
          text_format = F.ChooseForTheme(TXUI.IsVanilla and "[tx:smartpower]" or "[tx:smartpower:percent:nosign]", "[tx:power:percent:nosign]"),
          xOffset = F.Dpi(0),
          yOffset = F.Dpi(5),
          justifyH = "CENTER",
          font = F.FontOverride(I.Fonts.TitleBlack),
          size = F.FontSizeScaled(24),
          fontOutline = F.FontStyleOverride(I.Fonts.TitleBlack, "SHADOWOUTLINE"),
        }),
      },
    })

    -- ActionBars
    F.Table.Crush(pf.actionbar, {
      bar1 = {
        buttonSize = F.Dpi(40),
        buttonHeight = F.Dpi(30),
      },

      bar3 = {
        buttonsPerRow = 6,
        mouseover = true,
      },

      bar4 = {
        buttonsPerRow = 6,
        mouseover = true,
      },
    })

    -- Movers
    F.Table.Crush(
      pf.movers,
      {
        PlayerPowerBarMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 372),
        ClassBarMover = F.Position("BOTTOM", "PlayerPowerBarMover", "TOP", 0, defaultPadding / 2),

        ElvAB_1 = F.Position("TOP", "PlayerPowerBarMover", "BOTTOM", 0, -defaultPadding),
        ElvAB_6 = F.Position("TOPRIGHT", "ElvAB_1", "BOTTOM", -defaultPadding / 2, -defaultPadding), -- left
        ElvAB_5 = F.Position("TOPLEFT", "ElvAB_1", "BOTTOM", defaultPadding / 2, -defaultPadding), -- right
        ElvAB_3 = F.Position("BOTTOMRIGHT", "ElvUIParent", "BOTTOM", -defaultPadding / 2, 45), -- left
        ElvAB_4 = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOM", defaultPadding / 2, 45), -- right
        ShiftAB = F.Position("BOTTOM", "ElvAB_3", "TOPRIGHT", 0, defaultPadding),
      },
      F.Table.If(IsHorizontalLayout, {
        PlayerPowerBarMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 402),
        ClassBarMover = F.Position("BOTTOM", "PlayerPowerBarMover", "TOP", 0, defaultPadding / 2),

        ElvAB_6 = F.Position("BOTTOMRIGHT", "ElvUIParent", "BOTTOM", -defaultPadding / 2, 45), -- left
        ElvAB_5 = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOM", defaultPadding / 2, 45), -- right
        ElvAB_3 = F.Position("RIGHT", "ElvAB_6", "LEFT", -defaultPadding, 0), -- left
        ElvAB_4 = F.Position("LEFT", "ElvAB_5", "RIGHT", defaultPadding, 0), -- right
        ShiftAB = F.Position("BOTTOM", "ElvAB_3", "TOPRIGHT", 0, defaultPadding),

        ElvUF_PartyMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 180),
        ElvUF_Raid1Mover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 110),
        ElvUF_Raid2Mover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 110),
        ElvUF_Raid3Mover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 110),
      })
    )
  end

  if style == "WeakAuras" then
    -- ToxiUI specifics
    F.Table.Crush(pf.TXUI, {
      addons = {
        fadePersist = {
          mode = "MOUSEOVER",
        },
      },
    })

    -- UnitFrame Player
    F.Table.Crush(pf.unitframe.units.player, {
      power = {
        enable = false,
        detachedWidth = F.Dpi(120),
        autoHide = true,
      },

      classbar = {
        enable = false,
      },

      customTexts = {
        ["toxiui:power"] = createCustomText({}, {
          attachTextTo = "Power",
          text_format = F.ChooseForTheme("[tx:smartpower:percent:nosign]", "[tx:power:percent:nosign]"),
          xOffset = F.Dpi(85),
          yOffset = F.Dpi(0),
          font = F.FontOverride(I.Fonts.Primary),
          size = F.FontSizeScaled(20),
          fontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
        }),
      },
    })

    -- ActionBars
    F.Table.Crush(pf.actionbar, {
      bar1 = {
        buttonSize = F.Dpi(32),
        buttonHeight = F.Dpi(24),
      },

      bar3 = {
        buttonsPerRow = 4,
        mouseover = false,
      },

      bar4 = {
        buttonsPerRow = 4,
        mouseover = false,
      },
    })

    -- Movers
    F.Table.Crush(
      pf.movers,
      {
        PlayerPowerBarMover = F.Position("RIGHT", "ElvUF_PlayerMover", "BOTTOMRIGHT", -10, 0),

        ElvAB_1 = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 45),
        ElvAB_6 = F.Position("BOTTOMRIGHT", "ElvAB_1", "BOTTOMLEFT", -defaultPadding * 4, 0), -- Close Left
        ElvAB_5 = F.Position("BOTTOMLEFT", "ElvAB_1", "BOTTOMRIGHT", defaultPadding * 4, 0), -- Close Right
        ElvAB_3 = F.Position("BOTTOMRIGHT", "ElvAB_6", "BOTTOMLEFT", -defaultPadding * 4, 0), -- Far Left
        ElvAB_4 = F.Position("BOTTOMLEFT", "ElvAB_5", "BOTTOMRIGHT", defaultPadding * 4, 0), -- Far Right
      },
      F.Table.If(IsHorizontalLayout, {
        ElvUF_PartyMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 200),
        ElvUF_Raid1Mover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 120),
        ElvUF_Raid2Mover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 120),
        ElvUF_Raid3Mover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 120),
      })
    )
  end

  TXUI:LogDebug("Finished building ActionBars profile for style: " .. style)
  return pf
end
