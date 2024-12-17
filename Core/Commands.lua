local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

local pairs = pairs
local tonumber, lower, wipe, next = tonumber, strlower, wipe, next

local ReloadUI = ReloadUI

local DisableAddOn = (C_AddOns and C_AddOns.DisableAddOn) or DisableAddOn
local EnableAddOn = (C_AddOns and C_AddOns.EnableAddOn) or EnableAddOn
local GetAddOnInfo = (C_AddOns and C_AddOns.GetAddOnInfo) or GetAddOnInfo
local GetNumAddOns = (C_AddOns and C_AddOns.GetNumAddOns) or GetNumAddOns

function TXUI:HandleDevProfiles(arg1)
  -- Command help
  local printUsage = function()
    self:LogInfo("Usage: /tx profile dps; healer; private; bw; dbm; plater; details")
  end

  -- If no parameter was given
  if not arg1 then
    printUsage()
    return
  end

  -- Set layout if not set
  E.db.TXUI.installer.layout = E.db.TXUI.installer.layout or I.Enum.Layouts.VERTICAL

  if arg1 == "dps" then
    E.db.TXUI.installer.layout = I.Enum.Layouts.VERTICAL
    self:LogInfo("Applying " .. F.String.ElvUI("ElvUI") .. " Vertical Profile ...")
    TXUI:GetModule("Installer"):ElvUI()
  elseif arg1 == "healer" then
    E.db.TXUI.installer.layout = I.Enum.Layouts.HORIZONTAL
    self:LogInfo("Applying " .. F.String.ElvUI("ElvUI") .. " Horizontal Profile ...")
    TXUI:GetModule("Installer"):ElvUI()
  elseif arg1 == "private" then
    self:LogInfo("Applying all Privates ...")
    TXUI:GetModule("Installer"):Privates()
  elseif arg1 == "details" then
    self:LogInfo("Applying Details Profile ...")
    TXUI:GetModule("Profiles"):Details()
  elseif arg1 == "plater" then
    self:LogInfo("Applying Plater Profile ...")
    TXUI:GetModule("Profiles"):Plater()
  elseif arg1 == "bw" then
    self:LogInfo("Applying BigWigs Profile ...")
    TXUI:GetModule("Profiles"):BigWigs()
  elseif arg1 == "font" then
    self:LogInfo("Applying Fonts Profile ...")
    E:UpdateDB()
    TXUI:GetModule("Profiles"):ElvUIFont()
    TXUI:GetModule("Profiles"):ElvUIFontPrivates()
    E:StaggeredUpdateAll()
  else -- if wrong parameter given
    printUsage()
  end
end

function TXUI:HandleDevExports(arg1)
  -- Command help
  local printUsage = function()
    self:LogInfo("Usage: /tx dev export names")
  end

  if not arg1 then -- Command Usage
    printUsage()
  elseif arg1 == "names" then -- Names import
    TXUI:ExportProfile("import_names")
  else
    printUsage()
  end
end

function TXUI:HandleDevCommand(category, arg1)
  -- Command help
  local printUsage = function()
    self:LogInfo("Usage: /tx dev profile; reset; cvar; chat; export; wb <arg1>")
  end

  if not category then
    printUsage()
  elseif category == "profile" then
    self:HandleDevProfiles(arg1)
  elseif category == "dpi" then
    self:LogInfo("DPI: " .. F.Dpi(tonumber(arg1) or 0))
  elseif category == "cvar" then
    self:LogInfo("Applying all CVars ...")
    TXUI:GetModule("Profiles"):ElvUICVars()
  elseif category == "chat" then
    self:LogInfo("Resetting chat & applying new chat Profile ...")
    TXUI:GetModule("Profiles"):ElvUIChat()
    E:StaggeredUpdateAll()
  elseif (category == "export") and F.IsDeveloper() then
    self:HandleDevExports(arg1)
  elseif (category == "splash") and F.IsDeveloper() then
    TXUI:GetModule("SplashScreen"):Wrap("Installing ...", function()
      self:LogInfo("Showing splash screen for 15 seconds ...")
    end, true)
  elseif category == "wb" then
    self:LogInfo("Activating WunderBar Debug Mode, ReloadUI to disable ...")
    TXUI:GetModule("WunderBar"):EnableDebugMode()
  elseif category == "toggle" then
    E.db.TXUI.general.overrideDevMode = not E.db.TXUI.general.overrideDevMode
    ReloadUI()
  else
    printUsage()
  end
end

function TXUI:HandleBadgeCommand()
  if not F.GetContributorEntryName() then return end

  if not F.IsTXUIProfile() then
    self:LogInfo("You are not using a " .. TXUI.Title .. " Profile")
    return
  end

  E.db.TXUI.general.chatBadgeOverride = not E.db.TXUI.general.chatBadgeOverride

  self:LogInfo("Chat badges " .. (E.db.TXUI.general.chatBadgeOverride and F.String.Error("deactivated") or F.String.Good("activated")) .. ".")
end

function TXUI:ShowStatusReport()
  if not F.IsTXUIProfile() then
    self:LogInfo("You are not using a " .. TXUI.Title .. " Profile")
    return
  end

  self:GetModule("Misc"):StatusReportShow()
end

local AddOns = {
  -- ElvUI
  ElvUI = true,
  ElvUI_Options = true,
  ElvUI_Libraries = true,

  -- ToxiUI
  ElvUI_ToxiUI = true,

  -- Other AddOns
  Details = true,
  BugSack = true,
  ["!BugGrabber"] = true,

  -- Dev Addons
  DevTool = true,
}

local function LogDebugInfo()
  TXUI:LogInfo("/tx debug on - /tx debug off")
end

-- Modified version of ElvUI's E:LuaError()
function TXUI:DebugMode(msg)
  if msg then
    local switch = lower(msg)
    local db = E.db.TXUI

    if switch == "on" or switch == "1" then
      for i = 1, GetNumAddOns() do
        local name = GetAddOnInfo(i)
        if not AddOns[name] and F.IsAddOnEnabled(name) then
          DisableAddOn(name, E.myname)
          db.disabledAddOns[name] = i
        end
      end

      E:SetCVar("scriptErrors", 1)
      ReloadUI()
    elseif switch == "off" or switch == "0" then
      if switch == "off" then
        E:SetCVar("scriptProfile", 0)
        E:SetCVar("scriptErrors", 0)
        TXUI:LogInfo("Lua errors off.")

        if F.IsAddOnEnabled("ElvUI_CPU") then DisableAddOn("ElvUI_CPU") end
      end

      if next(db.disabledAddOns) then
        for name in pairs(db.disabledAddOns) do
          EnableAddOn(name, E.myname)
        end

        wipe(db.disabledAddOns)
        ReloadUI()
      end
    else
      LogDebugInfo()
    end
  else
    LogDebugInfo()
  end
end

function TXUI:HandleChatCommand(msg)
  -- Parse category
  local category = self:GetArgs(msg)

  if not category then
    E:ToggleOptions("TXUI")
  elseif category == "changelog" or category == "cl" then
    E:ToggleOptions("TXUI,changelog")
  elseif category == "settings" then
    E:ToggleOptions("TXUI")
  elseif category == "badge" then
    self:HandleBadgeCommand()
  elseif category == "export" then
    local arg1 = self:GetArgs(msg, 6, 7)
    if arg1 == "names" then
      self:LogInfo("Exporting Names ...")
      TXUI:ExportProfile("names")
    end
  elseif category == "wb" or category == "wunderbar" then
    E:ToggleOptions("TXUI,wunderbar")
  elseif (category == "dev") and TXUI.DevRelease then
    self:HandleDevCommand(self:GetArgs(msg, 3, 4))
  elseif (category == "reset") and F.IsTXUIProfile() then
    E:StaticPopup_Show("TXUI_RESET_TXUI_PROFILE")
  elseif (category == "status" or category == "info") and F.IsTXUIProfile() then
    self:ShowStatusReport()
  elseif category == "install" or category == "i" then
    E:GetModule("PluginInstaller"):Queue(TXUI:GetModule("Installer"):Dialog())
  elseif category == "debug" then
    self:DebugMode(self:GetArgs(msg, 5, 6))
  elseif F.IsTXUIProfile() then
    self:LogInfo("Usage: /tx cl; changelog; install; i; settings; status; wb; debug")
  else
    self:LogInfo("You are not using a " .. TXUI.Title .. " profile. Please install " .. TXUI.Title .. " first.")
    self:LogInfo("Usage: /tx cl; changelog; install; i; settings")
  end
end

function TXUI:LoadCommands()
  self:RegisterChatCommand("tx", "HandleChatCommand")
  self:RegisterChatCommand("txui", "HandleChatCommand")
  self:RegisterChatCommand("toxi", "HandleChatCommand")
  self:RegisterChatCommand("toxiui", "HandleChatCommand")
end
