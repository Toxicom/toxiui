local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local WB = TXUI:GetModule("WunderBar")

local pairs = pairs

WB.registeredAnimations = {}
WB.animationType = F.Enum {
  "COLOR",
  "FADE",
  "PROGRESS",
}

function WB:StopAnimationType(obj, t)
  if t == self.animationType.COLOR then
    if obj.ColorChange and obj.ColorChange:IsPlaying() then obj.ColorChange:Stop() end
    if obj.ColorFlash and obj.ColorFlash:IsPlaying() then obj.ColorFlash:Stop() end
    if obj.ColorCycle and obj.ColorCycle:IsPlaying() then obj.ColorCycle:Stop() end
  elseif t == self.animationType.FADE then
    if obj.Fade and obj.Fade:IsPlaying() then obj.Fade:Stop() end
    if obj.FlashFade and obj.FlashFade:IsPlaying() then obj.FlashFade:Stop() end

    if obj.TextTransition then
      if obj.TextTransition:IsPlaying() then obj.TextTransition:Stop() end
      if obj.TextTransition.Hold:IsPlaying() then obj.TextTransition.Hold:Stop() end
    end
  elseif t == self.animationType.PROGRESS then
    if obj.SmoothProgess and obj.SmoothProgess:IsPlaying() then obj.SmoothProgess:Stop() end
  end
end

function WB:StopAnimations(obj)
  if not obj then return self:LogDebug("StopAnimations > Called with an empty obj") end

  self:StopAnimationType(obj, self.animationType.COLOR)
  self:StopAnimationType(obj, self.animationType.FADE)
  self:StopAnimationType(obj, self.animationType.PROGRESS)
end

function WB:StopAllAnimations()
  for obj in pairs(self.registeredAnimations) do
    self:StopAnimations(obj)
  end
end

function WB:StartColorChange(obj, duration, changeColor, colorType)
  if not obj.ColorChange then
    obj.ColorChange = TXUI:CreateAnimationGroup(obj):CreateAnimation("Color")
    obj.ColorChange:SetEasing("out-quintic")
  end

  self:StopAnimationType(obj, self.animationType.COLOR)

  obj.ColorChange:SetColorType(colorType or "text")
  obj.ColorChange:SetDuration(duration)
  obj.ColorChange:SetChange(changeColor.r, changeColor.g, changeColor.b, changeColor.a)
  obj.ColorChange:Play()
end

function WB:StartColorFlash(obj, duration, normalColor, flashColor, noLoop, colorType)
  if not obj.ColorFlash then
    obj.ColorFlash = TXUI:CreateAnimationGroup(obj)

    obj.ColorFlash.ColorIn = obj.ColorFlash:CreateAnimation("Color")
    obj.ColorFlash.ColorIn:SetOrder(1)

    obj.ColorFlash.ColorOut = obj.ColorFlash:CreateAnimation("Color")
    obj.ColorFlash.ColorOut:SetOrder(2)

    self.registeredAnimations[obj] = true
  end

  self:StopAnimationType(obj, self.animationType.COLOR)

  obj.ColorFlash.ColorIn:SetColorType(colorType or "text")
  obj.ColorFlash.ColorIn:SetDuration(duration)
  obj.ColorFlash.ColorIn:SetChange(flashColor.r, flashColor.g, flashColor.b, flashColor.a)

  obj.ColorFlash.ColorOut:SetColorType(colorType or "text")
  obj.ColorFlash.ColorOut:SetDuration(duration)
  obj.ColorFlash.ColorOut:SetChange(normalColor.r, normalColor.g, normalColor.b, normalColor.a)

  obj.ColorFlash:SetLooping((noLoop == nil or noLoop == false))
  obj.ColorFlash:Play()
end

function WB:StartSmoothProgess(obj, duration, value)
  if not obj.SmoothProgess then
    obj.SmoothProgess = TXUI:CreateAnimationGroup(obj):CreateAnimation("Progress")
    obj.SmoothProgess:SetEasing("inout-quintic")

    self.registeredAnimations[obj] = true
  end

  self:StopAnimationType(obj, self.animationType.PROGRESS)

  obj.SmoothProgess:SetDuration(duration)
  obj.SmoothProgess:SetChange(value)
  obj.SmoothProgess:Play()
end

function WB:StartTextTransition(obj, duration, callback, noLoop)
  if not obj.TextTransition then
    obj.TextTransition = TXUI:CreateAnimationGroup(obj)

    obj.TextTransition.FadeOut = obj.TextTransition:CreateAnimation("Fade")
    obj.TextTransition.FadeOut:SetEasing("in-quintic")
    obj.TextTransition.FadeOut:SetDuration(duration * 0.5)
    obj.TextTransition.FadeOut:SetChange(0)
    obj.TextTransition.FadeOut:SetOrder(1)
    obj.TextTransition.FadeOut:SetScript("OnFinished", function(anim)
      anim:GetParent().TextTransition.Hold:Play()
    end)

    obj.TextTransition.Hold = TXUI:CreateAnimationGroup(obj):CreateAnimation("Sleep")
    obj.TextTransition.Hold:SetDuration(0.1)

    obj.TextTransition.FadeIn = obj.TextTransition:CreateAnimation("Fade")
    obj.TextTransition.FadeIn:SetEasing("out-quintic")
    obj.TextTransition.FadeIn:SetDuration(duration * 0.5)
    obj.TextTransition.FadeIn:SetChange(1)
    obj.TextTransition.FadeOut:SetOrder(2)

    self.registeredAnimations[obj] = true
  end

  self:StopAnimationType(obj, self.animationType.FADE)

  obj.TextTransition.Hold:SetScript("OnFinished", function(anim)
    anim.LoopCounter = anim.LoopCounter and (anim.LoopCounter + 1) or 1
    callback(anim)
    anim:GetParent().TextTransition.FadeIn:Play()
  end)

  obj.TextTransition:SetLooping((noLoop == nil or noLoop == false))
  obj.TextTransition:Play()
end

function WB:IsTextTransitionPlaying(obj)
  if not obj then return self:LogDebug("IsTextTransitionPlaying > obj was not defined") end
  if not obj.TextTransition then return false end
  return obj.TextTransition:IsPlaying()
end

function WB:StartFlashFade(obj, duration)
  if not obj.FlashFade then
    obj.FlashFade = TXUI:CreateAnimationGroup(obj)

    obj.FlashFade.FadeIn = obj.FlashFade:CreateAnimation("Fade")
    obj.FlashFade.FadeIn:SetEasing("in")
    obj.FlashFade.FadeIn:SetChange(1)
    obj.FlashFade.FadeIn:SetOrder(1)

    obj.FlashFade.FadeOut = obj.FlashFade:CreateAnimation("Fade")
    obj.FlashFade.FadeOut:SetEasing("in-quintic")
    obj.FlashFade.FadeOut:SetChange(0)
    obj.FlashFade.FadeOut:SetOrder(2)

    self.registeredAnimations[obj] = true
  end

  self:StopAnimationType(obj, self.animationType.FADE)

  obj.FlashFade.FadeIn:SetDuration(duration * 0.25)
  obj.FlashFade.FadeOut:SetDuration(duration * 0.75)

  obj.FlashFade:SetLooping(false)
  obj.FlashFade:Play()
end

function WB:StartFade(obj, duration, alpha)
  if not obj.Fade then
    obj.Fade = TXUI:CreateAnimationGroup(obj):CreateAnimation("Fade")
    obj.Fade:SetEasing("out-quintic")

    self.registeredAnimations[obj] = true
  end

  self:StopAnimationType(obj, self.animationType.FADE)

  obj.Fade:SetDuration(duration)
  obj.Fade:SetChange(alpha)
  obj.Fade:Play()
end

function WB:StartColorCycle(obj, duration, startA, endA)
  if not obj.ColorCycle then
    obj.ColorCycle = TXUI:CreateAnimationGroup(obj)
    obj.ColorCycle.Anim = obj.ColorCycle:CreateAnimation("ColorCycle")

    self.registeredAnimations[obj] = true
  elseif obj.ColorCycle:IsPlaying() then
    obj.ColorCycle:Stop()
  end

  self:StopAnimationType(obj, self.animationType.COLOR)

  obj.ColorCycle.Anim:SetDuration(duration * self.db.general.animationsMult)
  obj.ColorCycle.Anim:SetChange(startA, endA)
  obj.ColorCycle:SetLooping(true)
  obj.ColorCycle:Play()
end
