local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local PF = TXUI:GetModule("Profiles")

local _G = _G

function PF:BuildOmniCDProfile()
  local pf = {}

  F.Table.Crush(pf, {
    Party = {
      party = {
        extraBars = {
          raidBar0 = {
            truncateStatusBarName = 10,
            textOfsX = 4,
            scale = 0.7,
            statusBarWidth = 200,
            manualPos = {
              raidBar0 = {
                y = F.Dpi(185),
                x = F.Dpi(395),
              },
            },
          },
        },
        icons = {
          scale = 0.85,
        },
        position = {
          paddingX = 1,
          attach = "TOPLEFT",
          preset = "TOPLEFT",
          offsetX = F.Dpi(50),
          anchor = "TOPRIGHT",
        },
      },
    },
    General = {
      fonts = {
        statusBar = {
          font = F.FontOverride(I.Fonts.Primary),
          flag = I.Font,
        },
        icon = {
          font = F.FontOverride(I.Fonts.Primary),
        },
        anchor = {
          font = F.FontOverride(I.Fonts.Primary),
          flag = "OUTLINE",
        },
      },
      textures = {
        statusBar = {
          BG = "- Tx Left",
          bar = "- Tx Left",
        },
      },
    },
  })

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
