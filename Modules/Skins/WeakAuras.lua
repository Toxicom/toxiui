local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local S = TXUI:GetModule("Skins")

-- Globals
local _G = _G
local abs = math.abs
local CreateFrame = CreateFrame
local ipairs = ipairs
local unpack = unpack

function S:WeakAuras_SkinIcon(region, data)
  -- Fake WAs, like previews etc
  if not region or not region.id then return end

  -- Create Mask
  if not region.styledMask then
    region.styledMask = CreateFrame("FRAME", nil, region)
    region.styledMask:EnableMouse(false)
  end

  region.ToxiUIApplyMaskSettings = function()
    -- Style Icons and fit to mask
    region.icon:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
    region.icon:SetDrawLayer("BACKGROUND", 0)
    region.icon:SetSize(region.styledMask:GetWidth(), region.styledMask:GetHeight())
    region.icon:ClearAllPoints()
    region.icon:SetPoint("CENTER", region.styledMask, "CENTER", 0, 0)

    -- Style cooldown text
    region.cooldown:SetSize(region.styledMask:GetWidth(), region.styledMask:GetHeight())
    region.cooldown:ClearAllPoints()
    region.cooldown:SetPoint("CENTER", region.styledMask, "CENTER", 0, 0)
  end

  region.UpdateTexCoords = function()
    local mirror_h = region.scalex < 0
    local mirror_v = region.scaley < 0

    local texWidth = 1 - 0.5 * region.zoom
    local aspectRatio
    if not region.keepAspectRatio then
      aspectRatio = 1 / self.waIconMult
    else
      local width = region.width * abs(region.scalex)
      local height = region.height * abs(region.scaley) * self.waIconMult

      if width == 0 or height == 0 then
        aspectRatio = 1 / self.waIconMult
      else
        aspectRatio = width / height
      end
    end

    region:ToxiUIApplyMaskSettings()

    -- GetTexCoord replacement
    do
      local left, right = unpack(E.TexCoords)

      region.currentCoord = region.currentCoord or {}
      region.currentCoord[1], region.currentCoord[2], region.currentCoord[3], region.currentCoord[4], region.currentCoord[5], region.currentCoord[6], region.currentCoord[7], region.currentCoord[8] =
        left, left, left, right, right, left, right, right

      local xRatio = aspectRatio < 1 and aspectRatio or 1
      local yRatio = aspectRatio > 1 and 1 / aspectRatio or 1
      for i, coord in ipairs(region.currentCoord) do
        region.currentCoord[i] = (coord - 0.5) * texWidth * ((i % 2 == 1) and xRatio or yRatio) + 0.5
      end
    end

    local ulx, uly, llx, lly, urx, ury, lrx, lry = unpack(region.currentCoord)

    if mirror_h then
      if mirror_v then
        region.icon:SetTexCoord(lrx, lry, urx, ury, llx, lly, ulx, uly)
      else
        region.icon:SetTexCoord(urx, ury, lrx, lry, ulx, uly, llx, lly)
      end
    else
      if mirror_v then
        region.icon:SetTexCoord(llx, lly, ulx, uly, lrx, lry, urx, ury)
      else
        region.icon:SetTexCoord(ulx, uly, llx, lly, urx, ury, lrx, lry)
      end
    end
  end

  -- Overwrite Calculation to use styled Mask instead of region
  region.UpdateInnerOuterSize = function()
    if not region.inner and not region.outer then return end

    local width = region.width * abs(region.scalex)
    local height = region.height * abs(region.scaley)

    local iconBorder = E:Scale(2)
    local iconWidth = region.styledMask:GetWidth()
    local iconHeight = region.styledMask:GetHeight()

    if region.inner then region.inner:SetSize(iconWidth - (0.2 * width), iconHeight - (0.2 * height)) end
    if region.outer then region.outer:SetSize(iconWidth + iconBorder + (0.1 * width), iconHeight + iconBorder + (0.1 * height)) end
  end

  -- Overwrite calculation to update styled mask as well
  region.UpdateSize = function()
    local width = region.width * abs(region.scalex)
    local height = region.height * abs(region.scaley)

    region:SetWidth(width)
    region:SetHeight(height)
    region.styledMask:ClearAllPoints()
    region.styledMask:SetPoint("CENTER", region, "CENTER", 0, 0)
    region.styledMask:SetWidth(width)
    region.styledMask:SetHeight(height * self.waIconMult)
    region:UpdateTexCoords()
  end

  -- Overwrite calculation to color to apply alpha correctly
  region.Color = function(_, r, g, b, a)
    region.color_r = r
    region.color_g = g
    region.color_b = b
    region.color_a = a
    if r or g or b then a = a or 1 end

    region.icon:SetVertexColor(region.color_anim_r or r, region.color_anim_g or g, region.color_anim_b or b, region.color_anim_a or a)
    if region.icon.backdrop then region.icon.backdrop:SetAlpha(region.color_anim_a or a or 1) end
  end

  -- Overwrite calculation to color to apply alpha correctly
  region.ColorAnim = function(_, r, g, b, a)
    region.color_anim_r = r
    region.color_anim_g = g
    region.color_anim_b = b
    region.color_anim_a = a
    if r or g or b then a = a or 1 end

    region.icon:SetVertexColor(r or region.color_r, g or region.color_g, b or region.color_b, a or region.color_a)
    if region.icon.backdrop then region.icon.backdrop:SetAlpha(a or region.color_a or 1) end
  end

  -- Hook glow type so we can fix the subregion anchor
  for _, subRegion in ipairs(region.subRegions) do
    if (subRegion.type == "subglow") and subRegion.SetGlowType and not subRegion.TXSetGlowTypeOld then
      subRegion.TXSetGlowTypeOld = subRegion.SetGlowType
      subRegion.SetGlowType = function(glowRegion, newType)
        subRegion.TXSetGlowTypeOld(glowRegion, newType)

        if newType == "buttonOverlay" then
          local iconBorder = E:Scale(2)
          glowRegion:ClearAllPoints()
          glowRegion:SetPoint("bottomleft", region.styledMask, "bottomleft", -iconBorder, -iconBorder)
          glowRegion:SetPoint("topright", region.styledMask, "topright", iconBorder, iconBorder)
        elseif newType == "ACShine" then
          local iconBorder = E:Scale(1)
          glowRegion:ClearAllPoints()
          glowRegion:SetPoint("bottomleft", region.styledMask, "bottomleft", -iconBorder, -iconBorder)
          glowRegion:SetPoint("topright", region.styledMask, "topright", iconBorder, iconBorder)
        elseif newType == "Pixel" then
          glowRegion:ClearAllPoints()
          glowRegion:SetPoint("bottomleft", region.styledMask, "bottomleft", 0, 0)
          glowRegion:SetPoint("topright", region.styledMask, "topright", 0, 0)
        end

        glowRegion:SetFrameLevel(region.styledMask:GetFrameLevel() + 1)
      end

      subRegion.SetGlowType(subRegion, subRegion.glowType)
    end
  end

  -- Create Border
  if not region.icon.backdrop then region.icon:CreateBackdrop("Default", nil, false, false, true) end

  -- Disable template background
  region.icon.backdrop.Center:StripTextures()
  region.icon.backdrop.Center:Kill()
  region.icon.backdrop:SetParent(region.styledMask)
  region.icon.backdrop.icon = region.icon

  -- Listen to size changes
  region:SetScript("OnSizeChanged", E.noop)
  region.icon:SetAllPoints(region.styledMask)
  region.styledMask:SetScript("OnSizeChanged", region.UpdateInnerOuterSize)

  -- Now force update
  region:ToxiUIApplyMaskSettings()
  region:UpdateSize()
  region:Color(data.color[1], data.color[2], data.color[3], data.color[4])
end

function S:WeakAuras_SkinAuraBar(region)
  -- Fake WAs, like previews etc
  if not region or not region.id then return end

  if not region.backdrop then region:CreateBackdrop("Default", nil, false, false, true) end
  region.backdrop:SetParent(region)
  region.backdrop.Center:StripTextures()
  region.backdrop.Center:Kill()

  region.icon:SetParent(region)
  region.icon:SetTexCoord(unpack(E.TexCoords))
  region.icon.SetTexCoord = E.noop

  if not region.iconFrame.backdrop then region.iconFrame:CreateBackdrop("Default", nil, false, false, true) end
  region.iconFrame:SetParent(region)
  region.iconFrame:SetAllPoints(region.icon)
  region.iconFrame:CreateBackdrop()
  region.iconFrame.backdrop:SetParent(region.iconFrame)
  region.iconFrame.backdrop.Center:StripTextures()
  region.iconFrame.backdrop.Center:Kill()
end

function S:WeakAuras_HandlePrototype(_, region, data)
  if not region then return end
  local regionType = region.regionType
  if self.waIconEnabled and regionType == "icon" then
    self:WeakAuras_SkinIcon(region, data)
  elseif self.waBarEnabled and regionType == "aurabar" then
    self:WeakAuras_SkinAuraBar(region)
  end
end

function S:WeakAuras()
  -- Get dbs
  local iconDB = F.GetDBFromPath("TXUI.addons.weakAurasIcons")
  local barDB = F.GetDBFromPath("TXUI.addons.weakAurasBars")

  -- Get Enable State
  local isIconEnabled = iconDB and iconDB.enabled
  local isBarEnabled = barDB and barDB.enabled

  -- Check state and requirements
  self.waIconEnabled = isIconEnabled and TXUI:HasRequirements(I.Requirements.WeakAurasIcons)
  self.waBarEnabled = isBarEnabled and TXUI:HasRequirements(I.Requirements.WeakAurasBars)
  self.waIconMult = (isIconEnabled and (iconDB.iconShape == I.Enum.IconShape.RECTANGLE)) and 0.75 or 1

  -- Hook prototypes
  self:SecureHook(_G.WeakAuras.regionPrototype, "create", F.Event.GenerateClosure(S.WeakAuras_HandlePrototype, self, nil))
  self:SecureHook(_G.WeakAuras.regionPrototype, "modifyFinish", F.Event.GenerateClosure(S.WeakAuras_HandlePrototype, self))
end
