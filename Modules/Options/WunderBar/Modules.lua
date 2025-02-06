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
            [getNameSorted("")] = "无",
            [getNameSorted("Time")] = TXUI:GetModule("WunderBar").registeredModulesNames["Time"],
          }
        else
          local availableModules = {
            [getNameSorted("")] = "无",
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
    name = "描述",
  }, {
    name = "在这里您可以启用和设置模块的位置。不能有重复的模块激活。\n\n"
      .. F.String.ToxiUI("信息:")
      .. " 模块大小是动态计算的，因此像更大的字体大小这样的东西会显示更少的信息。想象一下，WunderBar 被分成九个相等的槽位 - 模块不能超过该宽度，"
      .. F.String.Class("时间")
      .. " 模块是一个例外。\n\n"
      .. F.String.Warning("重要:")
      .. " 如果某些模块没有相邻的模块，它们会自动增加大小。",
  })

  -- Spacer
  self:AddSpacer(options)

  -- Modules Left
  do
    local group = self:AddInlineGroup(options, {
      name = "模块 - 左侧",
    })
    self:WunderBar_Modules_Select(group, "LeftPanel")
  end

  -- Spacer
  self:AddSpacer(options)

  -- Modules Middle
  do
    local group = self:AddInlineGroup(options, {
      name = "模块 - 中间",
    })
    self:WunderBar_Modules_Select(group, "MiddlePanel")
  end

  -- Spacer
  self:AddSpacer(options)

  -- Modules Right
  do
    local group = self:AddInlineGroup(options, {
      name = "模块 - 右侧",
    })
    self:WunderBar_Modules_Select(group, "RightPanel")
  end
end
