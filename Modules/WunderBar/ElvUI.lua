local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local WB = TXUI:GetModule("WunderBar")

local ipairs = ipairs

function WB:ConstructElvUIDataText(construct, dataText)
  construct.OnUpdate = function(module, ...)
    if module.dataText.onUpdate then
      module.dataText.onUpdate(module.dataTextDummy, ...)
      module:UpdateText()
    end
  end

  construct.OnEvent = function(module, ...)
    if module.dataText.eventFunc then
      module.dataText.eventFunc(module.dataTextDummy, ...)
      module:UpdateText()
    end
  end

  construct.OnClick = function(module, _, ...)
    if module.dataText.onClick then
      module.dataText.onClick(module.dataTextDummy, ...)
      module:UpdateText()
    end
  end

  construct.OnEnter = function(module, _, ...)
    module.mouseOver = true
    module:UpdateColor()

    if module.dataText.onEnter then
      module.dataText.onEnter(module.dataTextDummy, ...)
      module:UpdateText()
    end
  end

  construct.OnLeave = function(module, _, ...)
    module.mouseOver = false
    module:UpdateColor()

    if module.dataText.OnLeave then
      module.dataText.OnLeave(module.dataTextDummy, ...)
      module:UpdateText()
    end
  end

  construct.OnWunderBarUpdate = function(module)
    module:UpdateColor()
    module:UpdateFonts()
    module:UpdateElements()
    module.OnEvent(module, "ELVUI_FORCE_UPDATE")
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

  construct.UpdateText = function(module)
    if module.text then
      local text = module.text:GetText()
      text = F.String.StripTexture(module.db.textColor and text or F.String.StripColor(text))

      if text and text ~= "" then module.text:SetText(module.db.useUppercase and F.String.Uppercase(text) or text) end
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
    module.dataText = dataText

    -- Create our text
    module:CreateText()

    -- Dummy ref
    module.dataTextDummy = module.frame
    module.dataTextDummy.text = module.text

    -- Update
    module:OnWunderBarUpdate()
  end
end

function WB:RegisterElvUIDatatexts()
  local elvUIDataTexts = {
    "Agility",
    "Armor",
    "CallToArms",
    "Coords",
    "Crit",
    "DPS",
    "Experience",
    "Expertise",
    "Haste",
    "HPS",
    "Item Level",
    "Leech",
    "Mail",
    "Mana Regen",
    "Mastery",
    "Missions",
    "Primary Stat",
    "Reputation",
    "Resilience",
    "Speed",
    "Stamina",
    "Strength",
    "Versatility",
  }

  if not TXUI.IsVanilla then tinsert(elvUIDataTexts, "Equipment Sets") end

  for _, dataTextName in ipairs(elvUIDataTexts) do
    local dt = self:GetElvUIDataText(dataTextName)
    if dt then
      local name = "ElvUI: " .. dataTextName

      if not self:GetModule(name, true) then
        local constructed = WB:NewModule(name)
        self:ConstructElvUIDataText(constructed, dt)
        self:RegisterSubModule(constructed, dt.events)

        -- Create virtual frame and connect it to datatext
        constructed.virtualFrame = {
          name = dataTextName,
          text = {
            SetFormattedText = E.noop,
          },
        }
        WB:ConnectVirtualFrameToDataText(dataTextName, constructed.virtualFrame)
      end
    end
  end
end
