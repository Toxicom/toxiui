local TXUI, F, E, I, V, P, G, L = unpack((select(2, ...)))
local RIF = TXUI:NewModule("RaidInfoFrame")

-- -----------------------------------------------
-- Create Frame and Elements
-- -----------------------------------------------
function RIF:CreateTooltip()
  if not self.frame then return end

  self.frame:EnableMouse(true)

  self.frame:SetScript("OnEnter", function()
    GameTooltip:SetOwner(self.frame, "ANCHOR_TOP")
    GameTooltip:AddLine(TXUI.Title .. " Raid Info Frame", 1, 1, 1)
    GameTooltip:AddLine(" ")
    GameTooltip:AddLine("Displays the current count of Tanks, Healers, and DPS in your raid group.", nil, nil, nil, true)
    GameTooltip:AddLine(" ")
    GameTooltip:AddLine("|cffFFFFFFLeft Click:|r Toggle Raid Frame")
    GameTooltip:AddLine("|cffFFFFFFRight Click:|r Toggle Settings")
    GameTooltip:Show()
  end)

  self.frame:SetScript("OnLeave", function()
    GameTooltip:Hide()
  end)

  self.frame:SetScript("OnMouseDown", function(_, button)
    if button == "LeftButton" then
      ToggleRaidFrame()
    elseif button == "RightButton" then
      E:ToggleOptions("TXUI,misc,raidInfo")
    end
  end)
end

function RIF:Create()
  if self.frame then return end
  local primaryFont = F.GetFontPath(I.Fonts.Primary)

  local frame = CreateFrame("Frame", "ToxiUI_RaidInfoFrame", E.UIParent, "BackdropTemplate")
  local point, anchor, attachTo, x, y = strsplit(",", F.Position(strsplit(",", self.db.position)))
  frame:SetPoint(point, anchor, attachTo, x, y)

  E:CreateMover(frame, "ToxiUIRaidInfoFrame", TXUI.Title .. " Raid Info Frame", nil, nil, nil, "ALL,TXUI", nil, "TXUI,misc,raidInfo")

  frame:SetBackdrop {
    bgFile = E.media.blankTex,
    edgeFile = E.media.blankTex,
    edgeSize = 1,
  }

  frame:SetBackdropBorderColor(0, 0, 0, 1)

  -- Tank
  frame.tankIcon = frame:CreateTexture(nil, "ARTWORK")
  frame.tankIcon:SetTexture(F.GetMedia(I.Media.RoleIcons, "MaterialTank"))
  frame.tankText = frame:CreateFontString(nil, "OVERLAY")
  frame.tankText:SetFont(primaryFont, F.FontSizeScaled(self.db.size), "OUTLINE")
  frame.tankText:SetText("2")

  -- Healer
  frame.healIcon = frame:CreateTexture(nil, "ARTWORK")
  frame.healIcon:SetTexture(F.GetMedia(I.Media.RoleIcons, "MaterialHeal"))
  frame.healText = frame:CreateFontString(nil, "OVERLAY")
  frame.healText:SetFont(primaryFont, F.FontSizeScaled(self.db.size), "OUTLINE")
  frame.healText:SetText("4")

  -- DPS
  frame.dpsIcon = frame:CreateTexture(nil, "ARTWORK")
  frame.dpsIcon:SetTexture(F.GetMedia(I.Media.RoleIcons, "MaterialDPS"))
  frame.dpsText = frame:CreateFontString(nil, "OVERLAY")
  frame.dpsText:SetFont(primaryFont, F.FontSizeScaled(self.db.size), "OUTLINE")
  frame.dpsText:SetText("14")

  -- Difficulty
  frame.difficultyIcon = frame:CreateTexture(nil, "ARTWORK")
  frame.difficultyIcon:SetTexture(F.GetMedia(I.Media.StateIcons, "MaterialStar"))
  frame.difficultyText = frame:CreateFontString(nil, "OVERLAY")
  frame.difficultyText:SetFont(primaryFont, F.FontSizeScaled(self.db.size), "OUTLINE")
  frame.difficultyText:SetText("")

  -- Total
  frame.totalIcon = frame:CreateTexture(nil, "ARTWORK")
  frame.totalIcon:SetTexture(F.GetMedia(I.Media.StateIcons, "MaterialPerson"))
  frame.totalText = frame:CreateFontString(nil, "OVERLAY")
  frame.totalText:SetFont(primaryFont, F.FontSizeScaled(self.db.size), "OUTLINE")
  frame.totalText:SetText("0")

  -- Finalize
  frame:Hide()
  self.frame = frame

  self:CreateTooltip()
  self:UpdateSize()
  self:UpdateSpacing()
  self:UpdateBackdrop()
  self:UpdateDifficultyVisibility()
  self:UpdateTotalVisibility()
  self:Update()

  frame:RegisterEvent("GROUP_ROSTER_UPDATE")
  frame:RegisterEvent("PLAYER_ENTERING_WORLD")
  frame:SetScript("OnEvent", function()
    self:Update()
  end)
end

-- -----------------------------------------------
-- Update Size (icon + font)
-- -----------------------------------------------
function RIF:UpdateSize()
  local size = self.db.size
  local font = F.GetFontPath(I.Fonts.Primary)

  self.frame.difficultyIcon:SetSize(size, size)
  self.frame.tankIcon:SetSize(size, size)
  self.frame.healIcon:SetSize(size, size)
  self.frame.dpsIcon:SetSize(size, size)
  self.frame.totalIcon:SetSize(size, size)

  self.frame.difficultyText:SetFont(font, size, "OUTLINE")
  self.frame.tankText:SetFont(font, size, "OUTLINE")
  self.frame.healText:SetFont(font, size, "OUTLINE")
  self.frame.dpsText:SetFont(font, size, "OUTLINE")
  self.frame.totalText:SetFont(font, size, "OUTLINE")

  self:UpdateLayout()
end

-- -----------------------------------------------
-- Update Spacing & Padding (element positioning)
-- -----------------------------------------------
function RIF:UpdateSpacing()
  local spacing = self.db.spacing
  local padding = self.db.padding

  -- Clear all points first
  self.frame.difficultyIcon:ClearAllPoints()
  self.frame.difficultyText:ClearAllPoints()
  self.frame.tankIcon:ClearAllPoints()
  self.frame.tankText:ClearAllPoints()
  self.frame.healIcon:ClearAllPoints()
  self.frame.healText:ClearAllPoints()
  self.frame.dpsIcon:ClearAllPoints()
  self.frame.dpsText:ClearAllPoints()
  self.frame.totalIcon:ClearAllPoints()
  self.frame.totalText:ClearAllPoints()

  -- Difficulty (left side)
  self.frame.difficultyIcon:SetPoint("LEFT", self.frame, "LEFT", padding, 0)
  self.frame.difficultyText:SetPoint("LEFT", self.frame.difficultyIcon, "RIGHT", spacing, 0)

  -- Tank icon anchors to difficulty text if shown, otherwise to frame
  if self.db.showDifficulty then
    self.frame.tankIcon:SetPoint("LEFT", self.frame.difficultyText, "RIGHT", spacing * 2, 0)
  else
    self.frame.tankIcon:SetPoint("LEFT", self.frame, "LEFT", padding, 0)
  end
  self.frame.tankText:SetPoint("LEFT", self.frame.tankIcon, "RIGHT", spacing, 0)

  self.frame.healIcon:SetPoint("LEFT", self.frame.tankText, "RIGHT", spacing, 0)
  self.frame.healText:SetPoint("LEFT", self.frame.healIcon, "RIGHT", spacing, 0)

  self.frame.dpsIcon:SetPoint("LEFT", self.frame.healText, "RIGHT", spacing, 0)
  self.frame.dpsText:SetPoint("LEFT", self.frame.dpsIcon, "RIGHT", spacing, 0)

  self.frame.totalIcon:SetPoint("LEFT", self.frame.dpsText, "RIGHT", spacing * 2, 0)
  self.frame.totalText:SetPoint("LEFT", self.frame.totalIcon, "RIGHT", spacing, 0)

  self:UpdateLayout()
end

-- -----------------------------------------------
-- Update Backdrop Color
-- -----------------------------------------------
function RIF:UpdateBackdrop()
  local c = self.db.backdropColor
  self.frame:SetBackdropColor(c.r, c.g, c.b, c.a)
end

-- -----------------------------------------------
-- Update Layout (Width & Height)
-- -----------------------------------------------
function RIF:UpdateLayout()
  local size = self.db.size
  local spacing = self.db.spacing
  local padding = self.db.padding

  local width = 0

  -- Difficulty (left side)
  if self.db.showDifficulty and self.frame.difficultyText:GetText() ~= "" then width = width + size + spacing + self.frame.difficultyText:GetStringWidth() + (spacing * 2) end

  -- Role icons and counts
  width = width + size + spacing + self.frame.tankText:GetStringWidth()
  width = width + spacing + size + spacing + self.frame.healText:GetStringWidth()
  width = width + spacing + size + spacing + self.frame.dpsText:GetStringWidth()

  -- Total (right side)
  if self.db.showTotal and self.frame.totalText:GetText() ~= "" then width = width + (spacing * 2) + size + spacing + self.frame.totalText:GetStringWidth() end

  local height = size + (padding * 2)

  self.frame:SetWidth(math.ceil(width + (padding * 2)))
  self.frame:SetHeight(height)
end

function RIF:ToggleFrame()
  if not self.frame then return end

  if self.frame:IsShown() then
    self.frame:Hide()
  else
    -- Show preview with sample data
    self.frame:Show()
    self.frame.tankText:SetText("2")
    self.frame.healText:SetText("4")
    self.frame.dpsText:SetText("14")
    self.frame.totalText:SetText("20")

    -- Update difficulty
    local diffText, diffColor = self:GetDifficultyInfo()
    if diffText and diffColor then
      self.frame.difficultyText:SetText(diffText)
      self.frame.difficultyText:SetTextColor(diffColor[1], diffColor[2], diffColor[3], 1)
    else
      self.frame.difficultyText:SetText("NM")
      self.frame.difficultyText:SetTextColor(_G.UNCOMMON_GREEN_COLOR:GetRGB())
    end

    self:UpdateLayout()
  end
end

-- -----------------------------------------------
-- Update Difficulty Visibility
-- -----------------------------------------------
function RIF:UpdateDifficultyVisibility()
  if not self.frame then return end

  local show = self.db.showDifficulty
  if show then
    self.frame.difficultyIcon:Show()
    self.frame.difficultyText:Show()
  else
    self.frame.difficultyIcon:Hide()
    self.frame.difficultyText:Hide()
  end

  -- Update spacing to reposition elements
  self:UpdateSpacing()
end

-- -----------------------------------------------
-- Update Total Visibility
-- -----------------------------------------------
function RIF:UpdateTotalVisibility()
  if not self.frame then return end

  local show = self.db.showTotal
  if show then
    self.frame.totalIcon:Show()
    self.frame.totalText:Show()
  else
    self.frame.totalIcon:Hide()
    self.frame.totalText:Hide()
  end

  -- Update spacing to reposition elements
  self:UpdateSpacing()
end

-- -----------------------------------------------
-- Get Raid Difficulty Info
-- -----------------------------------------------
function RIF:GetDifficultyInfo()
  local difficulty = GetRaidDifficultyID()

  -- Mythic
  if difficulty == 16 then
    return "M", { _G.EPIC_PURPLE_COLOR:GetRGB() }
  -- Heroic
  elseif difficulty == 15 then
    return "HC", { _G.RARE_BLUE_COLOR:GetRGB() }
  -- Normal
  elseif difficulty == 14 then
    return "NM", { _G.UNCOMMON_GREEN_COLOR:GetRGB() }
  -- LFR
  elseif difficulty == 17 then
    return "LFR", { _G.HEIRLOOM_BLUE_COLOR:GetRGB() }
  end

  return nil, nil
end

-- -----------------------------------------------
-- Update Role Counts + Layout
-- -----------------------------------------------
function RIF:Update()
  if not self.frame then return end

  -- Update visibility based on settings
  self:UpdateDifficultyVisibility()
  self:UpdateTotalVisibility()

  -- Update difficulty (always check, even outside raid)
  local diffText, diffColor = self:GetDifficultyInfo()
  if diffText and diffColor and self.db.showDifficulty then
    self.frame.difficultyText:SetText(diffText)
    self.frame.difficultyText:SetTextColor(diffColor[1], diffColor[2], diffColor[3], 1)
  else
    self.frame.difficultyText:SetText("")
  end

  if IsInRaid() then
    self.frame:Show()

    local tank, heal, dps = 0, 0, 0
    local total = GetNumGroupMembers()

    for i = 1, total do
      local unit = "raid" .. i
      if UnitExists(unit) then
        local role = UnitGroupRolesAssigned(unit)
        if role == "TANK" then
          tank = tank + 1
        elseif role == "HEALER" then
          heal = heal + 1
        elseif role == "DAMAGER" then
          dps = dps + 1
        end
      end
    end

    self.frame.tankText:SetText(tank)
    self.frame.healText:SetText(heal)
    self.frame.dpsText:SetText(dps)

    if self.db.showTotal then
      self.frame.totalText:SetText(total)
    else
      self.frame.totalText:SetText("")
    end

    self:UpdateLayout()
  else
    self.frame:Hide()
  end
end

-- -----------------------------------------------
-- Enable If Allowed
-- -----------------------------------------------
function RIF:Enable()
  self:Create()
end

-- -----------------------------------------------
-- Database Load & Requirements Check
-- -----------------------------------------------
function RIF:DatabaseUpdate()
  self.db = F.GetDBFromPath("TXUI.misc.raidInfo")
  if TXUI:HasRequirements(I.Requirements.RaidInfoFrame) and self.db and self.db.enabled then self:Enable() end
end

-- -----------------------------------------------
-- Initialize Module
-- -----------------------------------------------
function RIF:Initialize()
  if self.Initialized then return end

  F.Event.RegisterOnceCallback("TXUI.InitializedSafe", F.Event.GenerateClosure(self.DatabaseUpdate, self))
  F.Event.RegisterCallback("TXUI.DatabaseUpdate", self.DatabaseUpdate, self)

  self.Initialized = true
end

TXUI:RegisterModule(RIF:GetName())
