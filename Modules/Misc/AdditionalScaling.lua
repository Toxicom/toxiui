local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local M = TXUI:GetModule("Misc")

local _G = _G
local xpcall = xpcall
local IsAddOnLoaded = IsAddOnLoaded

M.addonsToLoad = {}

function M:AddCallbackForAddon(addonName, func)
  local addon = M.addonsToLoad[addonName]
  if not addon then
    M.addonsToLoad[addonName] = {}
    addon = M.addonsToLoad[addonName]
  end

  if type(func) == "string" then func = M[func] end

  tinsert(addon, func or M[addonName])
end

function M:ADDON_LOADED(_, addonName)
  if not E.initialized or not TXUI:HasRequirements(I.Requirements.AdditionalScaling) then return end

  local object = M.addonsToLoad[addonName]
  if object then M:CallLoadedAddon(addonName, object) end
end

function M:CallLoadedAddon(addonName, object)
  for _, func in next, object do
    xpcall(func, print, M)
  end

  M.addonsToLoad[addonName] = nil
end

function M:SetElementScale(dbName, blizzName)
  local option

  if not E.db.TXUI.mix.scaling.enabled then
    option = { scale = 1 }
  else
    option = E.db.TXUI.misc.scaling[dbName]
  end

  if not option then
    TXUI:LogDebug("AdditionalScaling > option " .. dbName .. " not found, skipping scaling!")
    return
  end

  _G[blizzName]:SetScale(option.scale)
end

function M:AdditionalScaling()
  -- Don't init if its not a TXUI profile or requirements are not met
  if not TXUI:HasRequirements(I.Requirements.AdditionalScaling) then return end

  -- check if database is present
  if E.db and E.db.TXUI then
    local db = E.db.TXUI.misc.scaling

    -- return if module is disabled
    if not db.enabled then return end

    M:SetElementScale("map", "WorldMapFrame")
    M:SetElementScale("characterFrame", "CharacterFrame")
    M:SetElementScale("dressingRoom", "DressUpFrame")

    -- In the next parts, if the AddOn isn't loaded by the game yet we add it to a list to be loaded as soon as the AddOn has been loaded
    -- Otherwise we can scale the UI element directly.
    if not IsAddOnLoaded("Blizzard_InspectUI") then
      M:AddCallbackForAddon("Blizzard_InspectUI", "ScaleInspectUI")
    else
      M:ScaleInspectUI()
    end

    if TXUI.IsRetail and not IsAddOnLoaded("Blizzard_Collections") then
      M:AddCallbackForAddon("Blizzard_Collections", "ScaleCollections")
    else
      M:ScaleCollections()
    end

    if not TXUI.IsRetail and not IsAddOnLoaded("Blizzard_TalentUI") then
      M:AddCallbackForAddon("Blizzard_TalentUI", "ScaleTalents")
    else
      M:ScaleTalents()
    end
  else
    TXUI:LogDebug("AdditionalScaling > E.db or E.db.TXUI not found, skipping scaling!")
  end
end

function M:ScaleCollections()
  M:SetElementScale("collections", "CollectionsJournal")
  M:SetElementScale("wardrobe", "WardrobeFrame")
end

function M:ScaleInspectUI()
  -- Special case for synced character & inspect frames
  -- If sync is enabled, we take the value of the characterFrame in the database
  local dbName = E.db.TXUI.misc.scaling.syncInspect.enabled and "characterFrame" or "inspectFrame"
  M:SetElementScale(dbName, "InspectFrame")
end

function M:ScaleTalents()
  M:SetElementScale("talents", "PlayerTalentFrame")
end

M:RegisterEvent("ADDON_LOADED")
M:AddCallback("AdditionalScaling")
