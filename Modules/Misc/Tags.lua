local TXUI, F, E, I, V, L, P, G = unpack((select(2, ...)))
local M = TXUI:GetModule("Misc")
local UF = E:GetModule("UnitFrames")
local ElvUF = E.oUF

local ipairs = ipairs
local select = select
local floor = math.floor
local match = string.match
local uppercase = string.upper
local UnitIsPlayer = UnitIsPlayer
local UnitReaction = UnitReaction
local Abbrev = E.TagFunctions.Abbrev
local GetCreatureDifficultyColor = GetCreatureDifficultyColor

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

-- Table for referencing which gradients should be reversed
local reverseUnitsTable = {
  ["target"] = true,
  ["targettarget"] = true,
  ["focus"] = true,
  ["arena1"] = true,
  ["arena2"] = true,
  ["arena3"] = true,
  ["arena4"] = true,
  ["arena5"] = true,
  ["boss1"] = true,
  ["boss2"] = true,
  ["boss3"] = true,
  ["boss4"] = true,
  ["boss5"] = true,
  ["boss6"] = true,
  ["boss7"] = true,
  ["boss8"] = true,
}

local function getCoordinates(col, row)
  local width = 64
  local height = 64

  local x1 = (col - 1) * width
  local x2 = col * width
  local y1 = (row - 1) * height
  local y2 = row * height

  -- Return the formatted string
  return string.format("%d:%d:%d:%d", x1, x2, y1, y2)
end

function M:Tags()
  local iconsDb = E.db.TXUI.wunderbar.subModules["SpecSwitch"].icons
  local iconTheme = E.db.TXUI.elvUIIcons.classIcons.theme or "ToxiClasses"
  local classIcon = [[|TInterface\AddOns\ElvUI_ToxiUI\Media\Textures\Icons\]] .. iconTheme .. [[:32:32:0:0:512:512:%s|t]]
  -- x1:x2:y1:y2
  local classIcons = {
    WARRIOR = "0:64:0:64",
    MAGE = "64:128:0:64",
    ROGUE = "128:192:0:64",
    DRUID = "192:256:0:64",
    HUNTER = "0:64:64:128",
    SHAMAN = "64:128:64:128",
    PRIEST = "128:192:64:128",
    WARLOCK = "192:256:64:128",
    PALADIN = "0:64:128:192",
    DEATHKNIGHT = "64:128:128:192",
    MONK = "128:192:128:192",
    DEMONHUNTER = "192:256:128:192",
    EVOKER = "256:320:0:64",
  }

  local specIcons = {
    -- Retail
    [0] = getCoordinates(8, 8), -- Unknown
    [62] = getCoordinates(3, 2), -- Mage Arcane
    [63] = getCoordinates(4, 2), -- Mage Fire
    [64] = getCoordinates(5, 2), -- Mage Frost
    [65] = getCoordinates(1, 3), -- Paladin Holy
    [66] = getCoordinates(2, 3), -- Paladin Protection
    [70] = getCoordinates(3, 3), -- Paladin Retribution
    [71] = getCoordinates(8, 4), -- Warrior Arms
    [72] = getCoordinates(1, 5), -- Warrior Fury
    [73] = getCoordinates(2, 5), -- Warrior Protection
    [102] = getCoordinates(4, 1), -- Druid Balance
    [103] = getCoordinates(5, 1), -- Druid Feral
    [104] = getCoordinates(6, 1), -- Druid Guardian
    [105] = getCoordinates(7, 1), -- Druid Restoration
    [250] = getCoordinates(1, 1), -- Death Knight Blood
    [251] = getCoordinates(2, 1), -- Death Knight Frost
    [252] = getCoordinates(3, 1), -- Death Knight Unholy
    [253] = getCoordinates(8, 1), -- Hunter Beast Master
    [254] = getCoordinates(1, 2), -- Hunter Marksmanship
    [255] = getCoordinates(2, 2), -- Hunter Survival
    [256] = getCoordinates(4, 3), -- Priest Discipline
    [257] = getCoordinates(5, 3), -- Priest Holy
    [258] = getCoordinates(6, 3), -- Priest Shadow
    [259] = getCoordinates(7, 3), -- Rogue Assassination
    [260] = getCoordinates(8, 3), -- Rogue Outlaw
    [261] = getCoordinates(1, 4), -- Rogue Subtlety
    [262] = getCoordinates(2, 4), -- Shaman Elemental
    [263] = getCoordinates(3, 4), -- Shaman Enhancement
    [264] = getCoordinates(4, 4), -- Shaman Restoration
    [265] = getCoordinates(5, 4), -- Warlock Affliction
    [266] = getCoordinates(6, 4), -- Warlock Demonology
    [267] = getCoordinates(7, 4), -- Warlock Destruction
    [268] = getCoordinates(6, 2), -- Monk Brewmaster
    [269] = getCoordinates(8, 2), -- Monk Windwalker
    [270] = getCoordinates(7, 2), -- Monk Mistweaver
    [577] = getCoordinates(3, 5), -- Demon Hunter Havoc
    [581] = getCoordinates(4, 5), -- Demon Hunter Vengeance
    [1467] = getCoordinates(5, 5), -- Evoker Devastation
    [1468] = getCoordinates(6, 5), -- Evoker Preservation
    [1473] = getCoordinates(7, 5), -- Evoker Augmentation
  }

  local function SetGradientColorMapString(name, unitClass, reverseGradient)
    if not name or name == "" then return end
    if not unitClass or unitClass == "" then return name end
    local classColorMap = E.db.TXUI.themes.gradientMode.classColorMap
    local reactionColorMap = E.db.TXUI.themes.gradientMode.reactionColorMap

    local colorMap = {}
    F.Table.Crush(colorMap, classColorMap, reactionColorMap)

    local left = colorMap[1][unitClass] -- Left (player UF)
    local right = colorMap[2][unitClass] -- Right (player UF)

    local r1, g1, b1
    local r2, g2, b2

    if E.db.TXUI.themes.gradientMode.saturationBoost then
      -- mod values taken from F.Color.GenerateCache()
      -- maybe can use instead F.Color.GetMap??
      local modS1, modL1 = 1.6, 0.6
      local modS2, modL2 = 0.9, 1

      local h1, s1, l1 = F.ConvertToHSL(left.r, left.g, left.b)
      local h2, s2, l2 = F.ConvertToHSL(right.r, right.g, right.b)

      r1, g1, b1 = F.ConvertToRGB(F.ClampToHSL(h1, s1 * modS1, l1 * modL1))
      r2, g2, b2 = F.ConvertToRGB(F.ClampToHSL(h2, s2 * modS2, l2 * modL2))
    else
      r1, g1, b1 = left.r, left.g, left.b
      r2, g2, b2 = right.r, right.g, right.b
    end

    -- Reverse color for target frame etc
    if reverseGradient then
      return E:TextGradient(name, r2, g2, b2, r1, g1, b1)
    else
      return E:TextGradient(name, r1, g1, b1, r2, g2, b2)
    end
  end

  local dm = TXUI:GetModule("ThemesDarkTransparency")
  local gm = TXUI:GetModule("ThemesGradients")

  local function FormatColorTag(str, unit, reverse)
    -- i don't fucking know, i don't see this string anywhere but otherwise get Lua errors
    if not str then return "Missing string, very bad!" end

    if UnitIsPlayer(unit) then
      local _, unitClass = UnitClass(unit)
      if E.db.TXUI.themes.darkMode.gradientName then
        return SetGradientColorMapString(str, unitClass, reverse)
      else
        local cs = ElvUF.colors.class[unitClass]
        ---@diagnostic disable-next-line: ambiguity-1
        return (cs and "|cff" .. F.String.FastRGB(cs[1], cs[2], cs[3]) .. str) or "|cffcccccc" .. str
      end
    else
      if E.db.TXUI.themes.darkMode.gradientName then
        local reaction = UnitReaction(unit, "player")
        if reaction then
          if reaction >= 5 then
            return SetGradientColorMapString(str, "GOOD", reverse)
          elseif reaction == 4 then
            return SetGradientColorMapString(str, "NEUTRAL", reverse)
          elseif reaction <= 3 and reaction > 0 then
            return SetGradientColorMapString(str, "BAD", reverse)
          end
        end
      else
        local cr = ElvUF.colors.reaction[UnitReaction(unit, "player")]
        ---@diagnostic disable-next-line: ambiguity-1
        return (cr and "|cff" .. F.String.FastRGB(cr[1], cr[2], cr[3]) .. str) or "|cffcccccc" .. str
      end
    end
  end

  -- Name tags
  local nameLength = { veryshort = 5, short = 10, medium = 15, long = 20 }
  for textFormat, length in pairs(nameLength) do
    E:AddTag(format("tx:name:%s", textFormat), "UNIT_NAME_UPDATE PLAYER_TARGET_CHANGED UNIT_FACTION INSTANCE_ENCOUNTER_ENGAGE_UNIT UNIT_FACTION", function(unit)
      local name = UnitName(unit)
      if not name then return "missing name wtf" end

      name = E:ShortenString(name, length)

      if not dm.isEnabled then return name end

      local reverseGradient = reverseUnitsTable[unit]
      return FormatColorTag(name, unit, reverseGradient)
    end)

    E:AddTag(format("tx:name:%s:uppercase", textFormat), "UNIT_NAME_UPDATE PLAYER_TARGET_CHANGED UNIT_FACTION INSTANCE_ENCOUNTER_ENGAGE_UNIT UNIT_FACTION", function(unit)
      local name = UnitName(unit)
      if not name then return "missing name wtf" end

      name = uppercase(name)
      name = E:ShortenString(name, length)

      if not dm.isEnabled then return name end

      local reverseGradient = reverseUnitsTable[unit]
      return FormatColorTag(name, unit, reverseGradient)
    end)

    E:AddTag(format("tx:name:abbrev:%s", textFormat), "UNIT_NAME_UPDATE PLAYER_TARGET_CHANGED UNIT_FACTION INSTANCE_ENCOUNTER_ENGAGE_UNIT", function(unit)
      local name = UnitName(unit)
      if not name then return "missing name wtf" end

      if strfind(name, "%s") then name = Abbrev(name) end
      name = E:ShortenString(name, length)

      if not dm.isEnabled then return name end

      local reverseGradient = reverseUnitsTable[unit]
      return FormatColorTag(name, unit, reverseGradient)
    end)

    E:AddTag(format("tx:name:abbrev:%s:uppercase", textFormat), "UNIT_NAME_UPDATE PLAYER_TARGET_CHANGED UNIT_FACTION INSTANCE_ENCOUNTER_ENGAGE_UNIT", function(unit)
      local name = UnitName(unit)
      if not name then return "missing name wtf" end

      name = uppercase(name)

      if strfind(name, "%s") then name = Abbrev(name) end
      name = E:ShortenString(name, length)

      if not dm.isEnabled then return name end

      local reverseGradient = reverseUnitsTable[unit]
      return FormatColorTag(name, unit, reverseGradient)
    end)
  end

  -- ToxiUI: Health Tags
  local function GetHealthPercentage(unit)
    local max = UnitHealthMax(unit)
    if max == 0 then
      return 0
    else
      return floor(UnitHealth(unit) / max * 100 + 0.5)
    end
  end

  local function ConstructFullHealthStr(reverseGradient, health, percentHealth)
    if not reverseGradient then
      -- TODO: fix this to be an actual | sign instead of l (letter L)
      return health .. " l " .. percentHealth
    else
      return percentHealth .. " l " .. health
    end
  end

  local function ColorHealthTag(unit, percentSign)
    local db = E.db.TXUI.styles.healthTag

    local status = not UnitIsFeignDeath(unit) and UnitIsDead(unit) and L["Dead"] or UnitIsGhost(unit) and L["Ghost"] or not UnitIsConnected(unit) and L["Offline"]

    if db.enabled and status then return status end

    local min, max = UnitHealth(unit), UnitHealthMax(unit)
    local health = E:GetFormattedText("CURRENT", min, max, nil, true)

    local percentHealth = GetHealthPercentage(unit)
    local percentHealthStr = tostring(percentHealth)

    local finalHealth
    local reverseGradient = not reverseUnitsTable[unit]

    local colorHealth = E.db.TXUI.themes.gradientMode.colorHealth
    if percentSign then percentHealthStr = percentHealthStr .. "%" end

    if db.enabled then
      if db.style == "FullPercent" then
        -- combine string with pipe, revert for target etc
        finalHealth = ConstructFullHealthStr(reverseGradient, health, percentHealthStr)
      else
        finalHealth = health
      end
    else
      finalHealth = percentHealthStr
    end

    -- Return different coloring for Dark Mode
    if dm.isEnabled then
      return FormatColorTag(finalHealth, unit, reverseGradient)
    -- If not gradient mode, or the option is disabled, return early an uncolored string
    elseif not gm.isEnabled or not colorHealth or not colorHealth.enabled then
      return finalHealth
    end

    local yellow = colorHealth.yellowThreshold
    local red = colorHealth.redThreshold

    if percentHealth <= yellow and percentHealth > red then
      return F.String.GradientClass(finalHealth, "ROGUE", reverseGradient)
    elseif percentHealth <= red then
      return F.String.GradientClass(finalHealth, "DEATHKNIGHT", reverseGradient)
    else
      return finalHealth
    end
  end

  E:AddTag("tx:health:percent:nosign", "UNIT_HEALTH PLAYER_TARGET_CHANGED UNIT_FACTION UNIT_MAXHEALTH", function(unit)
    return ColorHealthTag(unit)
  end)

  E:AddTag("tx:health:percent", "UNIT_HEALTH PLAYER_TARGET_CHANGED UNIT_FACTION UNIT_MAXHEALTH", function(unit)
    return ColorHealthTag(unit, true)
  end)

  E:AddTag("tx:health:current:shortvalue", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED", function(unit)
    local status = not UnitIsFeignDeath(unit) and UnitIsDead(unit) and L["Dead"] or UnitIsGhost(unit) and L["Ghost"] or not UnitIsConnected(unit) and L["Offline"]
    if status then
      return status
    else
      local min, max = UnitHealth(unit), UnitHealthMax(unit)
      local health = E:GetFormattedText("CURRENT", min, max, nil, true)

      if not dm.isEnabled then return health end

      local reverseGradient = reverseUnitsTable[unit]
      return FormatColorTag(health, unit, not reverseGradient)
    end
  end)

  E:AddTag("tx:health:full:nosign", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED", function(unit)
    local status = not UnitIsFeignDeath(unit) and UnitIsDead(unit) and L["Dead"] or UnitIsGhost(unit) and L["Ghost"] or not UnitIsConnected(unit) and L["Offline"]
    if status then
      return status
    else
      local min, max = UnitHealth(unit), UnitHealthMax(unit)
      local health = E:GetFormattedText("CURRENT", min, max, nil, true)

      local percentHealth = GetHealthPercentage(unit)
      local percentHealthStr = tostring(percentHealth)
      local reverseGradient = reverseUnitsTable[unit]

      local finalHealth = ConstructFullHealthStr(reverseGradient, health, percentHealthStr)

      if not dm.isEnabled then return finalHealth end

      return FormatColorTag(finalHealth, unit, not reverseGradient)
    end
  end)

  E:AddTag("tx:health:full", "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED", function(unit)
    local status = not UnitIsFeignDeath(unit) and UnitIsDead(unit) and L["Dead"] or UnitIsGhost(unit) and L["Ghost"] or not UnitIsConnected(unit) and L["Offline"]
    if status then
      return status
    else
      local min, max = UnitHealth(unit), UnitHealthMax(unit)
      local health = E:GetFormattedText("CURRENT", min, max, nil, true)

      local percentHealth = GetHealthPercentage(unit)

      local percentHealthStr = tostring(percentHealth)
      -- append % sign
      percentHealthStr = percentHealthStr .. "%"
      local reverseGradient = reverseUnitsTable[unit]

      local finalHealth = ConstructFullHealthStr(reverseGradient, health, percentHealthStr)

      if not dm.isEnabled then return finalHealth end

      return FormatColorTag(finalHealth, unit, not reverseGradient)
    end
  end)

  -- ToxiUI: Power Tags
  local function ColorSmartPowerTag(unit, percentSign, full)
    local max = UnitPowerMax(unit)

    if max == 0 then return end

    local _, powerType = UnitPowerType(unit)

    local power = floor(UnitPower(unit) / max * 100 + 0.5)
    local powerStr = tostring(power)
    local reverseGradient = reverseUnitsTable[unit]

    if percentSign then powerStr = powerStr .. "%" end

    if powerType ~= "MANA" then return powerStr end

    if full then powerStr = tostring(UnitPower(unit)) end

    if power <= 50 and power > 20 then
      return F.String.GradientClass(powerStr, "ROGUE", reverseGradient)
    elseif power <= 20 then
      return F.String.GradientClass(powerStr, "DEATHKNIGHT", reverseGradient)
    else
      return powerStr
    end
  end

  -- Power Percent No Sign Tag
  E:AddTag("tx:power:percent:nosign", "UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER", function(unit)
    local max = UnitPowerMax(unit)
    local power = floor(UnitPower(unit) / max * 100 + 0.5)

    if not dm.isEnabled then
      if max ~= 0 then return power end
    end

    local powerStr = tostring(power)

    local reverseGradient = reverseUnitsTable[unit]
    if max ~= 0 then return FormatColorTag(powerStr, unit, reverseGradient) end
  end)

  -- Smart Power Percent No Sign Tag
  E:AddTag("tx:smartpower:percent:nosign", "UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER", function(unit)
    return ColorSmartPowerTag(unit)
  end)

  E:AddTag("tx:smartpower", "UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER", function(unit)
    return ColorSmartPowerTag(unit, false, true)
  end)

  -- Power Percent Tag
  E:AddTag("tx:power:percent", "UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER", function(unit)
    local max = UnitPowerMax(unit)
    local power = floor(UnitPower(unit) / max * 100 + 0.5)
    local powerStr = tostring(power)
    -- append % sign
    powerStr = powerStr .. "%"

    if not dm.isEnabled then
      if max ~= 0 then return powerStr end
    end

    local reverseGradient = reverseUnitsTable[unit]
    if max ~= 0 then return FormatColorTag(powerStr, unit, reverseGradient) end
  end)

  -- Smart Power Percent Tag
  E:AddTag("tx:smartpower:percent", "UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER", function(unit)
    return ColorSmartPowerTag(unit, true)
  end)

  local usingSpecIcons = TXUI.IsRetail and match(iconTheme, "ToxiSpec")

  -- Class Icon Tag
  E:AddTag("tx:classicon", "PLAYER_TARGET_CHANGED", function(unit)
    if UnitIsPlayer(unit) then
      local _, class = UnitClass(unit)
      local icon = classIcons[class]

      if usingSpecIcons then
        local specIcon = ""

        local info = E:GetUnitSpecInfo(unit)

        if info and info.id and iconsDb then
          icon = specIcons[info.id]

          if icon then specIcon = format(classIcon, icon) end
        end

        return specIcon
      end

      if icon then return format(classIcon, icon) end
    end
  end)

  -- Level Tag
  E:AddTag("tx:level", "UNIT_LEVEL PLAYER_LEVEL_UP", function(unit)
    local level = UnitLevel(unit)

    -- Do not show level for max level units
    if level >= I.MaxLevelTable[TXUI.MetaFlavor] then return end

    -- Handle unknown or missing level
    if level == -1 or not level or level == "" then level = "??" end

    local levelStr = "Lv " .. tostring(level)

    if not dm.isEnabled then return levelStr end

    local reverseGradient = reverseUnitsTable[unit]
    return FormatColorTag(levelStr, unit, reverseGradient)
  end)

  -- Level Difficulty Tag
  E:AddTag("tx:level:difficulty", "UNIT_LEVEL PLAYER_LEVEL_UP", function(unit)
    local level = UnitLevel(unit)

    -- Handle unknown or missing level
    if level == -1 or not level or level == "" then level = "??" end

    local color
    local hex

    if level == "??" then
      hex = "6e6e6e" -- #6e6e6e
    else
      color = GetCreatureDifficultyColor(level)
      hex = E:RGBToHex(color.r, color.g, color.b, "")
    end

    local levelStr = tostring(level)
    local coloredLvl = F.String.Color(levelStr, hex)

    if not dm.isEnabled then return "Lv " .. coloredLvl end

    local reverseGradient = reverseUnitsTable[unit]
    -- After reload without a target FormatColorTag returns nil so we have to fallback to "Lv"
    return (FormatColorTag("Lv ", unit, reverseGradient) or "Lv") .. coloredLvl
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

  -- Class Icon
  do
    E:AddTagInfo(
      "tx:classicon",
      TagNames.GENERAL,
      "Displays " .. TXUI.Title .. " class icon. The class icon style can be customized in " .. TXUI.Title .. " settings -> " .. F.String.Menu.Skins() .. " -> " .. F.String.ElvUI()
    )

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
    E:AddTagInfo("tx:classification", TagNames.GENERAL, "Displays a silver or gold " .. TXUI.Title .. " star for rare & elite monsters")
  end

  -- Tag info: Names
  do
    -- Tag categories and their descriptions
    local tagCategories = {
      { modifier = "", description = "Displays the name of the unit with " },
      {
        modifier = "abbrev:",
        description = "Displays the name of the unit with abbreviation and ",
        uppercaseDesc = "Displays the name of the unit in UPPERCASE with abbreviation and ",
      },
    }

    -- Lengths and their descriptions
    local lengths = {
      { name = "veryshort", limit = 5 },
      { name = "short", limit = 10 },
      { name = "medium", limit = 15 },
      { name = "long", limit = 20 },
    }

    -- Uppercase modifier
    local uppercaseModifier = ":uppercase"

    -- Loop to generate tags
    for _, category in ipairs(tagCategories) do
      for _, length in ipairs(lengths) do
        -- Regular tags
        local tagName = "tx:name:" .. category.modifier .. length.name
        local description = category.description .. TXUI.Title .. " colors. (limited to " .. length.limit .. " letters)"
        E:AddTagInfo(tagName, TagNames.NAMES, description)

        -- Uppercase tags, if applicable
        if category.modifier == "abbrev:" then
          -- For abbreviated tags, include uppercase modifier after length
          tagName = tagName .. uppercaseModifier
          description = category.uppercaseDesc .. TXUI.Title .. " colors. (limited to " .. length.limit .. " letters)"
          E:AddTagInfo(tagName, TagNames.NAMES, description)
        else
          -- For non-abbreviated tags, add uppercase versions
          local uppercaseTagName = "tx:name:" .. length.name .. uppercaseModifier
          local uppercaseDescription = "Displays the name of the unit in UPPERCASE with " .. TXUI.Title .. " colors. (limited to " .. length.limit .. " letters)"
          E:AddTagInfo(uppercaseTagName, TagNames.NAMES, uppercaseDescription)
        end
      end
    end
  end

  -- Tag info: Health
  do
    E:AddTagInfo("tx:health:percent:nosign", TagNames.HEALTH, "Displays percentage HP of unit without decimals or the % sign. Also adds " .. TXUI.Title .. " colors.")
    E:AddTagInfo("tx:health:percent", TagNames.HEALTH, "Displays percentage HP of unit without decimals. Also adds " .. TXUI.Title .. " colors.")
    E:AddTagInfo("tx:health:current:shortvalue", TagNames.HEALTH, "Shortvalue of the unit's current health (e.g. 81k instead of 81200). Also adds " .. TXUI.Title .. " colors.")

    E:AddTagInfo("tx:health:full:nosign", TagNames.HEALTH, "Displays full HP for Old layout style (e.g. 81k | 100) with " .. TXUI.Title .. " colors and no % sign.")
    E:AddTagInfo("tx:health:full", TagNames.HEALTH, "Displays full HP for Old layout style (e.g. 81k | 100%) with " .. TXUI.Title .. " colors.")
  end

  -- Tag info: Power
  do
    E:AddTagInfo(
      "tx:power:percent:nosign",
      TagNames.POWER,
      "Displays percentage Power of unit without decimals or the % sign. Also adds " .. TXUI.Title .. " colors and does not display when Power is at 0."
    )

    E:AddTagInfo(
      "tx:smartpower:percent:nosign",
      TagNames.POWER,
      "Displays percentage Smart Power of unit without decimals or the % sign. Smart Power changes color to "
        .. F.String.Warning("yellow")
        .. " when "
        .. F.String.Class("MANA", "MAGE")
        .. " <= 50, and to "
        .. F.String.Error("red")
        .. " when "
        .. F.String.Class("MANA", "MAGE")
        .. " <= 20"
    )

    E:AddTagInfo(
      "tx:power:percent",
      TagNames.POWER,
      "Displays percentage Power of unit without decimals. Also adds " .. TXUI.Title .. " colors and does not display when Power is at 0."
    )

    E:AddTagInfo(
      "tx:smartpower:percent",
      TagNames.POWER,
      "Displays percentage Smart Power of unit without decimals. Smart Power changes color to "
        .. F.String.Warning("yellow")
        .. " when "
        .. F.String.Class("MANA", "MAGE")
        .. " <= 50, and to "
        .. F.String.Error("red")
        .. " when "
        .. F.String.Class("MANA", "MAGE")
        .. " <= 20"
    )

    E:AddTagInfo(
      "tx:smartpower",
      TagNames.POWER,
      "Displays raw power value for mana users, otherwise percentage. No percentage sign and no decimals. Changes color when mana gets low."
    )
  end

  -- Requires ElvUI 13.67 or later
  if UF and UF.overrideTags then
    local overrideTags = {
      ["tx:level"] = true,
      ["tx:level:difficulty"] = true,
      ["tx:classicon"] = true,
      ["tx:health:full"] = true,
      ["tx:health:full:nosign"] = true,
      ["tx:health:percent:nosign"] = true,
      ["tx:health:percent"] = true,
      ["tx:health:current:shortvalue"] = true,

      ["tx:name:veryshort"] = true,
      ["tx:name:short"] = true,
      ["tx:name:medium"] = true,
      ["tx:name:long"] = true,

      ["tx:name:abbrev:veryshort"] = true,
      ["tx:name:abbrev:short"] = true,
      ["tx:name:abbrev:medium"] = true,
      ["tx:name:abbrev:long"] = true,

      ["tx:name:veryshort:uppercase"] = true,
      ["tx:name:short:uppercase"] = true,
      ["tx:name:medium:uppercase"] = true,
      ["tx:name:long:uppercase"] = true,

      ["tx:name:abbrev:veryshort:uppercase"] = true,
      ["tx:name:abbrev:short:uppercase"] = true,
      ["tx:name:abbrev:medium:uppercase"] = true,
      ["tx:name:abbrev:long:uppercase"] = true,

      ["tx:power:percent"] = true,
      ["tx:power:percent:nosign"] = true,
      ["tx:smartpower"] = true,
      ["tx:smartpower:percent"] = true,
      ["tx:smartpower:percent:nosign"] = true,
    }

    F.Table.Crush(UF.overrideTags, overrideTags)
  end

  -- Settings Callback
  F.Event.RegisterCallback("Tags.DatabaseUpdate", self.TagsUpdate, self)
  F.Event.RegisterCallback("TXUI.DatabaseUpdate", self.TagsUpdate, self)
  F.Event.RegisterOnceCallback("TXUI.InitializedSafe", F.Event.GenerateClosure(self.TagsUpdate, self))
end

M:AddCallback("Tags")
