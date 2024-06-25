local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local PF = TXUI:GetModule("Profiles")

local GetRealmName = GetRealmName
local UnitName = UnitName

function PF:BuildBigWigsProfile()
  local pf = {}
  local profileName = I.ProfileNames[E.db.TXUI.installer.layout]

  local width = E.physicalWidth
  local height = E.physicalHeight

  -- Default (2560)
  local Anchor_x = -46
  local EmphasizeAnchor_x = 241
  local Proximity_x = 845

  -- Default (1440)
  local Anchor_y = 400
  local EmphasizeAnchor_y = -110
  local Proximity_y = 155
  local Messages_y = -160
  local Countdown_y = -150

  -- Maybe we could move all of these out to a separate file and just
  -- call a function to get the correct settings based on width/height?
  if width == 3440 then
    Anchor_x = -46
    EmphasizeAnchor_x = 241
    Proximity_x = 1090
  end

  if width == 1920 then
    Anchor_x = -46
    EmphasizeAnchor_x = 241
    Proximity_x = 900
  end

  if height == 1080 then
    Anchor_y = 400
    EmphasizeAnchor_y = -110
    Proximity_y = 240
    Messages_y = -20
    Countdown_y = 100
  end

  F.Table.Crush(pf, {
    ["namespaces"] = {
      ["BigWigs_Plugins_AltPower"] = {
        ["profiles"] = {
          [profileName] = {
            ["additionalWidth"] = 28,
            ["backgroundColor"] = {
              [4] = 0.31,
            },
            ["fontName"] = F.FontOverride(I.Fonts.Primary),
            ["fontSize"] = 14,
            ["position"] = {
              [3] = -392,
              [4] = -392,
            },
          },
        },
      },
      ["BigWigs_Plugins_AutoReply"] = {
        ["profiles"] = {
          [profileName] = {
            ["disabled"] = false,
            ["exitCombat"] = 4,
            ["mode"] = 4,
          },
        },
      },
      ["BigWigs_Plugins_Bars"] = {
        ["profiles"] = {
          [profileName] = {
            ["normalHeight"] = 26,
            ["normalWidth"] = 354,
            ["normalPosition"] = {
              -- Anchor point of the Bar
              "BOTTOMRIGHT",
              -- Anchor point of the screen
              "BOTTOMRIGHT",
              Anchor_x,
              Anchor_y,
            },
            ["expHeight"] = 26,
            ["expWidth"] = 271,
            ["expPosition"] = {
              -- Anchor point of the Bar
              "LEFT",
              -- Anchor point of the screen
              "CENTER",
              EmphasizeAnchor_x,
              EmphasizeAnchor_y,
            },
            ["alignText"] = "RIGHT",
            ["alignTime"] = "LEFT",
            ["barStyle"] = "ElvUI",
            ["emphasizeGrowup"] = true,
            ["emphasizeTime"] = 10,
            ["fill"] = true,
            ["fontName"] = F.FontOverride(I.Fonts.TitleRaid),
            ["fontSize"] = 16,
            ["fontSizeEmph"] = 16,
            ["fontSizeNameplate"] = 12,
            ["growup"] = true,
            ["iconPosition"] = "RIGHT",
            ["outline"] = "OUTLINE",
            ["spacing"] = 5,
            ["texture"] = "- Tx Left",
            ["visibleBarLimit"] = 8,
            ["visibleBarLimitEmph"] = 4,
          },
        },
      },
      ["BigWigs_Plugins_Colors"] = {
        ["profiles"] = {
          [profileName] = {
            ["barColor"] = {
              ["BigWigs_Plugins_Colors"] = {
                ["default"] = {
                  [1] = 0.01,
                  [2] = 0.63,
                  [3] = 0.93,
                },
              },
            },
            ["barEmphasized"] = {
              ["BigWigs_Plugins_Colors"] = {
                ["default"] = {
                  [1] = 0.97,
                  [2] = 0.09,
                  [3] = 0.56,
                },
              },
            },
            ["red"] = {
              ["BigWigs_Plugins_Colors"] = {
                ["default"] = {
                  [1] = 0.7,
                  [2] = 0.14,
                  [3] = 0.14,
                  [4] = 1,
                },
              },
            },
          },
        },
      },
      ["BigWigs_Plugins_Countdown"] = {
        ["profiles"] = {
          [profileName] = {
            ["fontColor"] = {
              ["b"] = 0.3,
            },
            ["fontName"] = F.FontOverride(I.Fonts.TitleBlack),
            ["fontSize"] = 100,
            ["position"] = {
              [1] = "CENTER",
              [2] = "CENTER",
              [4] = Countdown_y,
            },
            ["voice"] = "enUS: Default (Male)",
          },
        },
      },
      ["BigWigs_Plugins_InfoBox"] = {
        ["profiles"] = {
          [profileName] = {
            ["posx"] = 310,
            ["posy"] = 207,
          },
        },
      },
      ["BigWigs_Plugins_Messages"] = {
        ["profiles"] = {
          [profileName] = {
            ["align"] = "RIGHT",
            ["emphFontName"] = F.FontOverride(I.Fonts.TitleRaid),
            ["emphFontSize"] = F.FontSizeScaled(24),
            ["emphPosition"] = {
              "TOP",
              "TOP",
              nil,
              -215,
            },
            ["emphUppercase"] = false,
            ["fontName"] = F.FontOverride(I.Fonts.TitleRaid),
            ["fontSize"] = F.FontSizeScaled(20),
            ["growUpwards"] = true,
            ["normalPosition"] = {
              "CENTER",
              "CENTER",
              -340,
              Messages_y,
            },
            ["outline"] = "OUTLINE",
          },
        },
      },
      ["BigWigs_Plugins_Proximity"] = {
        ["profiles"] = {
          [profileName] = {
            ["fontName"] = F.FontOverride(I.Fonts.Title),
            ["fontSize"] = 24,
            ["objects"] = {
              ["ability"] = false,
              ["close"] = false,
              ["sound"] = false,
            },
            ["posx"] = Proximity_x,
            ["posy"] = Proximity_y,
          },
        },
      },
      ["BigWigs_Plugins_Pull"] = {
        ["profiles"] = {
          [profileName] = {
            ["voice"] = "English: Jim",
          },
        },
      },
      ["BigWigs_Plugins_Wipe"] = {
        ["profiles"] = {
          [profileName] = {
            ["wipeSound"] = "Awww Crap",
          },
        },
      },
    },
  })

  if F.HiDpi() then
    if E.db.TXUI.installer.layout == I.Enum.Layouts.HEALER then -- Move Anchor for Healer layout
      pf["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["expPosition"] = {
        nil,
        nil,
        EmphasizeAnchor_x,
        EmphasizeAnchor_y + 15,
      }
    end
  else
    if E.db.TXUI.installer.layout == I.Enum.Layouts.HEALER then self:LogWarning("Sorry, we don't have a 1080p profile yet for healers") end
  end

  -- Those are not included in the export, change manually if needed
  pf["profiles"] = {}
  pf["profiles"][profileName] = {}
  pf["profiles"][profileName]["showZoneMessages"] = true
  pf["profiles"][profileName]["flash"] = true
  pf["profiles"][profileName]["fakeDBMVersion"] = true

  -- ! Personal change
  if F.DevBuildBigWigsProfile then F.Table.Crush(pf, F.DevBuildBigWigsProfile(pf)) end

  return pf
end

function PF:BigWigs_Private()
  -- Get table name
  local dbName = TXUI.IsRetail and "BigWigs3DB" or "BigWigsClassicDB"

  -- Create Table if they don't exist
  _G[dbName] = _G[dbName] or {}
  _G[dbName].profileKeys = _G[dbName].profileKeys or {}

  -- Create a profile key for the current player
  local name = UnitName("player")
  local realm = GetRealmName()

  -- Set our profile as preffered
  _G[dbName].profileKeys[name .. " - " .. realm] = I.ProfileNames[E.db.TXUI.installer.layout]
end

function PF:MergeBigWigsProfile()
  -- Get table names
  local dbName = TXUI.IsRetail and "BigWigs3DB" or "BigWigsClassicDB"
  local dbIconName = TXUI.IsRetail and "BigWigsIconDB" or "BigWigsIconClassicDB"

  -- Create Tables if they don't exist
  _G[dbName] = _G[dbName] or {}
  _G[dbIconName] = _G[dbIconName] or {}

  -- Build BigWigs Profile
  local pf = self:BuildBigWigsProfile()

  -- Merge Tablee
  F.Table.Crush(_G[dbName], pf)

  -- Hide minimap icon
  _G[dbIconName].hide = true

  -- Create key for character
  self:BigWigs_Private()
end
