local TXUI, F, E, I, V, P, G = unpack(select(2, ...))

local CS = { keyCache = {} }

local C_MythicPlus_GetOwnedKeystoneChallengeMapID = TXUI.IsRetail and C_MythicPlus.GetOwnedKeystoneChallengeMapID
local C_MythicPlus_GetOwnedKeystoneLevel = TXUI.IsRetail and C_MythicPlus.GetOwnedKeystoneLevel
local InventoryConstantsNumBagSlots = Constants.InventoryConstants.NumBagSlots
local C_Container_GetContainerNumSlots = TXUI.IsRetail and C_Container.GetContainerNumSlots
local C_Container_GetContainerItemID = TXUI.IsRetail and C_Container.GetContainerItemID
local C_Container_GetContainerItemLink = TXUI.IsRetail and C_Container.GetContainerItemLink
local C_Item_IsItemKeystoneByID = TXUI.IsRetail and C_Item.IsItemKeystoneByID

function CS:Init()
  if not TXUI.IsRetail then return end

  F.Event.RegisterFrameEventAndCallback("CHALLENGE_MODE_COMPLETED", self.UpdateCachedKey, self)
  F.Event.RegisterFrameEventAndCallback("PLAYER_ENTERING_WORLD", self.UpdateCachedKey, self)
  F.Event.RegisterFrameEventAndCallback("BAG_UPDATE_DELAYED", self.UpdateCachedKey, self)
  F.Event.RegisterFrameEventAndCallback("CHAT_MSG_GUILD", self.HandleKeyMessage, self, "CHAT_MSG_GUILD")
  F.Event.RegisterFrameEventAndCallback("CHAT_MSG_PARTY_LEADER", self.HandleKeyMessage, self, "CHAT_MSG_PARTY_LEADER")
  F.Event.RegisterFrameEventAndCallback("CHAT_MSG_PARTY", self.HandleKeyMessage, self, "CHAT_MSG_PARTY")
end

function CS:HandleKeyMessage(event, msg)
  if not msg or not F.String.StartsWith(msg, "!keys") then return end

  if not self.keyCache.link then return TXUI:LogInfo("It seems like you don't have a keystone") end
  SendChatMessage(self.keyCache.link, (event == "CHAT_MSG_GUILD" and "GUILD") or "PARTY")
end

function CS:UpdateCachedKey()
  local mapId = C_MythicPlus_GetOwnedKeystoneChallengeMapID()
  local level = C_MythicPlus_GetOwnedKeystoneLevel()

  if self.keyCache.mapId ~= mapId or self.keyCache.level ~= level then
    self.keyCache.mapId = mapId
    self.keyCache.level = level

    for bagIndex = 0, InventoryConstantsNumBagSlots do
      for slotIndex = 1, C_Container_GetContainerNumSlots(bagIndex) do
        local itemID = C_Container_GetContainerItemID(bagIndex, slotIndex)
        ---@diagnostic disable-next-line: param-type-mismatch
        if itemID and C_Item_IsItemKeystoneByID(itemID) then self.keyCache.link = C_Container_GetContainerItemLink(bagIndex, slotIndex) end
      end
    end
  end
end

CS:Init()
