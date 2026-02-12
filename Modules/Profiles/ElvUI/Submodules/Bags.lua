local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local PF = TXUI:GetModule("Profiles")

local bags = {
  bagSize = F.Dpi(53),
  bagWidth = F.Dpi(840),
  bankSize = F.Dpi(48),
  bankWidth = F.Dpi(840),

  useBlizzardCleanup = false,
  clearSearchOnClose = true,
  junkIcon = true,
  moneyCoins = false,
  scrapIcon = true,
  showBindType = true,
  vendorGrays = {
    enable = true,
  },

  spinner = {
    enable = true,
    size = 80,
    color = I.Strings.Branding.ColorRGB,
  },
}

function PF:ApplyBags(pf)
  F.Table.Crush(pf.bags, bags)
end
