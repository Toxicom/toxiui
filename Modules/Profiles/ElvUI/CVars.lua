local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local PF = TXUI:GetModule("Profiles")

local SetCVar = SetCVar

-- copied from E:SetupCVars
function PF:ElvUICVars()
  SetCVar("statusTextDisplay", "BOTH")
  SetCVar("screenshotQuality", 10)
  SetCVar("chatMouseScroll", 1)
  SetCVar("chatStyle", "classic")
  SetCVar("whisperMode", "inline")
  SetCVar("wholeChatWindowClickable", 0)
  SetCVar("showTutorials", 0)
  SetCVar("showNPETutorials", 0)
  SetCVar("UberTooltips", 1)
  SetCVar("threatWarning", 3)
  SetCVar("alwaysShowActionBars", 1)
  SetCVar("lockActionBars", 1)
  SetCVar("ActionButtonUseKeyDown", 1)
  SetCVar("spamFilter", 0)
  SetCVar("cameraDistanceMaxZoomFactor", 2.6)
  SetCVar("showQuestTrackingTooltips", 1)
  SetCVar("fstack_preferParentKeys", 0) -- Add back the frame names via fstack!
  SetCVar("useUiScale", 1)
  SetCVar("uiScale", E.global.general.UIScale)
  SetCVar("autoClearAFK", 1)

  if TXUI.IsRetail then SetCVar("cameraDistanceMaxZoomFactor", 2.6) end
end
