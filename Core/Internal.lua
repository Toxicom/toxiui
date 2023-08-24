local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

-- General settings
I.General = {
  AddOnPath = "Interface\\AddOns\\ElvUI_ToxiUI\\",
  MediaPath = "Interface\\AddOns\\ElvUI_ToxiUI\\Media\\",

  -- Default font, this is not used inside profiles but is meant as fallback if settings are invalid
  DefaultFont = "- ToxiUI",
  DefaultFontSize = 18,
  DefaultFontShadow = false,
  DefaultFontOutline = "NONE",
  DefaultFontColor = "CUSTOM", -- CLASS, VALUE (ElvUI), CUSTOM
  DefaultFontCustomColor = F.Table.HexToRGB("#ff0000ff"),

  ChatFontSize = F.FontSizeScaled(14, 13), -- Default Blizzard chat font size, font styles defined by elvui but not size
}

I.Fonts = {
  Primary = "- ToxiUI",
  Title = "- Big Noodle Titling", -- - Big Noodle Titling
  TitleSecondary = "- M 700", -- - Montserrat Bold
  TitleRaid = "- M 900", -- - Montserrat Black
  Icons = "- ToxiUI Icons",
}

I.FontNames = {
  [I.Fonts.Primary] = "Primary",
  [I.Fonts.Title] = "Title",
  [I.Fonts.TitleSecondary] = "Title Secondary",
  [I.Fonts.TitleRaid] = "Title Raid",
}

I.FontDescription = {
  [I.Fonts.Primary] = "Used in the majority of the UI.",
  [I.Fonts.Title] = "Used mostly for names.",
  [I.Fonts.TitleSecondary] = "Used for names in Raid Frames.",
  [I.Fonts.TitleRaid] = "Mostly used for Raid names and couple other places.",
}

I.FontOrder = {
  I.Fonts.Primary,
  I.Fonts.Title,
  I.Fonts.TitleSecondary,
  I.Fonts.TitleRaid,
}

I.MediaKeys = {
  font = "Fonts",
  texture = "Textures",
  chaticon = "ChatIcons",
  icon = "Icons",
  role = "RoleIcons",
  state = "StateIcons",
  theme = "Themes",
  logo = "Logos",
  armory = "Armory",
  installer = "Installer",
}

I.MediaPaths = {
  font = [[Interface\AddOns\ElvUI_ToxiUI\Media\Fonts\]],
  texture = [[Interface\AddOns\ElvUI_ToxiUI\Media\Textures\]],
  chaticon = [[Interface\AddOns\ElvUI_ToxiUI\Media\Textures\ChatIcons\]],
  icon = [[Interface\AddOns\ElvUI_ToxiUI\Media\Textures\Icons\]],
  role = [[Interface\AddOns\ElvUI_ToxiUI\Media\Textures\Role\]],
  state = [[Interface\AddOns\ElvUI_ToxiUI\Media\Textures\State\]],
  theme = [[Interface\AddOns\ElvUI_ToxiUI\Media\Textures\Themes\]],
  logo = [[Interface\AddOns\ElvUI_ToxiUI\Media\Backgrounds\Logos\]],
  armory = [[Interface\AddOns\ElvUI_ToxiUI\Media\Backgrounds\Armory\]],
  installer = [[Interface\AddOns\ElvUI_ToxiUI\Media\Backgrounds\Installer\]],
}

-- Media
-- Look inside Media/Core.lua for all media files
I.Media = {
  Fonts = {},
  Textures = {},
  ChatIcons = {},
  Icons = {},
  RoleIcons = {},
  StateIcons = {},
  Themes = {},
  Logos = {},
  Armory = {},
  Installer = {},
}

-- Profile names to be used
-- This only affects BigWigs
I.ProfileNames = {
  ["Default"] = "ToxiUI", -- Plater, Details
  [I.Enum.Layouts.DPS] = "ToxiUI-DPS", -- BigWigs
  [I.Enum.Layouts.HEALER] = "ToxiUI-Healer", -- BigWigs
  ["Dev"] = "ToxiUI-Dev",
}

I.Requirements = {
  ["WeakAurasIcons"] = {
    I.Enum.Requirements.WEAK_AURAS_ENABLED,
    I.Enum.Requirements.WT_WA_SKIN_DISABLED,
    I.Enum.Requirements.MASQUE_DISABLED,
  },
  ["WeakAurasBars"] = {
    I.Enum.Requirements.WEAK_AURAS_ENABLED,
    I.Enum.Requirements.WT_WA_SKIN_DISABLED,
  },
  ["DarkMode"] = {
    I.Enum.Requirements.GRADIENT_MODE_DISABLED,
    I.Enum.Requirements.ELVUI_NOT_SKINNED,
  },
  ["DarkModeTransparency"] = {
    I.Enum.Requirements.DARK_MODE_ENABLED,
    I.Enum.Requirements.GRADIENT_MODE_DISABLED,
    I.Enum.Requirements.ELVUI_NOT_SKINNED,
  },
  ["GradientMode"] = {
    I.Enum.Requirements.DARK_MODE_DISABLED,
    I.Enum.Requirements.ELVUI_NOT_SKINNED,
  },
  ["VehicleBar"] = {
    I.Enum.Requirements.SL_VEHICLE_BAR_DISABLED,
    I.Enum.Requirements.ELVUI_ACTIONBARS_DISABLED,
  },
  ["MiniMapCoords"] = {
    I.Enum.Requirements.SL_MINIMAP_COORDS_DISABLED,
  },
  ["FadePersist"] = {
    I.Enum.Requirements.OLD_FADE_PERSIST_DISABLED,
    I.Enum.Requirements.ELVUI_ACTIONBARS_DISABLED,
  },
  ["GameMenuButton"] = {},
  ["BlizzardFonts"] = {
    I.Enum.Requirements.OTHER_BLIZZARD_FONTS_DISABLED,
  },
  ["RoleIcons"] = {
    I.Enum.Requirements.SL_DISABLED,
  },
  ["DetailsGradientMode"] = {
    I.Enum.Requirements.DARK_MODE_DISABLED,
    I.Enum.Requirements.ELVUI_NOT_SKINNED,
    I.Enum.Requirements.DETAILS_NOT_SKINNED,
    I.Enum.Requirements.DETAILS_LOADED_AND_TXPROFILE,
  },
  ["DetailsDarkMode"] = {
    I.Enum.Requirements.GRADIENT_MODE_DISABLED,
    I.Enum.Requirements.ELVUI_NOT_SKINNED,
    I.Enum.Requirements.DETAILS_NOT_SKINNED,
    I.Enum.Requirements.DETAILS_LOADED_AND_TXPROFILE,
  },
  ["Armory"] = {
    I.Enum.Requirements.ARMORY_DISABLED,
  },
  ["Deconstruct"] = {
    I.Enum.Requirements.SL_DECONSTRUCT_DISABLED,
    I.Enum.Requirements.ELVUI_BAGS_ENABLED,
  },
  ["ElvUITheme"] = {
    I.Enum.Requirements.OTHER_THEMES_DISABLED,
  },
}

-- Controls Settings about the Fancy Gradient Theme
-- if the value is "false" or it's not in one of the arrays it defaults to the mid texture
I.GradientMode = {
  -- Used when no gradient color is defined
  ["BackupMultiplier"] = 0.65,

  -- Shared Media Statusbar texture names
  ["Textures"] = {
    ["Left"] = "- Tx Left",
    ["Right"] = "- Tx Right",
    ["Mid"] = "- Tx Mid",
  },

  -- Layout specific settings
  ["Layouts"] = {
    -- Healer layout specific settings
    [I.Enum.Layouts.HEALER] = {
      -- Left Healer Gradient
      ["Left"] = {
        ["player"] = true,
        ["pet"] = true,
        ["tank"] = true,
        ["tanktarget"] = true,
        ["assist"] = true,
        ["assisttarget"] = true,
      },

      -- Right Healer Gradient
      ["Right"] = {
        ["target"] = true,
        ["targettarget"] = true,
        ["arena"] = true,
        ["boss"] = true,
        ["focus"] = true,
      },
    },

    -- DPS layout specific settings
    [I.Enum.Layouts.DPS] = {
      -- Left DPS Gradient
      ["Left"] = {
        ["player"] = true,
        ["pet"] = true,
        ["party"] = true,
        ["raid1"] = true,
        ["raid2"] = true,
        ["raid3"] = true,
        ["tank"] = true,
        ["tanktarget"] = true,
        ["assist"] = true,
        ["assisttarget"] = true,
      },

      -- Right DPS Gradient
      ["Right"] = {
        ["target"] = true,
        ["targettarget"] = true,
        ["arena"] = true,
        ["boss"] = true,
        ["focus"] = true,
      },
    },
  },
}

I.ElvUIIcons = {
  ["Role"] = {
    ["TXUI"] = {
      ["default"] = {
        TANK = "NewTank",
        HEALER = "NewHeal",
        DAMAGER = "NewDPS",
      },
      ["raid1"] = {
        TANK = "NewSmallTank",
        HEALER = "NewSmallHeal",
        DAMAGER = "NewSmallDPS",
      },
      ["raid2"] = {
        TANK = "NewSmallTank",
        HEALER = "NewSmallHeal",
        DAMAGER = "NewSmallDPS",
      },
      ["raid3"] = {
        TANK = "NewSmallTank",
        HEALER = "NewSmallHeal",
        DAMAGER = "NewSmallDPS",
      },
    },

    ["TXUI_WHITE"] = {
      ["default"] = {
        TANK = "WhiteTank",
        HEALER = "WhiteHeal",
        DAMAGER = "WhiteDPS",
      },
    },

    ["TXUI_MATERIAL"] = {
      ["default"] = {
        TANK = "MaterialTank",
        HEALER = "MaterialHeal",
        DAMAGER = "MaterialDPS",
      },
      ["raid1"] = {
        TANK = "MaterialTank",
        HEALER = "MaterialHeal",
        DAMAGER = "MaterialDPS",
      },
      ["raid2"] = {
        TANK = "MaterialTank",
        HEALER = "MaterialHeal",
        DAMAGER = "MaterialDPS",
      },
      ["raid3"] = {
        TANK = "MaterialTank",
        HEALER = "MaterialHeal",
        DAMAGER = "MaterialDPS",
      },
    },

    ["TXUI_STYLIZED"] = {
      ["default"] = {
        TANK = "StylizedTank",
        HEALER = "StylizedHeal",
        DAMAGER = "StylizedDPS",
      },
      ["raid1"] = {
        TANK = "StylizedTank",
        HEALER = "StylizedHeal",
        DAMAGER = "StylizedDPS",
      },
      ["raid2"] = {
        TANK = "StylizedTank",
        HEALER = "StylizedHeal",
        DAMAGER = "StylizedDPS",
      },
      ["raid3"] = {
        TANK = "StylizedTank",
        HEALER = "StylizedHeal",
        DAMAGER = "StylizedDPS",
      },
    },
  },

  ["Dead"] = {
    ["TXUI"] = "WhiteDead",
    ["TXUI_MATERIAL"] = "MaterialDead",
    ["TXUI_STYLIZED"] = "StylizedDead",
    ["BLIZZARD"] = "Interface\\LootFrame\\LootPanel-Icon",
  },

  ["Offline"] = {
    ["TXUI"] = "WhiteDC",
    ["TXUI_MATERIAL"] = "MaterialDC",
    ["TXUI_STYLIZED"] = "StylizedDC",
    ["ALERT"] = "Interface\\DialogFrame\\UI-Dialog-Icon-AlertNew",
    ["ARTHAS"] = "Interface\\LFGFRAME\\UI-LFR-PORTRAIT",
    ["PASS"] = "Interface\\PaperDollInfoFrame\\UI-GearManager-LeaveItem-Transparent",
    ["NOTREADY"] = "Interface\\RAIDFRAME\\ReadyCheck-NotReady",
  },
}

-- Holds all data important to use, and will be filled with the below entries when GameBar is loaded
-- type, name, known [known is always true for items]
I.HearthstoneDataLoaded = false
I.HearthstoneData = {
  [556] = { ["type"] = "spell", ["hearthstone"] = true, ["class"] = "SHAMAN" }, -- Astral Recall
  [6948] = { ["type"] = "item", ["hearthstone"] = true }, -- Hearthstone
  [48933] = { ["type"] = "toy", ["hearthstone"] = false }, -- Wormhole Generator: Northrend
  [50977] = { ["type"] = "spell", ["hearthstone"] = false, ["class"] = "DEATHKNIGHT" }, -- Death Gate
  [54452] = { ["type"] = "toy", ["hearthstone"] = true }, -- Ethereal Portal
  [64488] = { ["type"] = "toy", ["hearthstone"] = true }, -- The Innkeeper's Daughter
  [87215] = { ["type"] = "toy", ["hearthstone"] = false }, -- Wormhole Generator: Pandaria
  [93672] = { ["type"] = "toy", ["hearthstone"] = true }, -- Dark Portal
  [110560] = { ["type"] = "item", ["hearthstone"] = false }, -- Garrison Hearthstone
  [126892] = { ["type"] = "spell", ["hearthstone"] = false, ["class"] = "MONK" }, -- Zen Pilgrimage
  [132517] = { ["type"] = "toy", ["hearthstone"] = false }, -- Intra-Dalaran Wormhole Generator
  [140192] = { ["type"] = "item", ["hearthstone"] = false }, -- Dalaran Hearthstone
  [141605] = { ["type"] = "item", ["hearthstone"] = false }, -- Flight Master's Whistle
  [142542] = { ["type"] = "toy", ["hearthstone"] = true }, -- Tome of Town Portal
  [151652] = { ["type"] = "toy", ["hearthstone"] = false }, -- Wormhole Generator: Argus
  [162973] = { ["type"] = "toy", ["hearthstone"] = true }, -- Greatfather Winter's Hearthstone
  [163045] = { ["type"] = "toy", ["hearthstone"] = true }, -- Headless Horseman's Hearthstone
  [165669] = { ["type"] = "toy", ["hearthstone"] = true }, -- Lunar Elder's Hearthstone
  [165670] = { ["type"] = "toy", ["hearthstone"] = true }, -- Peddlefeet's Lovely Hearthstone
  [165802] = { ["type"] = "toy", ["hearthstone"] = true }, -- Noble Gardener's Hearthstone
  [166746] = { ["type"] = "toy", ["hearthstone"] = true }, -- Fire Eater's Hearthstone
  [166747] = { ["type"] = "toy", ["hearthstone"] = true }, -- Brewfest Reveler's Hearthstone
  [168807] = { ["type"] = "toy", ["hearthstone"] = false }, -- Wormhole Generator: Kul Tiras
  [168808] = { ["type"] = "toy", ["hearthstone"] = false }, -- Wormhole Generator: Zandalar
  [168907] = { ["type"] = "toy", ["hearthstone"] = true }, -- Holographic Digitalization Hearthstone
  [172179] = { ["type"] = "toy", ["hearthstone"] = true }, -- Eternal Traveler's Hearthstone
  [172924] = { ["type"] = "toy", ["hearthstone"] = false }, -- Wormhole Generator: Shadowlands
  [180290] = { ["type"] = "toy", ["hearthstone"] = true, ["covenant"] = "NightFae" }, -- Night Fae Hearthstone
  [180817] = { ["type"] = "toy", ["hearthstone"] = true }, -- Cypher of Relocation
  [182773] = { ["type"] = "toy", ["hearthstone"] = true, ["covenant"] = "Necrolord" }, -- Necrolord Hearthstone
  [183716] = { ["type"] = "toy", ["hearthstone"] = true, ["covenant"] = "Venthyr" }, -- Venthyr Sinstone
  [184353] = { ["type"] = "toy", ["hearthstone"] = true, ["covenant"] = "Kyrian" }, -- Kyrian Hearthstone
  [188952] = { ["type"] = "toy", ["hearthstone"] = true }, -- Dominated Hearthstone (The Jailer's Gauntlet: Layer 2)
  [190237] = { ["type"] = "toy", ["hearthstone"] = true }, -- Broker Translocation Matrix
  [193588] = { ["type"] = "toy", ["hearthstone"] = true }, -- Timewalker's Hearthstone (Dragonflight Epic Edition)
  [193753] = { ["type"] = "spell", ["hearthstone"] = false, ["class"] = "DRUID" }, -- Dreamwalk
  [312372] = { ["type"] = "spell", ["hearthstone"] = false }, -- Return to Camp (Vulpera Racial)
  [324547] = { ["type"] = "spell", ["hearthstone"] = false }, -- Hearth Kidneystone (Necrolord Soulbind)

  -- Dragonflight not yet verified
  [198156] = { ["type"] = "toy", ["hearthstone"] = false, ["load"] = TXUI.IsRetail }, -- Wyrmhole Generator
  [200630] = { ["type"] = "toy", ["hearthstone"] = true, ["load"] = TXUI.IsRetail }, -- Ohn'ir Windsage's Hearthstone

  -- Mage specific
  [193759] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Hall of the Guardian

  [344597] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Oribos
  [344587] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Oribos

  [10059] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Stormwind
  [3561] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Stormwind

  [11417] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Orgrimmar
  [3567] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Orgrimmar

  [281402] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Dazar'alor - Horde
  [281404] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Dazar'alor - Horde

  [281400] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Boralus - Alliance
  [281403] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Boralus - Alliance

  [176246] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Stormshield - Alliance
  [176248] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Stormshield - Alliance

  [176244] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Warspear - Horde
  [176242] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Warspear - Horde

  [224871] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Dalaran (Legion)
  [224869] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Dalaran (Legion)

  [132620] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Vale of Eternal Blossoms - Alliance
  [132621] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Vale of Eternal Blossoms - Alliance

  [132626] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Vale of Eternal Blossoms - Horde
  [132627] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Vale of Eternal Blossoms - Horde

  [120146] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Ancient Dalaran
  [120145] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Ancient Dalaran

  [53142] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Dalaran (Northrend)
  [53140] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Dalaran (Northrend)

  [33691] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Shattrath - Alliance
  [33690] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Shattrath - Alliance

  [35717] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Shattrath - Horde
  [35715] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Shattrath - Horde

  [49360] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Theramore - Alliance
  [49359] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Theramore - Alliance

  [49361] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Stonard - Horde
  [49358] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Stonard - Horde

  [11419] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Darnassus
  [3565] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Darnassus

  [11420] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Thunder Bluff
  [3566] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Thunder Bluff

  [11418] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Undercity
  [3563] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Undercity

  [11416] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Ironforge
  [3562] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Ironforge

  [32267] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Silvermoon
  [32272] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Silvermoon

  [32266] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Exodar
  [32271] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Exodar

  [395289] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Valdrakken
  [395277] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Valdrakken

  [88346] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Tol Barad - Horde
  [88344] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Tol Barad - Horde

  [88345] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Tol Barad - Alliance
  [88342] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Tol Barad - Alliance
}

I.HearthstoneData_Wrath = {
  [6948] = { ["type"] = "item", ["hearthstone"] = true }, -- Hearthstone
  [48933] = { ["type"] = "item", ["hearthstone"] = false }, -- Wormhole Generator: Northrend
  [54452] = { ["type"] = "item", ["hearthstone"] = true }, -- Ethereal Portal
  [184871] = { ["type"] = "item", ["hearthstone"] = true }, -- Dark Portal (TBC Deluxe Edition)

  -- Hearthstone: Death Knight
  [50977] = { ["type"] = "spell", ["hearthstone"] = false, ["class"] = "DEATHKNIGHT" }, -- Death Gate

  -- Hearthstone: Shaman
  [556] = { ["type"] = "spell", ["hearthstone"] = true, ["class"] = "SHAMAN" }, -- Astral Recall

  -- Hearthstone: Mage
  [10059] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Stormwind
  [3561] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Stormwind

  [11417] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Orgrimmar
  [3567] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Orgrimmar

  [53142] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Dalaran (Northrend)
  [53140] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Dalaran (Northrend)

  [33691] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Shattrath - Alliance
  [33690] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Shattrath - Alliance

  [35717] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Shattrath - Horde
  [35715] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Shattrath - Horde

  [49360] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Theramore - Alliance
  [49359] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Theramore - Alliance

  [49361] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Stonard - Horde
  [49358] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Stonard - Horde

  [11419] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Darnassus
  [3565] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Darnassus

  [11420] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Thunder Bluff
  [3566] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Thunder Bluff

  [11418] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Undercity
  [3563] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Undercity

  [11416] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Ironforge
  [3562] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Ironforge

  [32267] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Silvermoon
  [32272] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Silvermoon

  [32266] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Exodar
  [32271] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Exodar
}

I.HearthstoneData_Classic = {
  [6948] = { ["type"] = "item", ["hearthstone"] = true }, -- Hearthstone

  -- Hearthstone: Shaman
  [556] = { ["type"] = "spell", ["hearthstone"] = true, ["class"] = "SHAMAN" }, -- Astral Recall

  -- Hearthstone: Mage
  [10059] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Stormwind
  [3561] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Stormwind

  [11417] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Orgrimmar
  [3567] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Orgrimmar

  [11419] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Darnassus
  [3565] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Darnassus

  [11420] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Thunder Bluff
  [3566] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Thunder Bluff

  [11418] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Undercity
  [3563] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Undercity

  [11416] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Ironforge
  [3562] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Ironforge
}

-- Data for which class or spec has which interrupt spell
I.InterruptSpellMap = {
  { id = 1766, conditions = { class = "ROGUE", level = 6 } }, -- Rogue, Kick
  { id = 2139, conditions = { class = "MAGE", level = 7 } }, -- Mage, Counterspell
  { id = 6552, conditions = { class = "WARRIOR", level = 7 } }, -- Warr, Pummel
  { id = 15487, conditions = { specIds = { 258 } } }, -- Shadow Priest, Silence i kill u
  { id = 19647, conditions = { specIds = { 265, 267 }, level = 29 } }, -- Aff&Destro Lock, Spell Lock
  { id = 31935, conditions = { specIds = { 66 } } }, -- Prot Paladin, Avenger's Shield
  { id = 47528, conditions = { class = "DEATHKNIGHT" } }, -- DK, Mind Freeze
  { id = 57994, conditions = { class = "SHAMAN" } }, -- Sha, Wind Shear
  { id = 78675, conditions = { specIds = { 102 } } }, -- Balance Druid, Solar Beeeeeam
  { id = 89766, conditions = { specIds = { 266 }, level = 29 } }, -- Demo Lock, Axe Toss
  { id = 96231, conditions = { class = "PALADIN" } }, -- Paladin, Rebuke
  { id = 106839, conditions = { class = "DRUID" } }, -- Druid, Skull Bash
  { id = 116705, conditions = { class = "MONK" } }, -- Monk, Spear Hand Strike
  { id = 147362, conditions = { specIds = { 253, 254 } } }, -- BM/MM Hunter-Counter Shot
  { id = 183752, conditions = { class = "DEMONHUNTER", level = 20 } }, -- DH, Disrupt
  { id = 187707, conditions = { specIds = { 255 } } }, -- SV-lol Hunter Muzzle
  { id = 351338, conditions = { class = "EVOKER" } }, -- Evoker Quell
}

--[[
  Data for which class or spec has which interrupt spell. This is currently only used in Wrath and Classic,
  as the interrupt logic iirc doesn't work properly in Wrath and The API doesn't allow us to do it in the same way in Classic
]]

I.InterruptSpellMap_Empty = {}
