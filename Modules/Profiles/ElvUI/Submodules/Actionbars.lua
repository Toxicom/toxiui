local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local PF = TXUI:GetModule("Profiles")

-- ActionBar Base Template
local actionbarTemplate = {
  point = "TOPLEFT",
  inheritGlobalFade = true,

  backdrop = false,
  keepSizeRatio = false,
  mouseover = false,

  buttons = 12,
  buttonSize = F.Dpi(36), -- Width
  buttonHeight = F.Dpi(24),
  buttonsPerRow = 12,
  buttonSpacing = F.Dpi(4),

  hotkeytext = true,
  hotkeyTextPosition = "TOPRIGHT",
  hotkeyTextYOffset = F.Dpi(0),
}

local createActionBar = function(...)
  local tbl = F.Table.Join({}, actionbarTemplate, ...)

  if not tbl.visibility then
    if TXUI.IsRetail then
      tbl.visibility = "[vehicleui][petbattle][overridebar] hide; show"
    elseif TXUI.IsClassic then
      tbl.visibility = "[vehicleui][overridebar] hide; show"
    else
      tbl.visibility = "[overridebar] hide; show"
    end
  end

  return tbl
end

-- Main Action Bar Template
local mainActionBarTemplate = {
  showGrid = true,

  counttext = true,
  countTextPosition = "BOTTOMLEFT",

  macrotext = true,
  macroTextPosition = "BOTTOM",
  macroTextYOffset = F.Dpi(0),

  visibility = TXUI.IsRetail and "[petbattle] hide; show" or "show",
}

local createMainActionBar = function(...)
  return F.Table.Join({}, actionbarTemplate, mainActionBarTemplate, ...)
end

function PF:ApplyActionbars(pf)
  -- ActionBars General
  F.Table.Crush(pf.actionbar, {
    transparent = true,
    globalFadeAlpha = 1,
    flyoutSize = F.Dpi(40),
    countTextYOffset = F.Dpi(0),

    cooldown = {
      checkSeconds = true,
      hhmmThreshold = -1,
      mmssThreshold = 180,
    },

    extraActionButton = {
      scale = F.DpiRaw(1.25),
    },

    zoneActionButton = {
      scale = F.DpiRaw(1.25),
    },

    -- Classic Totem Bar
    totemBar = TXUI.IsClassic and {
      mouseover = true,
      keepSizeRatio = false,
      flyoutDirection = "UP",

      buttonSize = F.Dpi(36), -- Width
      buttonHeight = F.Dpi(24),

      flyoutSize = F.Dpi(36), -- Width
      flyoutHeight = F.Dpi(24),

      spacing = F.Dpi(1),
      flyoutSpacing = F.Dpi(1),
    } or nil,
  })

  -- ActionBar Bars
  pf.actionbar.bar1 = createMainActionBar {
    enabled = true,
  }

  pf.actionbar.bar2 = createMainActionBar {
    enabled = false,
  }

  pf.actionbar.bar3 = createMainActionBar {
    enabled = true,
    buttonsPerRow = 4,
  }

  pf.actionbar.bar4 = createMainActionBar {
    enabled = true,
    buttonsPerRow = 4,
  }

  pf.actionbar.bar5 = createMainActionBar {
    enabled = true,
  }

  pf.actionbar.bar6 = createMainActionBar {
    enabled = true,
  }

  pf.actionbar.bar7 = createMainActionBar { enabled = false }
  pf.actionbar.bar8 = createMainActionBar { enabled = false }
  pf.actionbar.bar9 = createMainActionBar { enabled = false }
  pf.actionbar.bar10 = createMainActionBar { enabled = false }
  pf.actionbar.bar13 = createMainActionBar { enabled = false }
  pf.actionbar.bar14 = createMainActionBar { enabled = false }
  pf.actionbar.bar15 = createMainActionBar { enabled = false }

  -- ActionBar Pet Bar
  pf.actionbar.barPet = createActionBar {
    mouseover = true,
    backdrop = false,
    backdropSpacing = F.Dpi(1),

    buttonSize = F.Dpi(30),
    buttonHeight = F.Dpi(20),
    buttonSpacing = F.Dpi(1),
    buttonsPerRow = 10,

    counttext = true,
    countTextPosition = "BOTTOMLEFT",

    hotkeyTextPosition = "TOPLEFT",
    hotkeyTextXOffset = F.Dpi(2),
    hotkeyTextYOffset = F.Dpi(-2),
  }

  -- ActionBar Stance Bar
  pf.actionbar.stanceBar = createActionBar {
    alpha = 0.8,
    mouseover = true,
    buttonSize = F.Dpi(32),
    inheritGlobalFade = true,
    hotkeyTextPosition = "TOP",
  }

  -- Visibility per game version
  if TXUI.IsRetail then
    pf.actionbar.barPet.visibility = "[petbattle] hide; [novehicleui,pet,nooverridebar,nopossessbar] show; hide"
    pf.actionbar.stanceBar.visibility = "[vehicleui][petbattle] hide; show"
  elseif TXUI.IsClassic then
    pf.actionbar.barPet.visibility = "[novehicleui,pet,nooverridebar,nopossessbar] show; hide"
    pf.actionbar.stanceBar.visibility = "[vehicleui] hide; show"
  else
    pf.actionbar.barPet.visibility = "[pet,nooverridebar] show; hide"
    pf.actionbar.stanceBar.visibility = "show"
  end

  pf.actionbar.convertPages = false -- just don't !
end
