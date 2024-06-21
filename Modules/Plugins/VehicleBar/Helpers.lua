local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local VB = TXUI:GetModule("VehicleBar")

local C_UnitAuras = C_UnitAuras
local format = string.format

function VB:IsVigorAvailable()
  return TXUI.IsRetail and IsMounted() and HasBonusActionBar()
end

function VB:GetWidgetInfo()
  local widgetSetID = C_UIWidgetManager.GetPowerBarWidgetSetID()
  local widgets = C_UIWidgetManager.GetAllWidgetsBySetID(widgetSetID)

  local widgetInfo = nil
  for _, w in pairs(widgets) do
    local tempInfo = C_UIWidgetManager.GetFillUpFramesWidgetVisualizationInfo(w.widgetID)
    if tempInfo and tempInfo.shownState == 1 then widgetInfo = tempInfo end
  end

  return widgetInfo
end

function VB:FormatKeybind(keybind)
  local modifier, key = keybind:match("^(%w)-(.+)$")
  if modifier and key then
    if E.db.TXUI.addons.colorModifiers.enabled then
      local color = E:ClassColor(E.myclass, true)
      local r, g, b = color.r, color.g, color.b
      return format("|cff%02x%02x%02x%s|r%s", r * 255, g * 255, b * 255, modifier:upper(), key)
    else
      return modifier:upper() .. key
    end
  else
    return keybind
  end
end

function VB:ColorSpeedText(msg)
  local thrillActive = C_UnitAuras.GetPlayerAuraBySpellID(377234)
  if thrillActive then
    local r, g, b = self.db.thrillColor.r, self.db.thrillColor.g, self.db.thrillColor.b

    return F.String.Color(msg, F.String.FastRGB(r, g, b))
  else
    return msg
  end
end
