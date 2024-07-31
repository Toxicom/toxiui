local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local ST = TXUI:GetModule("Styles")
local PF = TXUI:GetModule("Profiles")

function ST:BuildUnitFramesProfile()
  local style = E.db.TXUI.styles.unitFrames

  if not style or style == "" then
    TXUI:LogDebug("Style UnitFrames > Invalid style provided")
    return
  end

  local pf = E.db
  local IsHorizontalLayout = pf.TXUI.installer.layout == I.Enum.Layouts.HORIZONTAL

  if style == "New" then
    -- UnitFrames
    F.Table.Crush(
      pf.unitframe.units,
      {
        -- Player
        player = {
          height = F.Dpi(30),

          customTexts = {
            ["!Name"] = {
              yOffset = F.ChooseForTheme(F.Dpi(27), F.Dpi(15)),
            },
            ["!Health"] = {
              text_format = "[tx:health:percent:nosign]",
              yOffset = F.ChooseForTheme(F.Dpi(15), F.Dpi(15)),

              font = F.FontOverride(I.Fonts.Primary),
              size = F.FontSizeScaled(36),
              fontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
            },
            ["!ClassIcon"] = {
              xOffset = F.ChooseForTheme(F.Dpi(5), F.Dpi(-10)),
              yOffset = F.ChooseForTheme(F.Dpi(0), F.Dpi(-16)),
            },
          },

          raidRoleIcons = {
            yOffset = F.ChooseForTheme(F.Dpi(21), F.Dpi(15)),
          },
        },

        target = {
          height = F.Dpi(30),

          customTexts = {
            ["!Name"] = {
              yOffset = F.ChooseForTheme(F.Dpi(27), F.Dpi(15)),
            },
            ["!Health"] = {
              text_format = "[tx:health:percent:nosign]",
              yOffset = F.ChooseForTheme(F.Dpi(15), F.Dpi(15)),

              font = F.FontOverride(I.Fonts.Primary),
              size = F.FontSizeScaled(36),
              fontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
            },
            ["!ClassIcon"] = {
              xOffset = F.ChooseForTheme(F.Dpi(-5), F.Dpi(10)),
              yOffset = F.ChooseForTheme(F.Dpi(0), F.Dpi(-16)),
            },
            ["!Classification"] = {
              yOffset = F.ChooseForTheme(F.Dpi(25), F.Dpi(15)),
            },
          },

          raidRoleIcons = {
            yOffset = F.ChooseForTheme(F.Dpi(21), F.Dpi(15)),
          },
        },

        pet = {
          height = F.Dpi(15),

          customTexts = {
            ["!Name"] = {
              yOffset = F.ChooseForTheme(F.Dpi(15), F.Dpi(10)),
            },
          },
        },

        targettarget = {
          height = F.Dpi(15),

          customTexts = {
            ["!Name"] = {
              yOffset = F.ChooseForTheme(F.Dpi(15), F.Dpi(10)),
            },
          },
        },

        focus = {
          customTexts = {
            ["!Name"] = {
              yOffset = F.ChooseForTheme(F.Dpi(27), F.Dpi(20)),
            },
            ["!Health"] = {
              yOffset = F.ChooseForTheme(F.Dpi(15), F.Dpi(20)),

              font = F.FontOverride(I.Fonts.Primary),
              size = F.FontSizeScaled(36),
              fontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
            },
            ["!ClassIcon"] = {
              xOffset = F.ChooseForTheme(F.Dpi(-5), F.Dpi(10)),
              yOffset = F.ChooseForTheme(F.Dpi(0), F.Dpi(-16)),
            },
          },
        },

        party = {
          customTexts = {
            ["!Name"] = {
              yOffset = F.ChooseForTheme(F.Dpi(27), F.Dpi(15)),
            },
            ["!Health"] = {
              yOffset = F.ChooseForTheme(F.Dpi(15), F.Dpi(15)),

              font = F.FontOverride(I.Fonts.Primary),
              size = F.FontSizeScaled(36),
              fontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
            },
            ["!ClassIcon"] = {
              xOffset = F.ChooseForTheme(F.Dpi(5), F.Dpi(-10)),
              yOffset = F.ChooseForTheme(F.Dpi(0), F.Dpi(-16)),
            },
          },

          raidRoleIcons = {
            yOffset = F.ChooseForTheme(F.Dpi(21), F.Dpi(15)),
          },
        },

        arena = {
          customTexts = {
            ["!Health"] = {
              text_format = "[tx:health:percent:nosign]",
              yOffset = F.ChooseForTheme(F.Dpi(15), F.Dpi(15)),

              font = F.FontOverride(I.Fonts.Primary),
              size = F.FontSizeScaled(36),
              fontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
            },

            ["!Name"] = {
              yOffset = F.ChooseForTheme(F.Dpi(27), F.Dpi(15)),
            },
          },
        },

        boss = {
          customTexts = {
            ["!Health"] = {
              yOffset = F.ChooseForTheme(F.Dpi(15), F.Dpi(15)),

              font = F.FontOverride(I.Fonts.Primary),
              size = F.FontSizeScaled(36),
              fontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
            },

            ["!Name"] = {
              yOffset = F.ChooseForTheme(F.Dpi(27), F.Dpi(15)),
            },
          },
        },
      },
      F.Table.If(IsHorizontalLayout, {
        party = {
          customTexts = {
            ["!Health"] = {
              yOffset = F.Dpi(0),
            },

            ["!Name"] = {
              yOffset = F.Dpi(0),
            },
          },
        },
      })
    )
  end

  if style == "Old" then
    -- UnitFrames
    F.Table.Crush(
      pf.unitframe.units,
      {
        -- Player
        player = {
          height = F.ChooseForTheme(F.Dpi(30), F.Dpi(40)),

          customTexts = {
            ["!Name"] = {
              yOffset = F.ChooseForTheme(F.Dpi(27), F.Dpi(0)),
            },
            ["!Health"] = {
              text_format = "[tx:health:current:shortvalue] || [tx:health:percent:nosign]",
              yOffset = F.ChooseForTheme(F.Dpi(27), F.Dpi(0)),

              font = F.FontOverride("- Steelfish"),
              size = F.FontSizeScaled(22),
              fontOutline = F.FontStyleOverride("- Steelfish", "SHADOW"),
            },
            ["!ClassIcon"] = {
              xOffset = F.ChooseForTheme(F.Dpi(5), F.Dpi(-32)),
              yOffset = F.ChooseForTheme(F.Dpi(0), F.Dpi(-16)),
            },
          },

          raidRoleIcons = {
            yOffset = F.ChooseForTheme(F.Dpi(21), F.Dpi(10)),
          },
        },

        target = {
          height = F.ChooseForTheme(F.Dpi(30), F.Dpi(40)),

          customTexts = {
            ["!Name"] = {
              yOffset = F.ChooseForTheme(F.Dpi(27), F.Dpi(0)),
            },
            ["!Health"] = {
              text_format = "[tx:health:percent:nosign] || [tx:health:current:shortvalue]",
              yOffset = F.ChooseForTheme(F.Dpi(27), F.Dpi(0)),

              font = F.FontOverride("- Steelfish"),
              size = F.FontSizeScaled(22),
              fontOutline = F.FontStyleOverride("- Steelfish", "SHADOW"),
            },
            ["!ClassIcon"] = {
              xOffset = F.ChooseForTheme(F.Dpi(-5), F.Dpi(32)),
              yOffset = F.ChooseForTheme(F.Dpi(0), F.Dpi(-16)),
            },
            ["!Classification"] = {
              yOffset = F.ChooseForTheme(F.Dpi(25), F.Dpi(0)),
            },
          },

          raidRoleIcons = {
            yOffset = F.ChooseForTheme(F.Dpi(21), F.Dpi(10)),
          },
        },

        pet = {
          height = F.ChooseForTheme(F.Dpi(15), F.Dpi(20)),

          customTexts = {
            ["!Name"] = {
              yOffset = F.ChooseForTheme(F.Dpi(15), F.Dpi(0)),
            },
          },
        },

        targettarget = {
          height = F.ChooseForTheme(F.Dpi(15), F.Dpi(20)),

          customTexts = {
            ["!Name"] = {
              yOffset = F.ChooseForTheme(F.Dpi(15), F.Dpi(0)),
            },
          },
        },

        focus = {
          customTexts = {
            ["!Name"] = {
              yOffset = F.ChooseForTheme(F.Dpi(25), F.Dpi(0)),
            },
            ["!Health"] = {
              yOffset = F.ChooseForTheme(F.Dpi(25), F.Dpi(0)),

              font = F.FontOverride("- Steelfish"),
              size = F.FontSizeScaled(22),
              fontOutline = F.FontStyleOverride("- Steelfish", "SHADOW"),
            },
            ["!ClassIcon"] = {
              xOffset = F.ChooseForTheme(F.Dpi(-5), F.Dpi(27)),
              yOffset = 0,
            },
          },
        },

        party = {
          customTexts = {
            ["!Name"] = {
              yOffset = F.Dpi(25),
            },
            ["!Health"] = {
              yOffset = F.Dpi(25),

              font = F.FontOverride("- Steelfish"),
              size = F.FontSizeScaled(24),
              fontOutline = F.FontStyleOverride("- Steelfish", "SHADOW"),
            },
            ["!ClassIcon"] = {
              xOffset = F.Dpi(10),
              yOffset = 0,
            },
          },

          raidRoleIcons = {
            yOffset = F.ChooseForTheme(F.Dpi(21), F.Dpi(21)),
          },
        },

        arena = {
          customTexts = {
            ["!Health"] = {
              text_format = "[tx:health:percent:nosign] || [tx:health:current:shortvalue]",
              yOffset = F.ChooseForTheme(F.Dpi(27), F.Dpi(0)),

              font = F.FontOverride("- Steelfish"),
              size = F.FontSizeScaled(20),
              fontOutline = F.FontStyleOverride("- Steelfish", "SHADOW"),
            },

            ["!Name"] = {
              yOffset = F.ChooseForTheme(F.Dpi(27), F.Dpi(0)),
            },
          },
        },

        boss = {
          customTexts = {
            ["!Health"] = {
              yOffset = F.Dpi(25),

              font = F.FontOverride("- Steelfish"),
              size = F.FontSizeScaled(24),
              fontOutline = F.FontStyleOverride("- Steelfish", "SHADOW"),
            },

            ["!Name"] = {
              yOffset = F.Dpi(-5),
            },
          },
        },
      },
      F.Table.If(IsHorizontalLayout, {
        party = {
          customTexts = {
            ["!Health"] = {
              yOffset = F.Dpi(0),
            },

            ["!Name"] = {
              yOffset = F.Dpi(0),
            },
          },
        },
      })
    )
  end

  local colors = PF:BuildColorsProfile()
  F.Table.Crush(pf.unitframe.colors, colors)

  TXUI:LogDebug("Finished building UnitFrames profile for style: " .. style)
  return pf
end

function ST:UpdateProfileForTheme()
  local pf = self:BuildUnitFramesProfile()

  -- Custom Text
  -- Arena
  F.UpdateDBFromPath(pf, "unitframe.units.arena.customTexts.!Health", "yOffset")
  F.UpdateDBFromPath(pf, "unitframe.units.arena.customTexts.!Name", "yOffset")
  F.UpdateDBFromPath(pf, "unitframe.units.arena.customTexts.!Power", "text_format")

  -- Boss
  F.UpdateDBFromPath(pf, "unitframe.units.boss.customTexts.!Health", "yOffset")
  F.UpdateDBFromPath(pf, "unitframe.units.boss.customTexts.!Name", "yOffset")
  F.UpdateDBFromPath(pf, "unitframe.units.boss.customTexts.!Power", "text_format")

  -- Focus
  F.UpdateDBFromPath(pf, "unitframe.units.focus.customTexts.!Health", "yOffset")
  F.UpdateDBFromPath(pf, "unitframe.units.focus.customTexts.!Name", "yOffset")
  F.UpdateDBFromPath(pf, "unitframe.units.focus.customTexts.!Power", "text_format")
  F.UpdateDBFromPath(pf, "unitframe.units.focus.customTexts.!ClassIcon", "xOffset")
  F.UpdateDBFromPath(pf, "unitframe.units.focus.customTexts.!ClassIcon", "yOffset")

  -- Pet
  F.UpdateDBFromPath(pf, "unitframe.units.pet.customTexts.!Name", "yOffset")

  -- Player
  F.UpdateDBFromPath(pf, "unitframe.units.player.customTexts.!Health", "yOffset")
  F.UpdateDBFromPath(pf, "unitframe.units.player.customTexts.!Name", "yOffset")
  F.UpdateDBFromPath(pf, "unitframe.units.player.customTexts.!ClassIcon", "xOffset")
  F.UpdateDBFromPath(pf, "unitframe.units.player.customTexts.!ClassIcon", "yOffset")
  F.UpdateDBFromPath(pf, "unitframe.units.player.raidRoleIcons", "yOffset")

  -- Party
  F.UpdateDBFromPath(pf, "unitframe.units.party.customTexts.!Name", "yOffset")
  F.UpdateDBFromPath(pf, "unitframe.units.party.customTexts.!Power", "text_format")
  F.UpdateDBFromPath(pf, "unitframe.units.party.customTexts.!ClassIcon", "xOffset")
  F.UpdateDBFromPath(pf, "unitframe.units.party.customTexts.!ClassIcon", "yOffset")
  F.UpdateDBFromPath(pf, "unitframe.units.party.raidRoleIcons", "yOffset")

  -- Target
  F.UpdateDBFromPath(pf, "unitframe.units.target.customTexts.!Health", "yOffset")
  F.UpdateDBFromPath(pf, "unitframe.units.target.customTexts.!Name", "yOffset")
  F.UpdateDBFromPath(pf, "unitframe.units.target.customTexts.!Power", "text_format")
  F.UpdateDBFromPath(pf, "unitframe.units.target.customTexts.!ClassIcon", "xOffset")
  F.UpdateDBFromPath(pf, "unitframe.units.target.customTexts.!ClassIcon", "yOffset")
  F.UpdateDBFromPath(pf, "unitframe.units.target.customTexts.!Classification", "yOffset")
  F.UpdateDBFromPath(pf, "unitframe.units.target.raidRoleIcons", "yOffset")

  -- Target-Target
  F.UpdateDBFromPath(pf, "unitframe.units.targettarget.customTexts.!Name", "yOffset")

  -- UnitFrame Heights
  F.UpdateDBFromPath(pf, "unitframe.units.pet", "height")
  F.UpdateDBFromPath(pf, "unitframe.units.player", "height")
  F.UpdateDBFromPath(pf, "unitframe.units.target", "height")
  F.UpdateDBFromPath(pf, "unitframe.units.targettarget", "height")

  -- UnitFrame Color Options
  F.UpdateDBFromPath(pf, "unitframe.colors", "customhealthbackdrop")
  F.UpdateDBFromPath(pf, "unitframe.colors", "healthclass")

  -- UnitFrame Colors
  F.UpdateDBFromPathRGB(pf, "unitframe.colors.health")
  F.UpdateDBFromPathRGB(pf, "unitframe.colors.health_backdrop")
  F.UpdateDBFromPathRGB(pf, "unitframe.colors.health_backdrop_dead")
end
