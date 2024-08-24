local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")

local find = string.find
local ipairs = ipairs
local pairs = pairs
local sub = string.sub

local getNameSorted = function(name)
  if find(name, "ElvUI") then
    return "1" .. name
  elseif find(name, "LDB") then
    return "2" .. name
  end
  return "0" .. name
end

function O:WunderBar_Modules_Select(group, panelName)
  for slot = 1, 3 do
    group.args["panel" .. slot] = {
      order = self:GetOrder(),
      type = "select",
      name = "",
      values = function()
        if (panelName == "MiddlePanel") and (slot == 2) then
          return {
            [getNameSorted("")] = "NONE",
            [getNameSorted("Time")] = TXUI:GetModule("WunderBar").registeredModulesNames["Time"],
          }
        else
          local availableModules = {
            [getNameSorted("")] = "NONE",
          }
          for name, displayName in pairs(TXUI:GetModule("WunderBar").registeredModulesNames) do
            availableModules[getNameSorted(name)] = displayName
          end
          return availableModules
        end
      end,
      get = function()
        return getNameSorted(E.db.TXUI.wunderbar.modules[panelName][slot])
      end,
      set = function(_, value)
        -- Remove sort key
        local val = sub(value, 2)

        -- Remove from anywhere else
        for _, mods in pairs(E.db.TXUI.wunderbar.modules) do
          for i, v in ipairs(mods) do
            if v == val then mods[i] = "" end
          end
        end

        -- Update in case something got removed
        TXUI:GetModule("WunderBar"):UpdatePanelSubModules()

        -- Set new location
        E.db.TXUI.wunderbar.modules[panelName][slot] = val

        -- Update everything
        TXUI:GetModule("WunderBar"):UpdatePanelSubModules()
        TXUI:GetModule("WunderBar"):UpdateBar()
      end,
      width = 1.5,
    }
  end
end

function O:WunderBar_Modules()
  -- Options
  local options = self.options.wunderbar.args["modules"]["args"]

  -- Modules Description
  self:AddInlineDesc(options, {
    name = "Description",
  }, {
    name = "Here you can enable and set the position of modules. There can not be duplicate modules active.\n\n"
      .. F.String.ToxiUI("Information:")
      .. " Module sizing is dynamically calculated, so things like bigger font sizes will show less information. Imagine the WunderBar being split into nine equal slots - modules can't exceed that width with the "
      .. F.String.Class("Time")
      .. " module being an exception. \n\n"
      .. F.String.Warning("Important:")
      .. " Some modules will increase their size automatically if they have no neighbouring Module.",
  })

  -- Spacer
  self:AddSpacer(options)

  -- Modules Left
  do
    local group = self:AddInlineGroup(options, {
      name = "Modules - Left",
    })
    self:WunderBar_Modules_Select(group, "LeftPanel")
  end

  -- Spacer
  self:AddSpacer(options)

  -- Modules Middle
  do
    local group = self:AddInlineGroup(options, {
      name = "Modules - Middle",
    })
    self:WunderBar_Modules_Select(group, "MiddlePanel")
  end

  -- Spacer
  self:AddSpacer(options)

  -- Modules Right
  do
    local group = self:AddInlineGroup(options, {
      name = "Modules - Right",
    })
    self:WunderBar_Modules_Select(group, "RightPanel")
  end
end
