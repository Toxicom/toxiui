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
