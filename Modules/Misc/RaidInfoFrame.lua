local TXUI, F, E, I, V, P, G, L = unpack((select(2, ...)))
local RIF = TXUI:NewModule("RaidInfoFrame")

-- -----------------------------------------------
-- Create Frame and Elements
-- -----------------------------------------------
function RIF:Create()
  if self.frame then return end

  local frame = CreateFrame("Frame", "ToxiUI_RaidInfoFrame", E.UIParent, "BackdropTemplate")
  frame:SetPoint("TOPLEFT", E.UIParent, "TOPLEFT", 10, -10)
  frame:Hide()

  E:CreateMover(frame, "ToxiUIRaidInfoFrame", TXUI.Title .. " Raid Info Frame", nil, nil, nil, "ALL,TXUI", nil, "TXUI,misc,raidInfo")

  frame:SetBackdrop {
    bgFile = E.media.blankTex,
    edgeFile = E.media.blankTex,
    edgeSize = 1,
  }

  frame:SetBackdropBorderColor(0, 0, 0, 1)

  -- Tank
  self.tankIcon = frame:CreateTexture(nil, "ARTWORK")
  self.tankText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  self.tankText:SetText("2")

  -- Healer
  self.healIcon = frame:CreateTexture(nil, "ARTWORK")
  self.healText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  self.healText:SetText("4")

  -- DPS
  self.dpsIcon = frame:CreateTexture(nil, "ARTWORK")
  self.dpsText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  self.dpsText:SetText("14")

  -- Assign the frame reference
  self.frame = frame

  -- Initial setup
  self:UpdateIcons()
  self:UpdateSize()
  self:UpdateSpacing()
  self:UpdateBackdrop()
  self:Update()

  -- Events
  self.frame:RegisterEvent("GROUP_ROSTER_UPDATE")
  self.frame:RegisterEvent("PLAYER_ENTERING_WORLD")
  self.frame:SetScript("OnEvent", function()
    self:Update()
  end)
end

-- -----------------------------------------------
-- Update Role Icon Textures
-- -----------------------------------------------
function RIF:UpdateIcons()
  local theme = E.db.TXUI.elvUIIcons.roleIcons.theme

  if self.tankIcon then self.tankIcon:SetTexture(F.GetMedia(I.Media.RoleIcons, I.ElvUIIcons.Role[theme].raid1.TANK)) end
  if self.healIcon then self.healIcon:SetTexture(F.GetMedia(I.Media.RoleIcons, I.ElvUIIcons.Role[theme].raid1.HEALER)) end
  if self.dpsIcon then self.dpsIcon:SetTexture(F.GetMedia(I.Media.RoleIcons, I.ElvUIIcons.Role[theme].raid1.DAMAGER)) end
end

-- -----------------------------------------------
-- Update Size (icon + font)
-- -----------------------------------------------
function RIF:UpdateSize()
  local size = self.db.size
  local font = F.GetFontPath(I.Fonts.Primary)

  self.tankIcon:SetSize(size, size)
  self.healIcon:SetSize(size, size)
  self.dpsIcon:SetSize(size, size)

  self.tankText:SetFont(font, size, "OUTLINE")
  self.healText:SetFont(font, size, "OUTLINE")
  self.dpsText:SetFont(font, size, "OUTLINE")

  self:UpdateLayout()
end

-- -----------------------------------------------
-- Update Spacing & Padding (element positioning)
-- -----------------------------------------------
function RIF:UpdateSpacing()
  local spacing = self.db.spacing
  local padding = self.db.padding

  self.tankIcon:SetPoint("LEFT", self.frame, "LEFT", padding, 0)
  self.tankText:SetPoint("LEFT", self.tankIcon, "RIGHT", spacing, 0)

  self.healIcon:SetPoint("LEFT", self.tankText, "RIGHT", spacing, 0)
  self.healText:SetPoint("LEFT", self.healIcon, "RIGHT", spacing, 0)

  self.dpsIcon:SetPoint("LEFT", self.healText, "RIGHT", spacing, 0)
  self.dpsText:SetPoint("LEFT", self.dpsIcon, "RIGHT", spacing, 0)

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
    + self.tankText:GetStringWidth()
    + spacing
    + size
    + spacing
    + self.healText:GetStringWidth()
    + spacing
    + size
    + spacing
    + self.dpsText:GetStringWidth()

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

    self.tankText:SetText(tank)
    self.healText:SetText(heal)
    self.dpsText:SetText(dps)

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
