local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local PU = TXUI:NewModule("ProfileUpdater")
local PF = TXUI:GetModule("Profiles")

local next = next
local pairs = pairs
local wipe = wipe
local ipairs = ipairs
local tinsert = tinsert
local sort = sort
local type = type
local tostring = tostring
local tonumber = tonumber
local tconcat = table.concat
local strsplit = strsplit
local abs = math.abs
local CreateFrame = CreateFrame
local C_CVar = C_CVar
local ReloadUI = ReloadUI
local InCombatLockdown = InCombatLockdown

local CANCEL = CANCEL

local POSITION_TOLERANCE = 2 -- pixels

-- Category and item definitions for the checklist
local CATEGORIES = {
  {
    key = "elvui_profile",
    label = "ElvUI Profile Sections",
    items = {
      { key = "general", label = "General", desc = "AFK, minimap, loot roll, alt power bar, custom glow, class colors", hasDiff = true },
      { key = "unitframes", label = "Unit Frames", desc = "Player, target, focus, pet, party, raid, arena, boss frames (layout, sizes, bars, auras, castbars)", hasDiff = true },
      { key = "nameplates", label = "Nameplates", desc = "Enemy/friendly NPC and player nameplates (sizes, castbars, auras, names, health text)", hasDiff = true },
      { key = "actionbars", label = "Action Bars", desc = "All action bars (1-15), pet bar, stance bar (sizes, spacing, visibility)", hasDiff = true },
      { key = "cooldowns", label = "Cooldowns", desc = "Per-module cooldown text overrides (actionbar, auras, nameplates, unitframes)", hasDiff = true },
      { key = "tooltip", label = "Tooltip", desc = "Tooltip appearance, health bar, guild ranks, visibility settings", hasDiff = true },
      { key = "bags", label = "Bags", desc = "Bag/bank sizes, sort direction, vendor/junk settings", hasDiff = true },
      { key = "chat", label = "Chat", desc = "Chat panel sizes, tab styling, timestamps, keyword highlighting", hasDiff = true },
      { key = "auras", label = "Auras", desc = "Buff and debuff display (sizes, growth direction, wrap after)", hasDiff = true },
      { key = "movers", label = "Movers", desc = "All frame positions and anchors (150+ mover entries)", hasDiff = true },
      { key = "colors", label = "Colors", desc = "Unitframe and nameplate colors (health, cast, power, class resources, heal prediction)", hasDiff = true },
    },
  },
  {
    key = "elvui_fonts",
    label = "Fonts",
    items = {
      {
        key = "fonts",
        label = "ElvUI Fonts",
        desc = "All public font settings (general, bags, chat, cooldowns, auras, nameplates, unitframes, tooltip, actionbars). "
          .. F.String.Error("We cannot show the difference for these."),
      },
      {
        key = "font_privates",
        label = "Font Privates",
        desc = "Chat bubble fonts, damage font, nameplate fonts, WindTools fonts. " .. F.String.Error("We cannot show the difference for these."),
      },
    },
  },
  {
    key = "elvui_other",
    label = "Other Settings",
    items = {
      { key = "cvars", label = "CVars", desc = "Console variables (UI scale, camera zoom, action bars, nameplates, chat style)", hasDiff = true },
      { key = "private", label = "Private Profile", desc = "Chat bubbles, textures, nameplate toggle, bags/chat enable, skins", hasDiff = true },
      { key = "global", label = "Global Profile", desc = "UI scale, world map coordinates, AceGUI window size", hasDiff = true },
      { key = "additional", label = "Additional AddOns", desc = "WindTools public settings (raid markers, extra items, contacts, social)", hasDiff = true },
      { key = "additional_private", label = "Additional Private", desc = "WindTools private settings (minimap buttons, skins, widgets, quest tracker)", hasDiff = true },
    },
  },
}

-- Mapping from item key to E.db sub-table path (for main profile sections)
local SECTION_MAP = {
  general = "general",
  unitframes = "unitframe",
  nameplates = "nameplates",
  actionbars = "actionbar",
  cooldowns = "cooldown",
  tooltip = "tooltip",
  bags = "bags",
  chat = "chat",
  auras = "auras",
}

PU.selectedItems = {}
PU.diffs = {}

-- Diff utilities

local function formatValue(val)
  if val == nil then return "|cff888888(none)|r" end
  local valType = type(val)
  if valType == "string" then return "|cffffd100\"" .. val .. "\"|r" end
  if valType == "number" then return "|cffffffff" .. tostring(val) .. "|r" end
  if valType == "boolean" then return val and "|cff66ff66true|r" or "|cffff6666false|r" end
  if valType == "table" then return "|cff888888{table}|r" end
  return tostring(val)
end

local function parseMoverString(str)
  if type(str) ~= "string" then return nil end
  local point, parent, relPoint, x, y = strsplit(",", str)
  return {
    point = point,
    parent = parent,
    relPoint = relPoint,
    x = tonumber(x) or 0,
    y = tonumber(y) or 0,
  }
end

-- Reusable test frame for computing where a profile mover anchor would place a frame
local moverTestFrame

local function isSameScreenPosition(moverName, newVal)
  -- Get the live mover frame and its current center
  local liveFrame = _G[moverName]
  if not liveFrame or not liveFrame.GetCenter then return false end

  local curCX, curCY = liveFrame:GetCenter()
  if not curCX then return false end

  -- Parse the profile's anchor string
  local parsed = parseMoverString(newVal)
  if not parsed then return false end

  -- Resolve parent frame (ElvUIParent, MinimapMover, etc.)
  local parentFrame = _G[parsed.parent]
  if not parentFrame then return false end

  -- Position a test frame using the profile anchor and compare centers
  if not moverTestFrame then
    moverTestFrame = CreateFrame("Frame", nil, E.UIParent)
    moverTestFrame:Hide()
  end

  moverTestFrame:SetSize(liveFrame:GetSize())
  moverTestFrame:ClearAllPoints()
  moverTestFrame:SetPoint(parsed.point, parentFrame, parsed.relPoint, parsed.x, parsed.y)

  local newCX, newCY = moverTestFrame:GetCenter()
  if not newCX then return false end

  return abs(curCX - newCX) < POSITION_TOLERANCE and abs(curCY - newCY) < POSITION_TOLERANCE
end

local function computeMoverDiff(current, new, results, reanchored)
  for k, newVal in pairs(new) do
    local curVal = current and current[k]
    local moverName = tostring(k)

    if curVal ~= newVal then
      if isSameScreenPosition(moverName, newVal) then
        -- Same screen position — ElvUI just normalized the anchor string
        local curParsed = parseMoverString(curVal)
        local newParsed = parseMoverString(newVal)
        tinsert(reanchored, {
          path = moverName,
          old = curVal,
          new = newVal,
          oldParent = curParsed and curParsed.parent or "?",
          newParent = newParsed and newParsed.parent or "?",
        })
      else
        tinsert(results, { path = moverName, old = curVal, new = newVal })
      end
    end
  end
end

local function computeTableDiff(current, new, path, results)
  for k, newVal in pairs(new) do
    local fullPath = path ~= "" and (path .. "." .. tostring(k)) or tostring(k)
    local curVal = current and current[k]

    if type(newVal) == "table" then
      if type(curVal) == "table" then
        computeTableDiff(curVal, newVal, fullPath, results)
      else
        tinsert(results, { path = fullPath, old = curVal, new = newVal })
      end
    elseif type(newVal) == "number" and type(curVal) == "number" then
      if not F.AlmostEqual(curVal, newVal) then tinsert(results, { path = fullPath, old = curVal, new = newVal }) end
    elseif curVal ~= newVal then
      tinsert(results, { path = fullPath, old = curVal, new = newVal })
    end
  end
end

function PU:ComputeAllDiffs()
  wipe(self.diffs)

  local pf = PF:BuildProfile()

  -- Main profile sections
  for key, dbPath in pairs(SECTION_MAP) do
    local entries = {}
    computeTableDiff(E.db[dbPath], pf[dbPath], "", entries)
    sort(entries, function(a, b)
      return a.path < b.path
    end)
    self.diffs[key] = { count = #entries, entries = entries }
  end

  -- Movers (with re-anchor detection)
  local moverEntries = {}
  local moverReanchored = {}
  computeMoverDiff(E.db.movers, pf.movers, moverEntries, moverReanchored)
  sort(moverEntries, function(a, b)
    return a.path < b.path
  end)
  sort(moverReanchored, function(a, b)
    return a.path < b.path
  end)
  self.diffs.movers = { count = #moverEntries, entries = moverEntries, reanchored = moverReanchored }

  -- Colors (from BuildColorsProfile, authoritative source)
  local colors = PF:BuildColorsProfile()
  local colorEntries = {}
  computeTableDiff(E.db.unitframe.colors, colors.unitframe.colors, "unitframe.colors", colorEntries)
  computeTableDiff(E.db.nameplates.colors, colors.nameplates.colors, "nameplates.colors", colorEntries)
  sort(colorEntries, function(a, b)
    return a.path < b.path
  end)
  self.diffs.colors = { count = #colorEntries, entries = colorEntries }

  -- CVars (GetCVarInfo returns strings, so convert expected to string for comparison)
  local cvarsPf = PF:BuildCVarsProfile()
  local cvarsEntries = {}
  for name, expected in pairs(cvarsPf) do
    local current = C_CVar.GetCVarInfo(name)
    if current ~= nil and tostring(current) ~= tostring(expected) then tinsert(cvarsEntries, { path = name, old = current, new = expected }) end
  end
  sort(cvarsEntries, function(a, b)
    return a.path < b.path
  end)
  self.diffs["cvars"] = { count = #cvarsEntries, entries = cvarsEntries }

  -- Private profile
  local privatePf = PF:BuildPrivateProfile()
  local privateEntries = {}
  for k, v in pairs(privatePf) do
    if type(v) == "table" and type(E.private[k]) == "table" then
      computeTableDiff(E.private[k], v, k, privateEntries)
    elseif E.private[k] ~= v then
      tinsert(privateEntries, { path = k, old = E.private[k], new = v })
    end
  end
  sort(privateEntries, function(a, b)
    return a.path < b.path
  end)
  self.diffs["private"] = { count = #privateEntries, entries = privateEntries }

  -- Global profile
  local globalPf = PF:BuildGlobalProfile()
  local globalEntries = {}
  for k, v in pairs(globalPf) do
    if type(v) == "table" and type(E.global[k]) == "table" then
      computeTableDiff(E.global[k], v, k, globalEntries)
    elseif E.global[k] ~= v then
      tinsert(globalEntries, { path = k, old = E.global[k], new = v })
    end
  end
  sort(globalEntries, function(a, b)
    return a.path < b.path
  end)
  self.diffs["global"] = { count = #globalEntries, entries = globalEntries }

  -- Additional AddOns (WindTools public)
  local additionalPf = PF:BuildAdditionalProfile()
  local additionalEntries = {}
  for k, v in pairs(additionalPf) do
    if k ~= "movers" then -- movers handled separately
      if type(v) == "table" and type(E.db[k]) == "table" then
        computeTableDiff(E.db[k], v, k, additionalEntries)
      elseif E.db[k] ~= v then
        tinsert(additionalEntries, { path = k, old = E.db[k], new = v })
      end
    end
  end
  sort(additionalEntries, function(a, b)
    return a.path < b.path
  end)
  self.diffs["additional"] = { count = #additionalEntries, entries = additionalEntries }

  -- Additional Private (WindTools private)
  local additionalPrivatePf = PF:BuildAdditionalPrivateProfile()
  local additionalPrivateEntries = {}
  for k, v in pairs(additionalPrivatePf) do
    if type(v) == "table" and type(E.private[k]) == "table" then
      computeTableDiff(E.private[k], v, k, additionalPrivateEntries)
    elseif E.private[k] ~= v then
      tinsert(additionalPrivateEntries, { path = k, old = E.private[k], new = v })
    end
  end
  sort(additionalPrivateEntries, function(a, b)
    return a.path < b.path
  end)
  self.diffs["additional_private"] = { count = #additionalPrivateEntries, entries = additionalPrivateEntries }
end

function PU:GetDiffForItem(key)
  return self.diffs[key]
end

function PU:BuildDiffText(key)
  local diffData = self.diffs[key]
  if not diffData then return nil end

  local hasChanges = diffData.count > 0
  local reanchored = diffData.reanchored
  local hasReanchored = reanchored and #reanchored > 0

  if not hasChanges and not hasReanchored then return "|cff66ff66No changes detected.|r" end

  local lines = {}

  -- Real changes
  for _, entry in ipairs(diffData.entries) do
    tinsert(lines, "|cffa0a0a0" .. entry.path .. "|r")
    tinsert(lines, "  " .. formatValue(entry.old) .. " |cffffff00->|r " .. formatValue(entry.new))
  end

  -- Re-anchored movers (false positives from ElvUI parent resolution)
  if hasReanchored then
    if hasChanges then tinsert(lines, "") end
    tinsert(lines, "|cff888888--- Re-anchored by ElvUI (" .. #reanchored .. ") ---|r")
    tinsert(lines, "|cff888888These movers originally were anchored to a different frame but ElvUI resolved their parent frame.|r")
    tinsert(lines, "|cff888888Because of that, we cannot be certain if the user moved them from their original position.|r")
    tinsert(lines, "|cff888888They will be re-applied with the original anchor on update.|r")
    tinsert(lines, "")
    for _, entry in ipairs(reanchored) do
      tinsert(lines, "|cff555555" .. entry.path .. "|r")
      tinsert(lines, "  |cff555555" .. (entry.oldParent or "?") .. " -> " .. (entry.newParent or "?") .. "|r")
    end
  end

  return tconcat(lines, "\n")
end

-- Selection state

function PU:GetCategories()
  return CATEGORIES
end

function PU:InitializeSelection()
  wipe(self.selectedItems)

  for _, category in ipairs(CATEGORIES) do
    for _, item in ipairs(category.items) do
      self.selectedItems[item.key] = true
    end
  end
end

function PU:SetItemSelected(key, selected)
  self.selectedItems[key] = selected or nil
end

function PU:SelectAll()
  for _, category in ipairs(CATEGORIES) do
    for _, item in ipairs(category.items) do
      self.selectedItems[item.key] = true
    end
  end
end

function PU:SelectNone()
  wipe(self.selectedItems)
end

function PU:GetSelectedCount()
  local count = 0
  for _ in pairs(self.selectedItems) do
    count = count + 1
  end
  return count
end

function PU:HasAnySelected()
  return next(self.selectedItems) ~= nil
end

-- Apply logic (no SplashScreen — runs synchronously from popup OnAccept hardware event)

function PU:ExecuteSelectedUpdates()
  local pf = PF:BuildProfile()
  local crushFnc = TXUI.DevRelease and F.Table.CrushDebug or F.Table.Crush

  -- Selective merge of main profile sections
  for key, dbPath in pairs(SECTION_MAP) do
    if self.selectedItems[key] then crushFnc(E.db[dbPath], pf[dbPath]) end
  end

  -- Movers need F.ProcessMovers first
  if self.selectedItems.movers then
    F.ProcessMovers(pf)
    crushFnc(E.db.movers, pf.movers)
  end

  -- Colors (separate from unitframes — BuildColorsProfile is authoritative)
  if self.selectedItems.colors then
    local colors = PF:BuildColorsProfile()
    crushFnc(E.db.unitframe.colors, colors.unitframe.colors)
    crushFnc(E.db.nameplates.colors, colors.nameplates.colors)
  end

  -- Standalone profile functions (each does its own Crush internally)
  if self.selectedItems.fonts then PF:ElvUIFont() end
  if self.selectedItems.font_privates then PF:ElvUIFontPrivates() end
  if self.selectedItems.cvars then PF:ElvUICVars() end
  if self.selectedItems.private then PF:ElvUIProfilePrivate() end
  if self.selectedItems.global then PF:ElvUIProfileGlobal() end
  if self.selectedItems.additional then PF:ElvUIAdditional() end
  if self.selectedItems.additional_private then PF:ElvUIAdditionalPrivate() end

  ReloadUI()
end

function PU:ShowConfirmationPopup()
  local count = self:GetSelectedCount()
  local dialogName = "TXUI_PROFILE_UPDATER_CONFIRM"

  E.PopupDialogs[dialogName] = {
    text = TXUI.Title .. " will update " .. F.String.Good(count) .. " profile section(s).\n\n" .. F.String.Warning(
      "This will overwrite current settings for the selected sections."
    ) .. "\n\n" .. F.String.Error("A UI reload will occur after applying."),
    button1 = "Apply & Reload",
    button2 = CANCEL,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = 1,
    OnAccept = function()
      PU:ExecuteSelectedUpdates()
    end,
  }

  E:StaticPopup_Show(dialogName)
end

function PU:Toggle()
  if InCombatLockdown() then
    TXUI:LogInfo("Cannot open Profile Updater during combat.")
    return
  end

  if not F.IsTXUIProfile() then
    TXUI:LogInfo("You are not using a " .. TXUI.Title .. " profile.")
    return
  end

  if not E.db.TXUI.installer.layout then
    TXUI:LogInfo("Layout not set. Please run the " .. TXUI.Title .. " installer first.")
    return
  end

  if not self.frame then
    self:InitializeSelection()
    self:ComputeAllDiffs()
    self:CreateUpdaterFrame()
  else
    self:InitializeSelection()
    self:ComputeAllDiffs()
    self:UpdateCheckboxLabels()
    self:UpdateCheckboxStates()
    self:UpdateApplyButton()
  end

  if self.frame:IsShown() then
    self.frame:Hide()
  else
    self.frame:Show()
    self.frame:Raise()
  end
end

function PU:Initialize()
  if self.Initialized then return end
  self.Initialized = true
end

TXUI:RegisterModule(PU:GetName())
