local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local WB = TXUI:GetModule("WunderBar")

-- Player housing (Retail): owned house list and the secure "teleport home" action,
-- shared by every WunderBar module that offers it (DataBar house mode, MicroMenu housing button)
if not TXUI.IsRetail then return end

local C_Housing = C_Housing
local C_HousingNeighborhood = C_HousingNeighborhood
local CreateFrame = CreateFrame
local GetTime = GetTime
local ipairs = ipairs
local next = next
local pairs = pairs
local PlayerIsTimerunning = PlayerIsTimerunning

local houseList
local houseRequestTime = 0
local teleportButtons = {}
local updateButtonsQueued = false

-- Prefer the house Blizzard's favor bar tracks, otherwise the first one we own
function WB:GetOwnedHouse()
  if not houseList then return end

  local trackedGUID = C_Housing.GetTrackedHouseGuid()
  local selected

  for _, houseInfo in ipairs(houseList) do
    if houseInfo.houseGUID and ((houseInfo.houseGUID == trackedGUID) or not selected) then selected = houseInfo end
  end

  return selected
end

-- The list arrives async with PLAYER_HOUSE_LIST_UPDATED, callers can ask freely
function WB:RequestOwnedHouses()
  if not C_Housing.IsHousingServiceEnabled() or PlayerIsTimerunning() then return end

  local now = GetTime()
  if (now - houseRequestTime) < 5 then return end
  houseRequestTime = now

  C_Housing.GetPlayerOwnedHouses()
end

-- Same as Blizzard's dashboard teleport button: offer the way back while visiting our own neighborhood
function WB:CanReturnHome(houseInfo)
  if not houseInfo or not C_HousingNeighborhood.CanReturnAfterVisitingHouse() then return false end

  local neighborhoodGUID = C_Housing.GetCurrentNeighborhoodGUID()
  return (neighborhoodGUID ~= nil) and (neighborhoodGUID == houseInfo.neighborhoodGUID)
end

-- Secure "teleporthome"/"returnhome" action for a mouse button, only call out of combat
function WB:SetHouseTeleportAttributes(button, houseInfo, mouseButton)
  if not houseInfo then
    button:SetAttribute("type" .. mouseButton, nil)
    return
  end

  button:SetAttribute("type" .. mouseButton, self:CanReturnHome(houseInfo) and "returnhome" or "teleporthome")
  button:SetAttribute("house-neighborhood-guid", houseInfo.neighborhoodGUID)
  button:SetAttribute("house-guid", houseInfo.houseGUID)
  button:SetAttribute("house-plot-id", houseInfo.plotID)
end

-- Secure attributes can only change out of combat, queue one refresh for all buttons
local function UpdateTeleportButtons()
  if updateButtonsQueued then return end
  updateButtonsQueued = true

  F.Event.ContinueOutOfCombat(function()
    updateButtonsQueued = false

    local houseInfo = WB:GetOwnedHouse()
    for button, mouseButton in pairs(teleportButtons) do
      WB:SetHouseTeleportAttributes(button, houseInfo, mouseButton)
    end
  end)
end

-- Keeps the button's teleport/return action up to date with the owned house and our location
function WB:RegisterHouseTeleportButton(button, mouseButton)
  teleportButtons[button] = mouseButton

  self:RequestOwnedHouses()
  UpdateTeleportButtons()
end

-- Own frame, the WunderBar module event proxy drops events while the bar is faded out
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_HOUSE_LIST_UPDATED")
eventFrame:RegisterEvent("TRACKED_HOUSE_CHANGED")
eventFrame:RegisterEvent("HOUSE_PLOT_ENTERED")
eventFrame:RegisterEvent("HOUSE_PLOT_EXITED")
eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
eventFrame:SetScript("OnEvent", function(_, event, list)
  if event == "PLAYER_HOUSE_LIST_UPDATED" then
    houseList = list
    F.Event.TriggerEvent("WunderBar.HousesUpdated")
  elseif event == "TRACKED_HOUSE_CHANGED" then
    F.Event.TriggerEvent("WunderBar.HousesUpdated")
  end

  if next(teleportButtons) then UpdateTeleportButtons() end
end)
