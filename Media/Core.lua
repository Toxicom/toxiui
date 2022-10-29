local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local LSM = E.Libs.LSM

-- Vars
local westAndRUBits = LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western
local allLocaleBits = LSM.LOCALE_BIT_koKR + LSM.LOCALE_BIT_zhCN + LSM.LOCALE_BIT_zhTW + westAndRUBits

-- -----
--   FONT - LSM
-- -----

F.AddMedia("font", "ToxiIcons.ttf", I.Fonts.Icons, nil, allLocaleBits)
F.AddMedia("font", "BigNoodleToo.ttf", I.Fonts.Title, nil, westAndRUBits)
F.AddMedia("font", "Steelfish.ttf", I.Fonts.Number, nil, westAndRUBits)
F.AddMedia("font", "FuturaPTBook.otf", "- Futura", nil, westAndRUBits)
F.AddMedia("font", "Montserrat-Thin.ttf", "- M 100", nil, westAndRUBits)
F.AddMedia("font", "Montserrat-ExtraLight.ttf", "- M 200", nil, westAndRUBits)
F.AddMedia("font", "Montserrat-Light.ttf", "- M 300", nil, westAndRUBits)
F.AddMedia("font", "Montserrat-Regular.ttf", "- M 400", nil, westAndRUBits)
F.AddMedia("font", "Montserrat-Medium.ttf", I.Fonts.Primary, nil, westAndRUBits)
F.AddMedia("font", "Montserrat-SemiBold.ttf", I.Fonts.PrimaryBold, nil, westAndRUBits)
F.AddMedia("font", "Montserrat-Bold.ttf", "- M 700", nil, westAndRUBits)
F.AddMedia("font", "Montserrat-ExtraBold.ttf", "- M 800", nil, westAndRUBits)
F.AddMedia("font", "Montserrat-Black.ttf", I.Fonts.BigNumber, nil, westAndRUBits)

-- -----
--   STATUSBAR - LSM
-- -----

-- General Textures
F.AddMedia("texture", "BuiOnePixel", "BuiOnePixel", "statusbar")
F.AddMedia("texture", "ToxiUI-clean", "- ToxiUI", "statusbar")

-- Gradient Textures
F.AddMedia("texture", "ToxiUI-grad", "- Tx Mid", "statusbar")
F.AddMedia("texture", "ToxiUI-g1", "- Tx Left", "statusbar")
F.AddMedia("texture", "ToxiUI-g2", "- Tx Right", "statusbar")

-- Texture alternatives (not in use)
F.AddMedia("texture", "ToxiUI-half", "- ToxiUI Half", "statusbar")
F.AddMedia("texture", "ToxiUI-dark", "- ToxiUI Dark", "statusbar")
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

-- -----
--   STATE ICONS
-- -----

F.AddMedia("state", "WhiteDC")
F.AddMedia("state", "WhiteDead")

-- Material Icons
F.AddMedia("state", "MaterialDC")
F.AddMedia("state", "MaterialDead")

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
--   ARMORY BACKGROUNDS
-- -----

F.AddMedia("armory", "BG1")
F.AddMedia("armory", "BG2")
F.AddMedia("armory", "BG3")
F.AddMedia("armory", "BG4")
F.AddMedia("armory", "BG5")
F.AddMedia("armory", "BG6")
F.AddMedia("armory", "BG7")
F.AddMedia("armory", "BG8")
F.AddMedia("armory", "BG9")
