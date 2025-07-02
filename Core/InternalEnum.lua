local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

I.Enum = {}

-- IDs for layouts
I.Enum.Layouts = F.Enum { "VERTICAL", "HORIZONTAL" }

-- IDs for Layout Style
I.Enum.LayoutStyle = F.Enum { "OLD", "NEW" }

-- Internal and Option Dialog reasons for modules to be disabled
I.Enum.Requirements = F.Enum {
  "TOXIUI_PROFILE", -- Checked by default
  "SL_DISABLED",
  "DARK_MODE_ENABLED",
  "DARK_MODE_DISABLED",
  "GRADIENT_MODE_ENABLED",
  "GRADIENT_MODE_DISABLED",
  "DETAILS_NOT_SKINNED",
  "ELVUI_NOT_SKINNED",
  "SL_VEHICLE_BAR_DISABLED",
  "SL_MINIMAP_COORDS_DISABLED",
  "SL_DECONSTRUCT_DISABLED",
  "ARMORY_DISABLED",
  "WT_ENABLED",
  "OLD_FADE_PERSIST_DISABLED",
  "DETAILS_LOADED_AND_TXPROFILE",
  "ELVUI_BAGS_ENABLED",
  "DETAILS_NOT_SKINNED",
  "OTHER_THEMES_DISABLED",
  "ELVUI_ACTIONBARS_ENABLED",
  "ELTRUISM_COLOR_MODIFIERS_DISABLED",
  "CHARACTER_SKIN_ENABLED",
  "AB_BUDDY_DISABLED",
  "ELTRUISM_DISABLED",
}

-- Used for F.String.Color functions
I.Enum.Colors = F.Enum {
  "TXUI", -- AddOnColor
  "PLATER",
  "DETAILS",
  "BIGWIGS",
  "NSCT",
  "OMNICD",
  "WDP",
  "WT",
  "ELVUI", -- ElvUI Default Blue color
  "ELVUI_VALUE", -- Dynamic ElvUI Value Color
  "CLASS", -- Dynamic Class Color
  "GOOD", -- Bright Green
  "ERROR", -- Bright Red
  "INSTALLER_WARNING", -- Contrast Red
  "WARNING", -- Yelloish color
  "WHITE", -- White duh
  "LUXTHOS", -- Luxthos color

  "SILVER",
  "GOLD",

  "LEGENDARY",
  "EPIC",
  "RARE",
  "BETA",
}

-- Used for gradient theme
I.Enum.GradientMode = {
  Direction = F.Enum { "LEFT", "RIGHT" },
  Mode = F.Enum { "HORIZONTAL", "VERTICAL" },
  Color = F.Enum { "SHIFT", "NORMAL" },
}

-- Types for Chat Icons
I.Enum.ContributorType = F.Enum { "DEV", "LEGENDARY", "EPIC", "RARE", "BETA" }

-- Types of modes for deconstruct
I.Enum.DeconstructState = F.Enum { "NONE", "DISENCHANT", "PROSPECT", "MILL" }

-- Types for Icon Shape
I.Enum.IconShape = F.Enum { "SQUARE", "RECTANGLE" }

-- Types for changelogs
I.Enum.ChangelogType = F.Enum { "UPDATE", "HOTFIX" }

-- Developers
I.Enum.Developers = F.Enum { "TOXI", "RYADA", "RHAP", "JAKE" }

-- Client Flavors
I.Enum.Flavor = F.Enum { "VANILLA", "MISTS", "RETAIL" }
