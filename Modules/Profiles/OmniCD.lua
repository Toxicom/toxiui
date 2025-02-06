local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local PF = TXUI:GetModule("Profiles")

local _G = _G

function PF:BuildOmniCDProfile()
  local pf = {}
  local db = _G.OmniCD and _G.OmniCD[1]

  local profile = db.DB.profile

  local offset = F.CalculateUltrawideOffset()

  F.Table.Crush(
    pf,
    {
      General = {
        fonts = {
          anchor = {
            font = F.FontOverride(I.Fonts.Primary),
            size = F.FontSizeScaled(16),
            flag = F.FontStyleOverride(I.Fonts.Primary, "OUTLINE"),
          },
          icon = {
            font = F.FontOverride(I.Fonts.Primary),
            size = F.FontSizeScaled(12),
            flag = F.FontStyleOverride(I.Fonts.Primary, "OUTLINE"),
          },
          statusBar = {
            font = F.FontOverride(I.Fonts.Primary),
            size = F.FontSizeScaled(24),
            flag = F.FontStyleOverride(I.Fonts.Primary, "OUTLINE"),
          },
        },
        textures = {
          statusBar = {
            BG = "- ToxiUI",
            bar = "- ToxiUI",
          },
        },
      },

      Party = {
        party = {
          extraBars = {
            -- Interrupts
            raidBar1 = {
              name = "Interrupts",
              hideSpark = true,
              textOfsX = 4,
              statusBarWidth = 426,
              manualPos = {
                raidBar1 = {
                  x = F.Dpi(329) + offset,
                  y = F.Dpi(165),
                },
              },
              reverseFill = false,
              bgColors = {
                activeColor = {
                  a = 0.6,
                },
              },
              scale = 0.65,
              sortBy = 1,
              locked = true,
            },

            -- Defensives
            raidBar2 = {
              name = "Defensives",
              spellType = {
                other = false,
                racial = false,
                custom2 = false,
                essence = false,
                trinket = false,
                custom1 = false,
                pvptrinket = false,
                covenant = false,
                consumable = false,
                cc = false,
                disarm = false,
                offensive = false,
                raidMovement = false,
                counterCC = false,
                immunity = false,
              },
              scale = 0.8,
              columns = 21,
              progressBar = false,
              enabled = true,
              manualPos = {
                raidBar2 = {
                  x = F.Dpi(165) + offset,
                  y = F.Dpi(250),
                },
              },
              paddingX = 1,
              layout = "horizontal",
              showName = false,
            },

            -- CC
            raidBar3 = {
              name = "CC",
              truncateIconName = 4,
              scale = 0.94,
              progressBar = false,
              growUpward = true,
              spellType = {
                disarm = true,
                cc = true,
              },
              paddingY = 1,
              enabled = true,
              manualPos = {
                raidBar3 = {
                  x = F.Dpi(790) + offset,
                  y = F.Dpi(345),
                },
              },
              columns = 3,
            },

            -- Immunes
            raidBar4 = {
              name = "Immunes",
              truncateIconName = 4,
              scale = 0.9199999999999999,
              progressBar = false,
              growUpward = true,
              spellType = {
                other = true,
                raidMovement = true,
                immunity = true,
              },
              sortDirection = "dsc",
              paddingY = 1,
              enabled = true,
              manualPos = {
                raidBar4 = {
                  x = F.Dpi(790) + offset,
                  y = F.Dpi(425),
                },
              },
              paddingX = 1,
              columns = 3,
            },
          },

          frame = {
            externalDefensive = 0,
            raidDefensive = 0,
            defensive = 2,
            disarm = 3,
            aoeCC = 3,
            cc = 3,
            counterCC = 3,
            immunity = 4,
          },

          highlight = {
            glowBuffs = false,
            glow = false,
          },

          spells = profile.Party.party.spells or {},

          icons = {
            scale = 0.85,
            showTooltip = false,
            desaturateActive = true,
            markEnhanced = false,
          },

          raidCDS = profile.Party.party.raidCDS or {},

          position = {
            paddingX = 1,
            attach = "TOPLEFT",
            preset = "TOPLEFT",
            offsetX = F.Dpi(50),
            anchor = "TOPRIGHT",
          },

          priority = {
            dispel = 0,
          },

          general = {
            showPlayerEx = false,
            showPlayer = true,
            showRange = true,
          },
        },

        raid = {
          extraBars = {
            raidBar0 = {
              hideSpark = true,
              statusBarWidth = F.Dpi(200),
              manualPos = {
                raidBar0 = {
                  x = F.Dpi(340) + offset,
                  y = F.Dpi(155),
                },
              },
              reverseFill = false,
              bgColors = {
                activeColor = {
                  a = 0.6,
                },
              },
              scale = 0.65,
              sortBy = 1,
              locked = true,
            },

            raidBar2 = {
              truncateIconName = 3,
              scale = 1,
              progressBar = false,
              growUpward = true,
              spellType = {
                offensive = true,
              },
              sortDirection = "dsc",
              paddingY = 1,
              enabled = true,
              columns = 20,
              manualPos = {
                raidBar2 = {
                  x = F.Dpi(265) + offset,
                  y = F.Dpi(225),
                },
              },
              locked = true,
            },

            raidBar1 = {
              manualPos = {
                raidBar1 = {
                  x = F.Dpi(240) + offset,
                  y = F.Dpi(205),
                },
              },
              growLeft = true,
              truncateIconName = 3,
              scale = 1,
              progressBar = false,
              spellType = {
                other = false,
                racial = false,
                custom2 = false,
                disarm = false,
                custom1 = false,
                pvptrinket = false,
                dispel = false,
                cc = false,
                raidMovement = false,
                essence = false,
                trinket = false,
                defensive = false,
                covenant = false,
                consumable = false,
                offensive = false,
                raidDefensive = false,
                counterCC = false,
              },
              locked = true,
              paddingY = 2,
              columns = 20,
              paddingX = 1,
              layout = "horizontal",
              sortBy = 4,
              sortDirection = "dsc",
            },
          },

          highlight = {
            glowBuffs = false,
          },

          spells = profile.Party.raid.spells or {},

          icons = {
            showForbearanceCounter = false,
            scale = 0.96,
            desaturateActive = true,
            counterScale = 0.7,
            markEnhanced = false,
            chargeScale = 0.9,
          },

          raidCDS = profile.Party.raid.raidCDS or {},

          position = {
            offsetX = 2,
          },

          priority = {
            immunity = 12,
            offensive = 9,
          },

          manualPos = {
            raidCDBar2 = {
              x = F.Dpi(35) + offset,
              y = F.Dpi(230),
            },
          },

          general = {
            zoneSelected = "party",
            showPlayer = true,
            showPlayerEx = false,
            showRange = true,
          },
        },

        visibility = {
          raid = false,
          arena = false,
          size = 40,
        },
      },
    },
    F.Table.If(E.db.TXUI.installer.layout == I.Enum.Layouts.HORIZONTAL, {
      Party = {
        party = {
          extraBars = {
            -- Interrupts
            raidBar1 = {
              manualPos = {
                raidBar1 = {
                  x = F.Dpi(165) + offset,
                  y = F.Dpi(365),
                },
              },
            },
          },

          position = {
            maxNumIcons = 5,

            preset = "manual",
            attach = "BOTTOMLEFT",
            attachMore = "BOTTOMLEFT",
            anchor = "TOPLEFT",
            anchorMore = "TOPLEFT",

            offsetX = F.Dpi(0),
            offsetY = F.Dpi(35),
          },
        },
      },
    })
  )

  return pf
end

function PF:ApplyOmniCDProfile()
  if not F.IsAddOnEnabled("OmniCD") then
    TXUI:LogWarning("OmniCD is not enabled. Will not apply profile.")
    return
  end

  local db = _G.OmniCD and _G.OmniCD[1]
  if not db then
    TXUI:LogWarning("No database found for OmniCD -- will not apply profile.")
    return
  end

  local profileName = E.db.TXUI.installer.layout == I.Enum.Layouts.HORIZONTAL and I.ProfileNames[I.Enum.Layouts.HORIZONTAL] or I.ProfileNames[I.Enum.Layouts.VERTICAL]
  local profile = PF:BuildOmniCDProfile() or {}

  db.DB:SetProfile(profileName)
  db.DB:ResetProfile(profileName)
  F.Table.Crush(db.DB.profile, profile)

  TXUI:LogInfo(F.String.ToxiUI("OmniCD") .. " profile successfully installed and applied. Please reload your UI!")
end
