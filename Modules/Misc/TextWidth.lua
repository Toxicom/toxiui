local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local TW = TXUI:NewModule("TextWidth", "AceHook-3.0")

local find = string.find
local next = next

--[[
  Max width for unit frame Custom Texts and the nameplate Name text.

  In instances some units (mostly enemies) have secret names, which tags can't abbreviate.
  A fixed width with word wrap off makes the game cut the text off with "...", which works on secret
  strings too. 0 = no limit (ElvUI's default behavior).

  Settings live in E.db.TXUI.textWidth, the sliders are injected into ElvUI's own options
  (Modules/Options/ElvUITextWidth.lua). Only applies on a ToxiUI profile.
]]

-- Applies or clears the width, only touching the FontString when the value changed
local function ApplyWidth(object, width, justifyH)
  if not object then return end

  if width and width > 0 then
    if object.__txWidth == width and object.__txJustify == justifyH then return end
    object.__txWidth = width
    object.__txJustify = justifyH

    object:SetWordWrap(false)
    object:SetWidth(width)
    if justifyH then object:SetJustifyH(justifyH) end
  elseif object.__txWidth then
    object.__txWidth = nil
    object.__txJustify = nil

    object:SetWidth(0)
    object:SetWordWrap(true)
  end
end

function TW:IsActive()
  return self.db ~= nil and F.IsTXUIProfile()
end

-- Unit Frames: Custom Texts
function TW:GetUnitFrameWidth(unit, textName)
  local units = self.db and self.db.unitframes
  local texts = units and units[unit]
  return texts and texts[textName] or 0
end

function TW:ConfigureCustomTexts(_, frame)
  local customTexts = frame and frame.customTexts
  if not customTexts or not next(customTexts) then return end

  local active = self:IsActive()
  local unit = frame.unitframeType

  -- Custom texts are anchored by their justifyH point, so ElvUI's justify already lines up with the fixed width
  for textName, object in next, customTexts do
    ApplyWidth(object, active and unit and self:GetUnitFrameWidth(unit, textName) or 0)
  end
end

-- Re-applies one unit's custom texts, same frames ElvUI's options update (UpdateCustomTextGroup)
function TW:UpdateUnitFrame(unit)
  local UF = E:GetModule("UnitFrames")

  local function update(frame)
    if frame and frame.customTexts then UF:Configure_CustomTexts(frame) end
  end

  if unit == "party" or find(unit, "raid") then
    local header = UF[unit]
    if not header then return end

    for _, child in next, { header:GetChildren() } do
      for _, subchild in next, { child:GetChildren() } do
        update(subchild)
      end
    end
  elseif unit == "boss" or unit == "arena" then
    for i = 1, 10 do
      update(UF[unit .. i])
    end
  else
    update(UF[unit])
  end
end

-- Nameplates: Name text
-- Only enemy plates get a max width, other names aren't secret so they're never limited
-- (also ignores widths saved for other plates by older versions)
local limitedNameplates = {
  ENEMY_PLAYER = true,
  ENEMY_NPC = true,
}

local function GetJustify(position)
  if not position then return "CENTER" end
  if find(position, "LEFT") then return "LEFT" end
  if find(position, "RIGHT") then return "RIGHT" end
  return "CENTER"
end

function TW:UpdateNameplateTags(np, nameplate)
  local name = nameplate and nameplate.Name
  if not name then return end

  local width = 0
  local frameType = nameplate.frameType
  if frameType and limitedNameplates[frameType] and self:IsActive() then
    local nameplates = self.db.nameplates
    width = nameplates and nameplates[frameType] or 0
  end

  if width > 0 then
    local db = np:PlateDB(nameplate)
    -- Name only mode forces the Name to the plate's CENTER (NP:DisablePlate), ignoring the position setting
    ApplyWidth(name, width, db.nameOnly and "CENTER" or GetJustify(db.name and db.name.position))
  else
    ApplyWidth(name, 0)
  end
end

function TW:UpdateNameplates()
  local NP = E:GetModule("NamePlates")
  if NP.Initialized then NP:ConfigureAll() end
end

function TW:DatabaseUpdate()
  self.db = F.GetDBFromPath("TXUI.textWidth")
end

function TW:Initialize()
  -- Don't init second time
  if self.Initialized then return end

  self:DatabaseUpdate()

  -- Hooks stay on, IsActive is checked inside so profile switches clear the widths again
  local UF = E:GetModule("UnitFrames")
  self:SecureHook(UF, "Configure_CustomTexts", "ConfigureCustomTexts")

  local NP = E:GetModule("NamePlates")
  self:SecureHook(NP, "Update_Tags", "UpdateNameplateTags")

  -- Register for updates
  F.Event.RegisterCallback("TXUI.DatabaseUpdate", self.DatabaseUpdate, self)

  -- We are done, hooray!
  self.Initialized = true
end

TXUI:RegisterModule(TW:GetName())
