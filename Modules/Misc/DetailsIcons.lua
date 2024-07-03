local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local M = TXUI:GetModule("Misc")

function M:DetailsIcons()
  if F.IsAddOnEnabled("Details") then
    local iconsPath = "Interface\\AddOns\\ElvUI_ToxiUI\\Media\\Textures\\Icons\\"
    local logoPath = "Interface\\AddOns\\ElvUI_ToxiUI\\Media\\Backgrounds\\Logos\\LogoSmall.tga"
    local coords = { 0, 1, 0, 1 }

    Details:AddCustomIconSet(iconsPath .. "ToxiClasses.blp", TXUI.Title, false, logoPath, coords)
    Details:AddCustomIconSet(iconsPath .. "UggColored.blp", F.String.Ugg() .. " " .. F.String.Rainbow("Colored"), false, logoPath, coords)
    Details:AddCustomIconSet(iconsPath .. "UggColoredStroke.blp", F.String.Ugg() .. " " .. F.String.Rainbow("Colored") .. " Stroke", false, logoPath, coords)
    Details:AddCustomIconSet(iconsPath .. "UggWhiteStroke.blp", F.String.Ugg() .. " White Stroke", false, logoPath, coords)

    Details:AddCustomIconSet(iconsPath .. "ToxiSpecStylized.blp", TXUI.Title .. " " .. F.String.Class("Spec") .. " Stylized", true, logoPath, coords)
    Details:AddCustomIconSet(iconsPath .. "ToxiSpecColored.blp", TXUI.Title .. " " .. F.String.Class("Spec") .. " " .. F.String.Rainbow("Colored"), true, logoPath, coords)
    Details:AddCustomIconSet(
      iconsPath .. "ToxiSpecColoredStroke.blp",
      TXUI.Title .. " " .. F.String.Class("Spec") .. " " .. F.String.Rainbow("Colored") .. " Stroke",
      true,
      logoPath,
      coords
    )
    Details:AddCustomIconSet(iconsPath .. "ToxiSpecWhite.blp", TXUI.Title .. " " .. F.String.Class("Spec") .. " White", true, logoPath, coords)
    Details:AddCustomIconSet(iconsPath .. "ToxiSpecWhiteStroke.blp", TXUI.Title .. " " .. F.String.Class("Spec") .. " White Stroke", true, logoPath, coords)
  end
end

M:AddCallback("DetailsIcons")
