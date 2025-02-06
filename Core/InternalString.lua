local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

I.Strings = {}

I.Strings.Requirements = {
  [I.Enum.Requirements.TOXIUI_PROFILE] = "无需字符串",
  [I.Enum.Requirements.SL_DISABLED] = "无法启用此选项，因为 Shadow & Light 中的类似模块当前已启用。请禁用它以解锁此选项。",
  [I.Enum.Requirements.DARK_MODE_ENABLED] = "无需字符串",
  [I.Enum.Requirements.DARK_MODE_DISABLED] = "同一时间只能激活一个主题。请禁用暗黑模式",
  [I.Enum.Requirements.GRADIENT_MODE_ENABLED] = "无需字符串",
  [I.Enum.Requirements.GRADIENT_MODE_DISABLED] = "同一时间只能激活一个主题。请禁用渐变模式",
  [I.Enum.Requirements.SL_VEHICLE_BAR_DISABLED] = "无法启用此选项，因为 Shadow & Light 的车辆栏模块当前已启用。请禁用它以解锁此选项。",
  [I.Enum.Requirements.SL_MINIMAP_COORDS_DISABLED] = "无法启用此选项，因为 Shadow & Light 的小地图坐标模块当前已启用。请禁用它以解锁此选项。",
  [I.Enum.Requirements.SL_DECONSTRUCT_DISABLED] = "无法启用此选项，因为 Shadow & Light 的分解模块当前已启用。请禁用它以解锁此选项。",
  [I.Enum.Requirements.ARMORY_DISABLED] = "无法启用此选项，因为 Shadow & Light 的角色军械库模块当前已启用。请禁用它以解锁此选项。",
  [I.Enum.Requirements.CHARACTER_SKIN_ENABLED] = "无法启用此选项，因为您已禁用 ElvUI 的角色框架皮肤",
  [I.Enum.Requirements.WT_ENABLED] = "无需字符串",
  [I.Enum.Requirements.OLD_FADE_PERSIST_DISABLED] = "当前已安装并启用 ElvUI_GlobalFadePersist。要使用此选项，请禁用 ElvUI_GlobalFadePersist，因为它会干扰 ToxiUI 的全局淡出持久性。",
  [I.Enum.Requirements.DETAILS_LOADED_AND_TXPROFILE] = "此选项已禁用，因为未加载 Details 或您的 Details 配置文件不是 ToxiUI。请运行 ToxiUI 安装程序并应用 Details 配置文件以解锁此选项。",
  [I.Enum.Requirements.ELVUI_BAGS_ENABLED] = "无法启用此选项，因为 ElvUI 的背包模块当前已关闭。请启用它以解锁此选项。",
  [I.Enum.Requirements.ELVUI_NOT_SKINNED] = "无法启用此选项，因为当前已启用类似的单位框架模块。请禁用它以解锁此选项。",
  [I.Enum.Requirements.DETAILS_NOT_SKINNED] = "无法启用此选项，因为当前已启用类似的 Details 模块。请禁用它以解锁此选项。",
  [I.Enum.Requirements.OTHER_THEMES_DISABLED] = "无法启用此选项，因为当前已启用类似的 ElvUI 模块。请禁用它以解锁此选项。",
  [I.Enum.Requirements.ELVUI_ACTIONBARS_ENABLED] = "无法使用此模块，因为 ElvUI 的动作条模块当前已关闭。请启用它以解锁此选项。",
  [I.Enum.Requirements.AB_BUDDY_DISABLED] = "无法使用此模块，因为已启用 ElvUI_ActionBarBuddy。请禁用它以解锁此选项。",
  [I.Enum.Requirements.ELTRUISM_COLOR_MODIFIERS_DISABLED] = "无法使用此模块，因为 EltruismUI 中的类似模块当前已启用。请禁用它以解锁此选项。",
  [I.Enum.Requirements.ELTRUISM_DISABLED] = "无法使用此模块，因为已启用 EltruismUI。请禁用它以解锁此选项。",
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
  ["FORMAT_CATA"] = "https://www.luxthos.com/%s-weakauras-for-world-of-warcraft-cataclysm/",
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
    WrathArmory = "https://www.curseforge.com/wow/addons/wratharmory-elvui-plugin",
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
  CATA = {
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
