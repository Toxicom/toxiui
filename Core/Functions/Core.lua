local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local LSM = E.Libs.LSM

local _G = _G
local abs = math.abs
local C_Covenants_GetActiveCovenantID = TXUI.IsRetail and C_Covenants.GetActiveCovenantID
local C_Covenants_GetCovenantData = TXUI.IsRetail and C_Covenants.GetCovenantData
local COVENANT_COLORS = COVENANT_COLORS
local CreateFrame = CreateFrame
local CreateFromMixins = CreateFromMixins
local error = error
local FindSpellOverrideByID = FindSpellOverrideByID
local format = string.format
local GetItemCount = GetItemCount
local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo
local GetSpellCooldown = (C_Spell and C_Spell.GetSpellCooldown) or GetSpellCooldown
local GetTime = GetTime
local gmatch = string.gmatch
local gsub = string.gsub
local ipairs = ipairs
local IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local IsSpellKnownOrOverridesKnown = IsSpellKnownOrOverridesKnown
local ItemMixin = ItemMixin
local match = string.match
local max = math.max
local min = math.min
local modf = math.modf
local next = next
local pairs = pairs
local pcall = pcall
local PlayerHasToy = PlayerHasToy
local ReloadUI = ReloadUI
local select = select
local setmetatable = setmetatable
local SpellMixin = SpellMixin
local strsplit = strsplit
local tcontains = tContains
local tinsert = table.insert
local tonumber = tonumber
local tremove = tremove
local type = type
local UnitLevel = UnitLevel
local unpack = unpack
local xpcall = xpcall

function F.IsTXUIProfile()
  local releaseVersion = F.GetDBFromPath("TXUI.changelog.releaseVersion")
  return not (not releaseVersion or releaseVersion == 0)
end

function F.ResetTXUIProfile()
  if not F.IsTXUIProfile() then return TXUI:LogDebug(TXUI, "ResetTXUIProfile > No TXUI Profile found") end

  local changelogData = {}
  local changelogPrivateData = {}

  E:CopyTable(changelogData, E.db.TXUI.changelog)
  E:CopyTable(changelogPrivateData, E.private.TXUI.changelog)

  E:CopyTable(E.db.TXUI, P)
  E:CopyTable(E.private.TXUI, V)

  E.db.TXUI.changelog = changelogData
  E.private.TXUI.changelog = changelogPrivateData

  ReloadUI()
end

function F.ResetModuleProfile(profile)
  if not F.IsTXUIProfile() then return TXUI:LogDebug(TXUI, "ResetModuleProfile > No TXUI Profile found") end
  if P[profile] == nil then return TXUI:LogDebug(TXUI, "ResetModuleProfile > Invalid config:", profile) end

  E:CopyTable(E.db.TXUI[profile], P[profile])
  ReloadUI()
end

function F.ResetMiscProfile(profile)
  if not F.IsTXUIProfile() then return TXUI:LogDebug(TXUI, "ResetMiscProfile > No TXUI Profile found") end
  if P.misc[profile] == nil then return TXUI:LogDebug(TXUI, "ResetMiscProfile > Invalid config:", profile) end

  E:CopyTable(E.db.TXUI.misc[profile], P.misc[profile])
  ReloadUI()
end

function F.IsAddOnEnabled(addon)
  return IsAddOnLoaded(addon)
end

function F.Enum(tbl)
  local length = #tbl
  for i = 1, length do
    local v = tbl[i]
    tbl[v] = i
  end

  return tbl
end

function F.Round(n, q)
  q = q or 1

  local int, frac = modf(n / q)
  if n == abs(n) and frac >= 0.5 then
    return (int + 1) * q
  elseif frac <= -0.5 then
    return (int - 1) * q
  end

  return int * q
end

function F.AlmostEqual(a, b)
  if not a or not b then return false end

  return abs(a - b) <= 0.001
end

function F.PerfectScale(n)
  local m = E.mult
  return (m == 1 or n == 0) and n or (n * m)
end

local doubleScaleResolutions = {
  [2054] = true,
  [2160] = true,
  [2880] = true,
  [1971] = true,
}

local customScaleResolutions = {
  [1920] = 0.65,
}

function F.PixelPerfect()
  local perfectScale = 768 / E.physicalHeight
  if doubleScaleResolutions[E.physicalHeight] then perfectScale = perfectScale * 1.5 end
  if customScaleResolutions[E.physicalHeight] then perfectScale = customScaleResolutions[E.physicalHeight] end
  return perfectScale
end

local baseScale = 768 / 1440 -- 0,5333333333333333
local baseMulti = 0.64 / baseScale -- 1,2
local perfectScale = baseScale / F.PixelPerfect()
local perfectMulti = baseMulti * perfectScale

function F.HiDpi()
  return E.physicalHeight / 1440 >= 1
end

function F.Dpi(value, frac)
  return F.Round(value * perfectMulti, frac)
end

function F.DpiRaw(value)
  return value * perfectMulti
end

function F.FontSizeScaled(value, clamp)
  value = E.db.TXUI and E.db.TXUI.addons and E.db.TXUI.addons.fontScale and (value + E.db.TXUI.addons.fontScale) or value
  clamp = (clamp and (E.db.TXUI and E.db.TXUI.addons and E.db.TXUI.addons.fontScale) and (clamp + E.db.TXUI.addons.fontScale) or clamp) or 0
  return F.Clamp(F.Clamp(F.Round(value * perfectScale), clamp or 0, 64), 8, 64)
end

function F.FontSize(value)
  value = E.db.TXUI and E.db.TXUI.addons and E.db.TXUI.addons.fontScale and (value + E.db.TXUI.addons.fontScale) or value
  return F.Clamp(value, 8, 64)
end

function F.Position(anchor1, parent, anchor2, x, y, offset, negative)
  local offsetX = 0

  if offset then
    offsetX = F.CalculateUltrawideOffset()

    if negative then offsetX = offsetX * -1 end
  end

  return format("%s,%s,%s,%d,%d", anchor1, parent, anchor2, F.Dpi(x) + offsetX, F.Dpi(y))
end

function F.Clamp(value, s, b)
  return min(max(value, s), b)
end

function F.ClampTo01(value)
  return F.Clamp(value, 0, 1)
end

function F.ClampToHSL(h, s, l)
  return h % 360, F.ClampTo01(s), F.ClampTo01(l)
end

function F.ConvertFromHue(m1, m2, h)
  if h < 0 then h = h + 1 end
  if h > 1 then h = h - 1 end

  if h * 6 < 1 then
    return m1 + (m2 - m1) * h * 6
  elseif h * 2 < 1 then
    return m2
  elseif h * 3 < 2 then
    return m1 + (m2 - m1) * (2 / 3 - h) * 6
  else
    return m1
  end
end

function F.ConvertToRGB(h, s, l)
  h = h / 360

  local m2 = l <= 0.5 and l * (s + 1) or l + s - l * s
  local m1 = l * 2 - m2

  return F.ConvertFromHue(m1, m2, h + 1 / 3), F.ConvertFromHue(m1, m2, h), F.ConvertFromHue(m1, m2, h - 1 / 3)
end

function F.ConvertToHSL(r, g, b)
  r = r or 0
  g = g or 0
  b = b or 0

  local minColor = min(r, g, b)
  local maxColor = max(r, g, b)
  local colorDelta = maxColor - minColor

  local h, s, l = 0, 0, (minColor + maxColor) / 2

  if l > 0 and l < 0.5 then s = colorDelta / (maxColor + minColor) end
  if l >= 0.5 and l < 1 then s = colorDelta / (2 - maxColor - minColor) end

  if colorDelta > 0 then
    if maxColor == r and maxColor ~= g then h = h + (g - b) / colorDelta end
    if maxColor == g and maxColor ~= b then h = h + 2 + (b - r) / colorDelta end
    if maxColor == b and maxColor ~= r then h = h + 4 + (r - g) / colorDelta end
    h = h / 6
  end

  if h < 0 then h = h + 1 end
  if h > 1 then h = h - 1 end

  return h * 360, s, l
end

function F.CalculateMultiplierColor(multi, r, g, b)
  local h, s, l = F.ConvertToHSL(r, g, b)
  return F.ConvertToRGB(F.ClampToHSL(h, s, l * multi))
end

function F.CalculateMultiplierColorArray(multi, colors)
  local r, g, b

  if colors.r then
    r, g, b = colors.r, colors.g, colors.b
  else
    r, g, b = colors[1], colors[2], colors[3]
  end

  return F.CalculateMultiplierColor(multi, r, g, b)
end

function F.SlowColorGradient(perc, ...)
  if perc >= 1 then
    return select(select("#", ...) - 2, ...)
  elseif perc <= 0 then
    return ...
  end

  local num = select("#", ...) / 3
  local segment, relperc = modf(perc * (num - 1))
  local r1, g1, b1, r2, g2, b2 = select((segment * 3) + 1, ...)

  return F.FastColorGradient(relperc, r1, g1, b1, r2, g2, b2)
end

function F.FastColorGradient(perc, r1, g1, b1, r2, g2, b2)
  if perc >= 1 then
    return r2, g2, b2
  elseif perc <= 0 then
    return r1, g1, b1
  end

  return (r2 * perc) + (r1 * (1 - perc)), (g2 * perc) + (g1 * (1 - perc)), (b2 * perc) + (b1 * (1 - perc))
end

function F.FontOverride(font)
  local override = F.GetDBFromPath("TXUI.general.fontOverride")[font]
  return (override and override ~= "DEFAULT") and override or font
end

function F.FontStyleOverride(font, style)
  local override = F.GetDBFromPath("TXUI.general.fontStyleOverride")[font]
  return (override and override ~= "DEFAULT") and override or style
end

function F.GetFontShadowOverride(font, shadow)
  local override = F.GetDBFromPath("TXUI.general.fontShadowOverride")[font]
  if override ~= nil and override ~= "DEFAULT" then return override end
  return shadow
end

function F.RemoveFontTemplate(fs)
  E.texts[fs] = nil
end

function F.GetFontColorFromDB(db, prefix)
  -- Vars
  if prefix == nil then prefix = "" end
  local fontColor
  local useDB = (db and prefix) and true or false
  local colorSwitch = (useDB and db[prefix .. "FontColor"]) or I.General.DefaultFontColor

  -- Switch
  if colorSwitch == "CUSTOM" then
    fontColor = (useDB and db[prefix .. "FontCustomColor"]) or I.General.DefaultFontCustomColor
  elseif colorSwitch == "TXUI" then
    fontColor = I.Strings.Branding.ColorRGBA
  elseif colorSwitch == "CLASS" then
    local classColor = E:ClassColor(E.myclass, true)
    fontColor = {
      r = classColor.r,
      g = classColor.g,
      b = classColor.b,
      a = 1,
    }
  elseif colorSwitch == "VALUE" then
    fontColor = {
      r = E.media.rgbvaluecolor[1],
      g = E.media.rgbvaluecolor[2],
      b = E.media.rgbvaluecolor[3],
      a = 1,
    }
  elseif colorSwitch == "COVENANT" then
    local covenantColor = COVENANT_COLORS[F.GetCachedCovenant()] or I.Strings.Branding.ColorRGBA
    fontColor = {
      r = covenantColor.r,
      g = covenantColor.g,
      b = covenantColor.b,
      a = 1,
    }
  else
    fontColor = {
      r = 1,
      g = 1,
      b = 1,
      a = 1,
    }
  end

  return fontColor
end

function F.SetFontColorFromDB(db, prefix, fs)
  local fontColor = F.GetFontColorFromDB(db, prefix)
  F.RemoveFontTemplate(fs)
  fs:SetTextColor(fontColor.r, fontColor.g, fontColor.b, fontColor.a)
end

function F.SetFontScaledFromDB(db, prefix, fs, color, fontOverwrite)
  F.SetFontFromDB(db, prefix, fs, color, fontOverwrite, true)
end

function F.GetFontPath(font)
  font = font or I.General.DefaultFont

  local lsmFont = LSM:Fetch("font", F.FontOverride(font))
  if not lsmFont then lsmFont = LSM:Fetch("font", font) end -- backup to non-override font
  if not lsmFont then lsmFont = LSM:Fetch("font", I.General.DefaultFont) end -- backup to normal font if not found
  if not lsmFont then lsmFont = E.media.normFont end -- backup to elvui font if not found

  return lsmFont
end

function F.SetFontFromDB(db, prefix, fs, color, fontOverwrite, useScaling)
  local useDB = (db and prefix) and true or false
  local font = (useDB and db[prefix .. "Font"]) or I.General.DefaultFont
  local size = (useDB and db[prefix .. "FontSize"]) or I.General.DefaultFontSize
  local outline = (useDB and db[prefix .. "FontOutline"]) or I.General.DefaultFontOutline
  local shadow = (useDB and db[prefix .. "FontShadow"] ~= nil) and db[prefix .. "FontShadow"]
  if shadow == nil then shadow = I.General.DefaultFontShadow end

  if fontOverwrite then font = fontOverwrite end
  local lsmFont = F.GetFontPath(font)

  shadow = F.GetFontShadowOverride(font, shadow)
  outline = F.FontStyleOverride(font, outline)

  if outline == "NONE" then outline = "" end

  F.RemoveFontTemplate(fs)
  fs:SetFont(lsmFont, useScaling and F.FontSizeScaled(size) or size, (not shadow and outline) or "")

  if shadow then
    fs:SetShadowOffset(1, -0.5)
    fs:SetShadowColor(0, 0, 0, 1)
  else
    fs:SetShadowOffset(0, 0)
    fs:SetShadowColor(0, 0, 0, 0)
  end

  if (color == nil) or (color == true) then F.SetFontColorFromDB(db, prefix, fs) end
end

do
  local throttleNamespaces = {}

  function F.CreateThrottleWrapper(namespace, throttle, func)
    return function(...)
      local currentTime = GetTime()
      if throttleNamespaces[namespace] and ((currentTime - throttleNamespaces[namespace]) <= throttle) then return end
      throttleNamespaces[namespace] = currentTime
      return func(...)
    end
  end
end

do
  local protected_call = {}

  function protected_call._error_handler(err)
    TXUI:LogWarning(err)
  end

  function protected_call._handle_result(success, ...)
    if success then return ... end
  end

  local do_pcall
  if not select(
    2,
    xpcall(function(a)
      return a
    end, error, true)
  ) then
    do_pcall = function(func, ...)
      local args = { ... }
      return protected_call._handle_result(xpcall(function()
        return func(unpack(args))
      end, protected_call._error_handler))
    end
  else
    do_pcall = function(func, ...)
      return protected_call._handle_result(xpcall(func, protected_call._error_handler, ...))
    end
  end

  function protected_call.call(func, ...)
    return do_pcall(func, ...)
  end

  local pcall_mt = {}
  function pcall_mt:__call(...)
    return do_pcall(...)
  end

  F.ProtectedCall = setmetatable(protected_call, pcall_mt)
end

do
  local eventManagerFrame, eventManagerTable, eventManagerDelayed = CreateFrame("Frame"), {}, {}

  eventManagerFrame:SetScript("OnUpdate", function()
    for _, func in ipairs(eventManagerDelayed) do
      F.ProtectedCall(unpack(func))
    end
    eventManagerDelayed = {}
  end)

  function F.EventManagerDelayed(func, ...)
    tinsert(eventManagerDelayed, { func, ... })
  end

  eventManagerFrame:SetScript("OnEvent", function(_, event, ...)
    local namespaces = eventManagerTable[event]
    if namespaces then
      for _, funcs in pairs(namespaces) do
        for _, func in ipairs(funcs) do
          func(event, ...)
        end
      end
    end
  end)

  function F.EventManagerRegister(namespace, event, func)
    local namespaces = eventManagerTable[event]

    if not namespaces then
      eventManagerTable[event] = {}
      namespaces = eventManagerTable[event]
      pcall(eventManagerFrame.RegisterEvent, eventManagerFrame, event)
    end

    local funcs = namespaces[namespace]

    if not funcs then
      namespaces[namespace] = { func }
    elseif not tcontains(funcs, func) then
      tinsert(funcs, func)
    end
  end

  function F.EventManagerUnregisterAll(namespace)
    for event in pairs(eventManagerTable) do
      local namespaces = eventManagerTable[event]
      local funcs = namespaces and namespaces[namespace]
      if funcs ~= nil then F.EventManagerUnregister(namespace, event) end
    end
  end

  function F.EventManagerUnregister(namespace, event, func)
    local namespaces = eventManagerTable[event]
    local funcs = namespaces and namespaces[namespace]

    if funcs then
      for index, fnc in ipairs(funcs) do
        if not func or (func == fnc) then
          tremove(funcs, index)
          break
        end
      end

      if #funcs == 0 then namespaces[namespace] = nil end

      if not next(funcs) then
        eventManagerFrame:UnregisterEvent(event)
        eventManagerTable[event] = nil
      end
    end
  end
end

do
  local devCache
  local roleCache
  local nameCache
  local myRealmName
  local isKnownPlayer

  function F.BuildMyRealmName()
    myRealmName = E.myname .. "-" .. E:ShortenRealm(E.myrealm)
  end

  function F.BuildRoleCache()
    devCache = {}
    roleCache = {}
    nameCache = {}

    local devIcon = E:TextureString(I.Media.ChatIcons.Dev, ":10:24") .. " "
    local legendaryIcon = E:TextureString(I.Media.ChatIcons.Legendary, ":10:24") .. " "
    local epicIcon = E:TextureString(I.Media.ChatIcons.Epic, ":10:24") .. " "
    local rareIcon = E:TextureString(I.Media.ChatIcons.Rare, ":10:24") .. " "

    local addToRoleCache = function(db, icon, dev)
      for entry, person in pairs(db) do
        if person[TXUI.Flavor] then
          for name, _ in pairs(person[TXUI.Flavor]) do
            roleCache[name] = icon

            if dev then
              devCache[name] = entry
              nameCache[name] = F.String.UppercaseFirstLetterOnly(I.Enum.Developers[entry])
            else
              nameCache[name] = entry
            end
          end
        end
      end
    end

    addToRoleCache(I.Data.Contributor[I.Enum.ContributorType.DEV], devIcon, true)
    addToRoleCache(I.Data.Contributor[I.Enum.ContributorType.LEGENDARY], legendaryIcon)
    addToRoleCache(I.Data.Contributor[I.Enum.ContributorType.EPIC], epicIcon)
    addToRoleCache(I.Data.Contributor[I.Enum.ContributorType.RARE], rareIcon)
    addToRoleCache(I.Data.Contributor[I.Enum.ContributorType.BETA], legendaryIcon)
  end

  function F.IsDeveloper(...)
    if E.db.TXUI.general.overrideDevMode then return false end

    if not roleCache then F.BuildRoleCache() end
    if not myRealmName then F.BuildMyRealmName() end

    local devs = { ... }
    if #devs > 0 then
      for i = 1, #devs do
        if devCache[myRealmName] == devs[i] then return true end
      end
    else
      return devCache[myRealmName] ~= nil or false
    end

    return false
  end

  function F.GetChatIcon(name)
    if not roleCache then F.BuildRoleCache() end
    return roleCache[name]
  end

  function F.GetContributorEntryName()
    if not roleCache then F.BuildRoleCache() end
    if not myRealmName then F.BuildMyRealmName() end

    return nameCache[myRealmName] or false
  end

  function F.IsContributor()
    if isKnownPlayer ~= nil then return isKnownPlayer end

    isKnownPlayer = F.GetContributorEntryName() ~= false
    return isKnownPlayer
  end
end

do
  local myCovenant
  function F.GetCachedCovenant(force)
    if not TXUI.IsRetail then return end

    if force or not myCovenant then
      local covenantData = C_Covenants_GetCovenantData(C_Covenants_GetActiveCovenantID())
      if covenantData then myCovenant = covenantData.textureKit end
    end

    return myCovenant
  end

  if TXUI.IsRetail then F.EventManagerRegister("F_API", "COVENANT_CHOSEN", function()
    F.GetCachedCovenant(true)
  end) end
end

function F.GetMedia(mediaPath, mediaName)
  local mediaFile = mediaPath[mediaName] or mediaName
  return mediaFile
end

function F.AddMedia(mediaType, mediaFile, lsmName, lsmType, lsmMask)
  local path = I.MediaPaths[mediaType]
  if path then
    local key = gsub(mediaFile, "%.%w-$", "")
    local file = path .. mediaFile

    local pathKey = I.MediaKeys[mediaType]
    if pathKey then
      I.Media[pathKey][key] = file
    else
      TXUI:LogDebug("Could not find path key for", mediaType, mediaFile, lsmName, lsmType, lsmMask)
    end

    if lsmName then
      local nameKey = (lsmName == true and key) or lsmName
      local mediaKey = lsmType or mediaType
      LSM:Register(mediaKey, nameKey, file, lsmMask)
    end
  else
    TXUI:LogDebug("Could not find media path for", mediaType, mediaFile, lsmName, lsmType, lsmMask)
  end
end

function F.CreateSoftShadow(frame, shadowSize, shadowAlpha)
  local edgeSize = E.twoPixelsPlease and 2 or 1
  shadowSize = shadowSize or 3
  shadowAlpha = shadowAlpha or 0.45

  local softShadow = frame.txSoftShadow or CreateFrame("Frame", nil, frame, "BackdropTemplate")
  softShadow:SetFrameLevel(frame:GetFrameLevel())
  softShadow:SetFrameStrata(frame:GetFrameStrata())
  softShadow:SetOutside(frame, (shadowSize - edgeSize) or edgeSize, (shadowSize - edgeSize) or edgeSize)
  softShadow:SetBackdrop {
    edgeFile = E.Media.Textures.GlowTex,
    edgeSize = E:Scale(shadowSize),
  }
  softShadow:SetBackdropColor(0, 0, 0, 0)
  softShadow:SetBackdropBorderColor(0, 0, 0, shadowAlpha)
  softShadow:Show()

  frame.txSoftShadow = softShadow
end

function F.CreateInnerNoise(frame)
  local edgeSize = E.twoPixelsPlease and 2 or 1

  local innerNoise = frame.txInnerNoise or frame:CreateTexture(nil, "BACKGROUND", nil, 2)
  innerNoise:SetInside(frame, edgeSize, edgeSize)
  innerNoise:SetTexture(I.Media.Themes.NoiseInner, "REPEAT", "REPEAT")
  innerNoise:SetHorizTile(true)
  innerNoise:SetVertTile(true)
  innerNoise:SetBlendMode("ADD")
  innerNoise:SetVertexColor(1, 1, 1, 1)
  innerNoise:Show()

  frame.txInnerNoise = innerNoise
end

function F.CreateInnerShadow(frame, smallVersion)
  local edgeSize = E.twoPixelsPlease and 2 or 1

  local innerShadow = frame.txInnerShadow or frame:CreateTexture(nil, "BACKGROUND", nil, 1)
  innerShadow:SetInside(frame, edgeSize, edgeSize)
  innerShadow:SetTexture(smallVersion and I.Media.Themes.ShadowInnerSmall or I.Media.Themes.ShadowInner)
  innerShadow:SetVertexColor(1, 1, 1, 0.5)
  innerShadow:SetBlendMode("BLEND")
  innerShadow:Show()

  frame.txInnerShadow = innerShadow
end

function F.GetDBFromPath(path, dbRef)
  local paths = { strsplit(".", path) }
  local length = #paths
  local count = 0
  dbRef = dbRef or E.db

  for _, key in pairs(paths) do
    if (dbRef == nil) or (type(dbRef) ~= "table") then break end

    if tonumber(key) then
      key = tonumber(key)
      dbRef = dbRef[key]
      count = count + 1
    else
      local idx

      if key:find("%b[]") then
        idx = {}

        for i in gmatch(key, "(%b[])") do
          i = match(i, "%[(.+)%]")
          tinsert(idx, i)
        end

        length = length + #idx
      end

      key = strsplit("[", key)

      if #key > 0 then
        dbRef = dbRef[key]
        count = count + 1
      end

      if idx and (type(dbRef) == "table") then
        for _, idxKey in ipairs(idx) do
          idxKey = tonumber(idxKey) or idxKey
          dbRef = dbRef[idxKey]
          count = count + 1

          if (dbRef == nil) or (type(dbRef) ~= "table") then break end
        end
      end
    end
  end

  if count == length then return dbRef end
  return nil
end

function F.UpdateDBFromPath(db, path, key)
  F.GetDBFromPath(path)[key] = F.GetDBFromPath(path, db)[key]
end

function F.UpdateDBFromPathRGB(db, path)
  F.UpdateDBFromPath(db, path, "r")
  F.UpdateDBFromPath(db, path, "g")
  F.UpdateDBFromPath(db, path, "b")
  F.UpdateDBFromPath(db, path, "a")
end

function F.ChooseForTheme(normalValue, darkValue)
  if E.db.TXUI.themes.darkMode.enabled and TXUI:HasRequirements(I.Requirements.DarkMode) then return darkValue end
  return normalValue
end

function F.ChooseForGradient(normalValue, gradientValue)
  if E.db.TXUI.themes.gradientMode.enabled and TXUI:HasRequirements(I.Requirements.GradientMode) then return gradientValue end
  return normalValue
end

function F.CheckCacheHearthstoneData()
  local countTotal, countLoaded = 0, 0
  for _, config in pairs(I.HearthstoneData) do
    if config.load == nil or config.load == true then
      countTotal = countTotal + 1
      if config.id then countLoaded = countLoaded + 1 end
    end
  end

  if countTotal == countLoaded then I.HearthstoneDataLoaded = true end
end

function F.CacheHearthstoneData()
  for id, config in pairs(I.HearthstoneData) do
    if config.load == nil or config.load == true then
      if (config.type == "toy") or (config.type == "item") then
        if TXUI.IsVanilla and config.type == "toy" then TXUI:ThrowError("HearthstoneData: Type toy is not valid for: " .. id) end
        local success = F.ProtectedCall(function()
          local itemMixin = CreateFromMixins(ItemMixin)
          itemMixin:SetItemID(id)
          itemMixin:ContinueOnItemLoad(function()
            config.id = id
            config.name = itemMixin:GetItemName()

            if not TXUI.IsVanilla and config.type == "toy" then
              config.known = PlayerHasToy(id)
            else
              config.known = GetItemCount(id, false, true) > 0
            end

            if not config.name or config.name == "" then TXUI:LogDebug("Could not fetch toy data", id) end
            F.CheckCacheHearthstoneData()
          end)

          return true
        end)

        if not success then TXUI:LogDebug("HearthstoneData: Could not load item: " .. id) end
      elseif config.type == "spell" then
        local success = F.ProtectedCall(function()
          local spellMixin = CreateFromMixins(SpellMixin)
          spellMixin:SetSpellID(id)
          if not spellMixin:IsSpellEmpty() and spellMixin:GetSpellID() then
            spellMixin:ContinueOnSpellLoad(function()
              config.id = id
              config.name = spellMixin:GetSpellName()
              config.known = IsSpellKnownOrOverridesKnown(id)
              if not config.name or config.name == "" then TXUI:LogDebug("Could not fetch spell data", id) end

              F.CheckCacheHearthstoneData()
            end)
          end
          return true
        end)

        if not success then TXUI:LogDebug("HearthstoneData: Could not load spell: " .. id) end
      end
    end
  end
end

function F.CheckInterruptConditions(condition)
  if condition.class and condition.class ~= E.myclass then return end
  if condition.level and condition.level > UnitLevel("player") then return end
  if condition.specIds and not tcontains(condition.specIds, GetSpecializationInfo(GetSpecialization())) then return end
  return true
end

function F.CheckInterruptSpellsEvaluation()
  for _, entry in ipairs(I.InterruptSpellMap) do
    entry.active = IsSpellKnownOrOverridesKnown(entry.id) and F.CheckInterruptConditions(entry.conditions)
  end
end

function F.CanInterruptEvaluation()
  local interruptCD = nil

  local spellIDs = {}
  for _, entry in ipairs(I.InterruptSpellMap) do
    if entry.active then tinsert(spellIDs, entry.id) end
  end

  for _, interruptSpellId in ipairs(spellIDs) do
    if E.myclass ~= "WARLOCK" then
      local cdStart, cdDur
      if TXUI.IsRetail then
        local cd = GetSpellCooldown(interruptSpellId)
        cdStart, cdDur = cd.startTime, cd.duration
      else
        cdStart, cdDur = GetSpellCooldown(interruptSpellId)
      end

      local tmpInterruptCD = (cdStart > 0 and cdDur - (GetTime() - cdStart)) or 0
      if not interruptCD or (tmpInterruptCD < interruptCD) then interruptCD = tmpInterruptCD end
    elseif FindSpellOverrideByID(119898) then -- Check if WL has the command ability
      local cdStart, cdDur
      if TXUI.IsRetail then
        local cd = GetSpellCooldown(interruptSpellId)
        cdStart, cdDur = cd.startTime, cd.duration
      else
        cdStart, cdDur = GetSpellCooldown(interruptSpellId)
      end
      local tmpInterruptCD = (cdStart > 0 and cdDur - (GetTime() - cdStart)) or 0
      if (tmpInterruptCD > 0) and (not interruptCD or (tmpInterruptCD < interruptCD)) then interruptCD = tmpInterruptCD end
    end
  end

  if interruptCD and interruptCD > 0 then return interruptCD end
  return 0
end

do
  local cachedCD = 0
  F.CanInterrupt = function()
    local cdDur = F.CanInterruptThrottled()
    if cdDur ~= nil then cachedCD = cdDur end
    return cachedCD
  end
end

function F.ProcessMovers(dbRef)
  -- Disable screen restrictions
  E:SetMoversClampedToScreen(false)

  -- Enable all movers
  for name in pairs(E.DisabledMovers) do
    local disable = E.DisabledMovers[name].shouldDisable
    local shouldDisable = (disable and disable()) or false

    if not shouldDisable and not E.CreatedMovers[name] then
      local holder = E.DisabledMovers[name]
      if not holder then TXUI:LogDebug("holder doesnt exist", name or "nil") end

      E.CreatedMovers[name] = {}
      for x, y in pairs(holder) do
        E.CreatedMovers[name][x] = y
      end

      E.DisabledMovers[name] = nil
    else
      TXUI:LogDebug("could not enable mover", name or "nil")
    end
  end

  local relativeMovers = {}
  local globalMovers = {}

  for name, points in pairs(dbRef.movers) do
    local _, relativeTo = strsplit(",", points)
    if relativeTo then
      relativeTo = relativeTo:gsub("Mover", "")

      if relativeTo ~= "ElvUIParent" and relativeTo ~= "UIParent" then
        if not relativeMovers[relativeTo] then relativeMovers[relativeTo] = {} end
        tinsert(relativeMovers[relativeTo], { name, points })
      else
        tinsert(globalMovers, { name, points })
      end
    end
  end

  local function processMover(info)
    local name, points = unpack(info)
    local cleanName = name:gsub("Mover", "")

    local holder = E.CreatedMovers[name]
    local mover = holder and holder.mover

    if mover and mover:GetCenter() then
      local point1, relativeTo1, relativePoint1, xOffset1, yOffset1 = strsplit(",", points)

      -- Set To DB Points
      mover:ClearAllPoints()
      mover:SetPoint(point1, relativeTo1, relativePoint1, xOffset1, yOffset1)

      -- Set ElvUI Converted Point
      local xOffsetConverted, yOffsetConverted, pointConverted = E:CalculateMoverPoints(mover)
      mover:ClearAllPoints()
      mover:SetPoint(pointConverted, _G.UIParent, pointConverted, xOffsetConverted, yOffsetConverted)

      -- Read resulting point, save it to our db
      local point3, _, relativePoint3, xOffset3, yOffset3 = mover:GetPoint()
      dbRef.movers[name] = format("%s,ElvUIParent,%s,%d,%d", point3, relativePoint3, xOffset3 and E:Round(xOffset3) or 0, yOffset3 and E:Round(yOffset3) or 0)

      -- Process other movers that are relative to us
      if relativeMovers[cleanName] and #relativeMovers[cleanName] > 0 then
        for i, relativeInfo in ipairs(relativeMovers[cleanName]) do
          if relativeInfo then
            relativeMovers[cleanName][i] = nil
            processMover(relativeInfo)
          end
        end
      end
    else
      TXUI:LogDebug(F.String.Error("Could not find holder"), name)
    end
  end

  for _, info in ipairs(globalMovers) do
    processMover(info)
  end

  for parent, infos in pairs(relativeMovers) do
    for _, info in ipairs(infos) do
      if info then TXUI:LogDebug(F.String.Error("Parent was never processed resulted in dangling child"), parent, info[1]) end
    end
  end
end

function F.IsSkyriding()
  if TXUI.IsRetail then
    return UnitPowerBarID("player") == I.Constants.VIGOR_BAR_ID
  else
    return false
  end
end

-- Copied from E:IsUltrawide() with less restrictions
function F.IsUltrawide()
  --HQ Resolution
  if E.physicalWidth >= 3440 and (E.physicalHeight == 1440 or E.physicalHeight == 1600) then return 2560 end --DQHD, DQHD+, WQHD & WQHD+

  --Low resolution
  if E.physicalWidth >= 2560 and (E.physicalHeight == 1080 or E.physicalHeight == 1200) then return 1920 end --WFHD, DFHD & WUXGA
end

function F.CalculateUltrawideOffset()
  if F.IsUltrawide() then
    return ((E.physicalWidth - F.IsUltrawide()) / 2) * F.PixelPerfect()
  else
    return 0
  end
end

F.CheckInterruptSpells = F.CreateThrottleWrapper("CheckInterruptSpells", 2, F.CheckInterruptSpellsEvaluation)
F.CanInterruptThrottled = F.CreateThrottleWrapper("CanInterrupt", 0.2, F.CanInterruptEvaluation)
