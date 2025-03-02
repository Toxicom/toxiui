local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local PF = TXUI:GetModule("Profiles")

local _G = _G

function PF:Plater(version)
  -- Globals
  local Plater = _G.Plater
  local DF = _G.DetailsFramework

  -- Overwrite plater function to supress popups on profile change
  if not self:IsHooked(Plater, "RefreshConfigProfileChanged") then self:RawHook(Plater, "RefreshConfigProfileChanged", function()
    Plater:RefreshConfig()
  end) end

  -- Overwrite plater function to supress popups on profile creation
  if not self:IsHooked(Plater, "OnProfileCreated") then
    self:RawHook(Plater, "OnProfileCreated", function()
      Plater.ImportScriptsFromLibrary()
      Plater.ApplyPatches()
      Plater.CompileAllScripts("script")
      Plater.CompileAllScripts("hook")
      Plater.db.profile.use_ui_parent = true
      Plater.db.profile.ui_parent_scale_tune = 1 / E.global.general.UIScale
      Plater:RefreshConfig()
      Plater.UpdatePlateClickSpace()
    end)
  end

  local importString = version == "new" and PF.ImportStrings.PlaterNew or PF.ImportStrings.PlaterOld

  -- Decompres data
  local profile = Plater.DecompressData(importString, "print")

  -- Set profile to Toxi
  Plater.db:SetProfile(I.ProfileNames.Default)

  -- Reset previous profile
  Plater.db:ResetProfile(false, true)

  -- Deep copy new profile over
  DF.table.copy(Plater.db.profile, profile)

  -- Restore cvars from new profile
  Plater.RestoreProfileCVars()

  -- Don't poison the cache with Wotlk/Retail data
  _G.PlaterDB.captured_casts = {}
  _G.PlaterDB.captured_spells = {}

  -- Unook plater function to supress popups on profile change
  if self:IsHooked(Plater, "RefreshConfigProfileChanged") then self:Unhook(Plater, "RefreshConfigProfileChanged") end

  -- Unook plater function to supress popups on profile creation
  if self:IsHooked(Plater, "OnProfileCreated") then self:Unhook(Plater, "OnProfileCreated") end

  -- Apply privates, not needed cause done already
  -- self:Plater_Private()
end

function PF:Plater_Private()
  if not _G.Plater then return end

  -- Globals
  local Plater = _G.Plater

  -- Set profile to Toxi
  Plater.db:SetProfile(I.ProfileNames.Default)

  -- Restore cvars from new profile
  Plater.RestoreProfileCVars()
end
