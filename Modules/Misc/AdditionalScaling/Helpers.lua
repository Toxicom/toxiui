local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local M = TXUI:GetModule("Misc")

local IsAddOnLoaded = (C_AddOns and C_AddOns.IsAddOnLoaded) or IsAddOnLoaded
local InCombatLockdown = InCombatLockdown
local xpcall = xpcall

M.addonsToLoad = {}
M.pendingScaling = {}

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
  -- If in combat, queue the scaling operations for after combat
  if InCombatLockdown() then
    M.pendingScaling[addonName] = object
    return
  end

  for _, func in next, object do
    xpcall(func, print, M)
  end

  M.addonsToLoad[addonName] = nil
end

function M:AddCallbackOrScale(AddOnName, func)
  if not IsAddOnLoaded(AddOnName) then
    M:AddCallbackForAddon(AddOnName, func)
  else
    -- If in combat, queue the scaling operation for after combat
    if InCombatLockdown() then
      M.pendingScaling[AddOnName] = M.pendingScaling[AddOnName] or {}
      tinsert(M.pendingScaling[AddOnName], func)
    else
      func()
    end
  end
end

function M:PLAYER_REGEN_ENABLED()
  if not E.initialized or not TXUI:HasRequirements(I.Requirements.AdditionalScaling) then return end

  -- Process all pending scaling operations after combat ends
  for addonName, object in pairs(M.pendingScaling) do
    for _, func in next, object do
      xpcall(func, print, M)
    end
    M.addonsToLoad[addonName] = nil
  end

  -- Clear the pending queue
  wipe(M.pendingScaling)
end

M:RegisterEvent("ADDON_LOADED")
M:RegisterEvent("PLAYER_REGEN_ENABLED")
