local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local LP = TXUI:GetModule("LandingPage")
local S = E:GetModule("Skins")

local CreateFrame = CreateFrame

-- Layout constants
local FRAME_WIDTH = 760
local FRAME_HEIGHT = 620
local HEADER_HEIGHT = 76
local FOOTER_HEIGHT = 52
local PADDING = 20
local BUTTON_WIDTH = 110
local BUTTON_HEIGHT = 24

local CONTENT_WIDTH = FRAME_WIDTH - PADDING * 2
local CONTENT_TOP = -(HEADER_HEIGHT + PADDING)
local CONTENT_HEIGHT = FRAME_HEIGHT - HEADER_HEIGHT - FOOTER_HEIGHT - PADDING * 2

-- Wire up all animation groups. Called once at the end of BuildFrame.
function LP:SetupAnimations(frame)
  local contentArea = frame.contentArea
  local pageSubtitle = frame.pageSubtitle

  -- ── Frame enter: fade in, 0.32s ease out ────────────────────────────────────
  frame.animEnter = TXUI:CreateAnimationGroup(frame)
  do
    local fadein = frame.animEnter:CreateAnimation("fade")
    fadein:SetChange(1)
    fadein:SetDuration(0.32)
    fadein:SetEasing("out-cubic")
  end

  -- ── Frame exit: fade out, 0.22s ease in ──────────────────────────────────────
  -- OnFinished calls frame:Hide(), which fires OnHide → onClose callback.
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

  -- ── Content out: fade content area to 0, 0.13s ease in ───────────────────────
  -- OnFinished: apply buffered page content, then start the in-animations.
  contentArea.animOut = TXUI:CreateAnimationGroup(contentArea)
  do
    local fadeout = contentArea.animOut:CreateAnimation("fade")
    fadeout:SetChange(0)
    fadeout:SetDuration(0.13)
    fadeout:SetEasing("in-quadratic")
  end
  contentArea.animOut:SetScript("OnFinished", function()
    LP:ApplyPageContent()
    -- Subtitle starts invisible; its staggered animIn will reveal it
    pageSubtitle:SetAlpha(0)
    contentArea.animIn:Play()
    contentArea.subtitleAnimIn:Play()
    -- Image: fade in from 0 if the new page shows one
    local img = frame.contentImage
    if img:IsShown() then
      img:SetAlpha(0)
      img.animIn:Play()
    end
  end)

  -- ── Image out/in: mirrors content area timing ────────────────────────────────
  local contentImage = frame.contentImage
  contentImage.animOut = TXUI:CreateAnimationGroup(contentImage)
  do
    local fadeout = contentImage.animOut:CreateAnimation("fade")
    fadeout:SetChange(0)
    fadeout:SetDuration(0.13)
    fadeout:SetEasing("in-quadratic")
  end
  contentImage.animIn = TXUI:CreateAnimationGroup(contentImage)
  do
    local fadein = contentImage.animIn:CreateAnimation("fade")
    fadein:SetChange(1)
    fadein:SetDuration(0.22)
    fadein:SetEasing("out-cubic")
  end

  -- ── Content in: fade content area to 1, 0.22s ease out ───────────────────────
  contentArea.animIn = TXUI:CreateAnimationGroup(contentArea)
  do
    local fadein = contentArea.animIn:CreateAnimation("fade")
    fadein:SetChange(1)
    fadein:SetDuration(0.22)
    fadein:SetEasing("out-cubic")
  end

  -- ── Subtitle stagger: sleep 0.07s then fade in 0.18s ─────────────────────────
  -- Played simultaneously with contentArea.animIn so subtitle appears slightly after content.
  contentArea.subtitleAnimIn = TXUI:CreateAnimationGroup(pageSubtitle)
  do
    local delay = contentArea.subtitleAnimIn:CreateAnimation("sleep")
    delay:SetDuration(0.07)
    delay:SetOrder(1)

    local fadein = contentArea.subtitleAnimIn:CreateAnimation("fade")
    fadein:SetChange(1)
    fadein:SetDuration(0.18)
    fadein:SetEasing("out-cubic")
    fadein:SetOrder(2)
  end
end

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
  headerTitle:SetFont(F.GetFontPath(I.Fonts.Title), F.FontSizeScaled(24), "")
  headerTitle:SetTextColor(1, 1, 1, 1)
  headerTitle:SetText(TXUI.Title)

  -- Page subtitle below the main title (updated per page)
  local pageSubtitle = frame:CreateFontString(nil, "OVERLAY")
  pageSubtitle:SetPoint("TOPLEFT", headerTitle, "BOTTOMLEFT", 0, -1)
  pageSubtitle:SetFont(F.GetFontPath(I.Fonts.Primary), F.FontSizeScaled(11), "")
  pageSubtitle:SetTextColor(0.6, 0.6, 0.6, 1)

  -- Close button — created manually and raised above the TitleDragAreaTemplate
  -- so it captures clicks correctly (the drag area covers the full header region)
  local closeBtn = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
  closeBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 2, 2)
  closeBtn:SetFrameLevel(frame:GetFrameLevel() + 10)
  closeBtn:SetScript("OnClick", function()
    LP:CloseLandingPage()
  end)
  S:HandleCloseButton(closeBtn)

  -- Content area
  local contentArea = CreateFrame("Frame", nil, frame)
  contentArea:SetPoint("TOPLEFT", frame, "TOPLEFT", PADDING, CONTENT_TOP)
  contentArea:SetSize(CONTENT_WIDTH, CONTENT_HEIGHT)

  -- Full-bleed image flush against the header accent line, spanning the full frame width.
  -- Parented to the frame (not contentArea) so it is independent of the content padding.
  local contentImage = frame:CreateTexture(nil, "ARTWORK")
  contentImage:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -HEADER_HEIGHT)
  contentImage:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -HEADER_HEIGHT)
  contentImage:Hide()

  -- Main text block (repositioned depending on whether an image is shown)
  local contentText = contentArea:CreateFontString(nil, "OVERLAY")
  contentText:SetWidth(CONTENT_WIDTH)
  contentText:SetFont(F.GetFontPath(I.Fonts.Primary), F.FontSizeScaled(13), "")
  contentText:SetTextColor(1, 1, 1, 1)
  contentText:SetJustifyH("LEFT")
  contentText:SetJustifyV("TOP")
  contentText:SetWordWrap(true)
  contentText:SetSpacing(4)

  -- Optional action button anchored to the bottom-centre of the content area.
  -- Shown only on pages that define a `button = { text, onClick }` field.
  local contentBtn = CreateFrame("Button", nil, contentArea, "UIPanelButtonTemplate")
  contentBtn:SetSize(160, BUTTON_HEIGHT)
  contentBtn:SetPoint("BOTTOM", contentArea, "BOTTOM", 0, 0)
  contentBtn:GetFontString():FontTemplate(F.GetFontPath(I.Fonts.Primary), 12, "NONE", true)
  S:HandleButton(contentBtn)
  contentBtn:Hide()

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
      LP:CloseLandingPage()
    end
  end)

  -- "X of Y" page indicator in the centre of the footer
  local pageIndicator = footer:CreateFontString(nil, "OVERLAY")
  pageIndicator:SetPoint("CENTER", footer, "CENTER")
  pageIndicator:SetFont(F.GetFontPath(I.Fonts.Primary), F.FontSizeScaled(11), "")
  pageIndicator:SetTextColor(0.5, 0.5, 0.5, 1)

  -- Run onClose callback when the frame is hidden. Covers both the animated close
  -- path (animExit calls Hide) and any external hide (Escape, /reload, etc.).
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
  frame.contentBtn = contentBtn
  frame.prevBtn = prevBtn
  frame.nextBtn = nextBtn
  frame.pageIndicator = pageIndicator

  self.frame = frame

  self:SetupAnimations(frame)
end

-- Animated close: plays the exit animation, which calls frame:Hide() in OnFinished.
-- Use this instead of frame:Hide() for all intentional dismissals.
function LP:CloseLandingPage()
  local f = self.frame
  if not f or not f:IsShown() then return end
  -- Stop any in-progress enter or content animations before exiting
  if f.animEnter:IsPlaying() then f.animEnter:Stop() end
  f.contentArea.animOut:Stop()
  f.contentArea.animIn:Stop()
  f.contentArea.subtitleAnimIn:Stop()
  f.contentImage.animOut:Stop()
  f.contentImage.animIn:Stop()
  -- Snap alpha to fully visible so the exit animates from a known baseline
  f:SetAlpha(1)
  f.animExit:Play()
end

-- Apply the buffered page content (self.pendingPage) to the frame. Called either
-- immediately on first show, or from contentArea.animOut's OnFinished during transitions.
function LP:ApplyPageContent()
  local pages = self.activePages
  local index = self.pendingPage
  if not pages or not index then return end

  local page = pages[index]
  local f = self.frame

  -- Subtitle
  f.pageSubtitle:SetText(page.title or "")

  -- Resize frame and reposition content area depending on whether this page has an image
  f.contentText:ClearAllPoints()
  f.contentArea:ClearAllPoints()
  if page.image then
    local imgH = page.imageHeight or 200
    f.contentImage:SetTexture(page.image)
    f.contentImage:SetHeight(imgH)
    -- Cover crop: scale source to fill display area, then trim the overflow symmetrically.
    -- Requires page.imageAspect = sourceWidth / sourceHeight. Falls back to stretch.
    if page.imageAspect then
      local displayAspect = FRAME_WIDTH / imgH
      if page.imageAspect >= displayAspect then
        -- Source is wider → fit height, crop left/right
        local cropX = (imgH * page.imageAspect - FRAME_WIDTH) / (2 * imgH * page.imageAspect)
        f.contentImage:SetTexCoord(cropX, 1 - cropX, 0, 1)
      else
        -- Source is taller → fit width, crop top/bottom
        local cropY = (FRAME_WIDTH / page.imageAspect - imgH) / (2 * FRAME_WIDTH / page.imageAspect)
        f.contentImage:SetTexCoord(0, 1, cropY, 1 - cropY)
      end
    else
      f.contentImage:SetTexCoord(0, 1, 0, 1)
    end
    f.contentImage:Show()
    f.contentArea:SetPoint("TOPLEFT", f, "TOPLEFT", PADDING, -(HEADER_HEIGHT + imgH + PADDING))
    f.contentArea:SetHeight(CONTENT_HEIGHT - imgH - PADDING)
    f.contentText:SetPoint("TOP", f.contentArea, "TOP")
  else
    f.contentImage:SetTexCoord(0, 1, 0, 1)
    f.contentImage:Hide()
    f.contentArea:SetPoint("TOPLEFT", f, "TOPLEFT", PADDING, CONTENT_TOP)
    f.contentArea:SetHeight(CONTENT_HEIGHT)
    f.contentText:SetPoint("TOP", f.contentArea, "TOP")
  end

  f.contentText:SetText(page.text or "")

  -- Optional action button
  if page.button then
    f.contentBtn:SetText(page.button.text)
    f.contentBtn:SetScript("OnClick", page.button.onClick)
    f.contentBtn:Show()
  else
    f.contentBtn:Hide()
  end

  -- Navigation state
  local isLast = index == #pages
  f.prevBtn:SetShown(index > 1)
  f.nextBtn:SetText(isLast and "Close" or "Next >")
  f.pageIndicator:SetText(index .. " / " .. #pages)

  self.currentPage = index
end

-- Switch the visible content to the page at `index`.
function LP:ShowPage(index)
  local pages = self.activePages
  if not pages or index < 1 or index > #pages then return end

  self.pendingPage = index

  if self.isFirstShow then
    -- First reveal: frame is still invisible (enter anim handles the fade-in).
    -- Apply content immediately with no content transition.
    self.isFirstShow = false
    self:ApplyPageContent()
    return
  end

  -- Subsequent page changes: stop any in-progress transition, then animate out.
  local contentArea = self.frame.contentArea
  contentArea.animIn:Stop()
  contentArea.subtitleAnimIn:Stop()
  contentArea.animOut:Stop()
  -- Snap content to fully visible so the out-animation starts from a clean baseline
  contentArea:SetAlpha(1)
  contentArea.animOut:Play()
  -- Image fades out in sync with content; animIn is triggered from animOut's OnFinished
  local img = self.frame.contentImage
  img.animIn:Stop()
  img.animOut:Stop()
  img:SetAlpha(1)
  img.animOut:Play()
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
  self.isFirstShow = true

  -- Stop any lingering exit animation before re-entering
  if self.frame.animExit:IsPlaying() then self.frame.animExit:Stop() end

  -- Apply page 1 content now (frame is still hidden — no visible flash)
  self:ShowPage(1)

  -- Prime the frame for the enter animation: start invisible
  self.frame:SetAlpha(0)
  self.frame:Show()
  self.frame.animEnter:Play()
end
