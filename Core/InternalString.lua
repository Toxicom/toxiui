local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

I.Strings = {}

I.Strings.Requirements = {
  [I.Enum.Requirements.TOXIUI_PROFILE] = "NO_STRING_NEEDED",
  [I.Enum.Requirements.SL_DISABLED] = "You can't enable this option because a similar module in Shadow & Light is currently turned on. Please disable it to unlock this option.",
  [I.Enum.Requirements.DARK_MODE_ENABLED] = "NO_STRING_NEEDED",
  [I.Enum.Requirements.DARK_MODE_DISABLED] = "Only one theme can be activated at the same time. Please disable dark mode",
  [I.Enum.Requirements.GRADIENT_MODE_ENABLED] = "NO_STRING_NEEDED",
  [I.Enum.Requirements.GRADIENT_MODE_DISABLED] = "Only one theme can be activated at the same time. Please disable gradient mode",
  [I.Enum.Requirements.SL_VEHICLE_BAR_DISABLED] = "You can't enable this option because Shadow & Light's Vehicle Bar module is currently turned on. Please disable it to unlock this option.",
  [I.Enum.Requirements.SL_MINIMAP_COORDS_DISABLED] = "You can't enable this option because Shadow & Light's Minimap Coordinates module is currently turned on. Please disable it to unlock this option.",
  [I.Enum.Requirements.SL_DECONSTRUCT_DISABLED] = "You can't enable this option because Shadow & Light's Deconstruct module is currently turned on. Please disable it to unlock this option.",
  [I.Enum.Requirements.ARMORY_DISABLED] = "You can't enable this option because Shadow & Light's Character Armory module is currently turned on. Please disable it to unlock this option.",
  [I.Enum.Requirements.CHARACTER_SKIN_ENABLED] = "You can't enable this option because you have ElvUI's Character Frame Skin disabled",
  [I.Enum.Requirements.WT_ENABLED] = "NO_STRING_NEEDED",
  [I.Enum.Requirements.OLD_FADE_PERSIST_DISABLED] = "ElvUI_GlobalFadePersist is currently installed and enabled. To use this option, please disable ElvUI_GlobalFadePersist, as it interferes with ToxiUI's global fade persist.",
  [I.Enum.Requirements.DETAILS_LOADED_AND_TXPROFILE] = "This option is disabled because Details is not loaded or your Details profile is not ToxiUI. Please run the ToxiUI installer and apply the Details profile to unlock this option.",
  [I.Enum.Requirements.ELVUI_BAGS_ENABLED] = "You can't enable this option because ElvUI's Bag module is currently turned off. Please enable it to unlock this option.",
  [I.Enum.Requirements.ELVUI_NOT_SKINNED] = "You can't enable this option because a similar module for UnitFrames is currently turned on. Please disable it to unlock this option.",
  [I.Enum.Requirements.DETAILS_NOT_SKINNED] = "You can't enable this option because a similar module for Details is currently turned on. Please disable it to unlock this option.",
  [I.Enum.Requirements.OTHER_THEMES_DISABLED] = "You can't enable this option because a similar module for ElvUI is currently turned on. Please disable it to unlock this option.",
  [I.Enum.Requirements.ELVUI_ACTIONBARS_ENABLED] = "You can't use this module because ElvUI's ActionBars module is currently turned off. Please enable it to unlock this option.",
  [I.Enum.Requirements.AB_BUDDY_DISABLED] = "You can't use this module because ElvUI_ActionBarBuddy is enabled. Please disable it to unlock this option.",
  [I.Enum.Requirements.ELTRUISM_COLOR_MODIFIERS_DISABLED] = "You can't use this module because a similar module is currently turned on in EltruismUI. Please disable it to unlock this option.",
  [I.Enum.Requirements.ELTRUISM_DISABLED] = "You can't use this module because EltruismUI is enabled. Please disable it to unlock this option.",
}

I.Strings.RequirementsDebug = {
  [I.Enum.Requirements.TOXIUI_PROFILE] = "No ToxiUI Profile",
  [I.Enum.Requirements.SL_DISABLED] = "SL Enabled",
  [I.Enum.Requirements.DARK_MODE_ENABLED] = "DM Disabled",
  [I.Enum.Requirements.DARK_MODE_DISABLED] = "DM Enabled",
  [I.Enum.Requirements.GRADIENT_MODE_ENABLED] = "GM Disabled",
  [I.Enum.Requirements.GRADIENT_MODE_DISABLED] = "GM Enabled",
  [I.Enum.Requirements.DETAILS_LOADED_AND_TXPROFILE] = "ToxiUI Details not found",
}

I.Strings.ChangelogText = {
  [I.Enum.ChangelogType.HOTFIX] = "Hotfix - no notes.",
}

I.Strings.WALinks = {
  ["DEFAULT"] = "https://www.luxthos.com/",
  ["FORMAT"] = "https://www.luxthos.com/%s-weakauras-for-world-of-warcraft-the-war-within/",
  ["FORMAT_MISTS"] = "https://www.luxthos.com/%s-weakauras-for-world-of-warcraft-mists-of-pandaria/",
  ["FORMAT_VANILLA"] = "https://www.luxthos.com/%s-weakauras-for-world-of-warcraft-classic-era-hardcore/",
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
  [I.Enum.Colors.TXUI] = "18a8ff", -- #18a8ff
  [I.Enum.Colors.PLATER] = "ff66a1", -- #ff66a1
  [I.Enum.Colors.DETAILS] = "f7f552", -- #f7f552
  [I.Enum.Colors.BIGWIGS] = "c94b28", -- #c94b28
  [I.Enum.Colors.NSCT] = "12e659", -- #12e659
  [I.Enum.Colors.WDP] = "e600cb", -- "#e600cb"
  [I.Enum.Colors.OMNICD] = "8634eb", -- #8634eb
  [I.Enum.Colors.WT] = "54e5ff", -- #54e5ff
  [I.Enum.Colors.ELVUI] = "1784d1", -- #1784d1
  [I.Enum.Colors.ERROR] = "ef5350", -- #ef5350
  [I.Enum.Colors.GOOD] = "66bb6a", -- #66bb6a
  [I.Enum.Colors.WARNING] = "f5b041", -- #f5b041
  [I.Enum.Colors.WHITE] = "ffffff", -- #ffffff
  [I.Enum.Colors.LUXTHOS] = "03fc9c", -- #03fc9c

  [I.Enum.Colors.SILVER] = "a3a3a3", -- #a3a3a3
  [I.Enum.Colors.GOLD] = "cfc517", -- ##cfc517

  [I.Enum.Colors.LEGENDARY] = "ff8000", -- #ff8000
  [I.Enum.Colors.EPIC] = "a335ee", -- #a335ee
  [I.Enum.Colors.RARE] = "0070dd", -- #0070dd
  [I.Enum.Colors.BETA] = "1eff00", -- #1eff00
}

I.Strings.Branding = {
  Title = "|cffffffffToxi|r|cff" .. I.Strings.Colors[I.Enum.Colors.TXUI] .. "UI|r",

  ColorHex = I.Strings.Colors[I.Enum.Colors.TXUI],
  ColorRGB = F.Table.HexToRGB(I.Strings.Colors[I.Enum.Colors.TXUI]),
  ColorRGBA = F.Table.HexToRGB(I.Strings.Colors[I.Enum.Colors.TXUI] .. "ff"),

  Links = {
    Website = "https://toxiui.com",
    Discord = "https://discord.gg/r85TGUU7zA",
    WAGuide = "https://toxiui.com/resources/guide/weakauras-guide/",
    Youtube = "https://www.youtube.com/@ToxiTV",
    Github = "https://github.com/toxicom/toxiui",
    ReforgedArmory = "https://www.curseforge.com/wow/addons/reforgedarmory-elvui-plugin",
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
  VANILLA = {
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
  MISTS = {
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
    -- Mists Only
    "MONK",
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
