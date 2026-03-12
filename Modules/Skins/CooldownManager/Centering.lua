local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local CM = TXUI:GetModule("CooldownManager")

local _G = _G
local ipairs = ipairs
local sort = table.sort
local floor = math.floor
local ceil = math.ceil
local min = math.min
local max = math.max
local wipe = wipe

local centeringKeys = { "essential", "utility", "buff" }

-- Reusable table to avoid garbage per CenterViewer call
local shownBuffer = {}

-- Cached viewer frames and layout properties (populated on enable, refreshed on settings change)
local viewerCache = {}

local function sortByLayoutIndex(a, b)
  return (a.layoutIndex or 0) < (b.layoutIndex or 0)
end

local function cacheViewerProps(viewerKey)
  local viewerName = CM.frameNames[viewerKey]
  local viewer = viewerName and _G[viewerName]
  if not viewer then return nil end

  viewerCache[viewerKey] = {
    viewer = viewer,
    orientationSetting = viewer.orientationSetting,
    stride = viewer.stride,
    xSpacing = viewer.childXPadding or 4,
    ySpacing = viewer.childYPadding or 4,
  }

  return viewerCache[viewerKey]
end

function CM:CenterViewer(viewerKey)
  if self._centeringIcons then return end
  if self._inEditMode then return end

  local cache = viewerCache[viewerKey]
  if not cache then return end
  if cache.orientationSetting == 1 then return end -- skip vertical viewers

  local viewer = cache.viewer
  local children = { viewer:GetChildren() }

  wipe(shownBuffer)
  for _, child in ipairs(children) do
    if child.Icon and child:IsShown() then shownBuffer[#shownBuffer + 1] = child end
  end

  local count = #shownBuffer
  if count == 0 then return end

  if count > 1 then sort(shownBuffer, sortByLayoutIndex) end

  local iconWidth = floor(shownBuffer[1]:GetWidth() + 0.5)
  local iconHeight = floor(shownBuffer[1]:GetHeight() + 0.5)
  if iconWidth <= 0 or iconHeight <= 0 then return end

  local xSpacing = cache.xSpacing
  local ySpacing = cache.ySpacing
  local viewerWidth = floor(viewer:GetWidth() + 0.5)

  local step = iconWidth + xSpacing
  -- Ensure stride is sane; fall back to calculated value and clamp to at least 1
  local stride = tonumber(cache.stride)
  if not stride or stride < 1 then stride = floor((viewerWidth + xSpacing) / step) end
  local maxPerRow = max(1, stride)
  local rows = ceil(count / maxPerRow)

  self._centeringIcons = true

  for row = 1, rows do
    local startIndex = (row - 1) * maxPerRow + 1
    local endIndex = min(row * maxPerRow, count)
    local rowCount = endIndex - startIndex + 1

    local rowWidth = rowCount * iconWidth + (rowCount - 1) * xSpacing
    local startX = -(rowWidth - iconWidth) / 2
    local yPos = -((row - 1) * (iconHeight + ySpacing))

    for i = 0, rowCount - 1 do
      local icon = shownBuffer[startIndex + i]
      if icon then
        if icon.DebuffBorder then icon.DebuffBorder:SetAlpha(0) end

        icon:ClearAllPoints()
        icon:SetPoint("TOP", viewer, "TOP", startX + i * step, yPos)
      end
    end
  end

  self._centeringIcons = false
end

function CM:AlignBuffBarViewer()
  if self._centeringIcons then return end
  if self._inEditMode then return end

  local cache = viewerCache["buffBar"]
  if not cache then return end

  local viewer = cache.viewer
  local children = { viewer:GetChildren() }

  wipe(shownBuffer)
  for _, child in ipairs(children) do
    if child:IsShown() and child:GetHeight() > 1 then shownBuffer[#shownBuffer + 1] = child end
  end

  local count = #shownBuffer
  if count == 0 then return end

  if count > 1 then sort(shownBuffer, sortByLayoutIndex) end

  local barHeight = floor(shownBuffer[1]:GetHeight() + 0.5)
  if barHeight <= 0 then return end

  local ySpacing = cache.ySpacing

  self._centeringIcons = true

  for i = 0, count - 1 do
    local bar = shownBuffer[i + 1]
    if bar then
      local yPos = i * (barHeight + ySpacing)
      bar:ClearAllPoints()
      bar:SetHeight(barHeight)
      bar:SetPoint("BOTTOMLEFT", viewer, "BOTTOMLEFT", 0, yPos)
      bar:SetPoint("BOTTOMRIGHT", viewer, "BOTTOMRIGHT", 0, yPos)
    end
  end

  self._centeringIcons = false
end

function CM:CenterAllViewers()
  if not self.centeringActive then return end

  for _, key in ipairs(centeringKeys) do
    if self.db.centering[key] then self:CenterViewer(key) end
  end
  if self.db.centering.buffBar then self:AlignBuffBarViewer() end
end

function CM:HookBuffBarVisibility(viewer)
  local children = { viewer:GetChildren() }
  for _, child in ipairs(children) do
    if not child._txBuffBarHooked then
      child._txBuffBarHooked = true
      self:SecureHookScript(child, "OnShow", function()
        if self.centeringActive and self.db.centering.buffBar then self:AlignBuffBarViewer() end
      end)
      self:SecureHookScript(child, "OnHide", function()
        if self.centeringActive and self.db.centering.buffBar then self:AlignBuffBarViewer() end
      end)
    end
  end
end

function CM:HookIconVisibility(viewer, viewerKey)
  local children = { viewer:GetChildren() }
  for _, child in ipairs(children) do
    if child.Icon and not child._txCenterHooked then
      child._txCenterHooked = true
      self:SecureHookScript(child, "OnShow", function()
        if self.centeringActive and self.db.centering[viewerKey] then self:CenterViewer(viewerKey) end
      end)
      self:SecureHookScript(child, "OnHide", function()
        if self.centeringActive and self.db.centering[viewerKey] then self:CenterViewer(viewerKey) end
      end)
    end
  end
end

function CM:EnableCentering()
  if not self.Initialized then return end
  self.centeringActive = true

  for _, key in ipairs(centeringKeys) do
    if self.db.centering[key] then
      local cache = cacheViewerProps(key)
      if not cache then return end

      local viewer = cache.viewer

      -- Hook RefreshLayout to re-center after Blizzard re-layouts icons
      -- Also hooks any new icon children and refreshes cached layout properties
      if not self:IsHooked(viewer, "RefreshLayout") then
        self:SecureHook(viewer, "RefreshLayout", function()
          if self.centeringActive and self.db.centering[key] then
            cacheViewerProps(key)
            self:HookIconVisibility(viewer, key)
            E:Delay(0, function()
              self:CenterViewer(key)
            end)
          end
        end)
      end

      -- Hook OnSizeChanged to catch icon count changes (especially buff icons in combat)
      -- When icons are added/removed, the viewer resizes — this hooks new children and re-centers
      if not self:IsHooked(viewer, "OnSizeChanged") then
        self:SecureHookScript(viewer, "OnSizeChanged", function()
          if self.centeringActive and self.db.centering[key] then
            self:HookIconVisibility(viewer, key)
            self:CenterViewer(key)
          end
        end)
      end

      -- Hook existing icon children for show/hide during combat
      self:HookIconVisibility(viewer, key)

      -- Initial centering
      self:CenterViewer(key)
    end
  end

  if self.db.centering.buffBar then
    local cache = cacheViewerProps("buffBar")
    if not cache then return end

    local viewer = cache.viewer

    if not self:IsHooked(viewer, "RefreshLayout") then
      self:SecureHook(viewer, "RefreshLayout", function()
        if self.centeringActive and self.db.centering.buffBar then
          cacheViewerProps("buffBar")
          self:HookBuffBarVisibility(viewer)
          E:Delay(0, function()
            self:AlignBuffBarViewer()
          end)
        end
      end)
    end

    if not self:IsHooked(viewer, "OnSizeChanged") then
      self:SecureHookScript(viewer, "OnSizeChanged", function()
        if self.centeringActive and self.db.centering.buffBar then
          self:HookBuffBarVisibility(viewer)
          self:AlignBuffBarViewer()
        end
      end)
    end

    self:HookBuffBarVisibility(viewer)
    self:AlignBuffBarViewer()
  end
end

function CM:DisableCentering()
  if not self.centeringActive then return end
  self.centeringActive = false
  wipe(viewerCache)
  -- Hooks are cleaned up by UnhookAll in Disable()
end
