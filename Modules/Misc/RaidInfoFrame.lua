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
  frame.tankText = frame:CreateFontString(nil, "OVERLAY")
  frame.tankText:SetFont(primaryFont, F.FontSizeScaled(self.db.size), "OUTLINE")
  frame.tankText:SetText("2")

  -- Healer
  frame.healIcon = frame:CreateTexture(nil, "ARTWORK")
  frame.healText = frame:CreateFontString(nil, "OVERLAY")
  frame.healText:SetFont(primaryFont, F.FontSizeScaled(self.db.size), "OUTLINE")
  frame.healText:SetText("4")

  -- DPS
  frame.dpsIcon = frame:CreateTexture(nil, "ARTWORK")
  frame.dpsText = frame:CreateFontString(nil, "OVERLAY")
  frame.dpsText:SetFont(primaryFont, F.FontSizeScaled(self.db.size), "OUTLINE")
  frame.dpsText:SetText("14")

  -- Finalize
  frame:Hide()
  self.frame = frame

  self:CreateTooltip()
  self:UpdateIcons()
  self:UpdateSize()
  self:UpdateSpacing()
  self:UpdateBackdrop()
  self:Update()

  frame:RegisterEvent("GROUP_ROSTER_UPDATE")
  frame:RegisterEvent("PLAYER_ENTERING_WORLD")
  frame:SetScript("OnEvent", function()
    self:Update()
  end)
end

-- -----------------------------------------------
-- Update Role Icon Textures
-- -----------------------------------------------
function RIF:UpdateIcons()
  local theme = E.db.TXUI.elvUIIcons.roleIcons.theme

  if self.frame.tankIcon then self.frame.tankIcon:SetTexture(F.GetMedia(I.Media.RoleIcons, I.ElvUIIcons.Role[theme].raid1.TANK)) end
  if self.frame.healIcon then self.frame.healIcon:SetTexture(F.GetMedia(I.Media.RoleIcons, I.ElvUIIcons.Role[theme].raid1.HEALER)) end
  if self.frame.dpsIcon then self.frame.dpsIcon:SetTexture(F.GetMedia(I.Media.RoleIcons, I.ElvUIIcons.Role[theme].raid1.DAMAGER)) end
end

-- -----------------------------------------------
-- Update Size (icon + font)
-- -----------------------------------------------
function RIF:UpdateSize()
  local size = self.db.size
  local font = F.GetFontPath(I.Fonts.Primary)

  self.frame.tankIcon:SetSize(size, size)
  self.frame.healIcon:SetSize(size, size)
  self.frame.dpsIcon:SetSize(size, size)

  self.frame.tankText:SetFont(font, size, "OUTLINE")
  self.frame.healText:SetFont(font, size, "OUTLINE")
  self.frame.dpsText:SetFont(font, size, "OUTLINE")

  self:UpdateLayout()
end

-- -----------------------------------------------
-- Update Spacing & Padding (element positioning)
-- -----------------------------------------------
function RIF:UpdateSpacing()
  local spacing = self.db.spacing
  local padding = self.db.padding

  self.frame.tankIcon:SetPoint("LEFT", self.frame, "LEFT", padding, 0)
  self.frame.tankText:SetPoint("LEFT", self.frame.tankIcon, "RIGHT", spacing, 0)

  self.frame.healIcon:SetPoint("LEFT", self.frame.tankText, "RIGHT", spacing, 0)
  self.frame.healText:SetPoint("LEFT", self.frame.healIcon, "RIGHT", spacing, 0)

  self.frame.dpsIcon:SetPoint("LEFT", self.frame.healText, "RIGHT", spacing, 0)
  self.frame.dpsText:SetPoint("LEFT", self.frame.dpsIcon, "RIGHT", spacing, 0)

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

  local width = size
    + spacing
    + self.frame.tankText:GetStringWidth()
    + spacing
    + size
    + spacing
    + self.frame.healText:GetStringWidth()
    + spacing
    + size
    + spacing
    + self.frame.dpsText:GetStringWidth()

  local height = size + (padding * 2)

  self.frame:SetWidth(math.ceil(width + (padding * 2)))
  self.frame:SetHeight(height)
end

function RIF:ToggleFrame()
  if not self.frame then return end

  if self.frame:IsShown() then
    self.frame:Hide()
  else
    self.frame:Show()
  end
end

-- -----------------------------------------------
-- Update Role Counts + Layout
-- -----------------------------------------------
function RIF:Update()
  if not self.frame then return end

  if IsInRaid() then
    self.frame:Show()

    local tank, heal, dps = 0, 0, 0
    for i = 1, GetNumGroupMembers() do
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
