local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local GM = TXUI:GetModule("GameMenu")

local math_floor = math.floor
local table_concat = table.concat
local table_insert = table.insert

-- Spacing helper (multiplier of 4)
function GM.Spacing(num)
  return num * 4
end

function GM.FormatPlayed(seconds, colorize)
  if not seconds or seconds <= 0 then return "N/A" end

  if colorize == nil then colorize = true end

  local minutesTotal = math_floor(seconds / 60)
  local hoursTotal = math_floor(minutesTotal / 60)
  local daysTotal = math_floor(hoursTotal / 24)

  local years = math_floor(daysTotal / 365)
  local daysAfterYears = daysTotal % 365
  local months = math_floor(daysAfterYears / 30)
  local days = daysAfterYears % 30
  local hours = hoursTotal % 24
  local minutes = minutesTotal % 60

  local function unit(n, singular, plural)
    local label = (n == 1) and singular or plural
    local num = tostring(n)
    if colorize then num = F.String.ToxiUI(num) end
    return num .. " " .. label
  end

  -- Pick the two largest non-zero time units
  local parts = {
    { years, "Year", "Years" },
    { months, "Month", "Months" },
    { days, "Day", "Days" },
    { hours, "Hour", "Hours" },
    { minutes, "Minute", "Minutes" },
  }

  local result = {}
  for _, p in ipairs(parts) do
    if p[1] > 0 then
      result[#result + 1] = unit(p[1], p[2], p[3])
      if #result == 2 then break end
    end
  end

  if #result == 0 then return "Less than a minute" end
  return table_concat(result, ", ")
end

-- Sum all stored played seconds across all characters/realms
function GM.GetTotalPlayedAll()
  local total = 0
  local played = (E.global.TXUI and E.global.TXUI.playedSeconds) or {}
  for _, realmMap in pairs(played) do
    for _, seconds in pairs(realmMap) do
      if seconds and seconds > 0 then total = total + seconds end
    end
  end
  return total
end

-- Group played time by class token, return sorted list (descending)
function GM.AggregatePlayedByClass()
  local totals = {}
  local classes = (E.global.TXUI and E.global.TXUI.classMap) or {}
  local played = (E.global.TXUI and E.global.TXUI.playedSeconds) or {}

  for realm, classMap in pairs(classes) do
    local playedRealm = played[realm]
    if playedRealm then
      for name, classToken in pairs(classMap) do
        local seconds = playedRealm[name]
        if seconds and seconds > 0 then totals[classToken] = (totals[classToken] or 0) + seconds end
      end
    end
  end

  local list = {}
  for classToken, seconds in pairs(totals) do
    table_insert(list, { class = classToken, seconds = seconds })
  end
  table.sort(list, function(a, b)
    return a.seconds > b.seconds
  end)
  return list
end
