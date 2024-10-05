local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local M = TXUI:GetModule("Misc")

local _G = _G
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
  if TXUI.IsRetail then M:SetElementScale("wardrobe", "WardrobeFrame") end
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

-- Credits to Kayr
function M:AdjustTransmogFrame()
  if not E.db.TXUI.misc.scaling.retailTransmog.enabled then return end

  local wardrobeFrame = _G["WardrobeFrame"]
  local transmogFrame = _G["WardrobeTransmogFrame"]

  local width = 1200
  local initialWidth = wardrobeFrame:GetWidth()
  local updatedWidth = width - initialWidth
  wardrobeFrame:SetWidth(width)

  local initialTransmogWidth = transmogFrame:GetWidth()
  local updatedTransmogWidth = initialTransmogWidth + updatedWidth
  transmogFrame:SetWidth(updatedTransmogWidth)

  -- Calculate inset width only once
  local modelScene = transmogFrame.ModelScene
  local insetWidth = E:Round(initialTransmogWidth - modelScene:GetWidth(), 0)
  transmogFrame.Inset.BG:SetWidth(transmogFrame.Inset.BG:GetWidth() - insetWidth)
  modelScene:SetWidth(transmogFrame:GetWidth() - insetWidth)
  modelScene:SetScript("OnShow", function()
    E:Delay(0.01, function()
      modelScene.activeCamera.maxZoomDistance = 6
    end)
  end)

  -- Move Slots
  transmogFrame.HeadButton:SetPoint("TOPLEFT", 20, -60)
  transmogFrame.HandsButton:SetPoint("TOPRIGHT", -20, -60)

  local mainHand = transmogFrame.MainHandButton
  local mainHandEnch = transmogFrame.MainHandEnchantButton
  local offHand = transmogFrame.SecondaryHandButton
  local offHandEnch = transmogFrame.SecondaryHandEnchantButton

  mainHand:SetPoint("BOTTOM", -30, 25)
  mainHandEnch:SetPoint("CENTER", mainHand, "BOTTOM", 0, -5)
  offHand:SetPoint("BOTTOM", 30, 25)
  offHandEnch:SetPoint("CENTER", offHand, "BOTTOM", 0, -5)

  transmogFrame.ToggleSecondaryAppearanceCheckbox:SetPoint("BOTTOMLEFT", transmogFrame, "BOTTOMRIGHT", 20, 20)
end
