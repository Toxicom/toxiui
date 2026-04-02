local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local CM = TXUI:GetModule("CooldownManager")

local _G = _G
local InCombatLockdown = InCombatLockdown
local ceil = math.ceil
local max = math.max

function CM:SyncBarsWidth()
  if not self.essentialViewer then return end
  if InCombatLockdown() then return end

  local width = ceil(self.essentialViewer:GetWidth())
  -- sometimes the width comes as fucking 1.003003002 etc. so make sure it's bigger than one button atleast
  if not width or width <= 30 then return end

  -- For when EssentialCooldownViewer is too small or no spells etc.
  if width <= 100 then width = F.Dpi(292) end -- default width

  -- Apply minimum width if set
  local dw = self.db.dynamicWidth
  local minWidth = dw and dw.minWidth
  if minWidth and minWidth > 0 then width = max(width, minWidth) end

  -- Skip if width hasn't changed
  if self.cachedBarsWidth == width then return end
  self.cachedBarsWidth = width

  -- Update ElvUI player power and classbar detached width
  local playerDB = E.db.unitframe.units.player
  if playerDB then
    if playerDB.power and playerDB.power.enable then playerDB.power.detachedWidth = width end
    if playerDB.classbar and playerDB.classbar.enable then
      -- For "spaced" fill, adjust spacing so bar widths divide evenly:
      -- (width - (numBars-1) * spacing) must be divisible by numBars.
      -- Search outward from original spacing, but cap at ±3 to avoid ugly large gaps.
      -- If no clean solution exists within range, leave spacing unchanged.
      if playerDB.classbar.fill == "spaced" then
        local classBarFrame = _G["ElvUF_Player_ClassBar"]
        local numBars = classBarFrame and classBarFrame.__max
        if numBars and numBars > 1 then
          local origSpacing = playerDB.classbar.spacing or 2
          for delta = 0, 3 do
            if (width - (numBars - 1) * (origSpacing + delta)) % numBars == 0 then
              playerDB.classbar.spacing = origSpacing + delta
              break
            end
            local sLow = origSpacing - delta
            if sLow >= 1 and (width - (numBars - 1) * sLow) % numBars == 0 then
              playerDB.classbar.spacing = sLow
              break
            end
          end
        end
      end

      playerDB.classbar.detachedWidth = width
    end

    -- Update the unitframe to apply changes (must be out of combat to avoid taint)
    F.Event.ContinueOutOfCombat(function()
      local uf = E:GetModule("UnitFrames")
      if uf and uf.CreateAndUpdateUF then uf:CreateAndUpdateUF("player") end
    end)
  end
end

function CM:SyncCastbarWidth()
  if not self.essentialViewer then return end
  if InCombatLockdown() then return end

  local width = ceil(self.essentialViewer:GetWidth())
  if not width or width <= 30 then return end
  if width <= 100 then width = F.Dpi(292) end

  -- Apply minimum width if set
  local dw = self.db.dynamicWidth
  local minWidth = dw and dw.minWidth
  if minWidth and minWidth > 0 then width = max(width, minWidth) end

  if self.cachedCastbarWidth == width then return end
  self.cachedCastbarWidth = width

  local playerDB = E.db.unitframe.units.player
  if playerDB and playerDB.castbar then
    playerDB.castbar.width = width

    F.Event.ContinueOutOfCombat(function()
      local uf = E:GetModule("UnitFrames")
      if uf and uf.CreateAndUpdateUF then uf:CreateAndUpdateUF("player") end
    end)
  end
end

function CM:OnDynamicWidthChanged()
  local dw = self.db and self.db.dynamicWidth
  if not dw or not dw.enabled then return end
  if dw.powerClassBars then self:SyncBarsWidth() end
  if dw.castBar then self:SyncCastbarWidth() end
end

-- Disable all dynamic width features (full teardown, used by CM:Disable)
function CM:DisableDynamicWidth()
  self:DisableDynamicBarsWidth()
  self:DisableDynamicCastbarWidth()
end

-- Pause dynamic width syncing during Edit Mode without restoring saved ElvUI widths.
-- Directly unhooks OnSizeChanged and clears all caches.
function CM:DisableDynamicWidthForEditMode()
  self.cachedBarsWidth = nil
  self.cachedCastbarWidth = nil
  if self.essentialViewer and self:IsHooked(self.essentialViewer, "OnSizeChanged") then self:Unhook(self.essentialViewer, "OnSizeChanged") end
end

-- Re-apply dynamic width syncing after Edit Mode exits.
function CM:EnableDynamicWidthAfterEditMode()
  local dw = self.db and self.db.dynamicWidth
  if not dw or not dw.enabled then return end
  if dw.powerClassBars then self:EnableDynamicBarsWidth() end
  if dw.castBar then self:EnableDynamicCastbarWidth() end
  self:OnDynamicWidthChanged()
end

function CM:EnableDynamicBarsWidth()
  if not self.Initialized then return end

  if not self.essentialViewer then return end

  -- Hook OnSizeChanged to sync whenever frame width changes
  if not self:IsHooked(self.essentialViewer, "OnSizeChanged") then self:SecureHookScript(self.essentialViewer, "OnSizeChanged", "OnDynamicWidthChanged") end
end

function CM:DisableDynamicBarsWidth()
  if not self.Initialized then return end

  self.cachedBarsWidth = nil

  -- Both features share the same OnSizeChanged hook; only unhook if castbar sync isn't also using it
  local dw = self.db and self.db.dynamicWidth
  if not (dw and dw.castBar) then
    if self.essentialViewer and self:IsHooked(self.essentialViewer, "OnSizeChanged") then self:Unhook(self.essentialViewer, "OnSizeChanged") end
  end
end

function CM:EnableDynamicCastbarWidth()
  if not self.Initialized then return end

  if not self.essentialViewer then return end

  if not self:IsHooked(self.essentialViewer, "OnSizeChanged") then self:SecureHookScript(self.essentialViewer, "OnSizeChanged", "OnDynamicWidthChanged") end
end

function CM:DisableDynamicCastbarWidth()
  if not self.Initialized then return end

  self.cachedCastbarWidth = nil

  -- Both features share the same OnSizeChanged hook; only unhook if bars width sync isn't also using it
  local dw = self.db and self.db.dynamicWidth
  if not (dw and dw.powerClassBars) then
    if self.essentialViewer and self:IsHooked(self.essentialViewer, "OnSizeChanged") then self:Unhook(self.essentialViewer, "OnSizeChanged") end
  end
end
