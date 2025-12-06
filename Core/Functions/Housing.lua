local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

F.Housing = {
  houseInfo = nil, -- cache
}

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
function F.Housing:TeleportHome()
  if not TXUI.IsRetail then
    TXUI:LogDebug("F.Housing.TeleportHome() is Retail only.")
    return
  end

  local info = self:GetHouseInfo()
  if not info then
    TXUI:LogDebug("F.Housing.TeleportHome >> houseInfo unavailable.")
    return
  end

  -- Protected call not allowed for addons:
  -- if C_HousingNeighborhood.CanReturnAfterVisitingHouse() then
  --     C_Housing.ReturnAfterVisitingHouse()
  --     return
  -- end

  C_Housing.TeleportHome(info.neighborhoodGUID, info.houseGUID, info.plotID)
end

-- Get the name for TeleportHome function
function F.Housing:GetTeleportHomeName()
  if not TXUI.IsRetail then
    TXUI:LogDebug("F.Housing.GetTeleportHomeName() is Retail only.")
    return
  end

  local info = self:GetHouseInfo()
  if not info then return "DEBUG: No House Info" end

  -- if C_HousingNeighborhood.CanReturnAfterVisitingHouse() then
  --   return "Return To Previous Location"
  -- end

  return "Teleport Home"
end
