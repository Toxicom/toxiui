local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local SC = TXUI:NewModule("SplashScreen", "AceTimer-3.0")

-- Globals
local CreateFrame = CreateFrame

function SC:CreateFrame()
  local backgroundFade = CreateFrame("Frame", nil, E.UIParent, "BackdropTemplate")
  backgroundFade:SetAllPoints(E.UIParent)
  backgroundFade:SetFrameStrata("TOOLTIP")
  backgroundFade:SetFrameLevel(10000)
  backgroundFade:EnableMouse(true)
  backgroundFade:EnableMouseWheel(true)
  backgroundFade:SetAlpha(1)
  backgroundFade:Hide()

  F.CreateInnerNoise(backgroundFade)
  F.CreateInnerShadow(backgroundFade)

  local bg = F.Table.HexToRGB("#282828cc")
  local gr = F.Table.HexToRGB(I.Strings.Colors[I.Enum.Colors.TXUI])

  backgroundFade.bg = backgroundFade:CreateTexture(nil, "BACKGROUND")
  backgroundFade.bg:SetAllPoints(backgroundFade)
  backgroundFade.bg:SetTexture(E.media.blankTex)
  backgroundFade.bg:SetVertexColor(bg.r, bg.g, bg.b, bg.a)

  backgroundFade.gradient = backgroundFade:CreateTexture(nil, "ARTWORK")
  backgroundFade.gradient:SetPoint("BOTTOM", backgroundFade, "BOTTOM", 0, 0)
  backgroundFade.gradient:SetSize(F.PerfectScale(E.screenWidth), 40)
  backgroundFade.gradient:SetTexture(E.Libs.LSM:Fetch("statusbar", "TX WorldState Score"))
  backgroundFade.gradient:SetVertexColor(1, 1, 1, 1)
  F.Color.SetGradientRGB(backgroundFade.gradient, I.Enum.GradientMode.Mode[I.Enum.GradientMode.Mode.VERTICAL], gr.r, gr.g, gr.b, 0.35, gr.r, gr.g, gr.b, 0)

  backgroundFade.logo = backgroundFade:CreateTexture(nil, "OVERLAY")
  backgroundFade.logo:SetPoint("BOTTOMRIGHT", backgroundFade, "BOTTOMRIGHT", -25, 25)
  backgroundFade.logo:SetTexture(I.Media.Logos.Logo)
  backgroundFade.logo:SetSize(220 * 0.65, 120 * 0.65)

  backgroundFade.text = backgroundFade:CreateFontString(nil, "OVERLAY")
  backgroundFade.text:SetPoint("BOTTOMLEFT", backgroundFade, "BOTTOMLEFT", 25, 25)
  backgroundFade.text:SetFont(F.GetFontPath(I.Fonts.Title), F.FontSizeScaled(64), "NONE")
  backgroundFade.text:SetTextColor(1, 1, 1, 1)
  backgroundFade.text:SetText(" ")

  self.backgroundFade = backgroundFade
end

function SC:Show(text)
  self.backgroundFade.text:SetText(text)
  self.backgroundFade:Show()
end

function SC:Hide()
  self:CancelAllTimers()
  self.backgroundFade:Hide()
end

function SC:Wrap(text, func, manualHide)
  self:CancelAllTimers()
  self:Show(text)

  self:ScheduleTimer(function()
    F.EventManagerDelayed(function()
      F.ProtectedCall(func)
      if not manualHide then F.EventManagerDelayed(SC.Hide, self) end
    end)
  end, 0.2)

  -- Always force hide
  self:ScheduleTimer(function()
    F.EventManagerDelayed(SC.Hide, self)
  end, 15)
end

function SC:Initialize()
  -- Don't init second time
  if self.Initialized then return end

  -- Create our Frame
  self:CreateFrame()

  -- We are done, hooray!
  self.Initialized = true
end

TXUI:RegisterModule(SC:GetName())
