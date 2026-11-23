local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")

local ipairs = ipairs
local pairs = pairs
local type = type

--[[
  Locks ElvUI options that ToxiUI overrides at runtime.

  Runs from O:OptionsCallback, which ElvUI calls from ElvUI_Options/Game/load.lua after every
  ElvUI options table is built, so E.Options can be patched in place.

  The ElvUI value stays saved. While the ToxiUI feature is active:
    - each overridden option is disabled and its tooltip says which feature controls it
    - the group gets a short notice at the top saying which feature controls the greyed-out settings
  Every check is a function, so toggling the ToxiUI feature updates ElvUI's options without a reload.
]]

-- Walks E.Options args by key, returns nil if any step is missing (keys differ per client)
local function GetOption(root, ...)
  local option = root
  for _, key in ipairs { ... } do
    option = option and option.args and option.args[key]
    if not option then return end
  end
  return option
end

-- override = { check, feature, location }
local function IsActive(override)
  return override.check() and true or false
end

local function ChangeIn(override, them)
  return F.String.Silver("Change " .. (them and "them" or "it") .. " in ") .. TXUI.Title .. F.String.Silver(" > " .. override.location .. ".")
end

local function TooltipNote(override)
  return F.String.Warning("Controlled by ") .. TXUI.Title .. F.String.Warning(" " .. override.feature .. ".") .. "\n" .. ChangeIn(override)
end

local function AppendTooltip(option, override, note)
  local originalDesc = option.desc
  option.desc = function(info)
    local desc = originalDesc
    if type(desc) == "function" then desc = desc(info) end
    if not IsActive(override) then return desc end
    if desc and desc ~= "" then return desc .. "\n\n" .. note end
    return note
  end
end

-- Disables an option (recursing into groups) and adds the tooltip note
local function LockOption(option, override)
  if type(option) ~= "table" then return end

  if option.type == "group" then
    if option.args then
      for _, child in pairs(option.args) do
        LockOption(child, override)
      end
    end
    return
  end

  if option.type == "description" or option.type == "header" then return end

  local originalDisabled = option.disabled
  option.disabled = function(info)
    if IsActive(override) then return true end
    if type(originalDisabled) == "function" then return originalDisabled(info) end
    return originalDisabled
  end

  AppendTooltip(option, override, TooltipNote(override))
end

-- Notice shown first in the group while the feature is active. Order 0 because AceConfig puts negative orders last
local function AddNotice(group, id, override, nameFunc)
  group.args["txuiOverride_" .. id] = {
    order = 0,
    type = "description",
    fontSize = "medium",
    width = "full",
    name = function()
      return nameFunc() .. "\n\n"
    end,
    hidden = function()
      return not IsActive(override)
    end,
  }
end

--[[
  Locks the given child keys of a group, or every setting in it when keys is nil, and adds a notice.
  The notice stays short; the greyed-out state and each option's tooltip show what's overridden.
]]
local function LockGroup(group, id, override, keys)
  if type(group) ~= "table" or not group.args then return end

  local subject = keys and "Greyed-out settings are" or "This section is"
  local notice = F.String.Warning(subject .. " controlled by ") .. TXUI.Title .. F.String.Warning(" " .. override.feature .. ".") .. "\n" .. ChangeIn(override, keys ~= nil)

  if keys then
    for _, key in ipairs(keys) do
      LockOption(group.args[key], override)
    end
  else
    LockOption(group, override)
  end

  AddNotice(group, id, override, function()
    return notice
  end)
end

-- Feature checks, mirroring each module's own enable conditions
local function GetModule(name)
  return TXUI:GetModule(name, true)
end

local function IsAFKActive()
  local db = E.db.TXUI and E.db.TXUI.addons and E.db.TXUI.addons.afkMode
  return db and db.enabled
end

local function IsArmoryActive()
  local module = GetModule("Armory")
  return module and module.isEnabled
end

local function IsCooldownManagerOverrideActive(key)
  return function()
    if not TXUI:HasRequirements(I.Requirements.CooldownManager) then return false end
    local db = E.db.TXUI and E.db.TXUI.addons and E.db.TXUI.addons.cooldownManager
    return db and db.enabled and db[key] and db[key].enabled
  end
end

local function IsFadePersistActive()
  if not E.private.actionbar.enable or not TXUI:HasRequirements(I.Requirements.FadePersist) then return false end
  local db = E.db.TXUI and E.db.TXUI.addons and E.db.TXUI.addons.fadePersist
  return db and db.enabled and db.mode ~= "ELVUI"
end

local function IsGradientActive()
  local module = GetModule("ThemesGradients")
  return module and module.isEnabled
end

local function IsGradientClassResourcesActive()
  local module = GetModule("ThemesGradients")
  return module and module.IsClassResourcesActive and module:IsClassResourcesActive()
end

local function IsDarkTransparencyActive()
  local module = GetModule("ThemesDarkTransparency")
  return module and module.isTransparencyEnabled
end

local Overrides = {
  AFK = { check = IsAFKActive, feature = "AFK Mode", location = "Skins > ElvUI > AFK Mode" },
  Armory = { check = IsArmoryActive, feature = "Armory", location = "Armory" },
  ClassBar = { check = IsCooldownManagerOverrideActive("classBarOverride"), feature = "Class Bar Override", location = "Skins > Cooldown Manager > Class/Power Bars" },
  PowerBar = { check = IsCooldownManagerOverrideActive("powerBarOverride"), feature = "Power Bar Override", location = "Skins > Cooldown Manager > Class/Power Bars" },
  FadePersist = { check = IsFadePersistActive, feature = "Action Bar Visibility", location = "Skins > Action Bars (set it to ElvUI mode)" },
  Gradient = { check = IsGradientActive, feature = "Gradient Mode", location = "Themes > Gradient Mode" },
  GradientClassResources = { check = IsGradientClassResourcesActive, feature = "Gradient Mode", location = "Themes > Gradient Mode" },
  DarkTransparency = { check = IsDarkTransparencyActive, feature = "Dark Mode transparency", location = "Themes > Dark Mode" },
}

function O:LockElvUIGeneral(options)
  -- AFK Mode: ToxiUI replaces the whole AFK screen and writes E.db.general.afk itself
  LockGroup(GetOption(options, "general", "cosmetic", "afkGroup"), "afk", Overrides.AFK)

  -- Item Level: Armory takes over the Character panel and re-enables displayCharacterInfo if it gets turned off
  local itemLevelGroup = GetOption(options, "general", "blizzardImprovements", "itemLevelInfo")
  if itemLevelGroup then
    local override = Overrides.Armory
    LockOption(itemLevelGroup.args.displayCharacterInfo, override)
    AddNotice(itemLevelGroup, "armory", override, function()
      return TXUI.Title .. F.String.Warning(" Armory replaces the entire Character panel, so Display Character Info is always enabled.") .. "\n" .. ChangeIn(override)
    end)
  end
end

function O:LockElvUIActionBars(options)
  -- Visibility: ToxiUI decides when the global fade parent shows, ElvUI's fade alpha is unused
  LockGroup(GetOption(options, "actionbar", "general"), "fadePersist", Overrides.FadePersist, { "globalFadeAlpha" })
end

function O:LockElvUIUnitFrames(options)
  local unitframe = GetOption(options, "unitframe")
  if not unitframe then return end

  local gradient = Overrides.Gradient

  -- Cooldown Manager bar overrides rewrite the player classbar/power enable per spec
  local player = GetOption(unitframe, "individualUnits", "player")
  LockGroup(GetOption(player, "classbar"), "classBarOverride", Overrides.ClassBar, { "enable" })
  LockGroup(GetOption(player, "power"), "powerBarOverride", Overrides.PowerBar, { "enable" })

  -- Gradient Mode textures, the global texture still applies to other bars, so only a tooltip note
  if unitframe.args.statusbar then
    AppendTooltip(
      unitframe.args.statusbar,
      gradient,
      TXUI.Title .. F.String.Warning(" Gradient Mode replaces this texture on health, power and cast bars.") .. "\n" .. ChangeIn(gradient, true)
    )
  end

  local colors = GetOption(unitframe, "allColorsGroup")
  if colors then
    -- Health
    local health = GetOption(colors, "healthGroup")
    LockGroup(health, "gradient", gradient, {
      "healthMultiplier",
      "colorhealthbyvalue",
      "healthselection",
      "healthclass",
      "forcehealthreaction",
      "tapped",
      "health",
      "disconnected",
      "healthBackdrop",
    })
    LockGroup(health, "darkTransparency", Overrides.DarkTransparency, { "transparentHealth", "invertHealth" })
    LockGroup(GetOption(colors, "healthBreak"), "gradient", gradient)

    -- Power
    LockGroup(GetOption(colors, "powerGroup"), "gradient", gradient, { "powerselection", "powerclass", "custompowerbackdrop", "power_backdrop" })
    LockGroup(GetOption(colors, "classResourceGroup", "powerGroup"), "gradient", gradient)

    -- Cast Bar (Class Castbars is still respected)
    LockGroup(GetOption(colors, "castBars"), "gradient", gradient, {
      "castReactionColor",
      "customcastbarbackdrop",
      "castbar_backdrop",
      "castColor",
      "castNoInterrupt",
      "castInterruptedColor",
    })

    -- Reaction & Selection
    LockGroup(GetOption(colors, "reactionGroup"), "gradient", gradient)
    LockGroup(GetOption(colors, "selectionGroup"), "gradient", gradient)

    -- Class Resources, only the ones Gradient Mode has colors for (classResourceMap), the rest keep ElvUI's color
    local classResources = GetOption(colors, "classResourceGroup")
    if classResources then
      local override = Overrides.GradientClassResources

      LockGroup(GetOption(classResources, "class"), "gradient", override, {
        "PALADIN",
        "PRIEST",
        "ARCANE_CHARGES",
        "FROST_ICICLES",
        "FIRE_BLAST",
        "SOUL_SHARDS",
        "SOUL_FRAGMENTS",
        "SPEAR_TIP",
      })

      for _, key in ipairs { "COMBO_POINTS", "CHI_POWER", "ESSENCE" } do
        LockGroup(GetOption(classResources, key), "gradient", override)
      end

      -- Charging rune color is still respected
      local runes = GetOption(classResources, "RUNES")
      if runes and runes.args then
        local runeKeys = {}
        for key in pairs(runes.args) do
          if key ~= "chargingRunes" then runeKeys[#runeKeys + 1] = key end
        end
        LockGroup(runes, "gradient", override, runeKeys)
      end
    end
  end

  -- Per-unit castbar custom colors (Enable, Class Color, Transparent and Invert are still respected)
  local castbarKeys = { "useReactionColor", "useCustomBackdrop", "colorBackdrop", "color", "colorNoInterrupt", "colorInterrupted" }
  for _, unitGroup in ipairs { "individualUnits", "groupUnits" } do
    local units = GetOption(unitframe, unitGroup)
    if units and units.args then
      for _, unit in pairs(units.args) do
        LockGroup(GetOption(unit, "castbar", "customColor"), "gradient", gradient, castbarKeys)
      end
    end
  end
end

function O:LockElvUINamePlates(options)
  -- ElvUI still picks which color applies, Gradient Mode replaces the color itself
  local colors = GetOption(options, "nameplates", "colorsGroup")
  if not colors then return end

  local gradient = Overrides.Gradient

  LockGroup(GetOption(colors, "general"), "gradient", gradient, { "tapped" })
  for _, key in ipairs { "threat", "selectionGroup", "classification", "reactions" } do
    LockGroup(GetOption(colors, key), "gradient", gradient)
  end
end

--[[
  Text Format hints: the ToxiUI profile leaves Name/Health/Power Text Format empty and draws those texts with
  Custom Texts instead. Nothing is locked (Text Format still works), it just points users to Custom Texts.
]]
local textFormatHint = { check = F.IsTXUIProfile }

local function AddTextFormatHint(group, unitGroup, unit)
  if type(group) ~= "table" or not group.args or not group.args.text_format then return end

  AppendTooltip(
    group.args.text_format,
    textFormatHint,
    TXUI.Title .. F.String.Warning(" shows this text using Custom Texts.") .. "\n" .. F.String.Silver("Text entered here is shown in addition to them.")
  )

  group.args.txuiTextFormatHint = {
    order = 98,
    type = "description",
    fontSize = "medium",
    width = "full",
    name = TXUI.Title .. F.String.Warning(" shows this text using Custom Texts, edit it there.") .. "\n" .. F.String.Silver(
      "Text entered in Text Format is shown in addition to them."
    ),
    hidden = function()
      return not F.IsTXUIProfile()
    end,
  }

  group.args.txuiTextFormatButton = {
    order = 99,
    type = "execute",
    name = "Custom Texts",
    func = function()
      E.Libs.AceConfigDialog:SelectGroup("ElvUI", "unitframe", unitGroup, unit, "customTexts")
    end,
    hidden = function()
      return not F.IsTXUIProfile()
    end,
  }
end

function O:AddElvUITextFormatHints(options)
  for _, unitGroup in ipairs { "individualUnits", "groupUnits" } do
    local units = GetOption(options, "unitframe", unitGroup)
    if units and units.args then
      for unit, unitOptions in pairs(units.args) do
        -- Only units that have a Custom Texts tab to send users to
        if GetOption(unitOptions, "customTexts") then
          AddTextFormatHint(GetOption(unitOptions, "name"), unitGroup, unit)
          AddTextFormatHint(GetOption(unitOptions, "health", "textGroup"), unitGroup, unit)
          AddTextFormatHint(GetOption(unitOptions, "power", "textGroup"), unitGroup, unit)
        end
      end
    end
  end
end

function O:LockElvUIOverrides()
  local options = E.Options
  if not options or not options.args then return end

  self:LockElvUIGeneral(options)
  self:LockElvUIActionBars(options)
  self:LockElvUIUnitFrames(options)
  self:LockElvUINamePlates(options)
  self:AddElvUITextFormatHints(options)
end
