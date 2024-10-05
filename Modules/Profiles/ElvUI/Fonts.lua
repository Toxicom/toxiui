local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local PF = TXUI:GetModule("Profiles")

local next = next
local ipairs = ipairs
local unpack = unpack

local function customTextSize(args)
  local ret = {}
  for _, v in ipairs(args) do
    if not v then return end
    local name, font, size, outline, stopOverride = unpack(v)
    ret[name] = {
      font = stopOverride and font or F.FontOverride(font),
      size = F.FontSizeScaled(size),
      fontOutline = stopOverride and outline or F.FontStyleOverride(font, outline),
    }
  end
  return ret
end

function PF:ElvUIFont()
  F.Table.Crush(E.db, {
    -- General
    general = {
      font = F.FontOverride(I.Fonts.Primary),
      fontSize = F.FontSizeScaled(14, 13),
      fontStyle = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),

      fonts = {
        cooldown = {
          enable = true,
          font = F.FontOverride(I.Fonts.Primary),
          outline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
        },

        errortext = {
          enable = true,
          font = F.FontOverride(I.Fonts.Primary),
          outline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
        },

        mailbody = {
          enable = true,
          font = F.FontOverride(I.Fonts.Primary),
          outline = F.FontStyleOverride(I.Fonts.Primary, "NONE"),
        },

        pvpsubzone = {
          enable = true,
          font = F.FontOverride(I.Fonts.Primary),
          outline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
        },

        pvpzone = {
          enable = true,
          font = F.FontOverride(I.Fonts.Primary),
          outline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
        },

        questsmall = {
          enable = true,
          font = F.FontOverride(I.Fonts.Primary),
          outline = F.FontStyleOverride(I.Fonts.Primary, "NONE"),
        },

        questtext = {
          enable = true,
          font = F.FontOverride(I.Fonts.Primary),
          outline = F.FontStyleOverride(I.Fonts.Primary, "NONE"),
        },

        questtitle = {
          enable = true,
          font = F.FontOverride(I.Fonts.Primary),
          outline = F.FontStyleOverride(I.Fonts.Primary, "NONE"),
        },

        worldsubzone = {
          enable = true,
          font = F.FontOverride(I.Fonts.Primary),
          outline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
        },

        worldzone = {
          enable = true,
          font = F.FontOverride(I.Fonts.Primary),
          outline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
        },
      },

      itemLevel = {
        itemLevelFont = F.FontOverride(I.Fonts.Primary),
        itemLevelFontSize = F.FontSize(11),
        itemLevelFontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),

        totalLevelFont = F.FontOverride(I.Fonts.Primary),
        totalLevelFontSize = F.FontSize(12),
        totalLevelFontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
      },

      altPowerBar = {
        font = F.FontOverride(I.Fonts.Primary),
        fontSize = F.FontSizeScaled(18),
        fontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
      },

      minimap = {
        locationFont = F.FontOverride(I.Fonts.Primary),
        locationFontSize = F.FontSizeScaled(22),
        locationFontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),

        icons = {
          queueStatus = {
            font = F.FontOverride(I.Fonts.Primary),
            fontSize = F.FontSizeScaled(12),
            fontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
          },
        },
      },

      queueStatus = {
        font = F.FontOverride(I.Fonts.Primary),
        fontSize = F.FontSizeScaled(16),
      },

      lootRoll = {
        nameFont = F.FontOverride(I.Fonts.Primary),
        nameFontSize = F.FontSizeScaled(14),
        nameFontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
      },

      totems = {
        font = F.FontOverride(I.Fonts.Primary),
        fontSize = F.FontSizeScaled(14),
        fontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
      },

      addonCompartment = {
        font = F.FontOverride(I.Fonts.Primary),
        fontSize = F.FontSizeScaled(16),
        fontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
      },

      guildBank = {
        countFont = F.FontOverride(I.Fonts.Primary),
        countFontSize = F.FontSizeScaled(20),
        countFontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),

        itemLevelFont = F.FontOverride(I.Fonts.Primary),
        itemLevelFontSize = F.FontSizeScaled(20),
        itemLevelFontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
      },
    },

    -- Bags
    bags = {
      itemLevelFont = F.FontOverride(I.Fonts.Primary),
      itemLevelFontSize = F.FontSizeScaled(20),
      itemLevelFontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),

      itemInfoFont = F.FontOverride(I.Fonts.Primary),
      itemInfoFontSize = F.FontSizeScaled(20),
      itemInfoFontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),

      countFont = F.FontOverride(I.Fonts.Primary),
      countFontSize = F.FontSizeScaled(20),
      countFontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),

      cooldown = {
        fonts = {
          enable = true,
          font = F.FontOverride(I.Fonts.Primary),
          fontSize = F.FontSizeScaled(16),
          fontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
        },
      },

      bagBar = {
        font = F.FontOverride(I.Fonts.Primary),
        fontSize = F.FontSizeScaled(14),
        fontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
      },
    },

    -- Chat
    chat = {
      font = F.FontOverride(I.Fonts.Primary),
      fontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),

      tabFont = F.FontOverride(I.Fonts.Primary),
      tabFontSize = F.FontSizeScaled(14, 13),
      tabFontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
    },

    -- Auras
    auras = {
      -- Buffs
      buffs = {
        countFont = F.FontOverride(I.Fonts.Primary),
        countFontSize = F.FontSizeScaled(20),
        countFontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),

        timeFont = F.FontOverride(I.Fonts.Primary),
        timeFontSize = F.FontSizeScaled(16),
        timeFontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
      },

      -- Debuffs
      debuffs = {
        countFont = F.FontOverride(I.Fonts.Primary),
        countFontSize = F.FontSizeScaled(20),
        countFontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),

        timeFont = F.FontOverride(I.Fonts.Primary),
        timeFontSize = F.FontSizeScaled(16),
        timeFontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
      },
    },

    -- UnitFrames
    unitframe = {
      font = F.FontOverride(I.Fonts.Primary),
      fontSize = F.FontSizeScaled(16),
      fontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),

      cooldown = {
        fonts = {
          enable = true,
          font = F.FontOverride(I.Fonts.Primary),
          fontSize = F.FontSizeScaled(16),
          fontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
        },
      },

      units = {
        player = {
          customTexts = customTextSize {
            { "!Name", I.Fonts.Title, 26, "SHADOWOUTLINE" },
            { "!Health", I.Fonts.Primary, 36, "SHADOWOUTLINE" },
            { "!HealthSmall", I.Fonts.Primary, 14, "SHADOWOUTLINE" },
            { "!Level", I.Fonts.Primary, 14, "SHADOWOUTLINE" },
            { "!Power", I.Fonts.Primary, 20, "SHADOWOUTLINE" },
            { "!ClassIcon", I.Fonts.Primary, 12, "SHADOWOUTLINE" },
            E.Classic and { "!Power", I.Fonts.TitleBlack, 24, "SHADOWOUTLINE" } or { "!Power", I.Fonts.Primary, 20, "SHADOWOUTLINE" },
          },

          buffs = {
            countFont = F.FontOverride(I.Fonts.TitleBlack),
            countFontSize = F.FontSizeScaled(16),
          },

          debuffs = {
            countFont = F.FontOverride(I.Fonts.TitleBlack),
            countFontSize = F.FontSizeScaled(16),
          },

          castbar = {
            customTextFont = {
              enable = true,
              font = F.FontOverride(I.Fonts.Primary),
              fontSize = F.FontSizeScaled(14),
              fontStyle = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
            },

            customTimeFont = {
              enable = true,
              font = F.FontOverride(I.Fonts.Primary),
              fontSize = F.FontSizeScaled(16),
              fontStyle = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
            },
          },
        },

        target = {
          customTexts = customTextSize {
            { "!Name", I.Fonts.Title, 26, "SHADOWOUTLINE" },
            { "!Health", I.Fonts.Primary, 36, "SHADOWOUTLINE" },
            { "!HealthSmall", I.Fonts.Primary, 14, "SHADOWOUTLINE" },
            { "!Level", I.Fonts.Primary, 14, "SHADOWOUTLINE" },
            { "!Power", I.Fonts.Primary, 20, "SHADOWOUTLINE" },
            { "!ClassIcon", I.Fonts.Primary, 12, "SHADOWOUTLINE" },
            { "!Classification", I.Fonts.Primary, 20, "SHADOWOUTLINE", true },
          },

          buffs = {
            countFont = F.FontOverride(I.Fonts.TitleBlack),
            countFontSize = F.FontSizeScaled(16),
          },

          debuffs = {
            countFont = F.FontOverride(I.Fonts.TitleBlack),
            countFontSize = F.FontSizeScaled(16),
          },

          castbar = {
            customTextFont = {
              enable = true,
              font = F.FontOverride(I.Fonts.Primary),
              fontSize = F.FontSizeScaled(14),
              fontStyle = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
            },

            customTimeFont = {
              enable = true,
              font = F.FontOverride(I.Fonts.Primary),
              fontSize = F.FontSizeScaled(16),
              fontStyle = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
            },
          },
        },

        pet = {
          customTexts = customTextSize {
            { "!Name", I.Fonts.Title, 16, "SHADOWOUTLINE" },
            { "!Happiness", I.Fonts.Title, 16, "SHADOWOUTLINE" },
          },

          castbar = {
            customTextFont = {
              enable = true,
              font = F.FontOverride(I.Fonts.Primary),
              fontSize = F.FontSizeScaled(14),
              fontStyle = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
            },

            customTimeFont = {
              enable = true,
              font = F.FontOverride(I.Fonts.Primary),
              fontSize = F.FontSizeScaled(16),
              fontStyle = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
            },
          },
        },

        targettarget = {
          customTexts = customTextSize { { "!Name", I.Fonts.Title, 16, "SHADOWOUTLINE" } },
        },

        focus = {
          customTexts = customTextSize {
            { "!Name", I.Fonts.Title, 26, "SHADOWOUTLINE" },
            { "!Health", I.Fonts.Primary, 36, "SHADOWOUTLINE" },
            { "!HealthSmall", I.Fonts.Primary, 14, "SHADOWOUTLINE" },
            { "!Power", I.Fonts.Primary, 20, "SHADOWOUTLINE" },
            { "!ClassIcon", I.Fonts.Primary, 12, "SHADOWOUTLINE" },
          },

          buffs = {
            countFont = F.FontOverride(I.Fonts.TitleBlack),
            countFontSize = F.FontSizeScaled(16),
          },

          debuffs = {
            countFont = F.FontOverride(I.Fonts.TitleBlack),
            countFontSize = F.FontSizeScaled(16),
          },

          castbar = {
            customTextFont = {
              enable = true,
              font = F.FontOverride(I.Fonts.Primary),
              fontSize = F.FontSizeScaled(14),
              fontStyle = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
            },

            customTimeFont = {
              enable = true,
              font = F.FontOverride(I.Fonts.Primary),
              fontSize = F.FontSizeScaled(16),
              fontStyle = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
            },
          },
        },

        party = F.Table.Join(
          {
            customTexts = customTextSize {
              { "!Name", I.Fonts.Title, 26, "SHADOWOUTLINE" },
              { "!Health", I.Fonts.Primary, 36, "SHADOWOUTLINE" },
              { "!Power", I.Fonts.Primary, 20, "SHADOWOUTLINE" },
              { "!Level", I.Fonts.Primary, 14, "SHADOWOUTLINE" },
              { "!ClassIcon", I.Fonts.Primary, 12, "SHADOWOUTLINE" },
            },

            buffs = {
              countFont = F.FontOverride(I.Fonts.TitleBlack),
              countFontSize = F.FontSizeScaled(18),
            },

            debuffs = {
              countFont = F.FontOverride(I.Fonts.TitleBlack),
              countFontSize = F.FontSizeScaled(18),
            },

            rdebuffs = {
              font = F.FontOverride(I.Fonts.Primary),
              fontSize = F.FontSizeScaled(18),
              fontOutline = F.FontStyleOverride(I.Fonts.Title, "SHADOWOUTLINE"),
            },
          },
          F.Table.If(E.db.TXUI.installer.layout == I.Enum.Layouts.HORIZONTAL, {
            customTexts = customTextSize {
              { "!Name", I.Fonts.Title, 26, "SHADOWOUTLINE" },
              { "!Health", I.Fonts.Primary, 36, "SHADOWOUTLINE" },
              { "!Power", I.Fonts.Primary, 20, "SHADOWOUTLINE" },
              { "!Level", I.Fonts.Primary, 14, "SHADOWOUTLINE" },
              { "!ClassIcon", I.Fonts.Primary, 12, "SHADOWOUTLINE" },
            },
          })
        ),

        raid1 = {
          customTexts = customTextSize {
            { "!Name", F.FontOverride(I.Fonts.Primary), 16, F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE") },
            { "!Group", F.FontOverride(I.Fonts.TitleRaid), 12, F.FontStyleOverride(I.Fonts.TitleRaid, "SHADOWOUTLINE") },
          },

          rdebuffs = {
            font = F.FontOverride(I.Fonts.Primary),
            fontSize = F.FontSizeScaled(14),
            fontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
          },
        },

        raid2 = {
          customTexts = customTextSize {
            { "!Name", F.FontOverride(I.Fonts.Primary), 16, F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE") },
            { "!Group", F.FontOverride(I.Fonts.TitleRaid), 12, F.FontStyleOverride(I.Fonts.TitleRaid, "SHADOWOUTLINE") },
          },

          rdebuffs = {
            font = F.FontOverride(I.Fonts.Primary),
            fontSize = F.FontSizeScaled(14),
            fontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
          },
        },

        raid3 = {
          customTexts = customTextSize {
            { "!Name", F.FontOverride(I.Fonts.Primary), 16, F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE") },
            { "!Group", F.FontOverride(I.Fonts.TitleRaid), 12, F.FontStyleOverride(I.Fonts.TitleRaid, "SHADOWOUTLINE") },
          },

          rdebuffs = {
            font = F.FontOverride(I.Fonts.Primary),
            fontSize = F.FontSizeScaled(14),
            fontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
          },
        },

        tank = {
          customTexts = customTextSize {
            { "!Name", F.FontOverride(I.Fonts.Primary), 16, F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE") },
          },
        },

        assist = {
          customTexts = customTextSize {
            { "!Name", F.FontOverride(I.Fonts.Primary), 16, F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE") },
          },
        },

        arena = {
          customTexts = customTextSize {
            { "!Health", I.Fonts.Primary, 36, "SHADOWOUTLINE" },
            { "!Name", I.Fonts.Title, 24, "SHADOWOUTLINE" },
            { "!Power", I.Fonts.Primary, 20, "SHADOWOUTLINE" },
          },

          buffs = {
            countFont = F.FontOverride(I.Fonts.TitleBlack),
            countFontSize = F.FontSizeScaled(16),
          },

          debuffs = {
            countFont = F.FontOverride(I.Fonts.TitleBlack),
            countFontSize = F.FontSizeScaled(16),
          },
        },

        boss = {
          customTexts = customTextSize {
            { "!Health", I.Fonts.Primary, 36, "SHADOWOUTLINE" },
            { "!HealthSmall", I.Fonts.Primary, 14, "SHADOWOUTLINE" },
            { "!Name", I.Fonts.Title, 24, "SHADOWOUTLINE" },
            { "!Power", I.Fonts.Primary, 20, "SHADOWOUTLINE" },
          },

          buffs = {
            countFont = F.FontOverride(I.Fonts.TitleBlack),
            countFontSize = F.FontSizeScaled(16),
          },

          debuffs = {
            countFont = F.FontOverride(I.Fonts.TitleBlack),
            countFontSize = F.FontSizeScaled(16),
          },
        },
      },
    },

    -- Tooltip
    tooltip = {
      font = F.FontOverride(I.Fonts.Primary),
      fontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
      textFontSize = F.FontSizeScaled(14), -- is fontSize (has old name)

      headerFont = F.FontOverride(I.Fonts.Primary),
      headerFontSize = F.FontSizeScaled(16),
      headerFontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),

      smallTextFontSize = F.FontSizeScaled(14),

      healthBar = {
        font = F.FontOverride(I.Fonts.Primary),
        fontSize = F.FontSizeScaled(16),
        fontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
      },
    },

    -- ActionBar
    actionbar = {
      font = F.FontOverride(I.Fonts.Primary),
      fontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
      fontSize = F.FontSizeScaled(18),

      cooldown = {
        fonts = {
          enable = true,
          font = F.FontOverride(I.Fonts.Primary),
          fontSize = F.FontSizeScaled(16),
          fontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
        },
      },
    },

    -- Cooldowns
    cooldown = {
      fonts = {
        enable = true,
        font = F.FontOverride(I.Fonts.Primary),
        fontSize = F.FontSizeScaled(16),
        fontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
      },
    },
  })

  -- ActionBars Main
  for i = 1, 10 do
    F.Table.Crush(E.db.actionbar["bar" .. i], {
      countFont = F.FontOverride(I.Fonts.Primary),
      countFontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
      countFontSize = F.FontSizeScaled(16),

      hotkeyFont = F.FontOverride(I.Fonts.Primary),
      hotkeyFontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
      hotkeyFontSize = F.FontSizeScaled(16),

      macroFont = F.FontOverride(I.Fonts.Primary),
      macroFontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
      macroFontSize = F.FontSizeScaled(14),
    })
  end

  -- ActionBars Additional
  for _, bar in next, { "barPet", "stanceBar", "vehicleExitButton", "extraActionButton" } do
    local ab = {}

    ab.hotkeyFont = F.FontOverride(I.Fonts.Primary)
    ab.hotkeyFontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE")
    ab.hotkeyFontSize = F.FontSizeScaled(12)

    if bar == "barPet" then
      ab.countFont = F.FontOverride(I.Fonts.Primary)
      ab.countFontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE")
      ab.countFontSize = F.FontSizeScaled(38)
    end

    F.Table.Crush(E.db.actionbar[bar], ab)
  end

  -- WT
  if F.IsAddOnEnabled("ElvUI_WindTools") then
    F.Table.Crush(E.db.WT, {
      social = {
        friendList = {
          infoFont = {
            name = F.FontOverride(I.Fonts.Primary),
            size = F.FontSize(12),
            style = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
          },

          nameFont = {
            name = F.FontOverride(I.Fonts.Primary),
            size = F.FontSize(14),
            style = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
          },
        },
      },
    })
  end

  if F.IsAddOnEnabled("ElvUI_WrathArmory") then
    F.Table.Crush(E.db.wratharmory, {
      character = {
        avgItemLevel = {
          font = F.FontOverride(I.Fonts.TitleBlack),
        },

        enchant = {
          font = F.FontOverride(I.Fonts.Primary),
          fontSize = F.FontSizeScaled(14),
        },

        itemLevel = {
          font = F.FontOverride(I.Fonts.Primary),
          fontSize = F.FontSizeScaled(16),
        },
      },

      inspect = {
        avgItemLevel = {
          font = F.FontOverride(I.Fonts.TitleBlack),
        },

        enchant = {
          font = F.FontOverride(I.Fonts.Primary),
        },

        itemLevel = {
          font = F.FontOverride(I.Fonts.Primary),
        },
      },
    })
  end
end

function PF:ElvUIFontPrivates()
  -- ElvUI
  F.Table.Crush(E.private, {
    general = {
      -- General
      chatBubbleFont = F.FontOverride(I.Fonts.Primary),
      chatBubbleFontSize = F.FontSizeScaled(14),
      chatBubbleFontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),

      -- Blizzard
      dmgfont = F.FontOverride(I.Fonts.TitleBlack),
      namefont = F.FontOverride(I.Fonts.Primary),
    },
  })

  -- WT
  if F.IsAddOnEnabled("ElvUI_WindTools") then
    F.Table.Crush(E.private.WT, {
      maps = {
        instanceDifficulty = {
          name = F.FontOverride(I.Fonts.Primary),
          size = F.FontSizeScaled(19),
          style = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
        },
      },

      skins = {
        errorMessage = {
          size = F.FontSizeScaled(24),
        },
      },

      quest = {
        objectiveTracker = {
          header = {
            name = F.FontOverride(I.Fonts.Title),
            size = F.FontSizeScaled(24),
            style = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
          },

          title = {
            name = F.FontOverride(I.Fonts.Primary),
            size = F.FontSizeScaled(16),
            style = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
          },

          info = {
            name = F.FontOverride(I.Fonts.Primary),
            size = F.FontSizeScaled(14),
            style = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
          },
        },
      },
    })
  end
end

function PF:ApplyFontChange()
  TXUI:GetModule("SplashScreen"):Wrap("Applying fonts ...", function()
    -- Apply font change
    self:ElvUIFont()
    self:ElvUIFontPrivates()

    -- Update ElvUI Media
    E:UpdateMedia()
    E:UpdateFontTemplates()

    -- execute elvui update, callback later
    self:ExecuteElvUIUpdate(function()
      -- Hide Splash
      TXUI:GetModule("SplashScreen"):Hide()

      -- force reload most parts of toxiui
      F.Event.TriggerEvent("TXUI.DatabaseUpdate")
    end, true)
  end, true)
end
