local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local M = TXUI:GetModule("Misc")

local pairs = pairs
local wipe = wipe

-- Map of settings that can be toggled for performance
-- Each entry: { name = "Display Name", path = "db.path.to.parent", key = "enabled" }
local settingsMap = {
  gradientMode = { name = "Gradient Mode", path = "TXUI.themes.gradientMode", key = "enabled" },
  darkModeTransparency = { name = "Dark Mode Transparency", path = "TXUI.themes.darkMode", key = "transparency" },
  damageMeter = { name = "Damage Meter Skin", path = "TXUI.addons.damageMeter", key = "enabled" },
  wunderbarAnimations = { name = "WunderBar Animations", path = "TXUI.wunderbar.general", key = "animations" },
  elvuiSkin = { name = "ElvUI Theme", path = "TXUI.addons.elvUITheme", key = "enabled" },
}

function M:GetPerformanceSettingsMap()
  return settingsMap
end

function M:PerformanceEnable()
  local db = E.db.TXUI.performance
  local saved = db.savedSettings

  wipe(saved)

  for id, entry in pairs(settingsMap) do
    local parent = F.GetDBFromPath(entry.path)
    if parent and parent[entry.key] == true then
      saved[id] = true
      parent[entry.key] = false
    end
  end

  db.enabled = true
end

function M:PerformanceDisable()
  local db = E.db.TXUI.performance
  local saved = db.savedSettings

  for id, entry in pairs(settingsMap) do
    if saved[id] then
      local parent = F.GetDBFromPath(entry.path)
      if parent then parent[entry.key] = true end
    end
  end

  wipe(saved)
  db.enabled = false
end

function M:PerformanceToggle()
  if E.db.TXUI.performance.enabled then
    self:PerformanceDisable()
  else
    self:PerformanceEnable()
  end
end
