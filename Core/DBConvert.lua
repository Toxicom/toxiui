local TXUI, F, E, I, V, P, G = unpack(select(2, ...))

function TXUI:DBConvert()
  local db = E.db.TXUI
  local private = E.private.TXUI

  if not F.IsTXUIProfile() then return end

  local cl = self:GetModule("Changelog")
  if (db.changelog.lastDBConversion ~= nil and db.changelog.lastDBConversion ~= 0) and (not cl:IsNewer(TXUI.ReleaseVersion, db.changelog.lastDBConversion)) then return end

  if TXUI.IsRetail then
    -- Profile Skin section convert
    if db.skins ~= nil then
      -- Dark mode moved into themes section
      if db.skins.darkMode ~= nil then
        db.themes.darkMode.enabled = db.skins.darkMode
        db.skins.darkMode = nil
      end

      -- Dark mode transparency moved into themes section
      if db.skins.darkModeTransparency ~= nil then
        db.themes.darkMode.transparency = db.skins.darkModeTransparency
        db.skins.darkModeTransparency = nil
      end

      -- Gradient mode moved into themes section
      if db.skins.customTextures ~= nil then
        db.themes.gradientMode.enabled = db.skins.customTextures
        db.skins.customTextures = nil
      end

      -- Check if Dark Mode is enabled, if so, force disable gradient mode
      if db.themes.darkMode.enabled == true then db.themes.gradientMode.enabled = false end

      self:LogDebug("DBConvert > Converted 'Skins'-Profile to new format")

      db.skins = nil
    end

    -- Private Skin section convert
    if private and private.skins ~= nil then
      -- WeakAura Bar moved into addons section
      if private.skins.weakAurasBars ~= nil then
        db.addons.weakAurasBars.enabled = private.skins.weakAurasBars
        private.skins.weakAurasBars = nil
      end

      -- WeakAura Icons moved into addons section
      if private.skins.weakAurasIcons ~= nil then
        db.addons.weakAurasIcons.enabled = private.skins.weakAurasIcons
        private.skins.weakAurasIcons = nil
      end

      self:LogDebug("DBConvert > Converted 'Skins'-Profile to new format")

      private.skins = nil
    end

    -- Private Misc section convert
    if private and private.misc then
      -- Fade Persist moved into addons section
      if private.misc.fadePersist ~= nil then
        db.addons.fadePersist.enabled = private.misc.fadePersist
        private.misc.fadePersist = nil
      end

      -- AFK mode moved into themes section
      if private.misc.afkMode ~= nil then
        db.addons.afkMode.enabled = private.misc.afkMode
        private.misc.afkMode = nil
      end

      self:LogDebug("DBConvert > Converted 'Misc'-Private to new format")

      private.misc = nil
    end
  end

  -- Print debug message
  self:LogDebug("DBConvert > DB Upgrade finished")

  -- Set last conversion
  db.changelog.lastDBConversion = TXUI.ReleaseVersion
end
