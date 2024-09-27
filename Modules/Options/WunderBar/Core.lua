local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")

function O:WunderBar()
  self:ResetOrder()

  local wunderBarDisabled = function()
    return not E.db.TXUI.wunderbar.general.enabled or (not TXUI:HasRequirements(I.Requirements.WunderBar))
  end

  local options = self.options.wunderbar.args

  options["general"] = {
    order = 1,
    type = "group",
    name = "General",
    desc = "General Settings for WunderBar",
    get = function(info)
      return E.db.TXUI.wunderbar.general[info[#info]]
    end,
    set = function(info, value)
      E.db.TXUI.wunderbar.general[info[#info]] = value
      TXUI:GetModule("WunderBar"):UpdateBar()
    end,
    args = {},
  }

  options["modules"] = {
    order = 2,
    type = "group",
    name = "Module Positions",
    desc = "Placement and Selection for Modules",
    hidden = wunderBarDisabled,
    args = {},
  }

  options["submodules"] = {
    order = 3,
    type = "group",
    childGroups = "tree",
    name = "Module Settings",
    desc = "Settings for individual " .. TXUI.Title .. " modules",
    hidden = wunderBarDisabled,
    args = {},
  }

  self:WunderBar_General()
  self:WunderBar_Modules()
  self:WunderBar_SubModules()
end

O:AddCallback("WunderBar")
