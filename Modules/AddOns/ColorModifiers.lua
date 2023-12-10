local TXUI, F, E, I, V, P, G, L = unpack((select(2, ...)))
local CM = TXUI:NewModule("ColorModifiers")

function CM:Enable()
  local colorHex = I.PriestColors.colorStr
  if E.myclass ~= "PRIEST" then colorHex = string.sub(E:ClassColor(E.myclass, true).colorStr, 3) end

  -- Overwrite localized strings with colors
  L["KEY_SHIFT"] = "|cff" .. colorHex .. L["KEY_SHIFT"] .. "|r"
  L["KEY_CTRL"] = "|cff" .. colorHex .. L["KEY_CTRL"] .. "|r"
  L["KEY_ALT"] = "|cff" .. colorHex .. L["KEY_ALT"] .. "|r"
  L["KEY_NUMPAD"] = "|cff" .. colorHex .. L["KEY_NUMPAD"] .. "|r"
  L["KEY_MOUSEBUTTON"] = "|cff" .. colorHex .. L["KEY_MOUSEBUTTON"] .. "|r"
end

function CM:DatabaseUpdate()
  self.db = F.GetDBFromPath("TXUI.addons.colorModifiers")

  if TXUI:HasRequirements(I.Requirements.ColorModifiers) and (self.db and self.db.enabled) and E.private.actionbar.enable then self:Enable() end
end

function CM:Initialize()
  if self.Initialized then return end

  -- Register for updates
  F.Event.RegisterOnceCallback("TXUI.InitializedSafe", F.Event.GenerateClosure(self.DatabaseUpdate, self))
  F.Event.RegisterCallback("TXUI.DatabaseUpdate", self.DatabaseUpdate, self)

  -- We are done, hooray!
  self.Initialized = true
end

TXUI:RegisterModule(CM:GetName())
