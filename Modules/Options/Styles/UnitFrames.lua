local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")

function O:Styles_UnitFrames()
  -- Create Tab
  self.options.styles.args["unitFramesGroup"] = {
    order = self:GetOrder(),
    type = "group",
    name = "UnitFrames",
    args = {},
  }

  -- Options
  local options = self.options.styles.args["unitFramesGroup"]["args"]

  -- UnitFrames Group Description
  self:AddInlineDesc(options, {
    name = "Description",
  }, {
    name = "Coming soon..",
  })
end

O:AddCallback("Styles_UnitFrames")
