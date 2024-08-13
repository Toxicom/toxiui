local TXUI, F, E, I, V, P, G, L = unpack((select(2, ...)))
local CM = TXUI:NewModule("ColorModifiers")
local AB = E:GetModule("ActionBars")

local sub = string.utf8sub
local len = strlenutf8

local function colorizeKey(text, colorHex)
  if #text > 1 then
    local baseText = sub(text, 1, len(text) - 1)
    local lastChar = sub(text, -1)
    local coloredText = "|cff" .. colorHex .. baseText .. "|r" .. lastChar
    return coloredText
  else
    return text
  end
end

function CM:ColorKeybinds(button)
  local text = button.HotKey:GetText()
  local colorHex = sub(E:ClassColor(E.myclass, true).colorStr, 3)

  if text and text ~= _G.RANGE_INDICATOR and len(text) > 1 then
    text = colorizeKey(text, colorHex)
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
