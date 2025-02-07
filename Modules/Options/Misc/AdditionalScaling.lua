local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")
local Misc = TXUI:GetModule("Misc")

function O:Plugins_AdditionalScaling()
  -- Create Tab
  self.options.misc.args["additionalScaling"] = {
    order = self:GetOrder(),
    type = "group",
    name = "额外缩放",
    args = {},
  }

  -- Options
  local options = self.options.misc.args["additionalScaling"]["args"]
  local optionsHidden

  -- General
  do
    -- General Group
    local generalGroup = self:AddInlineRequirementsDesc(options, {
      name = "描述",
    }, {
      name = "这些选项允许您对可能有点太小的UI元素应用额外的缩放。\n\n"
        .. F.String.ToxiUI("信息: ")
        .. "禁用模块后，您必须重新加载UI，否则缩放将不会重置！\n\n",
    }, I.Requirements.AdditionalScaling).args

    -- Enable
    generalGroup.enabled = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "启用此选项将启用" .. TXUI.Title .. " " .. F.String.Scaling() .. "。\n\n",
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
      name = "角色",
      hidden = optionsHidden,
    }, {
      name = "缩放角色特定的框架。\n\n",
    }).args

    -- Character Group: Character Frame
    characterGroup.characterFrame = {
      order = self:GetOrder(),
      type = "range",
      name = "角色框架",
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
      name = "试衣间",
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
      name = "检查框架",
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
      desc = "启用此选项会使您的检查框架缩放与角色框架缩放具有相同的值。",
      name = "同步检查",
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
      name = "缩放与NPC交互相关的框架。是的，我们知道邮箱技术上不是NPC。\n\n",
    }).args

    -- NPC Group: Vendor
    npcGroup.vendor = {
      order = self:GetOrder(),
      type = "range",
      name = "商人",
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
      name = "职业训练师",
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
      name = "闲聊",
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
      name = "任务",
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
      name = "邮箱",
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
      name = "拍卖行",
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
      name = "其他",
      hidden = optionsHidden,
    }, {
      name = "缩放其他框架。\n\n",
    }).args

    -- Other Group: Map
    otherGroup.map = {
      order = self:GetOrder(),
      type = "range",
      name = "地图",
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
      name = "法术书",
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
      name = "收藏",
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
      name = "专业",
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
      name = "好友",
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
      name = "仅限正式服",
      hidden = optionsHidden,
      disabled = retailDisabled,
    }, {
      name = "缩放仅限正式服的框架。\n\n",
    }).args

    -- Retail Group: Wardrobe
    retailGroup.wardrobe = {
      order = self:GetOrder(),
      type = "range",
      name = "衣柜",
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
      name = "物品升级",
      desc = "添加物品的界面，例如：物品升级框架，催化剂升级",
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
      name = "装备弹出",
      desc = "添加物品的界面的物品弹出，例如：物品升级框架，催化剂升级",
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
      name = "组队查找器",
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
      name = "幻化框架",
      desc = "使幻化框架变大。",
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
      name = "仅限经典服",
      hidden = optionsHidden,
    }, {
      name = "缩放仅限经典服的框架。\n\n",
    }).args

    -- Classic Group: Talents
    classicGroup.talents = {
      order = self:GetOrder(),
      type = "range",
      name = "天赋",
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
      name = "飞行点",
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
