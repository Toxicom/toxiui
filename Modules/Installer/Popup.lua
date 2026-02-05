local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local IS = TXUI:GetModule("Installer")
local PF = TXUI:GetModule("Profiles")

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

-- Import Existing Profile Popup
function IS:ShowImportProfilePopup()
  local CL = TXUI:GetModule("Changelog")
  local profiles = self:FindNewestTXUIProfiles()

  -- Build the popup text (both profiles guaranteed to exist at this point)
  local publicVersionStr = CL:FormattedVersion(profiles.public.version)
  local privateVersionStr = CL:FormattedVersion(profiles.private.version)

  local text = F.String.ToxiUI("Found ToxiUI Profiles:") .. "\n\n"
  text = text .. "Public: " .. F.String.Good(profiles.public.name) .. " (" .. F.String.Class(publicVersionStr, "MONK") .. ")\n"
  text = text .. "Private: " .. F.String.Good(profiles.private.name) .. " (" .. F.String.Class(privateVersionStr, "MONK") .. ")\n"
  text = text .. "\n" .. F.String.Warning("Import these settings to your current profile?")

  local dialogName = "TXUI_ImportProfilePopup"

  E.PopupDialogs[dialogName] = {
    text = text,
    button1 = "Import",
    button2 = CANCEL,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = 1,
    OnAccept = function()
      IS:ImportExistingProfiles(profiles)
    end,
  }

  E:StaticPopup_Show(dialogName)
end

-- No ToxiUI Profiles Found Popup
function IS:ShowNoProfilesFoundPopup()
  local dialogName = "TXUI_NoProfilesFoundPopup"

  E.PopupDialogs[dialogName] = {
    text = F.String.Error("No valid ToxiUI profiles found!")
      .. "\n\n"
      .. "A valid "
      .. TXUI.Title
      .. " profile requires both public and private profile data.\n\nPlease use the regular installation process instead.",
    button1 = OKAY,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = 1,
  }

  E:StaticPopup_Show(dialogName)
end

-- Already on Latest Profile Popup
function IS:ShowAlreadyLatestPopup()
  local dialogName = "TXUI_AlreadyLatestPopup"

  E.PopupDialogs[dialogName] = {
    text = F.String.Good("You are already on the latest version!") .. "\n\n" .. "Your current private profile is already the newest " .. TXUI.Title .. " profile available.",
    button1 = OKAY,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = 1,
  }

  E:StaticPopup_Show(dialogName)
end
