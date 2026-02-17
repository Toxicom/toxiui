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

local function getSpecName()
  return I.SpecNames[GetSpecializationInfo(GetSpecialization())] or UNKNOWN
end

-- Format a scale value for display (trim excessive decimals)
local function formatScale(value)
  return format("%.4g", value)
end

-- Helper: generates a line entry for a feature with a requirements check
local function reqLine(label, requirementsKey, dbValue)
  return {
    label,
    function()
      local requirements = TXUI:CheckRequirements(requirementsKey)
      if requirements ~= true then return F.String.Error(format("No (%s)", I.Strings.RequirementsDebug[requirements])) end
      return (dbValue() == true) and F.String.Good("Yes") or F.String.Error("No")
    end,
  }
end

-- Declarative section definitions
-- Each section: { header, lines, [headerFn] }
-- Each line: { "Label", valueFn } — valueFn returns the formatted value string
-- Entries that are `false` or `nil` are skipped (use for conditional lines)
local function getSections()
  local cl = TXUI:GetModule("Changelog")

  return {
    {
      header = "AddOn Info",
      lines = {
        {
          format("Version of %s", TXUI.Title),
          function()
            return F.String.Good(cl:FormattedVersion())
          end,
        },
        {
          "Last Profile Version",
          function()
            local version = (not E.db.TXUI.changelog.lastLayoutVersion or E.db.TXUI.changelog.lastLayoutVersion == 0) and "NONE"
              or cl:FormattedVersion(E.db.TXUI.changelog.lastLayoutVersion)
            return (version == "NONE" or E.db.TXUI.changelog.lastLayoutVersion ~= TXUI.ReleaseVersion) and F.String.Error(version) or F.String.Good(version)
          end,
        },
        {
          "Last Private Version",
          function()
            local version = (not E.private.TXUI.changelog.releaseVersion or E.private.TXUI.changelog.releaseVersion == 0) and "NONE"
              or cl:FormattedVersion(E.private.TXUI.changelog.releaseVersion)
            return (version == "NONE" or E.private.TXUI.changelog.releaseVersion ~= TXUI.ReleaseVersion) and F.String.Error(version) or F.String.Good(version)
          end,
        },
        {
          "Pixel Perfect Scale",
          function()
            return F.String.Good(formatScale(E:PixelBestSize()))
          end,
        },
        {
          TXUI.Title .. " Perfect Scale",
          function()
            return F.String.Good(formatScale(F.PixelPerfect()))
          end,
        },
        {
          "UI Scale Is",
          function()
            local uiScale = E.global.general.UIScale
            local display = formatScale(uiScale)
            return uiScale == F.PixelPerfect() and F.String.Good(display) or F.String.Error(display)
          end,
        },
      },
    },
    {
      header = "Settings",
      headerFn = function()
        return TXUI.Title .. " " .. F.String.ColorFirstLetter("Settings")
      end,
      lines = {
        {
          "Debug Mode",
          function()
            return (not F.Table.IsEmpty(E.db.TXUI.disabledAddOns)) and F.String.Good("On") or F.String.Error("Off")
          end,
        },
        reqLine("Gradient Mode", I.Requirements.GradientMode, function()
          return E.db.TXUI.themes.gradientMode.enabled
        end),
        reqLine("Dark Mode", I.Requirements.DarkMode, function()
          return E.db.TXUI.themes.darkMode.enabled
        end),
        reqLine("DM Transparency", I.Requirements.DarkModeTransparency, function()
          return E.db.TXUI.themes.darkMode.transparency
        end),
        reqLine("WunderBar", I.Requirements.WunderBar, function()
          return E.db.TXUI.wunderbar.general.enabled
        end),
        TXUI.IsRetail and reqLine("Damage Meter", I.Requirements.DamageMeter, function()
          return E.db.TXUI.addons.damageMeter.enabled
        end),
      },
    },
    {
      header = "WoW Info",
      lines = {
        {
          "Version of WoW",
          function()
            return F.String.Good(format("%s (build %s)", E.wowpatch, E.wowbuild))
          end,
        },
        {
          "Client Language",
          function()
            return F.String.Good(E.locale)
          end,
        },
        {
          "Display Mode",
          function()
            return F.String.Good(E:GetDisplayMode())
          end,
        },
        {
          "Resolution",
          function()
            return F.String.Good(E.resolution)
          end,
        },
        E.isMacClient and {
          "Using Mac Client",
          function()
            return F.String.Good("Yes")
          end,
        },
      },
    },
    {
      header = "Character Info",
      lines = {
        {
          "Faction",
          function()
            return F.String.Good(E.myfaction)
          end,
        },
        {
          "Race",
          function()
            return F.String.Good(E.myrace)
          end,
        },
        {
          "Class",
          function()
            return F.String.Good(I.EnglishClassName[E.myclass])
          end,
        },
        TXUI.IsRetail and {
          "Specialization",
          function()
            return F.String.Good(getSpecName())
          end,
        },
        {
          "Level",
          function()
            return F.String.Good(E.mylevel)
          end,
        },
        {
          "Zone",
          function()
            return F.String.Good(GetRealZoneText() or UNKNOWN)
          end,
        },
      },
    },
  }
end

-- Filters out false/nil entries from a lines table
local function filterLines(lines)
  local filtered = {}
  for _, entry in ipairs(lines) do
    if entry then tinsert(filtered, entry) end
  end
  return filtered
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

      -- Alternating row background (even rows only, faded edges)
      if i % 2 == 0 then
        local rowBgLeft = line:CreateTexture(nil, "BACKGROUND")
        rowBgLeft:SetTexture(E.media.blankTex)
        rowBgLeft:SetPoint("LEFT", line, "LEFT", 0, 0)
        rowBgLeft:SetPoint("RIGHT", line, "CENTER", 0, 0)
        rowBgLeft:SetHeight(20)
        F.Color.SetGradientRGB(rowBgLeft, "HORIZONTAL", 1, 1, 1, 0.08, 1, 1, 1, 0)

        local rowBgRight = line:CreateTexture(nil, "BACKGROUND")
        rowBgRight:SetTexture(E.media.blankTex)
        rowBgRight:SetPoint("LEFT", line, "CENTER", 0, 0)
        rowBgRight:SetPoint("RIGHT", line, "RIGHT", 0, 0)
        rowBgRight:SetHeight(20)
        F.Color.SetGradientRGB(rowBgRight, "HORIZONTAL", 1, 1, 1, 0, 1, 1, 1, 0.08)
      end

      -- Label (left-aligned)
      local label = line:CreateFontString(nil, "ARTWORK")
      label:SetPoint("LEFT", line, "LEFT", 0, 0)
      label:SetPoint("RIGHT", line, "CENTER", -5, 0)
      label:SetJustifyH("LEFT")
      label:SetJustifyV("MIDDLE")
      label:FontTemplate(font, 14, "OUTLINE", true)
      line.Label = label

      -- Value (right-aligned)
      local value = line:CreateFontString(nil, "ARTWORK")
      value:SetPoint("LEFT", line, "CENTER", 5, 0)
      value:SetPoint("RIGHT", line, "RIGHT", 0, 0)
      value:SetJustifyH("RIGHT")
      value:SetJustifyV("MIDDLE")
      value:FontTemplate(font, 14, "OUTLINE", true)
      line.Value = value

      -- Single-line text (used by addon/plugin side panel)
      local text = line:CreateFontString(nil, "ARTWORK")
      text:SetAllPoints()
      text:SetJustifyH("LEFT")
      text:SetJustifyV("MIDDLE")
      text:FontTemplate(font, 14, "OUTLINE", true)
      text:Hide()
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

  -- Build main sections from declarative definitions
  local sections = getSections()
  statusFrame.Sections = {}

  local prevAnchor = statusFrame
  for i, sectionDef in ipairs(sections) do
    local lines = filterLines(sectionDef.lines)
    local lineCount = #lines
    local sectionHeight = (lineCount * 30) + 10

    local section = self:StatusReportCreateSection(mainSectionWidth, sectionHeight, nil, 30, statusFrame, "TOP", prevAnchor, i == 1 and "TOP" or "BOTTOM", i == 1 and -90 or 0)
    section.Content = self:StatusReportCreateContent(lineCount, mainSectionWidth - mainSectionPadding, section, section.Header)

    statusFrame.Sections[i] = section
    prevAnchor = section
  end

  -- Side panel sections (addons/plugins — dynamic)
  pluginFrame.SectionA = self:StatusReportCreateSection(sideSectionWidth, nil, nil, 30, pluginFrame, "TOP", pluginFrame, "TOP", -10)
  pluginFrame.SectionP = self:StatusReportCreateSection(sideSectionWidth, nil, nil, 30, pluginFrame, "TOP", pluginFrame.SectionA, "BOTTOM", -30)

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

  -- Update all main sections from declarative definitions
  local sections = getSections()
  for i, sectionDef in ipairs(sections) do
    local section = statusFrame.Sections[i]
    section.Header.Text:SetText(sectionDef.headerFn and sectionDef.headerFn() or F.String.ColorFirstLetter(sectionDef.header))

    local lines = filterLines(sectionDef.lines)
    for lineIdx, entry in ipairs(lines) do
      local label, valueFn = entry[1], entry[2]
      local line = section.Content["Line" .. lineIdx]
      line.Label:SetText(label)
      line.Value:SetText(valueFn())
      line.Label:Show()
      line.Value:Show()
      line.Text:Hide()
    end
  end

  -- AddOn Frame (side panel)
  local AddOnSection = addOnFrame.SectionA
  AddOnSection.Header.Text:SetText(F.String.ColorFirstLetter("AddOns"))

  local PluginSection = addOnFrame.SectionP
  PluginSection.Header.Text:SetText(F.String.ColorFirstLetter("Plugins"))

  do
    wipe(addOnData)

    for _, addOn in ipairs { "ElvUI", "Details", "BigWigs", "WarpDeplete", "BugGrabber", "BugSack" } do
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
        local line = AddOnSection.Content["Line" .. i]
        line.Text:Show()
        line.Label:Hide()
        line.Value:Hide()
        line.Text:SetFormattedText("%s %s", name, F.String.Good(data.version))
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
        local line = PluginSection.Content["Line" .. i]
        line.Text:Show()
        line.Label:Hide()
        line.Value:Hide()
        line.Text:SetFormattedText("%s %s", name, versionString)
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
