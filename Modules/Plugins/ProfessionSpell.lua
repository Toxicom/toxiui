local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local PS = TXUI:NewModule("ProfessionSpell", "AceHook-3.0")

-- Globals
local CreateFrame = CreateFrame
local _G = _G
local GameTooltip = GameTooltip
local GetSpellTexture = GetSpellTexture

function PS:CreateButton()
  if self.button then return end

  local showTooltip = function(button)
    if button.spellID then
      GameTooltip:SetOwner(button, "ANCHOR_LEFT", 4, 4)
      -- Necessary for professions
      local _, _, _, _, _, _, spellID = GetSpellInfo(button.spellID)
      GameTooltip:SetSpellByID(spellID or button.spellID)
    end
  end

  local button = CreateFrame("Button", "ToxiUI_Profession_Button", _G.ProfessionsFrame, "SecureActionButtonTemplate")
  button:EnableMouse(true)
  button:RegisterForClicks("AnyDown")
  button:SetSize(self.width, self.height)
  button:SetTemplate()
  button:StyleButton(nil, true)
  button:SetPoint("TOPLEFT", 20, -20)
  button:SetScript("OnEnter", showTooltip)
  button:SetScript("OnLeave", F.Event.GenerateClosure(GameTooltip.Hide, GameTooltip))

  button.spellID = 818

  -- Set the button to cast Cooking Fire at the player's location
  button:SetAttribute("type", "macro")
  button:SetAttribute("macrotext", "/cast [@player] Cooking Fire")

  local texture = GetSpellTexture(button.spellID)

  button:SetNormalTexture(texture)
  button:SetPushedTexture(texture)
  button:SetDisabledTexture(texture)

  local left, right, top, bottom = E:CropRatio(button)
  local normalTexture, pushedTexture, disabledTexture = button:GetNormalTexture(), button:GetPushedTexture(), button:GetDisabledTexture()
  normalTexture:SetTexCoord(left, right, top, bottom)
  normalTexture:SetInside()
  pushedTexture:SetTexCoord(left, right, top, bottom)
  pushedTexture:SetInside()
  disabledTexture:SetTexCoord(left, right, top, bottom)
  disabledTexture:SetInside()
  disabledTexture:SetDesaturated(true)

  -- Create Cooldown Frame
  local cooldown = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate")
  cooldown:SetAllPoints()
  cooldown:SetDrawBling(false)
  cooldown:SetDrawEdge(false)
  button.cooldown = cooldown

  -- Hook OnUpdate script to update cooldown
  button:SetScript("OnUpdate", function()
    local start, duration = GetSpellCooldown(self.spellID)
    if start and duration and duration > 0 then self.cooldown:SetCooldown(start, duration) end
  end)

  F.Log.Dev(button, "button")

  self.button = button
end

function PS:OnEvent(event, addonName)
  if event == "ADDON_LOADED" and addonName == "Blizzard_Professions" then
    _G.ProfessionsFrame:HookScript("OnShow", function(self)
      local prof = self:GetProfessionInfo()
      if prof and prof.professionID == 185 then
        if not PS.button then PS:CreateButton() end
        PS.button:Show()
      else
        if PS.button then PS.button:Hide() end
      end
    end)
  end
end

function PS:Initialize()
  if self.Initialized then return end

  self.button = nil
  self.width = 48 + E.Border
  self.height = 36 + E.Border

  local eventFrame = CreateFrame("Frame")
  eventFrame:RegisterEvent("ADDON_LOADED")
  eventFrame:SetScript("OnEvent", self.OnEvent)

  self.Initialized = true
end

TXUI:RegisterModule(PS:GetName())
