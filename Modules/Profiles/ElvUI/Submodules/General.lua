local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local PF = TXUI:GetModule("Profiles")

local general = {
  -- AFK Mode
  afk = true,
  gameMenuScale = 0.8,

  -- Options
  autoRepair = "PLAYER",
  bottomPanel = false,
  resurrectSound = true,
  stickyFrames = false,
  talkingHeadFrameBackdrop = true,
  talkingHeadFrameScale = F.DpiRaw(1),

  -- Quest Tracker
  objectiveFrameAutoHide = false,
  objectiveFrameAutoHideInKeystone = false,
  objectiveFrameHeight = F.Dpi(600),

  -- Colors
  valuecolor = F.Table.CurrentClassColor(),
  backdropcolor = F.Table.HexToRGB("#1a1a1a"),
  backdropfadecolor = F.Table.HexToRGB("#292929CC"),
  bordercolor = F.Table.HexToRGB("#000000"),

  -- MiniMap
  minimap = {
    size = F.Dpi(276),

    icons = {
      lfgEye = {
        xOffset = F.Dpi(0),
        scale = 0.8,
      },

      mail = {
        xOffset = F.Dpi(0),
        yOffset = F.Dpi(0),
      },
    },
  },

  queueStatus = {
    xOffset = 0,
    yOffset = 0,
  },

  -- Loot Roll
  lootRoll = {
    statusBarTexture = F.ChooseForGradient("- ToxiUI", "- Tx Right"),
    buttonSize = 30,
    leftButtons = true,
  },

  -- AltPowerBar
  altPowerBar = {
    statusBar = "- ToxiUI",
  },

  -- AddOn Compartment
  addonCompartment = {
    size = 24,
  },

  -- Custom Glow
  customGlow = {
    style = "Pixel Glow",
    color = { r = 0.95, g = 0.95, b = 0, a = 0.9 },
    startAnimation = true,
    useColor = false,
    duration = 1,
    speed = 0.3,
    lines = 8,
    size = 1,
  },

  classColors = {
    ["SHAMAN"] = F.Table.HexToRGB("#006edb"),
  },
}

function PF:ApplyGeneral(pf)
  F.Table.Crush(pf.general, general)
end
