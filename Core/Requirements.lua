local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

local ipairs = ipairs
local type = type

function TXUI:HasRequirements(requirements, skipProfile)
  local check = self:CheckRequirements(requirements, skipProfile)
  return (check == true) and true or false
end

function TXUI:GetRequirementString(requirement)
  local reason = ""
  local text = I.Strings.Requirements[requirement]

  if not text or (text == "") or (text == "NO_STRING_DEFINED") then
    self:LogDebug("GetRequirementString > Could not find string for " .. I.Enum.Requirements[requirement])
  else
    reason = (text ~= "NO_STRING_NEEDED") and text or ""
  end

  return (reason ~= "") and reason or nil
end

function TXUI:CheckRequirements(requirements, skipProfile)
  if not skipProfile and (not F.IsTXUIProfile()) then return I.Enum.Requirements.TOXIUI_PROFILE end
  if type(requirements) ~= "table" then requirements = { requirements } end

  for _, requirement in ipairs(requirements) do
    if requirement == I.Enum.Requirements.SL_DISABLED then
      if F.IsAddOnEnabled("ElvUI_SLE") then return requirement end
    elseif requirement == I.Enum.Requirements.DARK_MODE_ENABLED then
      if E.db.TXUI.themes.darkMode.enabled ~= true then return requirement end
    elseif requirement == I.Enum.Requirements.DARK_MODE_DISABLED then
      if E.db.TXUI.themes.darkMode.enabled ~= false then return requirement end
    elseif requirement == I.Enum.Requirements.GRADIENT_MODE_ENABLED then
      if E.db.TXUI.themes.gradientMode.enabled ~= true then return requirement end
    elseif requirement == I.Enum.Requirements.GRADIENT_MODE_DISABLED then
      if E.db.TXUI.themes.gradientMode.enabled ~= false then return requirement end
    elseif requirement == I.Enum.Requirements.SL_VEHICLE_BAR_DISABLED then
      if F.IsAddOnEnabled("ElvUI_SLE") and E.db.sle.actionbar.vehicle.enabled then return requirement end
    elseif requirement == I.Enum.Requirements.SL_MINIMAP_COORDS_DISABLED then
      if F.IsAddOnEnabled("ElvUI_SLE") and E.db.sle and E.db.sle.minimap.coords.enable then return requirement end
    elseif requirement == I.Enum.Requirements.SL_DECONSTRUCT_DISABLED then
      if F.IsAddOnEnabled("ElvUI_SLE") and E.private.sle and E.private.sle.professions and E.private.sle.professions.deconButton.enable then return requirement end
    elseif requirement == I.Enum.Requirements.ARMORY_DISABLED then
      if F.IsAddOnEnabled("ElvUI_SLE") then
        if F.GetDBFromPath("sle.armory.character.enable") or F.GetDBFromPath("db.sle.armory.inspect.enable") or F.GetDBFromPath("E.db.sle.armory.stats.enable") then
          return requirement
        end
      end

      if F.IsAddOnEnabled("ElvUI_EltreumUI") then
        if
          F.GetDBFromPath("ElvUI_EltreumUI.skins.expandarmorybg")
          or F.GetDBFromPath("ElvUI_EltreumUI.skins.itemquality")
          or F.GetDBFromPath("ElvUI_EltreumUI.skins.characterskingradients")
          or F.GetDBFromPath("ElvUI_EltreumUI.skins.statcolors")
          or F.GetDBFromPath("ElvUI_EltreumUI.skins.classicarmory ")
        then
          return requirement
        end
      end
    elseif requirement == I.Enum.Requirements.CHARACTER_SKIN_ENABLED then
      if E.private.skins.blizzard.character ~= true then return requirement end
    elseif requirement == I.Enum.Requirements.WT_ENABLED then
      if not F.IsAddOnEnabled("ElvUI_WindTools") then return requirement end
    elseif requirement == I.Enum.Requirements.OLD_FADE_PERSIST_DISABLED then
      if F.IsAddOnEnabled("ElvUI_GlobalFadePersist") then return requirement end
    elseif requirement == I.Enum.Requirements.ELVUI_ACTIONBARS_ENABLED then
      if E.private.actionbar.enable ~= true then return requirement end
    elseif requirement == I.Enum.Requirements.AB_BUDDY_DISABLED then
      if F.IsAddOnEnabled("ElvUI_ActionBarBuddy") then return requirement end
    elseif requirement == I.Enum.Requirements.DETAILS_LOADED_AND_TXPROFILE then
      local profileName = F.IsAddOnEnabled("Details") and Details and Details.GetCurrentProfileName and Details.GetCurrentProfileName()
      if not profileName or (profileName ~= I.ProfileNames.Default and profileName ~= I.ProfileNames.Dev) then return requirement end
    elseif requirement == I.Enum.Requirements.ELVUI_BAGS_ENABLED then
      if E.private.bags.enable ~= true then return requirement end
    elseif requirement == I.Enum.Requirements.DETAILS_NOT_SKINNED then
      if F.GetDBFromPath("mui.skins.addonSkins.enable", E.private) or F.GetDBFromPath("ElvUI_EltreumUI.skins.details") then return requirement end
    elseif requirement == I.Enum.Requirements.ELVUI_NOT_SKINNED then
      local statusBarDB = F.GetDBFromPath("sle.unitframe.statusbarTextures")
      if statusBarDB ~= nil then
        for _, tbl in pairs(statusBarDB) do
          if tbl.enable then return requirement end
        end
      end

      if
        F.GetDBFromPath("mui.unitframes.highlight.enable", E.private)
        or F.GetDBFromPath("mui.unitframes.healPrediction.enable")
        or F.GetDBFromPath("mui.unitframes.power.enable")
      then
        return requirement
      end

      if
        F.GetDBFromPath("ElvUI_EltreumUI.unitframes.gradientmode.enable")
        or F.GetDBFromPath("ElvUI_EltreumUI.unitframes.darkmode")
        or F.GetDBFromPath("ElvUI_EltreumUI.unitframes.lightmode")
        or F.GetDBFromPath("ElvUI_EltreumUI.unitframes.UFmodifications")
        or F.GetDBFromPath("ElvUI_EltreumUI.unitframes.darkpowercolor")
      then
        return requirement
      end
    elseif requirement == I.Enum.Requirements.OTHER_THEMES_DISABLED then
      if
        F.GetDBFromPath("mui.skins.shadowOverlay", E.private)
        or F.GetDBFromPath("sle.module.shadows.enable", E.private)
        or F.GetDBFromPath("ElvUI_EltreumUI.skins.shadow.enable")
        or F.GetDBFromPath("ElvUI_EltreumUI.borders.borders")
      then
        return requirement
      end
    elseif requirement == I.Enum.Requirements.ELTRUISM_COLOR_MODIFIERS_DISABLED then
      if F.IsAddOnEnabled("ElvUI_EltreumUI") and F.GetDBFromPath("ElvUI_EltreumUI.skins.colormodkey") then return requirement end
    elseif requirement == I.Enum.Requirements.ELTRUISM_DISABLED then
      if F.IsAddOnEnabled("ElvUI_EltreumUI") then return requirement end
    end
  end

  return true
end
