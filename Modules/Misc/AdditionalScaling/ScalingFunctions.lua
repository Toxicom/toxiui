local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local M = TXUI:GetModule("Misc")

local _G = _G
local IsRetailTalentsWindowHooked = false

function M:SetElementScale(dbName, blizzName)
  local option = E.db.TXUI.misc.scaling[dbName]

  if not option then
    TXUI:LogDebug("AdditionalScaling > option " .. dbName .. " not found, skipping scaling!")
    return
  end

  _G[blizzName]:SetScale(option.scale)
end

function M:ScaleCollections()
  M:SetElementScale("collections", "CollectionsJournal")
  if TXUI.IsRetail then M:SetElementScale("wardrobe", "WardrobeFrame") end
end

function M:ScaleInspectUI()
  -- Special case for synced character & inspect frames
  -- If sync is enabled, we take the value of the characterFrame in the database
  local dbName = E.db.TXUI.misc.scaling.syncInspect.enabled and "characterFrame" or "inspectFrame"
  M:SetElementScale(dbName, "InspectFrame")
end

function M:HookRetailTalentsWindow()
  _G.ClassTalentFrame:HookScript("OnShow", function()
    M:ScaleTalents()
  end)
  _G.ClassTalentFrame:HookScript("OnEvent", function()
    M:ScaleTalents()
  end)
  IsRetailTalentsWindowHooked = true
end

function M:ScaleTalents()
  local frameName = TXUI.IsRetail and "ClassTalentFrame" or "PlayerTalentFrame"
  if TXUI.IsRetail and not IsRetailTalentsWindowHooked then
    M:HookRetailTalentsWindow()
  else
    M:SetElementScale("talents", frameName)
  end
end
