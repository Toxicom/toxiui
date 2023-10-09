local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local M = TXUI:GetModule("Misc")

local _G = _G
local LoadAddOn = LoadAddOn
local IsAddOnLoaded = IsAddOnLoaded

function M:SetElementScale(dbName, blizzName, loadAddonName)
  if E.db and E.db.TXUI then
    local option = E.db.TXUI.misc.scaling[dbName]

    if not option then
      TXUI:LogDebug("AdditionalScaling > option " .. dbName .. " not found, skipping scaling!")
      return
    end

    if option.scale ~= 1 then
      if loadAddonName and not IsAddOnLoaded(loadAddonName) then LoadAddOn(loadAddonName) end
      _G[blizzName]:SetScale(option.scale)
    end
  else
    TXUI:LogDebug("AdditionalScaling > E.db or E.db.TXUI not found, skipping scaling!")
  end
end

function M:AdditionalScaling()
  -- Don't init if its not a TXUI profile or requirements are not met
  if not TXUI:HasRequirements(I.Requirements.AdditionalScaling) then return end

  M:SetElementScale("map", "WorldMapFrame")
  M:SetElementScale("characterFrame", "CharacterFrame")
  M:SetElementScale("dressingRoom", "DressUpFrame")
  -- Special case for synced character & inspect frames
  local syncedFrameName = E.db.TXUI.misc.scaling.syncInspect.enabled and "characterFrame" or "inspectFrame"
  M:SetElementScale(syncedFrameName, "InspectFrame", "Blizzard_InspectUI")

  if TXUI.IsRetail then
    M:SetElementScale("collections", "CollectionsJournal", "Blizzard_Collections")
    M:SetElementScale("wardrobe", "WardrobeFrame", "Blizzard_Collections")
  end
  if not TXUI.IsRetail then M:SetElementScale("talents", "PlayerTalentFrame", "Blizzard_TalentUI") end
end

M:AddCallback("AdditionalScaling")
