local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local WB = TXUI:GetModule("WunderBar")
local DT = E:GetModule("DataTexts")
local LDB = E.Libs.LDB

local format = string.format
local strlen = string.len

local LDBna = {
  ["N/A"] = true,
  ["n/a"] = true,
  ["N/a"] = true,
}

function WB:ConstructLDBDataText(construct, dataText, name)
  construct.OnEvent = function(module)
    LDB:RegisterCallback("LibDataBroker_AttributeChanged_" .. module.name .. "_text", function(...)
      module:UpdateText(...)
    end)

    LDB:RegisterCallback("LibDataBroker_AttributeChanged_" .. module.name .. "_value", function(...)
      module:UpdateText(...)
    end)

    construct:OnCallback()
  end

  construct.OnCallback = function(module)
    if module.name and module.dataText then
      LDB.callbacks:Fire("LibDataBroker_AttributeChanged_" .. module.name .. "_text", module.name, nil, module.dataText.text, module.dataText)
    end
  end

  construct.OnClick = function(module, _, ...)
    if module.dataText.OnClick then module.dataText.OnClick(module.dataTextDummy, ...) end
  end

  construct.OnEnter = function(module)
    module.mouseOver = true
    module:UpdateColor()

    if module.dataText.OnTooltipShow then module.dataText.OnTooltipShow(DT.tooltip) end
    if module.dataText.OnEnter then module.dataText.OnEnter(module.dataTextDummy) end
    DT.tooltip:Show()
  end

  construct.OnLeave = function(module, _, ...)
    module.mouseOver = false
    module:UpdateColor()

    if module.dataText.OnLeave then module.dataText.OnLeave(module.dataTextDummy, ...) end
  end

  construct.OnWunderBarUpdate = function(module)
    module:UpdateColor()
    module:UpdateFonts()
    module:UpdateElements()
    module:OnEvent()
  end

  construct.UpdateColor = function(module)
    if module.mouseOver then
      WB:SetFontAccentColor(module.text)
    else
      WB:SetFontNormalColor(module.text)
    end
  end

  construct.UpdateFonts = function(module)
    WB:SetFontFromDB(nil, nil, module.text)
  end

  construct.UpdateElements = function(module)
    local anchorPoint = WB:GetGrowDirection(module.Module, true)

    module.text:ClearAllPoints()

    if anchorPoint == "RIGHT" then
      module.text:SetJustifyH("RIGHT")
      module.text:SetPoint("RIGHT", module.frame, "RIGHT", 0, 0)
    else
      module.text:SetJustifyH("LEFT")
      module.text:SetPoint("LEFT", module.frame, "LEFT", 0, 0)
    end

    module.text:SetSize(module.Module:GetWidth(), module.Module:GetHeight())
  end

  construct.UpdateText = function(module, _, Name, _, Value)
    if module.text then
      local text
      if not Value or (strlen(Value) >= 3) or (Value == Name or LDBna[Value]) then
        text = (not LDBna[Value] and Value) or Name
      else
        text = format("%s: %s", Name, Value)
      end

      text = F.String.StripTexture(module.db.textColor and text or F.String.StripColor(text))
      module.text:SetText(module.db.useUppercase and F.String.Uppercase(text) or text)
    end
  end

  construct.CreateText = function(module)
    if module.text then return end

    local text = module.frame:CreateFontString(nil, "OVERLAY")
    text:SetPoint("CENTER")

    module.text = text
  end

  construct.OnInit = function(module)
    -- Get our settings DB
    module.db = WB:GetSubModuleDB("ElvUILDB")

    -- Vars
    module.frame = module.SubModuleHolder
    module.mouseOver = false

    -- Create our text
    module:CreateText()

    -- Dummy ref
    module.dataTextDummy = module.frame
    module.dataTextDummy.EnableMouseWheel = function(_, enable)
      module.Module:EnableMouseWheel(enable)
    end
    module.dataTextDummy.SetScript = function(_, event, func)
      module.Module:SetScript(event, func)
    end

    -- Update
    module:OnWunderBarUpdate()
  end

  construct.name = name
  construct.dataText = dataText
end

function WB:RegisterLDBDatatexts()
  for name, obj in LDB:DataObjectIterator() do
    if not (DT.RegisteredDataTexts[name] and DT.RegisteredDataTexts[name].category ~= "Data Broker") then
      local moduleName = "LDB: " .. name
      if not self:GetModule(moduleName, true) then
        local constructed = WB:NewModule(moduleName)
        self:ConstructLDBDataText(constructed, obj, name)
        self:RegisterSubModule(constructed)
      end
    else
      self:LogDebug("RegisterDatatexts > Cannot register LDB module, due to conflict:", name)
    end
  end
end
