local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local M = TXUI:GetModule("Misc")

local find = string.find
local wipe = wipe

-- Vars
local ct

local shortRealmName
function M:ChatIcon_DevIconCallback(sender)
  if not sender or sender == "" then return end
  -- Check if badges are active
  if E and E.db and E.db.TXUI and E.db.TXUI.general and E.db.TXUI.general.chatBadgeOverride then return end

  -- Strip colors
  local cleanName = F.String.StripColor(sender)
  -- Add realm name if the name has none
  if not find(cleanName, "-", 1, true) then
    if not shortRealmName then shortRealmName = E:ShortenRealm(E.myrealm) end
    cleanName = cleanName .. "-" .. shortRealmName
  end

  return F.GetChatIcon(cleanName)
end

function M:ChatIcon_Check()
  if (not E:GetModule("Chat")) or not E.private.chat.enable or (not TXUI:HasRequirements(I.Requirements.RoleIcons)) then -- ElvUI Chat
    return false
  end

  return true
end

function M:ChatIcon_RoleCheck()
  if
    not ct
    or not ct.db
    or not ct.db.enable
    or (ct.db.roleIconStyle ~= "BLIZZARD") -- WT Check
    or not E.db.TXUI.elvUIIcons.roleIcons
    or not E.db.TXUI.elvUIIcons.roleIcons.enabled -- TX Check
    or (not TXUI:HasRequirements(I.Requirements.RoleIcons))
  then
    return false
  end -- TX Check

  return true
end

function M:ChatIcon_UpdateRoleIcons(_)
  if not self:ChatIcon_RoleCheck() then return self.hooks[ct]["UpdateRoleIcons"](ct) end

  ct.cache.blizzardRoleIcons.Tank = self.iconCache.roles.Tank
  ct.cache.blizzardRoleIcons.Healer = self.iconCache.roles.Healer
  ct.cache.blizzardRoleIcons.DPS = self.iconCache.roles.DPS

  return self.hooks[ct]["UpdateRoleIcons"](ct)
end

function M:ChatIcon_UpdateSettings()
  wipe(self.iconCache.roles)

  if self:ChatIcon_RoleCheck() then
    -- Get role icon
    local roleTexture = I.ElvUIIcons.Role[E.db.TXUI.elvUIIcons.roleIcons.theme]["default"]

    -- Cache Role Icons
    self.iconCache.roles.Tank = E:TextureString(I.Media.RoleIcons[roleTexture.TANK], ":16:16")
    self.iconCache.roles.Healer = E:TextureString(I.Media.RoleIcons[roleTexture.HEALER], ":16:16")
    self.iconCache.roles.DPS = E:TextureString(I.Media.RoleIcons[roleTexture.DAMAGER], ":16:16")
  end
end

function M:ChatIcon_ForceUpdate()
  -- Init the Module if not done before
  if self.iconCache == nil then
    self:ChatIcon()
    return
  end

  -- Update Icon Cache
  self:ChatIcon_UpdateSettings()

  -- Exit if WT Chat is not enabled
  if not self:ChatIcon_RoleCheck() then return end

  -- Force Update WT Chat Module
  ct:UpdateRoleIcons()
  ct:CheckLFGRoles()
end

function M:ChatIcon()
  -- Init already done
  if self.iconCache ~= nil then return end

  -- Vars
  self.iconCache = {}
  self.iconCache.roles = {}

  -- Update Icon Cache
  self:ChatIcon_UpdateSettings()

  -- Get WindTools
  local wt = E.Libs.AceAddon:GetAddon("ElvUI_WindTools", true)

  if wt then
    -- Get WindTools Chat Text Module
    ct = wt:GetModule("ChatText")

    -- Hook WindTools
    if ct and ct.db then
      self:RawHook(ct, "UpdateRoleIcons", "ChatIcon_UpdateRoleIcons")
      self:ChatIcon_ForceUpdate()

      F.Event.RegisterCallback("RoleIcons.SettingsUpdate", F.Event.GenerateClosure(M.ChatIcon_ForceUpdate, self))
    end
  end

  -- Add callback for ElvUI
  if self:ChatIcon_Check() then E:GetModule("Chat"):AddPluginIcons(function(...)
    return self:ChatIcon_DevIconCallback(...)
  end) end
end

M:AddCallback("ChatIcon")
