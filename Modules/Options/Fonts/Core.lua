local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")

function O:Fonts()
  -- Reset order for new page
  self:ResetOrder()

  local options = self.options.fonts.args

  options["elvui_fonts"] = {
    name = "Font Options",
    order = self:GetOrder(),
    type = "group",
    args = {},
  }

  options["blizzard_fonts"] = {
    order = self:GetOrder(),
    type = "group",
    name = "Blizzard Fonts",
    get = function(info)
      return E.db.TXUI.blizzardFonts[info[#info]]
    end,
    set = function(info, value)
      E.db.TXUI.blizzardFonts[info[#info]] = value
      F.Event.TriggerEvent("BlizzardFonts.SettingsUpdate")
    end,
    args = {},
  }
end

O:AddCallback("Fonts")
