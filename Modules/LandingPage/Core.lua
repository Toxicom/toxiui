local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local LP = TXUI:NewModule("LandingPage")

-- Returns true if the given page type should be shown.
function LP:ShouldShowFrame(key)
  if not F.IsTXUIProfile() then return false end

  local releaseVersion = F.GetDBFromPath("TXUI.changelog.releaseVersion")
  if not releaseVersion or releaseVersion == 0 then return false end

  local CL = TXUI:GetModule("Changelog")

  if key == "fresh" then
    -- Only show once the installer has completed for the current version
    if CL:HasUpdates(releaseVersion) then return false end
    return not E.db.TXUI.landingPage.seenFreshInstall
  elseif key == "update" then
    -- Show when there is a pending addon update the user hasn't been notified about yet.
    -- Does NOT require the installer to have run — the LP content explains that it isn't needed.
    if not E.db.TXUI.landingPage.seenFreshInstall then return false end
    if not CL:IsNewer(TXUI.ReleaseVersion, releaseVersion) then return false end -- no update pending, nothing to show
    local seenVersion = E.db.TXUI.landingPage.seenUpdateVersion
    return not (seenVersion and seenVersion ~= 0 and not CL:IsNewer(TXUI.ReleaseVersion, seenVersion))
  end

  return false
end

function LP:ShowFrame(key)
  if key == "fresh" then
    self:ShowLandingPage {
      pages = self:GetFreshInstallPages(),
      onClose = function()
        E.db.TXUI.landingPage.seenFreshInstall = true
        -- If there's also a pending update LP (e.g. existing user who never saw
        -- the fresh install page), queue it to open on the next frame rather than
        -- suppressing it. For true fresh installs the versions match so
        -- ShouldShowFrame("update") will return false naturally.
        if self:ShouldShowFrame("update") then F.Event.RunNextFrame(function()
          self:ShowFrame("update")
        end) end
      end,
    }
  elseif key == "update" then
    self:ShowLandingPage {
      pages = self:GetUpdatePages(),
      onClose = function()
        E.db.TXUI.landingPage.seenUpdateVersion = TXUI.ReleaseVersion
      end,
    }
  end
end

function LP:CheckAndShow()
  if self:ShouldShowFrame("fresh") then
    self:ShowFrame("fresh")
  elseif self:ShouldShowFrame("update") then
    self:ShowFrame("update")
  end
end

function LP:Initialize()
  if self.Initialized then return end

  F.Event.RegisterOnceCallback("TXUI.InitializedSafe", F.Event.GenerateClosure(self.CheckAndShow, self))

  self.Initialized = true
end

TXUI:RegisterModule(LP:GetName())
