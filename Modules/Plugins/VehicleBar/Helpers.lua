local TXUI, F, E = unpack((select(2, ...)))
local VB = TXUI:GetModule("VehicleBar")

local C_UnitAuras = C_UnitAuras
local C_UIWidgetManager = C_UIWidgetManager
local format = string.format

function VB:IsVigorAvailable()
  if F.IsSkyriding() then
    return true
  else
    return false
  end
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
    local r, g, b = self.vdb.thrillColor.r, self.vdb.thrillColor.g, self.vdb.thrillColor.b

    return F.String.Color(msg, F.String.FastRGB(r, g, b))
  else
    return msg
  end
end
