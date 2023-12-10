local TXUI, F, E, I, V, P, G, L = unpack((select(2, ...)))
local CM = TXUI:NewModule("ColorModifiers")

-- function CM:Initialize()
if TXUI:HasRequirements(I.Requirements.ColorModifiers) then
  -- E.db.TXUI.addons.colorModifiers is nil when calling not inside CM:Initialize()
  -- but if calling inside CM:Initialize() then the L strings do not get overwritten
  -- doesn't matter if I use F.GetDBFromPath or just straight up E.db.TXUI

  -- if F.GetDBFromPath("TXUI.addons.colorModifiers") then
  local colorHex
  if E.myclass == "PRIEST" then
    colorHex = I.PriestColors.colorStr
  else
    colorHex = string.sub(E:ClassColor(E.myclass, true).colorStr, 3)
  end

  -- Overwrite localized strings with colors
  L["KEY_SHIFT"] = "|cff" .. colorHex .. L["KEY_SHIFT"] .. "|r"
  L["KEY_CTRL"] = "|cff" .. colorHex .. L["KEY_CTRL"] .. "|r"
  L["KEY_ALT"] = "|cff" .. colorHex .. L["KEY_ALT"] .. "|r"
  L["KEY_NUMPAD"] = "|cff" .. colorHex .. L["KEY_NUMPAD"] .. "|r"
  L["KEY_MOUSEBUTTON"] = "|cff" .. colorHex .. L["KEY_MOUSEBUTTON"] .. "|r"
  -- end
end
-- end

TXUI:RegisterModule(CM:GetName())
