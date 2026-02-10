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
      get = function(_)
        return E.db.TXUI.addons.cooldownManager.fading
      end,
      set = function(_, value)
        E.db.TXUI.addons.cooldownManager.fading = value
        E:StaticPopup_Show("CONFIG_RL")
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
      name = "This option syncs the width of the Player Power Bar and Class Bar "
        .. F.String.ToxiUI("(detached)")
        .. " with the Essential Cooldown Viewer width.\n\n",
    }, I.Requirements.CooldownManager).args

    dynamicGroup.dynamicBarsWidth = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Enabling this syncs the detached power/class bar width with the Cooldown Manager.",
      name = function()
        return self:GetEnableName(E.db.TXUI.addons.cooldownManager.dynamicBarsWidth, dynamicGroup)
      end,
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
        end
        cmDB.dynamicBarsWidth = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
    }

    dynamicGroup.dynamicCastbarWidth = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Enabling this syncs the player castbar width with the Cooldown Manager.",
      name = "Castbar",
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
        end
        cmDB.dynamicCastbarWidth = value
        E:StaticPopup_Show("CONFIG_RL")
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
        .. " unit frame elements for automatic positioning.\n\n",
    }, I.Requirements.CooldownManager).args

    -- Essential Cooldown Viewer -> Power Bar
    anchorGroup.anchorEssentialEnabled = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Anchor the Essential Cooldown Viewer to the bottom of ElvUI's detached Power Bar.",
      name = "Essential to Power Bar",
      get = function(_)
        return db.essential.enabled
      end,
      set = function(_, value)
        db.essential.enabled = value
        E:StaticPopup_Show("CONFIG_RL")
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
        return not db.essential.enabled
      end,
      get = function(_)
        return db.essential.yOffset
      end,
      set = function(_, value)
        db.essential.yOffset = value
        E:StaticPopup_Show("CONFIG_RL")
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
      get = function(_)
        return db.utility.enabled
      end,
      set = function(_, value)
        db.utility.enabled = value
        E:StaticPopup_Show("CONFIG_RL")
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
        return not db.utility.enabled
      end,
      get = function(_)
        return db.utility.yOffset
      end,
      set = function(_, value)
        db.utility.yOffset = value
        E:StaticPopup_Show("CONFIG_RL")
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
      get = function(_)
        return db.buff.enabled
      end,
      set = function(_, value)
        db.buff.enabled = value
        E:StaticPopup_Show("CONFIG_RL")
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
        return not db.buff.enabled
      end,
      get = function(_)
        return db.buff.yOffset
      end,
      set = function(_, value)
        db.buff.yOffset = value
        E:StaticPopup_Show("CONFIG_RL")
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
      get = function(_)
        return db.buffBar.enabled
      end,
      set = function(_, value)
        db.buffBar.enabled = value
        E:StaticPopup_Show("CONFIG_RL")
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
        return not db.buffBar.enabled
      end,
      get = function(_)
        return db.buffBar.yOffset
      end,
      set = function(_, value)
        db.buffBar.yOffset = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
    }
  end
end

if TXUI.IsRetail then O:AddCallback("Skins_CooldownManager") end
