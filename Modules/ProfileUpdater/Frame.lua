local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local PU = TXUI:GetModule("ProfileUpdater")
local S = E:GetModule("Skins")

local CreateFrame = CreateFrame
local ipairs = ipairs
local pairs = pairs
local tinsert = tinsert
local GameTooltip = GameTooltip
local GameTooltip_Hide = GameTooltip_Hide
local ReloadUI = ReloadUI

local FRAME_WIDTH = 1280
local LEFT_PANEL_WIDTH = 390
local CHECKBOX_SIZE = 24
local ROW_HEIGHT = 28
local COLUMN_WIDTH = 185
local SECTION_HEADER_HEIGHT = 30
local PADDING = 15
local BUTTON_WIDTH = 160
local BUTTON_HEIGHT = 26
local LAYOUT_BUTTON_WIDTH = 130
local PANEL_GAP = 60
local TITLE_HEIGHT = 45
local DIFF_ROW_HEIGHT = 54
local RELOAD_BANNER_H = 28

-- Row pool: hide all active rows, clear scripts so they can be safely reconfigured
local function releaseAllRows(pool)
  for _, row in ipairs(pool) do
    if row:IsShown() then
      row:Hide()
      row:ClearAllPoints()
      row:SetScript("OnClick", nil)
      row:SetScript("OnEnter", nil)
      row:SetScript("OnLeave", nil)
      row:EnableMouse(false)
    end
  end
end

-- Acquire the first hidden row from the pool, or create a new one
local function acquireRow(pool, parent, contentWidth)
  for _, row in ipairs(pool) do
    if not row:IsShown() then
      row:Show()
      return row
    end
  end

  local font = F.GetFontPath(I.Fonts.Primary)
  local row = CreateFrame("Button", nil, parent)
  row:SetHeight(DIFF_ROW_HEIGHT)
  row:SetWidth(contentWidth)

  local hl = row:CreateTexture(nil, "HIGHLIGHT")
  hl:SetAllPoints()
  hl:SetTexture(E.media.blankTex)
  hl:SetVertexColor(1, 1, 1, 0.08)

  local pathLabel = row:CreateFontString(nil, "OVERLAY")
  pathLabel:SetPoint("TOPLEFT", row, "TOPLEFT", 6, -4)
  pathLabel:SetPoint("TOPRIGHT", row, "TOPRIGHT", -6, -4)
  pathLabel:FontTemplate(font, 11, "OUTLINE", true)
  pathLabel:SetJustifyH("LEFT")
  row.pathLabel = pathLabel

  local valueLabel = row:CreateFontString(nil, "OVERLAY")
  valueLabel:SetPoint("TOPLEFT", pathLabel, "BOTTOMLEFT", 0, -2)
  valueLabel:SetPoint("TOPRIGHT", pathLabel, "BOTTOMRIGHT", 0, -2)
  valueLabel:FontTemplate(font, 11, "NONE", true)
  valueLabel:SetJustifyH("LEFT")
  row.valueLabel = valueLabel

  local newLabel = row:CreateFontString(nil, "OVERLAY")
  newLabel:SetPoint("TOPLEFT", valueLabel, "BOTTOMLEFT", 0, -1)
  newLabel:SetPoint("TOPRIGHT", valueLabel, "BOTTOMRIGHT", 0, -1)
  newLabel:FontTemplate(font, 11, "NONE", true)
  newLabel:SetJustifyH("LEFT")
  row.newLabel = newLabel

  local sep = row:CreateTexture(nil, "ARTWORK")
  sep:SetHeight(1)
  sep:SetPoint("BOTTOMLEFT", row, "BOTTOMLEFT", 0, 0)
  sep:SetPoint("BOTTOMRIGHT", row, "BOTTOMRIGHT", 0, 0)
  sep:SetTexture(E.media.blankTex)
  sep:SetVertexColor(1, 1, 1, 0.05)

  tinsert(pool, row)
  return row
end

-- Reset the diff panel view without touching reload state (used when switching layout)
local function resetDiffView()
  if PU.rowPool then releaseAllRows(PU.rowPool) end
  if PU.diffPanelTitle then PU.diffPanelTitle:SetText(F.String.Muted("Hover over a section to preview changes")) end
  PU.currentDiffKey = nil
  PU.currentDiffLabel = nil
end

function PU:SetupAnimations(frame)
  frame.animEnter = TXUI:CreateAnimationGroup(frame)
  do
    local fadein = frame.animEnter:CreateAnimation("fade")
    fadein:SetChange(1)
    fadein:SetDuration(0.32)
    fadein:SetEasing("out-cubic")
  end

  frame.animExit = TXUI:CreateAnimationGroup(frame)
  do
    local fadeout = frame.animExit:CreateAnimation("fade")
    fadeout:SetChange(0)
    fadeout:SetDuration(0.22)
    fadeout:SetEasing("in-cubic")
  end
  frame.animExit:SetScript("OnFinished", function()
    frame:Hide()
  end)
end

function PU:ShowFrame()
  local f = self.frame
  if not f then return end
  if f.animExit:IsPlaying() then f.animExit:Stop() end
  f:SetAlpha(0)
  f:Show()
  f:Raise()
  f.animEnter:Play()
end

function PU:CloseFrame()
  local f = self.frame
  if not f or not f:IsShown() then return end
  if f.animEnter:IsPlaying() then f.animEnter:Stop() end
  f:SetAlpha(1)
  f.animExit:Play()
end

function PU:BuildCheckboxLabelText(item)
  local labelText = item.label
  local diffData = self:GetDiffForItem(item.key)
  if diffData then
    if diffData.count > 0 then
      labelText = labelText .. " " .. F.String.DiffChanged("(" .. diffData.count .. ")")
    else
      labelText = labelText .. " " .. F.String.Good("(0)")
    end
    if diffData.reanchored and #diffData.reanchored > 0 then labelText = labelText .. " " .. F.String.Muted("+" .. #diffData.reanchored) end
  end
  return labelText
end

function PU:BuildDiffTitleText(label, diffData)
  local titleParts = label .. " — "
  if diffData then
    if diffData.count > 0 then
      titleParts = titleParts .. F.String.DiffChanged(diffData.count .. " change(s)")
    else
      titleParts = titleParts .. F.String.Good("No changes")
    end
    if diffData.reanchored and #diffData.reanchored > 0 then titleParts = titleParts .. " " .. F.String.Muted("(" .. #diffData.reanchored .. " re-anchored)") end
  end
  return titleParts
end

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

  label:SetText(self:BuildCheckboxLabelText(item))

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

  local panel = CreateFrame("Frame", nil, parent, "BackdropTemplate")
  panel:SetPoint("TOPLEFT", parent, "TOPLEFT", diffPanelLeft, -TITLE_HEIGHT)
  panel:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -PADDING, BUTTON_HEIGHT + PADDING + 10)
  panel:CreateBackdrop("Transparent")

  -- Section title (updates on hover)
  local panelTitle = panel:CreateFontString(nil, "OVERLAY")
  panelTitle:SetPoint("TOPLEFT", panel, "TOPLEFT", 10, -10)
  panelTitle:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -10, -10)
  panelTitle:FontTemplate(font, 14, "OUTLINE", true)
  panelTitle:SetJustifyH("LEFT")
  panelTitle:SetText(F.String.Muted("Hover over a section to preview changes"))
  self.diffPanelTitle = panelTitle

  -- Hint below the title
  local hintText = panel:CreateFontString(nil, "OVERLAY")
  hintText:SetPoint("TOPLEFT", panelTitle, "BOTTOMLEFT", 0, -3)
  hintText:FontTemplate(font, 10, "NONE", true)
  hintText:SetJustifyH("LEFT")
  hintText:SetText(F.String.ToxiUI("Click any change to apply it individually") .. F.String.Silver(" — reload required after closing"))

  -- Reload banner (appears after first individual apply)
  local reloadBanner = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
  reloadBanner:SetSize(rightPanelWidth - 20, RELOAD_BANNER_H)
  reloadBanner:SetPoint("BOTTOM", panel, "BOTTOM", 0, 6)
  reloadBanner:SetText("")
  reloadBanner:GetFontString():FontTemplate(font, 11, "OUTLINE", true)
  S:HandleButton(reloadBanner)
  reloadBanner:Hide()
  reloadBanner:SetScript("OnClick", function()
    PU.pendingReload = false
    ReloadUI()
  end)
  self.diffReloadBanner = reloadBanner

  -- Scroll frame (leaves room for the banner at the bottom)
  local scrollFrame = CreateFrame("ScrollFrame", "TXUIProfileUpdaterScroll", panel, "UIPanelScrollFrameTemplate")
  scrollFrame:SetPoint("TOPLEFT", hintText, "BOTTOMLEFT", 0, -6)
  scrollFrame:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -26, RELOAD_BANNER_H + 10)

  local scrollChild = CreateFrame("Frame")
  scrollChild:SetWidth(rightPanelWidth - 46)
  scrollChild:SetHeight(1)
  scrollFrame:SetScrollChild(scrollChild)

  local scrollBar = _G["TXUIProfileUpdaterScrollScrollBar"]
  if scrollBar then S:HandleScrollBar(scrollBar) end

  self.diffScrollChild = scrollChild
  self.diffScrollFrame = scrollFrame
  self.diffContentWidth = rightPanelWidth - 46
  self.rowPool = self.rowPool or {}
end

function PU:ClearDiffRows()
  if self.rowPool then releaseAllRows(self.rowPool) end
  if self.diffPanelTitle then self.diffPanelTitle:SetText(F.String.Muted("Hover over a section to preview changes")) end
  self.currentDiffKey = nil
  self.currentDiffLabel = nil
  self.pendingReload = false
  self.appliedCount = 0
  if self.diffReloadBanner then self.diffReloadBanner:Hide() end
end

function PU:BuildInteractiveDiffRows(key)
  if not self.diffScrollChild then return end

  releaseAllRows(self.rowPool)

  local diffData = self:GetDiffForItem(key)
  local yOffset = 0
  local contentWidth = self.diffContentWidth

  -- Places a diff entry row with GitHub-style - / + lines
  local function placeDiffRow(entry, isReanchored, isCdmManaged)
    local row = acquireRow(self.rowPool, self.diffScrollChild, contentWidth)
    row:SetSize(contentWidth, DIFF_ROW_HEIGHT)
    row:SetPoint("TOPLEFT", self.diffScrollChild, "TOPLEFT", 0, -yOffset)

    if isReanchored then
      row.pathLabel:SetText(F.String.Silver(entry.path))
      row.valueLabel:SetText(F.String.DiffRemoved("-") .. " " .. F.String.Muted(entry.oldParent or "?"))
      row.newLabel:SetText(F.String.DiffAdded("+") .. " " .. F.String.Muted(entry.newParent or "?"))
      row.newLabel:Show()
      row:EnableMouse(false)
      row:SetAlpha(0.65)
    elseif isCdmManaged then
      row.pathLabel:SetText(F.String.Silver(entry.path))
      row.valueLabel:SetText(F.String.DiffRemoved("-") .. " " .. F.String.Muted(tostring(entry.old)))
      row.newLabel:SetText(F.String.DiffAdded("+") .. " " .. F.String.Muted(tostring(entry.new)))
      row.newLabel:Show()
      row:EnableMouse(true)
      row:SetAlpha(0.65)
      row:SetScript("OnEnter", function(self_row)
        GameTooltip:SetOwner(self_row, "ANCHOR_RIGHT")
        GameTooltip:AddLine("Managed by " .. F.String.ToxiUI("ToxiUI"), 1, 1, 1)
        GameTooltip:AddLine(F.String.Muted("This setting is updated dynamically and cannot be changed here."), nil, nil, nil, true)
        GameTooltip:Show()
      end)
      row:SetScript("OnLeave", function()
        GameTooltip_Hide()
      end)
    else
      local capturedKey = key
      local capturedEntry = entry
      row.pathLabel:SetText(F.String.Silver(entry.path))
      row.valueLabel:SetText(F.String.DiffRemoved("-") .. " " .. F.String.FormatDiffValue(entry.old))
      row.newLabel:SetText(F.String.DiffAdded("+") .. " " .. F.String.FormatDiffValue(entry.new))
      row.newLabel:Show()
      row:EnableMouse(true)
      row:SetAlpha(1.0)
      row:SetScript("OnClick", function()
        PU:ApplyDiffEntry(capturedKey, capturedEntry)
        PU:OnDiffEntryApplied(capturedKey)
      end)
      row:SetScript("OnEnter", function(self_row)
        GameTooltip:SetOwner(self_row, "ANCHOR_RIGHT")
        GameTooltip:AddLine("Click to apply this change", 1, 1, 1)
        GameTooltip:AddLine(F.String.Muted("A reload will be required after closing."), nil, nil, nil, true)
        GameTooltip:Show()
      end)
      row:SetScript("OnLeave", function()
        GameTooltip_Hide()
      end)
    end

    yOffset = yOffset + DIFF_ROW_HEIGHT
  end

  -- Places a slim header/divider row (no diff lines)
  local function placeHeaderRow(text)
    local row = acquireRow(self.rowPool, self.diffScrollChild, contentWidth)
    row:SetSize(contentWidth, 20)
    row:SetPoint("TOPLEFT", self.diffScrollChild, "TOPLEFT", 0, -yOffset)
    row.pathLabel:SetText(text)
    row.valueLabel:SetText("")
    row.newLabel:Hide()
    row:EnableMouse(false)
    row:SetAlpha(0.6)
    yOffset = yOffset + 20
  end

  -- Places a single-line status message row
  local function placeMessageRow(text)
    local row = acquireRow(self.rowPool, self.diffScrollChild, contentWidth)
    row:SetSize(contentWidth, 30)
    row:SetPoint("TOPLEFT", self.diffScrollChild, "TOPLEFT", 0, -yOffset)
    row.pathLabel:SetText(text)
    row.valueLabel:SetText("")
    row.newLabel:Hide()
    row:EnableMouse(false)
    row:SetAlpha(0.8)
    yOffset = yOffset + 30
  end

  if not diffData then
    placeMessageRow(F.String.Warning("Detailed preview not available for this section."))
  elseif diffData.count == 0 and (not diffData.reanchored or #diffData.reanchored == 0) and (not diffData.cdmManaged or #diffData.cdmManaged == 0) then
    placeMessageRow(F.String.Good("No changes detected."))
  else
    for _, entry in ipairs(diffData.entries) do
      placeDiffRow(entry, false)
    end

    local reanchored = diffData.reanchored
    if reanchored and #reanchored > 0 then
      if diffData.count > 0 then yOffset = yOffset + 6 end
      placeHeaderRow(F.String.Muted("--- Re-anchored by ") .. F.String.ElvUI("ElvUI") .. F.String.Muted(" (" .. #reanchored .. ") — read-only ---"))
      for _, entry in ipairs(reanchored) do
        placeDiffRow(entry, true, false)
      end
    end

    local cdmManaged = diffData.cdmManaged
    if cdmManaged and #cdmManaged > 0 then
      if diffData.count > 0 or (reanchored and #reanchored > 0) then yOffset = yOffset + 6 end
      placeHeaderRow(F.String.Muted("--- Managed by ") .. F.String.ToxiUI("ToxiUI") .. F.String.Muted(" (" .. #cdmManaged .. ") — updated dynamically ---"))
      for _, entry in ipairs(cdmManaged) do
        placeDiffRow(entry, false, true)
      end
    end
  end

  self.diffScrollChild:SetHeight(yOffset > 0 and yOffset or 1)
  self.diffScrollFrame:SetVerticalScroll(0)
end

function PU:ShowDiffForItem(key, label)
  if not self.diffPanelTitle then return end

  self.currentDiffKey = key
  self.currentDiffLabel = label

  self.diffPanelTitle:SetText(self:BuildDiffTitleText(label, self:GetDiffForItem(key)))

  self:BuildInteractiveDiffRows(key)
end

function PU:OnDiffEntryApplied(sectionKey)
  -- Rebuild rows to reflect the removed entry
  self:BuildInteractiveDiffRows(sectionKey)

  -- Refresh the title count
  if self.currentDiffLabel then self.diffPanelTitle:SetText(self:BuildDiffTitleText(self.currentDiffLabel, self:GetDiffForItem(sectionKey))) end

  -- Update all checkbox count labels
  self:UpdateCheckboxLabels()

  -- Show the reload banner
  self:ShowReloadBanner()
end

function PU:ShowReloadBanner()
  if not self.diffReloadBanner then return end
  local n = self.appliedCount or 0
  local label = n == 1 and "1 change applied" or (n .. " changes applied")
  self.diffReloadBanner:SetText(F.String.Warning(label) .. " — click to Reload Now")
  self.diffReloadBanner:Show()
end

function PU:RefreshLayoutButtons()
  if not self.layoutBtnV or not self.layoutBtnH then return end
  if E.db.TXUI.installer.layout == I.Enum.Layouts.VERTICAL then
    self.layoutBtnV:SetText(F.String.Good("Vertical") .. F.String.Silver(" (active)"))
    self.layoutBtnH:SetText("Horizontal")
  else
    self.layoutBtnV:SetText("Vertical")
    self.layoutBtnH:SetText(F.String.Good("Horizontal") .. F.String.Silver(" (active)"))
  end
end

function PU:CreateLayoutSwitcher(parent, yOffset)
  local font = F.GetFontPath(I.Fonts.Primary)

  local label = parent:CreateFontString(nil, "OVERLAY")
  label:SetPoint("TOPLEFT", parent, "TOPLEFT", PADDING, yOffset - 6)
  label:FontTemplate(font, 13, "NONE", true)
  label:SetText("Layout:")

  local btnV = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
  btnV:SetSize(LAYOUT_BUTTON_WIDTH, BUTTON_HEIGHT)
  btnV:SetPoint("LEFT", label, "RIGHT", 8, 6)
  btnV:GetFontString():FontTemplate(font, 12, "OUTLINE", true)
  S:HandleButton(btnV)

  local btnH = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
  btnH:SetSize(LAYOUT_BUTTON_WIDTH, BUTTON_HEIGHT)
  btnH:SetPoint("LEFT", btnV, "RIGHT", 8, 0)
  btnH:GetFontString():FontTemplate(font, 12, "OUTLINE", true)
  S:HandleButton(btnH)

  btnV:SetScript("OnClick", function()
    if E.db.TXUI.installer.layout == I.Enum.Layouts.VERTICAL then return end
    E.db.TXUI.installer.layout = I.Enum.Layouts.VERTICAL
    PU:ComputeAllDiffs()
    resetDiffView()
    PU:UpdateCheckboxLabels()
    PU:RefreshLayoutButtons()
  end)

  btnH:SetScript("OnClick", function()
    if E.db.TXUI.installer.layout == I.Enum.Layouts.HORIZONTAL then return end
    E.db.TXUI.installer.layout = I.Enum.Layouts.HORIZONTAL
    PU:ComputeAllDiffs()
    resetDiffView()
    PU:UpdateCheckboxLabels()
    PU:RefreshLayoutButtons()
  end)

  self.layoutBtnV = btnV
  self.layoutBtnH = btnH
  self:RefreshLayoutButtons()
end

function PU:CreateActionButtons(parent)
  local font = F.GetFontPath(I.Fonts.Primary)

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
    PU:CloseFrame()
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
    if item then cb.label:SetText(self:BuildCheckboxLabelText(item)) end
  end
end

function PU:UpdateApplyButton()
  if not self.applyButton then return end

  local count = self:GetSelectedCount()
  self.applyButton:SetText("Apply (" .. count .. ") sections")
  if count > 0 then
    self.applyButton:Enable()
  else
    self.applyButton:Disable()
  end
end

function PU:CreateUpdaterFrame()
  local frame = CreateFrame("Frame", "TXUIProfileUpdater", E.UIParent, "BackdropTemplate")
  frame:SetPoint("CENTER", E.UIParent, "CENTER")
  frame:SetFrameStrata("HIGH")
  frame:CreateBackdrop("Transparent")
  frame:CreateCloseButton()
  frame.CloseButton:SetScript("OnClick", function()
    PU:CloseFrame()
  end)
  frame:SetMovable(true)
  frame:Hide()

  local titleDrag = CreateFrame("Frame", nil, frame, "TitleDragAreaTemplate")
  titleDrag:SetPoint("TOPLEFT", frame, "TOPLEFT")
  titleDrag:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 0, -TITLE_HEIGHT)

  local font = F.GetFontPath(I.Fonts.Primary)
  local title = frame:CreateFontString(nil, "OVERLAY")
  title:SetPoint("TOP", frame, "TOP", 0, -PADDING)
  title:FontTemplate(font, 20, "NONE", true)
  title:SetText(TXUI.Title .. " Profile Updater")

  local yOffset = -TITLE_HEIGHT

  local disclaimerText = frame:CreateFontString(nil, "OVERLAY")
  disclaimerText:SetPoint("TOPLEFT", frame, "TOPLEFT", PADDING, yOffset - 5)
  disclaimerText:SetWidth(LEFT_PANEL_WIDTH - PADDING * 2)
  disclaimerText:SetWordWrap(true)
  disclaimerText:SetJustifyH("LEFT")
  disclaimerText:SetJustifyV("TOP")
  disclaimerText:SetSpacing(2)
  disclaimerText:FontTemplate(font, 12, "NONE", true)
  disclaimerText:SetText(
    F.String.Error("WARNING:")
      .. " Applying selected sections will "
      .. F.String.Error("overwrite")
      .. " your current ElvUI settings for those sections with "
      .. TXUI.Title
      .. " defaults. Any manual changes you have made to selected sections will be lost.\n\n"
      .. F.String.Good("Hover over each section to preview what will change or to apply changes individually.")
      .. "\n\n"
      .. F.String.ToxiUI("Important: ")
      .. "It is recommended to create a backup your profile if you're afraid to lose any changes you've made.\n\n"
  )
  yOffset = yOffset - disclaimerText:GetStringHeight() - 15

  -- Layout switcher
  yOffset = yOffset - 5
  self:CreateLayoutSwitcher(frame, yOffset)
  yOffset = yOffset - (BUTTON_HEIGHT + 12)

  local checkboxes = {}
  local categories = self:GetCategories()

  for _, category in ipairs(categories) do
    yOffset = yOffset - 5
    self:CreateSectionHeader(frame, category.label, yOffset)
    yOffset = yOffset - SECTION_HEADER_HEIGHT

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

    if col > 0 then yOffset = yOffset - ROW_HEIGHT end
  end

  yOffset = yOffset - (BUTTON_HEIGHT + PADDING + 10)

  frame:SetSize(FRAME_WIDTH, -yOffset)

  self:CreateDiffPanel(frame)
  self:CreateActionButtons(frame)
  self:UpdateApplyButton()

  -- Reload prompt when closing with pending individual changes
  frame:SetScript("OnHide", function()
    if PU.pendingReload then
      local dialogName = "TXUI_PROFILE_UPDATER_RELOAD"
      E.PopupDialogs[dialogName] = {
        text = TXUI.Title .. ": Individual changes have been applied.\n\n" .. F.String.Warning("A UI reload is required for changes to take full effect."),
        button1 = "Reload UI",
        button2 = "Later",
        timeout = 0,
        whileDead = 1,
        hideOnEscape = 1,
        OnAccept = function()
          PU.pendingReload = false
          ReloadUI()
        end,
      }
      E:StaticPopup_Show(dialogName)
    end
  end)

  -- Re-show the banner if the frame is re-opened with pending changes
  frame:SetScript("OnShow", function()
    if PU.pendingReload then PU:ShowReloadBanner() end
  end)

  self.frame = frame
  self.checkboxes = checkboxes
  self:SetupAnimations(frame)
end
