local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local IS = TXUI:GetModule("Installer")

-- Discord Popup Link
function IS:PopupDiscordLink()
  -- Create popup if it dosen't exist
  if not E.PopupDialogs.TXUI_DiscordLinkDisplay then
    E.PopupDialogs.TXUI_DiscordLinkDisplay = E.PopupDialogs.ELVUI_EDITBOX
    E.PopupDialogs.TXUI_DiscordLinkDisplay["text"] = "Use the following link to join us on Discord"
  end

  -- Show Popup
  E:StaticPopup_Show("TXUI_DiscordLinkDisplay", nil, nil, I.Strings.Branding.Links.Discord)
end

-- ToxiUI Website Popup Link
function IS:PopupWebsiteLink()
  -- Create popup if it dosen't exist
  if not E.PopupDialogs.TXUI_WebsiteLinkDisplay then
    E.PopupDialogs.TXUI_WebsiteLinkDisplay = E.PopupDialogs.ELVUI_EDITBOX
    E.PopupDialogs.TXUI_WebsiteLinkDisplay["text"] = "For more information please visit the " .. TXUI.Title .. " website via this link!"
  end

  -- Show Popup
  E:StaticPopup_Show("TXUI_WebsiteLinkDisplay", nil, nil, I.Strings.Branding.Links.Website)
end

-- ToxiUI WA Guide Popup Link
function IS:PopupWAGuide()
  -- Create popup if it dosen't exist
  if not E.PopupDialogs.TXUI_WAGuideDisplay then
    E.PopupDialogs.TXUI_WAGuideDisplay = E.PopupDialogs.ELVUI_EDITBOX
    E.PopupDialogs.TXUI_WAGuideDisplay["text"] = "Use the following link to see a guide on how to customise your WeakAuras to adapt to the " .. TXUI.Title .. " style."
  end

  -- Show Popup
  E:StaticPopup_Show("TXUI_WAGuideDisplay", nil, nil, I.Strings.Branding.Links.WAGuide)
end

-- Weakauras Popup Link
function IS:PopupWALink()
  -- Create popup if it dosen't exist
  if not E.PopupDialogs.TXUI_WALinkDisplay then
    E.PopupDialogs.TXUI_WALinkDisplay = E.PopupDialogs.ELVUI_EDITBOX
    if TXUI.IsVanilla then
      E.PopupDialogs.TXUI_WALinkDisplay["text"] = "Use the following link to get yourself a WeakAuras class package!"
    else
      E.PopupDialogs.TXUI_WALinkDisplay["text"] = "Use the following link to download " .. F.String.Luxthos("Luxthos") .. " WeakAuras!"
    end
  end

  -- Show Popup
  E:StaticPopup_Show("TXUI_WALinkDisplay", nil, nil, F.String.WALink())
end
