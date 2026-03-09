local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

local COVENANT_COLORS = COVENANT_COLORS

-- Addon and community branding strings, all exposed via F.String.*
-- Depends on F.String utilities from String.lua (load after)

-- Client tags

function F.String.Retail()
  return F.String.Color("[Retail]", "00ccff") .. " "
end

function F.String.Classic()
  return F.String.Color("[Mists]", "00ff96") .. " "
end

function F.String.Anniversary()
  return F.String.Color("[TBC]", "9eff00") .. " "
end

function F.String.Era()
  return F.String.Color("[Classic]", "ffcc00") .. " "
end

-- Addons

function F.String.ToxiUI(msg)
  return F.String.Color(msg, I.Enum.Colors.TXUI)
end

function F.String.ElvUI(msg)
  if not msg or msg == "" then return F.String.Color("ElvUI", I.Enum.Colors.ELVUI) end
  return F.String.Color(msg, I.Enum.Colors.ELVUI)
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
  return msg or "OmniCD"
end

function F.String.WarpDeplete(msg)
  if not msg or msg == "" then return F.String.Color("WarpDeplete", I.Enum.Colors.WDP) end
  return F.String.Color(msg, I.Enum.Colors.WDP)
end

function F.String.WindTools(msg)
  if not msg or msg == "" then return "|cff5385edW|r|cff5094eai|r|cff4da4e7n|r|cff4ab4e4d|r|cff47c0e1T|r|cff44cbdfo|r|cff41d7ddo|r|cff41d7ddl|r|cff41d7dds|r" end
  return F.String.FastGradientHex(msg, "#5385ed", "#41d7dd")
end

function F.String.WunderUI()
  return F.String.Epic("Wunder") .. "UI"
end

-- Community

function F.String.Luxthos(msg)
  if not msg or msg == "" then msg = "Luxthos" end
  return F.String.Color(msg, I.Enum.Colors.LUXTHOS)
end

function F.String.Eltreum()
  -- taken from Eltruism .toc
  return F.String.FastGradientHex("Eltreum", "#587AAD", "#9FE3F4")
end

function F.String.Kryo()
  return F.String.Class("Kryo", "DEMONHUNTER")
end

function F.String.Ugg()
  return F.String.Color("U.", "3273fa") .. F.String.Color("GG", "ffffff")
end

-- Supporter tiers

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

-- Product strings

function F.String.Authors()
  return F.String.ToxiUI("Toxi")
end

function F.String.Scaling()
  return F.String.ToxiUI("Additional Scaling") .. " module"
end

function F.String.CDM()
  return TXUI.Title .. " " .. F.String.Class("Cooldown Manager Skin", "MONK")
end

function F.String.ReforgedArmory()
  return F.String.Class("Reforged", "MONK") .. F.String.Class("Armory", "ROGUE")
end

function F.String.GradientString()
  return F.String.FastGradient("Gradient", 0, 0.6, 1, 0, 0.9, 1)
end

function F.String.Covenant(msg)
  if not TXUI.IsRetail then return F.String.ElvUI(msg) end
  local covenantColor = COVENANT_COLORS[F.GetCachedCovenant()] or I.Strings.Branding.ColorRGBA
  return F.String.RGB(msg, covenantColor)
end

function F.String.MinElv(ver)
  return "Increase minimum required " .. F.String.ElvUI() .. " version to " .. ver
end

-- Menu tab labels

F.String.Menu = F.String.Menu or {}

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
