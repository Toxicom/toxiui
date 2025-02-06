local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local GR = TXUI:GetModule("ThemesGradients")

local CreateColor = CreateColor

function GR:SetGradientColors(frame, valueChanged, eR, eG, eB, colorChanged, colorFunc)
  if frame.currentColor == nil then
    frame.currentColor = eB ~= nil and CreateColor(eR, eG, eB, 1) or CreateColor(0, 0, 0, 1)
    colorChanged = true
  end

  if not colorChanged then
    colorChanged = eB ~= nil and not F.Color.EqualToRGB(frame.currentColor, eR, eG, eB)
    if colorChanged then frame.currentColor:SetRGBA(eR, eG, eB, 1) end
  end

  if colorChanged then
    local colorMap, colorEntry = colorFunc()
    colorChanged = frame.colorEntry ~= colorEntry or frame.colorMap ~= colorMap

    if colorChanged then
      frame.colorMap = colorMap
      frame.colorEntry = colorEntry
      frame.currentColor:SetRGBA(eR, eG, eB, 1)
    end
  end

  if colorChanged or frame.normalColor == nil then
    colorChanged = true

    if frame.colorMap ~= nil then
      local fgMap = F.Color.GetMap(frame.colorMap)
      local bgMap = F.Color.GetBackgroundMap(frame.colorMap)

      if fgMap ~= nil and bgMap ~= nil then
        frame.normalColor = fgMap[I.Enum.GradientMode.Color.NORMAL][frame.colorEntry]
        frame.shiftColor = fgMap[I.Enum.GradientMode.Color.SHIFT][frame.colorEntry]
        frame.normalColorBG = bgMap[I.Enum.GradientMode.Color.NORMAL][frame.colorEntry]
        frame.shiftColorBG = bgMap[I.Enum.GradientMode.Color.SHIFT][frame.colorEntry]
      end

      if frame.normalColor == nil then
        frame.colorMap = nil
        frame.colorEntry = nil
      end
    end

    if frame.colorMap == nil then
      frame.normalColor = frame.currentColor
      frame.shiftColor = F.Color.CalculateShift(self.db.saturationBoost, frame.normalColor)
      frame.normalColorBG = F.Color.CalculateMultiplier(self.db.backgroundMultiplier, frame.normalColor)
      frame.shiftColorBG = F.Color.CalculateMultiplier(self.db.backgroundMultiplier, frame.shiftColor)
    end
  end

  if not colorChanged and not self.updateCache[frame] then colorChanged = true end

  if colorChanged or valueChanged or frame.normalColorFade == nil then
    if frame.normalColorFade == nil then frame.normalColorFade = CreateColor(0, 0, 0, 1) end
    if frame.normalColorFadeBG == nil then frame.normalColorFadeBG = CreateColor(0, 0, 0, 1) end

    if frame.fadeDirection == I.Enum.GradientMode.Direction.LEFT then
      F.Color.UpdateGradient(frame.normalColorFade, frame.currentPercent, frame.shiftColor, frame.normalColor)
      F.Color.UpdateGradient(frame.normalColorFadeBG, 1 - frame.currentPercent, frame.normalColorBG, frame.shiftColorBG)
    else
      F.Color.UpdateGradient(frame.normalColorFade, frame.currentPercent, frame.normalColor, frame.shiftColor)
      F.Color.UpdateGradient(frame.normalColorFadeBG, 1 - frame.currentPercent, frame.shiftColorBG, frame.normalColorBG)
    end
  end

  local statusBar = frame.textura or frame:GetStatusBarTexture()
  local statusBarBG = frame.background or frame.bg or frame.BG

  if frame.fadeDirection == I.Enum.GradientMode.Direction.LEFT then
    F.Color.SetGradient(statusBar, frame.fadeMode, frame.shiftColor, frame.normalColorFade)
    F.Color.SetGradient(statusBarBG, frame.fadeMode, frame.normalColorFadeBG, frame.normalColorBG)
  else
    F.Color.SetGradient(statusBar, frame.fadeMode, frame.normalColor, frame.normalColorFade)
    F.Color.SetGradient(statusBarBG, frame.fadeMode, frame.normalColorFadeBG, frame.shiftColorBG)
  end

  self.updateCache[frame] = true
end
