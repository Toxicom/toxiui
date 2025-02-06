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
end

O:AddCallback("Fonts")
