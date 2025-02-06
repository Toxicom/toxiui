local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local S = TXUI:GetModule("Skins")

local _G = _G
local format = string.format

function S:ElvUI_WindTools()
  local loader = _G.BigWigsLoader

  -- BW Core not found, return
  if not loader then return end

  -- Unregister WindTools skinning cause we do our own
  E:Delay(2, function()
    loader.UnregisterMessage("WindTools", "BigWigs_FrameCreated") -- trolololol
  end)

  -- And go
  loader.RegisterMessage("ToxiUI", "BigWigs_FrameCreated", function(_, frame, name)
    if name == "QueueTimer" then
      local parent = frame:GetParent()
      frame:StripTextures()
      frame:CreateBackdrop("Transparent")
      frame:SetStatusBarTexture(E.media.normTex)
      frame:SetStatusBarColor(I.Strings.Branding.ColorRGB.r, I.Strings.Branding.ColorRGB.g, I.Strings.Branding.ColorRGB.b, 1)
      frame:SetSize(parent:GetWidth(), 10)
      frame:ClearAllPoints()
      frame:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", 0, -5)
      frame:SetPoint("TOPRIGHT", parent, "BOTTOMRIGHT", 0, -5)
      frame.text.SetFormattedText = function(text, _, time)
        text:SetText(format("%d", time))
      end
      frame.text:FontTemplate(F.GetFontPath(I.Fonts.Primary), F.FontSizeScaled(20), "OUTLINE")
      frame.text:ClearAllPoints()
      frame.text:SetPoint("TOP", frame, "TOP", 0, -3)
    end
  end)
end
