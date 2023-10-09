local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local M = TXUI:GetModule("Misc")

local _G = _G
local LoadAddOn = LoadAddOn
local IsAddOnLoaded = IsAddOnLoaded
local xpcall = xpcall

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
  if E.db and E.db.TXUI then
    local option = E.db.TXUI.misc.scaling[dbName]

    if not option then
      TXUI:LogDebug("AdditionalScaling > option " .. dbName .. " not found, skipping scaling!")
      return
    end

    if option.scale ~= 1 then _G[blizzName]:SetScale(option.scale) end
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
  M:AddCallbackForAddon("Blizzard_InspectUI", "ScaleInspectUI")

  if TXUI.IsRetail then M:AddCallbackForAddon("Blizzard_Collections", "ScaleCollections") end

  if not TXUI.IsRetail then M:AddCallbackForAddon("Blizzard_TalentUI", "ScaleTalents") end
end

function M:ScaleCollections()
  M:SetElementScale("collections", "CollectionsJournal")
  M:SetElementScale("wardrobe", "WardrobeFrame")
end

function M:ScaleInspectUI()
  -- Special case for synced character & inspect frames
  local syncedFrameName = E.db.TXUI.misc.scaling.syncInspect.enabled and "characterFrame" or "inspectFrame"
  M:SetElementScale(syncedFrameName, "InspectFrame")
end

function M:ScaleTalents()
  M:SetElementScale("talents", "PlayerTalentFrame")
end

M:RegisterEvent("ADDON_LOADED")
M:AddCallback("AdditionalScaling")
