local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local PF = TXUI:GetModule("Profiles")

local _G = _G

function PF:BuildOmniCDProfile()
  local pf = {}

  F.Table.Crush(
    pf,
    {
      General = {
        fonts = {
          anchor = {
            font = F.FontOverride(I.Fonts.Primary),
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
            BG = "- Tx Left",
            bar = "- Tx Left",
          },
        },
      },

      Party = {
        party = {
          extraBars = {
            -- Interrupts
            raidBar0 = {
              name = "Interrupts",
              hideSpark = true,
              textOfsX = 4,
              statusBarWidth = 426,
              manualPos = {
                raidBar0 = {
                  x = F.Dpi(329),
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
            raidBar1 = {
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
                raidBar1 = {
                  x = F.Dpi(165),
                  y = F.Dpi(265),
                },
              },
              paddingX = 1,
              layout = "horizontal",
              showName = false,
              locked = true,
            },

            -- CC
            raidBar2 = {
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
                raidBar2 = {
                  x = F.Dpi(790),
                  y = F.Dpi(345),
                },
              },
              columns = 3,
              locked = true,
            },

            -- Immunes
            raidBar3 = {
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
                raidBar3 = {
                  x = F.Dpi(790),
                  y = F.Dpi(425),
                },
              },
              paddingX = 1,
              columns = 3,
              locked = true,
            },
          },

          highlight = {
            glowBuffs = false,
            glow = false,
          },

          spells = {
            -- TODO: Finish comments omg
            -- Evoker
            ["357210"] = true, -- Evoker: Deep Breath
            ["370665"] = true, -- Evoker: Rescue
            ["374227"] = false, -- Evoker: Zephyr
            ["363916"] = false, -- Evoker: Obsidian Scales

            -- Warrior
            ["118038"] = false, -- Warrior: Die by the Sword
            ["5246"] = false, -- Warrior: Intimidating Shout

            -- Paladin
            ["216331"] = false, -- Paladin: Avenging Crusader
            ["115750"] = false, -- Paladin: Blinding Light

            -- Druid
            ["124974"] = true, -- Druid: Nature's Vigil
            ["740"] = false, -- Druid: Tranquility
            ["33891"] = false, -- Druid: Tree of Life
            ["22812"] = false, -- Druid: Barkskin
            ["102793"] = true, -- Druid: Ursol's Vortex

            -- Shaman
            ["8143"] = false, -- Shaman: Tremor Totem
            ["51490"] = true, -- Shaman: Thunderstorm
            ["192077"] = true, -- Shaman: Wind Rush Totem

            -- Warlock
            ["5484"] = true, -- Warlock: Howl of Terror
            ["205180"] = true, -- Warlock: Summon Darkglare
            ["212295"] = false, -- Warlock: Nether Ward
            ["48020"] = false, -- Warlock: Demonic Circle: Teleport
            ["1122"] = true, -- Warlock: Summon Infernal

            ["187650"] = false, -- Hunter: Freezing Trap
            ["235219"] = false, -- Mage: Cold Snap
            ["215652"] = false,
            ["59752"] = false,
            ["7744"] = false,
            ["115203"] = false,
            ["210918"] = false,
            ["345231"] = false,
            ["336135"] = false,
            ["209258"] = false,
            ["205636"] = true,
            ["102560"] = true,
            ["107574"] = true,
            ["108968"] = false,
            ["108281"] = true,
            ["179057"] = true,
            ["122783"] = false,
            ["10060"] = true,
            ["132578"] = true,
            ["53480"] = false,
            ["13750"] = true,
            ["231895"] = false,
            ["48707"] = false,
            ["363534"] = false,
            ["210256"] = false,
            ["102558"] = true,
            ["47482"] = false,
            ["23920"] = false,
            ["198111"] = false,
            ["236320"] = false,
            ["45438"] = false,
            ["31230"] = false,
            ["194223"] = true,
            ["204336"] = false,
            ["377509"] = false,
            ["31935"] = false,
            ["228049"] = false,
            ["186265"] = false,
            ["48792"] = false,
            ["322118"] = true,
            ["115310"] = false,
            ["205604"] = false,
            ["122470"] = false,
            ["106898"] = true,
            ["31224"] = false,
            ["204018"] = true,
            ["104773"] = false,
            ["108280"] = false,
            ["365350"] = true,
            ["119381"] = true,
            ["97462"] = false,
            ["342245"] = false,
            ["197268"] = false,
            ["374251"] = true,
            ["50334"] = true,
            ["853"] = false,
            ["108271"] = false,
            ["30884"] = false,
            ["42650"] = true,
            ["6789"] = false,
            ["99"] = true,
            ["109304"] = false,
            ["265202"] = false,
            ["193530"] = true,
            ["378441"] = false,
            ["871"] = false,
            ["47536"] = false,
            ["114556"] = false,
            ["109248"] = true,
            ["184364"] = false,
            ["121471"] = true,
            ["86949"] = false,
            ["152279"] = true,
            ["114018"] = true,
            ["2094"] = false,
            ["378464"] = false,
            ["374348"] = false,
            ["192058"] = true,
            ["198838"] = false,
            ["19574"] = true,
            ["336126"] = false,
            ["12472"] = true,
            ["132469"] = true,
            ["114050"] = true,
            ["102543"] = true,
            ["198589"] = false,
            ["374968"] = true,
            ["5277"] = false,
            ["1856"] = false,
            ["114051"] = true,
            ["288613"] = true,
            ["61336"] = false,
            ["6940"] = true,
            ["64044"] = false,
            ["116844"] = true,
            ["196555"] = false,
            ["108238"] = false,
            ["47585"] = false,
            ["122278"] = false,
            ["642"] = false,
            ["73325"] = true,
            ["265187"] = true,
            ["30283"] = true,
            ["123904"] = true,
            ["64843"] = false,
            ["19236"] = false,
          },

          icons = {
            scale = 0.85,
            showTooltip = false,
            desaturateActive = true,
            markEnhanced = false,
          },

          raidCDS = {
            ["114018"] = true,
            ["1022"] = true,
            ["116849"] = true,
            ["51490"] = true,
            ["2565"] = true,
            ["124974"] = true,
            ["5484"] = true,
            ["370665"] = true,
            ["106898"] = true,
            ["8122"] = true,
            ["202137"] = true,
            ["6940"] = true,
            ["192077"] = true,
            ["204018"] = true,
            ["102793"] = true,
            ["199452"] = true,
            ["357170"] = true,
            ["119381"] = true,
            ["192058"] = true,
            ["374251"] = true,
            ["205636"] = true,
            ["102342"] = true,
            ["108281"] = true,
            ["179057"] = true,
            ["871"] = true,
            ["47788"] = true,
            ["1160"] = true,
            ["372048"] = true,
            ["374968"] = true,
            ["12975"] = true,
            ["116844"] = true,
            ["33206"] = true,
            ["99"] = true,
            ["73325"] = true,
            ["132469"] = true,
            ["30283"] = true,
            ["109248"] = true,
          },

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
                  x = F.Dpi(340),
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
                  x = F.Dpi(265),
                  y = F.Dpi(225),
                },
              },
              locked = true,
            },

            raidBar1 = {
              manualPos = {
                raidBar1 = {
                  x = F.Dpi(240),
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

          spells = {
            ["204336"] = false,
            ["64044"] = false,
            ["377509"] = false,
            ["216331"] = false,
            ["118038"] = false,
            ["209258"] = false,
            ["740"] = false,
            ["8143"] = false,
            ["186265"] = false,
            ["15487"] = false,
            ["48792"] = false,
            ["51052"] = false,
            ["6552"] = false,
            ["115310"] = false,
            ["57994"] = false,
            ["115750"] = false,
            ["22812"] = false,
            ["184364"] = false,
            ["187827"] = false,
            ["212295"] = false,
            ["212619"] = false,
            ["5246"] = false,
            ["187650"] = false,
            ["48020"] = false,
            ["183752"] = false,
            ["8122"] = false,
            ["235219"] = false,
            ["106839"] = false,
            ["6940"] = true,
            ["104773"] = false,
            ["204018"] = true,
            ["198838"] = false,
            ["336126"] = false,
            ["236320"] = false,
            ["196555"] = false,
            ["62618"] = false,
            ["108280"] = false,
            ["215652"] = false,
            ["23920"] = false,
            ["59752"] = false,
            ["47528"] = false,
            ["388007"] = true,
            ["119898"] = false,
            ["97462"] = false,
            ["7744"] = false,
            ["109304"] = false,
            ["342245"] = false,
            ["228049"] = false,
            ["197268"] = false,
            ["30884"] = false,
            ["15286"] = false,
            ["210918"] = false,
            ["363916"] = false,
            ["345231"] = false,
            ["853"] = false,
            ["336135"] = false,
            ["1856"] = false,
            ["116705"] = false,
            ["2139"] = false,
            ["210256"] = false,
            ["6789"] = false,
            ["191427"] = false,
            ["190319"] = false,
            ["351338"] = false,
            ["31224"] = false,
            ["196718"] = false,
            ["31935"] = false,
            ["64843"] = false,
            ["378441"] = false,
            ["1766"] = false,
            ["871"] = false,
            ["47536"] = false,
            ["187707"] = false,
            ["48707"] = false,
            ["10060"] = true,
            ["86949"] = false,
            ["2094"] = false,
            ["98008"] = false,
            ["53480"] = false,
            ["374227"] = false,
            ["78675"] = false,
            ["378464"] = false,
            ["374348"] = false,
            ["115203"] = false,
            ["231895"] = false,
            ["108968"] = false,
            ["122783"] = false,
            ["96231"] = false,
            ["122278"] = false,
            ["114556"] = false,
            ["363534"] = false,
            ["372048"] = false,
            ["108271"] = false,
            ["5277"] = false,
            ["61336"] = false,
            ["198589"] = false,
            ["114052"] = false,
            ["33891"] = false,
            ["360194"] = false,
            ["205604"] = false,
            ["47482"] = false,
            ["265202"] = false,
            ["198111"] = false,
            ["47585"] = false,
            ["147362"] = false,
            ["31821"] = false,
            ["45438"] = false,
            ["642"] = false,
            ["31230"] = false,
            ["108238"] = false,
            ["31884"] = false,
            ["122470"] = false,
            ["19236"] = false,
          },

          icons = {
            showForbearanceCounter = false,
            scale = 0.96,
            desaturateActive = true,
            counterScale = 0.7,
            markEnhanced = false,
            chargeScale = 0.9,
          },

          raidCDS = {
            ["102342"] = true,
            ["1022"] = true,
            ["116849"] = true,
            ["388007"] = true,
            ["47788"] = true,
            ["6940"] = true,
            ["10060"] = true,
            ["204018"] = true,
            ["199452"] = true,
            ["357170"] = true,
            ["33206"] = true,
          },

          position = {
            offsetX = 2,
          },

          priority = {
            immunity = 12,
            offensive = 9,
          },

          manualPos = {
            raidCDBar2 = {
              x = F.Dpi(35),
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
          raid = true,
          arena = false,
          size = 40,
        },
      },
    },
    F.Table.If(E.db.TXUI.installer.layout == I.Enum.Layouts.HEALER, {
      Party = {
        party = {
          extraBars = {
            -- Interrupts
            raidBar0 = {
              manualPos = {
                raidBar0 = {
                  x = F.Dpi(165),
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

  local profileName = I.ProfileNames.Default
  local profile = PF:BuildOmniCDProfile() or {}

  db.DB:SetProfile(profileName)
  db.DB:ResetProfile(profileName)
  F.Table.Crush(db.DB.profile, profile)

  TXUI:LogInfo("OmniCD profile successfully installed and applied. Please reload your UI!")
end
