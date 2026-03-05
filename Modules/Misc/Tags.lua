---@diagnostic disable: redundant-parameter
local TXUI, F, E, I, V, L, P, G = unpack((select(2, ...)))
local M = TXUI:GetModule("Misc")
local UF = E:GetModule("UnitFrames")
local ElvUF = E.oUF

local AbbreviateNumbers = AbbreviateNumbers
local floor = math.floor
local format = string.format
local strfind = strfind
local GetCreatureDifficultyColor = GetCreatureDifficultyColor
local ipairs = ipairs
local match = string.match
local ScaleTo100 = CurveConstants and CurveConstants.ScaleTo100
local select = select
local UnitClassification = UnitClassification
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitHealthPercent = UnitHealthPercent
local UnitIsPlayer = UnitIsPlayer
local UnitLevel = UnitLevel
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax
local UnitPowerPercent = UnitPowerPercent
local UnitPowerType = UnitPowerType
local UnitReaction = UnitReaction

local utf8len = string.utf8len
local utf8sub = string.utf8sub

function M:_TagsUpdate()
  if not F.IsTXUIProfile() then return end

  for _, unit in ipairs { "party", "arena", "boss", "pet", "player", "target", "targettarget", "focus", "raid1", "raid2", "raid3" } do
    if unit == "party" or unit:find("raid") then
      for i = 1, UF[unit]:GetNumChildren() do
        local child = select(i, UF[unit]:GetChildren())
        for x = 1, child:GetNumChildren() do
          local subchild = select(x, child:GetChildren())
          if subchild then subchild:UpdateTags() end
        end
      end
    elseif unit == "boss" or unit == "arena" then
      for i = 1, 10 do
        local unitframe = UF[unit .. i]
        if unitframe then unitframe:UpdateTags() end
      end
    else
      local unitframe = UF[unit]
      if unitframe then unitframe:UpdateTags() end
    end
  end
end

function M:TagsUpdate()
  if UF.Initialized then
    F.Event.RunNextFrame(function()
      F.Event.ContinueAfterElvUIUpdate(function()
        self:_TagsUpdate()
      end)
    end)
  elseif not self:IsHooked(UF, "Initialize") then
    self:SecureHook(UF, "Initialize", F.Event.GenerateClosure(self.TagsUpdate, self))
  end
end

-- Event strings
local NAME_EVENTS = "UNIT_NAME_UPDATE PLAYER_TARGET_CHANGED UNIT_FACTION INSTANCE_ENCOUNTER_ENGAGE_UNIT"
local HEALTH_EVENTS = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED"
local POWER_EVENTS = "UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER"
local LEVEL_EVENTS = "UNIT_LEVEL PLAYER_LEVEL_UP"

-- Helper: Get unit status (dead/ghost/offline)
local function GetUnitStatus(unit)
  if not UnitIsFeignDeath(unit) and UnitIsDead(unit) then return L["Dead"] end
  if UnitIsGhost(unit) then return L["Ghost"] end
  if not UnitIsConnected(unit) then return L["Offline"] end
end

-- Helper: Convert level to string with "??" fallback
local function GetLevelString(level)
  if level == -1 or not level or level == "" then return "??" end
  return tostring(level)
end

function M:ReplaceAndColorRest(name, strMatch, colorFunc)
  if strMatch and strMatch ~= "" then
    -- Convert both strings to lowercase for case-insensitive matching
    local lowerName = name:lower()
    local lowerMatch = strMatch:lower()

    -- Find the start position of the match
    local startPos, endPos = lowerName:find(lowerMatch, 1, true)

    if startPos then
      -- Keep the matched string white
      local whiteMatch = "|cffffffff" .. name:sub(startPos, endPos) .. "|r"
      local nameBefore = name:sub(1, startPos - 1)
      local nameAfter = name:sub(endPos + 1)

      -- Color the rest of the string
      local coloredNameBefore = colorFunc(nameBefore)
      local coloredNameAfter = colorFunc(nameAfter)

      return coloredNameBefore .. whiteMatch .. coloredNameAfter
    end
  end

  -- If no match is found, split the name and color the second half
  local spaceCount = select(2, name:gsub(" ", ""))
  local splitPoint = floor(utf8len(name) / 2) + spaceCount
  local nameHighlight = utf8sub(name, 1, splitPoint)
  local nameRest = utf8sub(name, splitPoint + 1)
  return nameHighlight .. colorFunc(nameRest)
end

function M:SplitAndColorName(name, unit, strMatch, class)
  -- Define the color function for class or reaction coloring
  local function colorFunc(text)
    if UnitIsPlayer(unit) then
      local cs = ElvUF.colors.class[class]
      return cs and ("|cff" .. F.String.FastRGB(cs.r, cs.g, cs.b) .. text) or ("|cffcccccc" .. text)
    else
      local cr = ElvUF.colors.reaction[UnitReaction(unit, "player")]
      return cr and ("|cff" .. F.String.FastRGB(cr.r, cr.g, cr.b) .. text) or ("|cffcccccc" .. text)
    end
  end

  -- Replace and color the non-matched part or split and color if no match
  return self:ReplaceAndColorRest(name, strMatch, colorFunc)
end

function M:Tags()
  local iconsDb = E.db.TXUI.wunderbar.subModules["SpecSwitch"].icons
  local iconTheme = E.db.TXUI.elvUIIcons.classIcons.theme or "ToxiClasses"
  local iconPath = self:GetClassIconPath(iconTheme)
  local usingSpecIcons = TXUI.IsRetail and match(iconTheme, "ToxiSpec")
  local classIconPath = usingSpecIcons and self:GetClassIconPath("ToxiClasses") or iconPath

  local dm = TXUI:GetModule("ThemesDarkTransparency")

  local function FormatColorTag(str, unit)
    -- i don't fucking know, i don't see this string anywhere but otherwise get Lua errors
    if not str then return "Missing string, very bad!" end

    if UnitIsPlayer(unit) then
      local _, unitClass = UnitClass(unit)
      local cs = ElvUF.colors.class[unitClass]
      return cs and ("|cff" .. F.String.FastRGB(cs.r, cs.g, cs.b) .. str) or ("|cffcccccc" .. str)
    else
      local cr = ElvUF.colors.reaction[UnitReaction(unit, "player")]
      return cr and ("|cff" .. F.String.FastRGB(cr.r, cr.g, cr.b) .. str) or ("|cffcccccc" .. str)
    end
  end

  -- Name tags
  E:AddTag("tx:name", NAME_EVENTS, function(unit)
    local name = UnitName(unit)
    if not name then return "missing name wtf" end

    if not dm.isEnabled then return name end

    return FormatColorTag(name, unit)
  end)

  -- Name tags with length variants
  -- CREDITS TO ELVUI TEAM
  for textFormat, length in pairs { veryshort = 5, short = 10, medium = 15, long = 20 } do
    E:AddTag(format("tx:name:%s", textFormat), NAME_EVENTS, function(unit)
      local name = UnitName(unit)
      if E:NotSecretValue(name) and name then name = E:ShortenString(name, length) end

      if not name then return end

      if not dm.isEnabled then return name end

      return FormatColorTag(name, unit)
    end)

    -- tx:name:abbrev:veryshort, tx:name:abbrev:short, tx:name:abbrev:medium, tx:name:abbrev:long
    E:AddTag(format("tx:name:abbrev:%s", textFormat), NAME_EVENTS, function(unit)
      local name = UnitName(unit)
      if E:NotSecretValue(name) and name and strfind(name, "%s") then name = Abbrev(name) end

      if E:NotSecretValue(name) and name then name = E:ShortenString(name, length) end

      if not name then return end

      if not dm.isEnabled then return name end

      return FormatColorTag(name, unit)
    end)

    E:AddTag(format("tx:name:%s:split", textFormat), NAME_EVENTS, function(unit, _, strMatch)
      local name = UnitName(unit)
      if not name then return end

      local _, unitClass = UnitClass(unit)

      if E:NotSecretValue(name) then
        name = E:ShortenString(name, length)
        return self:SplitAndColorName(name, unit, strMatch, unitClass)
      end

      if not dm.isEnabled then return name end
      return FormatColorTag(name, unit)
    end)

    E:AddTag(format("tx:name:abbrev:%s:split", textFormat), NAME_EVENTS, function(unit, _, strMatch)
      local name = UnitName(unit)
      if not name then return end

      local _, unitClass = UnitClass(unit)

      if E:NotSecretValue(name) then
        if strfind(name, "%s") then name = Abbrev(name) end
        name = E:ShortenString(name, length)
        return self:SplitAndColorName(name, unit, strMatch, unitClass)
      end

      -- Secret value: just color without split
      if not dm.isEnabled then return name end
      return FormatColorTag(name, unit)
    end)
  end

  -- ToxiUI: Health Tags
  local function GetHealthPercentage(unit)
    if TXUI.IsRetail then return format("%d", UnitHealthPercent(unit, true, ScaleTo100)) end

    local max = UnitHealthMax(unit)
    if max == 0 then
      return 0
    else
      return floor(UnitHealth(unit) / max * 100 + 0.5)
    end
  end

  local function ColorHealthTag(unit, percentSign)
    local status = GetUnitStatus(unit)
    if status then return status end

    local percentHealth = GetHealthPercentage(unit)
    local percentHealthStr = tostring(percentHealth)

    if percentSign then percentHealthStr = percentHealthStr .. "%" end

    -- Return different coloring for Dark Mode
    if dm.isEnabled then
      return FormatColorTag(percentHealthStr, unit)
    -- If not gradient mode, or the option is disabled, return early an uncolored string
    else
      return percentHealthStr
    end
  end

  E:AddTag("tx:health:percent:nosign", "UNIT_HEALTH PLAYER_TARGET_CHANGED UNIT_FACTION UNIT_MAXHEALTH", function(unit)
    return ColorHealthTag(unit)
  end)

  E:AddTag("tx:health:current:shortvalue", HEALTH_EVENTS, function(unit)
    local status = GetUnitStatus(unit)
    if status then return status end

    local health = UnitHealth(unit)
    local healthStr = AbbreviateNumbers(health, E.Abbreviate.short)

    if not dm.isEnabled then return healthStr end

    return FormatColorTag(healthStr, unit)
  end)

  E:AddTag("tx:health:current:shortvalue:absorb", HEALTH_EVENTS .. " UNIT_ABSORB_AMOUNT_CHANGED", function(unit)
    local status = GetUnitStatus(unit)
    if status then return status end

    local health = UnitHealth(unit)
    local healthStr = AbbreviateNumbers(health, E.Abbreviate.short)

    local absorb = UnitGetTotalAbsorbs(unit)
    local absorbStr = AbbreviateNumbers(absorb, E.Abbreviate.short)

    local ret = format("%s + %s", healthStr, absorbStr)

    if not dm.isEnabled then return ret end

    return FormatColorTag(ret, unit)
  end, not TXUI.IsRetail)

  -- Power Percent No Sign Tag
  E:AddTag("tx:power:percent:nosign", POWER_EVENTS, function(unit)
    if TXUI.IsRetail then
      local power = format("%d", UnitPowerPercent(unit, nil, true, ScaleTo100))

      if not dm.isEnabled then
        return power
      else
        return FormatColorTag(power, unit)
      end
    else
      local max = UnitPowerMax(unit)
      local power = floor(UnitPower(unit) / max * 100 + 0.5)

      if not dm.isEnabled then
        if max ~= 0 then return power end
      end

      local powerStr = tostring(power)

      if max ~= 0 then return FormatColorTag(powerStr, unit) end
    end
  end)

  -- Specs that should not display mana in Midnight
  local hideManaSpecs = {
    [I.Specs.Mage.Fire] = true,
    [I.Specs.Mage.Frost] = true,
    [I.Specs.Shaman.Enhancement] = true,
    [I.Specs.Druid.Feral] = true,
    [I.Specs.Druid.Guardian] = true,
    [I.Specs.Druid.Balance] = true,
  }

  local displayPercentageSpecs = {
    [I.Specs.Mage.Arcane] = true,
    -- all healers except Paladin, since they use holy power
    [I.Specs.Druid.Restoration] = true,
    [I.Specs.Evoker.Preservation] = true,
    [I.Specs.Monk.Mistweaver] = true,
    [I.Specs.Priest.Discipline] = true,
    [I.Specs.Priest.Holy] = true,
    [I.Specs.Shaman.Restoration] = true,
  }

  local function powerTagFunc(unit)
    local power = UnitPower(unit)
    local powerType = UnitPowerType(unit)

    if TXUI.IsRetail then
      if E.myclass == "WARLOCK" and unit == "player" then power = UnitPower(unit, Enum.PowerType.SoulShards) end
      if E.myclass == "EVOKER" and unit == "player" then power = UnitPower(unit, Enum.PowerType.Essence) end
      if E.myclass == "PALADIN" and unit == "player" then power = UnitPower(unit, Enum.PowerType.HolyPower) end
      if unit == "player" and hideManaSpecs[E.myspecID] and powerType == Enum.PowerType.Mana then return end
      if unit == "player" and displayPercentageSpecs[E.myspecID] then power = format("%d", UnitPowerPercent(unit, nil, true, ScaleTo100)) end
    end

    if dm.isEnabled then
      return FormatColorTag(power, unit)
    else
      return power
    end
  end

  E:AddTag("tx:power", POWER_EVENTS, powerTagFunc)

  E:AddTag("tx:power:classbar", POWER_EVENTS, function(unit)
    local playerDB = E.db.unitframe and E.db.unitframe.units and E.db.unitframe.units.player
    if not playerDB or playerDB.power.enable then return end
    return powerTagFunc(unit)
  end)

  -- Class Icon Tags (normal and reversed/mirrored, with optional :player filter)
  for _, reverse in ipairs { false, true } do
    for _, playerOnly in ipairs { false, true } do
      local tagName = "tx:classicon"
      if reverse then tagName = tagName .. ":reverse" end
      if playerOnly then tagName = tagName .. ":player" end

      E:AddTag(tagName, "PLAYER_TARGET_CHANGED PLAYER_SPECIALIZATION_CHANGED", function(unit)
        if playerOnly and not UnitIsPlayer(unit) then return end

        local _, class = UnitClass(unit)
        if not class then return end

        if UnitIsPlayer(unit) and usingSpecIcons then
          local specId = nil

          local info = E:GetUnitSpecInfo(unit)
          if info and info.id then specId = info.id end

          if iconsDb and specId then
            local specIcon = M.SpecIcons[specId]

            if specIcon then
              local coords = reverse and M:ReverseIconCoords(specIcon) or specIcon
              return format(iconPath, coords)
            end
          end
        end

        local icon = M.ClassIcons[class]
        if icon then
          local coords = reverse and M:ReverseIconCoords(icon) or icon
          return format(classIconPath, coords)
        end
      end)
    end
  end

  -- Level Tag
  E:AddTag("tx:level", LEVEL_EVENTS, function(unit)
    local level = UnitLevel(unit)

    -- Do not show level for max level units
    if level >= I.MaxLevelTable[TXUI.MetaFlavor] then return end

    local levelDisplayStr = "Lv " .. GetLevelString(level)

    if not dm.isEnabled then return levelDisplayStr end

    return FormatColorTag(levelDisplayStr, unit)
  end)

  -- Level Difficulty Tag
  E:AddTag("tx:level:difficulty", LEVEL_EVENTS, function(unit)
    local level = UnitLevel(unit)
    local levelStr = GetLevelString(level)

    local hex
    if levelStr == "??" then
      hex = "6e6e6e"
    else
      local color = GetCreatureDifficultyColor(level)
      hex = E:RGBToHex(color.r, color.g, color.b, "")
    end

    local coloredLvl = F.String.Color(levelStr, hex)

    if not dm.isEnabled then return "Lv " .. coloredLvl end

    -- After reload without a target FormatColorTag returns nil so we have to fallback to "Lv"
    return (FormatColorTag("Lv ", unit) or "Lv ") .. coloredLvl
  end)

  -- Credits to ElvUI [classification:icon]
  do
    local icon = F.String.ConvertGlyph(59706) -- star (xp) icon
    local gold, silver = F.String.Color(icon, I.Enum.Colors.GOLD), F.String.Color(icon, I.Enum.Colors.SILVER)
    local typeIcon = { elite = gold, worldboss = gold, rareelite = silver, rare = silver }
    E:AddTag("tx:classification", "UNIT_NAME_UPDATE", function(unit)
      if UnitIsPlayer(unit) then return end
      return typeIcon[UnitClassification(unit)]
    end)
  end

  local TagNames = {
    GENERAL = TXUI.Title,
    NAMES = TXUI.Title .. " Names",
    HEALTH = TXUI.Title .. " Health",
    POWER = TXUI.Title .. " Power",
  }

  -- Tag info
  -- Tag info: General

  -- Class Icon Tags
  do
    local settingsPath = TXUI.Title .. " settings -> " .. F.String.Menu.Skins() .. " -> " .. F.String.Class("Class") .. " icons"

    for _, reverse in ipairs { false, true } do
      for _, playerOnly in ipairs { false, true } do
        local tagName = "tx:classicon"
        if reverse then tagName = tagName .. ":reverse" end
        if playerOnly then tagName = tagName .. ":player" end

        local desc = "Displays " .. TXUI.Title .. " class icon"
        if reverse then desc = desc .. " reversed/mirrored" end
        if playerOnly then desc = desc .. " only for player units" end
        desc = desc .. ". The class icon style can be customized in " .. settingsPath

        E:AddTagInfo(tagName, TagNames.GENERAL, desc)
      end
    end

    -- Level
    E:AddTagInfo("tx:level", TagNames.GENERAL, "Displays unit's level with " .. TXUI.Title .. " colors (e.g. Lv 42). Hides when the unit is max level.")

    -- Level Difficulty
    do
      local color = GetCreatureDifficultyColor(42)
      local hex = E:RGBToHex(color.r, color.g, color.b, "")
      E:AddTagInfo(
        "tx:level:difficulty",
        TagNames.GENERAL,
        "Displays unit's level with " .. TXUI.Title .. " and difficulty colors (e.g. Lv " .. F.String.Color("42", hex) .. "). Does not hide when the unit is max level."
      )
    end
    -- Classification
    E:AddTagInfo(
      "tx:classification",
      TagNames.GENERAL,
      "Displays a silver or gold " .. TXUI.Title .. " star for rare & elite monsters. This tag can be used only with the " .. F.String.ToxiUI("'- ToxiUI'") .. " font!"
    )
  end

  -- Tag info: Names
  do
    E:AddTagInfo("tx:name", TagNames.NAMES, "Displays unit's name with " .. TXUI.Title .. " colors.")

    local secret = F.String.Error("[SECRET]") .. " "
    for textFormat, length in pairs { veryshort = 5, short = 10, medium = 15, long = 20 } do
      E:AddTagInfo(
        format("tx:name:%s", textFormat),
        TagNames.NAMES,
        secret .. F.String.ToxiUI("[BASIC]") .. " Displays the name of the unit with " .. TXUI.Title .. " colors. (limited to " .. length .. " letters)"
      )
      E:AddTagInfo(
        format("tx:name:abbrev:%s", textFormat),
        TagNames.NAMES,
        secret .. F.String.ToxiUI("[BASIC / ABBREV]") .. " Displays the name of the unit with abbreviation and " .. TXUI.Title .. " colors. (limited to " .. length .. " letters)"
      )
      E:AddTagInfo(
        format("tx:name:%s:split", textFormat),
        TagNames.NAMES,
        secret
          .. F.String.ToxiUI("[SPLIT]")
          .. " Displays the name of the unit split in |cffffffffwhite|r and "
          .. F.String.Class("class")
          .. " color. Can use |cfff4f4f4{stringMatch}|r to split. (limited to "
          .. length
          .. " letters)"
      )
      E:AddTagInfo(
        format("tx:name:abbrev:%s:split", textFormat),
        TagNames.NAMES,
        secret
          .. F.String.ToxiUI("[SPLIT / ABBREV]")
          .. " Displays the name of the unit with abbreviation split in |cffffffffwhite|r and "
          .. F.String.Class("class")
          .. " color. Can use |cfff4f4f4{stringMatch}|r to split. (limited to "
          .. length
          .. " letters)"
      )
    end
  end

  -- Tag info: Health
  do
    E:AddTagInfo("tx:health:percent:nosign", TagNames.HEALTH, "Displays percentage HP of unit without decimals or the % sign. Also adds " .. TXUI.Title .. " colors.")
    E:AddTagInfo("tx:health:current:shortvalue", TagNames.HEALTH, "Shortvalue of the unit's current health (e.g. 81k instead of 81200). Also adds " .. TXUI.Title .. " colors.")
    if TXUI.IsRetail then
      E:AddTagInfo(
        "tx:health:current:shortvalue:absorb",
        TagNames.HEALTH,
        "Shortvalue of the unit's current health with absorb value (e.g. 81k + 20k). Also adds " .. TXUI.Title .. " colors."
      )
    end
  end

  -- Tag info: Power
  do
    E:AddTagInfo(
      "tx:power:percent:nosign",
      TagNames.POWER,
      "Displays percentage Power of unit without decimals or the % sign. Also adds " .. TXUI.Title .. " colors and does not display when Power is at 0."
    )
    E:AddTagInfo(
      "tx:power",
      TagNames.POWER,
      "Displays current Power of unit. Also adds " .. TXUI.Title .. " colors." .. (TXUI.IsRetail and " Smart display per-specialization." or "")
    )
    E:AddTagInfo("tx:power:classbar", TagNames.POWER, "Same as [tx:power] but only displays when the Player Power Bar is disabled.")
  end

  -- Requires ElvUI 13.67 or later
  if UF and UF.overrideTags then
    local overrideTags = {
      ["tx:level"] = true,
      ["tx:level:difficulty"] = true,
      ["tx:classicon"] = true,
      ["tx:classicon:reverse"] = true,
      ["tx:health:percent:nosign"] = true,
      ["tx:health:current:shortvalue"] = true,
      ["tx:health:current:shortvalue:absorb"] = true,

      ["tx:name"] = true,
      ["tx:name:veryshort"] = true,
      ["tx:name:short"] = true,
      ["tx:name:medium"] = true,
      ["tx:name:long"] = true,
      ["tx:name:abbrev:veryshort"] = true,
      ["tx:name:abbrev:short"] = true,
      ["tx:name:abbrev:medium"] = true,
      ["tx:name:abbrev:long"] = true,
      ["tx:name:veryshort:split"] = true,
      ["tx:name:short:split"] = true,
      ["tx:name:medium:split"] = true,
      ["tx:name:long:split"] = true,
      ["tx:name:abbrev:veryshort:split"] = true,
      ["tx:name:abbrev:short:split"] = true,
      ["tx:name:abbrev:medium:split"] = true,
      ["tx:name:abbrev:long:split"] = true,

      ["tx:power:percent:nosign"] = true,
    }

    F.Table.Crush(UF.overrideTags, overrideTags)
  end

  -- Settings Callback
  F.Event.RegisterCallback("Tags.DatabaseUpdate", self.TagsUpdate, self)
  F.Event.RegisterCallback("TXUI.DatabaseUpdate", self.TagsUpdate, self)
  F.Event.RegisterOnceCallback("TXUI.InitializedSafe", F.Event.GenerateClosure(self.TagsUpdate, self))
end

M:AddCallback("Tags")
