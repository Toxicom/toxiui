local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

local ReloadUI = ReloadUI
local tonumber = tonumber

function TXUI:HandleDevProfiles(arg1)
  -- Command help
  local printUsage = function()
    self:LogInfo("Usage: /tx profile dps||healer||private||bw||dbm||plater||details")
  end

  -- If no parameter was given
  if not arg1 then
    printUsage()
    return
  end

  -- Set layout if not set
  E.db.TXUI.installer.layout = E.db.TXUI.installer.layout or I.Enum.Layouts.DPS

  if arg1 == "dps" then
    E.db.TXUI.installer.layout = I.Enum.Layouts.DPS
    self:LogInfo("Applying " .. F.String.ElvUI("ElvUI") .. " DPS Profile ...")
    TXUI:GetModule("Installer"):ElvUI()
  elseif arg1 == "healer" then
    E.db.TXUI.installer.layout = I.Enum.Layouts.HEALER
    self:LogInfo("Applying " .. F.String.ElvUI("ElvUI") .. " Healer Profile ...")
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
    TXUI:GetModule("Profiles"):MergeBigWigsProfile()
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

function TXUI:HandleDevExports(arg1, arg2)
  -- Command help
  local printUsage = function()
    self:LogInfo("Usage: /tx dev export bw||names")
    self:LogInfo("Example: /tx dev export bw healer")
  end

  if not arg1 then -- Command Usage
    printUsage()
  elseif arg1 == "bw" then -- BigWigs export
    if not arg2 then
      printUsage()
    elseif arg2 == "dps" then
      self:LogInfo("Exporting BigWigs DPS Profile ...")
      TXUI:ExportProfile(arg1, I.ProfileNames[I.Enum.Layouts.DPS])
    elseif arg2 == "healer" then
      self:LogInfo("Exporting BigWigs Healer Profile ...")
      TXUI:ExportProfile(arg1, I.ProfileNames[I.Enum.Layouts.HEALER])
    else
      self:LogInfo("Usage: /tx dev export bw dps||healer")
    end
  elseif arg1 == "names" then -- Names import
    TXUI:ExportProfile("import_names")
  else
    printUsage()
  end
end

function TXUI:HandleDevCommand(category, arg1, arg2)
  -- Command help
  local printUsage = function()
    self:LogInfo("Usage: /tx dev profile||reset||cvar||chat||export||wb <arg1> <arg2>")
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
    self:HandleDevExports(arg1, arg2)
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
  elseif (category == "export") and TXUI.DevRelease then
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
  elseif category == "install" then
    E:ToggleOptions("TXUI,general")
  elseif F.IsTXUIProfile() then
    self:LogInfo("Usage: /tx cl||changelog||install||settings||status||wb")
  else
    self:LogInfo("Usage: /tx cl||changelog||install||settings")
  end
end

function TXUI:LoadCommands()
  self:RegisterChatCommand("tx", "HandleChatCommand")
  self:RegisterChatCommand("txui", "HandleChatCommand")
  self:RegisterChatCommand("toxi", "HandleChatCommand")
  self:RegisterChatCommand("toxiui", "HandleChatCommand")

  -- TROLOLOL
  if F.IsTXUIProfile() then
    E:UnregisterChatCommand("estatus")
    self:RegisterChatCommand("estatus", "ShowStatusReport")
  end
end
