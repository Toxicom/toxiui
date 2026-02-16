local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local GM = TXUI:GetModule("GameMenu")
local Misc = TXUI:GetModule("Misc")

local m = GM.Spacing

function GM:CreatePlayerInfo()
  local parent = self.backgroundFade

  -- Bottom text promotion
  parent.bottomText = parent:CreateFontString(nil, "OVERLAY")
  parent.bottomText:Point("BOTTOM", 0, self.outerSpacing)
  parent.bottomText:SetFont(self.primaryFont, F.FontSizeScaled(14), "OUTLINE")
  parent.bottomText:SetTextColor(1, 1, 1, 0.6)
  parent.bottomText:SetText("You can find all the relevant " .. TXUI.Title .. " information at " .. I.Strings.Branding.Links.Website)

  -- Player Name
  parent.nameText = parent:CreateFontString(nil, "OVERLAY")
  parent.nameText:SetPoint("TOP", parent.logo, "BOTTOM", 0, m(-8))
  parent.nameText:SetFont(self.titleFont, F.FontSizeScaled(28), "OUTLINE")
  parent.nameText:SetTextColor(1, 1, 1, 1)
  parent.nameText:SetText(F.String.GradientClass(E.myname))

  -- Player Guild
  parent.guildText = parent:CreateFontString(nil, "OVERLAY")
  parent.guildText:SetPoint("TOP", parent.nameText, "BOTTOM", 0, 0)
  parent.guildText:SetFont(self.primaryFont, F.FontSizeScaled(16), "OUTLINE")
  parent.guildText:SetTextColor(1, 1, 1, 1)

  -- Spec Icon
  parent.specIcon = parent:CreateFontString(nil, "OVERLAY")
  parent.specIcon:SetPoint("TOP", parent.guildText, "BOTTOM", 0, m(-6))

  -- Level
  parent.levelText = parent:CreateFontString(nil, "OVERLAY")
  parent.levelText:SetPoint("RIGHT", parent.specIcon, "LEFT", m(-1), 0)
  parent.levelText:SetFont(self.primaryFont, F.FontSizeScaled(20), "OUTLINE")
  parent.levelText:SetTextColor(1, 1, 1, 1)

  -- Class
  parent.classText = parent:CreateFontString(nil, "OVERLAY")
  parent.classText:SetPoint("LEFT", parent.specIcon, "RIGHT", m(1), 0)
  parent.classText:SetFont(self.primaryFont, F.FontSizeScaled(20), "OUTLINE")
  parent.classText:SetTextColor(1, 1, 1, 1)
end

function GM:UpdatePlayerInfo()
  if not self.backgroundFade or not self.backgroundFade.guildText then return end

  local guildName = GetGuildInfo("player")
  local specIcon, iconsFont = Misc:GenerateSpecIcon(self.db.specIconStyle)

  self.backgroundFade.specIcon:SetFont(iconsFont, F.FontSizeScaled(self.db.specIconSize), "")
  self.backgroundFade.specIcon:SetTextColor(1, 1, 1, 1)

  self.backgroundFade.guildText:SetText(guildName and F.String.FastGradientHex("<" .. guildName .. ">", "06c910", "33ff3d") or "")
  self.backgroundFade.specIcon:SetText(specIcon)
  self.backgroundFade.levelText:SetText("Lv " .. E.mylevel)
  self.backgroundFade.classText:SetText(F.String.GradientClass(E.myLocalizedClass, nil, true))
end
