local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local PF = TXUI:GetModule("Profiles")

local next = next
local ipairs = ipairs
local unpack = unpack

local function customTextSize(args)
  local ret = {}
  for _, v in ipairs(args) do
    local name, font, size, outline = unpack(v)
    ret[name] = {
      font = F.FontOverride(font),
      size = F.FontSizeScaled(size),
      fontOutline = F.FontStyleOverride(font, outline),
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
      fontStyle = F.FontStyleOverride(I.Fonts.Primary, ""),

      itemLevel = {
        itemLevelFont = F.FontOverride(I.Fonts.PrimaryBold),
        itemLevelFontSize = F.FontSize(11),
        itemLevelFontOutline = F.FontStyleOverride(I.Fonts.Primary, ""),
      },

      altPowerBar = {
        font = F.FontOverride(I.Fonts.Title),
        fontSize = F.FontSizeScaled(18),
        fontOutline = F.FontStyleOverride(I.Fonts.Title, ""),
      },

      minimap = {
        locationFont = F.FontOverride(I.Fonts.Title),
        locationFontSize = F.FontSizeScaled(22),
        locationFontOutline = F.FontStyleOverride(I.Fonts.Title, ""),

        icons = {
          queueStatus = {
            font = F.FontOverride(I.Fonts.Primary),
            fontSize = F.FontSizeScaled(12),
            fontOutline = F.FontStyleOverride(I.Fonts.Primary, "OUTLINE"),
          },
        },
      },

      lootRoll = {
        nameFont = F.FontOverride(I.Fonts.Primary),
        nameFontSize = F.FontSizeScaled(14),
        nameFontOutline = F.FontStyleOverride(I.Fonts.Primary, "OUTLINE"),
      },

      totems = {
        font = F.FontOverride(I.Fonts.Primary),
        fontSize = F.FontSizeScaled(14),
        fontOutline = F.FontStyleOverride(I.Fonts.Primary, "OUTLINE"),
      },
    },

    -- Bags
    bags = {
      itemLevelFont = F.FontOverride(I.Fonts.Number),
      itemLevelFontSize = F.FontSizeScaled(22),
      itemLevelFontOutline = F.FontStyleOverride(I.Fonts.Number, "OUTLINE"),

      itemInfoFont = F.FontOverride(I.Fonts.Number),
      itemInfoFontSize = F.FontSizeScaled(26),
      itemInfoFontOutline = F.FontStyleOverride(I.Fonts.Number, "OUTLINE"),

      countFont = F.FontOverride(I.Fonts.Number),
      countFontSize = F.FontSizeScaled(26),
      countFontOutline = F.FontStyleOverride(I.Fonts.Number, "OUTLINE"),

      cooldown = {
        fonts = {
          enable = true,
          font = F.FontOverride(I.Fonts.Number),
          fontSize = F.FontSizeScaled(20),
          fontOutline = F.FontStyleOverride(I.Fonts.Number, "OUTLINE"),
        },
      },

      bagBar = {
        font = F.FontOverride(I.Fonts.Primary),
        fontSize = F.FontSizeScaled(14),
        fontOutline = F.FontStyleOverride(I.Fonts.Number, "OUTLINE"),
      },
    },

    -- Chat
    chat = {
      font = F.FontOverride(I.Fonts.Primary),
      fontOutline = F.FontStyleOverride(I.Fonts.Primary, ""),

      tabFont = F.FontOverride(I.Fonts.Title),
      tabFontSize = F.FontSizeScaled(14, 13),
      tabFontOutline = F.FontStyleOverride(I.Fonts.Title, ""),
    },

    -- Auras
    auras = {
      -- Buffs
      buffs = {
        countFont = F.FontOverride(I.Fonts.Number),
        countFontSize = F.FontSizeScaled(26),
        countFontOutline = F.FontStyleOverride(I.Fonts.Number, "OUTLINE"),

        timeFont = F.FontOverride(I.Fonts.Title),
        timeFontSize = F.FontSizeScaled(22),
        timeFontOutline = F.FontStyleOverride(I.Fonts.Number, ""),
      },

      -- Debuffs
      debuffs = {
        countFont = F.FontOverride(I.Fonts.Number),
        countFontSize = F.FontSizeScaled(26),
        countFontOutline = F.FontStyleOverride(I.Fonts.Number, "OUTLINE"),

        timeFont = F.FontOverride(I.Fonts.Title),
        timeFontSize = F.FontSizeScaled(22),
        timeFontOutline = F.FontStyleOverride(I.Fonts.Number, ""),
      },
    },

    unitframe = {
      font = F.FontOverride(I.Fonts.Title),
      fontSize = F.FontSizeScaled(20),
      fontOutline = F.FontStyleOverride(I.Fonts.Title, ""),

      cooldown = {
        fonts = {
          enable = true,
          font = F.FontOverride(I.Fonts.Number),
          fontSize = F.FontSizeScaled(28),
          fontOutline = F.FontStyleOverride(I.Fonts.Number, "OUTLINE"),
        },
      },

      units = {
        player = {
          customTexts = customTextSize {
            { "!Name", I.Fonts.Title, 26, "NONE" },
            { "!Health", I.Fonts.Number, 22, "NONE" },
          },

          buffs = {
            countFont = F.FontOverride(I.Fonts.Title),
            countFontSize = F.FontSizeScaled(22),
          },

          debuffs = {
            countFont = F.FontOverride(I.Fonts.Title),
            countFontSize = F.FontSizeScaled(22),
          },

          castbar = {
            customTextFont = {
              enable = true,
              font = F.FontOverride(I.Fonts.Title),
              fontSize = F.FontSizeScaled(22),
              fontStyle = F.FontStyleOverride(I.Fonts.Title, ""),
            },

            customTimeFont = {
              enable = true,
              font = F.FontOverride(I.Fonts.Title),
              fontSize = F.FontSizeScaled(22),
              fontStyle = F.FontStyleOverride(I.Fonts.Title, ""),
            },
          },
        },

        target = {
          customTexts = customTextSize {
            { "!Name", I.Fonts.Title, 26, "NONE" },
            { "!Health", I.Fonts.Number, 22, "NONE" },
          },

          buffs = {
            countFont = F.FontOverride(I.Fonts.Title),
            countFontSize = F.FontSizeScaled(22),
          },

          debuffs = {
            countFont = F.FontOverride(I.Fonts.Title),
            countFontSize = F.FontSizeScaled(22),
          },

          castbar = {
            customTextFont = {
              enable = true,
              font = F.FontOverride(I.Fonts.Title),
              fontSize = F.FontSizeScaled(22),
              fontStyle = F.FontStyleOverride(I.Fonts.Title, ""),
            },

            customTimeFont = {
              enable = true,
              font = F.FontOverride(I.Fonts.Title),
              fontSize = F.FontSizeScaled(22),
              fontStyle = F.FontStyleOverride(I.Fonts.Title, ""),
            },
          },
        },

        pet = {
          customTexts = customTextSize { { "!Name", I.Fonts.Title, 16, "NONE" } },
        },

        targettarget = {
          customTexts = customTextSize { { "!Name", I.Fonts.Title, 16, "NONE" } },
        },

        focus = {
          customTexts = customTextSize {
            { "!Name", I.Fonts.Title, 26, "NONE" },
            { "!Health", I.Fonts.Number, 22, "NONE" },
          },

          buffs = {
            countFont = F.FontOverride(I.Fonts.Title),
            countFontSize = F.FontSizeScaled(22),
          },

          debuffs = {
            countFont = F.FontOverride(I.Fonts.Title),
            countFontSize = F.FontSizeScaled(22),
          },

          castbar = {
            customTextFont = {
              enable = true,
              font = F.FontOverride(I.Fonts.Title),
              fontSize = F.FontSizeScaled(22),
              fontStyle = F.FontStyleOverride(I.Fonts.Title, ""),
            },

            customTimeFont = {
              enable = true,
              font = F.FontOverride(I.Fonts.Title),
              fontSize = F.FontSizeScaled(22),
              fontStyle = F.FontStyleOverride(I.Fonts.Title, ""),
            },
          },
        },

        party = F.Table.Join(
          {
            customTexts = customTextSize {
              { "!Name", I.Fonts.Title, 26, "NONE" },
              { "!Health", I.Fonts.Number, 24, "NONE" },
            },

            buffs = {
              countFont = F.FontOverride(I.Fonts.Number),
              countFontSize = F.FontSizeScaled(18),
            },

            debuffs = {
              countFont = F.FontOverride(I.Fonts.Number),
              countFontSize = F.FontSizeScaled(18),
            },

            rdebuffs = {
              font = F.FontOverride(I.Fonts.Number),
              fontSize = F.FontSizeScaled(18),
              fontOutline = F.FontStyleOverride(I.Fonts.Title, ""),
            },
          },
          F.Table.If(E.db.TXUI.installer.layout == I.Enum.Layouts.HEALER, {
            customTexts = customTextSize { { "!Name", I.Fonts.Title, 26, "NONE" }, { "!Health", I.Fonts.Number, 32, "NONE" } },
          })
        ),

        raid1 = {
          customTexts = customTextSize { { "!Name", I.Fonts.Title, 16, "OUTLINE" } },

          rdebuffs = {
            font = F.FontOverride(I.Fonts.Title),
            fontSize = F.FontSizeScaled(16),
            fontOutline = F.FontStyleOverride(I.Fonts.Title, ""),
          },
        },

        raid2 = {
          customTexts = customTextSize { { "!Name", I.Fonts.Title, 16, "OUTLINE" } },

          rdebuffs = {
            font = F.FontOverride(I.Fonts.Title),
            fontSize = F.FontSizeScaled(16),
            fontOutline = F.FontStyleOverride(I.Fonts.Title, ""),
          },
        },

        raid3 = {
          customTexts = customTextSize { { "!Name", I.Fonts.Title, 16, "OUTLINE" } },

          rdebuffs = {
            font = F.FontOverride(I.Fonts.Title),
            fontSize = F.FontSizeScaled(16),
            fontOutline = F.FontStyleOverride(I.Fonts.Title, ""),
          },
        },

        arena = {
          customTexts = customTextSize {
            { "!Health", I.Fonts.Number, 20, "NONE" },
            { "!Name", I.Fonts.Title, 24, "NONE" },
            { "!Power", I.Fonts.Number, 20, "OUTLINE" },
          },

          buffs = {
            countFont = F.FontOverride(I.Fonts.Number),
            countFontSize = F.FontSizeScaled(22),
          },

          debuffs = {
            countFont = F.FontOverride(I.Fonts.Number),
            countFontSize = F.FontSizeScaled(22),
          },
        },

        boss = {
          customTexts = customTextSize {
            { "!Health", I.Fonts.Number, 24, "NONE" },
            { "!Name", I.Fonts.Title, 24, "NONE" },
            { "!Power", I.Fonts.Number, 20, "OUTLINE" },
          },

          buffs = {
            countFont = F.FontOverride(I.Fonts.Number),
            countFontSize = F.FontSizeScaled(22),
          },

          debuffs = {
            countFont = F.FontOverride(I.Fonts.Number),
            countFontSize = F.FontSizeScaled(22),
          },
        },
      },
    },

    -- Tooltip
    tooltip = {
      font = F.FontOverride(I.Fonts.Primary),
      fontOutline = F.FontStyleOverride(I.Fonts.Primary, ""),
      textFontSize = F.FontSizeScaled(14), -- is fontSize (has old name)

      headerFont = F.FontOverride(I.Fonts.Primary),
      headerFontSize = F.FontSizeScaled(16),
      headerFontOutline = F.FontStyleOverride(I.Fonts.Primary, ""),

      smallTextFontSize = F.FontSizeScaled(14),

      healthBar = {
        font = F.FontOverride(I.Fonts.Title),
        fontSize = F.FontSizeScaled(20),
        fontOutline = F.FontStyleOverride(I.Fonts.Title, "OUTLINE"),
      },
    },

    -- ActionBar
    actionbar = {
      font = F.FontOverride(I.Fonts.Title),
      fontOutline = F.FontStyleOverride(I.Fonts.Title, "OUTLINE"),
      fontSize = F.FontSizeScaled(18),

      cooldown = {
        fonts = {
          enable = true,
          font = F.FontOverride(I.Fonts.Number),
          fontSize = F.FontSizeScaled(20),
          fontOutline = F.FontStyleOverride(I.Fonts.Number, "OUTLINE"),
        },
      },
    },

    -- Cooldowns
    cooldown = {
      fonts = {
        enable = true,
        font = F.FontOverride(I.Fonts.Number),
        fontSize = F.FontSizeScaled(22),
        fontOutline = F.FontStyleOverride(I.Fonts.Number, "OUTLINE"),
      },
    },
  })

  -- ActionBars Main
  for i = 1, 10 do
    F.Table.Crush(E.db.actionbar["bar" .. i], {
      countFont = F.FontOverride(I.Fonts.Title),
      countFontOutline = F.FontStyleOverride(I.Fonts.Title, "OUTLINE"),
      countFontSize = F.FontSizeScaled(19),

      hotkeyFont = F.FontOverride(I.Fonts.Title),
      hotkeyFontOutline = F.FontStyleOverride(I.Fonts.Title, "OUTLINE"),
      hotkeyFontSize = F.FontSizeScaled(19),

      macroFont = F.FontOverride(I.Fonts.Title),
      macroFontOutline = F.FontStyleOverride(I.Fonts.Title, "OUTLINE"),
      macroFontSize = F.FontSizeScaled(14),
    })
  end

  -- ActionBars Additional
  for _, bar in next, { "barPet", "stanceBar", "vehicleExitButton", "extraActionButton" } do
    local ab = {}

    ab.hotkeyFont = F.FontOverride(I.Fonts.Title)
    ab.hotkeyFontOutline = F.FontStyleOverride(I.Fonts.Title, "OUTLINE")
    ab.hotkeyFontSize = F.FontSizeScaled(18)

    if bar == "barPet" then
      ab.countFont = F.FontOverride(I.Fonts.Title)
      ab.countFontOutline = F.FontStyleOverride(I.Fonts.Title, "OUTLINE")
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
            style = F.FontStyleOverride(I.Fonts.Primary, ""),
          },

          nameFont = {
            name = F.FontOverride(I.Fonts.Primary),
            size = F.FontSize(14),
            style = F.FontStyleOverride(I.Fonts.Primary, ""),
          },
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
      chatBubbleFontOutline = F.FontStyleOverride(I.Fonts.Primary, ""),

      -- Blizzard
      dmgfont = F.FontOverride(I.Fonts.BigNumber),
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
          style = F.FontStyleOverride(I.Fonts.Primary, ""),
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
            style = F.FontStyleOverride(I.Fonts.Primary, ""),
          },

          title = {
            name = F.FontOverride(I.Fonts.Primary),
            size = F.FontSizeScaled(17),
            style = F.FontStyleOverride(I.Fonts.Primary, ""),
          },

          info = {
            name = F.FontOverride(I.Fonts.Primary),
            size = F.FontSizeScaled(14),
            style = F.FontStyleOverride(I.Fonts.Primary, ""),
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
