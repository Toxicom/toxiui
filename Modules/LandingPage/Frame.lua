local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local LP = TXUI:GetModule("LandingPage")
local S = E:GetModule("Skins")

local CreateFrame = CreateFrame

-- Layout constants
local FRAME_WIDTH = 760
local FRAME_HEIGHT = 520
local HEADER_HEIGHT = 76
local FOOTER_HEIGHT = 52
local PADDING = 20
local BUTTON_WIDTH = 110
local BUTTON_HEIGHT = 24

local CONTENT_WIDTH = FRAME_WIDTH - PADDING * 2
local CONTENT_TOP = -(HEADER_HEIGHT + PADDING)
local CONTENT_HEIGHT = FRAME_HEIGHT - HEADER_HEIGHT - FOOTER_HEIGHT - PADDING * 2

function LP:BuildFrame()
  local frame = CreateFrame("Frame", "TXUILandingPage", E.UIParent, "BackdropTemplate")
  frame:SetPoint("CENTER", E.UIParent, "CENTER")
  frame:SetSize(FRAME_WIDTH, FRAME_HEIGHT)
  frame:SetFrameStrata("HIGH")
  frame:SetFrameLevel(100)
  frame:CreateBackdrop("Transparent")
  frame:SetMovable(true)
  frame:EnableMouse(true)
  frame:Hide()

  -- Drag region covers the entire header
  local titleDrag = CreateFrame("Frame", nil, frame, "TitleDragAreaTemplate")
  titleDrag:SetPoint("TOPLEFT", frame, "TOPLEFT")
  titleDrag:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 0, -HEADER_HEIGHT)

  -- Header background
  local headerBg = frame:CreateTexture(nil, "BACKGROUND")
  headerBg:SetPoint("TOPLEFT", frame, "TOPLEFT")
  headerBg:SetPoint("TOPRIGHT", frame, "TOPRIGHT")
  headerBg:SetHeight(HEADER_HEIGHT)
  headerBg:SetTexture(E.media.blankTex)
  local bgColor = F.Table.HexToRGB("#1e1e1eff")
  headerBg:SetVertexColor(bgColor.r, bgColor.g, bgColor.b, bgColor.a)

  -- ToxiUI brand accent line at the bottom of the header
  local accentLine = frame:CreateTexture(nil, "ARTWORK")
  accentLine:SetPoint("BOTTOMLEFT", headerBg, "BOTTOMLEFT")
  accentLine:SetPoint("BOTTOMRIGHT", headerBg, "BOTTOMRIGHT")
  accentLine:SetHeight(1)
  accentLine:SetTexture(E.media.blankTex)
  local gr = F.Table.HexToRGB(I.Strings.Colors[I.Enum.Colors.TXUI])
  accentLine:SetVertexColor(gr.r, gr.g, gr.b, 0.8)

  -- Main title — anchored to the vertical centre of the header
  local headerTitle = frame:CreateFontString(nil, "OVERLAY")
  headerTitle:SetPoint("LEFT", frame, "TOPLEFT", PADDING, -(HEADER_HEIGHT / 2) + 8)
  headerTitle:SetFont(F.GetFontPath(I.Fonts.Title), F.FontSizeScaled(24), "NONE")
  headerTitle:SetTextColor(1, 1, 1, 1)
  headerTitle:SetText(TXUI.Title)

  -- Page subtitle below the main title (updated per page)
  local pageSubtitle = frame:CreateFontString(nil, "OVERLAY")
  pageSubtitle:SetPoint("TOPLEFT", headerTitle, "BOTTOMLEFT", 0, -1)
  pageSubtitle:SetFont(F.GetFontPath(I.Fonts.Primary), F.FontSizeScaled(11), "NONE")
  pageSubtitle:SetTextColor(0.6, 0.6, 0.6, 1)

  -- Close button — created manually and raised above the TitleDragAreaTemplate
  -- so it captures clicks correctly (the drag area covers the full header region)
  local closeBtn = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
  closeBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 2, 2)
  closeBtn:SetFrameLevel(frame:GetFrameLevel() + 10)
  closeBtn:SetScript("OnClick", function()
    frame:Hide()
  end)
  S:HandleCloseButton(closeBtn)

  -- Content area
  local contentArea = CreateFrame("Frame", nil, frame)
  contentArea:SetPoint("TOPLEFT", frame, "TOPLEFT", PADDING, CONTENT_TOP)
  contentArea:SetSize(CONTENT_WIDTH, CONTENT_HEIGHT)

  -- Optional image texture shown at the top of the content area
  local contentImage = contentArea:CreateTexture(nil, "ARTWORK")
  contentImage:SetPoint("TOP", contentArea, "TOP")
  contentImage:Hide()

  -- Main text block (repositioned depending on whether an image is shown)
  local contentText = contentArea:CreateFontString(nil, "OVERLAY")
  contentText:SetWidth(CONTENT_WIDTH)
  contentText:SetFont(F.GetFontPath(I.Fonts.Primary), F.FontSizeScaled(13), "NONE")
  contentText:SetTextColor(1, 1, 1, 1)
  contentText:SetJustifyH("LEFT")
  contentText:SetJustifyV("TOP")
  contentText:SetWordWrap(true)
  contentText:SetSpacing(4)

  -- Footer navigation bar
  local footer = CreateFrame("Frame", nil, frame)
  footer:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", PADDING, PADDING)
  footer:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -PADDING, PADDING)
  footer:SetHeight(FOOTER_HEIGHT - PADDING)

  -- Previous button
  local prevBtn = CreateFrame("Button", nil, footer, "UIPanelButtonTemplate")
  prevBtn:SetSize(BUTTON_WIDTH, BUTTON_HEIGHT)
  prevBtn:SetPoint("LEFT", footer, "LEFT")
  prevBtn:SetText("< Previous")
  prevBtn:GetFontString():FontTemplate(F.GetFontPath(I.Fonts.Primary), 12, "NONE", true)
  S:HandleButton(prevBtn)
  prevBtn:SetScript("OnClick", function()
    LP:ShowPage(LP.currentPage - 1)
  end)

  -- Next / Close button
  local nextBtn = CreateFrame("Button", nil, footer, "UIPanelButtonTemplate")
  nextBtn:SetSize(BUTTON_WIDTH, BUTTON_HEIGHT)
  nextBtn:SetPoint("RIGHT", footer, "RIGHT")
  nextBtn:SetText("Next >")
  nextBtn:GetFontString():FontTemplate(F.GetFontPath(I.Fonts.Primary), 12, "NONE", true)
  S:HandleButton(nextBtn)
  nextBtn:SetScript("OnClick", function()
    if LP.currentPage < #LP.activePages then
      LP:ShowPage(LP.currentPage + 1)
    else
      LP.frame:Hide()
    end
  end)

  -- "X of Y" page indicator in the centre of the footer
  local pageIndicator = footer:CreateFontString(nil, "OVERLAY")
  pageIndicator:SetPoint("CENTER", footer, "CENTER")
  pageIndicator:SetFont(F.GetFontPath(I.Fonts.Primary), F.FontSizeScaled(11), "NONE")
  pageIndicator:SetTextColor(0.5, 0.5, 0.5, 1)

  -- Run onClose callback when the frame is hidden (covers both the close button
  -- and the "Close" action on the last page)
  frame:SetScript("OnHide", function()
    if LP.onClose then
      LP.onClose()
      LP.onClose = nil
    end
  end)

  frame.pageSubtitle = pageSubtitle
  frame.contentArea = contentArea
  frame.contentImage = contentImage
  frame.contentText = contentText
  frame.prevBtn = prevBtn
  frame.nextBtn = nextBtn
  frame.pageIndicator = pageIndicator

  self.frame = frame
end

-- Switch the visible content to the page at `index`.
function LP:ShowPage(index)
  local pages = self.activePages
  if not pages or index < 1 or index > #pages then return end

  self.currentPage = index
  local page = pages[index]
  local f = self.frame

  -- Update subtitle
  f.pageSubtitle:SetText(page.title or "")

  -- Reposition text depending on whether this page has an image
  f.contentText:ClearAllPoints()
  if page.image then
    f.contentImage:SetTexture(page.image)
    f.contentImage:SetSize(page.imageWidth or CONTENT_WIDTH, page.imageHeight or 200)
    f.contentImage:Show()
    f.contentText:SetPoint("TOPLEFT", f.contentImage, "BOTTOMLEFT", 0, -10)
  else
    f.contentImage:Hide()
    f.contentText:SetPoint("TOP", f.contentArea, "TOP")
  end

  f.contentText:SetText(page.text or "")

  -- Navigation state
  local isLast = index == #pages
  if index == 1 then
    f.prevBtn:Hide()
  else
    f.prevBtn:Show()
  end
  f.nextBtn:SetText(isLast and "Close" or "Next >")

  -- Page indicator
  f.pageIndicator:SetText(index .. " / " .. #pages)
end

-- Show the landing page with `config.pages` (array of page tables) and an
-- optional `config.onClose` callback that fires when the frame is hidden.
--
-- Page table fields:
--   title       string   — subtitle shown under the ToxiUI logo
--   text        string   — main body (supports F.String.* colour helpers)
--   image       string?  — optional texture path
--   imageWidth  number?  — display width for the image (default: full content width)
--   imageHeight number?  — display height for the image (default: 200)
function LP:ShowLandingPage(config)
  if not self.frame then self:BuildFrame() end

  self.activePages = config.pages
  self.currentPage = 0
  self.onClose = config.onClose

  self:ShowPage(1)
  self.frame:Show()
end
