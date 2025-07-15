local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local WB = TXUI:GetModule("WunderBar")
local LSM = E.Libs.LSM

-- Globals
local C_PetBattles_IsInBattle = (TXUI.IsRetail or TXUI.IsMists) and C_PetBattles.IsInBattle
local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local IsResting = IsResting

function WB:BarFadeIn()
  if not self.isEnabled then return end

  self:FadeIn(self.bar, 1)
end

function WB:BarFadeOut()
  if not self.isEnabled then return end

  self:FadeOut(self.bar, 1)
end

function WB:CheckVisibility(event)
  if not self.isEnabled then return end

  local isVisible = true

  -- Force enable Mouseover Only if you have selected RESTING_AND_MOUSEOVER
  if self.db.general.barVisibility == "RESTING_AND_MOUSEOVER" then self.db.general.barMouseOverOnly = true end

  -- Always hide for pokemon on retail
  if self.isVisible and (not TXUI.IsVanilla and C_PetBattles_IsInBattle()) then isVisible = false end

  -- Only visible on mouseover
  if isVisible and self.db.general.barVisibility ~= "RESTING_AND_MOUSEOVER" and self.db.general.barMouseOverOnly and not self.isMouseOver and not self.flyoutIsOpen then
    isVisible = false
  end

  -- Check if not overwritten by mouseover
  if isVisible then
    if self.db.general.barVisibility == "ALWAYS" then
      isVisible = true
    elseif self.db.general.barVisibility == "RESTING" then
      isVisible = IsResting()
    elseif self.db.general.barVisibility == "RESTING_AND_MOUSEOVER" then
      isVisible = self.flyoutIsOpen or IsResting() or self.isMouseOver
    elseif self.db.general.barVisibility == "NO_COMBAT" then
      if event then
        if event == "PLAYER_REGEN_DISABLED" then isVisible = false end
      else
        isVisible = not InCombatLockdown()
      end
    end
  end

  if not self.isVisible and isVisible then
    self:BarFadeIn()
    self:SendForceUpdate(false)
  elseif self.isVisible and not isVisible then
    self:BarFadeOut()
  end

  self.isVisible = isVisible
end

function WB:BarOnEnter()
  self.isMouseOver = true
  if self.db.general.barMouseOverOnly then
    if self.mouseOverTimer then self:CancelTimer(self.mouseOverTimer) end
    self:CheckVisibility()
  end
end

function WB:BarOnLeave()
  if self.db.general.barMouseOverOnly then
    if self.mouseOverTimer then self:CancelTimer(self.mouseOverTimer) end

    self.mouseOverTimer = self:ScheduleTimer(function()
      self.isMouseOver = false
      self:CheckVisibility()
    end, 2)
  else
    self.isMouseOver = false
  end
end

function WB:BarOnUpdate(_, elapsed)
  if not self.isVisible then return end
  self:HandleModuleOnUpdate(elapsed)
end

function WB:UpdateBar()
  -- Size for bar
  local barHeight = E:Scale(self.db.general.barHeight)
  self.bar:SetSize(F.PerfectScale(self.db.general.barWidth), barHeight)
  self.bar:ClearAllPoints()

  if self.isTop then
    self.bar:SetPoint("TOP", E.UIParent, "TOP", 0, 0)
  else
    self.bar:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, 0)
  end

  -- Size for modules
  local panelSize = F.PerfectScale(self:CalculateEqualWidth(self.db.general.barWidth, E:Scale(self.db.general.barSpacing)))
  self.bar.leftPanel:SetSize(panelSize, barHeight)
  self.bar.middlePanel:SetSize(panelSize, barHeight)
  self.bar.rightPanel:SetSize(panelSize, barHeight)

  -- Set Background
  local lsmTexture = LSM:Fetch("statusbar", self.db.general.backgroundTexture)
  if not lsmTexture then lsmTexture = E.media.blankTex end -- backup to elvui texture if not found
  self.bar.barBackground:SetTexture(lsmTexture)

  -- Get color from func
  local color = F.GetFontColorFromDB {
    FontColor = self.db.general.backgroundColor,
    FontCustomColor = self.db.general.backgroundCustomColor,
  }

  -- Custom handling for ElvUI & Class Color
  if self.db.general.backgroundColor == "CLASS" then
    color.a = 0.6
  elseif self.db.general.backgroundColor == "VALUE" then
    color = E.db.general.backdropfadecolor
  elseif self.db.general.backgroundColor == "RGB" then
    self:StartColorCycle(self.bar.barBackground, 10, 0.6, self.db.general.backgroundGradient and (0.6 * (1 - self.db.general.backgroundGradientAlpha)) or 0.6)
  end

  -- Set Fade
  if self.db.general.backgroundColor ~= "RGB" then
    self:StopAnimationType(self.bar.barBackground, self.animationType.COLOR)

    if self.db.general.backgroundGradient then
      local initialAlpha = self.isTop and color.a * (1 - self.db.general.backgroundGradientAlpha) or color.a
      local endAlpha = self.isTop and color.a or color.a * (1 - self.db.general.backgroundGradientAlpha)

      F.Color.SetGradientRGB(self.bar.barBackground, "VERTICAL", color.r, color.g, color.b, initialAlpha, color.r, color.g, color.b, endAlpha)
    else
      F.Color.SetGradientRGB(self.bar.barBackground, "VERTICAL", color.r, color.g, color.b, color.a, color.r, color.g, color.b, color.a)
    end
  end

  self:UpdatePanelModules()
  self:CheckVisibility()
end

function WB:ConstructBar()
  if self.bar then return end

  local bar = CreateFrame("Frame", "TXUIWunderBar", E.UIParent)
  bar:SetFrameStrata("MEDIUM")

  local barBackground = bar:CreateTexture(nil, "BACKGROUND")
  barBackground:SetAllPoints()

  local leftPanel = CreateFrame("Frame", "TXUIWunderBarLeftPanel", bar)
  local middlePanel = CreateFrame("Frame", "TXUIWunderBarMiddlePanel", bar)
  local rightPanel = CreateFrame("Frame", "TXUIWunderBarRightPanel", bar)

  leftPanel:SetPoint("RIGHT", middlePanel, "LEFT", 0, 0)
  middlePanel:SetPoint("CENTER", bar, "CENTER", 0, 0)
  rightPanel:SetPoint("LEFT", middlePanel, "RIGHT", 0, 0)

  leftPanel.panelName = "LeftPanel"
  middlePanel.panelName = "MiddlePanel"
  rightPanel.panelName = "RightPanel"

  bar.leftPanel = leftPanel
  bar.middlePanel = middlePanel
  bar.rightPanel = rightPanel
  bar.barBackground = barBackground

  self.bar = bar
end
