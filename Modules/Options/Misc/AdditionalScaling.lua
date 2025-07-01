local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")
local Misc = TXUI:GetModule("Misc")

function O:Plugins_AdditionalScaling()
  -- Create Tab
  self.options.misc.args["additionalScaling"] = {
    order = self:GetOrder(),
    type = "group",
    name = "Additional Scaling",
    args = {},
  }

  -- Options
  local options = self.options.misc.args["additionalScaling"]["args"]
  local optionsHidden

  -- General
  do
    -- General Group
    local generalGroup = self:AddInlineRequirementsDesc(options, {
      name = "Description",
    }, {
      name = "These options allow you to apply additional scaling to UI elements that might otherwise be a little bit too small.\n\n"
        .. F.String.ToxiUI("Information: ")
        .. "After disabling the module you must reload the UI, otherwise the scaling will not reset!\n\n",
    }, I.Requirements.AdditionalScaling).args

    -- Enable
    generalGroup.enabled = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Toggling this on enables the " .. TXUI.Title .. " " .. F.String.Scaling() .. ".\n\n",
      name = function()
        return self:GetEnableName(E.db.TXUI.misc.scaling.enabled, generalGroup)
      end,
      get = function(_)
        return E.db.TXUI.misc.scaling.enabled
      end,
      set = function(_, value)
        E.db.TXUI.misc.scaling.enabled = value
        if value then
          Misc:AdditionalScaling()
        else
          E:StaticPopup_Show("CONFIG_RL")
        end
      end,
    }

    -- Hidden helper
    optionsHidden = function()
      return self:GetEnabledState(E.db.TXUI.misc.scaling.enabled, generalGroup) ~= self.enabledState.YES or not TXUI:HasRequirements(I.Requirements.AdditionalScaling)
    end
  end

  -- Spacer
  self:AddSpacer(options)

  -- Character
  do
    -- Character Group
    local characterGroup = self:AddInlineDesc(options, {
      name = "Character",
      hidden = optionsHidden,
    }, {
      name = "Scale character specific frames.\n\n",
    }).args

    -- Character Group: Character Frame
    characterGroup.characterFrame = {
      order = self:GetOrder(),
      type = "range",
      name = "Character Frame",
      get = function(_)
        return E.db.TXUI.misc.scaling.characterFrame.scale
      end,
      set = function(_, value)
        E.db.TXUI.misc.scaling.characterFrame.scale = value
        Misc:AdditionalScaling()
      end,
      min = 0.5,
      max = 2,
      step = 0.05,
    }

    -- Character Group: Dressing Room
    characterGroup.dressingRoom = {
      order = self:GetOrder(),
      type = "range",
      name = "Dressing Room",
      get = function(_)
        return E.db.TXUI.misc.scaling.dressingRoom.scale
      end,
      set = function(_, value)
        E.db.TXUI.misc.scaling.dressingRoom.scale = value
        Misc:AdditionalScaling()
      end,
      min = 0.5,
      max = 2,
      step = 0.05,
    }

    -- Character Group: Inspect Frame
    characterGroup.inspectFrame = {
      order = self:GetOrder(),
      type = "range",
      name = "Inspect Frame",
      disabled = function()
        return E.db.TXUI.misc.scaling.syncInspect.enabled
      end,
      get = function(_)
        return E.db.TXUI.misc.scaling.inspectFrame.scale
      end,
      set = function(_, value)
        E.db.TXUI.misc.scaling.inspectFrame.scale = value
        Misc:AdditionalScaling()
      end,
      min = 0.5,
      max = 2,
      step = 0.05,
    }

    -- Character Group: Sync Inspect
    characterGroup.syncInspect = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Toggling this on makes your inspect frame scale have the same value as the character frame scale.",
      name = "Sync Inspect",
      get = function(_)
        return E.db.TXUI.misc.scaling.syncInspect.enabled
      end,
      set = function(_, value)
        E.db.TXUI.misc.scaling.syncInspect.enabled = value
        Misc:AdditionalScaling()
      end,
    }
  end

  -- Spacer
  self:AddSpacer(options)

  -- NPC
  do
    -- NPC Group
    local npcGroup = self:AddInlineDesc(options, {
      name = "NPC",
      hidden = optionsHidden,
    }, {
      name = "Scale frames related to interactions with NPCs. Yes, we know a mailbox isn't technically an NPC.\n\n",
    }).args

    -- NPC Group: Vendor
    npcGroup.vendor = {
      order = self:GetOrder(),
      type = "range",
      name = "Vendor",
      get = function(_)
        return E.db.TXUI.misc.scaling.vendor.scale
      end,
      set = function(_, value)
        E.db.TXUI.misc.scaling.vendor.scale = value
        Misc:AdditionalScaling()
      end,
      min = 0.5,
      max = 2,
      step = 0.05,
    }

    -- NPC Group: Class Trainer
    npcGroup.classTrainer = {
      order = self:GetOrder(),
      type = "range",
      name = "Class Trainer",
      get = function(_)
        return E.db.TXUI.misc.scaling.classTrainer.scale
      end,
      set = function(_, value)
        E.db.TXUI.misc.scaling.classTrainer.scale = value
        Misc:AdditionalScaling()
      end,
      min = 0.5,
      max = 2,
      step = 0.05,
    }

    -- NPC Group: Gossip
    npcGroup.gossip = {
      order = self:GetOrder(),
      type = "range",
      name = "Gossip",
      get = function(_)
        return E.db.TXUI.misc.scaling.gossip.scale
      end,
      set = function(_, value)
        E.db.TXUI.misc.scaling.gossip.scale = value
        Misc:AdditionalScaling()
      end,
      min = 0.5,
      max = 2,
      step = 0.05,
    }

    -- NPC Group: Quest
    npcGroup.quest = {
      order = self:GetOrder(),
      type = "range",
      name = "Quest",
      get = function(_)
        return E.db.TXUI.misc.scaling.quest.scale
      end,
      set = function(_, value)
        E.db.TXUI.misc.scaling.quest.scale = value
        Misc:AdditionalScaling()
      end,
      min = 0.5,
      max = 2,
      step = 0.05,
    }

    -- NPC Group: Mailbox
    npcGroup.mailbox = {
      order = self:GetOrder(),
      type = "range",
      name = "Mailbox",
      get = function(_)
        return E.db.TXUI.misc.scaling.mailbox.scale
      end,
      set = function(_, value)
        E.db.TXUI.misc.scaling.mailbox.scale = value
        Misc:AdditionalScaling()
      end,
      min = 0.5,
      max = 2,
      step = 0.05,
    }

    npcGroup.auctionHouse = {
      order = self:GetOrder(),
      type = "range",
      name = "Auction House",
      get = function(_)
        return E.db.TXUI.misc.scaling.auctionHouse.scale
      end,
      set = function(_, value)
        E.db.TXUI.misc.scaling.auctionHouse.scale = value
        Misc:AdditionalScaling()
      end,
      min = 0.5,
      max = 2,
      step = 0.05,
    }
  end

  -- Spacer
  self:AddSpacer(options)

  -- Other
  do
    -- Other Group
    local otherGroup = self:AddInlineDesc(options, {
      name = "Other",
      hidden = optionsHidden,
    }, {
      name = "Scale other frames.\n\n",
    }).args

    -- Other Group: Map
    otherGroup.map = {
      order = self:GetOrder(),
      type = "range",
      name = "Map",
      get = function(_)
        return E.db.TXUI.misc.scaling.map.scale
      end,
      set = function(_, value)
        E.db.TXUI.misc.scaling.map.scale = value
        Misc:AdditionalScaling()
      end,
      min = 0.5,
      max = 2,
      step = 0.05,
    }

    -- Other Group: Spellbook
    otherGroup.spellbook = {
      order = self:GetOrder(),
      type = "range",
      name = "Spellbook",
      get = function(_)
        return E.db.TXUI.misc.scaling.spellbook.scale
      end,
      set = function(_, value)
        E.db.TXUI.misc.scaling.spellbook.scale = value
        Misc:AdditionalScaling()
      end,
      min = 0.5,
      max = 2,
      step = 0.05,
    }

    -- Other Group: Collections
    otherGroup.collections = {
      order = self:GetOrder(),
      type = "range",
      name = "Collections",
      disabled = function()
        return TXUI.IsVanilla
      end,
      get = function(_)
        return E.db.TXUI.misc.scaling.collections.scale
      end,
      set = function(_, value)
        E.db.TXUI.misc.scaling.collections.scale = value
        Misc:AdditionalScaling()
      end,
      min = 0.5,
      max = 2,
      step = 0.05,
    }

    -- Other Group: Profession
    otherGroup.profession = {
      order = self:GetOrder(),
      type = "range",
      name = "Profession",
      get = function(_)
        return E.db.TXUI.misc.scaling.profession.scale
      end,
      set = function(_, value)
        E.db.TXUI.misc.scaling.profession.scale = value
        Misc:AdditionalScaling()
      end,
      min = 0.5,
      max = 2,
      step = 0.05,
    }

    -- Other Group: Friends
    otherGroup.friends = {
      order = self:GetOrder(),
      type = "range",
      name = "Friends",
      get = function(_)
        return E.db.TXUI.misc.scaling.friends.scale
      end,
      set = function(_, value)
        E.db.TXUI.misc.scaling.friends.scale = value
        Misc:AdditionalScaling()
      end,
      min = 0.5,
      max = 2,
      step = 0.05,
    }
  end

  -- Spacer
  self:AddSpacer(options)

  -- Retail
  do
    local retailDisabled = function()
      return not TXUI.IsRetail
    end

    -- Retail Group
    local retailGroup = self:AddInlineDesc(options, {
      name = "Retail Only",
      hidden = optionsHidden,
      disabled = retailDisabled,
    }, {
      name = "Scale Retail only frames.\n\n",
    }).args

    -- Retail Group: Wardrobe
    retailGroup.wardrobe = {
      order = self:GetOrder(),
      type = "range",
      name = "Wardrobe",
      get = function(_)
        return E.db.TXUI.misc.scaling.wardrobe.scale
      end,
      set = function(_, value)
        E.db.TXUI.misc.scaling.wardrobe.scale = value
        Misc:AdditionalScaling()
      end,
      min = 0.5,
      max = 2,
      step = 0.05,
    }

    -- Retail Group: Item Upgrade Frame
    retailGroup.itemUpgrade = {
      order = self:GetOrder(),
      type = "range",
      name = "Item Upgrade",
      desc = "Interfaces where you add an item, eg.: item upgrade frame, catalyst upgrade",
      get = function(_)
        return E.db.TXUI.misc.scaling.itemUpgrade.scale
      end,
      set = function(_, value)
        E.db.TXUI.misc.scaling.itemUpgrade.scale = value
        Misc:AdditionalScaling()
      end,
      min = 0.5,
      max = 2,
      step = 0.05,
    }

    -- Retail Group: Equipment Flyout
    retailGroup.equipmentFlyout = {
      order = self:GetOrder(),
      type = "range",
      name = "Equipment Flyout",
      desc = "Flyout of items for interfaces where you add an item, eg.: item upgrade frame, catalyst upgrade",
      get = function(_)
        return E.db.TXUI.misc.scaling.equipmentFlyout.scale
      end,
      set = function(_, value)
        E.db.TXUI.misc.scaling.equipmentFlyout.scale = value
        Misc:AdditionalScaling()
      end,
      min = 0.5,
      max = 3,
      step = 0.05,
    }

    -- Retail Group: Group Finder
    retailGroup.groupFinder = {
      order = self:GetOrder(),
      type = "range",
      name = "Group Finder",
      get = function(_)
        return E.db.TXUI.misc.scaling.groupFinder.scale
      end,
      set = function(_, value)
        E.db.TXUI.misc.scaling.groupFinder.scale = value
        Misc:AdditionalScaling()
      end,
      min = 0.5,
      max = 3,
      step = 0.05,
    }

    self:AddSpacer(retailGroup)

    retailGroup.transmog = {
      order = self:GetOrder(),
      type = "toggle",
      name = "Transmog Frame",
      desc = "Makes the transmogrification frame bigger.",
      get = function(_)
        return E.db.TXUI.misc.scaling.retailTransmog.enabled
      end,
      set = function(_, value)
        E.db.TXUI.misc.scaling.retailTransmog.enabed = value
        if value then
          Misc:AdditionalScaling()
        else
          E:StaticPopup_Show("CONFIG_RL")
        end
      end,
    }
  end

  -- Spacer
  self:AddSpacer(options)

  -- Classic
  do
    -- Classic Group
    local classicGroup = self:AddInlineDesc(options, {
      name = "Classic Only",
      hidden = optionsHidden,
    }, {
      name = "Scale Vanilla & Mists of Pandaria Classic only frames.\n\n",
    }).args

    -- Classic Group: Talents
    classicGroup.talents = {
      order = self:GetOrder(),
      type = "range",
      name = "Talents",
      disabled = function()
        return TXUI.IsRetail
      end,
      get = function(_)
        return E.db.TXUI.misc.scaling.talents.scale
      end,
      set = function(_, value)
        E.db.TXUI.misc.scaling.talents.scale = value
        Misc:AdditionalScaling()
      end,
      min = 0.5,
      max = 2,
      step = 0.05,
    }

    -- Classic Group: Taxi
    classicGroup.taxi = {
      order = self:GetOrder(),
      type = "range",
      name = "Taxi",
      disabled = function()
        return TXUI.IsRetail
      end,
      get = function(_)
        return E.db.TXUI.misc.scaling.taxi.scale
      end,
      set = function(_, value)
        E.db.TXUI.misc.scaling.taxi.scale = value
        Misc:AdditionalScaling()
      end,
      min = 0.5,
      max = 2,
      step = 0.05,
    }
  end
end

O:AddCallback("Plugins_AdditionalScaling")
