local TXUI, F, E, I, V, P, G = unpack(select(2, ...))

local COVENANT_COLORS = COVENANT_COLORS
local format = string.format
local gmatch = string.gmatch
local gsub = string.gsub
local strmatch = strmatch
local strtrim = strtrim
local type = type
local utf8len = string.utf8len
local utf8lower = string.utf8lower
local utf8sub = string.utf8sub
local utf8upper = string.utf8upper

F.String = {}

function F.String.Color(msg, color)
  if type(color) == "string" then
    return "|cff" .. color .. msg .. "|r"
  else
    return "|cff" .. I.Strings.Colors[color] .. msg .. "|r"
  end
end

function F.String.HexToRGB(hex)
  local r, g, b, a = strmatch(hex, "^#?(%x%x)(%x%x)(%x%x)(%x?%x?)$")
  if not r then return 0, 0, 0, nil end
  return tonumber(r, 16) / 255, tonumber(g, 16) / 255, tonumber(b, 16) / 255, (a ~= "") and (tonumber(a, 16) / 255) or nil
end

function F.String.FastRGB(r, g, b)
  return format("%02x%02x%02x", r * 255, g * 255, b * 255)
end

function F.String.FastRGBA(r, g, b, a)
  return format("%02x%02x%02x%02x", (a or 1) * 255, r * 255, g * 255, b * 255)
end

function F.String.RGB(msg, colors)
  if colors.r then
    return F.String.Color(msg, F.String.FastRGB(colors.r, colors.g, colors.b))
  else
    return F.String.Color(msg, F.String.FastRGB(colors[1], colors[2], colors[3]))
  end
end

function F.String.ToxiUI(msg)
  return F.String.Color(msg, I.Enum.Colors.TXUI)
end

function F.String.ElvUI(msg)
  return F.String.Color(msg, I.Enum.Colors.ELVUI)
end

function F.String.ElvUIValue(msg)
  return F.String.RGB(msg, E.media.rgbvaluecolor)
end

function F.String.Class(msg, class)
  local color = E:ClassColor(class or E.myclass, true)
  return F.String.Color(msg, F.String.FastRGB(color.r, color.g, color.b))
end

function F.String.RandomClassColor(msg)
  local classNames
  if TXUI.IsClassic then
    classNames = I.Strings.Classes.CLASSIC
  elseif TXUI.IsWrath then
    classNames = I.Strings.Classes.WRATH
  else
    classNames = I.Strings.Classes.RETAIL
  end

  local randomClass = classNames[math.random(1, #classNames)]
  local color = E:ClassColor(randomClass, true)
  return F.String.Color(msg, F.String.FastRGB(color.r, color.g, color.b))
end

function F.String.Luxthos(msg)
  return F.String.Color(msg, I.Enum.Colors.LUXTHOS)
end

function F.String.Authors()
  return F.String.ToxiUI("Toxi")
end

function F.String.Error(msg)
  return F.String.Color(msg, I.Enum.Colors.ERROR)
end

function F.String.Good(msg)
  return F.String.Color(msg, I.Enum.Colors.GOOD)
end

function F.String.Warning(msg)
  return F.String.Color(msg, I.Enum.Colors.WARNING)
end

-- Supporter colors
function F.String.Legendary(msg)
  return F.String.Color(msg, I.Enum.Colors.LEGENDARY)
end

function F.String.Epic(msg)
  return F.String.Color(msg, I.Enum.Colors.EPIC)
end

function F.String.Rare(msg)
  return F.String.Color(msg, I.Enum.Colors.RARE)
end

function F.String.Beta(msg)
  return F.String.Color(msg, I.Enum.Colors.BETA)
end

function F.String.Covenant(msg)
  if not TXUI.IsRetail then return F.String.ElvUI(msg) end

  local covenantColor = COVENANT_COLORS[F.GetCachedCovenant()] or I.Strings.Branding.ColorRGBA
  return F.String.RGB(msg, covenantColor)
end

function F.String.WALink(class)
  class = class or E.myclass
  local classLink = I.Strings.WALinks[class]

  if classLink ~= nil then
    local base = TXUI.IsClassic and I.Strings.WALinks.FORMAT_CLASSIC or TXUI.IsWrath and I.Strings.WALinks.FORMAT_WRATH or I.Strings.WALinks.FORMAT
    return format(base, classLink)
  end

  return TXUI.IsClassic and I.Strings.WALinks.DEFAULT_CLASSIC or I.Strings.WALinks.DEFAULT
end

function F.String.Abbreviate(text)
  if type(text) ~= "string" or text == "" then return text end

  if (text:gsub(" of (.*)", "")):gsub(" the (.*)", "") == "Rune" then
    text = text:gsub(".* the ", ""):gsub(".* of ", "")
  else
    text = text:gsub(" of (.*)", ""):gsub(" the (.*)", "")
  end

  local letters, lastWord = "", strmatch(text, ".+%s(.+)$")
  if lastWord then
    for word in gmatch(text, ".-%s") do
      local firstLetter = gsub(word, "^[%s%p]*", "")

      if not strmatch(firstLetter, "%d+") then
        firstLetter = utf8sub(firstLetter, 1, 1)
        if firstLetter ~= utf8lower(firstLetter) then letters = format("%s%s. ", letters, firstLetter) end
      else
        firstLetter = gsub(firstLetter, "%D+", "")
        letters = format("%s%s ", letters, firstLetter)
      end
    end

    return format("%s%s", letters, lastWord)
  end

  return text
end

E.TagFunctions.Abbrev = F.String.Abbreviate

function F.String.Uppercase(text)
  if type(text) ~= "string" then return text end
  return utf8upper(text)
end

function F.String.Lowercase(text)
  if type(text) ~= "string" then return text end
  return utf8lower(text)
end

function F.String.UppercaseFirstLetter(text)
  if type(text) ~= "string" then return text end
  return utf8upper(utf8sub(text, 1, 1)) .. utf8sub(text, 2)
end

function F.String.UppercaseFirstLetterOnly(text)
  if type(text) ~= "string" then return text end
  return utf8upper(utf8sub(text, 1, 1)) .. utf8lower(utf8sub(text, 2))
end

function F.String.LowercaseEnum(text)
  if type(text) ~= "string" then return text end
  return strtrim(text):gsub("_", " "):gsub("(%a)([%w_']*)", function(a, b)
    return F.String.Uppercase(a) .. F.String.Lowercase(b)
  end)
end

function F.String.ColorFirstLetter(text)
  if type(text) ~= "string" then return text end
  return F.String.ToxiUI(utf8upper(utf8sub(text, 1, 1))) .. "|cfff5feff" .. utf8sub(text, 2) .. "|r"
end

function F.String.StripTexture(text)
  if type(text) ~= "string" then return text end
  return gsub(text, "(%s?)(|?)|[TA].-|[ta](%s?)", function(w, x, y)
    if x == "" then return (w ~= "" and w) or (y ~= "" and y) or "" end
  end)
end

function F.String.StripColor(text)
  if type(text) ~= "string" then return text end
  return gsub(text, "|c%x%x%x%x%x%x%x%x(.-)|r", "%1")
end

function F.String.Strip(text)
  if type(text) ~= "string" then return text end
  return F.String.StripColor(F.String.StripTexture(text))
end

function F.String.Trim(text)
  return strmatch(text, "^%s*(.*%S)") or ""
end

function F.String.FastGradient(text, r1, g1, b1, r2, g2, b2)
  local msg, len, idx = "", utf8len(text), 0

  for i = 1, len do
    local x = utf8sub(text, i, i)
    if strmatch(x, "%s") then
      msg = msg .. x
      idx = idx + 1
    else
      local relperc = (idx / len)

      if not r2 then
        msg = msg .. "|cff" .. F.String.FastRGB(r1, g1, b1) .. x .. "|r"
      else
        local r, g, b = F.FastColorGradient(relperc, r1, g1, b1, r2, g2, b2)
        msg = msg .. "|cff" .. F.String.FastRGB(r, g, b) .. x .. "|r"
        idx = idx + 1
      end
    end
  end

  return msg
end

function F.String.FastGradientHex(text, h1, h2)
  local r2, g2, b2
  local r1, g1, b1 = F.String.HexToRGB(h1)

  if h2 then
    r2, g2, b2 = F.String.HexToRGB(h2)
  else
    local h, s, l = F.ConvertToHSL(r1, g1, b1)
    r1, g1, b1 = F.ConvertToRGB(F.ClampToHSL(h, s * 0.95, l * 1.2))
    r2, g2, b2 = F.ConvertToRGB(F.ClampToHSL(h, s * 1.35, l * 0.85))
  end

  return F.String.FastGradient(text, r1, g1, b1, r2, g2, b2)
end

function F.String.FastColorGradientHex(percentage, h1, h2)
  local r1, g1, b1 = F.String.HexToRGB(h1)
  local r2, g2, b2 = F.String.HexToRGB(h2)

  return F.FastColorGradient(percentage, r1, g1, b1, r2, g2, b2)
end
