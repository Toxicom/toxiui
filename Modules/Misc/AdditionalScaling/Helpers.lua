local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local M = TXUI:GetModule("Misc")

local IsAddOnLoaded = (C_AddOns and C_AddOns.IsAddOnLoaded) or IsAddOnLoaded
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

function M:AddCallbackOrScale(AddOnName, func)
  if not IsAddOnLoaded(AddOnName) then
    M:AddCallbackForAddon(AddOnName, func)
  else
    func()
  end
end

M:RegisterEvent("ADDON_LOADED")
