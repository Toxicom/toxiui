local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")

local hooksecurefunc = hooksecurefunc
local next = next
local setmetatable = setmetatable
local type = type

--[[
  "Max Width" sliders for Modules/Misc/TextWidth.lua, added into ElvUI's own options so they sit next to
  the related ElvUI settings instead of a separate ToxiUI section:
    - Nameplates > [unit] > Name
    - UnitFrames > [unit] > Custom Texts > [text]

  ElvUI creates custom text option groups with a local function (on options load, profile change via
  C:RefreshCustomTexts, and when a text is created), so the sliders are re-added after each of those.
]]

local SLIDER_KEY = "txuiMaxWidth"

-- Inputs already wrapped. Kept outside the option tables, AceConfig rejects unknown keys on them
local hookedInputs = setmetatable({}, { __mode = "k" })

local nameplateGroups = {
  playerGroup = "PLAYER",
  friendlyPlayerGroup = "FRIENDLY_PLAYER",
  enemyPlayerGroup = "ENEMY_PLAYER",
  friendlyNPCGroup = "FRIENDLY_NPC",
  enemyNPCGroup = "ENEMY_NPC",
}

local function IsHidden()
  return not F.IsTXUIProfile()
end

local function GetDB()
  return E.db.TXUI and E.db.TXUI.textWidth
end

local function GetModule()
  return TXUI:GetModule("TextWidth", true)
end

local function CreateSlider(order, get, set)
  return {
    order = order,
    type = "range",
    name = "Max Width",
    desc = "Limits how wide the text can be, longer text is cut off with '...'.\n\n" .. F.String.Silver(
      "Useful for names that can't be shortened by tags, like secret enemy names in instances."
    ) .. "\n\n" .. F.String.Silver("0 = no limit. Added by ") .. TXUI.Title .. F.String.Silver("."),
    min = 0,
    max = 500,
    step = 1,
    get = get,
    set = set,
    hidden = IsHidden,
  }
end

function O:AddElvUINameplateTextWidth(options)
  local nameplates = options.args.nameplates
  if not nameplates or not nameplates.args then return end

  for groupKey, frameType in next, nameplateGroups do
    local nameGroup = nameplates.args[groupKey] and nameplates.args[groupKey].args and nameplates.args[groupKey].args.nameGroup
    if nameGroup and nameGroup.args then
      -- Between Y-Offset (5) and Text Format (6)
      nameGroup.args[SLIDER_KEY] = CreateSlider(5.5, function()
        local db = GetDB()
        return db and db.nameplates and db.nameplates[frameType] or 0
      end, function(_, value)
        local db = GetDB()
        if not db then return end

        db.nameplates[frameType] = value

        local module = GetModule()
        if module then module:UpdateNameplates() end
      end)
    end
  end
end

-- Adds the slider to every custom text group that doesn't have it yet
local function AddCustomTextSliders()
  local unitframe = E.Options.args.unitframe
  if not unitframe or not unitframe.args then return end

  for _, unitGroup in next, { "individualUnits", "groupUnits" } do
    local units = unitframe.args[unitGroup] and unitframe.args[unitGroup].args
    if units then
      for unit, unitOptions in next, units do
        local tags = type(unitOptions) == "table" and unitOptions.args and unitOptions.args.customTexts and unitOptions.args.customTexts.args.tags
        if tags and tags.args then
          for textName, textGroup in next, tags.args do
            if type(textGroup) == "table" and textGroup.args and not textGroup.args[SLIDER_KEY] then
              -- After Attach Text To (9), before Text Format (100)
              textGroup.args[SLIDER_KEY] = CreateSlider(10, function()
                local db = GetDB()
                local texts = db and db.unitframes and db.unitframes[unit]
                return texts and texts[textName] or 0
              end, function(_, value)
                local db = GetDB()
                if not db then return end

                if not db.unitframes[unit] then db.unitframes[unit] = {} end
                -- Store 0 instead of nil, nil would fall back to a profile default for this text
                db.unitframes[unit][textName] = value

                local module = GetModule()
                if module then module:UpdateUnitFrame(unit) end
              end)
            end
          end
        end
      end
    end
  end
end

-- New custom texts are created from the "Create Custom Text" input, wrap it to add the slider afterwards
local function HookCreateCustomText()
  local unitframe = E.Options.args.unitframe
  if not unitframe or not unitframe.args then return end

  for _, unitGroup in next, { "individualUnits", "groupUnits" } do
    local units = unitframe.args[unitGroup] and unitframe.args[unitGroup].args
    if units then
      for _, unitOptions in next, units do
        local input = type(unitOptions) == "table" and unitOptions.args and unitOptions.args.customTexts and unitOptions.args.customTexts.args.createCustomText
        if input and type(input.set) == "function" and not hookedInputs[input] then
          local originalSet = input.set
          input.set = function(...)
            originalSet(...)
            AddCustomTextSliders()
          end
          hookedInputs[input] = true
        end
      end
    end
  end
end

function O:AddElvUICustomTextWidth()
  AddCustomTextSliders()
  HookCreateCustomText()

  -- Profile changes rebuild the custom text groups
  local C = E.Config and E.Config[1]
  if C and C.RefreshCustomTexts and not self.customTextRefreshHooked then
    hooksecurefunc(C, "RefreshCustomTexts", AddCustomTextSliders)
    self.customTextRefreshHooked = true
  end
end

function O:AddElvUITextWidthOptions()
  local options = E.Options
  if not options or not options.args then return end

  self:AddElvUINameplateTextWidth(options)
  self:AddElvUICustomTextWidth()
end
