local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local CL = TXUI:GetModule("Changelog")

local find = string.find
local format = string.format
local pairs = pairs
local sort = table.sort

local function parseVersion(a)
  local _, _, aMajor, aMinor, aPatch = find(a, "(%d+).(%d+).(%d+)")
  if aMajor == nil then -- convert legacy number to semver
    _, _, aMajor, aMinor, aPatch = find(a, "(%d)(%d)(%d)")
  end
  return aMajor, aMinor, aPatch
end

-- Semver compare if new version
function CL:IsNewer(a, b)
  local aMajor, aMinor, aPatch = parseVersion(a)
  local bMajor, bMinor, bPatch = parseVersion(b)
  return (aMajor > bMajor) or (aMajor == bMajor and (aMinor > bMinor or (aMinor == bMinor and aPatch > bPatch)))
end

-- Semver compare if same version
function CL:IsSame(a, b)
  local aMajor, aMinor, aPatch = parseVersion(a)
  local bMajor, bMinor, bPatch = parseVersion(b)
  return (aMajor == bMajor) and (aMinor == bMinor) and (aPatch == bPatch)
end

-- Semver compare if same version
function CL:IsSameOrNewer(a, b)
  local aMajor, aMinor, aPatch = parseVersion(a)
  local bMajor, bMinor, bPatch = parseVersion(b)
  return ((aMajor > bMajor) or (aMajor == bMajor and (aMinor > bMinor or (aMinor == bMinor and aPatch > bPatch))))
    or ((aMajor == bMajor) and (aMinor == bMinor) and (aPatch == bPatch))
end

-- Semver sorted table
function CL:HasUpdates(version)
  local foundUpdate = false

  -- We don't need to check if its the same
  if self:IsSame(TXUI.ReleaseVersion, version) then return false end

  -- Iterate over all updates, and check if its an update
  for log, data in pairs(TXUI.Changelog) do
    if (data.HOTFIX == nil or data.HOTFIX == false) and self:IsNewer(log, version) then
      foundUpdate = true
      break
    end
  end

  return foundUpdate
end

-- Semver sorted table
function CL:GetSortedSemverTable()
  local logs = {}

  -- get changelog version and add to table
  for log, _ in pairs(TXUI.Changelog) do
    logs[#logs + 1] = log
  end

  -- sort table descending
  sort(logs, function(a, b)
    return self:IsNewer(a, b)
  end)

  return logs
end

-- Return the latest changelogs as sorted table
function CL:GetSorted()
  local logs = self:GetSortedSemverTable()

  local index = 0
  return function()
    index = index + 1
    return logs[index], TXUI.Changelog[logs[index]]
  end
end

-- Return the latest version from releases
function CL:GetVersion()
  local logs = {}

  -- get changelog version and add to table
  for log, _ in pairs(TXUI.Changelog) do
    logs[#logs + 1] = log
  end

  -- sort table descending
  sort(logs, function(a, b)
    return self:IsNewer(a, b)
  end)

  return logs[1]
end

-- Return the latest version from releases
-- Note: This can only be called AFTER :InitializeChangelog
function CL:FormattedVersion(version)
  local printVersion = version or TXUI.ReleaseVersion
  local _, _, major, minor, patch = find(printVersion, "(%d+).(%d+).(%d+)")
  local versionString = format("v%s.%s.%s", major, minor, patch)
  if TXUI.DevRelease and (not version or version == TXUI.ReleaseVersion) then versionString = TXUI.GitHash .. " " .. TXUI.DevTag end
  return versionString
end
