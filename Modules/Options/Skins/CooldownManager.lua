local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")

function O:Skins_CooldownManager()
  -- Create Tab
  self.options.skins.args["cooldownManagerGroup"] = {
    order = self:GetOrder(),
    type = "group",
    name = "Cooldown Manager " .. E.NewSign,
    args = {},
  }

  -- Options
  local options = self.options.skins.args["cooldownManagerGroup"]["args"]

  local function isDisabled()
    return not E.db.TXUI.addons.cooldownManager.enabled
  end

  self:AddInlineDesc(options, {
    name = "Description",
  }, {
    name = TXUI.Title --
      .. " provides additional features for "
      .. F.String.ToxiUI("Blizzard Cooldown Manager")
      .. " which can be configured here.\n\n"
      .. F.String.Warning("Warning: ")
      .. "This is still experimental and might be removed in the future.\n\n"
      .. F.String.ToxiUI("Information: ")
      .. "We recommend reloading the UI each time you interact with the Edit Mode to avoid issues!\n\n",
  })

  -- Spacer
  self:AddSpacer(options)

  -- General
  do
    local generalGroup = self:AddInlineRequirementsDesc(options, {
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
  end

  -- Spacer
  self:AddSpacer(options)

  -- Fading
  do
    local fadingGroup = self:AddInlineRequirementsDesc(options, {
      name = "Fading",
    }, {
      name = "This option makes your Cooldown Manager bars "
        .. F.String.ToxiUI("(EssentialCooldownViewer, UtilityCooldownViewer, BuffIconCooldownViewer)")
        .. " fade together with your Player UnitFrame.\n\n"
        .. F.String.ToxiUI("Information: ")
        .. "It is recommended to reload your UI after editing cooldown settings for the best experience.\n\n",
    }, I.Requirements.CooldownManager).args

    fadingGroup.fading = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Enabling this makes the Cooldown Manager bars fade with the Player UnitFrame.",
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
  end

  -- Spacer
  self:AddSpacer(options)

  -- Dynamic Bars Width
  do
    local dynamicGroup = self:AddInlineRequirementsDesc(options, {
      name = "Dynamic Bars Width",
    }, {
      name = "This option syncs the width of the Player Power Bar and Class Bar " .. F.String.ToxiUI("(detached)") .. " with the Essential Cooldown Viewer width.\n\n",
    }, I.Requirements.CooldownManager).args

    dynamicGroup.dynamicBarsWidth = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Enabling this syncs the detached power/class bar width with the Cooldown Manager.",
      name = function()
        return self:GetEnableName(E.db.TXUI.addons.cooldownManager.dynamicBarsWidth, dynamicGroup)
      end,
      disabled = isDisabled,
      get = function(_)
        return E.db.TXUI.addons.cooldownManager.dynamicBarsWidth
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
        cmDB.dynamicBarsWidth = value
        F.Event.TriggerEvent("CooldownManager.DatabaseUpdate")
      end,
    }

    dynamicGroup.dynamicCastbarWidth = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Enabling this syncs the player castbar width with the Cooldown Manager.",
      name = "Castbar",
      disabled = isDisabled,
      get = function(_)
        return E.db.TXUI.addons.cooldownManager.dynamicCastbarWidth
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
        cmDB.dynamicCastbarWidth = value
        F.Event.TriggerEvent("CooldownManager.DatabaseUpdate")
      end,
    }
  end

  -- Spacer
  self:AddSpacer(options)

  -- Anchoring
  do
    local db = E.db.TXUI.addons.cooldownManager.anchors

    local anchorGroup = self:AddInlineRequirementsDesc(options, {
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
      return isDisabled() or not E.db.unitframe.units.player.power.enable or not E.db.unitframe.units.player.classbar.enable
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
        return isDisabled() or not db.utility.enabled
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
      disabled = isDisabled,
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
        return isDisabled() or not db.buff.enabled
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
        return isDisabled() or not db.buffBar.enabled
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

  -- Spacer
  self:AddSpacer(options)

  -- Centering
  do
    local centerGroup = self:AddInlineRequirementsDesc(options, {
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
  end

  -- Spacer
  self:AddSpacer(options)

  -- Keybinds
  do
    local function keybindsDisabled()
      return isDisabled() or not E.private.actionbar.enable
    end

    local kbGroup = self:AddInlineRequirementsDesc(options, {
      name = "Keybinds",
    }, {
      name = "Show keybind text on Cooldown Manager icons by reading bindings from "
        .. F.String.ToxiUI("ElvUI Action Bars")
        .. ".\n\n"
        .. (not E.private.actionbar.enable and F.String.Error("Requires ElvUI ActionBars to be enabled.\n\n") or ""),
    }, I.Requirements.CooldownManager).args

    local function addViewerKeybindOptions(group, viewerLabel, settingKey)
      local db = E.db.TXUI.addons.cooldownManager.keybinds[settingKey]

      group["kb" .. settingKey .. "Enabled"] = {
        order = self:GetOrder(),
        type = "toggle",
        desc = "Show keybind text on " .. viewerLabel .. " icons.",
        name = viewerLabel,
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
        min = -20,
        max = 20,
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
        min = -20,
        max = 20,
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

      self:AddSpacer(group)
    end

    addViewerKeybindOptions(kbGroup, "Essential", "essential")
    addViewerKeybindOptions(kbGroup, "Utility", "utility")
  end
end

if TXUI.IsRetail then O:AddCallback("Skins_CooldownManager") end
