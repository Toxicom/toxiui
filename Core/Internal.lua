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

I.MaxLevelTable = {
  ["Retail"] = 90,
  ["Classic"] = 90,
  ["ClassicEra"] = 60,
  ["Anniversary"] = 70,
}

I.Fonts = {
  Primary = "- ToxiUI",
  Title = "- Big Noodle Titling", -- - Big Noodle Titling
  TitleBold = "- M 700", -- - Montserrat Bold
  TitleBlack = "- M 900", -- - Montserrat Black
  Icons = "- ToxiUI Icons",
}

I.Textures = {
  Primary = "KMT47",
}

I.FontNames = {
  [I.Fonts.Primary] = "Primary",
  [I.Fonts.Title] = "Title",
  [I.Fonts.TitleBold] = "Title Bold",
  [I.Fonts.TitleBlack] = "Title Black",
}

I.FontDescription = {
  [I.Fonts.Primary] = "Used in the majority of the UI.",
  [I.Fonts.Title] = "Used mostly for names.",
  [I.Fonts.TitleBold] = "Used for headers and titles, e.g. AFK screen, Game Menu, zone text, and Raid Frames group number.",
  [I.Fonts.TitleBlack] = "Very bold font used in a couple places, like map coordinates.",
}

I.FontOrder = {
  I.Fonts.Primary,
  I.Fonts.Title,
  I.Fonts.TitleBold,
  I.Fonts.TitleBlack,
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
  style = "Style",
  banner = "Banners",
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
  style = [[Interface\AddOns\ElvUI_ToxiUI\Media\Backgrounds\Styles\]],
  banner = [[Interface\AddOns\ElvUI_ToxiUI\Media\Banners\]],
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
  Style = {},
  Banners = {},
}

-- Profile names to be used
-- This only affects BigWigs
I.ProfileNames = {
  ["Default"] = "ToxiUI", -- Details
  [I.Enum.Layouts.VERTICAL] = "ToxiUI-Vertical", -- BigWigs
  [I.Enum.Layouts.HORIZONTAL] = "ToxiUI-Horizontal", -- BigWigs
  ["Dev"] = "ToxiUI-Dev",
}

I.Requirements = {
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
    I.Enum.Requirements.ELVUI_ACTIONBARS_ENABLED,
  },
  ["MiniMapCoords"] = {
    I.Enum.Requirements.SL_MINIMAP_COORDS_DISABLED,
  },
  ["FadePersist"] = {
    I.Enum.Requirements.OLD_FADE_PERSIST_DISABLED,
    I.Enum.Requirements.ELVUI_ACTIONBARS_ENABLED,
    I.Enum.Requirements.AB_BUDDY_DISABLED,
  },
  ["GameMenu"] = {},
  ["AdditionalScaling"] = {
    I.Enum.Requirements.ELTRUISM_DISABLED,
  },
  ["HideFrames"] = {},
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
    I.Enum.Requirements.CHARACTER_SKIN_ENABLED,
  },
  ["Deconstruct"] = {
    I.Enum.Requirements.SL_DECONSTRUCT_DISABLED,
    I.Enum.Requirements.ELVUI_BAGS_ENABLED,
  },
  ["ElvUITheme"] = {
    I.Enum.Requirements.OTHER_THEMES_DISABLED,
  },
  ["ColorModifiers"] = {
    I.Enum.Requirements.ELTRUISM_COLOR_MODIFIERS_DISABLED,
  },
  ["RaidInfoFrame"] = {},
  ["Animations"] = {},
  ["CooldownManager"] = {
    I.Enum.Requirements.BETTER_COOLDOWN_MANAGER_DISABLED,
    I.Enum.Requirements.COOLDOWN_MANAGER_CENTERED_DISABLED,
    I.Enum.Requirements.ARCUI_DISABLED,
  },
  ["DamageMeter"] = {
    I.Enum.Requirements.DETAILS_ADDON_DISABLED,
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
    -- Horizontal layout specific settings
    [I.Enum.Layouts.HORIZONTAL] = {
      -- Left Horizontal Gradient
      ["Left"] = {
        ["player"] = true,
        ["pet"] = true,
        ["tank"] = true,
        ["tanktarget"] = true,
        ["assist"] = true,
        ["assisttarget"] = true,
      },

      -- Right Horizontal Gradient
      ["Right"] = {
        ["target"] = true,
        ["targettarget"] = true,
        ["arena"] = true,
        ["boss"] = true,
        ["focus"] = true,
      },
    },

    -- Vertical layout specific settings
    [I.Enum.Layouts.VERTICAL] = {
      -- Left Vertical Gradient
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

      -- Right Vertical Gradient
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
      ["raid1"] = {
        TANK = "WhiteTank",
        HEALER = "WhiteHeal",
        DAMAGER = "WhiteDPS",
      },
      ["raid2"] = {
        TANK = "WhiteTank",
        HEALER = "WhiteHeal",
        DAMAGER = "WhiteDPS",
      },
      ["raid3"] = {
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

  ["Assist"] = {
    ["TXUI_STYLIZED"] = "StylizedAssist",
    ["TXUI_MATERIAL"] = "MaterialAssist",
    ["BLIZZARD"] = "Interface\\GroupFrame\\UI-Group-AssistantIcon",
  },

  ["Leader"] = {
    ["TXUI_MATERIAL"] = "MaterialLeader",
    ["TXUI_STYLIZED"] = "StylizedLeader",
    ["BLIZZARD"] = "Interface\\GroupFrame\\UI-Group-LeaderIcon",
  },

  ["Looter"] = {
    ["TXUI_MATERIAL"] = "MaterialLooter",
    ["TXUI_STYLIZED"] = "StylizedLooter",
    ["BLIZZARD"] = "Interface\\GroupFrame\\UI-Group-MasterLooter",
  },

  ["MainAssist"] = {
    ["TXUI_MATERIAL"] = "MaterialMainAssist",
    ["TXUI_STYLIZED"] = "StylizedMainAssist",
    ["BLIZZARD"] = "Interface\\GroupFrame\\UI-Group-MainAssistIcon",
  },

  ["MainTank"] = {
    ["TXUI_MATERIAL"] = "MaterialMainTank",
    ["TXUI_STYLIZED"] = "StylizedMainTank",
    ["BLIZZARD"] = "Interface\\GroupFrame\\UI-Group-MainTankIcon",
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

-- Mount ID, not Spell ID
-- Can find Mount ID on Wowhead, or use E.MountIDs[spellID]
I.RepairMounts = {
  2237, -- Grizzly Hills Packmaster
  460, -- Grand Expedition Yak
  284, -- Traveler's Tundra Mammoth (Horde)
  280, -- Traveler's Tundra Mammoth (Alliance)
  1039, -- Mighty Caravan Brutosaur
  2265, -- Trader’s Gilded Brutosaur
}

-- Holds all data important to use, and will be filled with the below entries when GameBar is loaded
-- type, name, known [known is always true for items]
I.HearthstoneDataLoaded = false
I.HearthstoneData = {
  -- Standard Items --
  [6948] = { ["type"] = "item", ["hearthstone"] = true }, -- Hearthstone
  [110560] = { ["type"] = "toy", ["hearthstone"] = false, ["label"] = "GARR" }, -- Garrison Hearthstone
  [140192] = { ["type"] = "toy", ["hearthstone"] = false, ["label"] = "DALA" }, -- Dalaran Hearthstone
  [141605] = { ["type"] = "item", ["hearthstone"] = false, ["label"] = "FMW" }, -- Flight Master's Whistle

  -- Class Teleports --
  [556] = { ["type"] = "spell", ["hearthstone"] = true, ["class"] = "SHAMAN" }, -- Astral Recall
  [18960] = { ["type"] = "spell", ["hearthstone"] = false, ["class"] = "DRUID" }, -- Teleport: Moonglade
  [50977] = { ["type"] = "spell", ["hearthstone"] = false, ["class"] = "DEATHKNIGHT" }, -- Death Gate
  [126892] = { ["type"] = "spell", ["hearthstone"] = false, ["class"] = "MONK" }, -- Zen Pligrimage
  [193753] = { ["type"] = "spell", ["hearthstone"] = false, ["class"] = "DRUID" }, -- Dreamwalk

  -- Racial Teleports/Items --
  [168862] = { ["type"] = "item", ["hearthstone"] = false, ["label"] = "FMW" }, -- G.E.A.R. Tracking Beacon
  [265225] = { ["type"] = "spell", ["hearthstone"] = false, ["label"] = "MOLE" }, -- Mole Machine
  [312372] = { ["type"] = "spell", ["hearthstone"] = false, ["label"] = "CAMP" }, -- Return to Camp
  [1238686] = { ["type"] = "spell", ["hearthstone"] = false, ["label"] = "ROOT" }, -- Rootwalking

  -- Alternate Hearthstones --
  [54452] = { ["type"] = "toy", ["hearthstone"] = true }, -- Ethereal Portal
  [64488] = { ["type"] = "toy", ["hearthstone"] = true }, -- The Innkeeper's Daughter
  [93672] = { ["type"] = "toy", ["hearthstone"] = true }, -- Dark Portal (Retail)
  [142542] = { ["type"] = "toy", ["hearthstone"] = true }, -- Tome of Town Portal
  [162973] = { ["type"] = "toy", ["hearthstone"] = true }, -- Greatfather Winter's Hearthstone
  [163045] = { ["type"] = "toy", ["hearthstone"] = true }, -- Headless Horseman's Hearthstone
  [165669] = { ["type"] = "toy", ["hearthstone"] = true }, -- Lunar Elder's Hearthstone
  [165670] = { ["type"] = "toy", ["hearthstone"] = true }, -- Peddlefeet's Lovely Hearthstone
  [165802] = { ["type"] = "toy", ["hearthstone"] = true }, -- Noble Gardener's Hearthstone
  [166746] = { ["type"] = "toy", ["hearthstone"] = true }, -- Fire Eater's Hearthstone
  [166747] = { ["type"] = "toy", ["hearthstone"] = true }, -- Brewfest Reveler's Hearthstone
  [168907] = { ["type"] = "toy", ["hearthstone"] = true }, -- Holographic Digitalization Hearthstone
  [172179] = { ["type"] = "toy", ["hearthstone"] = true }, -- Eternal Traveler's Hearthstone
  [180290] = { ["type"] = "toy", ["hearthstone"] = true, ["covenant"] = true }, -- Night Fae Hearthstone
  [182773] = { ["type"] = "toy", ["hearthstone"] = true, ["covenant"] = true }, -- Necrolord Hearthstone
  [183716] = { ["type"] = "toy", ["hearthstone"] = true, ["covenant"] = true }, -- Venthyr Sinstone
  [184353] = { ["type"] = "toy", ["hearthstone"] = true, ["covenant"] = true }, -- Kyrian Hearthstone
  [188952] = { ["type"] = "toy", ["hearthstone"] = true }, -- Dominated Hearthstone
  [190237] = { ["type"] = "toy", ["hearthstone"] = true }, -- Broker Translocation Matrix
  [193588] = { ["type"] = "toy", ["hearthstone"] = true }, -- Timewalker's Hearthstone
  [200630] = { ["type"] = "toy", ["hearthstone"] = true }, -- Ohn'ir Windsage's Hearthstone
  [206195] = { ["type"] = "toy", ["hearthstone"] = true }, -- Path of the Naaru
  [208704] = { ["type"] = "toy", ["hearthstone"] = true }, -- Deepdweller's Earthen Hearthstone
  [209035] = { ["type"] = "toy", ["hearthstone"] = true }, -- Hearthstone of the Flame
  [190196] = { ["type"] = "toy", ["hearthstone"] = true }, -- Enlightened Hearthstone
  [212337] = { ["type"] = "toy", ["hearthstone"] = true }, -- Stone of the Hearth
  [228940] = { ["type"] = "toy", ["hearthstone"] = true }, -- Notorious Thread's Hearthstone
  [236687] = { ["type"] = "toy", ["hearthstone"] = true }, -- Explosive Hearthstone
  [246565] = { ["type"] = "toy", ["hearthstone"] = true }, -- Cosmic Hearthstone
  [245970] = { ["type"] = "toy", ["hearthstone"] = true }, -- P.O.S.T. Master's Express Hearthstone
  [263489] = { ["type"] = "toy", ["hearthstone"] = true }, -- Naaru's Enfold
  [235016] = { ["type"] = "toy", ["hearthstone"] = true }, -- Redeployment Module

  -- Engineering Items/Toys --
  [18984] = { ["type"] = "toy", ["hearthstone"] = false, ["label"] = "EVR" }, -- Dimensional Ripper - Everlook
  [18986] = { ["type"] = "toy", ["hearthstone"] = false, ["label"] = "GAD" }, -- Ultrasafe Transporter: Gadgetzan
  [30542] = { ["type"] = "toy", ["hearthstone"] = false, ["label"] = "A52" }, -- Dimensional Ripper - Area 52
  [30544] = { ["type"] = "toy", ["hearthstone"] = false, ["label"] = "TOSH" }, -- Ultrasafe Transporter: Toshley's Station
  [48933] = { ["type"] = "toy", ["hearthstone"] = false, ["label"] = "WotLK" }, -- Wormhole Generator: Northrend
  [87215] = { ["type"] = "toy", ["hearthstone"] = false, ["label"] = "MOP" }, -- Wormhole Generator: Pandaria
  [112059] = { ["type"] = "toy", ["hearthstone"] = false, ["label"] = "WOD" }, -- Wormhole Centrifuge
  [132517] = { ["type"] = "item", ["hearthstone"] = false, ["label"] = "DALA" }, -- Intra-Dalaran Wormhole Generator
  [151652] = { ["type"] = "toy", ["hearthstone"] = false, ["label"] = "ARG" }, -- Wormhole Generator: Argus
  [168807] = { ["type"] = "toy", ["hearthstone"] = false, ["label"] = "KT" }, -- Wormhole Generator: Kul Tiras
  [168808] = { ["type"] = "toy", ["hearthstone"] = false, ["label"] = "ZAN" }, -- Wormhole Generator: Zandalar
  [172924] = { ["type"] = "toy", ["hearthstone"] = false, ["label"] = "SL" }, -- Wormhole Generator: Shadowlands
  [198156] = { ["type"] = "toy", ["hearthstone"] = false, ["label"] = "DF" }, -- Wyrmhole Generator: Dragon Isles
  [221966] = { ["type"] = "toy", ["hearthstone"] = false, ["label"] = "TWW" }, -- Wormhole Generator: Khaz Algar
  [248485] = { ["type"] = "toy", ["hearthstone"] = false, ["label"] = "MID" }, -- Wormhole Generator: Quel'Thalas

  -- Teleportation Equipment --
  [22589] = { ["type"] = "item", ["hearthstone"] = false, ["label"] = "KZ" }, -- Atiesh, Greatstaff of the Guardian
  [28585] = { ["type"] = "item", ["hearthstone"] = false, ["label"] = "HOME" }, -- Ruby Slippers
  [32757] = { ["type"] = "item", ["hearthstone"] = false, ["label"] = "KAR" }, -- Blessed Medallion of Karabor
  [44935] = { ["type"] = "item", ["hearthstone"] = false, ["label"] = "DALA" }, -- Ring of the Kirin Tor
  [45690] = { ["type"] = "item", ["hearthstone"] = false, ["label"] = "DALA" }, -- Inscribed Ring of the Kirin Tor
  [46874] = { ["type"] = "item", ["hearthstone"] = false, ["label"] = "ICC" }, -- Argent Crusader's Tabard
  [48956] = { ["type"] = "item", ["hearthstone"] = false, ["label"] = "DALA" }, -- Etched Ring of the Kirin Tor
  [51559] = { ["type"] = "item", ["hearthstone"] = false, ["label"] = "DALA" }, -- Runed of the Kirin Tor
  [50287] = { ["type"] = "item", ["hearthstone"] = false, ["label"] = "BOTY" }, -- Boots of the Bay
  [63206] = { ["type"] = "item", ["hearthstone"] = false, ["label"] = "SW" }, -- Wrap of Unity (Alliance)
  [63207] = { ["type"] = "item", ["hearthstone"] = false, ["label"] = "ORG" }, -- Wrap of Unity (Horde)
  [63352] = { ["type"] = "item", ["hearthstone"] = false, ["label"] = "SW" }, -- Shroud of Cooperation (Alliance)
  [63353] = { ["type"] = "item", ["hearthstone"] = false, ["label"] = "ORG" }, -- Shroud of Cooperation (Horde)
  [63378] = { ["type"] = "item", ["hearthstone"] = false, ["label"] = "TBR" }, -- Hellscream's Reach Tabard
  [63379] = { ["type"] = "item", ["hearthstone"] = false, ["label"] = "TBR" }, -- Baradin's Wardens Tabard
  [65274] = { ["type"] = "item", ["hearthstone"] = false, ["label"] = "ORG" }, -- Cloak of Coordination (Horde)
  [65360] = { ["type"] = "item", ["hearthstone"] = false, ["label"] = "SW" }, -- Cloak of Coordination (Alliance)
  [139599] = { ["type"] = "item", ["hearthstone"] = false, ["label"] = "DALA" }, -- Empowered Ring of the Kirin Tor
  [142469] = { ["type"] = "item", ["hearthstone"] = false, ["label"] = "KZ" }, -- Violet Seal of the Grand Magus
  [144391] = { ["type"] = "item", ["hearthstone"] = false, ["label"] = "BRAWL" }, -- Pugilist's Powerful Punching Ring (Alliance)
  [144392] = { ["type"] = "item", ["hearthstone"] = false, ["label"] = "BRAWL" }, -- Pugilist's Powerful Punching Ring (Horde)
  [166559] = { ["type"] = "item", ["hearthstone"] = false, ["label"] = "DAZ" }, -- Commander's Signet of Battle
  [166560] = { ["type"] = "item", ["hearthstone"] = false, ["label"] = "BOR" }, -- Captain's Signet of Command
  [193000] = { ["type"] = "item", ["hearthstone"] = false, ["label"] = "RAND" }, -- Ring-Bound Hourglass
  [243056] = { ["type"] = "toy", ["hearthstone"] = false, ["label"] = "DORN" }, -- Delver's Mana-Bound Ethergate
  [230850] = { ["type"] = "toy", ["hearthstone"] = false, ["label"] = "DLVE" }, -- Delve-O-Bot 7001
  [205255] = { ["type"] = "toy", ["hearthstone"] = false, ["label"] = "ZARL" }, -- Niffen Diggin' Mitts
  [253629] = { ["type"] = "toy", ["hearthstone"] = false, ["label"] = "ARC" }, -- Personal Key to the Arcantina

  --                   --
  -- Mythic+ Teleports --
  --                   --
  -- Wrath of the Lich King
  [1254555] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "mid1", ["label"] = "POS" }, -- Pit of Saron
  -- Cataclysm
  [410080] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "df2", ["label"] = "VP" }, -- The Vortex Pinnacle
  [424142] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "df3", ["label"] = "TotT" }, -- Throne of the Tides
  [445424] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "tww1", ["label"] = "GB" }, -- Grim Batol

  -- Mists of Pandaria --
  [131204] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "df1", ["label"] = "TJS" }, -- Temple of the Jade Serpent
  [131205] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "mop", ["label"] = "SB" }, -- Stormstout Brewery
  [131206] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "mop", ["label"] = "SPM" }, -- Shado-Pan Monastery
  [131222] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "mop", ["label"] = "MSP" }, -- Mogu'shan Palace
  [131225] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "mop", ["label"] = "GSS" }, -- Gate of the Setting Sun
  [131228] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "mop", ["label"] = "SON" }, -- Siege of Niuzao
  [131229] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "mop", ["label"] = "SM" }, -- Scarlet Monastery
  [131231] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "mop", ["label"] = "SH" }, -- Scarlet Halls
  [131232] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "mop", ["label"] = "SCH" }, -- Scholomance

  -- Warlords of Draenor
  [159895] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "wod", ["label"] = "BSM" }, -- Bloodmaul Slag Mines
  [159896] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "wod", ["label"] = "ID" }, -- Iron Docks
  [159897] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "wod", ["label"] = "AUCH" }, -- Auchindoun
  [159898] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "wod", ["label"] = "SKY" }, -- Skyreach
  [159899] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "df1", ["label"] = "SBG" }, -- Shadowmoon Burial Grounds
  [159900] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "sl4", ["label"] = "GD" }, -- Grimrail Depot
  [159901] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "df3", ["label"] = "EB" }, -- The Everbloom
  [159902] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "wod", ["label"] = "UBS" }, -- Upper Blackrock Spire
  [1254557] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "mid1", ["label"] = "SKY" }, -- Skyreach

  -- Legion
  [410078] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "df", ["label"] = "NL" }, -- Neltharion's Lair
  [424153] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "df3", ["label"] = "BRH" }, -- Black Rook Hold
  [424163] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "df3", ["label"] = "DHT" }, -- Darkheart Thicket
  [393764] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "df", ["label"] = "HOV" }, -- Halls of Valor
  [393766] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "df", ["label"] = "COS" }, -- Court of Stars
  [1254551] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "mid1", ["label"] = "SotV" }, -- Seat of the Triumvirate

  -- Battle for Azeroth
  [424167] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "df3", ["label"] = "WM" }, -- Waycrest Manor
  [424187] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "df3", ["label"] = "AD" }, -- Atal'Dazar
  [410074] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "df", ["label"] = "UNDR" }, -- Underrot
  [410071] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "df", ["label"] = "FH" }, -- Freehold
  [467555] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "tww2", ["label"] = "ML" }, -- The MOTHERLODE!!
  [467553] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "tww2", ["label"] = "ML" }, -- The MOTHERLODE!!
  -- One for Horde and one for Alliance
  [464256] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "tww1", ["label"] = "SIEGE" }, -- Siege of Boralus
  [445418] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "tww1", ["label"] = "SIEGE" }, -- Siege of Boralus

  -- Shadowlands
  [354462] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "tww1", ["label"] = "NW" }, -- Necrotic Wake
  [354463] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "sl", ["label"] = "PF" }, -- Plaguefall
  [354464] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "tww1", ["label"] = "MISTS" }, -- Mists of Tirna Scithe
  [354465] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "tww3", ["label"] = "HOA" }, -- Halls of Atonement
  [354466] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "sl", ["label"] = "SOA" }, -- Spires of Ascension
  [354467] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "tww2", ["label"] = "TOP" }, -- Theater of Pain
  [354468] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "sl", ["label"] = "DOS" }, -- De Other Side
  [354469] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "sl", ["label"] = "SD" }, -- Sanguine Depths
  [367416] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "tww3", ["label"] = "TVM" }, -- Tazavesh, the Veiled Market
  [373190] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "sl", ["label"] = "CN" }, -- Castle Nathria
  [373191] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "sl", ["label"] = "SOD" }, -- Sanctum of Domination
  [373192] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "sl", ["label"] = "SotFO" }, -- Sepulcher of the First Ones
  [373262] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "sl", ["label"] = "KZ" }, -- Karazhan
  [373274] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "tww2", ["label"] = "WORK" }, -- Mechagon

  -- Dragonflight
  [393222] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "df4", ["label"] = "ULD" }, -- Uldaman: Legacy of Tyr
  [393256] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "df4", ["label"] = "RLP" }, -- Ruby Life Pools
  [393262] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "df4", ["label"] = "NO" }, -- Nokhud Offensive
  [393267] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "df4", ["label"] = "BH" }, -- Brackenhide Hollow
  [393273] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "mid1", ["label"] = "AA" }, -- Algeth'ar Academy
  [393276] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "df4", ["label"] = "NELT" }, -- Neltharus
  [393279] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "df4", ["label"] = "AV" }, -- Azure Vault
  [393283] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "df4", ["label"] = "HOI" }, -- Halls of Infusion
  [424197] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "df3", ["label"] = "DOI" }, -- Dawn of the Infinite

  -- The War Within
  [445417] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "tww3", ["label"] = "ARAK" }, -- Ara-Kara, City of Echoes
  [445416] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "tww1", ["label"] = "COT" }, -- City of Threads
  [445414] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "tww3", ["label"] = "DAWN" }, -- The Dawnbreaker
  [445443] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "tww2", ["label"] = "ROOK" }, -- The Rookery
  [445269] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "tww1", ["label"] = "SV" }, -- The Stonevault
  [445440] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "tww2", ["label"] = "BREW" }, -- Cinderbrew Meadery
  [467546] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "tww2", ["label"] = "BREW" }, -- Cinderbrew Meadery
  [445441] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "tww2", ["label"] = "DFC" }, -- Darkflame Cleft
  [445444] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "tww3", ["label"] = "PSF" }, -- Priory of the Sacred Flame
  [1216786] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "tww3", ["label"] = "FLOOD" }, -- Operation: Floodgate
  [1237215] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "tww3", ["label"] = "EDA" }, -- Eco-Dome Al'dani

  -- Midnight
  [1254572] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "mid1", ["label"] = "MT" }, -- Magisters' Terrace
  [1254400] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "mid1", ["label"] = "WS" }, -- Windrunner Spire
  [1254563] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "mid1", ["label"] = "NPX" }, -- Nexus-Point Xenas
  [1254559] = { ["type"] = "spell", ["hearthstone"] = false, ["mythic"] = true, ["season"] = "mid1", ["label"] = "MC" }, -- Maisara Caverns

  --                --
  -- Raid Teleports --
  --                --
  -- Dragonflight
  [432254] = { ["type"] = "spell", ["hearthstone"] = false, ["raid"] = true, ["expansion"] = "df", ["label"] = "VotI" }, -- Vault of the Incarnates
  [432257] = { ["type"] = "spell", ["hearthstone"] = false, ["raid"] = true, ["expansion"] = "df", ["label"] = "ABER" }, -- Aberrus, the Shadowed Crucible
  [432258] = { ["type"] = "spell", ["hearthstone"] = false, ["raid"] = true, ["expansion"] = "df", ["label"] = "AMIR" }, -- Amirdrassil, the Dream's Hope
  -- The War Within
  [1226482] = { ["type"] = "spell", ["hearthstone"] = false, ["raid"] = true, ["expansion"] = "tww", ["label"] = "UNDER" }, -- Liberation of Undermine
  [1239155] = { ["type"] = "spell", ["hearthstone"] = false, ["raid"] = true, ["expansion"] = "tww", ["label"] = "MANA" }, -- Manaforge Omega

  --                --
  -- Mage Teleports --
  --                --
  [3561] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, ["label"] = "SW" }, -- Teleport: Stormwind
  [3567] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, ["label"] = "ORG" }, -- Teleport: Orgrimmar
  [3562] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, ["label"] = "IF" }, -- Teleport: Ironforge
  [3563] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, ["label"] = "UC" }, -- Teleport: Undercity
  [3565] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, ["label"] = "DARN" }, -- Teleport: Darnassus
  [3566] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, ["label"] = "TB" }, -- Teleport: Thunder Bluff
  [32271] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, ["label"] = "EXO" }, -- Teleport: Exodar
  [32272] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, ["label"] = "SM" }, -- Teleport: Silvermoon
  [33690] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, ["label"] = "TBC" }, -- Teleport: Shattrath (Alliance)
  [35715] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, ["label"] = "TBC" }, -- Teleport: Shattrath (Horde)
  [49359] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, ["label"] = "THER" }, -- Teleport: Theramore
  [49358] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, ["label"] = "STON" }, -- Teleport: Stonard
  [53140] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, ["label"] = "WotLK" }, -- Teleport: Dalaran - Northrend
  [88342] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, ["label"] = "CATA" }, -- Teleport: Tol Barad (Alliance)
  [88344] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, ["label"] = "CATA" }, -- Teleport: Tol Barad (Horde)
  [120145] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, ["label"] = "DALA" }, -- Ancient Teleport: Dalaran
  [132621] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, ["label"] = "MOP" }, -- Teleport: Vale of Eternal Blossoms (Alliance)
  [132627] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, ["label"] = "MOP" }, -- Teleport: Vale of Eternal Blossoms (Horde)
  [176242] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, ["label"] = "WOD" }, -- Teleport: Warspear
  [176248] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, ["label"] = "WOD" }, -- Teleport: Stormshield
  [193759] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, ["label"] = "HALL" }, -- Teleport: Hall of the Guardian
  [224869] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, ["label"] = "DALA" }, -- Teleport: Dalaran - Broken Isles
  [281403] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, ["label"] = "BFA" }, -- Teleport: Boralus
  [281404] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, ["label"] = "BFA" }, -- Teleport: Dazar'alor
  [344587] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, ["label"] = "SL" }, -- Teleport: Oribos
  [395277] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, ["label"] = "DF" }, -- Teleport: Valdrakken
  [446540] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, ["label"] = "TWW" }, -- Teleport: Dornogal
  [1259190] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, ["label"] = "MID" }, -- Teleport: Silvermoon City (Midnight)

  -- Mage Portals --
  [10059] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, ["label"] = "SW" }, -- Portal: Stormwind
  [11417] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, ["label"] = "ORG" }, -- Portal: Orgrimmar
  [11416] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, ["label"] = "IF" }, -- Portal: Ironforge
  [11418] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, ["label"] = "UC" }, -- Portal: Undercity
  [11419] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, ["label"] = "DARN" }, -- Portal: Darnassus
  [11420] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, ["label"] = "TB" }, -- Portal: Thunder Bluff
  [32266] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, ["label"] = "EXO" }, -- Portal: Exodar
  [32267] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, ["label"] = "SM" }, -- Portal: Silvermoon
  [33691] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, ["label"] = "TBC" }, -- Portal: Shattrath (Alliance)
  [35717] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, ["label"] = "TBC" }, -- Portal: Shattrath (Horde)
  [49360] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, ["label"] = "THER" }, -- Portal: Theramore
  [49361] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, ["label"] = "STON" }, -- Portal: Stonard
  [53142] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, ["label"] = "WotLK" }, -- Portal: Dalaran - Northrend
  [88345] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, ["label"] = "CATA" }, -- Portal: Tol Barad (Alliance)
  [88346] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, ["label"] = "CATA" }, -- Portal: Tol Barad (Horde)
  [120146] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, ["label"] = "DALA" }, -- Ancient Portal: Dalaran
  [132620] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, ["label"] = "MOP" }, -- Portal: Vale of Eternal Blossoms (Alliance)
  [132626] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, ["label"] = "MOP" }, -- Portal: Vale of Eternal Blossoms (Horde)
  [176244] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, ["label"] = "WOD" }, -- Portal: Warspear
  [176246] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, ["label"] = "WOD" }, -- Portal: Stormshield
  [224871] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, ["label"] = "DALA" }, -- Portal: Dalaran - Broken Isles
  [281400] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, ["label"] = "BFA" }, -- Portal: Boralus
  [281402] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, ["label"] = "BFA" }, -- Portal: Dazar'alor
  [344597] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, ["label"] = "SL" }, -- Portal: Oribos
  [395289] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, ["label"] = "DF" }, -- Portal: Valdrakken
  [446534] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, ["label"] = "TWW" }, -- Portal: Dornogal
  [1259194] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, ["label"] = "MID" }, -- Portal: Silvermoon City (Midnight)

  -- Other Teleportation Items/Spells --
  [37863] = { ["type"] = "item", ["hearthstone"] = false, ["label"] = "BRD" }, -- Direbrew's Remote
  [43824] = { ["type"] = "toy", ["hearthstone"] = false, ["label"] = "DALA" }, -- The Schools of Arcane Magic - Mastery
  [52251] = { ["type"] = "item", ["hearthstone"] = false, ["label"] = "DALA" }, -- Jaina's Locket
  [58487] = { ["type"] = "item", ["hearthstone"] = false, ["label"] = "DHLM" }, -- Potion of Deepholm
  [64457] = { ["type"] = "item", ["hearthstone"] = false, ["label"] = "RAND" }, -- The Last Relic of Argus
  [95567] = { ["type"] = "toy", ["hearthstone"] = false, ["label"] = "IOT" }, -- Kirin Tor Beacon
  [95568] = { ["type"] = "toy", ["hearthstone"] = false, ["label"] = "IOT" }, -- Sunreaver Beacon
  [103678] = { ["type"] = "item", ["hearthstone"] = false, ["label"] = "TIML" }, -- Time-Lost Artifact
  [118662] = { ["type"] = "item", ["hearthstone"] = false, ["label"] = "BLAD" }, -- Bladespire Relic
  [118663] = { ["type"] = "item", ["hearthstone"] = false, ["label"] = "KAR" }, -- Relic of Karabor
  [128353] = { ["type"] = "item", ["hearthstone"] = false, ["label"] = "SHIP" }, -- Admiral's Compass
  [129276] = { ["type"] = "item", ["hearthstone"] = false, ["label"] = "AZ" }, -- Beginner's Guide to Dimensional Rifting
  [129929] = { ["type"] = "item", ["hearthstone"] = false, ["label"] = "SHFT" }, -- Ever-Shifting Mirror
  [140324] = { ["type"] = "toy", ["hearthstone"] = false, ["label"] = "SUR" }, -- Mobile Telemancy Beacon
  [140493] = { ["type"] = "item", ["hearthstone"] = false, ["label"] = "BI" }, -- Adepts's Guide to Dimensional Rifting
  [167075] = { ["type"] = "item", ["hearthstone"] = false, ["label"] = "MECH" }, -- Ultrasafe Transporter: Mechagon
  [211788] = { ["type"] = "toy", ["hearthstone"] = false, ["label"] = "GIL" }, -- Tess's Peacebloom
  [324547] = { ["type"] = "spell", ["hearthstone"] = false, ["label"] = "NECR" }, -- Hearth Kidneystone
}

I.HearthstoneData_Classic = {
  [6948] = { ["type"] = "item", ["hearthstone"] = true }, -- Hearthstone
  [48933] = { ["type"] = "toy", ["hearthstone"] = false }, -- Wormhole Generator: Northrend
  [54452] = { ["type"] = "item", ["hearthstone"] = true }, -- Ethereal Portal
  [184871] = { ["type"] = "toy", ["hearthstone"] = true }, -- Dark Portal (TBC Deluxe Edition)
  [64488] = { ["type"] = "toy", ["hearthstone"] = true }, -- The Innkeeper's Daughter
  [52251] = { ["type"] = "item", ["hearthstone"] = false }, -- Jaina's Locket

  -- Hearthstone: Death Knight
  [50977] = { ["type"] = "spell", ["hearthstone"] = false, ["class"] = "DEATHKNIGHT" }, -- Death Gate

  -- Hearthstone: Druid
  [18960] = { ["type"] = "spell", ["hearthstone"] = false, ["class"] = "DRUID" }, -- Teleport: Moonglade

  -- Hearthstone: Shaman
  [556] = { ["type"] = "spell", ["hearthstone"] = true, ["class"] = "SHAMAN" }, -- Astral Recall

  -- Hearthstone: Mage
  [10059] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, ["label"] = "SW" }, -- Portal: Stormwind
  [3561] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, ["label"] = "SW" }, -- Teleport: Stormwind

  [11417] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, label = "ORG" }, -- Portal: Orgrimmar
  [3567] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, label = "ORG" }, -- Teleport: Orgrimmar

  [53142] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, label = "WotLK" }, -- Portal: Dalaran (Northrend)
  [53140] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, label = "WotLK" }, -- Teleport: Dalaran (Northrend)

  [33691] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, label = "TBC" }, -- Portal: Shattrath - Alliance
  [33690] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, label = "TBC" }, -- Teleport: Shattrath - Alliance

  [35717] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, label = "TBC" }, -- Portal: Shattrath - Horde
  [35715] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, label = "TBC" }, -- Teleport: Shattrath - Horde

  [49360] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, label = "THER" }, -- Portal: Theramore - Alliance
  [49359] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, label = "THER" }, -- Teleport: Theramore - Alliance

  [49361] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, label = "STON" }, -- Portal: Stonard - Horde
  [49358] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, label = "STON" }, -- Teleport: Stonard - Horde

  [11419] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, label = "DARN" }, -- Portal: Darnassus
  [3565] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, label = "DARN" }, -- Teleport: Darnassus

  [11420] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, label = "TB" }, -- Portal: Thunder Bluff
  [3566] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, label = "TB" }, -- Teleport: Thunder Bluff

  [11418] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, label = "UC" }, -- Portal: Undercity
  [3563] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, label = "UC" }, -- Teleport: Undercity

  [11416] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, label = "IF" }, -- Portal: Ironforge
  [3562] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, label = "IF" }, -- Teleport: Ironforge

  [32267] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, label = "SM" }, -- Portal: Silvermoon
  [32272] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, label = "SM" }, -- Teleport: Silvermoon

  [32266] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, label = "EXO" }, -- Portal: Exodar
  [32271] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, label = "EXO" }, -- Teleport: Exodar

  [132621] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, ["label"] = "MOP" }, -- Teleport: Vale of Eternal Blossoms (Alliance)
  [132627] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, ["label"] = "MOP" }, -- Teleport: Vale of Eternal Blossoms (Horde)
  [132620] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, ["label"] = "MOP" }, -- Portal: Vale of Eternal Blossoms (Alliance)
  [132626] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, ["label"] = "MOP" }, -- Portal: Vale of Eternal Blossoms (Horde)
}

I.HearthstoneData_ClassicEra = {
  [6948] = { ["type"] = "item", ["hearthstone"] = true }, -- Hearthstone

  -- Hearthstone: Druid
  [18960] = { ["type"] = "spell", ["hearthstone"] = false, ["class"] = "DRUID" }, -- Teleport: Moonglade

  -- Hearthstone: Shaman
  [556] = { ["type"] = "spell", ["hearthstone"] = true, ["class"] = "SHAMAN" }, -- Astral Recall

  -- Hearthstone: Mage
  [10059] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, label = "SW" }, -- Portal: Stormwind
  [3561] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, label = "SW" }, -- Teleport: Stormwind

  [11417] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, label = "ORG" }, -- Portal: Orgrimmar
  [3567] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, label = "ORG" }, -- Teleport: Orgrimmar

  [11419] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, label = "DARN" }, -- Portal: Darnassus
  [3565] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, label = "DARN" }, -- Teleport: Darnassus

  [11420] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, label = "TB" }, -- Portal: Thunder Bluff
  [3566] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, label = "TB" }, -- Teleport: Thunder Bluff

  [11418] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, label = "UC" }, -- Portal: Undercity
  [3563] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, label = "UC" }, -- Teleport: Undercity

  [11416] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, label = "IF" }, -- Portal: Ironforge
  [3562] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, label = "IF" }, -- Teleport: Ironforge
}

I.HearthstoneData_Anniversary = {
  [6948] = { ["type"] = "item", ["hearthstone"] = true }, -- Hearthstone
  [260221] = { ["type"] = "item", ["hearthstone"] = true }, -- Naaru's Embrace
  [184871] = { ["type"] = "item", ["hearthstone"] = true }, -- Dark Portal (TBC Deluxe Edition)

  -- Hearthstone: Druid
  [18960] = { ["type"] = "spell", ["hearthstone"] = false, ["class"] = "DRUID" }, -- Teleport: Moonglade

  -- Hearthstone: Shaman
  [556] = { ["type"] = "spell", ["hearthstone"] = true, ["class"] = "SHAMAN" }, -- Astral Recall

  -- Hearthstone: Mage
  [10059] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, label = "SW" }, -- Portal: Stormwind
  [3561] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, label = "SW" }, -- Teleport: Stormwind

  [11417] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, label = "ORG" }, -- Portal: Orgrimmar
  [3567] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, label = "ORG" }, -- Teleport: Orgrimmar

  [11419] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, label = "DARN" }, -- Portal: Darnassus
  [3565] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, label = "DARN" }, -- Teleport: Darnassus

  [11420] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, label = "TB" }, -- Portal: Thunder Bluff
  [3566] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, label = "TB" }, -- Teleport: Thunder Bluff

  [11418] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, label = "UC" }, -- Portal: Undercity
  [3563] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, label = "UC" }, -- Teleport: Undercity

  [11416] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, label = "IF" }, -- Portal: Ironforge
  [3562] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, label = "IF" }, -- Teleport: Ironforge

  -- TBC-specific portals/teleports
  [33691] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, label = "TBC" }, -- Portal: Shattrath - Alliance
  [33690] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, label = "TBC" }, -- Teleport: Shattrath - Alliance

  [35717] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, label = "TBC" }, -- Portal: Shattrath - Horde
  [35715] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, label = "TBC" }, -- Teleport: Shattrath - Horde

  [32267] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, label = "SM" }, -- Portal: Silvermoon
  [32272] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, label = "SM" }, -- Teleport: Silvermoon

  [32266] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, label = "EXO" }, -- Portal: Exodar
  [32271] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, label = "EXO" }, -- Teleport: Exodar

  [49360] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, label = "THER" }, -- Portal: Theramore - Alliance
  [49359] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, label = "THER" }, -- Teleport: Theramore - Alliance

  [49361] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true, label = "STON" }, -- Portal: Stonard - Horde
  [49358] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true, label = "STON" }, -- Teleport: Stonard - Horde
}
