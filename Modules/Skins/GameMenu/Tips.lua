local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local GM = TXUI:GetModule("GameMenu")

local m = GM.Spacing

function GM:CreateTips()
  local parent = self.backgroundFade

  parent.tipText = parent:CreateFontString(nil, "OVERLAY")
  if parent.specIcon then
    parent.tipText:SetPoint("TOP", parent.specIcon, "BOTTOM", 0, m(-6))
  else
    parent.tipText:SetPoint("TOP", parent.logo, "BOTTOM", 0, m(-8))
  end
  parent.tipText:SetFont(self.primaryFont, F.FontSizeScaled(16), "OUTLINE")
  parent.tipText:SetTextColor(1, 1, 1, 1)
  parent.tipText:SetWidth(700)
end

function GM:UpdateTips()
  if not self.backgroundFade or not self.backgroundFade.tipText then return end

  local randomTips = I.Constants.RandomTips
  local randomIndex = math.random(1, #randomTips)
  local randomTip = randomTips[randomIndex]

  local monthDate = date("%m/%d")
  local year = date("%Y")
  local ToxiBirthday = monthDate == "01/06"
  local ToxiUiBirthday = monthDate == "10/18"
  local ToxiUiAge = year - 2020
  local holidays = { ["12/24"] = true, ["12/25"] = true, ["12/26"] = true }
  local holidayString = holidays[monthDate] and "\n\nThe " .. TXUI.Title .. " team wishes you Happy Holidays!" or ""

  local tipText = F.String.ToxiUI("Random tip #" .. randomIndex .. ": ") .. randomTip .. holidayString

  if ToxiBirthday then
    tipText = "Did you know that today, January 6th, is "
      .. F.String.ToxiUI("Toxi")
      .. "'s birthday?\n"
      .. F.String.ToxiUI("Fun fact:")
      .. " First version of the "
      .. TXUI.Title
      .. " installer was released on this day back in 2021!"
  elseif ToxiUiBirthday then
    tipText = "Did you know that today, October 18th, is " .. TXUI.Title .. "'s birthday? " .. TXUI.Title .. " is now " .. ToxiUiAge .. " years old!"
  end

  self.backgroundFade.tipText:SetText(tipText)
end
