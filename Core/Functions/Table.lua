local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

local next = next
local pairs = pairs
local rawset = rawset
local select = select
local setmetatable = setmetatable
local tinsert = table.insert
local tsort = table.sort
local type = type
local unpack = unpack

F.Table = {}

function F.Table.SetMetatables(tbl, mt)
  for k, v in pairs(tbl) do
    if type(v) == "table" then tbl[k] = F.Table.SetMetatables(v, mt) end
  end

  return setmetatable(tbl, mt)
end

function F.Table.IsEmpty(tbl)
  return next(tbl) == nil
end

function F.Table.HasAnyEntries(tbl)
  return not F.Table.IsEmpty(tbl)
end

function F.Table.GetOrCreate(tbl, ...)
  local currentTable = tbl

  for i = 1, select("#", ...) do
    local key = (select(i, ...))
    if type(currentTable[key]) ~= "table" then currentTable[key] = {} end
    currentTable = currentTable[key]
  end

  return currentTable
end

function F.Table.RemoveEmpty(tbl)
  for k, v in pairs(tbl) do
    if type(v) == "table" then
      if next(v) == nil then
        tbl[k] = nil
      else
        tbl[k] = F.Table.RemoveEmpty(v)
      end
    end
  end

  return tbl
end

function F.Table.Join(...)
  local ret = {}

  for i = 1, select("#", ...) do
    local t = select(i, ...)
    if t then
      for k, v in pairs(t) do
        if type(k) == "number" then
          tinsert(ret, v)
        else
          ret[k] = v
        end
      end
    end
  end

  return ret
end

function F.Table.Crush(ret, ...)
  for i = 1, select("#", ...) do
    local t = select(i, ...)
    if t then
      for k, v in pairs(t) do
        if type(v) == "table" and type(ret[k] or false) == "table" then
          F.Table.Crush(ret[k], v)
        else
          rawset(ret, k, v)
        end
      end
    end
  end
end

function F.Table.CrushDebug(ret, ...)
  for i = 1, select("#", ...) do
    local t = select(i, ...)
    if t then
      for k, v in pairs(t) do
        if type(v) == "table" and type(ret[k] or false) == "table" then
          F.Table.CrushDebug(ret[k], v)
        else
          if ret[k] == nil and k ~= "customTexts" and k ~= "infoPanel" and k ~= "customTexture" and k ~= "movers" and k ~= "uiScaleInformed" and k ~= "convertPages" then
            TXUI:LogDebug("Setting new k,v", k, v)
          end

          rawset(ret, k, v)
        end
      end
    end
  end
end

function F.Table.If(cond, thenTable, orTable)
  if not cond then return orTable or {} end
  return thenTable or {}
end

function F.Table.RGB(r, g, b, a)
  local ret = {
    r = r,
    g = g,
    b = b,
  }

  if a then ret.a = a end

  return ret
end

function F.Table.HexToRGB(hex)
  local r, g, b, a = F.String.HexToRGB(hex)
  return F.Table.RGB(r, g, b, a)
end

function F.Table.CurrentClassColor()
  local color = E:ClassColor(E.myclass, true)

  return F.Table.RGB(color.r, color.g, color.b)
end

function F.Table.Sort(t, f)
  local keys = {}

  for k in pairs(t) do
    keys[#keys + 1] = k
  end

  tsort(keys, f)

  local i = 0
  return function()
    i = i + 1
    return keys[i], t[keys[i]]
  end
end

function F.Table.SafePack(...)
  return { n = select("#", ...), ... }
end

function F.Table.SafeUnpack(tbl)
  return unpack(tbl, 1, tbl.n)
end
