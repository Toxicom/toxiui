local TXUI = unpack((select(2, ...)))
local VB = TXUI:GetModule("VehicleBar")

local ipairs = ipairs

function VB:StopAllAnimations()
  if self.bar.SlideIn and (self.bar.SlideIn.SlideIn:IsPlaying()) then self.bar.SlideIn.SlideIn:Finish() end

  for _, button in ipairs(self.bar.buttons) do
    if button.FadeIn and (button.FadeIn:IsPlaying()) then
      button.FadeIn:Stop()
      button:SetAlpha(1)
    end
  end

  if self:IsVigorAvailable() and self.vigorBar and self.vigorBar.segments then
    for _, segment in ipairs(self.vigorBar.segments) do
      if segment.FadeIn and (segment.FadeIn:IsPlaying()) then
        segment.FadeIn:Stop()
        segment:SetAlpha(1)
      end
    end

    if self.vigorBar.speedText.FadeIn and (self.vigorBar.speedText.FadeIn:IsPlaying()) then
      self.vigorBar.speedText.FadeIn:Stop()
      self.vigorBar.speedText:SetAlpha(1)
    end
  end
end

function VB:SetupButtonAnim(button, index)
  local iconFade = (1 * self.db.animationsMult)
  local iconHold = (index * 0.10) * self.db.animationsMult

  button.FadeIn = button.FadeIn or TXUI:CreateAnimationGroup(button)

  button.FadeIn.ResetFade = button.FadeIn.ResetFade or button.FadeIn:CreateAnimation("Fade")
  button.FadeIn.ResetFade:SetDuration(0)
  button.FadeIn.ResetFade:SetChange(0)
  button.FadeIn.ResetFade:SetOrder(1)

  button.FadeIn.Hold = button.FadeIn.Hold or button.FadeIn:CreateAnimation("Sleep")
  button.FadeIn.Hold:SetDuration(iconHold)
  button.FadeIn.Hold:SetOrder(2)

  button.FadeIn.Fade = button.FadeIn.Fade or button.FadeIn:CreateAnimation("Fade")
  button.FadeIn.Fade:SetEasing("out-quintic")
  button.FadeIn.Fade:SetChange(1)
  button.FadeIn.Fade:SetDuration(iconFade)
  button.FadeIn.Fade:SetOrder(3)
end
