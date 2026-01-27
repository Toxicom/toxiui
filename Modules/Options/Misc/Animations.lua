local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")

-- Easing type dropdown values
-- Note: Elastic and bounce easings are excluded as they produce values outside 0-1 range
local easingTypeValues = {
  ["linear"] = "Linear",
  ["in"] = "In",
  ["in-quadratic"] = "In Quadratic",
  ["in-cubic"] = "In Cubic",
  ["in-quartic"] = "In Quartic",
  ["in-sinusoidal"] = "In Sinusoidal",
  ["in-exponential"] = "In Exponential",
  ["in-circular"] = "In Circular",
  ["inout"] = "In-Out",
  ["inout-quadratic"] = "In-Out Quadratic",
  ["inout-cubic"] = "In-Out Cubic",
  ["inout-quartic"] = "In-Out Quartic",
  ["inout-sinusoidal"] = "In-Out Sinusoidal",
  ["inout-exponential"] = "In-Out Exponential",
  ["inout-circular"] = "In-Out Circular",
  ["out"] = "Out",
  ["out-quadratic"] = "Out Quadratic",
  ["out-cubic"] = "Out Cubic",
  ["out-quartic"] = "Out Quartic",
  ["out-sinusoidal"] = "Out Sinusoidal",
  ["out-exponential"] = "Out Exponential",
  ["out-circular"] = "Out Circular",
}

-- Frame display names
local frameDisplayNames = {
  characterFrame = "Character Frame",
  dressingRoom = "Dressing Room",
  inspectFrame = "Inspect Frame",
  friendsFrame = "Friends Frame",
  groupFinder = "Group Finder",
  collectionsJournal = "Collections",
  encounterJournal = "Encounter Journal",
  map = "World Map",
  spellbook = "Spellbook",
  professionsBook = "Professions Book",
  professions = "Professions",
  auctionHouse = "Auction House",
  mailbox = "Mailbox",
  merchant = "Merchant",
  gossip = "Gossip",
  quest = "Quest Dialog",
  questLog = "Quest Log",
  achievementFrame = "Achievements",
  weeklyRewards = "Great Vault",
  talents = "Talents",
}

function O:Plugins_Animations()
  local isAnimationsDisabled = function()
    return not E.db.TXUI.animations.enabled
  end

  -- Create Tab
  self.options.misc.args.animations = {
    order = self:GetOrder(),
    type = "group",
    name = "Animations",
    get = function(info)
      return E.db.TXUI.animations[info[#info]]
    end,
    set = function(info, value)
      E.db.TXUI.animations[info[#info]] = value
      F.Event.TriggerEvent("Animations.SettingsUpdate")
    end,
    args = {},
  }

  -- Options
  local options = self.options.misc.args.animations.args
  local optionsDisabled

  -- General
  do
    -- General Group
    local generalGroup = self:AddInlineRequirementsDesc(options, {
      name = "General",
    }, {
      name = "Add smooth animations to Blizzard frames when they open.\n\n",
    }, I.Requirements.Animations).args

    -- Enable
    generalGroup.enabled = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Toggling this on enables " .. TXUI.Title .. " Frame Animations.",
      name = function()
        return self:GetEnableName(E.db.TXUI.animations.enabled, generalGroup)
      end,
      get = function(_)
        return E.db.TXUI.animations.enabled
      end,
      set = function(_, value)
        E.db.TXUI.animations.enabled = value
        F.Event.TriggerEvent("Animations.DatabaseUpdate")
      end,
    }

    optionsDisabled = function()
      return isAnimationsDisabled() or self:GetEnabledState(E.db.TXUI.animations.enabled, generalGroup) ~= self.enabledState.YES
    end
  end

  self:AddSpacer(options)

  -- Global Settings
  do
    local globalGroup = self:AddInlineDesc(options, {
      name = "Global Settings",
      hidden = optionsDisabled,
    }, {
      name = "Settings that apply to all frame animations.\n\n",
    }).args

    -- Animation Speed
    globalGroup.animationsMult = {
      order = self:GetOrder(),
      type = "range",
      name = "Animation Speed",
      desc = "Global animation speed multiplier. Lower values make animations slower.",
      min = 0.25,
      max = 2,
      step = 0.05,
      isPercent = true,
      get = function()
        return 1 / E.db.TXUI.animations.animationsMult
      end,
      set = function(_, value)
        E.db.TXUI.animations.animationsMult = 1 / value
        F.Event.TriggerEvent("Animations.SettingsUpdate")
      end,
    }
  end

  self:AddSpacer(options)

  -- Easing Reference
  do
    self:AddInlineDesc(options, {
      name = "Easing Reference",
      hidden = optionsDisabled,
    }, {
      name = "Easing functions control the acceleration of animations:\n\n"
        .. F.String.ToxiUI("Direction:")
        .. "\n"
        .. "  In - Starts slow, accelerates toward the end\n"
        .. "  Out - Starts fast, decelerates toward the end\n"
        .. "  In-Out - Slow at both ends, fast in the middle\n\n"
        .. F.String.ToxiUI("Types:")
        .. "\n"
        .. "  Linear - Constant speed, no acceleration\n"
        .. "  Quadratic - Gentle curve (power of 2)\n"
        .. "  Cubic - Moderate curve (power of 3)\n"
        .. "  Quartic - Pronounced curve (power of 4)\n"
        .. "  Sinusoidal - Smooth wave-like curve\n"
        .. "  Exponential - Very sharp acceleration\n"
        .. "  Circular - Based on circular arc\n\n"
        .. F.String.Good("Recommended:")
        .. " Out-Cubic provides a natural feel for UI animations.\n\n",
    })
  end

  self:AddSpacer(options)

  -- Frame Settings
  do
    local framesGroup = self:AddInlineDesc(options, {
      name = "Frame Settings",
      hidden = optionsDisabled,
    }, {
      name = "Configure animations for individual frames. Enable or disable animations and choose the animation style for each frame.\n\n",
    }).args

    -- Get the Animations module to check FrameMap
    local AN = TXUI:GetModule("Animations")

    -- Create settings for each frame
    for frameKey, displayName in pairs(frameDisplayNames) do
      -- Skip frames that don't exist for this game version
      if AN.FrameMap[frameKey] then
        local frameGroup = {
          order = self:GetOrder(),
          type = "group",
          name = displayName,
          inline = true,
          hidden = optionsDisabled,
          args = {},
        }

        -- Enable toggle for this frame
        frameGroup.args.enabled = {
          order = 1,
          type = "toggle",
          name = "Enable",
          desc = "Enable animation for " .. displayName,
          get = function()
            return E.db.TXUI.animations.frames[frameKey].enabled
          end,
          set = function(_, value)
            E.db.TXUI.animations.frames[frameKey].enabled = value
            F.Event.TriggerEvent("Animations.DatabaseUpdate")
          end,
        }

        local frameDisabled = function()
          return optionsDisabled() or not E.db.TXUI.animations.frames[frameKey].enabled
        end

        -- Duration slider
        frameGroup.args.duration = {
          order = 2,
          type = "range",
          name = "Duration",
          desc = "Animation duration in seconds",
          min = 0.1,
          max = 1,
          step = 0.05,
          get = function()
            return E.db.TXUI.animations.frames[frameKey].duration
          end,
          set = function(_, value)
            E.db.TXUI.animations.frames[frameKey].duration = value
            F.Event.TriggerEvent("Animations.SettingsUpdate")
          end,
          disabled = frameDisabled,
        }

        -- Easing type dropdown
        frameGroup.args.easing = {
          order = 3,
          type = "select",
          name = "Easing",
          desc = "Choose the easing function for the animation",
          values = easingTypeValues,
          get = function()
            return E.db.TXUI.animations.frames[frameKey].easing
          end,
          set = function(_, value)
            E.db.TXUI.animations.frames[frameKey].easing = value
            F.Event.TriggerEvent("Animations.SettingsUpdate")
          end,
          disabled = frameDisabled,
        }

        framesGroup[frameKey] = frameGroup
      end
    end
  end
end

O:AddCallback("Plugins_Animations")
