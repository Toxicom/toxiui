local TXUI, F, E, I, V, P, G, L = unpack((select(2, ...)))
local RIF = TXUI:NewModule("RaidInfoFrame")

local spacing, iconSize, fontSpacing, padding = 4, 16, 10, 4

-- -----------------------------------------------
-- Create Frame
-- -----------------------------------------------
function RIF:Create()
  local db = self.db
  local point, anchor, attachTo, x, y = strsplit(",", F.Position(strsplit(",", db.position)))
  TXUI:LogDebug("RIF: Creating frame")

  self.frame = CreateFrame("Frame", "ToxiUI_RaidInfoFrame", E.UIParent, "BackdropTemplate")
  self.frame:SetPoint(point, anchor, attachTo, x, y)
  self.frame:SetHeight(20 + padding)
  self.frame:Hide()

  self.frame:SetBackdrop {
    bgFile = E.media.blankTex,
    edgeFile = E.media.blankTex,
    edgeSize = 1,
  }
  self.frame:SetBackdropColor(0, 0, 0, 0.5)
  self.frame:SetBackdropBorderColor(0, 0, 0, 1)

  -- Tank
  self.tankIcon = self.frame:CreateTexture(nil, "ARTWORK")
  self.tankIcon:SetSize(iconSize, iconSize)
  self.tankIcon:SetPoint("LEFT", self.frame, "LEFT", padding, 0)

  self.tankText = self.frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  self.tankText:SetPoint("LEFT", self.tankIcon, "RIGHT", spacing, 0)

  -- Healer
  self.healIcon = self.frame:CreateTexture(nil, "ARTWORK")
  self.healIcon:SetSize(iconSize, iconSize)
  self.healIcon:SetPoint("LEFT", self.tankText, "RIGHT", fontSpacing, 0)

  self.healText = self.frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  self.healText:SetPoint("LEFT", self.healIcon, "RIGHT", spacing, 0)

  -- DPS
  self.dpsIcon = self.frame:CreateTexture(nil, "ARTWORK")
  self.dpsIcon:SetSize(iconSize, iconSize)
  self.dpsIcon:SetPoint("LEFT", self.healText, "RIGHT", fontSpacing, 0)

  self.dpsText = self.frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  self.dpsText:SetPoint("LEFT", self.dpsIcon, "RIGHT", spacing, 0)

  self:UpdateIcons()
  self:Update()

  self.frame:RegisterEvent("GROUP_ROSTER_UPDATE")
  self.frame:RegisterEvent("PLAYER_ENTERING_WORLD")
  self.frame:SetScript("OnEvent", function()
    self:Update()
  end)
end

-- -----------------------------------------------
-- Update Icons
-- -----------------------------------------------
function RIF:UpdateIcons()
  local theme = E.db.TXUI.elvUIIcons.roleIcons.theme

  if self.tankIcon then self.tankIcon:SetTexture(F.GetMedia(I.Media.RoleIcons, I.ElvUIIcons.Role[theme].raid1.TANK)) end

  if self.healIcon then self.healIcon:SetTexture(F.GetMedia(I.Media.RoleIcons, I.ElvUIIcons.Role[theme].raid1.HEALER)) end

  if self.dpsIcon then self.dpsIcon:SetTexture(F.GetMedia(I.Media.RoleIcons, I.ElvUIIcons.Role[theme].raid1.DAMAGER)) end
end

-- -----------------------------------------------
-- Update Role Count Display
-- -----------------------------------------------
function RIF:Update()
  if not self.frame then return end

  if true then
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

    local width = iconSize
      + spacing
      + self.tankText:GetStringWidth()
      + fontSpacing
      + iconSize
      + spacing
      + self.healText:GetStringWidth()
      + fontSpacing
      + iconSize
      + spacing
      + self.dpsText:GetStringWidth()

    self.frame:SetWidth(math.ceil(width + (padding * 2)))
  else
    self.frame:Hide()
  end
end

-- -----------------------------------------------
-- Enable If Allowed
-- -----------------------------------------------
function RIF:Enable()
  TXUI:LogDebug("RIF: Enabling module")
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
  TXUI:LogDebug("RIF: Initialize start")
  if self.Initialized then return end

  -- Only register DB-related hooks here
  F.Event.RegisterOnceCallback("TXUI.InitializedSafe", F.Event.GenerateClosure(self.DatabaseUpdate, self))
  F.Event.RegisterCallback("TXUI.DatabaseUpdate", self.DatabaseUpdate, self)

  self.Initialized = true
  TXUI:LogDebug("RIF: Initialized true")
end

TXUI:RegisterModule(RIF:GetName())
