local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local LAEV = TXUI:GetModule("Dev"):GetModule("Laev")

-- Looks like this file is not important ...
--@do-not-package@

function LAEV:SetupProfile()
  -- ToxiUI
  -- ToxiUI: AddOns
  E.db["TXUI"]["addons"]["afkMode"]["turnCamera"] = false
  E.db["TXUI"]["addons"]["elvUITheme"]["shadowSize"] = 2
  E.db["TXUI"]["addons"]["fadePersist"]["mode"] = "ELVUI"

  -- ToxiUI: Armory
  E.db["TXUI"]["armory"]["classTextFontSize"] = 18
  E.db["TXUI"]["armory"]["levelTextFontSize"] = 18
  E.db["TXUI"]["armory"]["stats"]["headerFontSize"] = 18
  E.db["TXUI"]["armory"]["stats"]["itemLevelFormat"] = "%.1f"
  E.db["TXUI"]["armory"]["stats"]["labelFontSize"] = 13
  E.db["TXUI"]["armory"]["stats"]["showAvgItemLevel"] = false
  E.db["TXUI"]["armory"]["stats"]["valueFontSize"] = 13

  -- ToxiUI: ElvUI Icons
  E.db["TXUI"]["elvUIIcons"]["deadIcons"]["theme"] = "TXUI_MATERIAL"
  E.db["TXUI"]["elvUIIcons"]["offlineIcons"]["theme"] = "TXUI_MATERIAL"
  E.db["TXUI"]["elvUIIcons"]["roleIcons"]["enabled"] = false
  E.db["TXUI"]["elvUIIcons"]["roleIcons"]["theme"] = "TXUI"

  -- ToxiUI: General
  E.db["TXUI"]["general"]["fontOverride"]["- Big Noodle Titling"] = "Arial Narrow"
  E.db["TXUI"]["general"]["fontOverride"]["- M 700"] = "Arial Narrow"
  E.db["TXUI"]["general"]["fontOverride"]["- M 900"] = "Arial Narrow"
  E.db["TXUI"]["general"]["fontOverride"]["- ToxiUI"] = "Arial Narrow"
  E.db["TXUI"]["general"]["fontShadowOverride"]["- Big Noodle Titling"] = false
  E.db["TXUI"]["general"]["fontShadowOverride"]["- M 700"] = false
  E.db["TXUI"]["general"]["fontShadowOverride"]["- M 900"] = false
  E.db["TXUI"]["general"]["fontShadowOverride"]["- ToxiUI"] = false
  E.db["TXUI"]["general"]["fontStyleOverride"]["- Big Noodle Titling"] = "OUTLINE"
  E.db["TXUI"]["general"]["fontStyleOverride"]["- M 700"] = "OUTLINE"
  E.db["TXUI"]["general"]["fontStyleOverride"]["- M 900"] = "OUTLINE"
  E.db["TXUI"]["general"]["fontStyleOverride"]["- ToxiUI"] = "OUTLINE"

  -- ToxiUI: Minimap Coords
  E.db["TXUI"]["miniMapCoords"]["enabled"] = false

  -- ToxiUI: Styles
  E.db["TXUI"]["styles"]["actionBars"] = "Classic"

  -- ToxiUI: Themes
  E.db["TXUI"]["themes"]["gradientMode"]["classColorMap"][1]["HUNTER"] = F.Table.HexToRGB("#516C2C")
  E.db["TXUI"]["themes"]["gradientMode"]["classColorMap"][2]["HUNTER"] = F.Table.HexToRGB("#B8FF55")

  -- ToxiUI: WunderBar
  E.db["TXUI"]["wunderbar"]["general"]["backgroundColor"] = "VALUE"
  E.db["TXUI"]["wunderbar"]["modules"]["LeftPanel"][3] = ""
  E.db["TXUI"]["wunderbar"]["modules"]["MiddlePanel"][1] = "Durability"
  E.db["TXUI"]["wunderbar"]["modules"]["MiddlePanel"][3] = "Currency"
  E.db["TXUI"]["wunderbar"]["modules"]["RightPanel"][1] = ""
  E.db["TXUI"]["wunderbar"]["subModules"]["Currency"]["showBagSpace"] = false
  E.db["TXUI"]["wunderbar"]["subModules"]["Durability"]["iconFontSize"] = 26
  E.db["TXUI"]["wunderbar"]["subModules"]["Durability"]["itemLevelShort"] = false
  E.db["TXUI"]["wunderbar"]["subModules"]["Hearthstone"]["iconFontSize"] = 24
  E.db["TXUI"]["wunderbar"]["subModules"]["Hearthstone"]["primaryHS"] = 208704
  E.db["TXUI"]["wunderbar"]["subModules"]["Hearthstone"]["secondaryHS"] = 140192
  E.db["TXUI"]["wunderbar"]["subModules"]["MicroMenu"]["icons"]["pvp"]["enabled"] = false
  E.db["TXUI"]["wunderbar"]["subModules"]["Time"]["infoTextDisplayed"]["ampm"] = false
  E.db["TXUI"]["wunderbar"]["subModules"]["Time"]["infoTextDisplayed"]["date"] = false
  E.db["TXUI"]["wunderbar"]["subModules"]["Time"]["infoTextDisplayed"]["mail"] = false

  -- ElvUI
  -- ElvUI: ActionBar
  local function configureActionBar(bar, settings)
    for key, value in pairs(settings) do
      E.db["actionbar"][bar][key] = value
    end
  end

  local commonSettings = {
    enabled = true,
    backdrop = false,
    buttons = 12,
    buttonHeight = 30,
    buttonSize = 38,
    countFont = "Arial Narrow",
    countFontOutline = "OUTLINE",
    countFontSize = 13,
    countTextPosition = "BOTTOMLEFT",
    hotkeyFont = "Arial Narrow",
    hotkeyFontOutline = "OUTLINE",
    hotkeyFontSize = 13,
    hotkeyTextYOffset = 0,
    keepSizeRatio = false,
    macroFont = "Arial Narrow",
    macroFontOutline = "OUTLINE",
    macroFontSize = 13,
    macroTextPosition = "BOTTOM",
    macroTextYOffset = 0,
    macrotext = false,
    point = "TOPLEFT",
  }

  -- Setting up bars with common settings
  configureActionBar("bar1", commonSettings)
  configureActionBar("bar3", commonSettings)
  configureActionBar("bar4", commonSettings)
  configureActionBar("bar5", commonSettings)
  configureActionBar("bar6", commonSettings)

  -- Adding unique settings for specific bars
  E.db["actionbar"]["bar3"]["mouseover"] = true

  E.db["actionbar"]["bar4"]["buttonsPerRow"] = 6
  E.db["actionbar"]["bar4"]["mouseover"] = true

  E.db["actionbar"]["bar5"]["buttonsPerRow"] = 12

  E.db["actionbar"]["stanceBar"]["enabled"] = false

  -- ElvUI: Bags
  E.db["bags"]["bagSize"] = 40
  E.db["bags"]["bagWidth"] = 568
  E.db["bags"]["bankSize"] = 40
  E.db["bags"]["bankWidth"] = 568

  E.db["bags"]["countFontSize"] = 14
  E.db["bags"]["itemInfoFontSize"] = 14
  E.db["bags"]["itemLevelFontSize"] = 14

  -- ElvUI: Chat
  E.db["chat"]["tabSelectedTextColor"] = F.Table.HexToRGB("#AAD372")
  E.db["chat"]["timeStampFormat"] = "%I:%M "

  -- ElvUI: Cooldown
  E.db["cooldown"]["daysIndicator"] = F.Table.HexToRGB("#AAD372")
  E.db["cooldown"]["hhmmColorIndicator"] = F.Table.HexToRGB("#AAD372")
  E.db["cooldown"]["hoursIndicator"] = F.Table.HexToRGB("#AAD372")
  E.db["cooldown"]["minutesIndicator"] = F.Table.HexToRGB("#AAD372")
  E.db["cooldown"]["mmssColorIndicator"] = F.Table.HexToRGB("#AAD372")
  E.db["cooldown"]["secondsIndicator"] = F.Table.HexToRGB("#AAD372")

  -- ElvUI: General
  E.db["general"]["addonCompartment"]["hide"] = true

  -- ElvUI: Movers
  E.db["movers"]["AlertFrameMover"] = "TOPLEFT,UIParent,TOPLEFT,723,-187"
  E.db["movers"]["AltPowerBarMover"] = "TOP,UIParent,TOP,0,-353"
  E.db["movers"]["ArenaHeaderMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-360,-504"
  E.db["movers"]["BossHeaderMover"] = "TOPRIGHT,UIParent,TOPRIGHT,-386,-343"
  E.db["movers"]["ClassBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,458"
  E.db["movers"]["ElvAB_1"] = "BOTTOM,ElvUIParent,BOTTOM,0,162"
  E.db["movers"]["ElvAB_3"] = "BOTTOM,ElvUIParent,BOTTOM,-380,94"
  E.db["movers"]["ElvAB_4"] = "BOTTOM,ElvUIParent,BOTTOM,380,94"
  E.db["movers"]["ElvAB_5"] = "BOTTOM,ElvUIParent,BOTTOM,0,128"
  E.db["movers"]["ElvAB_6"] = "BOTTOM,ElvUIParent,BOTTOM,0,94"
  E.db["movers"]["ElvUF_PartyMover"] = "TOPLEFT,UIParent,TOPLEFT,499,-562"
  E.db["movers"]["ElvUF_PlayerCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,197"
  E.db["movers"]["ElvUF_Raid1Mover"] = "BOTTOMLEFT,UIParent,BOTTOMLEFT,4,315"
  E.db["movers"]["ElvUF_Raid2Mover"] = "BOTTOMLEFT,UIParent,BOTTOMLEFT,4,315"
  E.db["movers"]["ElvUF_Raid3Mover"] = "BOTTOMLEFT,UIParent,BOTTOMLEFT,4,316"
  E.db["movers"]["ElvUF_TargetCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,390,380"
  E.db["movers"]["ElvUIBagMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-5,50"
  E.db["movers"]["ElvUIBankMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,5,50"
  E.db["movers"]["PetAB"] = "BOTTOM,UIParent,BOTTOM,0,197"
  E.db["movers"]["PlayerPowerBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,-324,415"
  E.db["movers"]["PowerBarContainerMover"] = "BOTTOM,UIParent,BOTTOM,-395,173"
  E.db["movers"]["QueueStatusMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-10,-250"
  E.db["movers"]["ShiftAB"] = "BOTTOM,UIParent,BOTTOM,-367,592"
  E.db["movers"]["TooltipMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-20,240"
  E.db["movers"]["VehicleLeaveButton"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-207,-247"

  -- ElvUI: Tooltip
  E.db["tooltip"]["healthBar"]["text"] = false

  -- ElvUI: UnitFrames
  E.db["unitframe"]["units"]["arena"]["enable"] = false
  E.db["unitframe"]["units"]["arena"]["fader"]["enable"] = false
  E.db["unitframe"]["units"]["boss"]["buffs"]["countFont"] = "Arial Narrow"
  E.db["unitframe"]["units"]["boss"]["buffs"]["countFontSize"] = 16
  E.db["unitframe"]["units"]["boss"]["buffs"]["countPosition"] = "BOTTOM"
  E.db["unitframe"]["units"]["boss"]["buffs"]["countYOffset"] = -7
  E.db["unitframe"]["units"]["boss"]["buffs"]["height"] = 22
  E.db["unitframe"]["units"]["boss"]["buffs"]["keepSizeRatio"] = false
  E.db["unitframe"]["units"]["boss"]["buffs"]["maxDuration"] = 300
  E.db["unitframe"]["units"]["boss"]["buffs"]["sizeOverride"] = 29
  E.db["unitframe"]["units"]["boss"]["buffs"]["yOffset"] = 19
  E.db["unitframe"]["units"]["boss"]["castbar"]["strataAndLevel"]["useCustomLevel"] = true
  E.db["unitframe"]["units"]["boss"]["castbar"]["width"] = 210
  E.db["unitframe"]["units"]["boss"]["customTexts"]["!Health"]["attachTextTo"] = "Health"
  E.db["unitframe"]["units"]["boss"]["customTexts"]["!Health"]["enable"] = true
  E.db["unitframe"]["units"]["boss"]["customTexts"]["!Health"]["font"] = "Arial Narrow"
  E.db["unitframe"]["units"]["boss"]["customTexts"]["!Health"]["fontOutline"] = "OUTLINE"
  E.db["unitframe"]["units"]["boss"]["customTexts"]["!Health"]["justifyH"] = "LEFT"
  E.db["unitframe"]["units"]["boss"]["customTexts"]["!Health"]["size"] = 30
  E.db["unitframe"]["units"]["boss"]["customTexts"]["!Health"]["text_format"] = "[tx:health:percent:nosign]"
  E.db["unitframe"]["units"]["boss"]["customTexts"]["!Health"]["xOffset"] = 6
  E.db["unitframe"]["units"]["boss"]["customTexts"]["!Health"]["yOffset"] = 18
  E.db["unitframe"]["units"]["boss"]["customTexts"]["!Power"]["attachTextTo"] = "Power"
  E.db["unitframe"]["units"]["boss"]["customTexts"]["!Power"]["enable"] = false
  E.db["unitframe"]["units"]["boss"]["customTexts"]["!Power"]["font"] = "Arial Narrow"
  E.db["unitframe"]["units"]["boss"]["customTexts"]["!Power"]["fontOutline"] = "OUTLINE"
  E.db["unitframe"]["units"]["boss"]["customTexts"]["!Power"]["justifyH"] = "LEFT"
  E.db["unitframe"]["units"]["boss"]["customTexts"]["!Power"]["size"] = 20
  E.db["unitframe"]["units"]["boss"]["customTexts"]["!Power"]["text_format"] = "[tx:smartpower:percent:nosign]"
  E.db["unitframe"]["units"]["boss"]["customTexts"]["!Power"]["xOffset"] = 84
  E.db["unitframe"]["units"]["boss"]["customTexts"]["!Power"]["yOffset"] = 0
  E.db["unitframe"]["units"]["boss"]["debuffs"]["countFont"] = "Arial Narrow"
  E.db["unitframe"]["units"]["boss"]["debuffs"]["countFontSize"] = 16
  E.db["unitframe"]["units"]["boss"]["debuffs"]["countPosition"] = "BOTTOM"
  E.db["unitframe"]["units"]["boss"]["debuffs"]["countYOffset"] = -7
  E.db["unitframe"]["units"]["boss"]["debuffs"]["height"] = 22
  E.db["unitframe"]["units"]["boss"]["debuffs"]["keepSizeRatio"] = false
  E.db["unitframe"]["units"]["boss"]["debuffs"]["maxDuration"] = 300
  E.db["unitframe"]["units"]["boss"]["debuffs"]["sizeOverride"] = 29
  E.db["unitframe"]["units"]["boss"]["debuffs"]["yOffset"] = -19
  E.db["unitframe"]["units"]["boss"]["health"]["text_format"] = ""
  E.db["unitframe"]["units"]["boss"]["height"] = 36
  E.db["unitframe"]["units"]["boss"]["name"]["text_format"] = ""
  E.db["unitframe"]["units"]["boss"]["power"]["text_format"] = ""
  E.db["unitframe"]["units"]["boss"]["power"]["width"] = "spaced"
  E.db["unitframe"]["units"]["boss"]["spacing"] = 38
  E.db["unitframe"]["units"]["boss"]["width"] = 210
  E.db["unitframe"]["units"]["party"]["buffIndicator"]["size"] = 12
  E.db["unitframe"]["units"]["party"]["buffs"]["anchorPoint"] = "BOTTOMLEFT"
  E.db["unitframe"]["units"]["party"]["buffs"]["countFont"] = "Arial Narrow"
  E.db["unitframe"]["units"]["party"]["buffs"]["countFontSize"] = 18
  E.db["unitframe"]["units"]["party"]["buffs"]["countPosition"] = "BOTTOM"
  E.db["unitframe"]["units"]["party"]["buffs"]["countYOffset"] = -7
  E.db["unitframe"]["units"]["party"]["buffs"]["height"] = 29
  E.db["unitframe"]["units"]["party"]["buffs"]["keepSizeRatio"] = false
  E.db["unitframe"]["units"]["party"]["buffs"]["perrow"] = 5
  E.db["unitframe"]["units"]["party"]["buffs"]["sizeOverride"] = 38
  E.db["unitframe"]["units"]["party"]["customTexts"]["!ClassIcon"]["attachTextTo"] = "Health"
  E.db["unitframe"]["units"]["party"]["customTexts"]["!ClassIcon"]["enable"] = true
  E.db["unitframe"]["units"]["party"]["customTexts"]["!ClassIcon"]["font"] = "Arial Narrow"
  E.db["unitframe"]["units"]["party"]["customTexts"]["!ClassIcon"]["fontOutline"] = "OUTLINE"
  E.db["unitframe"]["units"]["party"]["customTexts"]["!ClassIcon"]["justifyH"] = "LEFT"
  E.db["unitframe"]["units"]["party"]["customTexts"]["!ClassIcon"]["size"] = 10
  E.db["unitframe"]["units"]["party"]["customTexts"]["!ClassIcon"]["text_format"] = "[tx:classicon]"
  E.db["unitframe"]["units"]["party"]["customTexts"]["!ClassIcon"]["xOffset"] = 6
  E.db["unitframe"]["units"]["party"]["customTexts"]["!ClassIcon"]["yOffset"] = 0
  E.db["unitframe"]["units"]["party"]["customTexts"]["!Health"]["attachTextTo"] = "Health"
  E.db["unitframe"]["units"]["party"]["customTexts"]["!Health"]["enable"] = true
  E.db["unitframe"]["units"]["party"]["customTexts"]["!Health"]["font"] = "Arial Narrow"
  E.db["unitframe"]["units"]["party"]["customTexts"]["!Health"]["fontOutline"] = "OUTLINE"
  E.db["unitframe"]["units"]["party"]["customTexts"]["!Health"]["justifyH"] = "RIGHT"
  E.db["unitframe"]["units"]["party"]["customTexts"]["!Health"]["size"] = 30
  E.db["unitframe"]["units"]["party"]["customTexts"]["!Health"]["text_format"] = "[tx:health:percent:nosign]"
  E.db["unitframe"]["units"]["party"]["customTexts"]["!Health"]["xOffset"] = -12
  E.db["unitframe"]["units"]["party"]["customTexts"]["!Health"]["yOffset"] = 18
  E.db["unitframe"]["units"]["party"]["customTexts"]["!Level"]["attachTextTo"] = "Health"
  E.db["unitframe"]["units"]["party"]["customTexts"]["!Level"]["enable"] = true
  E.db["unitframe"]["units"]["party"]["customTexts"]["!Level"]["font"] = "Arial Narrow"
  E.db["unitframe"]["units"]["party"]["customTexts"]["!Level"]["fontOutline"] = "OUTLINE"
  E.db["unitframe"]["units"]["party"]["customTexts"]["!Level"]["justifyH"] = "LEFT"
  E.db["unitframe"]["units"]["party"]["customTexts"]["!Level"]["size"] = 14
  E.db["unitframe"]["units"]["party"]["customTexts"]["!Level"]["text_format"] = "[tx:level]"
  E.db["unitframe"]["units"]["party"]["customTexts"]["!Level"]["xOffset"] = 22
  E.db["unitframe"]["units"]["party"]["customTexts"]["!Level"]["yOffset"] = -14
  E.db["unitframe"]["units"]["party"]["customTexts"]["!Power"]["attachTextTo"] = "Power"
  E.db["unitframe"]["units"]["party"]["customTexts"]["!Power"]["enable"] = false
  E.db["unitframe"]["units"]["party"]["customTexts"]["!Power"]["font"] = "Arial Narrow"
  E.db["unitframe"]["units"]["party"]["customTexts"]["!Power"]["fontOutline"] = "OUTLINE"
  E.db["unitframe"]["units"]["party"]["customTexts"]["!Power"]["justifyH"] = "LEFT"
  E.db["unitframe"]["units"]["party"]["customTexts"]["!Power"]["size"] = 20
  E.db["unitframe"]["units"]["party"]["customTexts"]["!Power"]["text_format"] = "[tx:smartpower:percent:nosign]"
  E.db["unitframe"]["units"]["party"]["customTexts"]["!Power"]["xOffset"] = 12
  E.db["unitframe"]["units"]["party"]["customTexts"]["!Power"]["yOffset"] = 0
  E.db["unitframe"]["units"]["party"]["debuffs"]["attachTo"] = "HEALTH"
  E.db["unitframe"]["units"]["party"]["debuffs"]["countFont"] = "Arial Narrow"
  E.db["unitframe"]["units"]["party"]["debuffs"]["countFontSize"] = 18
  E.db["unitframe"]["units"]["party"]["debuffs"]["countPosition"] = "BOTTOM"
  E.db["unitframe"]["units"]["party"]["debuffs"]["countYOffset"] = -7
  E.db["unitframe"]["units"]["party"]["debuffs"]["height"] = 29
  E.db["unitframe"]["units"]["party"]["debuffs"]["keepSizeRatio"] = false
  E.db["unitframe"]["units"]["party"]["debuffs"]["priority"] = "Blacklist,Dispellable,Boss,RaidDebuffs,CCDebuffs,Whitelist"
  E.db["unitframe"]["units"]["party"]["debuffs"]["sizeOverride"] = 38
  E.db["unitframe"]["units"]["party"]["groupBy"] = "ROLE"
  E.db["unitframe"]["units"]["party"]["growthDirection"] = "DOWN_LEFT"
  E.db["unitframe"]["units"]["party"]["healPrediction"]["absorbStyle"] = "REVERSED"
  E.db["unitframe"]["units"]["party"]["healPrediction"]["enable"] = true
  E.db["unitframe"]["units"]["party"]["health"]["text_format"] = ""
  E.db["unitframe"]["units"]["party"]["height"] = 36
  E.db["unitframe"]["units"]["party"]["horizontalSpacing"] = 6
  E.db["unitframe"]["units"]["party"]["name"]["text_format"] = ""
  E.db["unitframe"]["units"]["party"]["phaseIndicator"]["scale"] = 1.2
  E.db["unitframe"]["units"]["party"]["power"]["height"] = 8
  E.db["unitframe"]["units"]["party"]["power"]["text_format"] = ""
  E.db["unitframe"]["units"]["party"]["power"]["width"] = "spaced"
  E.db["unitframe"]["units"]["party"]["raidRoleIcons"]["scale"] = 2
  E.db["unitframe"]["units"]["party"]["raidRoleIcons"]["xOffset"] = 12
  E.db["unitframe"]["units"]["party"]["raidRoleIcons"]["yOffset"] = 25
  E.db["unitframe"]["units"]["party"]["raidWideSorting"] = true
  E.db["unitframe"]["units"]["party"]["raidicon"]["size"] = 31
  E.db["unitframe"]["units"]["party"]["raidicon"]["xOffset"] = -60
  E.db["unitframe"]["units"]["party"]["raidicon"]["yOffset"] = -12
  E.db["unitframe"]["units"]["party"]["rdebuffs"]["enable"] = false
  E.db["unitframe"]["units"]["party"]["rdebuffs"]["font"] = "Arial Narrow"
  E.db["unitframe"]["units"]["party"]["rdebuffs"]["fontSize"] = 18
  E.db["unitframe"]["units"]["party"]["rdebuffs"]["size"] = 36
  E.db["unitframe"]["units"]["party"]["rdebuffs"]["yOffset"] = 24
  E.db["unitframe"]["units"]["party"]["readycheckIcon"]["position"] = "CENTER"
  E.db["unitframe"]["units"]["party"]["readycheckIcon"]["size"] = 48
  E.db["unitframe"]["units"]["party"]["readycheckIcon"]["yOffset"] = 0
  E.db["unitframe"]["units"]["party"]["roleIcon"]["position"] = "LEFT"
  E.db["unitframe"]["units"]["party"]["roleIcon"]["size"] = 36
  E.db["unitframe"]["units"]["party"]["roleIcon"]["xOffset"] = -42
  E.db["unitframe"]["units"]["party"]["roleIcon"]["yOffset"] = 0
  E.db["unitframe"]["units"]["party"]["showPlayer"] = false
  E.db["unitframe"]["units"]["party"]["startFromCenter"] = true
  E.db["unitframe"]["units"]["party"]["verticalSpacing"] = 34
  E.db["unitframe"]["units"]["party"]["width"] = 210
  E.db["unitframe"]["units"]["pet"]["castbar"]["customTextFont"]["enable"] = true
  E.db["unitframe"]["units"]["pet"]["castbar"]["customTextFont"]["font"] = "Arial Narrow"
  E.db["unitframe"]["units"]["pet"]["castbar"]["customTextFont"]["fontSize"] = 16
  E.db["unitframe"]["units"]["pet"]["castbar"]["customTimeFont"]["enable"] = true
  E.db["unitframe"]["units"]["pet"]["castbar"]["customTimeFont"]["font"] = "Arial Narrow"
  E.db["unitframe"]["units"]["pet"]["castbar"]["customTimeFont"]["fontSize"] = 16
  E.db["unitframe"]["units"]["pet"]["castbar"]["height"] = 14
  E.db["unitframe"]["units"]["pet"]["castbar"]["textColor"] = F.Table.HexToRGB("#FFFFFF")
  E.db["unitframe"]["units"]["pet"]["castbar"]["width"] = 120
  E.db["unitframe"]["units"]["pet"]["customTexts"]["!Happiness"]["attachTextTo"] = "Health"
  E.db["unitframe"]["units"]["pet"]["customTexts"]["!Happiness"]["enable"] = true
  E.db["unitframe"]["units"]["pet"]["customTexts"]["!Happiness"]["font"] = "Arial Narrow"
  E.db["unitframe"]["units"]["pet"]["customTexts"]["!Happiness"]["fontOutline"] = "OUTLINE"
  E.db["unitframe"]["units"]["pet"]["customTexts"]["!Happiness"]["justifyH"] = "LEFT"
  E.db["unitframe"]["units"]["pet"]["customTexts"]["!Happiness"]["size"] = 16
  E.db["unitframe"]["units"]["pet"]["customTexts"]["!Happiness"]["text_format"] = ""
  E.db["unitframe"]["units"]["pet"]["customTexts"]["!Happiness"]["xOffset"] = -25
  E.db["unitframe"]["units"]["pet"]["customTexts"]["!Happiness"]["yOffset"] = 0
  E.db["unitframe"]["units"]["pet"]["disableTargetGlow"] = false
  E.db["unitframe"]["units"]["pet"]["fader"]["combat"] = true
  E.db["unitframe"]["units"]["pet"]["fader"]["health"] = true
  E.db["unitframe"]["units"]["pet"]["fader"]["hover"] = true
  E.db["unitframe"]["units"]["pet"]["fader"]["instanceDifficulties"]["dungeonHeroic"] = true
  E.db["unitframe"]["units"]["pet"]["fader"]["instanceDifficulties"]["dungeonMythic"] = true
  E.db["unitframe"]["units"]["pet"]["fader"]["instanceDifficulties"]["dungeonNormal"] = true
  E.db["unitframe"]["units"]["pet"]["fader"]["instanceDifficulties"]["raidHeroic"] = true
  E.db["unitframe"]["units"]["pet"]["fader"]["instanceDifficulties"]["raidMythic"] = true
  E.db["unitframe"]["units"]["pet"]["fader"]["instanceDifficulties"]["raidNormal"] = true
  E.db["unitframe"]["units"]["pet"]["fader"]["minAlpha"] = 0
  E.db["unitframe"]["units"]["pet"]["fader"]["playertarget"] = true
  E.db["unitframe"]["units"]["pet"]["fader"]["range"] = false
  E.db["unitframe"]["units"]["pet"]["fader"]["unittarget"] = true
  E.db["unitframe"]["units"]["pet"]["height"] = 18
  E.db["unitframe"]["units"]["pet"]["name"]["text_format"] = ""
  E.db["unitframe"]["units"]["pet"]["power"]["enable"] = false
  E.db["unitframe"]["units"]["pet"]["threatStyle"] = "NONE"
  E.db["unitframe"]["units"]["pet"]["width"] = 120
  E.db["unitframe"]["units"]["player"]["CombatIcon"]["color"] = F.Table.HexToRGB("#FFFFFF")
  E.db["unitframe"]["units"]["player"]["CombatIcon"]["size"] = 29
  E.db["unitframe"]["units"]["player"]["CombatIcon"]["texture"] = "CUSTOM"
  E.db["unitframe"]["units"]["player"]["CombatIcon"]["yOffset"] = -20
  E.db["unitframe"]["units"]["player"]["RestIcon"]["anchorPoint"] = "TOPRIGHT"
  E.db["unitframe"]["units"]["player"]["RestIcon"]["defaultColor"] = false
  E.db["unitframe"]["units"]["player"]["RestIcon"]["size"] = 43
  E.db["unitframe"]["units"]["player"]["RestIcon"]["texture"] = "CUSTOM"
  E.db["unitframe"]["units"]["player"]["RestIcon"]["xOffset"] = 12
  E.db["unitframe"]["units"]["player"]["RestIcon"]["yOffset"] = 22
  E.db["unitframe"]["units"]["player"]["aurabar"]["enable"] = false
  E.db["unitframe"]["units"]["player"]["buffs"]["countFont"] = "Arial Narrow"
  E.db["unitframe"]["units"]["player"]["buffs"]["countFontSize"] = 16
  E.db["unitframe"]["units"]["player"]["castbar"]["customTextFont"]["enable"] = true
  E.db["unitframe"]["units"]["player"]["castbar"]["customTextFont"]["font"] = "Arial Narrow"
  E.db["unitframe"]["units"]["player"]["castbar"]["customTextFont"]["fontSize"] = 14
  E.db["unitframe"]["units"]["player"]["castbar"]["customTimeFont"]["enable"] = true
  E.db["unitframe"]["units"]["player"]["castbar"]["customTimeFont"]["font"] = "Arial Narrow"
  E.db["unitframe"]["units"]["player"]["castbar"]["customTimeFont"]["fontSize"] = 14
  E.db["unitframe"]["units"]["player"]["castbar"]["height"] = 30
  E.db["unitframe"]["units"]["player"]["castbar"]["insideInfoPanel"] = false
  E.db["unitframe"]["units"]["player"]["castbar"]["strataAndLevel"]["useCustomLevel"] = true
  E.db["unitframe"]["units"]["player"]["castbar"]["textColor"] = F.Table.HexToRGB("#FFFFFF")
  E.db["unitframe"]["units"]["player"]["castbar"]["width"] = 320
  E.db["unitframe"]["units"]["player"]["castbar"]["xOffsetText"] = 2
  E.db["unitframe"]["units"]["player"]["castbar"]["xOffsetTime"] = -2
  E.db["unitframe"]["units"]["player"]["classbar"]["detachFromFrame"] = true
  E.db["unitframe"]["units"]["player"]["classbar"]["detachedWidth"] = 298
  E.db["unitframe"]["units"]["player"]["classbar"]["enable"] = false
  E.db["unitframe"]["units"]["player"]["customTexts"]["!ClassIcon"]["attachTextTo"] = "Health"
  E.db["unitframe"]["units"]["player"]["customTexts"]["!ClassIcon"]["enable"] = true
  E.db["unitframe"]["units"]["player"]["customTexts"]["!ClassIcon"]["font"] = "Arial Narrow"
  E.db["unitframe"]["units"]["player"]["customTexts"]["!ClassIcon"]["fontOutline"] = "OUTLINE"
  E.db["unitframe"]["units"]["player"]["customTexts"]["!ClassIcon"]["justifyH"] = "LEFT"
  E.db["unitframe"]["units"]["player"]["customTexts"]["!ClassIcon"]["size"] = 12
  E.db["unitframe"]["units"]["player"]["customTexts"]["!ClassIcon"]["text_format"] = "[tx:classicon]"
  E.db["unitframe"]["units"]["player"]["customTexts"]["!ClassIcon"]["xOffset"] = 6
  E.db["unitframe"]["units"]["player"]["customTexts"]["!ClassIcon"]["yOffset"] = 0
  E.db["unitframe"]["units"]["player"]["customTexts"]["!Health"]["attachTextTo"] = "Health"
  E.db["unitframe"]["units"]["player"]["customTexts"]["!Health"]["enable"] = true
  E.db["unitframe"]["units"]["player"]["customTexts"]["!Health"]["font"] = "Arial Narrow"
  E.db["unitframe"]["units"]["player"]["customTexts"]["!Health"]["fontOutline"] = "OUTLINE"
  E.db["unitframe"]["units"]["player"]["customTexts"]["!Health"]["justifyH"] = "RIGHT"
  E.db["unitframe"]["units"]["player"]["customTexts"]["!Health"]["size"] = 32
  E.db["unitframe"]["units"]["player"]["customTexts"]["!Health"]["text_format"] = "[tx:health:percent:nosign]"
  E.db["unitframe"]["units"]["player"]["customTexts"]["!Health"]["xOffset"] = -12
  E.db["unitframe"]["units"]["player"]["customTexts"]["!Health"]["yOffset"] = 18
  E.db["unitframe"]["units"]["player"]["customTexts"]["!Level"]["attachTextTo"] = "Health"
  E.db["unitframe"]["units"]["player"]["customTexts"]["!Level"]["enable"] = true
  E.db["unitframe"]["units"]["player"]["customTexts"]["!Level"]["font"] = "Arial Narrow"
  E.db["unitframe"]["units"]["player"]["customTexts"]["!Level"]["fontOutline"] = "OUTLINE"
  E.db["unitframe"]["units"]["player"]["customTexts"]["!Level"]["justifyH"] = "LEFT"
  E.db["unitframe"]["units"]["player"]["customTexts"]["!Level"]["size"] = 14
  E.db["unitframe"]["units"]["player"]["customTexts"]["!Level"]["text_format"] = "[tx:level]"
  E.db["unitframe"]["units"]["player"]["customTexts"]["!Level"]["xOffset"] = 22
  E.db["unitframe"]["units"]["player"]["customTexts"]["!Level"]["yOffset"] = -18
  E.db["unitframe"]["units"]["player"]["customTexts"]["!Name"]["attachTextTo"] = "Health"
  E.db["unitframe"]["units"]["player"]["customTexts"]["!Name"]["enable"] = true
  E.db["unitframe"]["units"]["player"]["customTexts"]["!Name"]["font"] = "Arial Narrow"
  E.db["unitframe"]["units"]["player"]["customTexts"]["!Name"]["fontOutline"] = "OUTLINE"
  E.db["unitframe"]["units"]["player"]["customTexts"]["!Name"]["justifyH"] = "LEFT"
  E.db["unitframe"]["units"]["player"]["customTexts"]["!Name"]["size"] = 16
  E.db["unitframe"]["units"]["player"]["customTexts"]["!Name"]["text_format"] = "[kmt-name:caps{11}]"
  E.db["unitframe"]["units"]["player"]["customTexts"]["!Name"]["xOffset"] = 6
  E.db["unitframe"]["units"]["player"]["customTexts"]["!Name"]["yOffset"] = 28
  E.db["unitframe"]["units"]["player"]["customTexts"]["!Power"]["attachTextTo"] = "Power"
  E.db["unitframe"]["units"]["player"]["customTexts"]["!Power"]["enable"] = false
  E.db["unitframe"]["units"]["player"]["customTexts"]["!Power"]["font"] = "Arial Narrow"
  E.db["unitframe"]["units"]["player"]["customTexts"]["!Power"]["fontOutline"] = "OUTLINE"
  E.db["unitframe"]["units"]["player"]["customTexts"]["!Power"]["justifyH"] = "CENTER"
  E.db["unitframe"]["units"]["player"]["customTexts"]["!Power"]["size"] = 20
  E.db["unitframe"]["units"]["player"]["customTexts"]["!Power"]["text_format"] = "[tx:smartpower:percent:nosign]"
  E.db["unitframe"]["units"]["player"]["customTexts"]["!Power"]["xOffset"] = 0
  E.db["unitframe"]["units"]["player"]["customTexts"]["!Power"]["yOffset"] = 6
  E.db["unitframe"]["units"]["player"]["debuffs"]["anchorPoint"] = "TOPRIGHT"
  E.db["unitframe"]["units"]["player"]["debuffs"]["countFont"] = "Arial Narrow"
  E.db["unitframe"]["units"]["player"]["debuffs"]["countFontSize"] = 16
  E.db["unitframe"]["units"]["player"]["debuffs"]["countPosition"] = "BOTTOM"
  E.db["unitframe"]["units"]["player"]["debuffs"]["countYOffset"] = -7
  E.db["unitframe"]["units"]["player"]["debuffs"]["growthX"] = "LEFT"
  E.db["unitframe"]["units"]["player"]["debuffs"]["height"] = 32
  E.db["unitframe"]["units"]["player"]["debuffs"]["keepSizeRatio"] = false
  E.db["unitframe"]["units"]["player"]["debuffs"]["perrow"] = 7
  E.db["unitframe"]["units"]["player"]["debuffs"]["priority"] = "Blacklist,Boss,CCDebuffs,RaidDebuffs,CastByUnit,CastByNPC,Personal"
  E.db["unitframe"]["units"]["player"]["debuffs"]["sizeOverride"] = 43
  E.db["unitframe"]["units"]["player"]["debuffs"]["spacing"] = 0
  E.db["unitframe"]["units"]["player"]["debuffs"]["yOffset"] = 30
  E.db["unitframe"]["units"]["player"]["disableMouseoverGlow"] = true
  E.db["unitframe"]["units"]["player"]["fader"]["instanceDifficulties"]["dungeonHeroic"] = true
  E.db["unitframe"]["units"]["player"]["fader"]["instanceDifficulties"]["dungeonMythic"] = true
  E.db["unitframe"]["units"]["player"]["fader"]["instanceDifficulties"]["dungeonNormal"] = true
  E.db["unitframe"]["units"]["player"]["fader"]["instanceDifficulties"]["raidHeroic"] = true
  E.db["unitframe"]["units"]["player"]["fader"]["instanceDifficulties"]["raidMythic"] = true
  E.db["unitframe"]["units"]["player"]["fader"]["instanceDifficulties"]["raidNormal"] = true
  E.db["unitframe"]["units"]["player"]["fader"]["minAlpha"] = 0
  E.db["unitframe"]["units"]["player"]["fader"]["vehicle"] = false
  E.db["unitframe"]["units"]["player"]["healPrediction"]["absorbStyle"] = "REVERSED"
  E.db["unitframe"]["units"]["player"]["health"]["text_format"] = ""
  E.db["unitframe"]["units"]["player"]["height"] = 36
  E.db["unitframe"]["units"]["player"]["partyIndicator"]["enable"] = false
  E.db["unitframe"]["units"]["player"]["power"]["detachFromFrame"] = true
  E.db["unitframe"]["units"]["player"]["power"]["detachedWidth"] = 144
  E.db["unitframe"]["units"]["player"]["power"]["enable"] = false
  E.db["unitframe"]["units"]["player"]["power"]["text_format"] = ""
  E.db["unitframe"]["units"]["player"]["power"]["width"] = "spaced"
  E.db["unitframe"]["units"]["player"]["raidRoleIcons"]["scale"] = 2
  E.db["unitframe"]["units"]["player"]["raidRoleIcons"]["xOffset"] = 6
  E.db["unitframe"]["units"]["player"]["raidRoleIcons"]["yOffset"] = 25
  E.db["unitframe"]["units"]["player"]["raidicon"]["attachTo"] = "CENTER"
  E.db["unitframe"]["units"]["player"]["raidicon"]["size"] = 29
  E.db["unitframe"]["units"]["player"]["raidicon"]["yOffset"] = 0
  E.db["unitframe"]["units"]["player"]["threatStyle"] = "NONE"
  E.db["unitframe"]["units"]["player"]["width"] = 300
  E.db["unitframe"]["units"]["raid1"]["customTexts"]["!Group"]["attachTextTo"] = "Frame"
  E.db["unitframe"]["units"]["raid1"]["customTexts"]["!Group"]["enable"] = true
  E.db["unitframe"]["units"]["raid1"]["customTexts"]["!Group"]["font"] = "Arial Narrow"
  E.db["unitframe"]["units"]["raid1"]["customTexts"]["!Group"]["fontOutline"] = "OUTLINE"
  E.db["unitframe"]["units"]["raid1"]["customTexts"]["!Group"]["justifyH"] = "RIGHT"
  E.db["unitframe"]["units"]["raid1"]["customTexts"]["!Group"]["size"] = 12
  E.db["unitframe"]["units"]["raid1"]["customTexts"]["!Group"]["text_format"] = "[group:raid]"
  E.db["unitframe"]["units"]["raid1"]["customTexts"]["!Group"]["xOffset"] = -2
  E.db["unitframe"]["units"]["raid1"]["customTexts"]["!Group"]["yOffset"] = -10
  E.db["unitframe"]["units"]["raid1"]["groupSpacing"] = 10
  E.db["unitframe"]["units"]["raid1"]["growthDirection"] = "RIGHT_UP"
  E.db["unitframe"]["units"]["raid1"]["healPrediction"]["absorbStyle"] = "REVERSED"
  E.db["unitframe"]["units"]["raid1"]["healPrediction"]["enable"] = true
  E.db["unitframe"]["units"]["raid1"]["health"]["text_format"] = ""
  E.db["unitframe"]["units"]["raid1"]["height"] = 42
  E.db["unitframe"]["units"]["raid1"]["horizontalSpacing"] = 5
  E.db["unitframe"]["units"]["raid1"]["name"]["text_format"] = ""
  E.db["unitframe"]["units"]["raid1"]["power"]["enable"] = false
  E.db["unitframe"]["units"]["raid1"]["raidRoleIcons"]["scale"] = 2
  E.db["unitframe"]["units"]["raid1"]["raidRoleIcons"]["yOffset"] = 7
  E.db["unitframe"]["units"]["raid1"]["rdebuffs"]["duration"]["color"] = F.Table.HexToRGB("#FFFFFF")
  E.db["unitframe"]["units"]["raid1"]["rdebuffs"]["font"] = "Arial Narrow"
  E.db["unitframe"]["units"]["raid1"]["rdebuffs"]["fontSize"] = 16
  E.db["unitframe"]["units"]["raid1"]["rdebuffs"]["size"] = 24
  E.db["unitframe"]["units"]["raid1"]["rdebuffs"]["stack"]["color"] = F.Table.HexToRGB("#FFFFFF")
  E.db["unitframe"]["units"]["raid1"]["rdebuffs"]["stack"]["yOffset"] = 0
  E.db["unitframe"]["units"]["raid1"]["rdebuffs"]["yOffset"] = 6
  E.db["unitframe"]["units"]["raid1"]["readycheckIcon"]["size"] = 29
  E.db["unitframe"]["units"]["raid1"]["roleIcon"]["damager"] = false
  E.db["unitframe"]["units"]["raid1"]["roleIcon"]["position"] = "BOTTOMLEFT"
  E.db["unitframe"]["units"]["raid1"]["roleIcon"]["size"] = 24
  E.db["unitframe"]["units"]["raid1"]["roleIcon"]["xOffset"] = 0
  E.db["unitframe"]["units"]["raid1"]["roleIcon"]["yOffset"] = 2
  E.db["unitframe"]["units"]["raid1"]["verticalSpacing"] = 1
  E.db["unitframe"]["units"]["raid1"]["width"] = 96
  E.db["unitframe"]["units"]["raid2"]["customTexts"]["!Group"]["attachTextTo"] = "Frame"
  E.db["unitframe"]["units"]["raid2"]["customTexts"]["!Group"]["enable"] = true
  E.db["unitframe"]["units"]["raid2"]["customTexts"]["!Group"]["font"] = "Arial Narrow"
  E.db["unitframe"]["units"]["raid2"]["customTexts"]["!Group"]["fontOutline"] = "OUTLINE"
  E.db["unitframe"]["units"]["raid2"]["customTexts"]["!Group"]["justifyH"] = "RIGHT"
  E.db["unitframe"]["units"]["raid2"]["customTexts"]["!Group"]["size"] = 12
  E.db["unitframe"]["units"]["raid2"]["customTexts"]["!Group"]["text_format"] = "[group:raid]"
  E.db["unitframe"]["units"]["raid2"]["customTexts"]["!Group"]["xOffset"] = -2
  E.db["unitframe"]["units"]["raid2"]["customTexts"]["!Group"]["yOffset"] = -10
  E.db["unitframe"]["units"]["raid2"]["groupSpacing"] = 10
  E.db["unitframe"]["units"]["raid2"]["growthDirection"] = "RIGHT_UP"
  E.db["unitframe"]["units"]["raid2"]["healPrediction"]["absorbStyle"] = "REVERSED"
  E.db["unitframe"]["units"]["raid2"]["healPrediction"]["enable"] = true
  E.db["unitframe"]["units"]["raid2"]["health"]["text_format"] = ""
  E.db["unitframe"]["units"]["raid2"]["height"] = 42
  E.db["unitframe"]["units"]["raid2"]["horizontalSpacing"] = 5
  E.db["unitframe"]["units"]["raid2"]["name"]["text_format"] = ""
  E.db["unitframe"]["units"]["raid2"]["raidRoleIcons"]["scale"] = 2
  E.db["unitframe"]["units"]["raid2"]["raidRoleIcons"]["yOffset"] = 7
  E.db["unitframe"]["units"]["raid2"]["rdebuffs"]["duration"]["color"] = F.Table.HexToRGB("#FFFFFF")
  E.db["unitframe"]["units"]["raid2"]["rdebuffs"]["enable"] = true
  E.db["unitframe"]["units"]["raid2"]["rdebuffs"]["font"] = "Arial Narrow"
  E.db["unitframe"]["units"]["raid2"]["rdebuffs"]["fontSize"] = 16
  E.db["unitframe"]["units"]["raid2"]["rdebuffs"]["size"] = 24
  E.db["unitframe"]["units"]["raid2"]["rdebuffs"]["stack"]["color"] = F.Table.HexToRGB("#FFFFFF")
  E.db["unitframe"]["units"]["raid2"]["rdebuffs"]["stack"]["yOffset"] = 0
  E.db["unitframe"]["units"]["raid2"]["rdebuffs"]["yOffset"] = 6
  E.db["unitframe"]["units"]["raid2"]["readycheckIcon"]["size"] = 29
  E.db["unitframe"]["units"]["raid2"]["roleIcon"]["damager"] = false
  E.db["unitframe"]["units"]["raid2"]["roleIcon"]["enable"] = true
  E.db["unitframe"]["units"]["raid2"]["roleIcon"]["position"] = "BOTTOMLEFT"
  E.db["unitframe"]["units"]["raid2"]["roleIcon"]["size"] = 24
  E.db["unitframe"]["units"]["raid2"]["roleIcon"]["xOffset"] = 0
  E.db["unitframe"]["units"]["raid2"]["roleIcon"]["yOffset"] = 2
  E.db["unitframe"]["units"]["raid2"]["verticalSpacing"] = 1
  E.db["unitframe"]["units"]["raid2"]["width"] = 96
  E.db["unitframe"]["units"]["raid3"]["customTexts"]["!Group"]["attachTextTo"] = "Frame"
  E.db["unitframe"]["units"]["raid3"]["customTexts"]["!Group"]["enable"] = true
  E.db["unitframe"]["units"]["raid3"]["customTexts"]["!Group"]["font"] = "Arial Narrow"
  E.db["unitframe"]["units"]["raid3"]["customTexts"]["!Group"]["fontOutline"] = "OUTLINE"
  E.db["unitframe"]["units"]["raid3"]["customTexts"]["!Group"]["justifyH"] = "RIGHT"
  E.db["unitframe"]["units"]["raid3"]["customTexts"]["!Group"]["size"] = 12
  E.db["unitframe"]["units"]["raid3"]["customTexts"]["!Group"]["text_format"] = "[group:raid]"
  E.db["unitframe"]["units"]["raid3"]["customTexts"]["!Group"]["xOffset"] = -2
  E.db["unitframe"]["units"]["raid3"]["customTexts"]["!Group"]["yOffset"] = -6
  E.db["unitframe"]["units"]["raid3"]["groupBy"] = "ROLE"
  E.db["unitframe"]["units"]["raid3"]["growthDirection"] = "RIGHT_UP"
  E.db["unitframe"]["units"]["raid3"]["healPrediction"]["absorbStyle"] = "REVERSED"
  E.db["unitframe"]["units"]["raid3"]["healPrediction"]["enable"] = true
  E.db["unitframe"]["units"]["raid3"]["health"]["text_format"] = ""
  E.db["unitframe"]["units"]["raid3"]["height"] = 26
  E.db["unitframe"]["units"]["raid3"]["horizontalSpacing"] = 5
  E.db["unitframe"]["units"]["raid3"]["name"]["text_format"] = ""
  E.db["unitframe"]["units"]["raid3"]["raidRoleIcons"]["scale"] = 2
  E.db["unitframe"]["units"]["raid3"]["raidRoleIcons"]["yOffset"] = 7
  E.db["unitframe"]["units"]["raid3"]["rdebuffs"]["duration"]["color"] = F.Table.HexToRGB("#FFFFFF")
  E.db["unitframe"]["units"]["raid3"]["rdebuffs"]["enable"] = true
  E.db["unitframe"]["units"]["raid3"]["rdebuffs"]["font"] = "Arial Narrow"
  E.db["unitframe"]["units"]["raid3"]["rdebuffs"]["fontSize"] = 16
  E.db["unitframe"]["units"]["raid3"]["rdebuffs"]["size"] = 22
  E.db["unitframe"]["units"]["raid3"]["rdebuffs"]["stack"]["color"] = F.Table.HexToRGB("#FFFFFF")
  E.db["unitframe"]["units"]["raid3"]["rdebuffs"]["stack"]["yOffset"] = 0
  E.db["unitframe"]["units"]["raid3"]["rdebuffs"]["yOffset"] = 5
  E.db["unitframe"]["units"]["raid3"]["readycheckIcon"]["size"] = 29
  E.db["unitframe"]["units"]["raid3"]["roleIcon"]["damager"] = false
  E.db["unitframe"]["units"]["raid3"]["roleIcon"]["enable"] = true
  E.db["unitframe"]["units"]["raid3"]["roleIcon"]["position"] = "BOTTOMLEFT"
  E.db["unitframe"]["units"]["raid3"]["roleIcon"]["size"] = 24
  E.db["unitframe"]["units"]["raid3"]["roleIcon"]["xOffset"] = 0
  E.db["unitframe"]["units"]["raid3"]["roleIcon"]["yOffset"] = 2
  E.db["unitframe"]["units"]["raid3"]["verticalSpacing"] = 1
  E.db["unitframe"]["units"]["raid3"]["width"] = 96
  E.db["unitframe"]["units"]["tank"]["customTexts"]["!Name"]["attachTextTo"] = "Frame"
  E.db["unitframe"]["units"]["tank"]["customTexts"]["!Name"]["enable"] = true
  E.db["unitframe"]["units"]["tank"]["customTexts"]["!Name"]["font"] = "Arial Narrow"
  E.db["unitframe"]["units"]["tank"]["customTexts"]["!Name"]["fontOutline"] = "OUTLINE"
  E.db["unitframe"]["units"]["tank"]["customTexts"]["!Name"]["justifyH"] = "CENTER"
  E.db["unitframe"]["units"]["tank"]["customTexts"]["!Name"]["size"] = 16
  E.db["unitframe"]["units"]["tank"]["customTexts"]["!Name"]["text_format"] = "[tx:name:short]"
  E.db["unitframe"]["units"]["tank"]["customTexts"]["!Name"]["xOffset"] = 0
  E.db["unitframe"]["units"]["tank"]["customTexts"]["!Name"]["yOffset"] = 0
  E.db["unitframe"]["units"]["tank"]["enable"] = false
  E.db["unitframe"]["units"]["tank"]["name"]["text_format"] = ""
  E.db["unitframe"]["units"]["tank"]["targetsGroup"]["name"]["text_format"] = "[tx:name:short]"
  E.db["unitframe"]["units"]["target"]["CombatIcon"]["enable"] = false
  E.db["unitframe"]["units"]["target"]["aurabar"]["enable"] = false
  E.db["unitframe"]["units"]["target"]["buffs"]["countFont"] = "Arial Narrow"
  E.db["unitframe"]["units"]["target"]["buffs"]["countFontSize"] = 16
  E.db["unitframe"]["units"]["target"]["buffs"]["countPosition"] = "BOTTOM"
  E.db["unitframe"]["units"]["target"]["buffs"]["countYOffset"] = -7
  E.db["unitframe"]["units"]["target"]["buffs"]["height"] = 32
  E.db["unitframe"]["units"]["target"]["buffs"]["keepSizeRatio"] = false
  E.db["unitframe"]["units"]["target"]["buffs"]["perrow"] = 7
  E.db["unitframe"]["units"]["target"]["buffs"]["priority"] = "Blacklist,Personal,Boss,nonPersonal,CastByUnit"
  E.db["unitframe"]["units"]["target"]["buffs"]["sizeOverride"] = 43
  E.db["unitframe"]["units"]["target"]["buffs"]["spacing"] = 0
  E.db["unitframe"]["units"]["target"]["buffs"]["yOffset"] = 72
  E.db["unitframe"]["units"]["target"]["castbar"]["customTextFont"]["enable"] = true
  E.db["unitframe"]["units"]["target"]["castbar"]["customTextFont"]["font"] = "Arial Narrow"
  E.db["unitframe"]["units"]["target"]["castbar"]["customTextFont"]["fontSize"] = 14
  E.db["unitframe"]["units"]["target"]["castbar"]["customTimeFont"]["enable"] = true
  E.db["unitframe"]["units"]["target"]["castbar"]["customTimeFont"]["font"] = "Arial Narrow"
  E.db["unitframe"]["units"]["target"]["castbar"]["customTimeFont"]["fontSize"] = 14
  E.db["unitframe"]["units"]["target"]["castbar"]["height"] = 30
  E.db["unitframe"]["units"]["target"]["castbar"]["insideInfoPanel"] = false
  E.db["unitframe"]["units"]["target"]["castbar"]["strataAndLevel"]["useCustomLevel"] = true
  E.db["unitframe"]["units"]["target"]["castbar"]["textColor"] = F.Table.HexToRGB("#FFFFFF")
  E.db["unitframe"]["units"]["target"]["castbar"]["width"] = 300
  E.db["unitframe"]["units"]["target"]["castbar"]["xOffsetText"] = 2
  E.db["unitframe"]["units"]["target"]["castbar"]["xOffsetTime"] = -2
  E.db["unitframe"]["units"]["target"]["customTexts"]["!ClassIcon"]["attachTextTo"] = "Health"
  E.db["unitframe"]["units"]["target"]["customTexts"]["!ClassIcon"]["enable"] = true
  E.db["unitframe"]["units"]["target"]["customTexts"]["!ClassIcon"]["font"] = "Arial Narrow"
  E.db["unitframe"]["units"]["target"]["customTexts"]["!ClassIcon"]["fontOutline"] = "OUTLINE"
  E.db["unitframe"]["units"]["target"]["customTexts"]["!ClassIcon"]["justifyH"] = "RIGHT"
  E.db["unitframe"]["units"]["target"]["customTexts"]["!ClassIcon"]["size"] = 12
  E.db["unitframe"]["units"]["target"]["customTexts"]["!ClassIcon"]["text_format"] = "[tx:classicon]"
  E.db["unitframe"]["units"]["target"]["customTexts"]["!ClassIcon"]["xOffset"] = -6
  E.db["unitframe"]["units"]["target"]["customTexts"]["!ClassIcon"]["yOffset"] = 0
  E.db["unitframe"]["units"]["target"]["customTexts"]["!Classification"]["attachTextTo"] = "Health"
  E.db["unitframe"]["units"]["target"]["customTexts"]["!Classification"]["enable"] = true
  E.db["unitframe"]["units"]["target"]["customTexts"]["!Classification"]["font"] = "Arial Narrow"
  E.db["unitframe"]["units"]["target"]["customTexts"]["!Classification"]["fontOutline"] = "OUTLINE"
  E.db["unitframe"]["units"]["target"]["customTexts"]["!Classification"]["justifyH"] = "RIGHT"
  E.db["unitframe"]["units"]["target"]["customTexts"]["!Classification"]["size"] = 20
  E.db["unitframe"]["units"]["target"]["customTexts"]["!Classification"]["text_format"] = "[tx:classification]"
  E.db["unitframe"]["units"]["target"]["customTexts"]["!Classification"]["xOffset"] = 18
  E.db["unitframe"]["units"]["target"]["customTexts"]["!Classification"]["yOffset"] = 30
  E.db["unitframe"]["units"]["target"]["customTexts"]["!Health"]["attachTextTo"] = "Health"
  E.db["unitframe"]["units"]["target"]["customTexts"]["!Health"]["enable"] = true
  E.db["unitframe"]["units"]["target"]["customTexts"]["!Health"]["font"] = "Arial Narrow"
  E.db["unitframe"]["units"]["target"]["customTexts"]["!Health"]["fontOutline"] = "OUTLINE"
  E.db["unitframe"]["units"]["target"]["customTexts"]["!Health"]["justifyH"] = "LEFT"
  E.db["unitframe"]["units"]["target"]["customTexts"]["!Health"]["size"] = 32
  E.db["unitframe"]["units"]["target"]["customTexts"]["!Health"]["text_format"] = "[tx:health:percent:nosign]"
  E.db["unitframe"]["units"]["target"]["customTexts"]["!Health"]["xOffset"] = 12
  E.db["unitframe"]["units"]["target"]["customTexts"]["!Health"]["yOffset"] = 18
  E.db["unitframe"]["units"]["target"]["customTexts"]["!Level"]["attachTextTo"] = "Health"
  E.db["unitframe"]["units"]["target"]["customTexts"]["!Level"]["enable"] = true
  E.db["unitframe"]["units"]["target"]["customTexts"]["!Level"]["font"] = "Arial Narrow"
  E.db["unitframe"]["units"]["target"]["customTexts"]["!Level"]["fontOutline"] = "OUTLINE"
  E.db["unitframe"]["units"]["target"]["customTexts"]["!Level"]["justifyH"] = "RIGHT"
  E.db["unitframe"]["units"]["target"]["customTexts"]["!Level"]["size"] = 14
  E.db["unitframe"]["units"]["target"]["customTexts"]["!Level"]["text_format"] = "[tx:level]"
  E.db["unitframe"]["units"]["target"]["customTexts"]["!Level"]["xOffset"] = -22
  E.db["unitframe"]["units"]["target"]["customTexts"]["!Level"]["yOffset"] = -18
  E.db["unitframe"]["units"]["target"]["customTexts"]["!Power"]["attachTextTo"] = "Power"
  E.db["unitframe"]["units"]["target"]["customTexts"]["!Power"]["enable"] = true
  E.db["unitframe"]["units"]["target"]["customTexts"]["!Power"]["font"] = "Arial Narrow"
  E.db["unitframe"]["units"]["target"]["customTexts"]["!Power"]["fontOutline"] = "OUTLINE"
  E.db["unitframe"]["units"]["target"]["customTexts"]["!Power"]["justifyH"] = "LEFT"
  E.db["unitframe"]["units"]["target"]["customTexts"]["!Power"]["size"] = 20
  E.db["unitframe"]["units"]["target"]["customTexts"]["!Power"]["text_format"] = "[tx:smartpower:percent:nosign]"
  E.db["unitframe"]["units"]["target"]["customTexts"]["!Power"]["xOffset"] = 102
  E.db["unitframe"]["units"]["target"]["customTexts"]["!Power"]["yOffset"] = 0
  E.db["unitframe"]["units"]["target"]["debuffs"]["anchorPoint"] = "TOPLEFT"
  E.db["unitframe"]["units"]["target"]["debuffs"]["attachTo"] = "FRAME"
  E.db["unitframe"]["units"]["target"]["debuffs"]["countFont"] = "Arial Narrow"
  E.db["unitframe"]["units"]["target"]["debuffs"]["countFontSize"] = 16
  E.db["unitframe"]["units"]["target"]["debuffs"]["countPosition"] = "BOTTOM"
  E.db["unitframe"]["units"]["target"]["debuffs"]["countYOffset"] = -7
  E.db["unitframe"]["units"]["target"]["debuffs"]["growthX"] = "RIGHT"
  E.db["unitframe"]["units"]["target"]["debuffs"]["height"] = 32
  E.db["unitframe"]["units"]["target"]["debuffs"]["keepSizeRatio"] = false
  E.db["unitframe"]["units"]["target"]["debuffs"]["maxDuration"] = 0
  E.db["unitframe"]["units"]["target"]["debuffs"]["perrow"] = 7
  E.db["unitframe"]["units"]["target"]["debuffs"]["priority"] = "Blacklist,Boss,Personal,RaidDebuffs,CastByUnit,CCDebuffs"
  E.db["unitframe"]["units"]["target"]["debuffs"]["sizeOverride"] = 43
  E.db["unitframe"]["units"]["target"]["debuffs"]["spacing"] = 0
  E.db["unitframe"]["units"]["target"]["debuffs"]["yOffset"] = 30
  E.db["unitframe"]["units"]["target"]["disableMouseoverGlow"] = true
  E.db["unitframe"]["units"]["target"]["fader"]["enable"] = false
  E.db["unitframe"]["units"]["target"]["healPrediction"]["absorbStyle"] = "REVERSED"
  E.db["unitframe"]["units"]["target"]["health"]["text_format"] = ""
  E.db["unitframe"]["units"]["target"]["height"] = 36
  E.db["unitframe"]["units"]["target"]["name"]["text_format"] = ""
  E.db["unitframe"]["units"]["target"]["orientation"] = "LEFT"
  E.db["unitframe"]["units"]["target"]["power"]["autoHide"] = true
  E.db["unitframe"]["units"]["target"]["power"]["detachFromFrame"] = true
  E.db["unitframe"]["units"]["target"]["power"]["detachedWidth"] = 144
  E.db["unitframe"]["units"]["target"]["power"]["text_format"] = ""
  E.db["unitframe"]["units"]["target"]["raidRoleIcons"]["position"] = "TOPRIGHT"
  E.db["unitframe"]["units"]["target"]["raidRoleIcons"]["scale"] = 2
  E.db["unitframe"]["units"]["target"]["raidRoleIcons"]["xOffset"] = -6
  E.db["unitframe"]["units"]["target"]["raidRoleIcons"]["yOffset"] = 25
  E.db["unitframe"]["units"]["target"]["raidicon"]["attachTo"] = "CENTER"
  E.db["unitframe"]["units"]["target"]["raidicon"]["size"] = 29
  E.db["unitframe"]["units"]["target"]["raidicon"]["yOffset"] = 0
  E.db["unitframe"]["units"]["target"]["threatStyle"] = "NONE"
  E.db["unitframe"]["units"]["target"]["width"] = 300
  E.db["unitframe"]["units"]["targettarget"]["debuffs"]["enable"] = false
  E.db["unitframe"]["units"]["targettarget"]["disableMouseoverGlow"] = true
  E.db["unitframe"]["units"]["targettarget"]["height"] = 18
  E.db["unitframe"]["units"]["targettarget"]["name"]["text_format"] = ""
  E.db["unitframe"]["units"]["targettarget"]["power"]["enable"] = false
  E.db["unitframe"]["units"]["targettarget"]["raidicon"]["attachTo"] = "CENTER"
  E.db["unitframe"]["units"]["targettarget"]["raidicon"]["size"] = 19
  E.db["unitframe"]["units"]["targettarget"]["raidicon"]["yOffset"] = 0
  E.db["unitframe"]["units"]["targettarget"]["width"] = 120

  -- ElvUI: Private
  E.private["general"]["chatBubbleFont"] = "Arial Narrow"
  E.private["general"]["chatBubbleFontOutline"] = "OUTLINE"
  E.private["general"]["chatBubbleFontSize"] = 12
  E.private["general"]["chatBubbles"] = "disabled"
  E.private["general"]["dmgfont"] = "Arial Narrow"
  E.private["general"]["glossTex"] = "- ToxiUI"
  E.private["general"]["minimap"]["hideTracking"] = true
  E.private["general"]["namefont"] = "Arial Narrow"
  E.private["general"]["normTex"] = "- Tx Mid"
  E.private["general"]["totemTracker"] = false
  E.db["unitframe"]["units"]["boss"]["customTexts"]["!Power"]["enable"] = false
  E.db["unitframe"]["units"]["boss"]["spacing"] = 42
  E.db["unitframe"]["units"]["party"]["customTexts"]["!Name"]["size"] = 20
  E.db["unitframe"]["units"]["party"]["customTexts"]["!Name"]["xOffset"] = 0
  E.db["unitframe"]["units"]["party"]["customTexts"]["!Name"]["yOffset"] = 28
  E.db["unitframe"]["units"]["party"]["customTexts"]["!Power"]["enable"] = false
  E.db["unitframe"]["units"]["party"]["power"]["height"] = 8
  E.db["unitframe"]["units"]["party"]["verticalSpacing"] = 34
  E.db["unitframe"]["units"]["party"]["width"] = 210
  E.db["unitframe"]["units"]["player"]["customTexts"]["!Power"]["enable"] = false
  E.db["unitframe"]["units"]["player"]["customTexts"]["!Power"]["justifyH"] = "CENTER"
  E.db["unitframe"]["units"]["player"]["customTexts"]["!Power"]["xOffset"] = 0
  E.db["unitframe"]["units"]["player"]["customTexts"]["!Power"]["yOffset"] = 6
  E.db["unitframe"]["units"]["player"]["power"]["text_format"] = ""
  E.db["unitframe"]["units"]["player"]["power"]["width"] = "spaced"
  E.db["unitframe"]["units"]["target"]["castbar"]["customTextFont"]["fontSize"] = 16
  E.db["unitframe"]["units"]["target"]["castbar"]["customTimeFont"]["fontSize"] = 16
end

function LAEV:SetupAdditionalAddons()
  if F.IsAddOnEnabled("ElvUI_WindTools") then
    E.db["WT"]["combat"]["raidMarkers"]["enable"] = false
    E.db["movers"]["WTParagonReputationToastFrameMover"] = "TOP,UIParent,TOP,0,-182"
    E.private["WT"]["maps"]["instanceDifficulty"]["enable"] = true
    E.private["WT"]["maps"]["minimapButtons"]["backdropSpacing"] = 2
    E.private["WT"]["maps"]["minimapButtons"]["buttonsPerRow"] = 3
    E.private["WT"]["maps"]["minimapButtons"]["mouseOver"] = true
    E.private["WT"]["maps"]["minimapButtons"]["spacing"] = 6
    E.private["WT"]["maps"]["superTracker"]["enable"] = false
    E.private["WT"]["maps"]["worldMap"]["enable"] = false
    E.private["WT"]["maps"]["worldMap"]["scale"]["enable"] = false
    E.private["WT"]["quest"]["objectiveTracker"]["cosmeticBar"]["width"] = 164
    E.private["WT"]["quest"]["objectiveTracker"]["cosmeticBar"]["widthMode"] = "DYNAMIC"
    E.private["WT"]["quest"]["objectiveTracker"]["header"]["classColor"] = true
    E.private["WT"]["quest"]["objectiveTracker"]["header"]["size"] = 24
    E.private["WT"]["quest"]["objectiveTracker"]["info"]["size"] = 14
    E.private["WT"]["quest"]["objectiveTracker"]["title"]["size"] = 16
    E.private["WT"]["quest"]["objectiveTracker"]["titleColor"]["customColorHighlight"] = F.Table.HexToRGB("#FFD259")
    E.private["WT"]["quest"]["objectiveTracker"]["titleColor"]["customColorNormal"] = F.Table.HexToRGB("#FFC733")
    E.private["WT"]["skins"]["addons"]["weakAuras"] = false
    E.private["WT"]["skins"]["elvui"]["enable"] = false
    E.private["WT"]["skins"]["removeParchment"] = false
    E.private["WT"]["skins"]["shadow"] = false
    E.private["WT"]["skins"]["widgets"]["button"]["backdrop"]["classColor"] = true
    E.private["WT"]["skins"]["widgets"]["button"]["backdrop"]["color"] = F.Table.HexToRGB("#18A8FF")
    E.private["WT"]["skins"]["widgets"]["button"]["backdrop"]["texture"] = "- Tx Fade"
    E.private["WT"]["skins"]["widgets"]["button"]["selected"]["backdropAlpha"] = 1
    E.private["WT"]["skins"]["widgets"]["button"]["selected"]["backdropClassColor"] = true
    E.private["WT"]["skins"]["widgets"]["button"]["selected"]["backdropColor"] = F.Table.HexToRGB("#18A8FF")
    E.private["WT"]["skins"]["widgets"]["button"]["selected"]["borderAlpha"] = 0.4
    E.private["WT"]["skins"]["widgets"]["button"]["selected"]["borderClassColor"] = true
    E.private["WT"]["skins"]["widgets"]["button"]["selected"]["borderColor"] = F.Table.HexToRGB("#18A8FF")
    E.private["WT"]["skins"]["widgets"]["slider"]["classColor"] = true
    E.private["WT"]["skins"]["widgets"]["slider"]["color"] = F.Table.HexToRGB("#18A8FF")
    E.private["WT"]["skins"]["widgets"]["slider"]["texture"] = "- ToxiUI"
    E.private["WT"]["skins"]["widgets"]["tab"]["backdrop"]["classColor"] = true
    E.private["WT"]["skins"]["widgets"]["tab"]["backdrop"]["color"] = F.Table.HexToRGB("#18A8FF")
    E.private["WT"]["skins"]["widgets"]["tab"]["backdrop"]["texture"] = "- Tx Fade"
    E.private["WT"]["skins"]["widgets"]["tab"]["selected"]["backdropClassColor"] = true
    E.private["WT"]["skins"]["widgets"]["tab"]["selected"]["backdropColor"] = F.Table.HexToRGB("#18A8FF")
    E.private["WT"]["skins"]["widgets"]["tab"]["selected"]["borderAlpha"] = 0.4
    E.private["WT"]["skins"]["widgets"]["tab"]["selected"]["borderClassColor"] = true
    E.private["WT"]["skins"]["widgets"]["tab"]["selected"]["borderColor"] = F.Table.HexToRGB("#18A8FF")
    E.private["WT"]["skins"]["widgets"]["tab"]["selected"]["texture"] = "- Tx Fade"
    E.private["WT"]["skins"]["widgets"]["tab"]["text"]["normalClassColor"] = true
    E.private["WT"]["skins"]["widgets"]["tab"]["text"]["normalColor"] = F.Table.HexToRGB("#18A8FF")
    E.private["WT"]["skins"]["widgets"]["treeGroupButton"]["backdrop"]["classColor"] = true
    E.private["WT"]["skins"]["widgets"]["treeGroupButton"]["backdrop"] = F.Table.HexToRGB("#18A8FF")
    E.private["WT"]["skins"]["widgets"]["treeGroupButton"]["backdrop"]["texture"] = "- Tx Fade"
    E.private["WT"]["skins"]["widgets"]["treeGroupButton"]["selected"]["backdropClassColor"] = true
    E.private["WT"]["skins"]["widgets"]["treeGroupButton"]["selected"]["backdropColor"] = F.Table.HexToRGB("#18A8FF")
    E.private["WT"]["skins"]["widgets"]["treeGroupButton"]["selected"]["borderAlpha"] = 0.4
    E.private["WT"]["skins"]["widgets"]["treeGroupButton"]["selected"]["borderClassColor"] = true
    E.private["WT"]["skins"]["widgets"]["treeGroupButton"]["selected"]["borderColor"] = F.Table.HexToRGB("#18A8FF")
    E.private["WT"]["skins"]["widgets"]["treeGroupButton"]["selected"]["texture"] = "- Tx Fade"
    E.private["WT"]["skins"]["widgets"]["treeGroupButton"]["text"]["normalClassColor"] = true
    E.private["WT"]["skins"]["widgets"]["treeGroupButton"]["text"]["normalColor"] = F.Table.HexToRGB("#18A8FF")
    E.private["WT"]["unitFrames"]["roleIcon"]["enable"] = false
  end

  local function configureCustomText(unit, nameFormat, justifyH, xOffset, yOffset)
    E.db["unitframe"]["units"][unit]["customTexts"]["!Name"]["attachTextTo"] = "Health"
    E.db["unitframe"]["units"][unit]["customTexts"]["!Name"]["enable"] = true
    E.db["unitframe"]["units"][unit]["customTexts"]["!Name"]["font"] = "Arial Narrow"
    E.db["unitframe"]["units"][unit]["customTexts"]["!Name"]["fontOutline"] = "OUTLINE"
    E.db["unitframe"]["units"][unit]["customTexts"]["!Name"]["justifyH"] = justifyH
    E.db["unitframe"]["units"][unit]["customTexts"]["!Name"]["size"] = 16
    E.db["unitframe"]["units"][unit]["customTexts"]["!Name"]["text_format"] = nameFormat
    E.db["unitframe"]["units"][unit]["customTexts"]["!Name"]["xOffset"] = xOffset
    E.db["unitframe"]["units"][unit]["customTexts"]["!Name"]["yOffset"] = yOffset
  end

  if F.IsAddOnEnabled("!KMediaTags") then
    local unitConfigurations = {
      { "boss", "[kmt-name:caps{10}]", "RIGHT", -6, 24 },
      { "party", "[kmt-name:caps{11}]", "LEFT", 0, 24 },
      { "pet", "[kmt-name:caps{7}]", "CENTER", 0, 18 },
      { "raid1", "[kmt-name:caps{5}]", "CENTER", 0, 0 },
      { "raid2", "[kmt-name:caps{5}]", "CENTER", 0, 0 },
      { "raid3", "[kmt-name:caps{5}]", "CENTER", 0, 0 },
      { "target", "[kmt-name:caps{11}]", "RIGHT", -6, 28 },
      { "targettarget", "[kmt-name:caps{8}]", "CENTER", 0, 18 },
    }

    for _, config in ipairs(unitConfigurations) do
      configureCustomText(unpack(config))
    end
    E.private["WT"]["quest"]["objectiveTracker"]["cosmeticBar"]["width"] = 164
    E.private["WT"]["quest"]["objectiveTracker"]["cosmeticBar"]["widthMode"] = "DYNAMIC"
    E.private["WT"]["quest"]["objectiveTracker"]["header"]["size"] = 20
    E.private["WT"]["skins"]["blizzard"]["enable"] = true
  end
end

LAEV:AddCallback("SetupProfile")
LAEV:AddCallback("SetupAdditionalAddons")

--@end-do-not-package@
