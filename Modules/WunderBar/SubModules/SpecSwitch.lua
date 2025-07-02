local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local WB = TXUI:GetModule("WunderBar")
local SS = WB:NewModule("SpecSwitch")
local DT = E:GetModule("DataTexts")

local _G = _G
local C_Traits_GetConfigInfo = C_Traits.GetConfigInfo
local CreateFrame = CreateFrame
local format = string.format
local GetActiveTalentGroup = GetActiveTalentGroup
local GetCurrentSpecID = TXUI.IsRetail and PlayerUtil.GetCurrentSpecID or nil
local GetCVarBool = GetCVarBool
local GetLastSelectedSavedConfigID = TXUI.IsRetail and C_ClassTalents.GetLastSelectedSavedConfigID or nil
local GetLootSpecialization = GetLootSpecialization
local GetNumSpecializationsForClassID = GetNumSpecializationsForClassID
local GetNumTalentGroups = GetNumTalentGroups
local GetSpecialization = GetSpecialization
local GetSpecializationInfoForClassID = GetSpecializationInfoForClassID
local C_SpecializationInfo = C_SpecializationInfo
local GetTalentGroupRole = GetTalentGroupRole
local GetTalentTabInfo = GetTalentTabInfo
local ipairs = ipairs
local SetActiveTalentGroup = SetActiveTalentGroup
local strjoin = strjoin
local tinsert = table.insert
local ToggleTalentFrame = ToggleTalentFrame
local UnitClassBase = UnitClassBase
local unpack = unpack

local TALENT_SPEC_PRIMARY = TALENT_SPEC_PRIMARY
local TALENT_SPEC_SECONDARY = TALENT_SPEC_SECONDARY
local TALENTS = TALENTS

local activeString = strjoin("", "|cff00FF00", ACTIVE_PETS, "|r")
local inactiveString = strjoin("", "|cffFF0000", FACTION_INACTIVE, "|r")

function SS:GetLoadoutName()
  if TXUI.IsRetail then
    local specId = GetCurrentSpecID and GetCurrentSpecID() or nil
    if specId then
      local configID = GetLastSelectedSavedConfigID(specId)
      if configID then
        local configInfo = C_Traits_GetConfigInfo(configID)

        if configInfo and configInfo.name then
          return configInfo.name
        else
          return nil
        end
      end
    end
  end

  return nil
end

function SS:OnEvent()
  self:OnWunderBarUpdate()
end

function SS:OnClick(frame, ...)
  if frame and frame.spec and frame:IsShown() then
    if frame.spec == "spec1" then
      self:SpecClick(frame, ...)
    elseif frame.spec == "spec2" then
      self:SpecClick(frame, ...)
    end
  end
end

function SS:OnEnter(frame)
  if frame and frame.spec and frame:IsShown() then
    if frame.spec == "spec1" then
      self:SpecEnter(self.spec1Text, self.spec1Icon)
    elseif frame.spec == "spec2" then
      self:SpecEnter(self.spec2Text, self.spec2Icon)
    end
  end
end

function SS:OnLeave(frame)
  if frame and frame.spec and frame:IsShown() then
    if frame.spec == "spec1" then
      self:SpecLeave(self.spec1Text, self.spec1Icon)
    elseif frame.spec == "spec2" then
      self:SpecLeave(self.spec2Text, self.spec2Icon)
    end
  end
end

function SS:SpecEnter(text, icon)
  WB:SetFontAccentColor(text)
  WB:SetFontAccentColor(icon)

  local dtModule = WB:GetElvUIDataText("Talent/Loot Specialization")

  if dtModule then
    dtModule.eventFunc(WB:GetElvUIDummy(), "ELVUI_FORCE_UPDATE")
    dtModule.onEnter()
  else
    local function addTexture(texture)
      return texture and format("|T%s:16:16:0:0:50:50:4:46:4:46|t", texture) or ""
    end

    DT.tooltip:ClearLines()

    local displayString = "|cffFFFFFF%s|r"
    for i, info in ipairs(self.specCache) do
      DT.tooltip:AddLine(
        strjoin(
          " ",
          addTexture(info.icon),
          format(displayString, info.name),
          format(displayString, "-"),
          _G[info.role],
          format(displayString, "-"),
          (i == self.spec1 and activeString or inactiveString)
        )
      )
    end

    DT.tooltip:AddLine(" ")
    DT.tooltip:AddLine(TALENTS, 0.69, 0.31, 0.31)

    displayString = "%s |cffFFFFFF%s:|r %s"
    for _, info in ipairs(self.specCache) do
      DT.tooltip:AddLine(format(displayString, addTexture(info.icon), info.name, info.points))
    end

    DT.tooltip:AddLine(" ")
    DT.tooltip:AddLine("|cffFFFFFFLeft Click:|r Show Talent UI")
    if TXUI.IsRetail or (TXUI.IsMists and GetNumSpecGroups(true) == 2) then DT.tooltip:AddLine("|cffFFFFFFRight Click:|r Change Talent Specialization") end
    DT.tooltip:Show()
  end
end

function SS:SpecLeave(text, icon)
  WB:SetFontNormalColor(text)
  WB:SetFontIconColor(icon)
end

function SS:SpecClick(frame, button, ...)
  local dtModule = WB:GetElvUIDataText("Talent/Loot Specialization")

  local hasDualSpec
  local activeGroup

  if TXUI.IsMists then
    hasDualSpec = GetNumSpecGroups(true) == 2
    activeGroup = C_SpecializationInfo.GetActiveSpecGroup()
  end

  if dtModule then
    dtModule.eventFunc(WB:GetElvUIDummy(), "PLAYER_LOOT_SPEC_UPDATED")
    dtModule.onClick(frame, button, ...)
  else
    if button == "LeftButton" then
      ToggleTalentFrame()
    elseif TXUI.IsMists then
      if not hasDualSpec then return end
      SetActiveTalentGroup(activeGroup == 1 and 2 or 1)
    else
      local menuList = {}

      for i, info in ipairs(self.specCache) do
        if info and info.name then
          tinsert(menuList, {
            spellID = info.name,
            icon = info.icon,
            type = "function",
            func = function()
              SetActiveTalentGroup(i)
            end,
          })
        end
      end

      local flyoutDirection = E.db.TXUI.wunderbar.general.position == "TOP" and "DOWN" or "UP"
      WB:ShowSecureFlyOut(frame, flyoutDirection, menuList)
    end
  end
end

function SS:OnWunderBarUpdate()
  F.Event.ContinueOutOfCombat(function()
    E:Delay(0.01, function()
      self:UpdateSpecialization()
      self:UpdateSwitch()
      self:UpdateElements()
      self:UpdatePosition()
      self:UpdateInfoText()
    end)
  end)
end

function SS:GetCurrentSpecPoints(spec)
  local points = {}
  local highPointsSpentIndex = nil

  for treeIndex = 1, 3 do
    local _, name, _, _, pointsSpent, _, previewPointsSpent, _ = GetTalentTabInfo(treeIndex, false, false, spec)
    if name then
      local displayPointsSpent = pointsSpent + previewPointsSpent
      points[treeIndex] = displayPointsSpent
      if displayPointsSpent > 0 and (not highPointsSpentIndex or displayPointsSpent > points[highPointsSpentIndex]) then highPointsSpentIndex = treeIndex end
    else
      points[treeIndex] = 0
    end
  end

  return points, highPointsSpentIndex
end

function SS:GetWrathCacheForSpec(spec)
  local points, highPointsSpentIndex = SS:GetCurrentSpecPoints(spec)

  local role = GetTalentGroupRole(spec)
  if not role or role == "NONE" then role = "DAMAGER" end

  if highPointsSpentIndex ~= nil then
    local _, name, _, icon, _, stringId = select(1, GetTalentTabInfo(highPointsSpentIndex, false, false, spec))

    if name then return {
      id = stringId,
      icon = icon,
      name = name,
      role = role,
      points = ("%s / %s / %s"):format(unpack(points)),
    } end
  end

  return {
    id = 0,
    icon = 134942,
    name = spec == 2 and TALENT_SPEC_SECONDARY or TALENT_SPEC_PRIMARY,
    role = "DAMAGER",
    points = "0 / 0 / 0",
  }
end

function SS:UpdateSpecialization()
  local spec1, spec2

  if TXUI.IsVanilla then
    spec1 = GetActiveTalentGroup()
    spec2 = GetNumTalentGroups() == 2 and (spec1 == 2 and 1 or 2) or nil
    self.specCache = {}

    if spec1 then self.specCache[spec1] = self:GetWrathCacheForSpec(spec1) end
    if spec2 then self.specCache[spec2] = self:GetWrathCacheForSpec(spec2) end
  else
    spec1 = C_SpecializationInfo and C_SpecializationInfo.GetSpecialization and C_SpecializationInfo.GetSpecialization() or GetSpecialization()
    spec2 = 0

    local lootSpec = GetLootSpecialization()
    if lootSpec and lootSpec ~= 0 then
      for specIdx, info in ipairs(self.specCache) do
        if info.id == lootSpec then
          spec2 = specIdx
          break
        end
      end
    end
  end

  self.spec1 = nil
  self.spec2 = nil
  self.infoSpec = nil

  if spec1 and self.db.general.showSpec1 then self.spec1 = spec1 end
  if spec2 and self.db.general.showSpec2 then self.spec2 = (spec2 ~= 0) and spec2 or spec1 end

  if not self.spec1 and self.spec2 then
    self.spec1 = (spec2 ~= 0) and spec2 or spec1
    self.spec2 = nil
  end

  if self.spec1 == spec1 then
    self.infoSpec = (spec2 ~= 0) and spec2 or nil
  else
    self.infoSpec = spec1
  end
end

function SS:UpdatePosition()
  if not self.spec1 and not self.spec2 then return end

  if not self.Module then return end

  local anchorPoint = WB:GetGrowDirection(self.Module, true)
  local maxWidth = WB:GetMaxWidth(self.Module)
  local iconSize = self.db.general.showIcons and self.db.general.iconFontSize or 0.01

  local iconOffset = 3
  local iconPadding = 5
  local iconSpace = iconSize + (iconPadding * 2)

  local showBoth = ((self.spec1 and self.db.general.showSpec1 and self.spec2 and self.db.general.showSpec2) and not self.forceHideSpec2)
  local primaryFrame = showBoth and self.spec1Frame or self.spec2Frame
  local primaryText = showBoth and self.spec1Text or self.spec2Text
  local primaryIcon = showBoth and self.spec1Icon or self.spec2Icon
  local secondaryFrame = showBoth and self.spec2Frame or self.spec1Frame
  local secondaryText = showBoth and self.spec2Text or self.spec1Text
  local secondaryIcon = showBoth and self.spec2Icon or self.spec1Icon

  primaryFrame:ClearAllPoints()
  secondaryFrame:ClearAllPoints()

  primaryText:ClearAllPoints()
  secondaryText:ClearAllPoints()

  primaryIcon:ClearAllPoints()
  secondaryIcon:ClearAllPoints()

  primaryIcon:SetJustifyH("RIGHT")
  secondaryText:SetJustifyH("RIGHT")

  local primaryOffset, secondaryOffset, primaryFrameOffset, secondaryFrameOffset = 0, 0, 0, 0

  if not self.forceHideSpec2 and showBoth then
    if anchorPoint == "RIGHT" then
      primaryOffset = -(secondaryText:GetStringWidth() + iconSize + (iconPadding * 4))
      primaryFrameOffset = primaryOffset
    else
      primaryOffset = iconSpace
      secondaryOffset = (primaryText:GetStringWidth() + (iconSpace * 2) + (iconPadding * 2))
      secondaryFrameOffset = (primaryText:GetStringWidth() + iconSpace + (iconPadding * 2))
    end
  else
    if anchorPoint == "LEFT" then secondaryOffset = iconSpace end
  end

  primaryText:SetJustifyH(anchorPoint)
  secondaryText:SetJustifyH(anchorPoint)

  primaryFrame:SetSize(primaryText:GetStringWidth() + iconSpace, self.frame:GetHeight())
  secondaryFrame:SetSize(secondaryText:GetStringWidth() + iconSpace, self.frame:GetHeight())

  primaryFrame:SetPoint(anchorPoint, self.frame, anchorPoint, primaryFrameOffset, 0)
  primaryText:SetPoint(anchorPoint, self.frame, anchorPoint, primaryOffset, 0)

  secondaryFrame:SetPoint(anchorPoint, self.frame, anchorPoint, secondaryFrameOffset, 0)
  secondaryText:SetPoint(anchorPoint, self.frame, anchorPoint, secondaryOffset, 0)

  primaryIcon:SetPoint("RIGHT", primaryText, "LEFT", -iconPadding, iconOffset - 0)
  secondaryIcon:SetPoint("RIGHT", secondaryText, "LEFT", -iconPadding, iconOffset - 0)

  self.infoText:ClearAllPoints()
  self.infoText:SetPoint("CENTER", secondaryText, "CENTER", 0, WB.dirMulti * self.db.general.infoOffset)

  if not self.forceHideSpec2 and (self.spec1 and self.spec2) then
    local totalWidth = (primaryText:GetStringWidth() + iconSpace)
    totalWidth = totalWidth + (secondaryText:GetStringWidth() + iconSpace)

    if totalWidth > maxWidth then
      self.forceHideSpec2 = true
      secondaryFrame:Hide()
      self:UpdatePosition()
    end
  end
end

function SS:UpdateInfoText()
  if self.db.general.infoEnabled and not (self.db.general.showSpec1 and self.db.general.showSpec2) and self.infoSpec then
    if self.db.general.infoShowIcon and not self.db.general.showSpec2 then
      WB:SetFontFromDB(self.db.general, "info", self.infoText, false, false, WB.db.general.iconFont)

      if not self.db.general.infoUseAccent then
        WB:SetFontIconColor(self.infoText)
      else
        WB:SetFontAccentColor(self.infoText)
      end

      local info = self.specCache[self.infoSpec]

      local iconTexture = (info and info.name) and self.db.icons[info.id]
      self.infoText:SetText(iconTexture or self.db.general.infoIcon)
    else
      local info = self.specCache[self.infoSpec]

      if info and info.name then
        WB:SetFontFromDB(self.db.general, "info", self.infoText, true, self.db.general.infoUseAccent)
        self.infoText:SetText(self.db.general.useUppercase and F.String.Uppercase(info.name) or info.name)
      end
    end
  else
    WB:SetFontFromDB(self.db.general, "info", self.infoText, true, self.db.general.infoUseAccent)
    self.infoText:SetText("")
  end
end

function SS:UpdateElement(spec, frame, icon, text, isSecondary)
  local info = self.specCache[spec]
  local loadoutName = SS:GetLoadoutName()

  if info and info.name then
    frame:Show()

    if loadoutName and not isSecondary and self.db.general.showLoadout then
      text:SetText(self.db.general.useUppercase and F.String.Uppercase(loadoutName) or loadoutName)
    else
      text:SetText(self.db.general.useUppercase and F.String.Uppercase(info.name) or info.name)
    end

    if self.db.general.showIcons then
      local iconTexture = self.db.icons[info.id or spec]

      if not iconTexture then
        iconTexture = self.db.icons[0]
        self:LogDebug("Icon could not be found", info.id, spec)
      end

      icon:Show()
      icon:SetText(iconTexture)
    else
      icon:Hide()
    end
  else
    frame:Hide()
  end
end

function SS:UpdateElements()
  self:UpdateElement(self.spec1, self.spec1Frame, self.spec1Icon, self.spec1Text)
  self:UpdateElement(self.spec2, self.spec2Frame, self.spec2Icon, self.spec2Text, true)
  self.forceHideSpec2 = false
end

function SS:UpdateSwitch()
  WB:SetFontFromDB(self.db.general, "main", self.spec1Text)
  WB:SetFontFromDB(self.db.general, "main", self.spec2Text)

  WB:SetIconFromDB(self.db.general, "icon", self.spec1Icon)
  WB:SetIconFromDB(self.db.general, "icon", self.spec2Icon)
end

function SS:CreateSwitch()
  -- Frames
  local spec1Frame = CreateFrame("Button", nil, self.frame, "SecureActionButtonTemplate")
  local spec2Frame = CreateFrame("Button", nil, self.frame, "SecureActionButtonTemplate")
  spec1Frame.spec = "spec1"
  spec2Frame.spec = "spec2"

  spec1Frame:SetPoint("CENTER")
  spec2Frame:SetPoint("CENTER")

  local onEnter = function(...)
    WB:ModuleOnEnter(self, ...)
  end

  local onLeave = function(...)
    WB:ModuleOnLeave(self, ...)
  end

  local onClick = function(...)
    WB:ModuleOnClick(self, ...)
  end

  spec1Frame:SetScript("OnEnter", onEnter)
  spec2Frame:SetScript("OnEnter", onEnter)

  spec1Frame:SetScript("OnLeave", onLeave)
  spec2Frame:SetScript("OnLeave", onLeave)

  spec1Frame:RegisterForClicks(GetCVarBool("ActionButtonUseKeyDown") and "AnyDown" or "AnyUp")
  spec2Frame:RegisterForClicks(GetCVarBool("ActionButtonUseKeyDown") and "AnyDown" or "AnyUp")

  spec1Frame:SetScript("OnClick", onClick)
  spec2Frame:SetScript("OnClick", onClick)

  self.spec1Frame = spec1Frame
  self.spec2Frame = spec2Frame

  -- Font Strings
  local spec1Text = spec1Frame:CreateFontString(nil, "OVERLAY")
  local spec1Icon = spec1Frame:CreateFontString(nil, "OVERLAY")
  local spec2Text = spec2Frame:CreateFontString(nil, "OVERLAY")
  local spec2Icon = spec2Frame:CreateFontString(nil, "OVERLAY")

  spec1Text:SetPoint("CENTER")
  spec1Icon:SetPoint("CENTER")
  spec2Text:SetPoint("CENTER")
  spec2Icon:SetPoint("CENTER")

  self.spec1Text = spec1Text
  self.spec1Icon = spec1Icon
  self.spec2Text = spec2Text
  self.spec2Icon = spec2Icon

  local infoText = spec1Frame:CreateFontString(nil, "OVERLAY")
  self.infoText = infoText
end

function SS:OnInit()
  -- Get our settings DB
  self.db = WB:GetSubModuleDB(self:GetName())

  -- Reuqest to extend
  WB:RequestToExtend(self.Module)

  -- Don't init second time
  if self.Initialized then return end

  -- Vars
  self.frame = self.SubModuleHolder
  self.spec1 = nil
  self.spec2 = nil
  self.infoSpec = nil
  self.forceHideSpec2 = false

  self.numSpecs = 2
  self.specCache = {}

  if TXUI.IsRetail then
    local _, classId = UnitClassBase("player")
    self.numSpecs = GetNumSpecializationsForClassID(classId)
    for i = 1, self.numSpecs do
      local id, name = GetSpecializationInfoForClassID(classId, i)
      if id then self.specCache[i] = { id = id, name = name } end
    end
  elseif TXUI.IsMists then
    self.numSpecs = GetNumSpecializations()
    for i = 1, self.numSpecs do
      local id, name = GetTalentTabInfo(i)
      if id and name then self.specCache[i] = {
        id = id,
        name = name,
      } end
    end
  end

  self:CreateSwitch()
  self:OnWunderBarUpdate()

  -- We are done, hooray!
  self.Initialized = true
end

WB:RegisterSubModule(
  SS,
  F.Table.Join(
    {
      "CHARACTER_POINTS_CHANGED",
      "PLAYER_TALENT_UPDATE",
      "ACTIVE_TALENT_GROUP_CHANGED",
    },
    F.Table.If(TXUI.IsRetail, {
      "PLAYER_LOOT_SPEC_UPDATED",
      "ACTIVE_COMBAT_CONFIG_CHANGED",
      "CONFIG_COMMIT_FAILED",
      "STARTER_BUILD_ACTIVATION_FAILED",
      "TRAIT_CONFIG_CREATED",
      "TRAIT_CONFIG_DELETED",
      "TRAIT_CONFIG_LIST_UPDATED",
      "TRAIT_CONFIG_UPDATED",
      "TRAIT_TREE_CHANGED",
    }),
    F.Table.If(TXUI.IsMists, { "TALENT_GROUP_ROLE_CHANGED", "PLAYER_LOOT_SPEC_UPDATED" })
  )
)
