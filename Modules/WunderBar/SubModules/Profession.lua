local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local WB = TXUI:GetModule("WunderBar")
local PR = WB:NewModule("Profession")
local DT = E:GetModule("DataTexts")

local C_TradeSkillUI = C_TradeSkillUI
local CreateFrame = CreateFrame
local format = string.format
local GetCVarBool = GetCVarBool
local GetNumSkillLines = GetNumSkillLines
local GetProfessionInfo = GetProfessionInfo
local GetProfessions = GetProfessions
local GetSkillLineInfo = GetSkillLineInfo
local ipairs = ipairs
local lower = string.lower
local next = next
local securecall = securecall
local tinsert = table.insert
local utf8sub = string.utf8sub

local PROFESSIONS_COOKING = PROFESSIONS_COOKING
local PROFESSIONS_FIRST_AID = PROFESSIONS_FIRST_AID
local PROFESSIONS_FISHING = PROFESSIONS_FISHING

function PR:OnEvent()
  self:OnWunderBarUpdate()
end

function PR:OnEnter(frame)
  if frame and frame.prof and frame:IsShown() then
    if frame.prof == "prof1" then
      self:ProfessionEnter(self.prof1Text, self.prof1Icon, self.prof1Bar)
    elseif frame.prof == "prof2" then
      self:ProfessionEnter(self.prof2Text, self.prof2Icon, self.prof2Bar)
    end
  end
end

function PR:OnLeave(frame)
  if frame and frame.prof and frame:IsShown() then
    if frame.prof == "prof1" then
      self:ProfessionLeave(self.prof1Text, self.prof1Icon, self.prof1Bar)
    elseif frame.prof == "prof2" then
      self:ProfessionLeave(self.prof2Text, self.prof2Icon, self.prof2Bar)
    end
  end
end

function PR:OnClick(frame, button)
  if frame and frame.prof and frame:IsShown() then
    if frame.prof == "prof1" then
      self:ProfessionClick(self.prof1, frame, button)
    elseif frame.prof == "prof2" then
      self:ProfessionClick(self.prof2, frame, button)
    end
  end
end

function PR:ProfessionEnter(text, icon, bar)
  WB:SetFontAccentColor(text)
  WB:SetFontAccentColor(icon)

  WB:SetAccentColorFunc(bar, "statusbar")
  WB:SetAccentColorFunc(bar.background, "vertex", 0.35)

  self:ProfessionTooltip()
end

function PR:ProfessionLeave(text, icon, bar)
  WB:SetFontNormalColor(text)
  WB:SetFontIconColor(icon)

  WB:SetNormalColorFunc(bar, "statusbar")
  WB:SetNormalColorFunc(bar.background, "vertex", 0.35)
end

function PR:ProfessionClick(prof, frame, button)
  if button == "RightButton" then
    local menuList = {}

    for index, _ in next, self.others do
      local profId = self.others[index]
      local skillLine, name, _, _, icon, extraSpellId = self:GetProfessionInfo(profId)
      -- 182 is Herablism skillLine ID
      -- 193290 is the Herbalism Journal ID
      if TXUI.IsRetail and skillLine == 182 then extraSpellId = 193290 end
      if skillLine then
        tinsert(menuList, {
          spellID = extraSpellId or name,
          icon = icon,
          type = "function",
          func = function()
            self:ProfessionOpen(profId)
          end,
        })
      end

      -- Cooking Fire
      if skillLine == 185 then
        local cookingFireSpellId = 818
        tinsert(menuList, {
          spellID = cookingFireSpellId,
          type = "spell",
        })
      end
    end

    local flyoutDirection = E.db.TXUI.wunderbar.general.position == "TOP" and "DOWN" or "UP"
    WB:ShowSecureFlyOut(frame, flyoutDirection, menuList)
  else
    self:ProfessionOpen(prof)
  end
end

function PR:ProfessionOpen(prof)
  local skillLine, name, _, _, _, extraSpellId = self:GetProfessionInfo(prof)

  if TXUI.IsRetail then
    local currBaseProfessionInfo = C_TradeSkillUI.GetBaseProfessionInfo()
    local isShown = _G["ProfessionsFrame"] and _G["ProfessionsFrame"]:IsShown()

    if isShown and currBaseProfessionInfo ~= nil and currBaseProfessionInfo.professionID == skillLine then
      C_TradeSkillUI.CloseTradeSkill()
    elseif skillLine then
      C_TradeSkillUI.OpenTradeSkill(skillLine) -- TODO: REPLACE with global when blizz pushes beta branch to retail
    end
  else
    if extraSpellId then name = E:GetSpellInfo(extraSpellId) end
    securecall("CastSpellByName", name)
  end
end

function PR:ProfessionTooltip()
  DT.tooltip:AddLine("Professions")
  DT.tooltip:AddLine(" ")

  for index, _ in next, self.others do
    local skillLine, name, rank, maxRank, icon = self:GetProfessionInfo(self.others[index])

    if skillLine or (name and rank and maxRank) then
      local texture = icon and format("|T%s:16:18:0:0:64:64:4:60:7:57:255:255:255|t ", icon) or nil
      local r, g, b = F.SlowColorGradient(rank / maxRank, 1, 0.1, 0.1, 1, 1, 0.1, 0.1, 1, 0.1)
      DT.tooltip:AddDoubleLine((texture or "") .. name, rank .. "/" .. maxRank, 1, 1, 1, r, g, b)
    end
  end

  DT.tooltip:AddLine(" ")
  DT.tooltip:AddLine("|cffFFFFFFLeft Click:|r Toggle Profession Window")
  DT.tooltip:AddLine("|cffFFFFFFRight Click:|r Show all Professions")
  DT.tooltip:Show()
end

function PR:OnWunderBarUpdate()
  F.Event.ContinueOutOfCombat(function()
    self:UpdateProfession()
    self:UpdateColors()
    self:UpdateElements()
    self:UpdatePosition()
  end)
end

function PR:GetProfessions()
  if TXUI.IsRetail then
    return GetProfessions()
  else
    local professions = {
      first = nil,
      second = nil,
      cooking = nil,
      first_aid = nil,
      fishing = nil,
      archaeology = nil,
    }

    for skillIndex = 1, GetNumSkillLines() do
      local skillName, isHeader, _, _, _, _, _, isAbandonable = GetSkillLineInfo(skillIndex)
      if skillName and not isHeader then
        if isAbandonable then
          if not professions.first then
            professions.first = skillIndex
          else
            professions.second = skillIndex
          end
        else
          local skillNameLower = lower(skillName)
          if skillName == PROFESSIONS_COOKING or skillNameLower == lower(PROFESSIONS_COOKING) then
            professions.cooking = skillIndex
          elseif skillName == PROFESSIONS_FIRST_AID or skillNameLower == lower(PROFESSIONS_FIRST_AID) then
            professions.first_aid = skillIndex
          elseif skillName == PROFESSIONS_FISHING or skillNameLower == lower(PROFESSIONS_FISHING) then
            professions.fishing = skillIndex
          elseif skillName == PROFESSIONS_ARCHAEOLOGY or skillNameLower == lower(PROFESSIONS_ARCHAEOLOGY) then
            professions.archaeology = skillIndex
          end
        end
      end
    end

    return professions.first, professions.second, professions.archaeology, professions.fishing, professions.cooking, professions.first_aid
  end
end

do
  local professionInfoTable

  function PR:GetWrathProfessionInfo()
    if professionInfoTable ~= nil then return professionInfoTable end

    professionInfoTable = {}
    local professionMap = {
      { spellIds = { 3273, 3274, 7924, 10846, 27028, 45542, 74559, 110406, 158741, 195113 }, skillLine = 129, texture = 135966 }, -- First Aid
      { spellIds = { 2018, 3100, 3538, 9785, 29844, 51300, 76666, 110396, 158737, 195097 }, skillLine = 164, texture = 136241 }, -- Blacksmithing
      { spellIds = { 2108, 3104, 3811, 10662, 32549, 51302, 81199, 110423, 158752, 195119 }, skillLine = 165, texture = 133611 }, -- Leatherworking
      { spellIds = { 2259, 3101, 3464, 11611, 28596, 51304, 80731, 105206 }, skillLine = 171, texture = 136240 }, -- Alchemy
      { spellIds = { 9134 }, extraSpellId = 2383, skillLine = 182, texture = 136246 }, -- Herbalism
      { spellIds = { 32606, 2575, 2576, 3564, 10248 }, extraSpellId = 2656, skillLine = 186, texture = 136248 }, -- Mining
      { spellIds = { 4036, 4037, 4038, 12656, 30350, 51306, 82774, 110403, 158739, 195112 }, skillLine = 202, texture = 136243 }, -- Engineering
      { spellIds = { 7411, 7412, 7413, 13920, 28029, 51313, 74258, 110400, 158716, 195096 }, skillLine = 333, texture = 136244 }, -- Enchanting
      { spellIds = { 7620 }, skillLine = 356, texture = 136245 }, -- Fishing
      { spellIds = { 2550, 3102, 3413, 18260, 33359, 51296, 88053, 104381, 158765, 195128 }, skillLine = 185, texture = 133971 }, -- Cooking
      { spellIds = { 3908, 3909, 3910, 12180, 26790, 51309, 75156, 110426, 158758, 195126 }, skillLine = 197, texture = 136249 }, -- Tailoring
      { spellIds = { 8613 }, skillLine = 393, texture = 134366 }, -- Skinning
    }

    if not TXUI.IsVanilla then
      -- We can't use F.Table.Crush here, because the tables do not have unique keys and
      -- therefore JC & Inscription override Blacksmithing & First Aid (as they're the first entries)

      -- Jewelcrafting
      tinsert(professionMap, { spellIds = { 25229, 25230, 28894, 28895, 28897, 51311, 73318, 110420, 158750, 195116 }, skillLine = 755, texture = 134071 })

      -- Inscription
      tinsert(professionMap, { spellIds = { 45357, 45358, 45359, 45360, 45361, 45363, 86008, 110417, 158748, 195115 }, skillLine = 773, texture = 237171 })

      -- Archaeology
      tinsert(professionMap, { spellIds = { 78670, 89721, 89722, 89718, 89720, 89719, 88961 }, skillLine = 794, texture = 441139 })
    end

    local function searchLocaleSpellName(ids, texture)
      for _, spellId in ipairs(ids) do
        local spellName, _, iconID = E:GetSpellInfo(spellId)
        if texture == iconID then return spellName end
      end
    end

    for _, prof in ipairs(professionMap) do
      local spellName = searchLocaleSpellName(prof.spellIds, prof.texture)

      if not spellName then
        self:LogDebug("Could not get spell info for profession with textureId", prof.texture)
      else
        professionInfoTable[spellName] = prof
      end
    end

    return professionInfoTable
  end
end

function PR:GetProfessionInfo(prof)
  if not prof then return end

  if TXUI.IsRetail then
    local skillName, texture, skillRank, skillMaxRank, _, _, skillLine = GetProfessionInfo(prof)
    return skillLine, skillName, skillRank, skillMaxRank, texture
  else
    local skillName, _, _, skillRank, _, _, skillMaxRank = GetSkillLineInfo(prof)
    local info = self:GetWrathProfessionInfo()[skillName] or {}
    return info.skillLine, skillName, skillRank, skillMaxRank, info.texture, info.extraSpellId
  end
end

function PR:UpdateProfession()
  local prof1, prof2, archaeology, fishing, cooking, first_aid = self:GetProfessions()

  self.prof1 = nil
  self.prof2 = nil
  self.others = {}

  -- Prof1
  if self.db.general.selectedProf1 == 1 then
    self.prof1 = prof1
  elseif self.db.general.selectedProf1 ~= 0 then
    local skillLineLearned = self:GetProfessionInfo(self.db.general.selectedProf1)

    if skillLineLearned then
      self.prof1 = self.db.general.selectedProf1
    else
      self.prof1 = prof1
    end
  end

  -- Prof2
  if self.db.general.selectedProf2 == 1 then
    self.prof2 = prof2
  elseif self.db.general.selectedProf2 ~= 0 then
    local skillLineLearned = self:GetProfessionInfo(self.db.general.selectedProf2)

    if skillLineLearned then
      self.prof2 = self.db.general.selectedProf2
    else
      self.prof2 = prof2
    end
  end

  -- Set Prof2 as Prof1 when Prof1 was not found
  if not self.prof1 and self.prof2 then
    self.prof1 = prof2
    self.prof2 = nil
  end

  self.others = { prof1, prof2, cooking, fishing, archaeology, first_aid }
end

function PR:UpdatePosition()
  if not self.prof1 and not self.prof2 then return end

  local anchorPoint = WB:GetGrowDirection(self.Module, true)
  local maxWidth = WB:GetMaxWidth(self.Module)
  local iconSize = self.db.general.showIcons and self.db.general.iconFontSize or 0.01
  local barOffset = self.db.general.showBars and (-self.db.general.barSpacing + self.db.general.barOffset) or 0
  local barTextOffset = self.db.general.showBars and (self.db.general.barSpacing + self.db.general.barOffset + self.db.general.barHeight) or 0

  local iconOffset = 3
  local iconPadding = 5
  local iconSpace = iconSize + (iconPadding * 2)

  local showBoth = ((self.prof1 and self.prof2) and not self.forceHideProf2)
  local primaryFrame = showBoth and self.prof1Frame or self.prof2Frame
  local primaryText = showBoth and self.prof1Text or self.prof2Text
  local primaryIcon = showBoth and self.prof1Icon or self.prof2Icon
  local primaryBar = showBoth and self.prof1Bar or self.prof2Bar
  local secondaryFrame = showBoth and self.prof2Frame or self.prof1Frame
  local secondaryText = showBoth and self.prof2Text or self.prof1Text
  local secondaryIcon = showBoth and self.prof2Icon or self.prof1Icon
  local secondaryBar = showBoth and self.prof2Bar or self.prof1Bar

  primaryFrame:ClearAllPoints()
  secondaryFrame:ClearAllPoints()

  primaryText:ClearAllPoints()
  secondaryText:ClearAllPoints()

  primaryIcon:ClearAllPoints()
  secondaryIcon:ClearAllPoints()

  primaryBar:ClearAllPoints()
  secondaryBar:ClearAllPoints()

  primaryIcon:SetJustifyH("RIGHT")
  secondaryText:SetJustifyH("RIGHT")

  primaryBar:SetSize(primaryText:GetStringWidth() or 0, self.db.general.barHeight)
  secondaryBar:SetSize(secondaryText:GetStringWidth() or 0, self.db.general.barHeight)

  local primaryOffset, secondaryOffset, primaryFrameOffset, secondaryFrameOffset = 0, 0, 0, 0

  if showBoth then
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
  primaryText:SetPoint(anchorPoint, self.frame, anchorPoint, primaryOffset, barTextOffset)
  primaryBar:SetPoint(anchorPoint, self.frame, anchorPoint, primaryOffset, barOffset)

  secondaryFrame:SetPoint(anchorPoint, self.frame, anchorPoint, secondaryFrameOffset, 0)
  secondaryText:SetPoint(anchorPoint, self.frame, anchorPoint, secondaryOffset, barTextOffset)
  secondaryBar:SetPoint(anchorPoint, self.frame, anchorPoint, secondaryOffset, barOffset)

  primaryIcon:SetPoint("RIGHT", primaryText, "LEFT", -iconPadding, iconOffset - barTextOffset)
  secondaryIcon:SetPoint("RIGHT", secondaryText, "LEFT", -iconPadding, iconOffset - barTextOffset)

  if not self.forceHideProf2 and (self.prof1 and self.prof2) then
    local totalWidth = (primaryText:GetStringWidth() + iconSpace)
    totalWidth = totalWidth + (secondaryText:GetStringWidth() + iconSpace)

    if totalWidth > maxWidth then
      self.forceHideProf2 = true
      secondaryFrame:Hide()
      self:UpdatePosition()
    end
  end
end

function PR:UpdateElement(prof, frame, icon, text, bar)
  local skillLine, name, rank, maxRank = self:GetProfessionInfo(prof)

  if skillLine or (name and rank and maxRank) then
    frame:Show()
    if self.db.general.abbreviate then
      name = self.db.abbreviations[skillLine]
    else
      name = utf8sub(name, 1, self.db.general.limitChar)
    end
    text:SetText(self.db.general.useUppercase and F.String.Uppercase(name) or name)

    if self.db.general.showIcons and skillLine then
      icon:Show()
      icon:SetText(self.db.icons[skillLine])
    else
      icon:Hide()
    end

    if self.db.general.showBars then
      bar:Show()
      bar:SetMinMaxValues(0, maxRank)
      bar:SetValue(rank)
    else
      bar:Hide()
    end
  else
    frame:Hide()
  end
end

function PR:UpdateElements()
  self:UpdateElement(self.prof1, self.prof1Frame, self.prof1Icon, self.prof1Text, self.prof1Bar)
  self:UpdateElement(self.prof2, self.prof2Frame, self.prof2Icon, self.prof2Text, self.prof2Bar)
  self.forceHideProf2 = false
end

function PR:UpdateColors()
  WB:SetFontFromDB(nil, nil, self.prof1Text)
  WB:SetFontFromDB(nil, nil, self.prof2Text)

  WB:SetIconFromDB(self.db.general, "icon", self.prof1Icon)
  WB:SetIconFromDB(self.db.general, "icon", self.prof2Icon)

  local fontColor = WB:GetFontNormalColor()
  self.prof1Bar:SetStatusBarColor(fontColor.r, fontColor.g, fontColor.b, fontColor.a)
  self.prof2Bar:SetStatusBarColor(fontColor.r, fontColor.g, fontColor.b, fontColor.a)
  self.prof1Bar.background:SetColorTexture(fontColor.r, fontColor.g, fontColor.b, fontColor.a * 0.35)
  self.prof2Bar.background:SetColorTexture(fontColor.r, fontColor.g, fontColor.b, fontColor.a * 0.35)
end

function PR:CreateProfessions()
  -- Frames
  local prof1Frame = CreateFrame("Button", nil, self.frame, "SecureActionButtonTemplate")
  local prof2Frame = CreateFrame("Button", nil, self.frame, "SecureActionButtonTemplate")
  prof1Frame.prof = "prof1"
  prof2Frame.prof = "prof2"

  prof1Frame:SetPoint("CENTER")
  prof2Frame:SetPoint("CENTER")

  local onEnter = function(...)
    WB:ModuleOnEnter(self, ...)
  end

  local onLeave = function(...)
    WB:ModuleOnLeave(self, ...)
  end

  local onClick = function(...)
    WB:ModuleOnClick(self, ...)
  end

  prof1Frame:SetScript("OnEnter", onEnter)
  prof2Frame:SetScript("OnEnter", onEnter)

  prof1Frame:SetScript("OnLeave", onLeave)
  prof2Frame:SetScript("OnLeave", onLeave)

  prof1Frame:RegisterForClicks(GetCVarBool("ActionButtonUseKeyDown") and "AnyDown" or "AnyUp")
  prof2Frame:RegisterForClicks(GetCVarBool("ActionButtonUseKeyDown") and "AnyDown" or "AnyUp")

  prof1Frame:SetScript("OnClick", onClick)
  prof2Frame:SetScript("OnClick", onClick)

  self.prof1Frame = prof1Frame
  self.prof2Frame = prof2Frame

  -- Font Strings
  local prof1Text = prof1Frame:CreateFontString(nil, "OVERLAY")
  local prof1Icon = prof1Frame:CreateFontString(nil, "OVERLAY")
  local prof2Text = prof2Frame:CreateFontString(nil, "OVERLAY")
  local prof2Icon = prof2Frame:CreateFontString(nil, "OVERLAY")

  prof1Text:SetPoint("CENTER")
  prof1Icon:SetPoint("CENTER")
  prof2Text:SetPoint("CENTER")
  prof2Icon:SetPoint("CENTER")

  self.prof1Text = prof1Text
  self.prof1Icon = prof1Icon
  self.prof2Text = prof2Text
  self.prof2Icon = prof2Icon

  -- Bars
  local prof1Bar = CreateFrame("STATUSBAR", nil, prof1Frame)
  local prof2Bar = CreateFrame("STATUSBAR", nil, prof2Frame)

  prof1Bar:SetStatusBarTexture(E.media.blankTex)
  prof1Bar:SetStatusBarColor(1, 1, 1, 1)
  prof2Bar:SetStatusBarTexture(E.media.blankTex)
  prof2Bar:SetStatusBarColor(1, 1, 1, 1)

  prof1Bar.background = prof1Bar:CreateTexture(nil, "BACKGROUND")
  prof2Bar.background = prof2Bar:CreateTexture(nil, "BACKGROUND")

  prof1Bar.background:SetAllPoints()
  prof2Bar.background:SetAllPoints()

  self.prof1Bar = prof1Bar
  self.prof2Bar = prof2Bar
end

function PR:OnInit()
  -- Get our settings DB
  self.db = WB:GetSubModuleDB(self:GetName())

  -- Reuqest to extend
  WB:RequestToExtend(self.Module)

  -- Don't init second time
  if self.Initialized then return end

  -- Vars
  self.frame = self.SubModuleHolder
  self.prof1 = nil
  self.prof2 = nil
  self.others = {}

  self:CreateProfessions()
  self:OnWunderBarUpdate()

  -- We are done, hooray!
  self.Initialized = true
end

WB:RegisterSubModule(PR, { "TRADE_SKILL_NAME_UPDATE", "SKILL_LINES_CHANGED", "TRIAL_STATUS_UPDATE" })
