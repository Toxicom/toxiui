local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local PF = TXUI:GetModule("Profiles")

local SetCVar = SetCVar
local pairs = pairs

-- copied from E:SetupCVars
function PF:BuildCVarsProfile()
  local cvars = {
    statusTextDisplay = "BOTH",
    screenshotQuality = 10,
    chatMouseScroll = 1,
    chatStyle = "classic",
    whisperMode = "inline",
    wholeChatWindowClickable = 0,
    showTutorials = 0,
    showNPETutorials = 0,
    UberTooltips = 1,
    threatWarning = 3,
    alwaysShowActionBars = 1,
    lockActionBars = 1,
    ActionButtonUseKeyDown = 1,
    spamFilter = 0,
    cameraDistanceMaxZoomFactor = TXUI.IsRetail and 2.6 or 4,
    showQuestTrackingTooltips = 1,
    fstack_preferParentKeys = 0, -- Add back the frame names via fstack!
    useUiScale = 1,
    uiScale = E.global.general.UIScale,
    autoClearAFK = 1,
    nameplateSelectedScale = 1.5,
  }

  return cvars
end

function PF:ElvUICVars()
  local cvars = self:BuildCVarsProfile()
  for name, value in pairs(cvars) do
    SetCVar(name, value)
  end
end
