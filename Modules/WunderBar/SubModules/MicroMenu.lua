local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local WB = TXUI:GetModule("WunderBar")
local CL = TXUI:GetModule("Changelog")
local MM = WB:NewModule("MicroMenu", "AceHook-3.0")
local DT = E:GetModule("DataTexts")

local _G = _G
local abs = math.abs
local AddonList = AddonList
local BNGetNumFriends = BNGetNumFriends
local C_BattleNet_GetFriendAccountInfo = C_BattleNet.GetFriendAccountInfo
local C_BattleNet_GetFriendGameAccountInfo = C_BattleNet.GetFriendGameAccountInfo
local C_BattleNet_GetFriendNumGameAccounts = C_BattleNet.GetFriendNumGameAccounts
local C_FriendList_GetNumOnlineFriends = C_FriendList.GetNumOnlineFriends
local CloseAllWindows = CloseAllWindows
local CloseMenus = CloseMenus
local CreateFrame = CreateFrame
local format = string.format
local FormatBindingKeyIntoText = FormatBindingKeyIntoText
local GameMenuFrame = GameMenuFrame
local GetAddOnMetadata = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata
local GetCVarBool = GetCVarBool
local GetNumGuildMembers = GetNumGuildMembers
local HideUIPanel = HideUIPanel
local InCombatLockdown = InCombatLockdown
local ipairs = ipairs
local IsInGuild = IsInGuild
local next = next
local pairs = pairs
local PlayerSpellsUtil = PlayerSpellsUtil
local PlaySound = PlaySound
local select = select
local ShowUIPanel = ShowUIPanel
local sort = sort
local tinsert = table.insert
local ToggleChannelFrame = ToggleChannelFrame
local ToggleCharacter = ToggleCharacter
local ToggleCollectionsJournal = _G.ToggleCollectionsJournal
local ToggleFriendsFrame = ToggleFriendsFrame
local ToggleGuildFrame = ToggleGuildFrame
local TogglePVPUI = TXUI.IsRetail and TogglePVPUI or TogglePVPFrame
local UIErrorsFrame = UIErrorsFrame
local UnitLevel = UnitLevel

local ACHIEVEMENTS = ACHIEVEMENTS
local ADDONS = ADDONS
local ADVENTURE_JOURNAL = ADVENTURE_JOURNAL
local BINDING_NAME_TOGGLEACHIEVEMENT = BINDING_NAME_TOGGLEACHIEVEMENT
local BINDING_NAME_TOGGLECHARACTER0 = BINDING_NAME_TOGGLECHARACTER0
local BINDING_NAME_TOGGLECHARACTER4 = BINDING_NAME_TOGGLECHARACTER4
local BINDING_NAME_TOGGLECHATTAB = BINDING_NAME_TOGGLECHATTAB
local BINDING_NAME_TOGGLEENCOUNTERJOURNAL = BINDING_NAME_TOGGLEENCOUNTERJOURNAL
local BINDING_NAME_TOGGLEGAMEMENU = BINDING_NAME_TOGGLEGAMEMENU
local BINDING_NAME_TOGGLEGUILDTAB = BINDING_NAME_TOGGLEGUILDTAB
local BINDING_NAME_TOGGLELFGPARENT = BINDING_NAME_TOGGLELFGPARENT
local BINDING_NAME_TOGGLEQUESTLOG = BINDING_NAME_TOGGLEQUESTLOG
local BINDING_NAME_TOGGLESOCIAL = BINDING_NAME_TOGGLESOCIAL
local BINDING_NAME_TOGGLESPELLBOOK = BINDING_NAME_TOGGLESPELLBOOK
local BINDING_NAME_TOGGLETALENTS = BINDING_NAME_TOGGLETALENTS
local BLIZZARD_STORE = BLIZZARD_STORE
local BNET_CLIENT_WOW = BNET_CLIENT_WOW
local CHARACTER_BUTTON = CHARACTER_BUTTON
local CHAT = CHAT
local COLLECTIONS = COLLECTIONS
local DUNGEONS_BUTTON = DUNGEONS_BUTTON
local ERR_NOT_IN_COMBAT = ERR_NOT_IN_COMBAT
local GUILD_AND_COMMUNITIES = GUILD_AND_COMMUNITIES
local HELP_BUTTON = HELP_BUTTON
local MAINMENU_BUTTON = MAINMENU_BUTTON
local NEWBIE_TOOLTIP_ACHIEVEMENT = NEWBIE_TOOLTIP_ACHIEVEMENT
local NEWBIE_TOOLTIP_CHARACTER = NEWBIE_TOOLTIP_CHARACTER
local NEWBIE_TOOLTIP_CHATMENU = NEWBIE_TOOLTIP_CHATMENU
local NEWBIE_TOOLTIP_ENCOUNTER_JOURNAL = NEWBIE_TOOLTIP_ENCOUNTER_JOURNAL
local NEWBIE_TOOLTIP_HELP = NEWBIE_TOOLTIP_HELP
local NEWBIE_TOOLTIP_LFGPARENT = NEWBIE_TOOLTIP_LFGPARENT
local NEWBIE_TOOLTIP_MAINMENU = NEWBIE_TOOLTIP_MAINMENU
local NEWBIE_TOOLTIP_MOUNTS_AND_PETS = NEWBIE_TOOLTIP_MOUNTS_AND_PETS
local NEWBIE_TOOLTIP_PVP = NEWBIE_TOOLTIP_PVP
local NEWBIE_TOOLTIP_QUESTLOG = NEWBIE_TOOLTIP_QUESTLOG
local NEWBIE_TOOLTIP_SPELLBOOK = NEWBIE_TOOLTIP_SPELLBOOK
local NEWBIE_TOOLTIP_TALENTS = NEWBIE_TOOLTIP_TALENTS
local PVP_OPTIONS = PVP_OPTIONS
local QUESTLOG_BUTTON = QUESTLOG_BUTTON
local SLASH_ACHIEVEMENTUI1 = SLASH_ACHIEVEMENTUI1
local SOCIAL_BUTTON = SOCIAL_BUTTON
local SPELLBOOK_ABILITIES_BUTTON = SPELLBOOK_ABILITIES_BUTTON
local TALENTS_BUTTON = TALENTS_BUTTON
local UNKNOWN = UNKNOWN
local WOW_PROJECT_MAINLINE = WOW_PROJECT_MAINLINE

MM.leftButtonText = "|cffFFFFFFLeft Click:|r "
MM.rightButtonText = "|cffFFFFFFRight Click:|r "

local function ToggleGroupFinder()
  if TXUI.IsRetail then
    _G.ToggleLFDParentFrame()
  else
    _G.PVEFrame_ToggleFrame()
  end
end

local lfgLevelRequirement = TXUI.IsMists and 15 or 10

MM.microMenu = {
  ["ach"] = {
    available = not TXUI.IsVanilla,
    name = ACHIEVEMENTS,
    macro = {
      LeftButton = SLASH_ACHIEVEMENTUI1,
    },
    keyBind = "TOGGLEACHIEVEMENT",
    newbieTooltip = NEWBIE_TOOLTIP_ACHIEVEMENT,
    tooltips = { MM.leftButtonText .. BINDING_NAME_TOGGLEACHIEVEMENT },
  },
  ["char"] = {
    name = CHARACTER_BUTTON,
    click = {
      LeftButton = function()
        if not InCombatLockdown() then
          ToggleCharacter("PaperDollFrame")
        else
          UIErrorsFrame:AddMessage(E.InfoColor .. ERR_NOT_IN_COMBAT)
        end
      end,
    },
    macro = {
      RightButton = "/narci",
    },
    keyBind = "TOGGLECHARACTER0",
    newbieTooltip = NEWBIE_TOOLTIP_CHARACTER,
    tooltips = { MM.leftButtonText .. BINDING_NAME_TOGGLECHARACTER0, MM.rightButtonText .. "Toggle Narcissus" },
  },
  ["pet"] = {
    available = not TXUI.IsVanilla,
    name = COLLECTIONS,
    click = {
      LeftButton = function()
        ToggleCollectionsJournal()
      end,
    },
    macro = {
      RightButton = "/run CollectionsJournal_LoadUI()\n/click MountJournalSummonRandomFavoriteButton",
    },
    keyBind = "TOGGLECOLLECTIONS",
    newbieTooltip = NEWBIE_TOOLTIP_MOUNTS_AND_PETS,
    tooltips = { MM.leftButtonText .. "Toggle Collections", TXUI.IsRetail and MM.rightButtonText .. "Random Favorite Mount" or "" },
  },
  ["journal"] = {
    name = ADVENTURE_JOURNAL,
    available = not TXUI.IsVanilla,
    macro = {
      LeftButton = "/click EJMicroButton",
      RightButton = TXUI.IsRetail and "/run WeeklyRewards_LoadUI(); if WeeklyRewardsFrame:IsShown() then WeeklyRewardsFrame:Hide() else WeeklyRewardsFrame:Show() end" or nil,
    },
    keyBind = "TOGGLEENCOUNTERJOURNAL",
    newbieTooltip = NEWBIE_TOOLTIP_ENCOUNTER_JOURNAL,
    tooltips = {
      MM.leftButtonText .. BINDING_NAME_TOGGLEENCOUNTERJOURNAL,
      TXUI.IsRetail and MM.rightButtonText .. "Show Weekly Rewards" or "",
    },
  },
  ["menu"] = {
    name = MAINMENU_BUTTON,
    special = true,
    click = {
      LeftButton = function()
        if not InCombatLockdown() then
          if not GameMenuFrame:IsShown() then
            CloseMenus()
            CloseAllWindows()
            PlaySound(850)
            ShowUIPanel(GameMenuFrame)
          else
            PlaySound(854)
            HideUIPanel(GameMenuFrame)
          end
        else
          UIErrorsFrame:AddMessage(E.InfoColor .. ERR_NOT_IN_COMBAT)
        end
      end,
      RightButton = function()
        if not InCombatLockdown() then
          ShowUIPanel(AddonList)
        else
          UIErrorsFrame:AddMessage(E.InfoColor .. ERR_NOT_IN_COMBAT)
        end
      end,
    },
    keyBind = "TOGGLEGAMEMENU",
    newbieTooltip = NEWBIE_TOOLTIP_MAINMENU,
    tooltips = { MM.leftButtonText .. BINDING_NAME_TOGGLEGAMEMENU, MM.rightButtonText .. ADDONS },
  },
  ["lfg"] = {
    available = not TXUI.IsVanilla and UnitLevel("player") >= lfgLevelRequirement,
    name = DUNGEONS_BUTTON,
    click = {
      LeftButton = function()
        if not InCombatLockdown() then
          ToggleGroupFinder()
        else
          UIErrorsFrame:AddMessage(E.InfoColor .. ERR_NOT_IN_COMBAT)
        end
      end,
    },
    keyBind = "TOGGLEGROUPFINDER",
    newbieTooltip = NEWBIE_TOOLTIP_LFGPARENT,
    tooltips = { MM.leftButtonText .. BINDING_NAME_TOGGLELFGPARENT },
  },
  ["guild"] = {
    name = TXUI.IsRetail and GUILD_AND_COMMUNITIES or "Guild",
    info = true,
    keyBind = "TOGGLEGUILDTAB",
    tooltips = { MM.leftButtonText .. BINDING_NAME_TOGGLEGUILDTAB, MM.rightButtonText .. "Quick Menu" },
    click = {
      LeftButton = function()
        if not InCombatLockdown() then
          ToggleGuildFrame()
        else
          UIErrorsFrame:AddMessage(E.InfoColor .. ERR_NOT_IN_COMBAT)
        end
      end,

      RightButton = function(frame)
        local dtModule = WB:GetElvUIDataText("Guild")

        if dtModule then
          dtModule.eventFunc(MM.guildVirtualFrame, "GUILD_ROSTER_UPDATE")
          dtModule.onClick(frame, "RightButton")
        end
      end,
    },
  },
  ["social"] = {
    name = SOCIAL_BUTTON,
    info = true,
    keyBind = "TOGGLESOCIAL",
    tooltips = { MM.leftButtonText .. BINDING_NAME_TOGGLESOCIAL, MM.rightButtonText .. "Quick Menu" },
    click = {
      LeftButton = function()
        if not InCombatLockdown() then
          ToggleFriendsFrame(1)
        else
          UIErrorsFrame:AddMessage(E.InfoColor .. ERR_NOT_IN_COMBAT)
        end
      end,
      RightButton = function(frame)
        local dtModule = WB:GetElvUIDataText("Friends")

        if dtModule then
          dtModule.eventFunc(MM.friendsVirtualFrame, nil)
          dtModule.onClick(frame, "RightButton")
        end
      end,
    },
  },
  ["spell"] = {
    name = SPELLBOOK_ABILITIES_BUTTON,
    click = {
      LeftButton = function()
        if PlayerSpellsUtil then
          PlayerSpellsUtil.ToggleSpellBookFrame()
        else
          ToggleFrame(_G.SpellBookFrame)
        end
      end,

      -- On Vanilla & Mists of Pandaria the professions are part of the spellbook
      RightButton = TXUI.IsRetail and _G.ProfessionMicroButton.OnClick or E.noop,
    },
    keyBind = "TOGGLESPELLBOOK",
    newbieTooltip = NEWBIE_TOOLTIP_SPELLBOOK,
    tooltips = { MM.leftButtonText .. BINDING_NAME_TOGGLESPELLBOOK, TXUI.IsRetail and MM.rightButtonText .. BINDING_NAME_TOGGLEPROFESSIONBOOK or nil },
  },
  ["talent"] = {
    name = TALENTS_BUTTON,
    click = {
      LeftButton = function()
        if PlayerSpellsUtil then
          PlayerSpellsUtil.ToggleClassTalentFrame()
        else
          _G.ToggleTalentFrame()
        end
      end,
    },
    keyBind = "TOGGLETALENTS",
    newbieTooltip = NEWBIE_TOOLTIP_TALENTS,
    tooltips = { MM.leftButtonText .. BINDING_NAME_TOGGLETALENTS },
  },
  ["quest"] = {
    name = QUESTLOG_BUTTON,
    macro = {
      LeftButton = "/click QuestLogMicroButton",
    },
    keyBind = "TOGGLEQUESTLOG",
    newbieTooltip = NEWBIE_TOOLTIP_QUESTLOG,
    tooltips = { MM.leftButtonText .. BINDING_NAME_TOGGLEQUESTLOG },
  },
  ["pvp"] = {
    name = PVP_OPTIONS,
    click = {
      LeftButton = function()
        if not InCombatLockdown() then
          if TXUI.IsVanilla then
            ToggleCharacter("HonorFrame")
          else
            TogglePVPUI()
          end
        else
          UIErrorsFrame:AddMessage(E.InfoColor .. ERR_NOT_IN_COMBAT)
        end
      end,
    },
    keyBind = "TOGGLECHARACTER4",
    newbieTooltip = NEWBIE_TOOLTIP_PVP,
    tooltips = { MM.leftButtonText .. BINDING_NAME_TOGGLECHARACTER4 },
  },
  ["help"] = {
    name = HELP_BUTTON,
    macro = {
      LeftButton = "/click HelpMicroButton",
    },
    keyBind = false,
    newbieTooltip = NEWBIE_TOOLTIP_HELP,
    tooltips = { MM.leftButtonText .. "Toggle Help Frame" },
  },
  ["shop"] = {
    available = TXUI.IsRetail,
    name = BLIZZARD_STORE,
    macro = {
      LeftButton = "/click StoreMicroButton",
    },
    keyBind = false,
    newbieTooltip = false,
    tooltips = { MM.leftButtonText .. "Toggle " .. BLIZZARD_STORE },
  },
  ["chat"] = {
    name = CHAT,
    click = {
      LeftButton = function()
        ToggleChannelFrame()
      end,
    },
    keyBind = "TOGGLECHATTAB",
    newbieTooltip = NEWBIE_TOOLTIP_CHATMENU,
    tooltips = { MM.leftButtonText .. BINDING_NAME_TOGGLECHATTAB },
  },
  ["txui"] = {
    special = true,
    name = TXUI.Title,
    click = {
      LeftButton = function()
        if not CL:HasSeenChangelog() then
          E.db.TXUI.changelog.seenVersion = TXUI.ReleaseVersion
          E:StaticPopup_Hide("TXUI_OPEN_CHANGELOG")
          E:ToggleOptions("TXUI,changelog")
        else
          E:ToggleOptions("TXUI")
        end
      end,
      RightButton = function()
        E:ToggleOptions("TXUI,changelog")
      end,
    },
  },
}

MM.microMenuOrder = {
  "menu",
  "chat",
  "guild",
  "social",
  "char",
  "spell",
  "talent",
  "ach",
  "quest",
  "lfg",
  "journal",
  "pvp",
  "pet",
  "shop",
  "help",
  "txui",
}

function MM:UpdateIcons()
  for i, _ in ipairs(self.frames) do
    local frame = self.frames[i]
    local settings = self.db.icons[frame.id]

    if settings.enabled then
      -- Button
      frame:SetSize(self.db.general.iconFontSize, self.db.general.iconFontSize)

      -- Icon
      WB:SetIconFromDB(self.db.general, "icon", frame.icon, false)

      if frame.id == "txui" and (not CL:HasSeenChangelog()) then
        WB:StartColorFlash(frame.icon, 1, WB:GetFontIconColor(), I.Strings.Branding.ColorRGBA)
      else
        WB:SetFontIconColor(frame.icon)
      end

      if frame.id == "pvp" then
        if E.myfaction == "Alliance" then
          frame.icon:SetText(settings.icon_a)
        elseif E.myfaction == "Horde" then
          frame.icon:SetText(settings.icon_h)
        else
          frame.icon:SetText(settings.icon)
        end
      else
        frame.icon:SetText(settings.icon)
      end

      -- Info Text
      if frame.infoText then
        WB:SetFontFromDB(self.db.general, "info", frame.infoText, true, self.db.general.infoUseAccent)

        frame.infoText:SetPoint("CENTER", 0, WB.dirMulti * self.db.general.infoOffset)

        if self.db.general.infoEnabled then
          frame.infoText:Show()
        else
          frame.infoText:Hide()
        end
      end
    end
  end
end

local function pluginSort(a, b)
  local A, B = a.title or a.name, b.title or b.name
  if A and B then return F.String.Strip(A) < F.String.Strip(B) end
end

function MM:ToxiUITooltip(button)
  DT.tooltip:SetOwner(button, "ANCHOR_TOP", 0, 20)
  DT.tooltip:AddDoubleLine(TXUI.Title, format(" |cff99ff33%s|r", CL:FormattedVersion()))

  DT.tooltip:AddLine(" ")
  DT.tooltip:AddDoubleLine("AddOns:", "Version:")

  do
    local addOnData = {}

    for _, addOn in ipairs { "ElvUI", "Details", "Plater", "BigWigs", "WeakAuras", "WarpDeplete", "OmniCD", "BugGrabber", "BugSack" } do
      if F.IsAddOnEnabled(addOn) then
        local data = {}
        data.name = GetAddOnMetadata(addOn, "Title") or addOn
        data.version = F.String.Strip(GetAddOnMetadata(addOn, "Version")) or UNKNOWN

        if addOn == "ElvUI" then data.version = E.versionString end

        if addOn == "Details" then
          data.name = "Details!"
          data.version = Details.GetVersionString()
        end

        tinsert(addOnData, data)
      end
    end

    if next(addOnData) then
      sort(addOnData, pluginSort)
      local r, g, b = E:HexToRGB("33ff33")

      for i = 1, #addOnData do
        local data = addOnData[i]
        DT.tooltip:AddDoubleLine(data.title or data.name, data.version, 1, 1, 1, r / 255, g / 255, b / 255)
      end
    end
  end

  do
    local pluginData = {}

    for _, data in pairs(E.Libs.EP.plugins) do
      if data and (not data.isLib and (not data.name or data.name ~= TXUI.AddOnName)) then tinsert(pluginData, data) end
    end

    if next(pluginData) then
      sort(pluginData, pluginSort)

      for i = 1, #pluginData do
        local data = pluginData[i]
        local name = data.title or data.name or UNKNOWN
        local version = F.String.Strip(data.version) or UNKNOWN
        local color = (data.old or version == "") and "ff3333" or "33ff33"
        local r, g, b = E:HexToRGB(color)
        DT.tooltip:AddDoubleLine(name, version, 1, 1, 1, r / 255, g / 255, b / 255)
      end
    end
  end

  if not CL:HasSeenChangelog() then
    DT.tooltip:AddLine(" ")
    DT.tooltip:AddLine(F.String.ToxiUI("New Update Installed!"))
    DT.tooltip:AddLine("|cffFFFFFFLeft Click:|r Click to open " .. TXUI.Title .. " Changelog")
  else
    DT.tooltip:AddLine(" ")
    DT.tooltip:AddLine("|cffFFFFFFLeft Click:|r Toggle " .. TXUI.Title .. " Configuration")
    DT.tooltip:AddLine("|cffFFFFFFRight Click:|r Open " .. TXUI.Title .. " Changelog")
  end

  DT.tooltip:Show()
end

function MM:ButtonEnter(button)
  WB:SetFontAccentColor(button.icon)

  local skipTitle = false

  if button.id == "social" then
    DT.tooltip:SetOwner(button, "ANCHOR_TOP", 0, 20)

    local dtModule = WB:GetElvUIDataText("Friends")

    if dtModule then
      dtModule.eventFunc(MM.friendsVirtualFrame, nil)
      dtModule.onEnter()
      skipTitle = true
    end
  elseif button.id == "guild" then
    DT.tooltip:SetOwner(button, "ANCHOR_TOP", 0, 20)

    local dtModule = WB:GetElvUIDataText("Guild")

    if dtModule then
      dtModule.eventFunc(MM.guildVirtualFrame, "GUILD_ROSTER_UPDATE")
      dtModule.onEnter()
      skipTitle = true
    end
  elseif button.id == "txui" then
    self:ToxiUITooltip(button)
    return
  end

  if button.info.tooltips and self.db.general.additionalTooltips then
    if skipTitle then skipTitle = DT.tooltip:IsShown() end

    if not skipTitle then
      DT.tooltip:SetOwner(button, "ANCHOR_TOP", 0, 20)

      if button.info.keyBind then
        DT.tooltip:AddLine(FormatBindingKeyIntoText(button.info.name, button.info.keyBind, "%s %s", "|cffffffff(%s)|r"))
      else
        DT.tooltip:AddLine(button.info.name)
      end

      if button.info.newbieTooltip and self.db.general.newbieToolips then
        DT.tooltip:AddLine(" ")
        DT.tooltip:AddLine(button.info.newbieTooltip, nil, nil, nil, true)
      end
    end

    DT.tooltip:AddLine(" ")
    for i, _ in ipairs(button.info.tooltips) do
      DT.tooltip:AddLine(button.info.tooltips[i], nil, nil, nil, true)
    end

    DT.tooltip:Show()
  end
end

function MM:ButtonLeave(button)
  if button.id == "txui" and (not CL:HasSeenChangelog()) then
    WB:StartColorFlash(button.icon, 1, WB:GetFontColorFromDB(self.db.general, "icon"), I.Strings.Branding.ColorRGBA)
  else
    WB:SetFontIconColor(button.icon)
  end
end

function MM:PositionButtons()
  local anchorPoint = WB:GetGrowDirection(self.Module, true)
  local growPoint = WB:GetGrowDirection(self.Module)
  local maxWidth = WB:GetMaxWidth(self.Module)
  local lastFrame = self.frame
  local currentWidth = 0

  for i, _ in ipairs(self.frames) do
    if self.frames[i].info.special then currentWidth = currentWidth + self.db.general.iconFontSize + self.db.general.iconSpacing end
  end

  for i, _ in ipairs(self.frames) do
    local frame = self.frames[i]
    local settings = self.db.icons[frame.id]

    if settings.enabled then
      local point = (i == 1) and anchorPoint or growPoint
      local padding = (i == 1) and 0 or (self.db.general.iconFontSize + self.db.general.iconSpacing)
      padding = growPoint == "LEFT" and -padding or padding
      if frame.info.special ~= true then currentWidth = currentWidth + abs(padding) end

      frame:ClearAllPoints()

      if (currentWidth < maxWidth) or (frame.info.special == true) then
        frame:SetPoint(point, lastFrame, point, padding, 0)
        frame:Show()
        lastFrame = frame
      else
        frame:Hide()
      end
    else
      frame:Hide()
    end
  end
end

function MM:CreateButtons()
  local function createMicroMenuButton(name, info)
    local frame = CreateFrame("BUTTON", nil, self.frame, "SecureActionButtonTemplate")
    frame:RegisterForClicks(GetCVarBool("ActionButtonUseKeyDown") and "AnyDown" or "AnyUp")

    frame.id = name
    frame.info = info

    local leftButton, rightButton = false, false

    -- Reset everything
    frame:SetAttribute("type1", nil)
    frame:SetAttribute("type2", nil)
    frame:SetAttribute("macrotext1", nil)
    frame:SetAttribute("macrotext2", nil)
    frame:SetAttribute("clickbutton", nil)
    frame.Click = nil

    if info.macro then
      if info.macro.LeftButton then
        frame:SetAttribute("type1", "macro")
        frame:SetAttribute("macrotext1", info.macro.LeftButton)
        leftButton = true
      end

      if info.macro.RightButton then
        frame:SetAttribute("type2", "macro")
        frame:SetAttribute("macrotext2", info.macro.RightButton)
        rightButton = true
      end
    end

    if info.click then
      local needClickHandler = false

      if info.click.LeftButton and not leftButton then
        frame:SetAttribute("type1", "click")
        needClickHandler = true
      end

      if (info.click.LeftButton or info.click.RightButton) and not rightButton then
        frame:SetAttribute("type2", "click")
        needClickHandler = true
      end

      if needClickHandler then
        function frame:Click(mouseButton)
          local func = mouseButton and info.click[mouseButton]

          if func then
            DT.tooltip:Hide()
            func(self, frame)
          end
        end

        frame:SetAttribute("clickbutton", frame)
      end
    end

    self:HookScript(frame, "OnEnter", function(...)
      WB:ModuleOnEnter(self, ...)
    end)

    self:HookScript(frame, "OnLeave", function(...)
      WB:ModuleOnLeave(self, ...)
    end)

    frame.infoText = frame:CreateFontString(nil, "OVERLAY")
    frame.icon = frame:CreateFontString(nil, "OVERLAY")
    frame.icon:SetPoint("CENTER")
    -- Not working in Mists of Pandaria? Maybe not needed at all?
    -- frame.icon:SetJustifyH("BOTTOM")

    self.frameNames[name] = frame
    tinsert(self.frames, frame)
  end

  for _, name in ipairs(MM.microMenuOrder) do
    local info = MM.microMenu[name]
    if info.available ~= false then createMicroMenuButton(name, info) end
  end
end

function MM:CheckGameInfo(gameAccountInfo)
  if not gameAccountInfo then return false end
  if not gameAccountInfo.isOnline then return false end
  if gameAccountInfo.clientProgram ~= BNET_CLIENT_WOW then return false end
  if self.db.general.onlyFriendsWoWRetail and gameAccountInfo.wowProjectID ~= WOW_PROJECT_MAINLINE then return false end
  return true
end

function MM:OnEvent(event)
  -- Friend counter
  if
    (self.db.general.infoEnabled and self.db.icons.social.enabled)
    and (
      event == "ELVUI_FORCE_UPDATE"
      or event == "BN_FRIEND_INFO_CHANGED"
      or event == "BN_FRIEND_ACCOUNT_ONLINE"
      or event == "BN_FRIEND_ACCOUNT_OFFLINE"
      or event == "FRIENDLIST_UPDATE"
      or event == "CHAT_MSG_SYSTEM"
    )
  then
    local number = C_FriendList_GetNumOnlineFriends() or 0
    local _, numBNOnlineFriends = BNGetNumFriends()

    if self.db.general.onlyFriendsWoW then
      for i = 1, numBNOnlineFriends do
        local accountInfo = C_BattleNet_GetFriendAccountInfo(i)
        if accountInfo then
          local numGameAccounts = C_BattleNet_GetFriendNumGameAccounts(i)
          if numGameAccounts and (numGameAccounts > 0) then
            for j = 1, numGameAccounts do
              if self:CheckGameInfo(C_BattleNet_GetFriendGameAccountInfo(i, j)) then number = number + 1 end
            end
          elseif self:CheckGameInfo(accountInfo.gameAccountInfo) then
            number = number + 1
          end
        end
      end
    else
      number = number + numBNOnlineFriends
    end

    if number ~= self.info.friends then
      self.info.friends = number
      local button = self.frameNames["social"]
      button.infoText:Show()
      button.infoText:SetText(number > 0 and number or "0")
      WB:FlashFontOnEvent(self.frameNames["social"].icon, true)
    end
  elseif self.db.general.infoEnabled and not self.db.icons.social.enabled then
    self.frameNames["social"].infoText:Hide()
  end

  if
    (self.db.general.infoEnabled and self.db.icons.guild.enabled)
    and (event == "ELVUI_FORCE_UPDATE" or event == "GUILD_ROSTER_UPDATE" or event == "PLAYER_GUILD_UPDATE" or event == "GUILD_MOTD" or event == "CHAT_MSG_SYSTEM")
  then
    local inGuild = IsInGuild()
    local guildCount = inGuild and (select(2, GetNumGuildMembers()) or 0) or 0

    if guildCount ~= self.info.guildies then
      self.info.guildies = guildCount
      local button = self.frameNames["guild"]
      button.infoText:Show()
      button.infoText:SetText(inGuild and guildCount or "0")
      WB:FlashFontOnEvent(button.icon, true)
    end
  elseif self.db.general.infoEnabled and not self.db.icons.guild.enabled then
    self.frameNames["guild"].infoText:Hide()
  end
end

function MM:OnEnter(frame)
  if frame and frame.id then self:ButtonEnter(frame) end
end

function MM:OnLeave(frame)
  if frame and frame.id then self:ButtonLeave(frame) end
end

function MM:OnWunderBarUpdate()
  self:UpdateIcons()
  self:PositionButtons()
  self:OnEvent("ELVUI_FORCE_UPDATE")
end

function MM:OnInit()
  -- Get our settings DB
  self.db = WB:GetSubModuleDB(self:GetName())

  -- Reuqest to extend
  WB:RequestToExtend(self.Module)

  -- Don't init second time
  if self.Initialized then return end

  -- Vars
  self.frame = self.SubModuleHolder
  self.frames = {}
  self.frameNames = {}

  self.info = {}
  self.info.friends = -1
  self.info.guildies = -1

  -- Create virtual frames and connect them to datatexts
  self.guildVirtualFrame = {
    name = "Guild",
    text = {
      SetFormattedText = E.noop,
      SetText = E.noop,
    },
    GetScript = function()
      return E.noop
    end,
    IsMouseOver = function()
      return false
    end,
  }
  WB:ConnectVirtualFrameToDataText("Guild", self.guildVirtualFrame)

  self.friendsVirtualFrame = {
    name = "Friends",
    text = {
      SetFormattedText = E.noop,
    },
  }
  WB:ConnectVirtualFrameToDataText("Friends", self.friendsVirtualFrame)

  -- Of we go
  self:CreateButtons()
  self:OnWunderBarUpdate()

  -- We are done, hooray!
  self.Initialized = true
end

WB:RegisterSubModule(MM, {
  "GUILD_ROSTER_UPDATE",
  "PLAYER_GUILD_UPDATE",
  "GUILD_MOTD",
  "BN_FRIEND_ACCOUNT_ONLINE",
  "BN_FRIEND_ACCOUNT_OFFLINE",
  "BN_FRIEND_INFO_CHANGED",
  "FRIENDLIST_UPDATE",
  "CHAT_MSG_SYSTEM",
})
