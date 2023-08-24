local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local PF = TXUI:GetModule("Profiles")

local _G = _G

function PF:BuildWarpDepleteProfile()
  local pf = {}

  F.Table.Crush(pf, {
    alignBossClear = "end",

    -- Bars
    barPadding = 4,

    bar1Font = F.FontOverride(I.Fonts.Primary),
    bar1Texture = "- Tx Left",
    bar1TextureColor = "ff00e5f6",

    bar2Font = F.FontOverride(I.Fonts.Primary),
    bar2Texture = "- Tx Left",
    bar2TextureColor = "ff00e5f6",

    bar3Font = F.FontOverride(I.Fonts.Primary),
    bar3Texture = "- Tx Left",
    bar3TextureColor = "ff00e5f6",

    -- Objective text color
    completedObjectivesColor = "ff00ff9e",
    timingsImprovedTimeColor = "ff00e5f6",

    -- Deaths
    deathsFont = "- ToxiUI",
    deathsColor = "ffbc0049",
    deathsFontSize = F.Dpi(12),

    -- Forces
    forcesFont = "- ToxiUI",
    forcesTexture = "- Tx Left",
    forcesTextureColor = "ffbc9f23",
    forcesOverlayTexture = "- Tx Left",

    -- Frame
    frameX = F.Dpi(0),
    frameY = F.Dpi(120),

    -- Key
    keyFont = F.FontOverride(I.Fonts.TitleRaid),
    keyDetailsFont = "- ToxiUI",
    keyColor = "ffffb35f",
    keyDetailsColor = "ff4487b2",

    -- Timer
    timerFont = F.FontOverride(I.Fonts.TitleRaid),

    -- Objectives
    objectivesFont = "- ToxiUI",
    objectivesFontSize = F.Dpi(12),
  })

  return pf
end

function PF:ApplyWarpDepleteProfile()
  if not F.IsAddOnEnabled("WarpDeplete") then
    TXUI:LogWarning("WarpDeplete is not enabled. Will not apply profile.")
    return
  end

  local db = _G.WarpDeplete.db.profiles
  if not db then
    TXUI:LogWarning("No database found for WarpDeplete -- will not apply profile.")
    return
  end

  local profileName = I.ProfileNames.Default
  local profile = PF:BuildWarpDepleteProfile() or {}

  _G.WarpDeplete.db:ResetProfile(profileName)
  db[profileName] = db[profileName] or {}
  F.Table.Crush(db[profileName], profile)
  _G.WarpDeplete.db:SetProfile(profileName)

  TXUI:LogInfo("WarpDeplete profile successfully installed and applied. Please reload your UI!")
end
