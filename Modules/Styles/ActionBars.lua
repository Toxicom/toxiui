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

  if style == "Classic" then
    if TXUI.IsRetail then E:SetCVar("cooldownViewerEnabled", "0") end

    -- ToxiUI specifics
    F.Table.Crush(pf.TXUI, {
      addons = {
        cooldownManager = {
          enabled = false,
        },

        fadePersist = {
          mode = "ELVUI",
        },
      },
    })

    -- Restore power/class bar widths (may have been modified by CDM dynamic width sync)
    F.Table.Crush(pf.unitframe.units.player, {
      power = { detachedWidth = F.Dpi(292) },
      classbar = { detachedWidth = F.Dpi(292) },
    })

    -- ActionBars
    F.Table.Crush(pf.actionbar, {
      bar1 = {
        buttonSize = F.Dpi(48),
        buttonHeight = F.Dpi(32),
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
        ElvAB_1 = F.Position("TOP", "PlayerPowerBarMover", "BOTTOM", 0, -defaultPadding),
        ElvAB_6 = F.Position("TOPRIGHT", "ElvAB_1", "BOTTOM", -defaultPadding / 2, -defaultPadding), -- left
        ElvAB_5 = F.Position("TOPLEFT", "ElvAB_1", "BOTTOM", defaultPadding / 2, -defaultPadding), -- right
        ElvAB_3 = F.Position("BOTTOMRIGHT", "ElvUIParent", "BOTTOM", -defaultPadding / 2, 54), -- left
        ElvAB_4 = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOM", defaultPadding / 2, 54), -- right
        ShiftAB = F.Position("BOTTOM", "ElvAB_3", "TOPRIGHT", 0, defaultPadding),
      },
      F.Table.If(IsHorizontalLayout, {

        ElvAB_6 = F.Position("BOTTOMRIGHT", "ElvUIParent", "BOTTOM", -defaultPadding / 2, 45), -- left
        ElvAB_5 = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOM", defaultPadding / 2, 45), -- right
        ElvAB_3 = F.Position("RIGHT", "ElvAB_6", "LEFT", -defaultPadding, 0), -- left
        ElvAB_4 = F.Position("LEFT", "ElvAB_5", "RIGHT", defaultPadding, 0), -- right
        ShiftAB = F.Position("BOTTOM", "ElvAB_3", "TOPRIGHT", 0, defaultPadding),

        ElvUF_PartyMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 216),
        ElvUF_Raid1Mover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 132),
        ElvUF_Raid2Mover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 132),
        ElvUF_Raid3Mover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 132),
      })
    )
  end

  if style == "cdm" then
    -- ToxiUI specifics
    F.Table.Crush(pf.TXUI, {
      addons = {
        fadePersist = {
          mode = "MOUSEOVER",
        },

        cooldownManager = {
          enabled = true,
        },
      },
    })

    -- ActionBars
    F.Table.Crush(pf.actionbar, {
      bar1 = {
        buttonSize = F.Dpi(36),
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
        ElvAB_1 = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 54),
        ElvAB_6 = F.Position("BOTTOMRIGHT", "ElvAB_1", "BOTTOMLEFT", -defaultPadding * 4, 0), -- Close Left
        ElvAB_5 = F.Position("BOTTOMLEFT", "ElvAB_1", "BOTTOMRIGHT", defaultPadding * 4, 0), -- Close Right
        ElvAB_3 = F.Position("BOTTOMRIGHT", "ElvAB_6", "BOTTOMLEFT", -defaultPadding * 4, 0), -- Far Left
        ElvAB_4 = F.Position("BOTTOMLEFT", "ElvAB_5", "BOTTOMRIGHT", defaultPadding * 4, 0), -- Far Right
      },
      F.Table.If(IsHorizontalLayout, {
        ElvUF_PartyMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 240),
        ElvUF_Raid1Mover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 144),
        ElvUF_Raid2Mover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 144),
        ElvUF_Raid3Mover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 144),
      })
    )
  end

  TXUI:LogDebug("Finished building ActionBars profile for style: " .. style)
  return pf
end
