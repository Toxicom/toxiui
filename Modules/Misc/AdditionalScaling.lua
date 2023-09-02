local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local M = TXUI:GetModule("Misc")

local _G = _G
local IsAddOnLoaded = IsAddOnLoaded

function M:SetElementScale(dbName, blizzName)
  if E.db and E.db.TXUI then
    local option = E.db.TXUI.addons.additionalScaling[dbName]

    if not option then return end

    if option.scale ~= 1 then _G[blizzName]:SetScale(option.scale) end
  else
    TXUI:LogDebug("AdditionalScaling > E.db or E.db.TXUI not found, skipping scaling!")
  end
end

function M:AdditionalScaling()
  -- Don't init if its not a TXUI profile or requirements are not met
  if not TXUI:HasRequirements(I.Requirements.AdditionalScaling) then return end

  M:SetElementScale("characterFrame", "CharacterFrame")
  M:SetElementScale("map", "WorldMapFrame")
  -- TODO: Make these work
  -- For some reason CollectionsJournal and WardrobeFrame are nil on reload
  -- They most likely get created after the first time user opens them
  -- Need to maybe add an event handler for when they're opened?
  -- M:SetElementScale("collections", "CollectionsJournal")
  -- M:SetElementScale("wardrobe", "WardrobeFrame")
end

M:AddCallback("AdditionalScaling")
