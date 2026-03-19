local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")
local M = TXUI:GetModule("Misc")

function O:Skins_CooldownManager()
  -- Create Tab
  self.options.skins.args["cooldownManagerGroup"] = {
    order = self:GetOrder(),
    type = "group",
    childGroups = "tab",
    name = "Cooldown Manager " .. E.NewSign,
    args = {},
  }

  -- Options
  local options = self.options.skins.args["cooldownManagerGroup"]["args"]

  local function isDisabled()
    return not E.db.TXUI.addons.cooldownManager.enabled
  end

  -- Description
  self:AddInlineDesc(options, {
    name = "Description",
  }, {
    name = TXUI.Title --
      .. " provides additional features for "
      .. F.String.ToxiUI("Blizzard Cooldown Manager")
      .. " which can be configured here.\n"
      .. F.String.Warning("Warning: ")
      .. "This is still experimental and might be removed in the future.\n"
      .. F.String.ToxiUI("Information: ")
      .. "We recommend reloading the UI each time you interact with the Edit Mode to avoid issues!\n",
  })

  -- Related Settings Navigation
  do
    local navGroup = self:AddInlineGroup(options, { name = "Related Settings" }).args

    navGroup.navDesc = {
      order = self:GetOrder(),
      type = "description",
      name = function()
        local lines = F.String.ElvUI("ElvUI")
          .. " Skin"
          .. " - Toggle the Blizzard Cooldown Manager skin on/off.\n"
          .. F.String.ElvUI("ElvUI")
          .. " Settings"
          .. " - Font, color, and display options for the Cooldown Manager text.\n"
          .. F.String.ElvUI("ElvUI")
          .. " Cooldown"
          .. " - Global cooldown text settings including the Cooldown Manager duration display.\n"
        if F.IsAddOnEnabled("ElvUI_WindTools") then
          lines = lines
            .. F.String.WindTools()
            .. " Skin"
            .. " - WindTools styling for the Cooldown Viewer frames.\n"
            .. F.String.WindTools()
            .. " Settings"
            .. " - WindTools layout and appearance settings for the Cooldown Viewer.\n"
        end
        return lines .. "\n"
      end,
    }

    navGroup.elvuiSkin = {
      order = self:GetOrder(),
      type = "execute",
      name = F.String.ElvUI("ElvUI") .. " Skin",
      desc = "Open the " .. F.String.ElvUI("ElvUI") .. " Skins panel to toggle the Cooldown Manager skin.",
      func = function()
        E:ToggleOptions("skins,blizzard")
      end,
    }

    navGroup.elvuiSettings = {
      order = self:GetOrder(),
      type = "execute",
      name = F.String.ElvUI("ElvUI") .. " Settings",
      desc = "Open the " .. F.String.ElvUI("ElvUI") .. " General > Blizzard Improvements > Cooldown Manager settings.",
      func = function()
        E:ToggleOptions("general,blizzardImprovements,cooldownManager")
      end,
    }

    navGroup.elvuiCooldown = {
      order = self:GetOrder(),
      type = "execute",
      name = F.String.ElvUI("ElvUI") .. " Cooldown",
      desc = "Open the " .. F.String.ElvUI("ElvUI") .. " Cooldown & Duration > Cooldown Manager settings.",
      func = function()
        E:ToggleOptions("cooldown,cdmanager")
      end,
    }

    navGroup.windtoolsSkin = {
      order = self:GetOrder(),
      type = "execute",
      name = F.String.WindTools() .. " Skin",
      desc = "Open the " .. F.String.WindTools() .. " Skins > Blizzard panel to configure the Cooldown Viewer skin.",
      hidden = function()
        return not F.IsAddOnEnabled("ElvUI_WindTools")
      end,
      func = function()
        E:ToggleOptions("WindTools,skins,blizzard")
      end,
    }

    navGroup.windtoolsSettings = {
      order = self:GetOrder(),
      type = "execute",
      name = F.String.WindTools() .. " Settings",
      desc = "Open the " .. F.String.WindTools() .. " Skins > Cooldown Viewer settings.",
      hidden = function()
        return not F.IsAddOnEnabled("ElvUI_WindTools")
      end,
      func = function()
        E:ToggleOptions("WindTools,skins,cooldownViewer")
      end,
    }
  end

  -- Tab: General
  do
    local tab = self:AddGroup(options, { name = "General" }).args

    -- Enable
    local generalGroup = self:AddInlineRequirementsDesc(tab, {
      name = "General",
    }, {
      name = "Enable or disable all " .. TXUI.Title .. " features for the Blizzard Cooldown Manager.\n\n",
    }, I.Requirements.CooldownManager).args

    generalGroup.enabled = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Enable " .. TXUI.Title .. " features for the Blizzard Cooldown Manager.",
      name = function()
        return self:GetEnableName(E.db.TXUI.addons.cooldownManager.enabled, generalGroup)
      end,
      get = function(_)
        return E.db.TXUI.addons.cooldownManager.enabled
      end,
      set = function(_, value)
        E.db.TXUI.addons.cooldownManager.enabled = value
        F.Event.TriggerEvent("CooldownManager.DatabaseUpdate")
      end,
    }

    -- Spacer
    self:AddSpacer(tab)

    -- Fading
    local fadingGroup = self:AddInlineRequirementsDesc(tab, {
      name = "Fading",
    }, {
      name = "This option makes your Cooldown Manager viewers fade together with your Player UnitFrame.\n\n",
    }, I.Requirements.CooldownManager).args

    fadingGroup.fading = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Enabling this makes the Cooldown Manager viewers fade with the Player UnitFrame.",
      name = function()
        return self:GetEnableName(E.db.TXUI.addons.cooldownManager.fading, fadingGroup)
      end,
      disabled = isDisabled,
      get = function(_)
        return E.db.TXUI.addons.cooldownManager.fading
      end,
      set = function(_, value)
        E.db.TXUI.addons.cooldownManager.fading = value
        F.Event.TriggerEvent("CooldownManager.DatabaseUpdate")
      end,
    }

    -- Spacer
    self:AddSpacer(tab)

    -- Dynamic Bars Width
    local dynamicGroup = self:AddInlineRequirementsDesc(tab, {
      name = "Dynamic Bars Width",
    }, {
      name = "Options to sync ElvUI and CDM bar widths.\n\n",
    }, I.Requirements.CooldownManager).args

    local function dynamicDisabled()
      return isDisabled() or not E.db.TXUI.addons.cooldownManager.dynamicWidth.enabled
    end

    dynamicGroup.dynamicWidthEnabled = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Enable syncing ElvUI player bar widths with the Cooldown Manager.",
      name = function()
        return self:GetEnableName(E.db.TXUI.addons.cooldownManager.dynamicWidth.enabled, dynamicGroup)
      end,
      disabled = isDisabled,
      get = function(_)
        return E.db.TXUI.addons.cooldownManager.dynamicWidth.enabled
      end,
      set = function(_, value)
        E.db.TXUI.addons.cooldownManager.dynamicWidth.enabled = value
        F.Event.TriggerEvent("CooldownManager.DatabaseUpdate")
      end,
    }

    dynamicGroup.dynamicBarsWidth = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Syncs the detached Power Bar and Class Bar width to match the Essential Cooldown Viewer width.",
      name = "Class/Power Bars",
      disabled = dynamicDisabled,
      get = function(_)
        return E.db.TXUI.addons.cooldownManager.dynamicWidth.powerClassBars
      end,
      set = function(_, value)
        local cmDB = E.db.TXUI.addons.cooldownManager
        local playerDB = E.db.unitframe.units.player
        if value and playerDB then
          cmDB._savedBarsWidth = {
            power = playerDB.power and playerDB.power.detachedWidth,
            classbar = playerDB.classbar and playerDB.classbar.detachedWidth,
          }
        elseif not value and playerDB then
          local saved = cmDB._savedBarsWidth
          if saved then
            if playerDB.power and saved.power then playerDB.power.detachedWidth = saved.power end
            if playerDB.classbar and saved.classbar then playerDB.classbar.detachedWidth = saved.classbar end
          end
          cmDB._savedBarsWidth = nil
          F.Event.ContinueOutOfCombat(function()
            local uf = E:GetModule("UnitFrames")
            if uf and uf.CreateAndUpdateUF then uf:CreateAndUpdateUF("player") end
          end)
        end
        cmDB.dynamicWidth.powerClassBars = value
        F.Event.TriggerEvent("CooldownManager.DatabaseUpdate")
      end,
    }

    dynamicGroup.dynamicCastbarWidth = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Syncs the player Castbar width to match the Essential Cooldown Viewer width.",
      name = "Castbar",
      disabled = dynamicDisabled,
      get = function(_)
        return E.db.TXUI.addons.cooldownManager.dynamicWidth.castBar
      end,
      set = function(_, value)
        local cmDB = E.db.TXUI.addons.cooldownManager
        local playerDB = E.db.unitframe.units.player
        if value and playerDB and playerDB.castbar then
          cmDB._savedCastbarWidth = playerDB.castbar.width
        elseif not value and playerDB and playerDB.castbar then
          if cmDB._savedCastbarWidth then playerDB.castbar.width = cmDB._savedCastbarWidth end
          cmDB._savedCastbarWidth = nil
          F.Event.ContinueOutOfCombat(function()
            local uf = E:GetModule("UnitFrames")
            if uf and uf.CreateAndUpdateUF then uf:CreateAndUpdateUF("player") end
          end)
        end
        cmDB.dynamicWidth.castBar = value
        F.Event.TriggerEvent("CooldownManager.DatabaseUpdate")
      end,
    }

    dynamicGroup.minDynamicWidth = {
      order = self:GetOrder(),
      type = "range",
      name = "Minimum Width",
      desc = "Minimum width for Class/Power Bars and Castbar syncing. Prevents bars from becoming too narrow when few cooldowns are shown.",
      min = 200,
      max = 600,
      step = 1,
      disabled = function()
        local dw = E.db.TXUI.addons.cooldownManager.dynamicWidth
        return dynamicDisabled() or (not dw.powerClassBars and not dw.castBar)
      end,
      get = function(_)
        return E.db.TXUI.addons.cooldownManager.dynamicWidth.minWidth
      end,
      set = function(_, value)
        E.db.TXUI.addons.cooldownManager.dynamicWidth.minWidth = value
        local cm = TXUI:GetModule("CooldownManager")
        if cm then cm:OnDynamicWidthChanged() end
      end,
    }
  end

  -- Tab: Anchoring
  do
    local tab = self:AddGroup(options, { name = "Anchoring" }).args
    local db = E.db.TXUI.addons.cooldownManager.anchors

    local anchorGroup = self:AddInlineRequirementsDesc(tab, {
      name = "Anchoring",
    }, {
      name = "Anchor Cooldown Manager frames to "
        .. F.String.ToxiUI("ElvUI")
        .. " unit frame elements for automatic positioning.\n\n"
        .. F.String.Warning("Note: ")
        .. "Anchoring only works when the viewer is set to "
        .. F.String.ToxiUI("Horizontal")
        .. " orientation in the Blizzard Cooldown Manager settings. Vertical viewers are skipped.\n\n",
    }, I.Requirements.CooldownManager).args

    local function essentialDisabled()
      return (not E.db.unitframe.units.player.power.enable and not E.db.unitframe.units.player.classbar.enable) or isDisabled()
    end

    -- Essential Cooldown Viewer -> Power Bar
    anchorGroup.anchorEssentialEnabled = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Anchor the Essential Cooldown Viewer to the bottom of ElvUI's detached Power Bar. Tries anchoring to the Class Bar if Power Bar is disabled.",
      name = "Essential to Power Bar",
      disabled = essentialDisabled,
      get = function(_)
        return db.essential.enabled
      end,
      set = function(_, value)
        db.essential.enabled = value
        F.Event.TriggerEvent("CooldownManager.DatabaseUpdate")
      end,
    }

    anchorGroup.anchorEssentialYOffset = {
      order = self:GetOrder(),
      type = "range",
      name = "Y Offset",
      desc = "Vertical offset for the Essential Cooldown Viewer anchor.",
      min = -50,
      max = 50,
      step = 1,
      disabled = function()
        return not db.essential.enabled or essentialDisabled()
      end,
      get = function(_)
        return db.essential.yOffset
      end,
      set = function(_, value)
        db.essential.yOffset = value
        F.Event.TriggerEvent("CooldownManager.DatabaseUpdate")
      end,
    }

    -- Spacer
    self:AddSpacer(anchorGroup)

    -- Utility Cooldown Viewer -> Essential Cooldown Viewer
    anchorGroup.anchorUtilityEnabled = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Anchor the Utility Cooldown Viewer to the bottom of the Essential Cooldown Viewer.",
      name = "Utility to Essential",
      disabled = isDisabled,
      get = function(_)
        return db.utility.enabled
      end,
      set = function(_, value)
        db.utility.enabled = value
        F.Event.TriggerEvent("CooldownManager.DatabaseUpdate")
      end,
    }

    anchorGroup.anchorUtilityYOffset = {
      order = self:GetOrder(),
      type = "range",
      name = "Y Offset",
      desc = "Vertical offset for the Utility Cooldown Viewer anchor.",
      min = -50,
      max = 50,
      step = 1,
      disabled = function()
        return not db.utility.enabled or isDisabled()
      end,
      get = function(_)
        return db.utility.yOffset
      end,
      set = function(_, value)
        db.utility.yOffset = value
        F.Event.TriggerEvent("CooldownManager.DatabaseUpdate")
      end,
    }

    -- Spacer
    self:AddSpacer(anchorGroup)

    -- Buff Viewer -> Class Bar (fallback: Power Bar)
    anchorGroup.anchorBuffEnabled = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Anchor the Buff Viewer to the top of ElvUI's Class Bar. Falls back to the Power Bar if the Class Bar is not available.",
      name = "Buff to Class Bar",
      disabled = essentialDisabled,
      get = function(_)
        return db.buff.enabled
      end,
      set = function(_, value)
        db.buff.enabled = value
        F.Event.TriggerEvent("CooldownManager.DatabaseUpdate")
      end,
    }

    anchorGroup.anchorBuffYOffset = {
      order = self:GetOrder(),
      type = "range",
      name = "Y Offset",
      desc = "Vertical offset for the Buff Viewer anchor.",
      min = -50,
      max = 50,
      step = 1,
      disabled = function()
        return not db.buff.enabled or essentialDisabled()
      end,
      get = function(_)
        return db.buff.yOffset
      end,
      set = function(_, value)
        db.buff.yOffset = value
        F.Event.TriggerEvent("CooldownManager.DatabaseUpdate")
      end,
    }

    -- Spacer
    self:AddSpacer(anchorGroup)

    -- Buff Bar Viewer -> Health Bar
    anchorGroup.anchorBuffBarEnabled = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Anchor the Buff Bar Viewer to the top of ElvUI's Health Bar.",
      name = "Buff Bar to Health Bar",
      disabled = isDisabled,
      get = function(_)
        return db.buffBar.enabled
      end,
      set = function(_, value)
        db.buffBar.enabled = value
        F.Event.TriggerEvent("CooldownManager.DatabaseUpdate")
      end,
    }

    anchorGroup.anchorBuffBarYOffset = {
      order = self:GetOrder(),
      type = "range",
      name = "Y Offset",
      desc = "Vertical offset for the Buff Bar Viewer anchor.",
      min = 0,
      max = 200,
      step = 1,
      disabled = function()
        return not db.buffBar.enabled or isDisabled()
      end,
      get = function(_)
        return db.buffBar.yOffset
      end,
      set = function(_, value)
        db.buffBar.yOffset = value
        F.Event.TriggerEvent("CooldownManager.DatabaseUpdate")
      end,
    }
  end

  -- Tab: Centering
  do
    local tab = self:AddGroup(options, { name = "Centering" }).args

    local centerGroup = self:AddInlineRequirementsDesc(tab, {
      name = "Centering",
    }, {
      name = "Center Cooldown Manager icons within each viewer frame instead of the default left-aligned layout.\n\n"
        .. F.String.Warning("Note: ")
        .. "Centering only works when the viewer is set to "
        .. F.String.ToxiUI("Horizontal")
        .. " orientation in the Blizzard Cooldown Manager settings. Vertical viewers are skipped.\n\n",
    }, I.Requirements.CooldownManager).args

    centerGroup.centerEssential = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Center icons in the Essential Cooldown Viewer.",
      name = "Essential",
      disabled = isDisabled,
      get = function(_)
        return E.db.TXUI.addons.cooldownManager.centering.essential
      end,
      set = function(_, value)
        E.db.TXUI.addons.cooldownManager.centering.essential = value
        F.Event.TriggerEvent("CooldownManager.DatabaseUpdate")
      end,
    }

    centerGroup.centerUtility = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Center icons in the Utility Cooldown Viewer.",
      name = "Utility",
      disabled = isDisabled,
      get = function(_)
        return E.db.TXUI.addons.cooldownManager.centering.utility
      end,
      set = function(_, value)
        E.db.TXUI.addons.cooldownManager.centering.utility = value
        F.Event.TriggerEvent("CooldownManager.DatabaseUpdate")
      end,
    }

    centerGroup.centerBuff = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Center icons in the Buff Icon Cooldown Viewer.",
      name = "Buff Icons",
      disabled = isDisabled,
      get = function(_)
        return E.db.TXUI.addons.cooldownManager.centering.buff
      end,
      set = function(_, value)
        E.db.TXUI.addons.cooldownManager.centering.buff = value
        F.Event.TriggerEvent("CooldownManager.DatabaseUpdate")
      end,
    }

    centerGroup.centerBuffBar = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Align bars in the Buff Bar Cooldown Viewer to the bottom of the viewer frame instead of static layout.",
      name = "Buff Bars",
      disabled = isDisabled,
      get = function(_)
        return E.db.TXUI.addons.cooldownManager.centering.buffBar
      end,
      set = function(_, value)
        E.db.TXUI.addons.cooldownManager.centering.buffBar = value
        F.Event.TriggerEvent("CooldownManager.DatabaseUpdate")
      end,
    }
  end

  -- Tab: Keybinds
  do
    local tab = self:AddGroup(options, { name = "Keybinds" }).args

    local function keybindsDisabled()
      return isDisabled() or not E.private.actionbar.enable
    end

    local _ = self:AddInlineRequirementsDesc(tab, {
      name = "Keybinds",
    }, {
      name = "Show keybind text on Cooldown Manager icons by reading bindings from "
        .. F.String.ToxiUI("ElvUI Action Bars")
        .. ".\n\n"
        .. (not E.private.actionbar.enable and F.String.Error("Requires ElvUI ActionBars to be enabled.\n\n") or ""),
    }, I.Requirements.CooldownManager)

    local function addViewerKeybindOptions(parentTab, viewerLabel, settingKey)
      local db = E.db.TXUI.addons.cooldownManager.keybinds[settingKey]
      local group = self:AddInlineGroup(parentTab, { name = viewerLabel }).args

      group["kb" .. settingKey .. "Enabled"] = {
        order = self:GetOrder(),
        type = "toggle",
        desc = "Show keybind text on " .. viewerLabel .. " icons.",
        name = function()
          return self:GetEnableName(db.enabled, group)
        end,
        get = function(_)
          return db.enabled
        end,
        set = function(_, value)
          db.enabled = value
          F.Event.TriggerEvent("CooldownManager.DatabaseUpdate")
        end,
        disabled = keybindsDisabled,
      }

      group["kb" .. settingKey .. "Font"] = {
        order = self:GetOrder(),
        type = "select",
        dialogControl = "LSM30_Font",
        name = "Font",
        desc = "Set the font.",
        values = self:GetAllFontsFunc(),
        disabled = function()
          return not db.enabled or keybindsDisabled()
        end,
        get = function(_)
          return db.labelFont
        end,
        set = function(_, value)
          db.labelFont = value
          F.Event.TriggerEvent("CooldownManager.DatabaseUpdate")
        end,
      }

      group["kb" .. settingKey .. "FontOutline"] = {
        order = self:GetOrder(),
        type = "select",
        name = "Font Outline",
        desc = "Set the font outline.",
        values = self:GetAllFontOutlinesFunc(),
        disabled = function()
          return not db.enabled or db.labelFontShadow == true or keybindsDisabled()
        end,
        get = function(_)
          return db.labelFontOutline
        end,
        set = function(_, value)
          db.labelFontOutline = value
          F.Event.TriggerEvent("CooldownManager.DatabaseUpdate")
        end,
      }

      group["kb" .. settingKey .. "FontSize"] = {
        order = self:GetOrder(),
        type = "range",
        name = "Font Size",
        desc = "Set the font size.",
        min = 1,
        max = 100,
        step = 1,
        disabled = function()
          return not db.enabled or keybindsDisabled()
        end,
        get = function(_)
          return db.labelFontSize
        end,
        set = function(_, value)
          db.labelFontSize = value
          F.Event.TriggerEvent("CooldownManager.DatabaseUpdate")
        end,
      }

      group["kb" .. settingKey .. "FontShadow"] = {
        order = self:GetOrder(),
        type = "toggle",
        name = "Font Shadow",
        desc = "Set font drop shadow.",
        disabled = function()
          return not db.enabled or keybindsDisabled()
        end,
        get = function(_)
          return db.labelFontShadow
        end,
        set = function(_, value)
          db.labelFontShadow = value
          F.Event.TriggerEvent("CooldownManager.DatabaseUpdate")
        end,
      }

      group["kb" .. settingKey .. "Anchor"] = {
        order = self:GetOrder(),
        type = "select",
        name = "Anchor",
        desc = "Position of the keybind text on the icon.",
        values = function()
          return unpack(E.Config).Values.TextPositions
        end,
        disabled = function()
          return not db.enabled or keybindsDisabled()
        end,
        get = function(_)
          return db.anchor
        end,
        set = function(_, value)
          db.anchor = value
          F.Event.TriggerEvent("CooldownManager.DatabaseUpdate")
        end,
      }

      group["kb" .. settingKey .. "XOffset"] = {
        order = self:GetOrder(),
        type = "range",
        name = "X Offset",
        desc = "Horizontal offset for the keybind text.",
        min = -64,
        max = 64,
        step = 1,
        disabled = function()
          return not db.enabled or keybindsDisabled()
        end,
        get = function(_)
          return db.xOffset
        end,
        set = function(_, value)
          db.xOffset = value
          F.Event.TriggerEvent("CooldownManager.DatabaseUpdate")
        end,
      }

      group["kb" .. settingKey .. "YOffset"] = {
        order = self:GetOrder(),
        type = "range",
        name = "Y Offset",
        desc = "Vertical offset for the keybind text.",
        min = -64,
        max = 64,
        step = 1,
        disabled = function()
          return not db.enabled or keybindsDisabled()
        end,
        get = function(_)
          return db.yOffset
        end,
        set = function(_, value)
          db.yOffset = value
          F.Event.TriggerEvent("CooldownManager.DatabaseUpdate")
        end,
      }
    end

    addViewerKeybindOptions(tab, "Essential", "essential")
    addViewerKeybindOptions(tab, "Utility", "utility")
  end

  -- Tab: Overrides
  do
    local tab = self:AddGroup(options, { name = "Overrides" }).args

    -- Build spec values table dynamically so icons update when the icon theme changes
    -- When showAll is false, only includes specs for the player's current class
    local function buildSpecValues(showAll)
      local values = {}
      local theme = E.db.TXUI.elvUIIcons.classIcons.theme or "ToxiClasses"
      local iconPath = M:GetClassIconPath(M:GetEffectiveClassIconTheme(theme)):gsub(":32:32:", ":16:16:")
      for _, token in ipairs(I.ClassOrder) do
        if showAll or token == E.myclass then
          local icon = string.format(iconPath, M.ClassIcons[token])
          local specs = I.ClassSpecOrder[token]
          if specs then
            for _, specID in ipairs(specs) do
              values[specID] = icon .. " " .. F.String.Class(I.SpecNames[specID] or tostring(specID), token)
            end
          end
        end
      end
      return values
    end

    -- Class Bar Override
    local classBarGroup = self:AddInlineRequirementsDesc(tab, {
      name = "Class Bar Override",
    }, {
      name = "Automatically disable the "
        .. F.String.ToxiUI("ElvUI Class Bar")
        .. " for selected specializations. The class bar is restored when switching to a spec not in the list.\n\n"
        .. F.String.Warning("Note: ")
        .. "Changes take effect on spec switch or UI reload.\n\n",
    }, I.Requirements.CooldownManager).args

    local classBarDB = E.db.TXUI.addons.cooldownManager.classBarOverride

    classBarGroup.classBarOverrideEnabled = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Enable automatic class bar disabling for selected specializations.",
      name = function()
        return self:GetEnableName(classBarDB.enabled, classBarGroup)
      end,
      disabled = isDisabled,
      get = function(_)
        return classBarDB.enabled
      end,
      set = function(_, value)
        classBarDB.enabled = value
        F.Event.TriggerEvent("CooldownManager.DatabaseUpdate")
      end,
    }

    classBarGroup.classBarShowAllSpecs = {
      order = self:GetOrder(),
      type = "toggle",
      name = "Show All Specs",
      desc = "Show specs from all classes instead of only your current class.",
      disabled = function()
        return isDisabled() or not classBarDB.enabled
      end,
      get = function(_)
        return classBarDB.showAllSpecs
      end,
      set = function(_, value)
        classBarDB.showAllSpecs = value
      end,
    }

    classBarGroup.classBarOverrideSpecs = {
      order = self:GetOrder(),
      type = "multiselect",
      name = "Disable Class Bar for Specs",
      desc = "Select to disable the Class Bar for this specialization.",
      width = 1.5,
      values = function()
        return buildSpecValues(classBarDB.showAllSpecs)
      end,
      disabled = function()
        return isDisabled() or not classBarDB.enabled
      end,
      get = function(_, specID)
        return classBarDB.specs[specID] == true
      end,
      set = function(_, specID, value)
        classBarDB.specs[specID] = value or nil
        F.Event.TriggerEvent("CooldownManager.DatabaseUpdate")
      end,
    }

    -- Spacer
    self:AddSpacer(tab)

    -- Power Bar Override
    local powerBarGroup = self:AddInlineRequirementsDesc(tab, {
      name = "Power Bar Override",
    }, {
      name = "Automatically disable the "
        .. F.String.ToxiUI("ElvUI Power Bar")
        .. " for selected specializations. The power bar is restored when switching to a spec not in the list.\n\n"
        .. F.String.Warning("Note: ")
        .. "Changes take effect on spec switch or UI reload.\n\n",
    }, I.Requirements.CooldownManager).args

    local powerBarDB = E.db.TXUI.addons.cooldownManager.powerBarOverride

    powerBarGroup.powerBarOverrideEnabled = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Enable automatic power bar disabling for selected specializations.",
      name = function()
        return self:GetEnableName(powerBarDB.enabled, powerBarGroup)
      end,
      disabled = isDisabled,
      get = function(_)
        return powerBarDB.enabled
      end,
      set = function(_, value)
        powerBarDB.enabled = value
        F.Event.TriggerEvent("CooldownManager.DatabaseUpdate")
      end,
    }

    powerBarGroup.powerBarShowAllSpecs = {
      order = self:GetOrder(),
      type = "toggle",
      name = "Show All Specs",
      desc = "Show specs from all classes instead of only your current class.",
      disabled = function()
        return isDisabled() or not powerBarDB.enabled
      end,
      get = function(_)
        return powerBarDB.showAllSpecs
      end,
      set = function(_, value)
        powerBarDB.showAllSpecs = value
      end,
    }

    powerBarGroup.powerBarOverrideSpecs = {
      order = self:GetOrder(),
      type = "multiselect",
      name = "Disable Power Bar for Specs",
      desc = "Select to disable the Power Bar for this specialization.",
      width = 1.5,
      values = function()
        return buildSpecValues(powerBarDB.showAllSpecs)
      end,
      disabled = function()
        return isDisabled() or not powerBarDB.enabled
      end,
      get = function(_, specID)
        return powerBarDB.specs[specID] == true
      end,
      set = function(_, specID, value)
        powerBarDB.specs[specID] = value or nil
        F.Event.TriggerEvent("CooldownManager.DatabaseUpdate")
      end,
    }
  end
end

if TXUI.IsRetail then O:AddCallback("Skins_CooldownManager") end
