local TXUI, F, E, I, V, P, G, L = unpack((select(2, ...)))
local CM = TXUI:NewModule("ColorModifiers")
local AB = E:GetModule("ActionBars")

local sub = string.utf8sub
local len = strlenutf8

function CM:ColorizeKey(text, colorHex)
  if len(text) > 1 then
    local baseText, lastChar

    -- Check if the last characters are digits
    local lastDigitMatch = text:match("(%d+)$")

    if lastDigitMatch and len(lastDigitMatch) > 1 then
      -- If there is more than one digit, treat all digits as lastChar
      baseText = sub(text, 1, len(text) - #lastDigitMatch)
      lastChar = lastDigitMatch
    else
      -- Otherwise, the last character is just the last character
      baseText = sub(text, 1, len(text) - 1)
      lastChar = sub(text, -1)
    end

    -- Colorize the baseText, leave lastChar as is
    local coloredText = "|cff" .. colorHex .. baseText .. "|r" .. lastChar
    return coloredText
  else
    return text
  end
end

function CM:ColorKeybinds(button)
  local text = button.HotKey:GetText()
  local colorHex = sub(E:ClassColor(E.myclass, true).colorStr, 3)

  -- Set keybind width same as button
  button.HotKey:Width(button:GetWidth())

  if text and text ~= _G.RANGE_INDICATOR and len(text) > 1 then
    text = CM:ColorizeKey(text, colorHex)
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
