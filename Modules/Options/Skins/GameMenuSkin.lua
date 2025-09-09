local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")

function O:Skins_ElvUI()
  -- Create Tab
  self.options.skins.args["gameMenuSkinGroup"] = {
    order = self:GetOrder(),
    type = "group",
    name = "Game Menu Skin",
    args = {},
  }

  -- Options
  local options = self.options.skins.args["gameMenuSkinGroup"]["args"]

  -- Main Group
  do
    local mainGroup = self:AddInlineRequirementsDesc(options, {
      name = "Description",
    }, {
      name = TXUI.Title .. " provides a skin for the Game Menu (ESC) that applies a background and additional information, all of which can be configured here.\n\n",
    }, I.Requirements.GameMenuButton).args

    -- ToxiUI Game Menu Button Enable
    mainGroup.gameMenuSkin = {
      order = self:GetOrder(),
      type = "toggle",
      desc = "Enabling this option enables the " .. TXUI.Title .. " Game Menu (ESC) skin.",
      name = function()
        return self:GetEnableName(E.db.TXUI.addons.gameMenuSkin.enabled, mainGroup)
      end,
      get = function(_)
        return E.db.TXUI.addons.gameMenuSkin.enabled
      end,
      set = function(_, value)
        E.db.TXUI.addons.gameMenuSkin.enabled = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
    }
  end

  self:AddSpacer(options)

  -- Background
  do
    local backgroundGroup = self:AddInlineRequirementsDesc(options, {
      name = "Background",
    }, {
      name = "Customize the color of the Game Menu Skin's background.\n\nThe " .. F.String.ToxiUI("Class Color") .. " option will override the " .. F.String.ToxiUI(
        "Background Color"
      ) .. " option, but you can still use it to control the alpha of the background.\n\n",
    }, I.Requirements.GameMenuButton).args

    local optionsDisabled = function()
      return not E.db.TXUI.addons.gameMenuSkin.enabled
    end

    backgroundGroup.bgColor = {
      order = self:GetOrder(),
      type = "color",
      name = "Background Color",
      hasAlpha = true,
      width = 1.1,
      get = self:GetFontColorGetter("TXUI.addons.gameMenuSkin", P.addons.gameMenuSkin),
      set = self:GetFontColorSetter("TXUI.addons.gameMenuSkin"),
      disabled = optionsDisabled,
    }

    backgroundGroup.classColor = {
      order = self:GetOrder(),
      type = "toggle",
      name = "Class Color",
      desc = "Toggling this on will enable your current class' color for the background.",
      get = function(_)
        return E.db.TXUI.addons.gameMenuSkin.classColor.enabled
      end,
      set = function(_, value)
        E.db.TXUI.addons.gameMenuSkin.classColor.enabled = value
      end,
      disabled = optionsDisabled,
    }
  end

  self:AddSpacer(options)

  -- Information Sections
  do
    local infoGroup = self:AddInlineRequirementsDesc(options, {
      name = "Information Sections",
    }, {
      name = "Display various useful information about your character.\n\n",
    }, I.Requirements.GameMenuButton).args

    local optionsDisabled = function()
      return not E.db.TXUI.addons.gameMenuSkin.enabled
    end

    infoGroup.showInfo = {
      order = self:GetOrder(),
      type = "toggle",
      name = "Show Player Info",
      desc = "Toggling this on displays player information in the game menu background.",
      get = function(_)
        return E.db.TXUI.addons.gameMenuSkin.showInfo
      end,
      set = function(_, value)
        E.db.TXUI.addons.gameMenuSkin.showInfo = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
      disabled = optionsDisabled,
    }

    infoGroup.showTips = {
      order = self:GetOrder(),

      type = "toggle",
      name = "Show Random Tips",
      desc = "Toggling this on displays random tips in the game menu background.",
      get = function(_)
        return E.db.TXUI.addons.gameMenuSkin.showTips
      end,
      set = function(_, value)
        E.db.TXUI.addons.gameMenuSkin.showTips = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
      disabled = optionsDisabled,
    }

    infoGroup.showCollections = {
      order = self:GetOrder(),
      type = "toggle",
      name = "Show Collections",
      desc = "Toggling this on displays your collection information in the game menu background.",
      get = function()
        return E.db.TXUI.addons.gameMenuSkin.showCollections
      end,
      set = function(_, value)
        E.db.TXUI.addons.gameMenuSkin.showCollections = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
      disabled = optionsDisabled,
      hidden = not TXUI.IsRetail,
    }
  end

  self:AddSpacer(options)

  -- Specialization Icons
  do
    local iconGroup = self:AddInlineRequirementsDesc(options, {
      name = "Specialization Icon",
    }, {
      name = "Customize the specialization icon that appears in the Player Info section.\n\n",
    }, I.Requirements.GameMenuButton).args

    local optionsDisabled = function()
      return not E.db.TXUI.addons.gameMenuSkin.enabled or not E.db.TXUI.addons.gameMenuSkin.showInfo
    end

    iconGroup.specIconStyle = {
      order = self:GetOrder(),
      type = "select",
      name = "Spec Icon Style",
      desc = "Choose between showing a class colored icon of your specialization, or a stylized specialization icon.",
      width = 1.5,
      values = {
        ToxiSpecColored = TXUI.Title .. F.String.Class(" Class Colored "),
        ToxiSpecColoredStroke = TXUI.Title .. F.String.Class(" Class Colored ") .. F.String.ToxiUI("[STROKE]"),
        ToxiSpecStylized = TXUI.Title .. " Stylized",
        ToxiSpecWhite = TXUI.Title .. " White",
        ToxiSpecWhiteStroke = TXUI.Title .. " White " .. F.String.ToxiUI("[STROKE]"),
      },
      get = function()
        return E.db.TXUI.addons.gameMenuSkin.specIconStyle
      end,
      set = function(_, value)
        E.db.TXUI.addons.gameMenuSkin.specIconStyle = value
      end,
      disabled = optionsDisabled,
    }

    iconGroup.specIconSize = {
      order = self:GetOrder(),
      type = "range",
      name = "Spec Icon Size",
      desc = "Change the size of the specialization icon.",
      min = 8,
      max = 64,
      step = 1,
      get = function()
        return E.db.TXUI.addons.gameMenuSkin.specIconSize
      end,
      set = function(_, value)
        E.db.TXUI.addons.gameMenuSkin.specIconSize = value
      end,
      disabled = optionsDisabled,
    }
  end

  self:AddSpacer(options)

  -- Mythic+ Section
  do
    local mythicGroup = self:AddInlineRequirementsDesc(options, {
      name = "Mythic+ Section",
      hidden = not TXUI.IsRetail,
    }, {
      name = "Display your character's Mythic+ information.\n\n",
    }, I.Requirements.GameMenuButton).args

    mythicGroup.showMythic = {
      order = self:GetOrder(),
      type = "toggle",
      name = "Show Mythic+",
      desc = "Toggling this on displays your Mythic+ information in the game menu background.",
      get = function()
        return E.db.TXUI.addons.gameMenuSkin.showMythic
      end,
      set = function(_, value)
        E.db.TXUI.addons.gameMenuSkin.showMythic = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
      disabled = function()
        return not E.db.TXUI.addons.gameMenuSkin.enabled
      end,
    }

    local optionsDisabled = function()
      return not E.db.TXUI.addons.gameMenuSkin.enabled or not E.db.TXUI.addons.gameMenuSkin.showMythic
    end

    mythicGroup.showScore = {
      order = self:GetOrder(),
      type = "toggle",
      name = "Show Score",
      desc = "Toggling this on displays your Mythic+ Score in the game menu background.",
      get = function()
        return E.db.TXUI.addons.gameMenuSkin.showMythicScore
      end,
      set = function(_, value)
        E.db.TXUI.addons.gameMenuSkin.showMythicScore = value
        E:StaticPopup_Show("CONFIG_RL")
      end,
      disabled = optionsDisabled,
    }

    mythicGroup.mythicHistoryLimit = {
      order = self:GetOrder(),
      type = "range",
      name = "History Limit",
      desc = "Number of Mythic+ dungeons shown in the latest runs.",
      min = 0,
      max = 10,
      step = 1,
      get = function()
        return E.db.TXUI.addons.gameMenuSkin.mythicHistoryLimit
      end,
      set = function(_, value)
        E.db.TXUI.addons.gameMenuSkin.mythicHistoryLimit = value
      end,
      disabled = optionsDisabled,
    }
  end
end

O:AddCallback("Skins_ElvUI")
