local TXUI, F, _, I, V, P, G = unpack((select(2, ...)))
local LP = TXUI:GetModule("LandingPage")

-- Build the page list for the post-update landing page.
-- Add `image`, `imageWidth`, `imageHeight` to any page to show a screenshot.
function LP:GetUpdatePages()
  local title = F.String.ToxiUI(TXUI.Title)
  local CL = TXUI:GetModule("Changelog")
  local versionString = CL:FormattedVersion()

  return {
    -- Page 1: Updated successfully
    {
      title = "Updated to " .. versionString,
      text = title
        .. " has been updated to version "
        .. F.String.Good(versionString)
        .. ". Thanks for keeping up to date!\n\n"
        .. F.String.Good("You do not need to re-run the installer.")
        .. " Updating the addon does not reset your profile "
        .. "or require a full reinstall. Your settings are safe.\n\n"
        .. "If you want to pull in new "
        .. title
        .. " defaults for specific parts of your UI, "
        .. "that is exactly what the "
        .. F.String.ToxiUI("Profile Updater")
        .. " is for.\n\n"
        .. F.String.Silver("Continue to learn more, or close this window and play."),
    },

    -- Page 2: Profile Updater
    {
      title = "Meet the Profile Updater",
      text = "The "
        .. F.String.ToxiUI("Profile Updater")
        .. " is the recommended way to apply new "
        .. title
        .. " defaults after an update. It gives you full control over what changes.\n\n"
        .. "Open it with "
        .. F.String.Good("/tx u")
        .. " and you will see every section of the profile "
        .. "that has changed since your last update. Hover any section for a live before/after diff, "
        .. "tick the ones you want, and click "
        .. F.String.Good("Apply")
        .. ".\n\n"
        .. "Only the sections you choose are touched. Everything else stays exactly as you left it.\n\n"
        .. F.String.Silver("Tip: check the Changelog first (/tx > Changelog) to see what changed before deciding what to apply."),
      button = {
        text = "Open Profile Updater",
        onClick = function()
          LP:CloseLandingPage()
          TXUI:GetModule("ProfileUpdater"):Toggle()
        end,
      },
    },
  }
end
