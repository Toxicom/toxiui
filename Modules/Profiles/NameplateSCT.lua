local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local PF = TXUI:GetModule("Profiles")

local _G = _G
local SetCVar = SetCVar

function PF:BuildNameplateSCTProfile()
  local pf = {}

  -- Most values here are default NSCT values
  -- Except for those marked as "Custom"
  F.Table.Crush(pf, {
    animations = {
      ability = "rainfall", -- Custom
      animationspeed = 1,
      autoattack = "rainfall", -- Custom
      autoattackcrit = "verticalUp",
      crit = "verticalUp",
      miss = "verticalUp",
    },

    animationsPersonal = {
      crit = "verticalUp",
      miss = "verticalUp",
      normal = "rainfall",
    },

    commaSeparate = true,
    damageColor = true,
    damageColorPersonal = false,
    defaultColor = "ffff00", -- #ffff00
    defaultColorPersonal = "ff0000", -- #ff0000
    enableMSQ = true,
    enabled = true,
    filter = "",
    filterEnabled = false,
    font = F.FontOverride(I.Fonts.TitleRaid), -- Custom
    fontFlag = "OUTLINE",
    fontShadow = false,

    formatting = {
      alpha = 1,
      size = F.FontSizeScaled(28), -- Custom
    },

    iconPosition = "RIGHT",
    iconScale = 1,
    modOffTargetStrata = false,
    npcFilter = "",

    offTargetFormatting = {
      alpha = 0.5,
      size = 15,
    },

    personalOnly = false,
    shouldDisplayOverkill = false,
    showIcon = true,

    sizing = {
      autoattackcritsizing = true,
      crits = true,
      critsScale = 2, -- Custom
      miss = false,
      missScale = 1.5,
      smallHits = true,
      smallHitsHide = true, -- Custom
      smallHitsScale = 0.66,
    },

    strata = {
      offTarget = "BACKGROUND", -- Custom
      target = "BACKGROUND", -- Custom
    },

    truncate = true,
    truncateLetter = true,
    useOffTarget = true,

    xOffset = 0,
    xOffsetIcon = 0,
    xOffsetPersonal = 0,

    yOffset = 0,
    yOffsetIcon = 0,
    yOffsetPersonal = -100,
  })

  return pf
end

function PF:ApplyNameplateSCTProfile()
  if not F.IsAddOnEnabled("NameplateSCT") then
    TXUI:LogWarning("NameplateSCT is not enabled. Will not apply profile.")
    return
  end

  local db = _G.NameplateSCTDB
  if not db then
    TXUI:LogWarning("No database found for NameplateSCT -- will not apply profile.")
    return
  end

  local profile = PF:BuildNameplateSCTProfile() or {}

  F.Table.Crush(db.global, profile)
  -- Disable Blizzard SCT
  SetCVar("floatingCombatTextCombatDamage", 0)

  TXUI:LogInfo(F.String.ToxiUI("NameplateSCT") .. " profile successfully installed and applied. Please reload your UI!")
end
