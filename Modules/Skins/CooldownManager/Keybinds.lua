local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local CM = TXUI:GetModule("CooldownManager")
local ColorMod = TXUI:GetModule("ColorModifiers")

local _G = _G
local format = format
local ipairs = ipairs
local pairs = pairs
local GetActionInfo = GetActionInfo
local GetMacroSpell = GetMacroSpell
local GetBindingKey = GetBindingKey
local C_Spell = C_Spell
local C_CooldownViewer = C_CooldownViewer
local CreateFrame = CreateFrame

local NUM_ELVUI_BARS = 15

local keybindKeys = { "essential", "utility" }

local function HideViewerKeybinds(viewer)
  if not viewer then return end
  for _, child in ipairs { viewer:GetChildren() } do
    if child.txKeybind then child.txKeybind:Hide() end
  end
end

function CM:ScanElvUIBindings()
  local result = {}

  for bar = 1, NUM_ELVUI_BARS do
    if bar ~= 11 and bar ~= 12 then
      for slot = 1, 12 do
        local btn = _G["ElvUI_Bar" .. bar .. "Button" .. slot]
        if btn and btn.action and btn.config then
          local binding = GetBindingKey(btn.config.keyBoundTarget)
          if binding then
            local actionType, id, subType = GetActionInfo(btn.action)
            local spellID

            if actionType == "spell" then
              spellID = id
            elseif actionType == "macro" then
              if subType == "spell" then
                spellID = id
              else
                spellID = GetMacroSpell(id)
              end
            end

            if spellID and not result[spellID] then result[spellID] = ColorMod:FormatKeybind(binding) end
          end
        end
      end
    end
  end

  return result
end

function CM:ResolveSpellBinding(spellID, bindingMap)
  if not spellID or spellID == 0 then return nil end

  if bindingMap[spellID] then return bindingMap[spellID] end

  -- Check override spell (e.g. talent-replaced abilities)
  local override = C_Spell.GetOverrideSpell(spellID)
  if override and bindingMap[override] then return bindingMap[override] end

  -- Check base spell
  local base = C_Spell.GetBaseSpell(spellID)
  if base and bindingMap[base] then return bindingMap[base] end

  return nil
end

local function GetKeybind(icon)
  if icon.txKeybind then return icon.txKeybind end

  local keybind = CreateFrame("Frame", nil, icon)
  keybind:SetFrameLevel(icon:GetFrameLevel() + 1)
  keybind:SetAllPoints(icon)

  local text = keybind:CreateFontString(nil, "OVERLAY")
  text:SetTextColor(1, 1, 1, 1)

  keybind.text = text
  icon.txKeybind = keybind

  return keybind
end

local function StyleKeybind(keybind, db)
  local text = keybind.text
  text:ClearAllPoints()
  text:SetPoint(db.anchor, keybind:GetParent(), db.anchor, db.xOffset, db.yOffset)
  F.SetFontFromDB(db, "label", text, false)
end

function CM:RefreshViewerKeybinds(settingKey, bindingMap)
  local viewerName = self.frameNames[settingKey]
  local viewer = viewerName and _G[viewerName]
  if not viewer then
    TXUI:LogDebug(format("[Keybinds] %s: viewer not found (%s)", settingKey, tostring(viewerName)))
    return
  end

  local kdb = self.db.keybinds
  if not kdb or not kdb[settingKey] or not kdb[settingKey].enabled then
    TXUI:LogDebug(format("[Keybinds] %s: disabled in DB", settingKey))
    HideViewerKeybinds(viewer)
    return
  end

  local viewerDB = kdb[settingKey]
  bindingMap = bindingMap or self:ScanElvUIBindings()
  local children = { viewer:GetChildren() }

  local bindingCount = 0
  for _ in pairs(bindingMap) do
    bindingCount = bindingCount + 1
  end

  TXUI:LogDebug(format("[Keybinds] %s: %d children, %d bindings in map", settingKey, #children, bindingCount))

  local matched, noIcon, noCooldownID, noInfo, noBinding = 0, 0, 0, 0, 0

  for _, child in ipairs(children) do
    if not child.Icon then
      noIcon = noIcon + 1
    elseif not child.cooldownID then
      noCooldownID = noCooldownID + 1
    else
      local info = C_CooldownViewer.GetCooldownViewerCooldownInfo(child.cooldownID)
      local text

      if info then
        text = self:ResolveSpellBinding(info.spellID, bindingMap)
        if not text and info.overrideSpellID then text = self:ResolveSpellBinding(info.overrideSpellID, bindingMap) end
        if not text then noBinding = noBinding + 1 end
      else
        noInfo = noInfo + 1
      end

      if text then
        matched = matched + 1
        local keybind = GetKeybind(child)
        StyleKeybind(keybind, viewerDB)
        keybind.text:SetText(text)
        keybind:Show()
      elseif child.txKeybind then
        child.txKeybind:Hide()
      end
    end
  end

  TXUI:LogDebug(format("[Keybinds] %s: matched=%d, noIcon=%d, noCooldownID=%d, noInfo=%d, noBinding=%d", settingKey, matched, noIcon, noCooldownID, noInfo, noBinding))
end

function CM:RefreshAllKeybinds()
  local bindingMap = self:ScanElvUIBindings()
  for _, key in ipairs(keybindKeys) do
    self:RefreshViewerKeybinds(key, bindingMap)
  end
end

do
  local delayCallback
  function CM:OnKeybindEvent()
    if not delayCallback then delayCallback = function()
      if self.keybindsActive then self:RefreshAllKeybinds() end
    end end

    -- Small delay to let the game state settle after spec/binding changes
    E:Delay(0.1, delayCallback)
  end
end

function CM:EnableKeybinds()
  if self.keybindsActive or not E.private.actionbar.enable then return end
  self.keybindsActive = true

  F.Event.RegisterFrameEventAndCallback("UPDATE_BINDINGS", self.OnKeybindEvent, self)
  F.Event.RegisterFrameEventAndCallback("PLAYER_SPECIALIZATION_CHANGED", self.OnKeybindEvent, self)
  F.Event.RegisterFrameEventAndCallback("PLAYER_TALENT_UPDATE", self.OnKeybindEvent, self)
  F.Event.RegisterFrameEventAndCallback("ACTIONBAR_HIDEGRID", self.OnKeybindEvent, self)
  F.Event.RegisterFrameEventAndCallback("ACTIONBAR_PAGE_CHANGED", self.OnKeybindEvent, self)
  F.Event.RegisterFrameEventAndCallback("UPDATE_BONUS_ACTIONBAR", self.OnKeybindEvent, self)

  for _, key in ipairs(keybindKeys) do
    local viewerName = self.frameNames[key]
    local viewer = viewerName and _G[viewerName]
    if viewer and not self:IsHooked(viewer, "RefreshLayout") then
      self:SecureHook(viewer, "RefreshLayout", function()
        if self.keybindsActive then self:RefreshViewerKeybinds(key) end
      end)
    end
  end

  -- Initial refresh with retry — cooldownIDs may not be assigned yet on reload
  local retries = 0
  local retryRefresh
  retryRefresh = function()
    if not self.keybindsActive then return end

    local hasCooldownIDs = false
    for _, key in ipairs(keybindKeys) do
      local viewer = _G[self.frameNames[key]]
      if viewer then
        for _, child in ipairs { viewer:GetChildren() } do
          if child.Icon and child.cooldownID then
            hasCooldownIDs = true
            break
          end
        end
      end
      if hasCooldownIDs then break end
    end

    if hasCooldownIDs then
      TXUI:LogDebug(format("[Keybinds] Initial refresh (attempt %d)", retries + 1))
      self:RefreshAllKeybinds()
    elseif retries < 10 then
      retries = retries + 1
      TXUI:LogDebug(format("[Keybinds] No cooldownIDs yet, retry %d", retries))
      E:Delay(0.5, retryRefresh)
    else
      TXUI:LogDebug("[Keybinds] Gave up waiting for cooldownIDs")
    end
  end
  retryRefresh()
end

function CM:DisableKeybinds()
  if not self.keybindsActive then return end
  self.keybindsActive = false

  F.Event.UnregisterFrameEventAndCallback("UPDATE_BINDINGS", self)
  F.Event.UnregisterFrameEventAndCallback("PLAYER_SPECIALIZATION_CHANGED", self)
  F.Event.UnregisterFrameEventAndCallback("PLAYER_TALENT_UPDATE", self)
  F.Event.UnregisterFrameEventAndCallback("ACTIONBAR_HIDEGRID", self)
  F.Event.UnregisterFrameEventAndCallback("ACTIONBAR_PAGE_CHANGED", self)
  F.Event.UnregisterFrameEventAndCallback("UPDATE_BONUS_ACTIONBAR", self)

  -- Hide all keybinds
  for _, key in ipairs(keybindKeys) do
    HideViewerKeybinds(_G[self.frameNames[key]])
  end
end
