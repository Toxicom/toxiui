local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local TG = TXUI:NewModule("ThemeThreatGlow", "AceHook-3.0")

local min = math.min

-- Vars
local UF

function TG:SetupAnimations(obj)
  if obj.FlashFade == nil then
    obj.FlashFade = TXUI:CreateAnimationGroup(obj)

    obj.FlashFade.FadeIn = obj.FlashFade:CreateAnimation("Fade")
    obj.FlashFade.FadeIn:SetEasing("in")
    obj.FlashFade.FadeIn:SetChange(1)
    obj.FlashFade.FadeIn:SetOrder(1)
    obj.FlashFade.FadeIn:SetDuration(0.75)

    obj.FlashFade.FadeOut = obj.FlashFade:CreateAnimation("Fade")
    obj.FlashFade.FadeOut:SetEasing("in-quintic")
    obj.FlashFade.FadeOut:SetChange(0.6)
    obj.FlashFade.FadeOut:SetOrder(2)
    obj.FlashFade.FadeOut:SetDuration(0.75)
  end

  obj.FlashFade:SetLooping(true)
end

function TG:ThreatHandler(_, threat, parent, threatStyle, status, r, g, b)
  if not self.db or not self.db.enabled then return end
  if threatStyle ~= "GLOW" then return end
  if parent.Health == nil then return end

  local shadow = parent.Health.backdrop and parent.Health.backdrop.txSoftShadow
  if not shadow or not shadow:IsShown() then return end

  threat.MainGlow:Hide()
  self:SetupAnimations(shadow)

  if status then
    if not shadow.FlashFade:IsPlaying() then shadow.FlashFade:Play() end
    shadow:SetBackdropBorderColor(r, g, b, min(1, self.db.shadowAlpha * 1.25))
  else
    if shadow.FlashFade:IsPlaying() then shadow.FlashFade:Stop() end
    shadow:SetAlpha(1)
    shadow:SetBackdropBorderColor(0, 0, 0, self.db.shadowAlpha)
  end
end

function TG:Disable()
  if not self.Initialized then return end
  if not self:IsHooked(UF, "ThreatHandler") then return end

  self:UnhookAll()
end

function TG:Enable()
  if not self.Initialized then return end
  if self:IsHooked(UF, "ThreatHandler") then return end

  self:SecureHook(UF, "ThreatHandler", "ThreatHandler")

  UF:Update_AllFrames()
end

function TG:DatabaseUpdate()
  -- Set db
  self.db = F.GetDBFromPath("TXUI.addons.elvUITheme")

  F.Event.ContinueOutOfCombat(function()
    -- Disable only out of combat
    self:Disable()

    -- Enable only out of combat
    if TXUI:HasRequirements(I.Requirements.ElvUITheme) and (self.db and self.db.enabled) then self:Enable() end
  end)
end

function TG:Initialize()
  -- Don't init second time
  if self.Initialized then return end

  -- Register for updates
  F.Event.RegisterOnceCallback("TXUI.InitializedSafe", F.Event.GenerateClosure(self.DatabaseUpdate, self))
  F.Event.RegisterCallback("TXUI.DatabaseUpdate", self.DatabaseUpdate, self)
  F.Event.RegisterCallback("Theme.DatabaseUpdate", self.DatabaseUpdate, self)

  -- Get Frameworks
  UF = E:GetModule("UnitFrames")

  -- We are done, hooray!
  self.Initialized = true
end

TXUI:RegisterModule(TG:GetName())
