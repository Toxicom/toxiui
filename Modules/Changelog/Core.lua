local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local CL = TXUI:GetModule("Changelog")

local print = print
local select = select
local UnitName = UnitName

-- Version Check
function CL:CheckVersion()
  if not F.IsTXUIProfile() then
    E:GetModule("PluginInstaller"):Queue(TXUI:GetModule("Installer"):Dialog())
  else
    local releaseVersion = F.GetDBFromPath("TXUI.changelog.releaseVersion")
    local newVersion = not releaseVersion or releaseVersion == 0 or self:HasUpdates(releaseVersion)
    if not newVersion then return end

    self:LogDebug("Showing Update Popup", releaseVersion)
    E:StaticPopup_Show("TXUI_OPEN_UPDATER")
  end
end

-- Version Check for the character specific profile
function CL:CheckPrivateProfileVersion()
  if not F.IsTXUIProfile() then return end

  local releaseVersion = F.GetDBFromPath("TXUI.changelog.releaseVersion")
  if not releaseVersion or releaseVersion == 0 or self:HasUpdates(releaseVersion) then return end

  local privateVersion = F.GetDBFromPath("TXUI.changelog.releaseVersion", E.private)
  if privateVersion and privateVersion ~= 0 and not self:HasUpdates(privateVersion) then return end

  self:LogDebug("Showing Private Update Popup", releaseVersion, privateVersion)
  E:StaticPopup_Show("TXUI_OPEN_PRIVATE_UPDATER")
end

-- Has seen changelog popup
function CL:CheckChangelogSeen()
  if TXUI:GetModule("WunderBar").ToxiUIShown() then return end -- Don't show when we use the toxi icon
  if not self:HasSeenChangelog() then E:StaticPopup_Show("TXUI_OPEN_CHANGELOG") end
end

-- Has seen changelog check
function CL:HasSeenChangelog()
  if
    F.IsTXUIProfile()
    and self:IsSame(E.db.TXUI.changelog.releaseVersion, TXUI.ReleaseVersion) -- latest version installed
    and ((not E.db.TXUI.changelog.seenVersion or E.db.TXUI.changelog.seenVersion == 0) or self:HasUpdates(E.db.TXUI.changelog.seenVersion))
  then -- not asked before on this version
    return false
  end

  return true
end

-- Check for all our profiles
function CL:ProfileChecks()
  -- Check if a new release is available, if not in combat
  self:CheckVersion()

  -- Check if the private profile is on the same version as ours
  self:CheckPrivateProfileVersion()

  -- Check if the user has not seen a changelog yet
  self:CheckChangelogSeen()
end

-- Initialization
function CL:Initialize()
  -- Don't init second time
  if self.Initialized then return end

  -- Read version from changelog
  TXUI.ReleaseVersion = self:GetVersion()

  -- Check for empty git hash
  if TXUI.GitHash == "DEV" then TXUI.GitHash = TXUI.ReleaseVersion end

  -- Get formatted current version
  local versionString = self:FormattedVersion()

  -- Login Message
  if E.db.general.loginmessage then
    local msg = "Hello, "
      .. UnitName("Player")
      .. ". Welcome to "
      .. TXUI.Title
      .. " "
      .. versionString
      .. " by "
      .. F.String.Authors()
      .. ", please visit https://toxiui.com for updates. Thank you."

    -- Convert URL to clickable if chat is loaded
    if E:GetModule("Chat").Initialized then msg = select(2, E:GetModule("Chat"):FindURL("CHAT_MSG_DUMMY", msg)) end

    print(msg) -- we do not use TXUI:Print since its already formatted
  end

  -- Load all changelog/updater/private check popups
  self:LoadPopups()

  -- Register events for checks
  F.Event.RegisterOnceCallback("TXUI.InitializedSafe", F.Event.GenerateClosure(self.ProfileChecks, self))
  F.Event.RegisterCallback("TXUI.DatabaseUpdate", self.ProfileChecks, self)

  -- We are done hooray!
  self.Initialized = true
end

TXUI:RegisterModule(CL:GetName())
