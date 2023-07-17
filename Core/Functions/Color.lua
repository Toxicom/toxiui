local TXUI, F, E, I, V, P, G = unpack(select(2, ...))

F.Color = {}

function F.Color.EqualTo(aColor, bColor)
  return F.AlmostEqual(aColor.r, bColor.r) and F.AlmostEqual(aColor.g, bColor.g) and F.AlmostEqual(aColor.b, bColor.b) and F.AlmostEqual(aColor.a, bColor.a)
end

function F.Color.EqualToRGB(aColor, r, g, b)
  return F.AlmostEqual(aColor.r, r) and F.AlmostEqual(aColor.g, g) and F.AlmostEqual(aColor.b, b)
end

function F.Color.SetGradient(obj, orientation, minColor, maxColor)
  if TXUI.IsClassic then
    local r1, g1, b1, a1 = minColor:GetRGBA()
    local r2, g2, b2, a2 = maxColor:GetRGBA()
    obj:SetGradientAlpha(orientation, r1, g1, b1, a1, r2, g2, b2, a2)
  else
    obj:SetGradient(orientation, minColor, maxColor)
  end
end

function F.Color.SetGradientRGB(obj, orientation, r1, g1, b1, a1, r2, g2, b2, a2)
  if TXUI.IsClassic then
    obj:SetGradientAlpha(orientation, r1, g1, b1, a1, r2, g2, b2, a2)
  else
    F.Color.SetGradient(obj, orientation, CreateColor(r1, g1, b1, a1), CreateColor(r2, g2, b2, a2))
  end
end

function F.Color.CalculateMultiplier(multi, color)
  local r, g, b = F.CalculateMultiplierColor(multi, color.r, color.g, color.b)
  return CreateColor(r, g, b, 1)
end

function F.Color.CalculateShift(boost, colorArray)
  local modS, modL = boost and 1.6 or 1, boost and 0.6 or I.GradientMode.BackupMultiplier
  local h, s, l = F.ConvertToHSL(colorArray.r, colorArray.g, colorArray.b)
  local r, g, b = F.ConvertToRGB(F.ClampToHSL(h, s * modS, l * modL))
  return CreateColor(r, g, b, 1)
end

function F.Color.SlowCalculateShift(colorArray)
  local db = F.GetDBFromPath("TXUI.themes.gradientMode")
  return F.Color.CalculateShift(db and db.saturationBoost, colorArray)
end

function F.Color.SlowCalculateBackground(colorArray)
  local db = F.GetDBFromPath("TXUI.themes.gradientMode")
  return F.Color.CalculateMultiplier((db and db.backgroundMultiplier ~= nil) and db.backgroundMultiplier or 0.35, colorArray)
end

function F.Color.UpdateGradient(obj, perc, minColor, maxColor)
  if perc >= 1 then
    local r, g, b = maxColor:GetRGBA()
    obj:SetRGBA(r, g, b, 1)
    return
  elseif perc <= 0 then
    local r, g, b = minColor:GetRGBA()
    obj:SetRGBA(r, g, b, 1)
    return
  end

  obj:SetRGBA((maxColor.r * perc) + (minColor.r * (1 - perc)), (maxColor.g * perc) + (minColor.g * (1 - perc)), (maxColor.b * perc) + (minColor.b * (1 - perc)), 1)
end

do
  local colorCache = {}
  local colorCacheBackground = {}

  function F.Color.GenerateCache()
    local db = F.GetDBFromPath("TXUI.themes.gradientMode")
    if not db then return end

    local saturationBoost = db.saturationBoost and F.IsContributor()
    db.saturationBoost = saturationBoost

    for _, colorKey in pairs { "reactionColorMap", "castColorMap", "powerColorMap", "specialColorMap", "classColorMap", "classResourceMap" } do
      local colorMap = db[colorKey]
      if colorMap then
        for _, colorType in pairs { I.Enum.GradientMode.Color.NORMAL, I.Enum.GradientMode.Color.SHIFT } do
          local modS, modL
          if colorType == I.Enum.GradientMode.Color.NORMAL then
            modS, modL = 0.9, 1
          else
            modS, modL = 1.6, 0.6
          end

          for colorEntry, colorArray in pairs(colorMap[colorType]) do
            local r1, g1, b1

            if saturationBoost then
              local h, s, l = F.ConvertToHSL(colorArray.r, colorArray.g, colorArray.b)
              r1, g1, b1 = F.ConvertToRGB(F.ClampToHSL(h, s * modS, l * modL))
            else
              r1, g1, b1 = colorArray.r, colorArray.g, colorArray.b
            end

            local r2, g2, b2 = F.CalculateMultiplierColor(db.backgroundMultiplier, r1, g1, b1)

            local tbl1 = F.Table.GetOrCreate(colorCache, colorKey, colorType)
            local tbl2 = F.Table.GetOrCreate(colorCacheBackground, colorKey, colorType)

            if tbl1[colorEntry] then
              tbl1[colorEntry]:SetRGBA(r1, g1, b1, 1)
              tbl2[colorEntry]:SetRGBA(r2, g2, b2, 1)
            else
              tbl1[colorEntry] = CreateColor(r1, g1, b1, 1)
              tbl2[colorEntry] = CreateColor(r2, g2, b2, 1)
            end
          end
        end
      end
    end
  end

  function F.Color.GetMap(colorMap)
    return colorCache[colorMap]
  end

  function F.Color.GetBackgroundMap(colorMap)
    return colorCacheBackground[colorMap]
  end
end
