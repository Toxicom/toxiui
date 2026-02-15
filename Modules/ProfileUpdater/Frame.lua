local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local PU = TXUI:GetModule("ProfileUpdater")
local S = E:GetModule("Skins")

local CreateFrame = CreateFrame
local ipairs = ipairs
local pairs = pairs
local GameTooltip = GameTooltip
local GameTooltip_Hide = GameTooltip_Hide

local FRAME_WIDTH = 1280
local LEFT_PANEL_WIDTH = 390
local CHECKBOX_SIZE = 24
local ROW_HEIGHT = 28
local COLUMN_WIDTH = 185
local SECTION_HEADER_HEIGHT = 30
local PADDING = 15
local BUTTON_WIDTH = 120
local BUTTON_HEIGHT = 26
local PANEL_GAP = 60
local TITLE_HEIGHT = 45

function PU:CreateSectionHeader(parent, text, yOffset)
  local headerFrame = CreateFrame("Frame", nil, parent)
  headerFrame:SetSize(LEFT_PANEL_WIDTH - PADDING, SECTION_HEADER_HEIGHT)
  headerFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", PADDING, yOffset)

  local font = F.GetFontPath(I.Fonts.Primary)
  local headerText = headerFrame:CreateFontString(nil, "ARTWORK")
  headerText:SetPoint("TOP")
  headerText:SetPoint("BOTTOM")
  headerText:SetJustifyH("CENTER")
  headerText:SetJustifyV("MIDDLE")
  headerText:FontTemplate(font, 16, "NONE", true)
  headerText:SetText(text)

  local leftDivider = headerFrame:CreateTexture(nil, "ARTWORK")
  leftDivider:SetHeight(2)
  leftDivider:SetPoint("LEFT", headerFrame, "LEFT", 0, 0)
  leftDivider:SetPoint("RIGHT", headerText, "LEFT", -5, 0)
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

  local rightDivider = headerFrame:CreateTexture(nil, "ARTWORK")
  rightDivider:SetHeight(2)
  rightDivider:SetPoint("RIGHT", headerFrame, "RIGHT", 0, 0)
  rightDivider:SetPoint("LEFT", headerText, "RIGHT", 5, 0)
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

  return headerFrame
end

function PU:CreateCheckboxRow(parent, item, xOffset, yOffset)
  local cb = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
  cb:SetSize(CHECKBOX_SIZE, CHECKBOX_SIZE)
  cb:SetPoint("TOPLEFT", parent, "TOPLEFT", xOffset, yOffset)
  cb:SetChecked(self.selectedItems[item.key] or false)
  S:HandleCheckBox(cb)

  cb:SetScript("OnClick", function(self_cb)
    PU:SetItemSelected(item.key, self_cb:GetChecked())
    PU:UpdateApplyButton()
  end)

  local font = F.GetFontPath(I.Fonts.Primary)
  local label = cb:CreateFontString(nil, "OVERLAY")
  label:SetPoint("LEFT", cb, "RIGHT", 4, 0)
  label:FontTemplate(font, 14, "OUTLINE", true)

  -- Build label text with change count
  local labelText = item.label
  local diffData = self:GetDiffForItem(item.key)
  if diffData then
    if diffData.count > 0 then
      labelText = labelText .. " |cffffd100(" .. diffData.count .. ")|r"
    else
      labelText = labelText .. " |cff66ff66(0)|r"
    end
    if diffData.reanchored and #diffData.reanchored > 0 then labelText = labelText .. " |cff888888+" .. #diffData.reanchored .. "|r" end
  end
  label:SetText(labelText)

  -- Hover: show tooltip and diff panel
  cb:SetScript("OnEnter", function(self_cb)
    if item.desc then
      GameTooltip:SetOwner(self_cb, "ANCHOR_RIGHT")
      GameTooltip:AddLine(item.label, 1, 1, 1)
      GameTooltip:AddLine(item.desc, nil, nil, nil, true)
      GameTooltip:Show()
    end
    if item.hasDiff then PU:ShowDiffForItem(item.key, item.label) end
  end)

  cb:SetScript("OnLeave", function()
    GameTooltip_Hide()
  end)

  cb.label = label
  cb.itemKey = item.key
  cb.itemData = item
  return cb
end

function PU:CreateDiffPanel(parent)
  local font = F.GetFontPath(I.Fonts.Primary)
  local diffPanelLeft = LEFT_PANEL_WIDTH + PANEL_GAP
  local rightPanelWidth = FRAME_WIDTH - diffPanelLeft - PADDING

  -- Right panel container
  local panel = CreateFrame("Frame", nil, parent, "BackdropTemplate")
  panel:SetPoint("TOPLEFT", parent, "TOPLEFT", diffPanelLeft, -TITLE_HEIGHT)
  panel:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -PADDING, BUTTON_HEIGHT + PADDING + 10)
  panel:CreateBackdrop("Transparent")

  -- Panel title
  local panelTitle = panel:CreateFontString(nil, "OVERLAY")
  panelTitle:SetPoint("TOPLEFT", panel, "TOPLEFT", 10, -10)
  panelTitle:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -10, -10)
  panelTitle:FontTemplate(font, 14, "OUTLINE", true)
  panelTitle:SetJustifyH("LEFT")
  panelTitle:SetText("|cff888888Hover over a section to preview changes|r")
  self.diffPanelTitle = panelTitle

  -- Scroll frame
  local scrollFrame = CreateFrame("ScrollFrame", "TXUIProfileUpdaterScroll", panel, "UIPanelScrollFrameTemplate")
  scrollFrame:SetPoint("TOPLEFT", panelTitle, "BOTTOMLEFT", 0, -8)
  scrollFrame:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -26, 8)

  -- Scroll child
  local scrollChild = CreateFrame("Frame")
  scrollChild:SetWidth(rightPanelWidth - 46)
  scrollFrame:SetScrollChild(scrollChild)

  -- Content text
  local contentText = scrollChild:CreateFontString(nil, "OVERLAY")
  contentText:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 2, -2)
  contentText:SetWidth(rightPanelWidth - 50)
  contentText:SetWordWrap(true)
  contentText:SetJustifyH("LEFT")
  contentText:SetJustifyV("TOP")
  contentText:SetSpacing(2)
  contentText:FontTemplate(font, 12, "NONE", true)

  -- Skin scrollbar
  local scrollBar = _G["TXUIProfileUpdaterScrollScrollBar"]
  if scrollBar then S:HandleScrollBar(scrollBar) end

  self.diffContentText = contentText
  self.diffScrollChild = scrollChild
  self.diffScrollFrame = scrollFrame
end

function PU:ShowDiffForItem(key, label)
  if not self.diffPanelTitle then return end

  local diffData = self:GetDiffForItem(key)
  if diffData then
    local titleParts = label .. " — "
    if diffData.count > 0 then
      titleParts = titleParts .. "|cffffd100" .. diffData.count .. " change(s)|r"
    else
      titleParts = titleParts .. "|cff66ff66No changes|r"
    end
    if diffData.reanchored and #diffData.reanchored > 0 then titleParts = titleParts .. " |cff888888(" .. #diffData.reanchored .. " re-anchored)|r" end
    self.diffPanelTitle:SetText(titleParts)
  else
    self.diffPanelTitle:SetText(label)
  end

  local diffText = self:BuildDiffText(key)
  if diffText then
    self.diffContentText:SetText(diffText)
  else
    self.diffContentText:SetText("|cff888888Detailed preview not available for this section.|r")
  end

  -- Resize scroll child to fit content
  local textHeight = self.diffContentText:GetStringHeight() + 10
  self.diffScrollChild:SetHeight(textHeight)

  -- Reset scroll position to top
  self.diffScrollFrame:SetVerticalScroll(0)
end

function PU:CreateActionButtons(parent)
  local font = F.GetFontPath(I.Fonts.Primary)

  -- Select All
  local selectAll = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
  selectAll:SetSize(BUTTON_WIDTH, BUTTON_HEIGHT)
  selectAll:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", PADDING, PADDING)
  selectAll:SetText("Select All")
  selectAll:GetFontString():FontTemplate(font, 12, "OUTLINE", true)
  S:HandleButton(selectAll)
  selectAll:SetScript("OnClick", function()
    PU:SelectAll()
    PU:UpdateCheckboxStates()
    PU:UpdateApplyButton()
  end)

  -- Select None
  local selectNone = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
  selectNone:SetSize(BUTTON_WIDTH, BUTTON_HEIGHT)
  selectNone:SetPoint("LEFT", selectAll, "RIGHT", 10, 0)
  selectNone:SetText("Select None")
  selectNone:GetFontString():FontTemplate(font, 12, "OUTLINE", true)
  S:HandleButton(selectNone)
  selectNone:SetScript("OnClick", function()
    PU:SelectNone()
    PU:UpdateCheckboxStates()
    PU:UpdateApplyButton()
  end)

  -- Apply
  local apply = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
  apply:SetSize(BUTTON_WIDTH, BUTTON_HEIGHT)
  apply:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -PADDING, PADDING)
  apply:SetText("Apply")
  apply:GetFontString():FontTemplate(font, 12, "OUTLINE", true)
  S:HandleButton(apply)
  apply:SetScript("OnClick", function()
    if not PU:HasAnySelected() then
      TXUI:LogInfo("No profile sections selected.")
      return
    end
    PU.frame:Hide()
    PU:ShowConfirmationPopup()
  end)

  self.applyButton = apply
end

function PU:UpdateCheckboxStates()
  if not self.checkboxes then return end

  for key, cb in pairs(self.checkboxes) do
    cb:SetChecked(self.selectedItems[key] or false)
  end
end

function PU:UpdateCheckboxLabels()
  if not self.checkboxes then return end

  for _, cb in pairs(self.checkboxes) do
    local item = cb.itemData
    if item then
      local labelText = item.label
      local diffData = self:GetDiffForItem(item.key)
      if diffData then
        if diffData.count > 0 then
          labelText = labelText .. " |cffffd100(" .. diffData.count .. ")|r"
        else
          labelText = labelText .. " |cff66ff66(0)|r"
        end
        if diffData.reanchored and #diffData.reanchored > 0 then labelText = labelText .. " |cff888888+" .. #diffData.reanchored .. "|r" end
      end
      cb.label:SetText(labelText)
    end
  end
end

function PU:UpdateApplyButton()
  if not self.applyButton then return end

  if self:HasAnySelected() then
    self.applyButton:Enable()
  else
    self.applyButton:Disable()
  end
end

function PU:CreateUpdaterFrame()
  -- Main frame
  local frame = CreateFrame("Frame", "TXUIProfileUpdater", E.UIParent, "BackdropTemplate")
  frame:SetPoint("CENTER", E.UIParent, "CENTER")
  frame:SetFrameStrata("HIGH")
  frame:CreateBackdrop("Transparent")
  frame:CreateCloseButton()
  frame:SetMovable(true)
  frame:Hide()

  -- Title drag area
  local titleDrag = CreateFrame("Frame", nil, frame, "TitleDragAreaTemplate")
  titleDrag:SetPoint("TOPLEFT", frame, "TOPLEFT")
  titleDrag:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 0, -TITLE_HEIGHT)

  -- Title text
  local font = F.GetFontPath(I.Fonts.Primary)
  local title = frame:CreateFontString(nil, "OVERLAY")
  title:SetPoint("TOP", frame, "TOP", 0, -PADDING)
  title:FontTemplate(font, 20, "NONE", true)
  title:SetText(TXUI.Title .. " Profile Updater")

  local yOffset = -TITLE_HEIGHT

  -- Disclaimer text (left panel)
  local disclaimerText = frame:CreateFontString(nil, "OVERLAY")
  disclaimerText:SetPoint("TOPLEFT", frame, "TOPLEFT", PADDING, yOffset - 5)
  disclaimerText:SetWidth(LEFT_PANEL_WIDTH - PADDING * 2)
  disclaimerText:SetWordWrap(true)
  disclaimerText:SetJustifyH("LEFT")
  disclaimerText:SetJustifyV("TOP")
  disclaimerText:SetSpacing(2)
  disclaimerText:FontTemplate(font, 12, "NONE", true)
  disclaimerText:SetText(
    "|cffff6666WARNING:|r Applying selected sections will |cffff6666overwrite|r your current ElvUI settings for those sections with "
      .. TXUI.Title
      .. " defaults. Any manual changes you have made to selected sections will be lost.\n\nHover over each section to preview what will change.\n\n"
  )
  yOffset = yOffset - disclaimerText:GetStringHeight() - 15

  -- Build checkboxes (left panel)
  local checkboxes = {}
  local categories = self:GetCategories()

  for _, category in ipairs(categories) do
    -- Section header
    yOffset = yOffset - 5
    self:CreateSectionHeader(frame, category.label, yOffset)
    yOffset = yOffset - SECTION_HEADER_HEIGHT

    -- Checkbox rows (two-column layout)
    local col = 0
    for _, item in ipairs(category.items) do
      local xOff = PADDING + (col * COLUMN_WIDTH)
      local cb = self:CreateCheckboxRow(frame, item, xOff, yOffset)
      checkboxes[item.key] = cb

      col = col + 1
      if col >= 2 then
        col = 0
        yOffset = yOffset - ROW_HEIGHT
      end
    end

    -- If ended on odd column, move to next row
    if col > 0 then yOffset = yOffset - ROW_HEIGHT end
  end

  -- Bottom padding for buttons
  yOffset = yOffset - (BUTTON_HEIGHT + PADDING + 10)

  -- Set final frame size
  frame:SetSize(FRAME_WIDTH, -yOffset)

  -- Diff panel (right side)
  self:CreateDiffPanel(frame)

  -- Action buttons (anchored to bottom, full width)
  self:CreateActionButtons(frame)

  self.frame = frame
  self.checkboxes = checkboxes
end
