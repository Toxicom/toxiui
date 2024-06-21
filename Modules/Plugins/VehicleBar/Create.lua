local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local VB = TXUI:GetModule("VehicleBar")

function VB:CreateVigorBar()
  local vigorBar = CreateFrame("Frame", "CustomVigorBar", UIParent)
  local width = self.bar:GetWidth()
  vigorBar:SetSize(width - self.spacing, self.vigorHeight)
  vigorBar:SetPoint("BOTTOM", self.bar, "TOP", 0, self.spacing * 3) -- Adjust position as needed

  -- Create the speed text
  vigorBar.speedText = vigorBar:CreateFontString(nil, "OVERLAY")
  vigorBar.speedText:SetFont(F.GetFontPath(I.Fonts.TitleBlack), F.FontSizeScaled(24), "OUTLINE")
  vigorBar.speedText:SetPoint("BOTTOM", vigorBar, "TOP", 0, 0)
  vigorBar.speedText:SetText("0%")

  -- Set parent-child relationship
  vigorBar.speedText:SetParent(vigorBar)

  vigorBar:Hide()

  -- Update speed text regularly
  vigorBar:SetScript("OnUpdate", function()
    self:UpdateSpeedText()
  end)

  vigorBar.segments = {}
  self.vigorBar = vigorBar

  self:UpdateVigorSegments()
end
