local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local PF = TXUI:GetModule("Profiles")

function PF:ElvUIAdditional()
  local pf = {}

  -- WindTools Config
  if F.IsAddOnEnabled("ElvUI_WindTools") then
    pf.WT = {}
    pf.movers = {}

    -- WT Mover
    F.Table.Crush(pf.movers, {
      WTMinimapButtonBarAnchor = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -238, -4),
    })

    -- WT DB Settings
    F.Table.Crush(pf.WT, {
      -- Announcement
      announcement = {
        goodbye = {
          enable = false,
        },
        interrupt = {
          enable = false,
        },
        thanks = {
          enable = false,
        },
        utility = {
          enable = false,
        },
      },

      -- Combat
      combat = {
        combatAlert = {
          enable = false,
        },

        raidMarkers = {
          enable = true,
          backdropSpacing = F.Dpi(2),
          buttonSize = F.Dpi(24),
          countDownTime = 7,
          spacing = F.Dpi(8),
          visibility = "INPARTY",
        },
      },

      -- Items
      item = {
        contacts = {
          enable = true,
        },

        extraItemsBar = {
          enable = true,

          bar1 = {
            alphaMax = 1,
            alphaMin = 0.5,
            anchor = "BOTTOMRIGHT",
            backdropSpacing = 2,
            buttonHeight = 30,
            buttonsPerRow = 2,
            buttonWidth = 40,
            enable = true,
            include = "QUEST,OPENABLE,DELVE",
            mouseOver = true,
            numButtons = 8,
            spacing = 2,
          },

          bar2 = {
            enable = false,
          },

          bar3 = {
            enable = false,
          },
        },

        delete = {
          fillIn = "AUTO",
        },

        inspect = {
          player = false,
          playerOnInspect = false,
          stats = false,
        },
      },

      -- Maps
      maps = {
        whoClicked = {
          enable = false,
        },

        eventTracker = {
          font = {
            scale = 0.7,
          },
        },
      },

      -- Quest
      quest = {
        switchButtons = {
          enable = false,
        },

        turnIn = {
          enable = false,
        },
      },

      -- Social
      social = {
        chatText = {
          abbreviation = "DEFAULT",
          roleIconStyle = "BLIZZARD",
          removeBrackets = false,
        },

        friendList = {
          textures = {
            status = "Default",
          },
        },

        chatLink = {
          enable = false,
        },

        emote = {
          enable = false,
        },

        smartTab = {
          enable = false,
        },

        chatBar = {
          enable = false,
        },

        contextMenu = {
          enable = false,
        },
      },

      -- Misc
      misc = {
        gameBar = {
          enable = false,
        },
      },

      tooltips = {
        elvUITweaks = {
          raceIcon = {
            enable = false,
          },

          specIcon = {
            enable = false,
          },
        },
      },
    })
  end

  -- Merge Tables
  F.Table.Crush(E.db, pf)
end

function PF:ElvUIAdditionalPrivate()
  local pv = {}

  -- WindTools Config
  if F.IsAddOnEnabled("ElvUI_WindTools") then
    pv.WT = {}

    local widgetTexture = "- Tx Fade"
    local widgetClassColor = true

    -- WindTools Private Settings
    F.Table.Crush(pv.WT, {
      -- Maps
      maps = {
        -- Maps: Instance Difficulty
        instanceDifficulty = {
          enable = true,
        },

        -- Maps: Minimap Buttons
        minimapButtons = {
          backdropSpacing = F.Dpi(2),
          buttonSize = F.Dpi(25),
          buttonsPerRow = 3,
          mouseOver = true,
          spacing = F.Dpi(5),
        },

        -- Maps: Super Tracker
        superTracker = {
          enable = false,
        },

        -- Maps: World Map
        worldMap = {
          enable = false,

          scale = {
            enable = false,
          },
        },
      },

      -- Misc
      misc = {
        moveBlizzardFrames = true,
      },

      -- Quest
      quest = {
        objectiveTracker = {
          header = {
            classColor = true,
          },

          titleColor = {
            customColorNormal = F.Table.HexToRGB("#ffc730"),
            customColorHighlight = F.Table.HexToRGB("#ffd36b"),
          },
        },
      },

      -- Skins
      skins = {
        -- Skins: ElvUI
        elvui = {
          enable = false,
        },

        -- Skins: Blizzard
        blizzard = {
          enable = false,
        },

        -- Skins: Addons
        addons = {
          weakAuras = false,
        },

        -- Skins: Widgets
        widgets = {
          button = {
            backdrop = {
              color = F.Table.HexToRGB(I.Strings.Colors[I.Enum.Colors.TXUI]),
              texture = widgetTexture,
              classColor = widgetClassColor,
            },

            selected = {
              backdropClassColor = widgetClassColor,
              backdropColor = F.Table.HexToRGB(I.Strings.Colors[I.Enum.Colors.TXUI]),
              backdropAlpha = 1,

              borderClassColor = widgetClassColor,
              borderColor = F.Table.HexToRGB(I.Strings.Colors[I.Enum.Colors.TXUI]),
              borderAlpha = 0.4,
            },
          },

          checkbox = {
            color = F.Table.HexToRGB(I.Strings.Colors[I.Enum.Colors.TXUI]),
            texture = "- ToxiUI",
            classColor = widgetClassColor,
          },

          slider = {
            color = F.Table.HexToRGB(I.Strings.Colors[I.Enum.Colors.TXUI]),
            texture = "- ToxiUI",
            classColor = widgetClassColor,
          },

          tab = {
            backdrop = {
              color = F.Table.HexToRGB(I.Strings.Colors[I.Enum.Colors.TXUI]),
              texture = widgetTexture,
              classColor = widgetClassColor,
            },

            selected = {
              backdropClassColor = widgetClassColor,
              backdropColor = F.Table.HexToRGB(I.Strings.Colors[I.Enum.Colors.TXUI]),
              backdropAlpha = 0.4,

              borderClassColor = widgetClassColor,
              borderColor = F.Table.HexToRGB(I.Strings.Colors[I.Enum.Colors.TXUI]),
              borderAlpha = 0.4,

              texture = widgetTexture,
            },

            text = {
              normalClassColor = widgetClassColor,
              normalColor = F.Table.HexToRGB(I.Strings.Colors[I.Enum.Colors.TXUI]),
            },
          },

          treeGroupButton = {
            backdrop = {
              color = F.Table.HexToRGB(I.Strings.Colors[I.Enum.Colors.TXUI]),
              texture = widgetTexture,
              classColor = widgetClassColor,
            },

            selected = {
              backdropClassColor = widgetClassColor,
              backdropColor = F.Table.HexToRGB(I.Strings.Colors[I.Enum.Colors.TXUI]),
              backdropAlpha = 0.4,

              borderClassColor = widgetClassColor,
              borderColor = F.Table.HexToRGB(I.Strings.Colors[I.Enum.Colors.TXUI]),
              borderAlpha = 0.4,

              texture = widgetTexture,
            },

            text = {
              normalClassColor = widgetClassColor,
              normalColor = F.Table.HexToRGB(I.Strings.Colors[I.Enum.Colors.TXUI]),
            },
          },
        },

        removeParchment = false,
        shadow = false,
      },

      -- Unit Frames
      unitFrames = {
        quickFocus = {
          enable = false,
        },
        roleIcon = {
          enable = false,
        },
      },
    })
  end

  -- Merge Tables
  F.Table.Crush(E.private, pv)
end
