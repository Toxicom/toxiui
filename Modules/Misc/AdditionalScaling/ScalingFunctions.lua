local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local M = TXUI:GetModule("Misc")

local _G = _G
local InCombatLockdown = InCombatLockdown
local IsRetailTalentsWindowHooked = false

function M:SetElementScale(dbName, blizzName)
  local option

  if E and E.db and E.db.TXUI and E.db.TXUI.misc and E.db.TXUI.misc.scaling and E.db.TXUI.misc.scaling[dbName] then
    option = E.db.TXUI.misc.scaling[dbName]
  else
    TXUI:LogDebug("AdditionalScaling > option " .. dbName .. " not found, skipping scaling!")
    return
  end

  local blizzElement = _G[blizzName]
  if blizzElement then
    blizzElement:SetScale(option.scale)
  else
    TXUI:LogDebug("AdditionalScaling > blizzElement " .. F.String.ToxiUI(blizzName) .. " not found, skipping scaling!")
  end
end

function M:ScaleCollections()
  M:SetElementScale("collections", "CollectionsJournal")
end

function M:ScaleItemUpgrade()
  M:SetElementScale("itemUpgrade", "ItemUpgradeFrame")
  M:SetElementScale("equipmentFlyout", "EquipmentFlyoutFrameButtons")
end

function M:ScaleCatalyst()
  M:SetElementScale("itemUpgrade", "ItemInteractionFrame")
  M:SetElementScale("equipmentFlyout", "EquipmentFlyoutFrameButtons")
end

function M:ScaleProfessions()
  if TXUI.IsRetail then
    E:Delay(0.01, function()
      local isHooked = M.hookedFrames["profession"] == true
      if not isHooked then
        -- Scale initially
        M:SetElementScale("profession", "ProfessionsFrame")

        -- Then hook each show. Idk why this frame needs this fucking special treatment
        local frame = _G["ProfessionsFrame"]
        frame:HookScript("OnShow", function()
          M:SetElementScale("profession", "ProfessionsFrame")
        end)

        M.hookedFrames["profession"] = true
      end
    end)
  else
    M:SetElementScale("profession", "TradeSkillFrame")
  end
end

function M:ScaleClassTrainer()
  M:SetElementScale("classTrainer", "ClassTrainerFrame")
end

function M:ScaleAuctionHouse()
  if TXUI.IsRetail then
    M:SetElementScale("auctionHouse", "AuctionHouseFrame")
  else
    M:SetElementScale("auctionHouse", "AuctionFrame")
  end
end

function M:ScaleRetailSpellbook()
  -- Don't scale PlayerSpellsFrame during combat to avoid taint
  if InCombatLockdown() then return end

  if TXUI.IsRetail and not IsRetailTalentsWindowHooked then
    M:HookRetailTalentsWindow()
  else
    M:SetElementScale("spellbook", "PlayerSpellsFrame")
  end
end

function M:ScaleInspectUI()
  -- Special case for synced character & inspect frames
  -- If sync is enabled, we take the value of the characterFrame in the database
  local dbName = E.db.TXUI.misc.scaling.syncInspect.enabled and "characterFrame" or "inspectFrame"
  M:SetElementScale(dbName, "InspectFrame")
end

function M:HookRetailTalentsWindow()
  _G.PlayerSpellsFrame:HookScript("OnShow", function()
    M:ScaleRetailSpellbook()
  end)
  _G.PlayerSpellsFrame:HookScript("OnEvent", function()
    M:ScaleRetailSpellbook()
  end)
  IsRetailTalentsWindowHooked = true
end

function M:ScaleTalents()
  M:SetElementScale("talents", "PlayerTalentFrame")
end
