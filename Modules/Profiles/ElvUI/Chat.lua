local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local PF = TXUI:GetModule("Profiles")
local CH = E:GetModule("Chat")

local _G = _G
local ipairs = ipairs
local tinsert = table.insert

local ChangeChatColor = ChangeChatColor
local CHAT_FRAMES = CHAT_FRAMES
local ChatFrame_AddMessageGroup = ChatFrame_AddMessageGroup
local ChatFrame_RemoveAllMessageGroups = ChatFrame_RemoveAllMessageGroups
local ChatFrame_RemoveMessageGroup = ChatFrame_RemoveMessageGroup
local FCF_OpenNewWindow = FCF_OpenNewWindow
local FCF_ResetChatWindows = FCF_ResetChatWindows
local FCF_SavePositionAndDimensions = FCF_SavePositionAndDimensions
local FCF_SetChatWindowFontSize = FCF_SetChatWindowFontSize
local FCF_SetWindowName = FCF_SetWindowName
local FCF_StopDragging = FCF_StopDragging
local GENERAL = GENERAL
local GUILD_EVENT_LOG = GUILD_EVENT_LOG
local MAX_WOW_CHAT_CHANNELS = MAX_WOW_CHAT_CHANNELS
local ToggleChatColorNamesByClassGroup = ToggleChatColorNamesByClassGroup
local VoiceTranscriptionFrame_UpdateEditBox = VoiceTranscriptionFrame_UpdateEditBox
local VoiceTranscriptionFrame_UpdateVisibility = VoiceTranscriptionFrame_UpdateVisibility
local VoiceTranscriptionFrame_UpdateVoiceTab = VoiceTranscriptionFrame_UpdateVoiceTab

function PF:ElvUIChatFont()
  -- Set chat font size
  for _, name in ipairs(CHAT_FRAMES) do
    local frame = _G[name]
    FCF_SetChatWindowFontSize(nil, frame, I.General.ChatFontSize)
  end
end

-- copied from E:SetupChat and changed to 1 window only
function PF:ElvUIChat()
  FCF_ResetChatWindows()
  FCF_OpenNewWindow()
  FCF_OpenNewWindow()
  FCF_OpenNewWindow()

  for _, name in ipairs(CHAT_FRAMES) do
    local frame = _G[name]
    local id = frame:GetID()

    -- Font size and colors for all tabs
    FCF_SetChatWindowFontSize(nil, frame, I.General.ChatFontSize)
    CH:FCFTab_UpdateColors(CH:GetTab(_G[name]))

    -- Tabs
    if id == 1 then
      FCF_SetWindowName(frame, GENERAL)
      frame:ClearAllPoints()
      frame:SetPoint("BOTTOMLEFT", _G["LeftChatToggleButton"], "TOPLEFT", 1, 3)
    elseif id == 2 then
      FCF_SetWindowName(frame, GUILD_EVENT_LOG)
    elseif id == 3 then
      VoiceTranscriptionFrame_UpdateVisibility(frame)
      VoiceTranscriptionFrame_UpdateVoiceTab(frame)
      VoiceTranscriptionFrame_UpdateEditBox(frame)
    elseif id == 4 then
      FCF_SetWindowName(frame, "Whisper")
    elseif id == 5 then
      FCF_SetWindowName(frame, "Guild")
    elseif id == 6 then
      FCF_SetWindowName(frame, "Party")
    end

    FCF_SavePositionAndDimensions(frame)
    FCF_StopDragging(frame)
  end

  -- Whisper tab
  ChatFrame_RemoveAllMessageGroups(_G["ChatFrame4"])
  for _, v in ipairs { "WHISPER", "BN_WHISPER", "IGNORED" } do
    ChatFrame_AddMessageGroup(_G["ChatFrame4"], v)
  end

  -- Guild tab
  ChatFrame_RemoveAllMessageGroups(_G["ChatFrame5"])
  for _, v in ipairs { "GUILD", "GUILD_ACHIEVEMENT", "OFFICER" } do
    ChatFrame_AddMessageGroup(_G["ChatFrame5"], v)
  end

  -- Party tab
  ChatFrame_RemoveAllMessageGroups(_G["ChatFrame6"])
  for _, v in ipairs { "PARTY", "PARTY_LEADER", "RAID", "RAID_LEADER", "RAID_WARNING", "INSTANCE_CHAT", "INSTANCE_CHAT_LEADER" } do
    ChatFrame_AddMessageGroup(_G["ChatFrame5"], v)
  end

  -- Remove whispers
  ChatFrame_RemoveMessageGroup(_G["ChatFrame1"], "IGNORED")
  ChatFrame_RemoveMessageGroup(_G["ChatFrame1"], "WHISPER")
  ChatFrame_RemoveMessageGroup(_G["ChatFrame1"], "BN_WHISPER")

  local chatGroup = {
    "SAY",
    "EMOTE",
    "YELL",
    "WHISPER",
    "PARTY",
    "PARTY_LEADER",
    "RAID",
    "RAID_LEADER",
    "RAID_WARNING",
    "INSTANCE_CHAT",
    "INSTANCE_CHAT_LEADER",
    "GUILD",
    "OFFICER",
    "ACHIEVEMENT",
    "GUILD_ACHIEVEMENT",
    "COMMUNITIES_CHANNEL",
  }

  for i = 1, MAX_WOW_CHAT_CHANNELS do
    tinsert(chatGroup, "CHANNEL" .. i)
  end

  for _, v in ipairs(chatGroup) do
    ToggleChatColorNamesByClassGroup(true, v)
  end

  -- Adjust Chat Colors
  ChangeChatColor("CHANNEL1", 0.76, 0.90, 0.91) -- General
  ChangeChatColor("CHANNEL2", 0.91, 0.62, 0.47) -- Trade
  ChangeChatColor("CHANNEL3", 0.91, 0.89, 0.47) -- Local Defense

  -- Apply chat font size
  self:ElvUIChatFont()
end
