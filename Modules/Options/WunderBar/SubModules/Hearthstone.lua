local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")
local ACH = LibStub("LibAceConfigHelper")

local _G = _G
local LOCALIZED_CLASS_NAMES_FEMALE = _G.LOCALIZED_CLASS_NAMES_FEMALE
local LOCALIZED_CLASS_NAMES_MALE = _G.LOCALIZED_CLASS_NAMES_MALE
local pairs = pairs
local UnitSex = UnitSex

function O:WunderBar_SubModules_Additional_Toggle(group)
  group["toggles"] = ACH:MultiSelect(
    " ",
    nil,
    1,
    function()
      local names = {}
      for _, option in pairs(I.HearthstoneData) do
        if option.known and not option.hearthstone and not option.class and (TXUI.IsCata or (not option.portal and not option.teleport)) then names[option.id] = option.name end
      end
      return names
    end,
    nil,
    nil,
    function(_, key)
      return E.db.TXUI.wunderbar.subModules["Hearthstone"].additionalHS[key]
    end,
    function(_, key, value)
      E.db.TXUI.wunderbar.subModules["Hearthstone"].additionalHS[key] = value
    end
  )
end

function O:WunderBar_SubModules_Hearthstone_Select(group, order, name, disabled)
  group[name] = ACH:Select(
    (name == "primaryHS" and "主要" or "次要") .. " 炉石",
    nil,
    order,
    function()
      -- For mages
      local classNames = LOCALIZED_CLASS_NAMES_MALE
      if UnitSex("player") == 3 then classNames = LOCALIZED_CLASS_NAMES_FEMALE end

      -- Generate values
      local names = {}
      for _, option in pairs(I.HearthstoneData) do
        if option.known then
          if option.teleport or option.portal then
            names[option.id] = F.String.Class(classNames["MAGE"] .. ": ", "MAGE") .. option.name
          elseif option.mythic then
            names[option.id] = F.String.Class("史诗: ", "DEMONHUNTER") .. option.name
          elseif option.covenant then
            names[option.id] = F.String.Class("盟约: ", "MONK") .. option.name
          elseif not option.class then
            names[option.id] = option.name
          end
        end
      end
      return names
    end,
    nil,
    "full",
    function(_)
      local data = I.HearthstoneData[E.db.TXUI.wunderbar.subModules["Hearthstone"][name]]
      return (data and data.known) and data.id or P.wunderbar.subModules["Hearthstone"][name]
    end,
    function(_, value)
      E.db.TXUI.wunderbar.subModules["Hearthstone"][name] = value
      TXUI:GetModule("WunderBar"):UpdateBar()
    end,
    disabled
  )
end

function O:WunderBar_SubModules_Hearthstone()
  local options = self.options.wunderbar.args.submodules.args
  local isUsingToxiUIFont = E.db.general.font == "- ToxiUI"

  options.hearthstone = ACH:Group((isUsingToxiUIFont and (F.String.ConvertGlyph(59717) .. " ") or "") .. "炉石", nil, self:GetOrder(), nil, function(info)
    return E.db.TXUI.wunderbar.subModules["Hearthstone"][info[#info]]
  end, function(info, value)
    E.db.TXUI.wunderbar.subModules["Hearthstone"][info[#info]] = value
    TXUI:GetModule("WunderBar"):UpdateBar()
  end)

  local tab = options.hearthstone.args
  local iconDisabled = function()
    return not E.db.TXUI.wunderbar.subModules["Hearthstone"].showIcon
  end

  -- General
  tab.generalGroup = ACH:Group("常规", nil, 1)
  tab.generalGroup.inline = true

  tab.generalGroup.args.useUppercase = ACH:Toggle("大写", nil, self:GetOrder())
  tab.generalGroup.args.showIcon = ACH:Toggle("显示图标", nil, self:GetOrder())
  tab.generalGroup.args.iconFontSize = ACH:Range("图标大小", nil, self:GetOrder(), {
    min = 1,
    max = 100,
    step = 1,
  }, nil, nil, nil, iconDisabled)

  self:AddSpacer(tab.generalGroup.args)

  tab.generalGroup.args.seasonMythics = {
    type = "toggle",
    name = "赛季史诗+传送",
    desc = "启用此选项将在飞出框中仅显示当前赛季的传送",
    order = self:GetOrder(),
    hidden = not TXUI.IsRetail,
    width = 1.2,
  }

  tab.generalGroup.args.showLabels = {
    type = "toggle",
    name = "显示 " .. F.String.Class("史诗+", "DEMONHUNTER") .. " 标签 " .. E.NewSign,
    desc = "启用此选项将在按钮上显示史诗+传送的标签。",
    order = self:GetOrder(),
    hidden = not TXUI.IsRetail,
    width = 1.2,
  }

  tab.generalGroup.args.showMageLabels = {
    type = "toggle",
    name = "显示 " .. F.String.Class("法师", "MAGE") .. " 标签 " .. E.NewSign,
    desc = "启用此选项将在按钮上显示法师传送和传送门的标签。",
    order = self:GetOrder(),
    disabled = function()
      local _, class = UnitClass("player")
      return class ~= "MAGE"
    end,
    width = 1.2,
  }

  -- Hearthstones
  tab.hearthstoneGroup = ACH:Group("炉石", nil, 2)
  tab.hearthstoneGroup.inline = true
  tab.hearthstoneGroup.args.randomPrimaryHs = ACH:Toggle(
    "随机主要炉石",
    "启用此选项将在每次重新加载UI时随机选择已选择的炉石玩具。它不会选择达拉然或要塞炉石、职业传送、盟约石。",
    1,
    nil,
    nil,
    2,
    nil,
    nil,
    nil,
    not TXUI.IsRetail
  )
  local primaryHsDisabled = function()
    return E.db.TXUI.wunderbar.subModules["Hearthstone"].randomPrimaryHs
  end
  local tomeOfTeleportationEnabled = function()
    return F.IsAddOnEnabled("TomeOfTeleportation")
  end

  self:WunderBar_SubModules_Hearthstone_Select(tab.hearthstoneGroup.args, 2, "primaryHS", primaryHsDisabled)
  self:WunderBar_SubModules_Hearthstone_Select(tab.hearthstoneGroup.args, 3, "secondaryHS", tomeOfTeleportationEnabled)

  -- Sort hearthstone selects by value
  tab.hearthstoneGroup.args.primaryHS.sortByValue = true
  tab.hearthstoneGroup.args.secondaryHS.sortByValue = true

  -- Cooldowns
  tab.cooldownGroup = ACH:Group("冷却文本组", nil, 2)
  tab.cooldownGroup.inline = true

  local cooldownDisabled = function()
    return not E.db.TXUI.wunderbar.subModules["Hearthstone"].cooldownEnabled
  end

  tab.cooldownGroup.args.cooldownEnabled = ACH:Toggle(function()
    return cooldownDisabled() and "禁用" or "启用"
  end, nil, 1)

  tab.cooldownGroup.args.cooldownUseAccent = ACH:Toggle("强调颜色", nil, 2, nil, nil, nil, nil, nil, cooldownDisabled)

  tab.cooldownGroup.args.spacer1 = ACH:Spacer(3)

  tab.cooldownGroup.args.cooldownFont = ACH:SharedMediaFont("字体", nil, 4, nil, nil, nil, cooldownDisabled)
  tab.cooldownGroup.args.cooldownFontSize = ACH:Range("字体大小", nil, 5, {
    min = 1,
    max = 100,
    step = 1,
  }, nil, nil, nil, cooldownDisabled)

  tab.cooldownGroup.args.cooldownOffset = ACH:Range("垂直偏移", nil, 6, {
    min = 1,
    max = 100,
    step = 1,
  }, nil, nil, nil, cooldownDisabled)

  -- Additional Tooltip Hearthstones
  tab.additionalGroup = ACH:Group("额外的工具提示冷却", nil, 3)
  tab.additionalGroup.inline = true
  self:WunderBar_SubModules_Additional_Toggle(tab.additionalGroup.args)
end
