local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local WB = TXUI:GetModule("WunderBar")
local DT = E:GetModule("DataTexts")

local CreateFrame = CreateFrame
local GetCVarBool = GetCVarBool
local ipairs = ipairs
local max = math.max
local min = math.min
local pairs = pairs
local tinsert = table.insert

function WB:GetGrowDirection(module, inverse)
  if not module then return end

  local index = module.moduleIndex

  if (index == 1) or (index == 2) or (index == 3) or (index == 6) then
    return inverse and "LEFT" or "RIGHT"
  elseif (index == 7) or (index == 8) or (index == 9) or (index == 4) then
    return inverse and "RIGHT" or "LEFT"
  end

  return "CENTER"
end

function WB:GetMaxWidth(module)
  if not module then return end

  return module:GetWidth()
end

function WB:HasRegisteredSubModule(module)
  return self.registeredModules[self.db.modules[module.parentName][module.parentIndex]]
end

function WB:RequestToExtend(module)
  module.extendModuleRequest = true
end

function WB:GrantExtendRequest(module)
  if not self:HasRegisteredSubModule(module) then return end
  if not module.extendModuleRequest then return end

  local growDir = self:GetGrowDirection(module)
  if growDir == "CENTER" then return end

  local index = module.moduleIndex
  local neighbourIndex, neighboursNeighbourIndex

  if growDir == "RIGHT" then
    neighbourIndex = index + 1
    neighboursNeighbourIndex = index + 2
  elseif growDir == "LEFT" then
    neighbourIndex = index - 1
    neighboursNeighbourIndex = index - 2
  end

  neighbourIndex = min(9, max(1, neighbourIndex))
  neighboursNeighbourIndex = min(9, max(1, neighboursNeighbourIndex))

  local neighbourModule = self.moduleFrames[neighbourIndex]
  local neighboursNeighbourModule = self.moduleFrames[neighboursNeighbourIndex]

  -- ignore request if space is not empty
  if self:HasRegisteredSubModule(neighbourModule) then return end

  -- ignore request if middle panel has already requested
  if self:HasRegisteredSubModule(neighboursNeighbourModule) and neighboursNeighbourModule.extendModuleRequest and neighboursNeighbourModule.parentName == "MiddlePanel" then
    return
  end

  module.extendedModule = true
end

function WB:ExtendModule(module)
  if not module.extendedModule then return end

  local growDir = self:GetGrowDirection(module)

  -- center is special
  if growDir == "CENTER" then return end

  local index = module.moduleIndex
  local neighbourIndex

  if growDir == "RIGHT" then
    neighbourIndex = index + 1
  elseif growDir == "LEFT" then
    neighbourIndex = index - 1
  end

  neighbourIndex = min(9, max(1, neighbourIndex))

  local neighbourModule = self.moduleFrames[neighbourIndex]

  local mWidth, mHeight = module:GetSize()
  local nWidth = neighbourModule:GetWidth()

  if growDir == "LEFT" then
    local point, attachedTo, relativePoint, xOffset, yOffset = module:GetPoint()
    xOffset = xOffset - nWidth

    module:ClearAllPoints()
    module:SetPoint(point, attachedTo, relativePoint, xOffset, yOffset)
  end

  module:SetSize(mWidth + nWidth, mHeight)
  neighbourModule:Hide()
end

function WB:GetModulePoint(module, xOffsetOverwrite)
  local width, _ = self:GetModuleAttributes(module)
  local point, relativePoint, xOffset, yOffset = "LEFT", "LEFT", xOffsetOverwrite or (width * (module.parentIndex - 1)), 0
  return point, module.parent, relativePoint, xOffset, yOffset
end

function WB:GetModuleAttributes(module)
  local panelWidth, panelHeight = module.parent:GetSize()
  return (panelWidth / 3), panelHeight
end

function WB:ModuleOnClick(subModule, ...)
  if subModule and subModule.OnClick then
    if self:GetClickAllowed() then
      DT.tooltip:Hide()
      subModule:OnClick(...)
    end
  end
end

function WB:ModuleOnEnter(subModule, ...)
  if subModule and subModule.OnEnter then
    if self:GetHoverAllowed() then
      DT.tooltip:ClearLines()
      DT.tooltip:SetOwner(subModule.SubModuleHolder, "ANCHOR_TOP", 0, 20)
      subModule:OnEnter(...)
    end
  end

  self:BarOnEnter(...)
end

function WB:ModuleOnLeave(subModule, ...)
  if subModule and subModule.OnEnter then
    DT.tooltip:ClearLines()
    DT.tooltip:Hide()
  end

  if subModule and subModule.OnLeave then subModule:OnLeave(...) end

  self:BarOnLeave(...)
end

do
  local timeElapsed = 0
  local timeThreshold = 0.1
  function WB:HandleModuleOnUpdate(elapsed)
    timeElapsed = timeElapsed + elapsed
    if timeElapsed < timeThreshold then return end

    for _, module in ipairs(self.moduleFrames) do
      if module.subModule and module.subModule.OnUpdate then module.subModule:OnUpdate(timeElapsed) end
    end

    timeElapsed = 0
  end
end

function WB:UpdatePanelModules(noUpdate)
  -- Update Position
  for _, module in ipairs(self.moduleFrames) do
    module:ClearAllPoints()
    module:SetPoint(self:GetModulePoint(module))
  end

  -- Reset Size
  for _, module in ipairs(self.moduleFrames) do
    local width, height = self:GetModuleAttributes(module)
    module:SetSize(width, height)
  end

  if not noUpdate then
    -- Grant extended request
    for _, module in ipairs(self.moduleFrames) do
      self:GrantExtendRequest(module)
    end

    -- Request size calculation if dynamic size is enabled
    if self.db.general.experimentalDynamicSize then
      for _, module in ipairs(self.moduleFrames) do
        if module.subModule and module.subModule.OnSizeCalculation then module.calculatedSize = module.subModule:OnSizeCalculation() end
      end

      -- Update dynamic size
      local dynamicSizeFound = false
      local dynamicSizeModule = nil
      local firstModuleIdInParent = nil
      for _, module in ipairs(self.moduleFrames) do
        if module.parentIndex == 1 then
          dynamicSizeFound = false
          dynamicSizeModule = nil
          firstModuleIdInParent = module.moduleIndex
        end

        if module.calculatedSize and module.calculatedSize ~= 0 then
          dynamicSizeFound = true
          dynamicSizeModule = module
        end

        if module.parentIndex == 3 and dynamicSizeFound and dynamicSizeModule then
          local dynamicWidth = dynamicSizeModule.calculatedSize + (E:Scale(self.db.general.barSpacing) * 2)
          local newWidth = ((dynamicSizeModule.parent:GetWidth() - dynamicWidth) / 2)
          local newHeight = dynamicSizeModule.parent:GetHeight()
          local nextXOffset = 0

          for i = firstModuleIdInParent, (firstModuleIdInParent + 2) do
            local resizeModule = self.moduleFrames[i]

            resizeModule:ClearAllPoints()
            resizeModule:SetPoint(self:GetModulePoint(resizeModule, nextXOffset))

            if resizeModule == dynamicSizeModule then
              resizeModule:SetSize(dynamicWidth, newHeight)
              nextXOffset = nextXOffset + dynamicWidth
            else
              resizeModule:SetSize(newWidth, newHeight)
              nextXOffset = nextXOffset + newWidth
            end
          end
        end
      end
    end

    -- Grow frame is request was granted
    for _, module in ipairs(self.moduleFrames) do
      self:ExtendModule(module)
    end

    -- Ask Module to update
    self:SendForceUpdate(true)
  end
end

function WB:SendForceUpdate(barUpdate)
  -- Trigger Force Update
  for _, module in ipairs(self.moduleFrames) do
    if module.subModule then
      module:Show()
      if barUpdate and module.subModule.OnWunderBarUpdate then module.subModule:OnWunderBarUpdate() end
      if module.subModule.OnEvent then module.subModule:OnEvent("ELVUI_FORCE_UPDATE") end
      if module.subModule.OnUpdate then module.subModule:OnUpdate(20000) end
    end
  end
end

function WB:UpdatePanelSubModules()
  self:UpdatePanelModules(true)
  self:DisableAllModules()

  local updateProxy = function(subModule, event, ...)
    if not self.isVisible then return end
    if TXUI.LogLevel > 4 then self:LogTrace("Firing Event", subModule:GetName(), event) end
    subModule.OnEvent(subModule, event, ...)
  end

  for _, module in ipairs(self.moduleFrames) do
    local moduleData = self.registeredModules[self.db.modules[module.parentName][module.parentIndex]]
    if moduleData then
      local subModule = self:GetModule(moduleData.name)
      subModule.Data = moduleData
      subModule.Module = module
      subModule.SubModuleHolder = subModule.SubModuleHolder or CreateFrame("Frame", nil, module)
      subModule.SubModuleHolder:SetParent(module)
      subModule.SubModuleHolder:ClearAllPoints()
      subModule.SubModuleHolder:SetAllPoints(module)
      subModule.SubModuleHolder:Show()

      if subModule.OnInit then subModule:OnInit(module) end

      if subModule.OnEvent then
        if moduleData.events then
          for _, event in pairs(moduleData.events) do
            F.Event.RegisterFrameEventAndCallback(event, updateProxy, subModule, event)
          end
        end
      end

      module:SetScript("OnClick", function(...)
        self:ModuleOnClick(subModule, ...)
      end)

      module:SetScript("OnEnter", function(...)
        self:ModuleOnEnter(subModule, ...)
      end)

      module:SetScript("OnLeave", function(...)
        self:ModuleOnLeave(subModule, ...)
      end)

      module.subModule = subModule
    end
  end

  self:UpdatePanelModules()
end

function WB:DisableAllModules()
  for _, module in ipairs(self.moduleFrames) do
    module:Hide()
    module:UnregisterAllEvents()
    module:EnableMouseWheel(false)
    module:SetScript("OnUpdate", nil)
    module:SetScript("OnEvent", nil)
    module:SetScript("OnClick", nil)
    module:SetScript("OnEnter", nil)
    module:SetScript("OnLeave", nil)
    if module.subModule then
      if module.subModule.OnEvent then
        if module.subModule.Data.events then
          for _, event in pairs(module.subModule.Data.events) do
            F.Event.UnregisterFrameEventAndCallback(event, module.subModule)
          end
        end
      end

      module.subModule.SubModuleHolder:Hide()
      module.subModule.Module = nil
    end
    module.subModule = nil
    module.extendedModule = false
    module.extendModuleRequest = false
    module.calculatedSize = 0
  end
end

function WB:ConstructModule(panel, moduleIndex, parentIndex)
  local module = CreateFrame("Button", "TXUIWunderBar" .. panel.panelName .. "Module" .. parentIndex, panel)
  module:RegisterForClicks(GetCVarBool("ActionButtonUseKeyDown") and "AnyDown" or "AnyUp")
  module.subModule = nil
  module.extendedModule = false
  module.extendModuleRequest = false
  module.calculatedSize = 0
  module.parent = panel
  module.parentName = panel.panelName
  module.parentIndex = parentIndex
  module.moduleIndex = moduleIndex
  tinsert(self.moduleFrames, module)
end

function WB:ConstructModules()
  if self.moduleFrames then return end

  -- Frame holder
  self.moduleFrames = {}

  -- Create Modules
  for i = 1, 3 do
    self:ConstructModule(self.bar.leftPanel, i, i)
  end
  for i = 4, 6 do
    self:ConstructModule(self.bar.middlePanel, i, i - 3)
  end
  for i = 7, 9 do
    self:ConstructModule(self.bar.rightPanel, i, i - 6)
  end

  -- Update Modules
  self:UpdatePanelSubModules()
end
