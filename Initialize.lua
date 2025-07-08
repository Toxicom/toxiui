local E, L, V, P, G = unpack(ElvUI)
local EP = E.Libs.EP
local addonName, addon = ...

local _G = _G
local find = string.find
local GetAddOnMetadata = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata
local GetBuildInfo = GetBuildInfo
local select = select
local tonumber = tonumber
local OKAY = OKAY

local TXUI = E:NewModule(addonName, "AceConsole-3.0", "AceTimer-3.0", "AceHook-3.0")

V.TXUI = {}
P.TXUI = {}
G.TXUI = {}

local F = {}
local I = {}

addon[1] = TXUI
addon[2] = F
addon[3] = E
addon[4] = I
addon[5] = V.TXUI
addon[6] = P.TXUI
addon[7] = G.TXUI
addon[8] = L
_G[addonName] = addon

TXUI.AddOnName = addonName
TXUI.GitHash = GetAddOnMetadata(addonName, "X-GitHash")
TXUI.DevRelease = false
TXUI.DevTag = ""
TXUI.DelayedWorldEntered = false
TXUI.MetaFlavor = GetAddOnMetadata(addonName, "X-Flavor")
TXUI.ClientBuildVersion = select(4, GetBuildInfo())
TXUI.Version = GetAddOnMetadata(addonName, "Version")

TXUI.IsVanilla = TXUI.MetaFlavor == "Vanilla"
TXUI.IsMists = TXUI.MetaFlavor == "Mists"
TXUI.IsRetail = TXUI.MetaFlavor == "Mainline"

-- M+ season for Retail, eg.: df3
-- see Internal.lua for M+ Hearthstones
TXUI.RetailSeason = "tww3"

TXUI.Modules = {}
TXUI.Modules.Changelog = TXUI:NewModule("Changelog", "AceEvent-3.0", "AceTimer-3.0")
TXUI.Modules.Options = TXUI:NewModule("Options")
TXUI.Modules.Skins = TXUI:NewModule("Skins", "AceHook-3.0", "AceEvent-3.0")

_G.ToxiUI_OnAddonCompartmentClick = function()
  E:ToggleOptions("TXUI")
end

-- Initialization
function TXUI:Initialize()
  -- Don't init second time
  if self.initialized then return end

  -- Set correct flavor
  local flavorMap = {
    ["Vanilla"] = I.Enum.Flavor.VANILLA,
    ["Mists"] = I.Enum.Flavor.MISTS,
    ["Mainline"] = I.Enum.Flavor.RETAIL,
  }

  self.Flavor = flavorMap[self.MetaFlavor] or I.Enum.Flavor.RETAIL

  -- Call pre init for ourselfs
  self:ModulePreInitialize(self)

  -- Mark dev release
  if self.GitHash then
    if find(self.GitHash, "alpha") then
      self.DevTag = F.String.Error("[ALPHA]")
    elseif find(self.GitHash, "beta") then
      self.DevTag = F.String.Error("[BETA]")
    elseif find(self.GitHash, "project%-version") then
      self.GitHash = "DEV" -- will be filled by changelog
      self.DevTag = F.String.Error("[DEV]")
    end

    self.DevRelease = (self.DevTag ~= "")
  end

  -- Set correct log level
  -- Higher number = more in-depth logs
  -- Log Level 5 is very spammy
  self.LogLevel = self.DevRelease and 4 or 3

  -- Check required ElvUI Version
  local ElvUIVersion = tonumber(E.version)
  local RequiredVersionString = GetAddOnMetadata(self.AddOnName, "X-ElvUIVersion")
  local RequiredVersion = tonumber(RequiredVersionString)

  E.PopupDialogs.ELVUI_MINIMUM_VERSION_REQUIRED = {
    text = TXUI.Title
      .. " did not load because your version of |cff1784d1ElvUI|r |cffef5350"
      .. E.versionString
      .. "|r is insufficient.\n\nPlease install |cff1784d1ElvUI|r version |cff66bb6a"
      .. RequiredVersionString
      .. "|r or higher!",
    button1 = OKAY,
    showAlert = true,
  }

  -- ElvUI's version check
  if ElvUIVersion < 1 or (ElvUIVersion < RequiredVersion) then
    E:Delay(2, function()
      E:StaticPopup_Show("ELVUI_MINIMUM_VERSION_REQUIRED")
    end)
    return
  end

  -- Check for non Mists, non Retail and non Vanilla
  if not self.IsRetail and not self.IsMists and not self.IsVanilla then return end

  -- Force ElvUI Setup to hide
  E.private.install_complete = E.version

  -- Set the correct tables for Flavor
  if self.IsMists then
    I.HearthstoneData = I.HearthstoneData_Mists
    I.InterruptSpellMap = I.InterruptSpellMap_Empty
  end

  if self.IsVanilla then
    I.HearthstoneData = I.HearthstoneData_Vanilla
    I.InterruptSpellMap = I.InterruptSpellMap_Empty
  end

  -- Lets go!
  self:InitializeModules()

  -- Register Plugin
  EP:RegisterPlugin(self.AddOnName, function()
    return self:GetModule("Options"):OptionsCallback()
  end)

  -- Monitor ElvUI Profile updated
  E.data.RegisterCallback(self, "OnProfileChanged", "UpdateProfiles")
  E.data.RegisterCallback(self, "OnProfileCopied", "UpdateProfiles")
  E.data.RegisterCallback(self, "OnProfileReset", "UpdateProfiles")
end

EP:HookInitialize(TXUI, TXUI.Initialize)
