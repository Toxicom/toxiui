local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local LSM = E.Libs.LSM

-- Vars
local supportedBits = LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western
local allLocaleBits = LSM.LOCALE_BIT_zhCN + LSM.LOCALE_BIT_zhTW + LSM.LOCALE_BIT_koKR + supportedBits

-- -----
--   FONT - LSM
-- -----

F.AddMedia("font", "ToxiUIIcons.ttf", I.Fonts.Icons, nil, allLocaleBits)
F.AddMedia("font", "ToxiUI.ttf", I.Fonts.Primary, nil, supportedBits)
F.AddMedia("font", "BigNoodleToo.ttf", I.Fonts.Title, nil, supportedBits)
F.AddMedia("font", "Montserrat-Medium.ttf", "- M 500", nil, supportedBits)
F.AddMedia("font", "Montserrat-Bold.ttf", I.Fonts.TitleRaid, nil, supportedBits)
F.AddMedia("font", "Montserrat-Black.ttf", I.Fonts.TitleBlack, nil, supportedBits)

-- -----
--   STATUSBAR - LSM
-- -----

-- General Textures
F.AddMedia("texture", "BuiOnePixel", "BuiOnePixel", "statusbar")
F.AddMedia("texture", "ToxiUI-clean", "- ToxiUI", "statusbar")
F.AddMedia("texture", "ToxiUI-fade", "- Tx Fade", "statusbar")

-- Gradient Textures
F.AddMedia("texture", "ToxiUI-grad", "- Tx Mid", "statusbar")
F.AddMedia("texture", "ToxiUI-g1", "- Tx Left", "statusbar")
F.AddMedia("texture", "ToxiUI-g2", "- Tx Right", "statusbar")

-- Texture alternatives (not in use)
F.AddMedia("texture", "ToxiUI-half", "- Tx Half", "statusbar")
F.AddMedia("texture", "ToxiUI-half-transparent", "- Tx Half Fade", "statusbar")
F.AddMedia("texture", "ToxiUI-half-transparent-stroke", "- Tx Half Fade Stroke", "statusbar")
F.AddMedia("texture", "ToxiUI-dark", "- Tx Dark", "statusbar")
F.AddMedia("texture", "Bezo", "- Bezo", "statusbar")
F.AddMedia("texture", "Bezo-dark1", "- Bezo Dark", "statusbar")
F.AddMedia("texture", "Bezo-dark2", "- Bezo Darker", "statusbar")

-- Custom ones for WunderBar for example (no defaults)
F.AddMedia("texture", "TX-WorldState-Score", "TX WorldState Score", "statusbar")

-- -----
--   CHAT ICONS/BADGES
-- -----

F.AddMedia("chaticon", "Dev") -- Blue
F.AddMedia("chaticon", "Legendary") -- Orange
F.AddMedia("chaticon", "Epic") -- Purple
F.AddMedia("chaticon", "Rare") -- Green

-- -----
--   OPTION ICONS
-- -----

F.AddMedia("icon", "Armory")
F.AddMedia("icon", "Changelog")
F.AddMedia("icon", "Contacts")
F.AddMedia("icon", "Fonts")
F.AddMedia("icon", "General")
F.AddMedia("icon", "Misc")
F.AddMedia("icon", "Reset")
F.AddMedia("icon", "Skins")
F.AddMedia("icon", "Themes")
F.AddMedia("icon", "WunderBar")
F.AddMedia("icon", "Styles")
F.AddMedia("icon", "Performance")

-- -----
--   ROLE ICONS
-- -----

F.AddMedia("role", "NewDPS")
F.AddMedia("role", "NewSmallDPS")
F.AddMedia("role", "NewHeal")
F.AddMedia("role", "NewSmallHeal")
F.AddMedia("role", "NewTank")
F.AddMedia("role", "NewSmallTank")

F.AddMedia("role", "WhiteDPS")
F.AddMedia("role", "WhiteHeal")
F.AddMedia("role", "WhiteTank")

-- Material Icons
F.AddMedia("role", "MaterialTank")
F.AddMedia("role", "MaterialHeal")
F.AddMedia("role", "MaterialDPS")

-- Stylized Icons
F.AddMedia("role", "StylizedTank")
F.AddMedia("role", "StylizedHeal")
F.AddMedia("role", "StylizedDPS")

-- -----
--   STATE ICONS
-- -----

F.AddMedia("state", "WhiteDC")
F.AddMedia("state", "WhiteDead")

-- Material Icons
F.AddMedia("state", "MaterialDC")
F.AddMedia("state", "MaterialDead")
F.AddMedia("state", "MaterialAssist")
F.AddMedia("state", "MaterialLeader")
F.AddMedia("state", "MaterialLooter")
F.AddMedia("state", "MaterialMainAssist")
F.AddMedia("state", "MaterialMainTank")

-- Stylized Icons
F.AddMedia("state", "StylizedDC") -- icons8.com
F.AddMedia("state", "StylizedDead") -- icons8.com
F.AddMedia("state", "StylizedAssist") -- icons8.com
F.AddMedia("state", "StylizedLeader") -- icons8.com
F.AddMedia("state", "StylizedLooter") -- icons8.com
F.AddMedia("state", "StylizedMainAssist")
F.AddMedia("state", "StylizedMainTank")

-- Resting Icon
F.AddMedia("state", "Resting")

-- -----
--   THEME TEXTURES
-- -----

F.AddMedia("theme", "NoiseInner")
F.AddMedia("theme", "ShadowInner")
F.AddMedia("theme", "ShadowInnerSmall")

-- -----
--   LOGOS
-- -----

F.AddMedia("logo", "Discord")
F.AddMedia("logo", "Logo")
F.AddMedia("logo", "LogoSmall")
F.AddMedia("logo", "Youtube")

-- -----
--   INSTALLER IMAGES
-- -----

F.AddMedia("installer", "Layouts")
F.AddMedia("installer", "DetailsOne")
F.AddMedia("installer", "DetailsTwo")
F.AddMedia("installer", "PlaterNew")
F.AddMedia("installer", "PlaterOld")
F.AddMedia("installer", "BigWigs")
F.AddMedia("installer", "WeakAuras")
F.AddMedia("installer", "OmniCD")
F.AddMedia("installer", "WarpDeplete")
F.AddMedia("installer", "Vertical")
F.AddMedia("installer", "Horizontal")
F.AddMedia("installer", "DiscordBanner")
F.AddMedia("installer", "WAGuide")
F.AddMedia("installer", "WebPreview")

-- -----
--   STYLE THUBMNAILS
-- -----

F.AddMedia("style", "WeakAuras")
F.AddMedia("style", "Classic")
F.AddMedia("style", "New")
F.AddMedia("style", "Old")
F.AddMedia("style", "ClassIconsPreview")
F.AddMedia("style", "SpecIconsPreview")

-- -----
--   ARMORY BACKGROUNDS
-- -----

F.AddMedia("armory", "BG1")
F.AddMedia("armory", "BG2")
F.AddMedia("armory", "BG3")

-- Class Armory Backgrounds
F.AddMedia("armory", "ToxiUI-DEATHKNIGHT")
F.AddMedia("armory", "ToxiUI-DEMONHUNTER")
F.AddMedia("armory", "ToxiUI-DRUID")
F.AddMedia("armory", "ToxiUI-EVOKER")
F.AddMedia("armory", "ToxiUI-HUNTER")
F.AddMedia("armory", "ToxiUI-MAGE")
F.AddMedia("armory", "ToxiUI-MONK")
F.AddMedia("armory", "ToxiUI-PALADIN")
F.AddMedia("armory", "ToxiUI-PRIEST")
F.AddMedia("armory", "ToxiUI-ROGUE")
F.AddMedia("armory", "ToxiUI-SHAMAN")
F.AddMedia("armory", "ToxiUI-WARLOCK")
F.AddMedia("armory", "ToxiUI-WARRIOR")
