local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

local COVENANT_COLORS = COVENANT_COLORS
local format = string.format
local gmatch = string.gmatch
local char = string.char
local floor = math.floor
local error = error
local tostring = tostring
local gsub = string.gsub
local strmatch = strmatch
local strtrim = strtrim
local type = type
local utf8len = string.utf8len
local utf8lower = string.utf8lower
local utf8sub = string.utf8sub
local utf8upper = string.utf8upper

F.String = {
  Menu = {},
}

function F.String.Color(msg, color)
  if type(color) == "string" then
    if #color == 8 then
      return "|c" .. color .. msg .. "|r"
    else
      return "|cff" .. color .. msg .. "|r"
    end
  else
    return "|cff" .. I.Strings.Colors[color] .. msg .. "|r"
  end
end

function F.String.Sublist(msg)
  return "\n  - |cffbdbdbd" .. msg .. "|r"
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

function F.String.Plater(msg)
  if not msg or msg == "" then return F.String.Color("Plater", I.Enum.Colors.PLATER) end

  return F.String.Color(msg, I.Enum.Colors.PLATER)
end

function F.String.Details(msg)
  if not msg or msg == "" then return F.String.Color("Details", I.Enum.Colors.DETAILS) end

  return F.String.Color(msg, I.Enum.Colors.DETAILS)
end

function F.String.BigWigs(msg)
  if not msg or msg == "" then return F.String.Color("BigWigs", I.Enum.Colors.BIGWIGS) end

  return F.String.Color(msg, I.Enum.Colors.BIGWIGS)
end

function F.String.NameplateSCT(msg)
  if not msg or msg == "" then return F.String.Color("NameplateSCT", I.Enum.Colors.NSCT) end

  return F.String.Color(msg, I.Enum.Colors.NSCT)
end

function F.String.OmniCD(msg)
  if not msg or msg == "" then return F.String.Color("OmniCD", I.Enum.Colors.OMNICD) end

  return F.String.Color(msg, I.Enum.Colors.OMNICD)
end

function F.String.WarpDeplete(msg)
  if not msg or msg == "" then return F.String.Color("WarpDeplete", I.Enum.Colors.WDP) end

  return F.String.Color(msg, I.Enum.Colors.WDP)
end

function F.String.WindTools(msg)
  if not msg or msg == "" then return "|cff5385edW|r|cff5094eai|r|cff4da4e7n|r|cff4ab4e4d|r|cff47c0e1T|r|cff44cbdfo|r|cff41d7ddo|r|cff41d7ddl|r|cff41d7dds|r" end

  return F.String.FastGradientHex(msg, "#5385ed", "#41d7dd")
end

function F.String.ElvUI(msg)
  if not msg or msg == "" then return F.String.Color("ElvUI", I.Enum.Colors.ELVUI) end

  return F.String.Color(msg, I.Enum.Colors.ELVUI)
end

function F.String.ElvUIValue(msg)
  return F.String.RGB(msg, E.media.rgbvaluecolor)
end

function F.String.Class(msg, class)
  local finalClass = class or E.myclass

  local color = E:ClassColor(finalClass, true)
  return F.String.Color(msg, F.String.FastRGB(color.r, color.g, color.b))
end

function F.String.RandomClassColor(msg)
  local classNames
  if TXUI.IsVanilla then
    classNames = I.Strings.Classes.VANILLA
  elseif TXUI.IsMists then
    classNames = I.Strings.Classes.MISTS
  else
    classNames = I.Strings.Classes.RETAIL
  end

  local randomClass = classNames[math.random(1, #classNames)]
  local color = E:ClassColor(randomClass, true)
  return F.String.Color(msg, F.String.FastRGB(color.r, color.g, color.b))
end

function F.String.Luxthos(msg)
  if not msg or msg == "" then msg = "Luxthos" end
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

function F.String.WunderUI()
  return F.String.Epic("Wunder") .. "UI"
end

function F.String.Eltreum()
  -- taken from Eltruism .toc
  return F.String.FastGradientHex("Eltreum", "#587AAD", "#9FE3F4")
end

function F.String.Ugg()
  return F.String.Color("U.", "3273fa") .. F.String.Color("GG", "ffffff")
end

function F.String.Scaling()
  return F.String.ToxiUI("Additional Scaling") .. " module"
end

function F.String.ReforgedArmory()
  return F.String.Class("Reforged", "MONK") .. F.String.Class("Armory", "ROGUE")
end

function F.String.MinElv(ver)
  return "Increase minimum required " .. F.String.ElvUI() .. " version to " .. ver
end

function F.String.GradientString()
  return F.String.FastGradient("Gradient", 0, 0.6, 1, 0, 0.9, 1)
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
    local base = TXUI.IsVanilla and I.Strings.WALinks.FORMAT_VANILLA or TXUI.IsMists and I.Strings.WALinks.FORMAT_MISTS or I.Strings.WALinks.FORMAT
    return format(base, classLink)
  end

  return I.Strings.WALinks.DEFAULT
end

function F.String.RemoveRuneOfThePrefix(text)
  return text:gsub(".* the ", ""):gsub(".* of ", "")
end

function F.String.RemoveEveryOfTheAndEverythingAfter(text)
  return text:gsub(" of (.*)", ""):gsub(" the (.*)", "")
end

-- Capture the following strings
-- .+%s(.+)$
-- . represents all characters
-- + makes us capture 1 or more repetitions of the previous character/symbol will always match the longest possible part
-- %s represents all space characters
-- $ at the end makes the pattern match to the end of the string
-- Example: "Lightweave Embroidery" captures "Embroidery"
function F.String.GetTheLastWordOfAString(text)
  return strmatch(text, ".+%s(.+)$")
end

-- Capture the following string
-- ^[%s%p]*
-- ^ forces us to start capturing at the start of the string
-- %s represents all space characters
-- %p represents all punctuation characters
-- * matches 0 or more repetitions of the previous character/symbol/pattern
-- [] is a capture group
-- This would capture the start of the string and replace all spaces with nothing (but most likely isn't working)
function F.String.RemoveAllWhitespaceCharacters(text)
  return text:gsub("^[%s%p]*", "")
end

-- Capture the following string
-- %d+
-- %d represents all digits
-- this would capture the longest number chain in a string
function F.String.ContainsNumericalCharacters(text)
  return strmatch(text, "%d+")
end

-- Capture the following string
-- %d+
-- %d represents all digits
-- this would capture the longest number chain in a string
function F.String.RemoveTheLongestNumericalChain(text)
  return text:gsub("%D+", "")
end

function F.String.Abbreviate(text)
  if type(text) ~= "string" or text == "" then return text end

  -- if string has Rune at the start it is almost 100% a DK Rune and needs some different initial logic.
  if strmatch(text, "^Rune") then
    text = F.String.RemoveRuneOfThePrefix(text)
  else
    text = F.String.RemoveEveryOfTheAndEverythingAfter(text)
  end

  local letters = ""
  local lastWord = F.String.GetTheLastWordOfAString(text)
  if not lastWord then return text end

  -- split the string on each space and loop through them
  -- If we have a string that contains numbers we will add them differently to the stringbuilder
  -- If we have an alphabetical word we check if the first letter is Uppercase, if this is the case add it to the resulting string with a . after it
  -- Else we ignore the word
  for word in gmatch(text, ".-%s") do
    local firstLetter = F.String.RemoveAllWhitespaceCharacters(word)

    if not F.String.ContainsNumericalCharacters(firstLetter) then
      firstLetter = utf8sub(firstLetter, 1, 1)
      if firstLetter ~= utf8lower(firstLetter) then
        -- combine letters value with firstletter value, and then add a . and space
        letters = format("%s%s. ", letters, firstLetter)
      end
    else
      firstLetter = F.String.RemoveTheLongestNumericalChain(firstLetter)
      -- combine letters value with firstLetter value and then add a space
      letters = format("%s%s ", letters, firstLetter)
    end
  end

  -- Combine the build string in the loop and the complete last word
  return format("%s%s", letters, lastWord)
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
  -- Remove |c...|r format
  text = text:gsub("|c%x%x%x%x%x%x%x%x(.-)|r", "%1")
  -- Remove |cn...: format
  text = text:gsub("|cn.-:(.-)|r", "%1")
  -- Remove any remaining |r
  text = text:gsub("|r", "")
  -- Remove any remaining |
  text = text:gsub("|", "")

  return text
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

function F.String.Rainbow(text)
  -- Define a table of color codes for the rainbow
  local colors = {
    "|cFFFF0000", -- Red
    "|cFFFF7F00", -- Orange
    "|cFFFFFF00", -- Yellow
    "|cFF00FF00", -- Green
    "|cFF0000FF", -- Blue
    "|cFF4B0082", -- Indigo
    "|cFF8B00FF", -- Violet
  }

  -- The resulting string
  local result = ""

  -- Length of the text
  local textLength = string.len(text)

  -- Iterate through each character of the input text
  for i = 1, textLength do
    -- Select color based on the current character position mod the number of colors
    local color = colors[((i - 1) % #colors) + 1]

    -- Append the colored character to the result string
    result = result .. color .. string.sub(text, i, i) .. "|r"
  end

  return result
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

function F.String.GradientClass(text, class, reverse)
  if not text or text == "" then return end

  local unitClass = class or E.myclass

  if E.db.TXUI.themes.gradientMode.classColorMap then
    local colorMap = E.db.TXUI.themes.gradientMode.classColorMap

    -- check if class is an actual valid class that we have gradients for, if not, fallback to player's class
    if not colorMap[1][unitClass] then unitClass = E.myclass end

    local left = colorMap[1][unitClass] -- Left (player UF)
    local right = colorMap[2][unitClass] -- Right (player UF)

    if left and left.r and right and right.r then
      if not reverse then
        return F.String.FastGradient(text, left.r, left.g, left.b, right.r, right.g, right.b)
      else
        return F.String.FastGradient(text, right.r, right.g, right.b, left.r, left.g, left.b)
      end
    else
      return text
    end
  else
    return text
  end
end

function F.String.Menu.General()
  return F.String.FastGradientHex("General", "#fffd61", "#c79a00")
end

function F.String.Menu.Contacts()
  return F.String.FastGradientHex("Contacts", "#ffa270", "#c63f17")
end

function F.String.Menu.Themes()
  return F.String.FastGradientHex("Themes", "#73e8ff", "#0086c3")
end

function F.String.Menu.WunderBar()
  return F.String.FastGradientHex("WunderBar", "#98ee99", "#338a3e")
end

function F.String.Menu.Armory()
  return F.String.FastGradientHex("Armory", "#6ff9ff", "#0095a8")
end

function F.String.Menu.Skins()
  return F.String.FastGradientHex("Skins", "#ff77a9", "#bf66ff")
end

function F.String.Menu.Styles()
  return F.String.FastGradientHex("Styles", "#ff26a8", "#a10355")
end

function F.String.Menu.Fonts()
  return F.String.FastGradientHex("Fonts", "#df78ef", "#790e8b")
end

function F.String.Menu.Plugins()
  return F.String.FastGradientHex("Plugins", "#b085f5", "#4d2c91")
end

function F.String.Menu.Changelog()
  return F.String.FastGradientHex("Changelog", "#8e99f3", "#26418f")
end

function F.String.Menu.Reset()
  return F.String.FastGradientHex("Reset", "#ff867c", "#b61827")
end

function F.String.Menu.Performance()
  return F.String.FastGradientHex("Performance", "#00ff31", "#00ffdc")
end

-- Credits to WunderUI
function F.String.ConvertGlyph(unicode)
  if unicode <= 0x7F then return char(unicode) end
  if unicode <= 0x7FF then return char(0xC0 + floor(unicode / 0x40), 0x80 + (unicode % 0x40)) end
  if unicode <= 0xFFFF then return char(0xE0 + floor(unicode / 0x1000), 0x80 + (floor(unicode / 0x40) % 0x40), 0x80 + (unicode % 0x40)) end
  error("Could not convert unicode " .. tostring(unicode))
end

function F.String.FormatTime(seconds)
  if seconds >= 3600 then
    return string.format("%02d:%02d", math.floor(seconds / 3600), math.floor((seconds % 3600) / 60))
  else
    return string.format("%02d:%02d", math.floor(seconds / 60), seconds % 60)
  end
end

function F.String.FormatTimeClass(seconds)
  local class = E.myclass
  if seconds >= 60 then
    local minutes = math.floor(seconds / 60)
    return minutes .. F.String.Class("m", class)
  else
    return math.floor(seconds) .. F.String.Class("s", class)
  end
end
