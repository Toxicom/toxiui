local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local M = TXUI:GetModule("Misc")

-- This is a changed version of ElvUIs StatusReport
-- Credits to ElvUI's Team
-- File: Core/StatusReport.lua

local wipe, sort, format = wipe, sort, string.format
local next, pairs, ipairs, tinsert = next, pairs, ipairs, tinsert

local CreateFrame = CreateFrame
local GetAddOnMetadata = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata
local GetRealZoneText = GetRealZoneText
local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo
local UNKNOWN = UNKNOWN

local englishClassName = {
  DEATHKNIGHT = "Death Knight",
  DEMONHUNTER = "Demon Hunter",
  DRUID = "Druid",
  EVOKER = "Evoker",
  HUNTER = "Hunter",
  MAGE = "Mage",
  MONK = "Monk",
  PALADIN = "Paladin",
  PRIEST = "Priest",
  ROGUE = "Rogue",
  SHAMAN = "Shaman",
  WARLOCK = "Warlock",
  WARRIOR = "Warrior",
}

local englishSpecName = {
  [250] = "Blood",
  [251] = "Frost",
  [252] = "Unholy",
  [102] = "Balance",
  [103] = "Feral",
  [104] = "Guardian",
  [105] = "Restoration",
  [253] = "Beast Mastery",
  [254] = "Marksmanship",
  [255] = "Survival",
  [62] = "Arcane",
  [63] = "Fire",
  [64] = "Frost",
  [268] = "Brewmaster",
  [270] = "Mistweaver",
  [269] = "Windwalker",
  [65] = "Holy",
  [66] = "Protection",
  [70] = "Retribution",
  [256] = "Discipline",
  [257] = "Holy",
  [258] = "Shadow",
  [259] = "Assasination",
  [260] = "Combat",
  [261] = "Sublety",
  [262] = "Elemental",
  [263] = "Enhancement",
  [264] = "Restoration",
  [265] = "Affliction",
  [266] = "Demonoligy",
  [267] = "Destruction",
  [71] = "Arms",
  [72] = "Fury",
  [73] = "Protection",
  [577] = "Havoc",
  [581] = "Vengeance",
  [1467] = "Devastation",
  [1468] = "Preservation",
  [1473] = "Augmentation",
}

local function getSpecName()
  return englishSpecName[GetSpecializationInfo(GetSpecialization())] or UNKNOWN
end

function M:StatusReportCreateContent(num, width, parent, anchorTo, content)
  if not content then content = CreateFrame("Frame", nil, parent) end
  content:SetSize(width, (num * 20) + ((num - 1) * 5)) -- 20 height and 5 spacing
  content:SetPoint("TOP", anchorTo, "BOTTOM")

  local font = F.GetFontPath(I.Fonts.Primary)
  for i = 1, num do
    if not content["Line" .. i] then
      local line = CreateFrame("Frame", nil, content)
      line:SetSize(width, 20)

      local text = line:CreateFontString(nil, "ARTWORK")
      text:SetAllPoints()
      text:SetJustifyH("LEFT")
      text:SetJustifyV("MIDDLE")
      text:FontTemplate(font, 14, "OUTLINE", true)
      line.Text = text

      if i == 1 then
        line:SetPoint("TOP", content, "TOP")
      else
        line:SetPoint("TOP", content["Line" .. (i - 1)], "BOTTOM", 0, -5)
      end

      content["Line" .. i] = line
    end
  end

  return content
end

function M:StatusReportCreateSection(width, height, headerWidth, headerHeight, parent, anchor1, anchorTo, anchor2, yOffset)
  local parentWidth, parentHeight = parent:GetSize()

  if width > parentWidth then parent:SetWidth(width + 25) end
  if height then parent:SetHeight(parentHeight + height) end

  local section = CreateFrame("Frame", nil, parent)
  section:SetSize(width, height or 0)
  section:SetPoint(anchor1, anchorTo, anchor2, 0, yOffset)

  local header = CreateFrame("Frame", nil, section)
  header:SetSize(headerWidth or width, headerHeight)
  header:SetPoint("TOP", section)
  section.Header = header

  local font = F.GetFontPath(I.Fonts.Primary)
  local text = section.Header:CreateFontString(nil, "ARTWORK")
  text:SetPoint("TOP")
  text:SetPoint("BOTTOM")
  text:SetJustifyH("CENTER")
  text:SetJustifyV("MIDDLE")
  text:FontTemplate(font, 18, "NONE", true)
  section.Header.Text = text

  local leftDivider = section.Header:CreateTexture(nil, "ARTWORK")
  leftDivider:SetHeight(2)
  leftDivider:SetPoint("LEFT", section.Header, "LEFT", 5, 0)
  leftDivider:SetPoint("RIGHT", section.Header.Text, "LEFT", -5, 0)
  leftDivider:SetTexture(E.media.blankTex)
  leftDivider:SetVertexColor(1, 1, 1, 1)
  F.Color.SetGradientRGB(
    leftDivider,
    "HORIZONTAL",
    I.Strings.Branding.ColorRGBA.r,
    I.Strings.Branding.ColorRGBA.g,
    I.Strings.Branding.ColorRGBA.b,
    0,
    I.Strings.Branding.ColorRGBA.r,
    I.Strings.Branding.ColorRGBA.g,
    I.Strings.Branding.ColorRGBA.b,
    I.Strings.Branding.ColorRGBA.a
  )
  section.Header.LeftDivider = leftDivider

  local rightDivider = section.Header:CreateTexture(nil, "ARTWORK")
  rightDivider:SetHeight(2)
  rightDivider:SetPoint("RIGHT", section.Header, "RIGHT", -5, 0)
  rightDivider:SetPoint("LEFT", section.Header.Text, "RIGHT", 5, 0)
  rightDivider:SetTexture(E.media.blankTex)
  rightDivider:SetVertexColor(1, 1, 1, 1)
  F.Color.SetGradientRGB(
    rightDivider,
    "HORIZONTAL",
    I.Strings.Branding.ColorRGBA.r,
    I.Strings.Branding.ColorRGBA.g,
    I.Strings.Branding.ColorRGBA.b,
    I.Strings.Branding.ColorRGBA.a,
    I.Strings.Branding.ColorRGBA.r,
    I.Strings.Branding.ColorRGBA.g,
    I.Strings.Branding.ColorRGBA.b,
    0
  )
  section.Header.RightDivider = rightDivider

  return section
end

function M:StatusReportCreate()
  -- Main frame
  local statusFrame = CreateFrame("Frame", "TXUIStatusReport", E.UIParent)
  statusFrame:SetPoint("CENTER", E.UIParent, "CENTER")
  statusFrame:SetFrameStrata("HIGH")
  statusFrame:CreateBackdrop("Transparent")
  statusFrame:CreateCloseButton()
  statusFrame:SetMovable(true)
  statusFrame:SetSize(0, 100)
  statusFrame:Hide()

  -- Plugin frame
  local pluginFrame = CreateFrame("Frame", nil, statusFrame)
  pluginFrame:SetPoint("TOPLEFT", statusFrame, "TOPRIGHT", E:Scale(E.Border * 2 + 1), 0)
  pluginFrame:SetFrameStrata("HIGH")
  pluginFrame:CreateBackdrop("Transparent")
  pluginFrame:SetSize(0, 25)
  statusFrame.AddOnFrame = pluginFrame

  -- Title logo (drag to move frame)
  local titleLogoFrame = CreateFrame("Frame", nil, statusFrame, "TitleDragAreaTemplate")
  titleLogoFrame:SetPoint("CENTER", statusFrame, "TOP")
  titleLogoFrame:SetSize(240, 80)
  statusFrame.TitleLogoFrame = titleLogoFrame

  local logoTop = statusFrame.TitleLogoFrame:CreateTexture(nil, "ARTWORK")
  logoTop:SetPoint("CENTER", titleLogoFrame, "TOP", 0, -85)
  logoTop:SetTexture(I.Media.Logos.Logo)
  logoTop:SetSize(128, 64)
  titleLogoFrame.LogoTop = logoTop

  local mainSectionWidth = 400
  local mainSectionPadding = 40
  local sideSectionWidth = 280

  -- Sections
  statusFrame.Section1 = self:StatusReportCreateSection(mainSectionWidth, (6 * 30) + 10, nil, 30, statusFrame, "TOP", statusFrame, "TOP", -90)
  statusFrame.Section2 = self:StatusReportCreateSection(mainSectionWidth, (7 * 30) + 10, nil, 30, statusFrame, "TOP", statusFrame.Section1, "BOTTOM", 0)
  statusFrame.Section3 = self:StatusReportCreateSection(mainSectionWidth, (5 * 30) + 10, nil, 30, statusFrame, "TOP", statusFrame.Section2, "BOTTOM", 0)
  statusFrame.Section4 = self:StatusReportCreateSection(mainSectionWidth, ((TXUI.IsRetail and 6 or 5) * 30) + 10, nil, 30, statusFrame, "TOP", statusFrame.Section3, "BOTTOM", 0)
  pluginFrame.SectionA = self:StatusReportCreateSection(sideSectionWidth, nil, nil, 30, pluginFrame, "TOP", pluginFrame, "TOP", -10)
  pluginFrame.SectionP = self:StatusReportCreateSection(sideSectionWidth, nil, nil, 30, pluginFrame, "TOP", pluginFrame.SectionA, "BOTTOM", -30)

  -- Section content
  statusFrame.Section1.Content = self:StatusReportCreateContent(6, mainSectionWidth - mainSectionPadding, statusFrame.Section1, statusFrame.Section1.Header)
  statusFrame.Section2.Content = self:StatusReportCreateContent(7, mainSectionWidth - mainSectionPadding, statusFrame.Section2, statusFrame.Section2.Header)
  statusFrame.Section3.Content = self:StatusReportCreateContent(5, mainSectionWidth - mainSectionPadding, statusFrame.Section3, statusFrame.Section3.Header)
  statusFrame.Section4.Content = self:StatusReportCreateContent(TXUI.IsRetail and 6 or 5, mainSectionWidth - mainSectionPadding, statusFrame.Section4, statusFrame.Section4.Header)

  -- Content lines
  statusFrame.Section3.Content.Line1.Text:SetFormattedText("Version of WoW: %s", F.String.Good(format("%s (build %s)", E.wowpatch, E.wowbuild)))
  statusFrame.Section3.Content.Line2.Text:SetFormattedText("Client Language: %s", F.String.Good(E.locale))
  statusFrame.Section3.Content.Line5.Text:SetFormattedText("Using Mac Client: %s", (E.isMacClient == true and F.String.Good("Yes") or F.String.Error("No")))
  statusFrame.Section4.Content.Line1.Text:SetFormattedText("Faction: %s", F.String.Good(E.myfaction))
  statusFrame.Section4.Content.Line2.Text:SetFormattedText("Race: %s", F.String.Good(E.myrace))
  statusFrame.Section4.Content.Line3.Text:SetFormattedText("Class: %s", F.String.Good(englishClassName[E.myclass]))

  return statusFrame
end

local function pluginSort(a, b)
  local A, B = a.title or a.name, b.title or b.name
  if A and B then return F.String.Strip(A) < F.String.Strip(B) end
end

local addOnData = {}
local pluginData = {}

function M:StatusReportUpdate()
  local statusFrame = self.StatusReportFrame
  local addOnFrame = statusFrame.AddOnFrame
  local cl = TXUI:GetModule("Changelog")

  -- Section headers
  statusFrame.Section1.Header.Text:SetText(F.String.ColorFirstLetter("AddOn Info"))
  statusFrame.Section2.Header.Text:SetText(TXUI.Title .. " " .. F.String.ColorFirstLetter("Settings"))
  statusFrame.Section3.Header.Text:SetText(F.String.ColorFirstLetter("WoW Info"))
  statusFrame.Section4.Header.Text:SetText(F.String.ColorFirstLetter("Character Info"))

  -- Section #1
  statusFrame.Section1.Content.Line1.Text:SetFormattedText("Version of %s: %s", TXUI.Title, F.String.Good(cl:FormattedVersion()))

  do
    local version = (not E.db.TXUI.changelog.lastLayoutVersion or E.db.TXUI.changelog.lastLayoutVersion == 0) and "NONE"
      or cl:FormattedVersion(E.db.TXUI.changelog.lastLayoutVersion)
    local versionString = (version == "NONE" or E.db.TXUI.changelog.lastLayoutVersion ~= TXUI.ReleaseVersion) and F.String.Error(version) or F.String.Good(version)
    statusFrame.Section1.Content.Line2.Text:SetFormattedText("Last Profile Version: %s", versionString)
  end

  do
    local version = (not E.private.TXUI.changelog.releaseVersion or E.private.TXUI.changelog.releaseVersion == 0) and "NONE"
      or cl:FormattedVersion(E.private.TXUI.changelog.releaseVersion)
    local versionString = (version == "NONE" or E.private.TXUI.changelog.releaseVersion ~= TXUI.ReleaseVersion) and F.String.Error(version) or F.String.Good(version)
    statusFrame.Section1.Content.Line3.Text:SetFormattedText("Last Private Version: %s", versionString)
  end

  statusFrame.Section1.Content.Line4.Text:SetFormattedText("Pixel Perfect Scale: %s", F.String.Good(E:PixelBestSize()))
  statusFrame.Section1.Content.Line5.Text:SetFormattedText("ToxiUI Perfect Scale: %s", F.String.Good(F.PixelPerfect()))

  do
    local uiScale = E.global.general.UIScale
    local uiScaleString = uiScale == F.PixelPerfect() and F.String.Good(uiScale) or F.String.Error(uiScale)
    statusFrame.Section1.Content.Line6.Text:SetFormattedText("UI Scale Is: %s", uiScaleString)
  end

  -- Section #2
  do
    local Section2 = statusFrame.Section2
    local text

    -- Debug Mode
    do
      text = (not F.Table.IsEmpty(E.db.TXUI.disabledAddOns)) and F.String.Good("On") or F.String.Error("Off")

      Section2.Content.Line1.Text:SetFormattedText("Debug Mode: %s", text)
    end

    -- Gradient Mode
    do
      local requirements = TXUI:CheckRequirements(I.Requirements.GradientMode)

      if requirements ~= true then
        text = F.String.Error(format("No (%s)", I.Strings.RequirementsDebug[requirements]))
      else
        text = ((E.db.TXUI.themes.gradientMode.enabled == true) and F.String.Good("Yes") or F.String.Error("No"))
      end

      Section2.Content.Line2.Text:SetFormattedText("Gradient Mode: %s", text)
    end

    -- Dark Mode
    do
      local requirements = TXUI:CheckRequirements(I.Requirements.DarkMode)

      if requirements ~= true then
        text = F.String.Error(format("No (%s)", I.Strings.RequirementsDebug[requirements]))
      else
        text = ((E.db.TXUI.themes.darkMode.enabled == true) and F.String.Good("Yes") or F.String.Error("No"))
      end

      Section2.Content.Line3.Text:SetFormattedText("Dark Mode: %s", text)
    end

    -- Dark Mode Transparency
    do
      local requirements = TXUI:CheckRequirements(I.Requirements.DarkModeTransparency)

      if requirements ~= true then
        text = F.String.Error(format("No (%s)", I.Strings.RequirementsDebug[requirements]))
      else
        text = ((E.db.TXUI.themes.darkMode.transparency == true) and F.String.Good("Yes") or F.String.Error("No"))
      end

      Section2.Content.Line4.Text:SetFormattedText("DM Transparency: %s", text)
    end

    -- Dark Mode Gradient Names
    do
      local requirements = TXUI:CheckRequirements(I.Requirements.DarkModeGradientName)

      if requirements ~= true then
        text = F.String.Error(format("No (%s)", I.Strings.RequirementsDebug[requirements]))
      else
        text = ((E.db.TXUI.themes.darkMode.gradientName == true) and F.String.Good("Yes") or F.String.Error("No"))
      end

      Section2.Content.Line5.Text:SetFormattedText("DM Gradients: %s", text)
    end

    -- Details Gradient Text
    do
      local requirements = TXUI:CheckRequirements(I.Requirements.DarkModeGradientName)

      if requirements ~= true then
        text = F.String.Error(format("No (%s)", I.Strings.RequirementsDebug[requirements]))
      else
        text = ((E.db.TXUI.themes.darkMode.detailsGradientText == true) and F.String.Good("Yes") or F.String.Error("No"))
      end

      Section2.Content.Line6.Text:SetFormattedText("Details Gradients: %s", text)
    end

    -- WunderBar
    do
      local requirements = TXUI:CheckRequirements(I.Requirements.WunderBar)

      if requirements ~= true then
        text = F.String.Error(format("No (%s)", I.Strings.RequirementsDebug[requirements]))
      else
        text = ((E.db.TXUI.wunderbar.general.enabled == true) and F.String.Good("Yes") or F.String.Error("No"))
      end

      Section2.Content.Line7.Text:SetFormattedText("WunderBar: %s", text)
    end
  end

  -- Section #3
  do
    local Section3 = statusFrame.Section3
    Section3.Content.Line3.Text:SetFormattedText("Display Mode: %s", F.String.Good(E:GetDisplayMode()))
    Section3.Content.Line4.Text:SetFormattedText("Resolution: %s", F.String.Good(E.resolution))
  end

  -- Section #4
  do
    local Section4 = statusFrame.Section4
    if TXUI.IsRetail then
      Section4.Content.Line4.Text:SetFormattedText("Specialization: %s", F.String.Good(getSpecName()))
      Section4.Content.Line5.Text:SetFormattedText("Level: %s", F.String.Good(E.mylevel))
      Section4.Content.Line6.Text:SetFormattedText("Zone: %s", F.String.Good(GetRealZoneText() or UNKNOWN))
    else
      Section4.Content.Line4.Text:SetFormattedText("Level: %s", F.String.Good(E.mylevel))
      Section4.Content.Line5.Text:SetFormattedText("Zone: %s", F.String.Good(GetRealZoneText() or UNKNOWN))
    end
  end

  -- AddOn Frame
  local AddOnSection = addOnFrame.SectionA
  AddOnSection.Header.Text:SetText(F.String.ColorFirstLetter("AddOns"))

  local PluginSection = addOnFrame.SectionP
  PluginSection.Header.Text:SetText(F.String.ColorFirstLetter("Plugins"))

  do
    wipe(addOnData)

    for _, addOn in ipairs { "ElvUI", "Details", "Plater", "BigWigs", "WeakAuras", "WarpDeplete", "OmniCD", "BugGrabber", "BugSack" } do
      if F.IsAddOnEnabled(addOn) then
        local data = {}
        local name = GetAddOnMetadata(addOn, "Title")
        local version = GetAddOnMetadata(addOn, "Version")

        if addOn == "ElvUI" then version = E.versionString end

        if addOn == "Details" then
          name = "Details!"
          version = Details.GetVersionString()
        end

        data.name = F.String.Strip(name) or UNKNOWN
        data.version = F.String.Strip(version) or UNKNOWN

        if data.version == UNKNOWN and addOn == "Details" then data.version = Details and Details.version or UNKNOWN end

        tinsert(addOnData, data)
      end
    end

    if next(addOnData) then
      sort(addOnData, pluginSort)

      local count = #addOnData
      AddOnSection.Content = self:StatusReportCreateContent(count, AddOnSection:GetWidth(), AddOnSection, AddOnSection.Header, AddOnSection.Content)

      for i = 1, count do
        local data = addOnData[i]
        local name = data.title or data.name
        AddOnSection.Content["Line" .. i].Text:SetFormattedText("%s %s", name, F.String.Good(data.version))
      end

      AddOnSection:SetHeight(count * 25)
    end
  end

  do
    wipe(pluginData)
    for _, data in pairs(E.Libs.EP.plugins) do
      if data and (not data.isLib and (not data.name or data.name ~= TXUI.AddOnName)) then tinsert(pluginData, data) end
    end

    if next(pluginData) then
      sort(pluginData, pluginSort)

      local count = #pluginData
      PluginSection.Content = self:StatusReportCreateContent(count, PluginSection:GetWidth(), PluginSection, PluginSection.Header, PluginSection.Content)

      for i = 1, count do
        local data = pluginData[i]
        local name = data.title or data.name or UNKNOWN
        local version = F.String.Strip(data.version) or UNKNOWN
        local versionString = (data.old or version == UNKNOWN) and F.String.Error(version) or F.String.Good(version)
        PluginSection.Content["Line" .. i].Text:SetFormattedText("%s %s", name, versionString)
      end

      PluginSection:SetHeight(count * 25)
    end
  end

  if next(addOnData) or next(pluginData) then
    addOnFrame:SetHeight((AddOnSection.Content and (AddOnSection.Content:GetHeight() + 50) or 0) + (PluginSection.Content and (PluginSection.Content:GetHeight() + 50) or 0))
    addOnFrame:Show()
  else
    addOnFrame:Hide()
  end
end

function M:StatusReportShow()
  if not self.StatusReportFrame then self.StatusReportFrame = self:StatusReportCreate() end

  if not self.StatusReportFrame:IsShown() then
    self:StatusReportUpdate()
    self.StatusReportFrame:Raise()
    self.StatusReportFrame:Show()
  else
    self.StatusReportFrame:Hide()
  end
end
