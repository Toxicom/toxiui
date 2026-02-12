local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local PF = TXUI:GetModule("Profiles")

local whiteText = { colors = { text = F.Table.HexToRGB("#ffffff") } }
local whiteTextReversed = { reverse = true, colors = { text = F.Table.HexToRGB("#ffffff") } }

local cooldown = {
  -- Per-module overrides
  actionbar = whiteText,
  aurabars = whiteText,
  auraindicator = whiteText,
  bags = whiteText,
  bossbutton = whiteText,
  global = whiteText,
  totemtracker = whiteText,
  zonebutton = whiteText,

  nameplates = whiteTextReversed,
  unitframe = whiteTextReversed,
  cdmanager = whiteTextReversed,

  auras = {
    colors = { text = F.Table.CurrentClassColor() },
    offsetY = -10,
  },
}

function PF:ApplyCooldowns(pf)
  F.Table.Crush(pf.cooldown, cooldown)
end
