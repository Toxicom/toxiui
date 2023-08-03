local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local WB = TXUI:GetModule("WunderBar")
local DT = E:GetModule("DataTexts")

local InCombatLockdown = InCombatLockdown
local pairs = pairs

function WB:CalculateEqualWidth(width, gap)
  gap = gap / 2
  return (width / 3) - gap
end

function WB:GetHoverAllowed()
  if not self.isVisible or self.db.general.noHover then return false end
  if self.db.general.noCombatHover and InCombatLockdown() then return false end

  return true
end

function WB:GetClickAllowed()
  if not self.isVisible then return false end
  if self.db.general.noCombatClick and InCombatLockdown() then return false end

  return true
end

function WB:GetSubModuleDB(name)
  return self.db.subModules[name]
end

function WB:GetElvUIDataText(name)
  local dt = DT.RegisteredDataTexts[name]

  if dt and dt.category ~= "Data Broker" then return dt end
end

function WB:ConnectVirtualFrameToDataText(dataTextName, virtualFrame)
  local dt = self:GetElvUIDataText(dataTextName)
  if dt.applySettings then dt.applySettings(virtualFrame, E.media.hexvaluecolor) end
end

function WB:FlashFontOnEvent(fs, icon)
  if not self.db.general.animationsEvents then return end
  self:StartColorFlash(fs, 0.33 * self.db.general.animationsMult, icon and self:GetFontIconColor() or self:GetFontNormalColor(), self:GetFontAccentColor(), true)
end

function WB:SetFontNormalColor(fs, animate)
  self:SetFontColorFromDB(nil, nil, fs, animate)
end

function WB:SetFontAccentColor(fs, animate)
  self:SetFontColorFromDB(self.db.general, "accent", fs, animate)
end

function WB:SetFontIconColor(fs, animate)
  self:SetFontColorFromDB(self.db.general, "icon", fs, animate)
end

function WB:GetFontNormalColor()
  return self:GetFontColorFromDB(nil, nil)
end

function WB:GetFontAccentColor()
  return self:GetFontColorFromDB(self.db.general, "accent")
end

function WB:GetFontIconColor()
  return self:GetFontColorFromDB(self.db.general, "icon")
end

function WB:AnimationsEnabled()
  return self.db.general.animations and true or false
end

function WB:SetBarProgress(obj, value)
  if self.db.general.animations then
    self:StartSmoothProgess(obj, 1 * self.db.general.animationsMult, value)
  else
    self:StopAnimations(obj)
    obj:SetValue(value)
  end
end

function WB:FlashFade(obj)
  if self.db.general.animations then
    self:StartFlashFade(obj, 1 * self.db.general.animationsMult)
  else
    self:StopAnimations(obj)
    obj:SetAlpha(0)
  end
end

function WB:FadeIn(obj, duration)
  if self.db.general.animations then
    self:StartFade(obj, (duration or 1) * self.db.general.animationsMult, 1)
  else
    self:StopAnimations(obj)
    obj:SetAlpha(1)
  end
end

function WB:FadeOut(obj, duration)
  if self.db.general.animations then
    self:StartFade(obj, (duration or 1) * self.db.general.animationsMult, 0)
  else
    self:StopAnimations(obj)
    obj:SetAlpha(0)
  end
end

function WB:GetFontColorFromDB(db, prefix)
  local useDB = (db and prefix) and true or false

  if useDB and db[prefix .. "FontColor"] then
    return F.GetFontColorFromDB(db, prefix)
  else
    return F.GetFontColorFromDB(self.db.general, "normal")
  end
end

function WB:SetFontColor(fs, fontColor, animate)
  if (animate ~= false) and self.db.general.animations then
    self:StartColorChange(fs, 0.33 * self.db.general.animationsMult, fontColor)
  else
    self:StopAnimations(fs)
    fs:SetTextColor(fontColor.r, fontColor.g, fontColor.b, fontColor.a)
  end
end

function WB:SetNormalColorFunc(obj, colorType, multi, animate)
  self:SetColorFunc(obj, self:GetFontNormalColor(), multi, colorType, animate)
end

function WB:SetAccentColorFunc(obj, colorType, multi, animate)
  self:SetColorFunc(obj, self:GetFontAccentColor(), multi, colorType, animate)
end

function WB:SetIconColorFunc(obj, colorType, multi, animate)
  self:SetColorFunc(obj, self:GetFontIconColor(), multi, colorType, animate)
end

function WB:SetColorFunc(obj, objColor, multi, colorType, animate)
  local newColor
  if (multi ~= nil) and (multi < 1) then
    newColor = E:CopyTable({}, objColor)
    newColor.a = newColor.a * multi
  else
    newColor = objColor
  end

  if (animate ~= false) and self.db.general.animations then
    self:StartColorChange(obj, 0.33 * self.db.general.animationsMult, newColor, colorType)
  else
    self:StopAnimations(obj)
    TXUI.AnimationSetFunc[colorType or "border"](obj, newColor.r, newColor.g, newColor.b, newColor.a)
  end
end

function WB:SetFontColorFromDB(db, prefix, fs, animate)
  if (animate ~= false) and self.db.general.animations then
    self:StartColorChange(fs, 0.33 * self.db.general.animationsMult, self:GetFontColorFromDB(db, prefix))
  else
    self:StopAnimations(fs)

    local fontColor = self:GetFontColorFromDB(db, prefix)
    fs:SetTextColor(fontColor.r, fontColor.g, fontColor.b, fontColor.a)
  end
end

function WB:SetIconFromDB(db, prefix, fs, color, accent)
  local useDB = (db and prefix) and true or false

  if useDB then
    F.SetFontScaledFromDB({
      [prefix .. "Font"] = (useDB and db[prefix .. "Font"]) or self.db.general.iconFont,
      [prefix .. "FontSize"] = (useDB and db[prefix .. "FontSize"]) or self.db.general.normalFontSize,
      [prefix .. "FontOutline"] = (useDB and db[prefix .. "FontOutline"]) or self.db.general.normalFontOutline,
      [prefix .. "FontShadow"] = (useDB and db[prefix .. "FontShadow"] ~= nil) and db[prefix .. "FontShadow"] or self.db.general.normalFontShadow,
    }, prefix, fs, false)
  else
    F.SetFontScaledFromDB(self.db.general, "normal", fs, false)
  end

  if (color == nil) or (color == true) then
    if accent then
      self:SetFontColorFromDB(self.db.general, "accent", fs)
    else
      self:SetFontColorFromDB(self.db.general, "icon", fs)
    end
  end
end

function WB:SetFontFromDB(db, prefix, fs, color, accent, fontOverwrite)
  local useDB = (db and prefix) and true or false

  if useDB then
    F.SetFontScaledFromDB({
      [prefix .. "Font"] = (useDB and db[prefix .. "Font"]) or self.db.general.normalFont,
      [prefix .. "FontSize"] = (useDB and db[prefix .. "FontSize"]) or self.db.general.normalFontSize,
      [prefix .. "FontOutline"] = (useDB and db[prefix .. "FontOutline"]) or self.db.general.normalFontOutline,
      [prefix .. "FontShadow"] = (useDB and db[prefix .. "FontShadow"] ~= nil) and db[prefix .. "FontShadow"] or self.db.general.normalFontShadow,
    }, prefix, fs, false, fontOverwrite)
  else
    F.SetFontScaledFromDB(self.db.general, "normal", fs, false, fontOverwrite)
  end

  if (color == nil) or (color == true) then
    if accent then
      self:SetFontColorFromDB(self.db.general, "accent", fs)
    else
      self:SetFontColorFromDB(db, prefix, fs)
    end
  end
end

function WB:GetElvUIDummy()
  return {
    text = {
      SetText = E.noop,
      SetFormattedText = E.noop,
    },
  }
end

WB.ToxiUIShown = function()
  if E.db.TXUI.wunderbar.general.enabled and TXUI:HasRequirements(I.Requirements.WunderBar) then
    for _, mods in pairs(E.db.TXUI.wunderbar.modules) do
      for slot = 1, 3 do
        if mods[slot] == "MicroMenu" then return true end
      end
    end
  end

  return false
end
