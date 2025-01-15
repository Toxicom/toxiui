local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

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

  -- Saturation Boost convert
  if db.themes.gradientMode.saturationBoost == false or db.themes.gradientMode.saturationBoost == true then
    -- Store old value
    local value = db.themes.gradientMode.saturationBoost
    -- Set new value from defaults
    db.themes.gradientMode.saturationBoost = P.themes.gradientMode.saturationBoost
    -- Set old value
    db.themes.gradientMode.saturationBoost.enabled = value
    self:LogDebug("DBConvert > Converted Saturation Boost to new format")
  end

  -- Convert custom text names (For those who updated in 6.9.0 beta)
  do
    local converted = false
    -- Mapping of old names to new names
    local newNames = {
      ["toxiui.power"] = "toxiui:power",
      ["toxiui.name"] = "toxiui:name",
      ["toxiui.level"] = "toxiui:level",
      ["toxiui.health"] = "toxiui:health",
      ["toxiui.health-small"] = "toxiui:health-small",
      ["toxiui.class-icon"] = "toxiui:class-icon",
      ["toxiui.classification"] = "toxiui:classification",
      ["toxiui.pet-happiness"] = "toxiui:pet-happiness",
      ["toxiui.raid-group"] = "toxiui:raid-group",
    }

    for _, unitTable in pairs(E.db.unitframe.units) do
      for key, value in pairs(unitTable.customTexts) do
        -- Check if the key exists in the newNames mapping
        if newNames[key] then
          -- Add the value to the new key in the table
          unitTable.customTexts[newNames[key]] = value
          -- Remove the old key
          unitTable.customTexts[key] = nil

          -- Confirm that we've converted a key
          converted = true
        end
      end
    end

    if converted then self:LogDebug("DBConvert > Converted Custom Texts to new names") end
  end

  -- Convert custom text names
  do
    local converted = false
    -- Mapping of old names to new names
    local newNames = {
      ["!Power"] = "toxiui:power",
      ["!Name"] = "toxiui:name",
      ["!Level"] = "toxiui:level",
      ["!Health"] = "toxiui:health",
      ["!HealthSmall"] = "toxiui:health-small",
      ["!ClassIcon"] = "toxiui:class-icon",
      ["!Classification"] = "toxiui:classification",
      ["!Happiness"] = "toxiui:pet-happiness",
      ["!Group"] = "toxiui:raid-group",
    }

    for _, unitTable in pairs(E.db.unitframe.units) do
      for key, value in pairs(unitTable.customTexts) do
        -- Check if the key exists in the newNames mapping
        if newNames[key] then
          -- Add the value to the new key in the table
          unitTable.customTexts[newNames[key]] = value
          -- Remove the old key
          unitTable.customTexts[key] = nil

          -- Confirm that we've converted a key
          converted = true
        end
      end
    end

    if converted then self:LogDebug("DBConvert > Converted Custom Texts to new names") end
  end

  -- Print debug message
  self:LogDebug("DBConvert > DB Upgrade finished")

  -- Set last conversion
  db.changelog.lastDBConversion = TXUI.ReleaseVersion
end
