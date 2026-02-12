local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local PF = TXUI:GetModule("Profiles")

local chat = {
  hideCopyButton = true,
  hideVoiceButtons = true,
  inactivityTimer = 15,
  keywords = "ElvUI, %MYNAME%, Toxi, ToxiUI",
  timeStampFormat = "%H:%M ",
  emotionIcons = false,
  numScrollMessages = 1,
  scrollDownInterval = 120,

  tabSelector = "NONE",
  tabSelectedTextColor = F.Table.CurrentClassColor(),

  -- Panels
  separateSizes = true,
  panelTabBackdrop = true,
  panelBackdrop = "HIDEBOTH",
  panelHeight = 200,
  panelHeightRight = 200,
  panelWidth = 450,
  panelWidthRight = 450,
  panelColor = F.Table.RGB(0, 0, 0, 0),

  -- Time Color
  useCustomTimeColor = true,
  customTimeColor = I.Strings.Branding.ColorRGB,
}

function PF:ApplyChat(pf)
  F.Table.Crush(pf.chat, chat)
end
