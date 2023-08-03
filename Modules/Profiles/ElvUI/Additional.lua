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
          enable = false,
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
      },

      -- Misc
      misc = {
        gameBar = {
          enable = false,
        },
      },
    })
  end

  -- Merge Tables
  F.Table.Crush(E.db, pf)
end

function PF:ElvUIAdditionalPrivate()
  -- WindTools Config
  if F.IsAddOnEnabled("ElvUI_WindTools") then
    E.private.WT.maps.instanceDifficulty.enable = true
    E.private.WT.maps.minimapButtons.backdropSpacing = F.Dpi(2)
    E.private.WT.maps.minimapButtons.buttonSize = F.Dpi(25)
    E.private.WT.maps.minimapButtons.buttonsPerRow = 2
    E.private.WT.maps.minimapButtons.mouseOver = true
    E.private.WT.maps.minimapButtons.spacing = F.Dpi(5)
    E.private.WT.maps.superTracker.enable = false
    E.private.WT.maps.worldMap.enable = false
    E.private.WT.maps.worldMap.scale.enable = false
    E.private.WT.misc.moveBlizzardFrames = true
    E.private.WT.quest.objectiveTracker.titleColor.customColorHighlight.b = 0.41960784313725
    E.private.WT.quest.objectiveTracker.titleColor.customColorHighlight.g = 0.82745098039216
    E.private.WT.quest.objectiveTracker.titleColor.customColorHighlight.r = 1
    E.private.WT.quest.objectiveTracker.titleColor.customColorNormal.b = 0.1921568627451
    E.private.WT.quest.objectiveTracker.titleColor.customColorNormal.g = 0.78039215686275
    E.private.WT.quest.objectiveTracker.titleColor.customColorNormal.r = 1
    E.private.WT.skins.elvui.enable = false
    E.private.WT.skins.blizzard.enable = false
    E.private.WT.skins.addons.weakAuras = false
    E.private.WT.skins.removeParchment = false
    E.private.WT.skins.shadow = false
    E.private.WT.unitFrames.quickFocus.enable = false
    E.private.WT.unitFrames.roleIcon.enable = false
  end
end
