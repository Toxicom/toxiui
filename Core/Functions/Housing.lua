local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

F.Housing = {
  houseInfo = nil, -- cache
  PlayerHouses = nil,
}

F.Housing.NeighborhoodMapIndex = {
    [2352] = 1, --Alliance, Founder's Point
    [2351] = 2, --Horde, Razorwind Shores
};

F.Event.RegisterFrameEventAndCallback("PLAYER_HOUSE_LIST_UPDATED", function(_, houseInfos)
  F.Housing.PlayerHouses = houseInfos
end, "housing")

    
function F.Housing:RefreshHouseInfo()
  self.houseInfo = C_Housing.GetCurrentHouseInfo()
  return self.houseInfo
end

function F.Housing:GetHouseInfo()
  -- If cached, return
  if self.houseInfo then return self.houseInfo end

  -- Otherwise fetch & store it
  return self:RefreshHouseInfo()
end

-- Teleport function
function F.Housing:TeleportHome(house)
  if not TXUI.IsRetail then
    TXUI:LogDebug("F.Housing.TeleportHome() is Retail only.")
    return
  end

  -- Protected call not allowed for addons:
  -- if C_HousingNeighborhood.CanReturnAfterVisitingHouse() then
  --     C_Housing.ReturnAfterVisitingHouse()
  --     return
  -- end

  TXUI:LogDebug(house)
  TXUI.LogDebug("Teleporting to " .. house.houseName)
  C_Housing.TeleportHome(house.neighborhoodGUID, house.houseGUID, house.plotID)
end

function F.Housing:GetFactionFromMapIndex(mapIndex)
  if mapIndex == 1 then
    return "A"
  elseif mapIndex == 2 then
    return "H"
  else
    return "???"
  end
end

-- Get the name for TeleportHome function
function F.Housing:GetTeleportHomeName()
  if not TXUI.IsRetail then
    TXUI:LogDebug("F.Housing.GetTeleportHomeName() is Retail only.")
    return
  end

  if not F.Housing.PlayerHouses then return "DEBUG: No House Info" end

  -- if C_HousingNeighborhood.CanReturnAfterVisitingHouse() then
  --   return "Return To Previous Location"
  -- end

  return "Teleport Home"
end