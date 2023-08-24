local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

I.Strings = {}

I.Strings.Requirements = {
  [I.Enum.Requirements.TOXIUI_PROFILE] = "NO_STRING_NEEDED",
  [I.Enum.Requirements.WEAK_AURAS_ENABLED] = "WeakAuras couldn't be detected. This could mean that the addon isn't installed or isn't enabled. Please ensure WeakAuras is installed and enabled in your AddOns menu.",
  [I.Enum.Requirements.MASQUE_DISABLED] = "Masque is currently installed and enabled. To use this option, please disable Masque, as it interferes with ToxiUI's WeakAuras skinning.",
  [I.Enum.Requirements.WT_WA_SKIN_DISABLED] = "WeakAuras skinning is currently enabled in WindTools. To use this option, please disable WeakAuras skinning in WindTools, as it interferes with ToxiUI's WeakAuras skinning.",
  [I.Enum.Requirements.SL_DISABLED] = "You can't enable this option because a similar module in Shadow & Light is currently turned on. Please disable it to unlock this option.",
  [I.Enum.Requirements.DARK_MODE_ENABLED] = "NO_STRING_NEEDED",
  [I.Enum.Requirements.DARK_MODE_DISABLED] = "Only one theme can be activated at the same time. Please disable dark mode",
  [I.Enum.Requirements.GRADIENT_MODE_ENABLED] = "NO_STRING_NEEDED",
  [I.Enum.Requirements.GRADIENT_MODE_DISABLED] = "Only one theme can be activated at the same time. Please disable gradient mode",
  [I.Enum.Requirements.SL_VEHICLE_BAR_DISABLED] = "You can't enable this option because Shadow & Light's Vehicle Bar module is currently turned on. Please disable it to unlock this option.",
  [I.Enum.Requirements.SL_MINIMAP_COORDS_DISABLED] = "You can't enable this option because Shadow & Light's Minimap Coordinates module is currently turned on. Please disable it to unlock this option.",
  [I.Enum.Requirements.SL_DECONSTRUCT_DISABLED] = "You can't enable this option because Shadow & Light's Deconstruct module is currently turned on. Please disable it to unlock this option.",
  [I.Enum.Requirements.ARMORY_DISABLED] = "You can't enable this option because Shadow & Light's Character Armory module is currently turned on. Please disable it to unlock this option.",
  [I.Enum.Requirements.OTHER_BLIZZARD_FONTS_DISABLED] = "You can't enable this option because Shadow & Light's Media module is currently turned on. Please disable it to unlock this option.",
  [I.Enum.Requirements.WT_ENABLED] = "NO_STRING_NEEDED",
  [I.Enum.Requirements.OLD_FADE_PERSIST_DISABLED] = "ElvUI_GlobalFadePersist is currently installed and enabled. To use this option, please disable ElvUI_GlobalFadePersist, as it interferes with ToxiUI's global fade persist.",
  [I.Enum.Requirements.DETAILS_LOADED_AND_TXPROFILE] = "NO_STRING_NEEDED",
  [I.Enum.Requirements.ELVUI_BAGS_ENABLED] = "You can't enable this option because ElvUI's Bag module is currently turned off. Please enable it to unlock this option.",
  [I.Enum.Requirements.ELVUI_NOT_SKINNED] = "You can't enable this option because a similar module for UnitFrames is currently turned on. Please disable it to unlock this option.",
  [I.Enum.Requirements.DETAILS_NOT_SKINNED] = "You can't enable this option because a similar module for Details is currently turned on. Please disable it to unlock this option.",
  [I.Enum.Requirements.OTHER_THEMES_DISABLED] = "You can't enable this option because a similar module for ElvUI is currently turned on. Please disable it to unlock this option.",
  [I.Enum.Requirements.ELVUI_ACTIONBARS_DISABLED] = "You can't use this module because ElvUI's ActionBars module is currently turned off. Please enable it to unlock this option.",
}

I.Strings.RequirementsDebug = {
  [I.Enum.Requirements.TOXIUI_PROFILE] = "No ToxiUI Profile",
  [I.Enum.Requirements.WEAK_AURAS_ENABLED] = "WA Disabled",
  [I.Enum.Requirements.MASQUE_DISABLED] = "MQ Enabled",
  [I.Enum.Requirements.WT_WA_SKIN_DISABLED] = "WT Skin Enabled",
  [I.Enum.Requirements.SL_DISABLED] = "SL Enabled",
  [I.Enum.Requirements.DARK_MODE_ENABLED] = "DM Disabled",
  [I.Enum.Requirements.DARK_MODE_DISABLED] = "DM Enabled",
  [I.Enum.Requirements.GRADIENT_MODE_ENABLED] = "GM Disabled",
  [I.Enum.Requirements.GRADIENT_MODE_DISABLED] = "GM Enabled",
}

I.Strings.ChangelogText = {
  [I.Enum.ChangelogType.HOTFIX] = "Hotfix - no notes.",
}

I.Strings.WALinks = {
  ["DEFAULT"] = "https://www.luxthos.com/",
  ["DEFAULT_CLASSIC"] = "https://wago.io/classic-weakauras",
  ["FORMAT"] = "https://www.luxthos.com/%s-weakauras-for-world-of-warcraft-dragonflight/",
  ["FORMAT_WRATH"] = "https://www.luxthos.com/%s-weakauras-for-world-of-warcraft-wrath-of-the-lich-king/",
  ["FORMAT_CLASSIC"] = "https://wago.io/classic-weakauras/classes/%s",
  ["WARRIOR"] = "warrior",
  ["HUNTER"] = "hunter",
  ["MAGE"] = "mage",
  ["ROGUE"] = "rogue",
  ["PRIEST"] = "priest",
  ["WARLOCK"] = "warlock",
  ["PALADIN"] = "paladin",
  ["DRUID"] = "druid",
  ["SHAMAN"] = "shaman",
  ["MONK"] = "monk",
  ["DEMONHUNTER"] = "demon-hunter",
  ["DEATHKNIGHT"] = "death-knight",
  ["EVOKER"] = "evoker",
}

I.Strings.Colors = {
  [I.Enum.Colors.TXUI] = "00e4f5",
  [I.Enum.Colors.ELVUI] = "1784d1",
  [I.Enum.Colors.ERROR] = "ef5350",
  [I.Enum.Colors.GOOD] = "66bb6a",
  [I.Enum.Colors.WARNING] = "f5b041",
  [I.Enum.Colors.WHITE] = "ffffff",
  [I.Enum.Colors.LUXTHOS] = "03fc9c",

  [I.Enum.Colors.LEGENDARY] = "ff8000",
  [I.Enum.Colors.EPIC] = "a335ee",
  [I.Enum.Colors.RARE] = "0070dd",
  [I.Enum.Colors.BETA] = "1eff00",
}

I.Strings.Branding = {
  Title = "|cffffffffToxi|r|cff" .. I.Strings.Colors[I.Enum.Colors.TXUI] .. "UI|r",

  ColorHex = I.Strings.Colors[I.Enum.Colors.TXUI],
  ColorRGB = F.Table.HexToRGB(I.Strings.Colors[I.Enum.Colors.TXUI]),
  ColorRGBA = F.Table.HexToRGB(I.Strings.Colors[I.Enum.Colors.TXUI] .. "ff"),

  Links = {
    Website = "https://toxiui.com",
    Discord = "https://discord.gg/r85TGUU7zA",
    WAGuide = "https://toxiui.com/wa",
    Youtube = "https://www.youtube.com/channel/UCHJmprM_gp9RnpFloB5HICg",
    Github = "https://github.com/toxicom/toxiui",
  },
}

I.Strings.Deconstruct = {
  Status = {
    Title = F.String.Color("Deconstruct", I.Enum.Colors.WHITE),
    Text = "With Deconstruct enabled, hover over your items\nto easily DISENCHANT/PROSPECT/MILL them.\n\n Current state: %s",
    Inactive = F.String.Error("Inactive"),
    Active = F.String.Good("Active"),
  },

  Label = {
    [I.Enum.DeconstructState.DISENCHANT] = "DE",
    [I.Enum.DeconstructState.PROSPECT] = "PROSP",
    [I.Enum.DeconstructState.MILL] = "MILL",
  },

  Color = {
    [I.Enum.DeconstructState.DISENCHANT] = {
      r = 0 / 255,
      g = 128 / 255,
      b = 255 / 255,
      a = 1,
    },
    [I.Enum.DeconstructState.PROSPECT] = {
      r = 218 / 255,
      g = 229 / 255,
      b = 71 / 255,
      a = 1,
    },
    [I.Enum.DeconstructState.MILL] = {
      r = 71 / 255,
      g = 229 / 255,
      b = 155 / 255,
      a = 1,
    },
  },
}

I.Strings.Classes = {
  CLASSIC = {
    "WARRIOR",
    "PALADIN",
    "HUNTER",
    "ROGUE",
    "PRIEST",
    "SHAMAN",
    "MAGE",
    "WARLOCK",
    "DRUID",
  },
  WRATH = {
    "WARRIOR",
    "PALADIN",
    "HUNTER",
    "ROGUE",
    "PRIEST",
    "SHAMAN",
    "MAGE",
    "WARLOCK",
    "DRUID",
    -- Wrath only
    "DEATHKNIGHT",
  },
  RETAIL = {
    "WARRIOR",
    "PALADIN",
    "HUNTER",
    "ROGUE",
    "PRIEST",
    "SHAMAN",
    "MAGE",
    "WARLOCK",
    "DRUID",
    -- Wrath only
    "DEATHKNIGHT",
    -- Retail only
    "MONK",
    "DEMONHUNTER",
    "EVOKER",
  },
}
