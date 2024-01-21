local TXUI, F, E, I, V, P, G, L = unpack((select(2, ...)))
local CM = TXUI:NewModule("ColorModifiers")
local AB = E:GetModule("ActionBars")

local find = string.find
local gsub = string.gsub
local sub = string.sub

local function colorizeKey(text, key, colorHex)
  local coloredKey = "|cff" .. colorHex .. key .. "|r"

  -- Check if the key is already colored
  if not find(text, coloredKey, 1, true) then
    -- Escape key if it contains any Lua pattern special characters
    local escapedKey = key:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
    local newText = gsub(text, escapedKey, coloredKey)
    return newText
  end
  return text
end

-- Define a list of keys that you want to colorize
local keysToColorize = {
  "KEY_SHIFT",
  "KEY_ALT",
  "KEY_CTRL",
  "KEY_META",
  "KEY_MOUSEBUTTON",
  "KEY_MOUSEWHEELUP",
  "KEY_MOUSEWHEELDOWN",
  "KEY_NUMPAD",
  "KEY_PAGEUP",
  "KEY_PAGEDOWN",
  "KEY_SPACE",
  "KEY_INSERT",
  "KEY_HOME",
  "KEY_DELETE",
  "KEY_NDIVIDE",
  "KEY_NMULTIPLY",
  "KEY_NMINUS",
  "KEY_NPLUS",
  "KEY_NEQUALS",
}

-- Heavily modified version of AB:FixKeybindText from ElvUI
function CM:ColorKeybinds(button)
  local text = button.HotKey:GetText()
  local colorHex = I.PriestColors.colorStr
  if E.myclass ~= "PRIEST" then colorHex = sub(E:ClassColor(E.myclass, true).colorStr, 3) end

  if text and text ~= _G.RANGE_INDICATOR then
    -- Only process the keys specified in keysToColorize
    for _, keyName in ipairs(keysToColorize) do
      local keyValue = L[keyName]
      if keyValue and type(keyValue) == "string" then text = colorizeKey(text, keyValue, colorHex) end
    end

    button.HotKey:SetText(text)
  end
end

function CM:Enable()
  if self.isHooked then return end
  hooksecurefunc(AB, "FixKeybindText", CM.ColorKeybinds)
  AB:UpdateButtonSettings()
  self.isHooked = true
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
