local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local PF = TXUI:GetModule("Profiles")

local tooltip = {
  colorAlpha = 0.75,
  guildRanks = false,
  playerTitles = false,

  healthBar = {
    height = 3,
  },

  visibility = {
    combatOverride = "SHOW",
  },
}

function PF:ApplyTooltip(pf)
  F.Table.Crush(pf.tooltip, tooltip)
end
