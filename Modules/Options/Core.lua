local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")
local LSM = E.Libs.LSM

local _G = _G
local format = string.format
local next = next
local pairs = pairs
local tinsert = table.insert
local type = type
local xpcall = xpcall

O.txUIDisabled = function()
  return not F.IsTXUIProfile()
end

O.enabledState = F.Enum { "YES", "NO", "FORCE_DISABLED" }
O.orderIndex = 1
O.callOnInit = {}
O.options = {
  general = {
    order = 2,
    type = "group",
    group = "tab",
    name = F.String.FastGradientHex("General", "#fffd61", "#c79a00"),
    desc = "Installation and credits",
    icon = I.Media.Icons.General,
    args = {},
  },
  contacts = {
    order = 3,
    type = "group",
    group = "tab",
    name = F.String.FastGradientHex("Contacts", "#ffa270", "#c63f17"),
    desc = "Find links on how to contact us",
    icon = I.Media.Icons.Contacts,
    args = {},
  },
  themes = {
    order = 4,
    type = "group",
    group = "tab",
    name = F.String.FastGradientHex("Themes", "#73e8ff", "#0086c3"),
    desc = "Toggle between Original, Gradient & Dark modes",
    icon = I.Media.Icons.Themes,
    hidden = O.txUIDisabled,
    args = {},
  },
  wunderbar = {
    order = 5,
    type = "group",
    group = "tab",
    name = F.String.FastGradientHex("WunderBar", "#98ee99", "#338a3e"),
    desc = "Configure all options for the bottom bar",
    icon = I.Media.Icons.WunderBar,
    hidden = O.txUIDisabled,
    args = {},
  },
  armory = {
    order = 6,
    type = "group",
    group = "tab",
    name = F.String.FastGradientHex("Armory", "#6ff9ff", "#0095a8"),
    desc = "Configure all options for the Character Sheet Armory",
    icon = I.Media.Icons.Armory,
    hidden = O.txUIDisabled,
    args = {},
  },
  skins = {
    order = 7,
    type = "group",
    group = "tab",
    name = F.String.FastGradientHex("Skins", "#ff77a9", "#b4004e"),
    desc = "Configure various skins that " .. TXUI.Title .. " provides",
    icon = I.Media.Icons.Skins,
    hidden = O.txUIDisabled,
    args = {},
  },
  fonts = {
    order = 8,
    type = "group",
    group = "tab",
    name = F.String.FastGradientHex("Fonts", "#df78ef", "#790e8b"),
    desc = "Configure various ElvUI and " .. TXUI.Title .. " fonts",
    icon = I.Media.Icons.Fonts,
    hidden = O.txUIDisabled,
    args = {},
  },
  misc = {
    order = 9,
    type = "group",
    group = "tab",
    name = F.String.FastGradientHex("Miscellaneous", "#b085f5", "#4d2c91"),
    desc = "Miscellaneous " .. TXUI.Title .. " plug-ins",
    icon = I.Media.Icons.Misc,
    hidden = O.txUIDisabled,
    args = {},
  },
  changelog = {
    order = 10,
    type = "group",
    group = "select",
    name = F.String.FastGradientHex("Changelog", "#8e99f3", "#26418f"),
    desc = "See the changelogs for all " .. TXUI.Title .. " releases",
    icon = I.Media.Icons.Changelog,
    hidden = O.txUIDisabled,
    args = {},
  },
  reset = {
    order = 11,
    type = "group",
    group = "tab",
    name = F.String.FastGradientHex("Reset", "#ff867c", "#b61827"),
    desc = "Reset " .. TXUI.Title .. " options",
    icon = I.Media.Icons.Reset,
    hidden = O.txUIDisabled,
    args = {},
  },
}

-- Error handler
local function errorhandler(err)
  return _G.geterrorhandler()(err)
end

function O:GetAllFontsFunc(additional)
  return function()
    return F.Table.Join({}, LSM:HashTable("font"), additional or {})
  end
end

function O:GetAllFontOutlinesFunc(additional)
  local styleSelection = {
    NONE = "None",
    OUTLINE = "Outline",
    THICKOUTLINE = "Thick",
    MONOCHROME = "|cffaaaaaaMono|r",
    MONOCHROMEOUTLINE = "|cffaaaaaaMono|r Outline",
    MONOCHROMETHICKOUTLINE = "|cffaaaaaaMono|r Thick",
  }

  return function()
    return F.Table.Join({}, styleSelection, additional or {})
  end
end

function O:GetAllFontColorsFunc(additional)
  local colorSelection = {
    NONE = "None",
    CLASS = F.String.Class("Class Color"),
    VALUE = F.String.ElvUIValue("ElvUI Color"),
    TXUI = TXUI.Title .. F.String.ToxiUI(" Color"),
    CUSTOM = "Custom",
  }

  if TXUI.IsRetail then F.Table.Join(colorSelection, {
    COVENANT = F.String.Covenant("Covenant Color"),
  }) end

  return function()
    return F.Table.Join({}, colorSelection, additional or {})
  end
end

function O:GetFontColorGetter(profileDB, defaultDB, customKey)
  return function(info)
    local key = customKey or info[#info]
    local profileEntry = F.GetDBFromPath(profileDB)[key]
    local defaultEntry = defaultDB[key]
    return profileEntry.r, profileEntry.g, profileEntry.b, profileEntry.a, defaultEntry.r, defaultEntry.g, defaultEntry.b, defaultEntry.a
  end
end

function O:GetFontColorSetter(profileDB, callback, customKey)
  return function(info, r, g, b, a)
    local key = customKey or info[#info]
    local profileEntry = F.GetDBFromPath(profileDB)[key]
    if profileEntry.r ~= r or profileEntry.g ~= g or profileEntry.b ~= b or profileEntry.a ~= a then
      profileEntry.r, profileEntry.g, profileEntry.b, profileEntry.a = r, g, b, a
      callback()
    end
  end
end

function O:GetEnabledState(check, group)
  local enabled = (check == true)
  local forceDisabled = false

  if group and group.disabled then
    if type(group.disabled) == "boolean" then
      forceDisabled = group.disabled
    elseif type(group.disabled) == "function" then
      forceDisabled = group.disabled()
    end
  end

  if (enabled and enabled == true) and not forceDisabled then
    return self.enabledState.YES
  elseif not forceDisabled then
    return self.enabledState.NO
  end

  return self.enabledState.FORCE_DISABLED
end

function O:GetEnableName(check, group)
  local enabled = self:GetEnabledState(check, group)

  if enabled == self.enabledState.YES then
    return F.String.Good("Enabled")
  elseif enabled == self.enabledState.NO then
    return F.String.Error("Disabled")
  end

  return "Disabled"
end

function O:AddGroup(options, others)
  local orderIdx = self:GetOrder()
  local group = {
    order = orderIdx,
    type = "group",
    args = {},
  }
  E:CopyTable(group, others)
  options["fancyInlineGroup" .. orderIdx] = group
  return options["fancyInlineGroup" .. orderIdx]
end

function O:AddInlineGroup(options, others)
  local orderIdx = self:GetOrder()
  local group = {
    order = orderIdx,
    inline = true,
    type = "group",
    args = {},
  }
  E:CopyTable(group, others)
  options["fancyInlineGroup" .. orderIdx] = group
  return options["fancyInlineGroup" .. orderIdx]
end

function O:AddDesc(options, othersGroup, othersDesc)
  local orderIdx = self:GetOrder()
  local inlineGroup = self:AddGroup(options, othersGroup)
  local group = {
    order = orderIdx,
    type = "description",
  }
  E:CopyTable(group, othersDesc)
  inlineGroup["args"]["fancyInlineDesc" .. orderIdx] = group
  return inlineGroup
end

function O:AddInlineDesc(options, othersGroup, othersDesc)
  local orderIdx = self:GetOrder()
  local inlineGroup = self:AddInlineGroup(options, othersGroup)
  local group = {
    order = orderIdx,
    type = "description",
  }
  E:CopyTable(group, othersDesc)
  inlineGroup["args"]["fancyInlineDesc" .. orderIdx] = group
  return inlineGroup
end

function O:AddInlineSoloDesc(options, othersDesc)
  local orderIdx = self:GetOrder()
  local group = {
    order = orderIdx,
    type = "description",
  }
  E:CopyTable(group, othersDesc)
  options["fancyInlineDesc" .. orderIdx] = group
  return group
end

function O:AddInlineRequirementsDesc(options, othersGroup, othersDesc, requirements)
  local orderIdx = self:GetOrder()
  local inlineGroup = self:AddInlineGroup(options, othersGroup)
  local group = F.Table.Join({}, {
    order = orderIdx,
    type = "description",
  }, othersDesc)

  inlineGroup.disabled = function()
    return not TXUI:HasRequirements(requirements)
  end

  -- Define if not defined
  if not group["name"] then group["name"] = "" end

  -- Convert to function
  if type(group["name"]) == "string" then
    local originalText = "" .. group["name"]

    group["name"] = function()
      local description = "" .. originalText
      local check = TXUI:CheckRequirements(requirements)
      if check and check ~= true then
        local reason = TXUI:GetRequirementString(check)
        if reason then description = description .. F.String.Error(reason) .. "\n\n" end
      end
      return description
    end
  else
    self:LogDebug("GroupName is not a string, cannot convert to requirements check")
  end

  inlineGroup["args"]["fancyInlineDesc" .. orderIdx] = group
  return inlineGroup
end

function O:AddSpacer(options, big)
  options["fancySpacer" .. self:GetOrder()] = {
    order = self:GetOrder(),
    type = "description",
    name = big and "\n\n" or "\n",
  }
  return options["fancySpacer" .. self:GetOrder()]
end

function O:AddTinySpacer(options)
  options["fancySpacer" .. self:GetOrder()] = {
    order = self:GetOrder(),
    type = "description",
    name = "",
  }
  return options["fancySpacer" .. self:GetOrder()]
end

function O:GetOrder()
  self.orderIndex = self.orderIndex + 1
  return self.orderIndex
end

function O:ResetOrder()
  self.orderIndex = 1
end

function O:AddCallback(name, func)
  -- Don't load any other settings except general and changelog when TXUI is not installed
  if not F.IsTXUIProfile() and (name ~= "Information" and name ~= "General" and name ~= "Changelog") then return end

  tinsert(self.callOnInit, func or self[name])
end

function O:OptionsCallback()
  -- Well, something went wrong, like really wrong
  if not self.Initialized then return end

  -- Add name at the top of elvui
  E.Options.name = E.Options.name .. " + " .. TXUI.Title .. format(" |cff99ff33%s|r", TXUI:GetModule("Changelog"):FormattedVersion())

  -- Header Logo and Tab Panel
  E.Options.args.TXUI = {
    type = "group",
    childGroups = "tree",
    name = TXUI.Title .. " " .. (TXUI.DevRelease and TXUI.DevTag or ""),
    args = {
      logo = {
        order = 1,
        type = "description",
        name = "",
        image = function()
          return I.Media.Logos.Logo, F.Dpi(256), F.Dpi(128)
        end,
      },
    },
  }

  -- Fill the options table
  for catagory, info in pairs(self.options) do
    E.Options.args.TXUI.args[catagory] = {
      order = info.order,
      type = "group",
      childGroups = info.group,
      name = info.name,
      desc = info.desc,
      hidden = info.hidden,
      icon = info.icon,
      args = info.args,
      get = info.get,
      set = info.set,
    }
  end
end

-- Initialization
function O:Initialize()
  -- Don't init second time
  if self.Initialized then return end

  -- Call registered submodules
  for index, func in next, self.callOnInit do
    xpcall(func, errorhandler, self)
    self.callOnInit[index] = nil
  end

  -- Removing settings tab when not installed
  if not F.IsTXUIProfile() then self.options.settings = nil end

  -- We are done, hooray!
  self.Initialized = true
end

TXUI:RegisterModule(O:GetName())
