local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

local YES, NO = YES, NO

function TXUI:LoadStaticPopups()
  E.PopupDialogs.TXUI_RESET_TXUI_PROFILE = {
    text = "Are you sure you want to reset "
      .. TXUI.Title
      .. "?\n\nThis will reset all settings from "
      .. TXUI.Title
      .. ", but "
      .. F.String.Error("NOT")
      .. " your "
      .. F.String.ElvUI("ElvUI")
      .. " Profile!",
    button1 = F.String.Error(YES),
    button2 = F.String.Good(NO),
    hideOnEscape = 1,
    whileDead = 1,
    OnAccept = function()
      F.ResetTXUIProfile()
    end,
  }

  E.PopupDialogs.TXUI_RESET_MODULE_PROFILE = {
    text = "Are you sure you want to reset " .. F.String.Error("%s") .. "?",
    button1 = F.String.Error(YES),
    button2 = F.String.Good(NO),
    hideOnEscape = 1,
    whileDead = 1,
    OnAccept = function(_, profile)
      F.ResetModuleProfile(profile)
    end,
  }

  E.PopupDialogs.TXUI_RESET_MISC_PROFILE = {
    text = "Are you sure you want to reset " .. F.String.Error("%s") .. "?",
    button1 = F.String.Error(YES),
    button2 = F.String.Good(NO),
    hideOnEscape = 1,
    whileDead = 1,
    OnAccept = function(_, profile)
      F.ResetMiscProfile(profile)
    end,
  }

  E.PopupDialogs.TXUI_DELETE_PLAYED_CHARACTER = {
    text = "Are you sure you want to remove " .. F.String.Error("%s") .. " from the played time data?\n\nThis " .. F.String.Error("cannot") .. " be undone.",
    button1 = F.String.Error(YES),
    button2 = F.String.Good(NO),
    hideOnEscape = 1,
    whileDead = 1,
    OnAccept = function(_, data)
      if not data or not E.global.TXUI then return end
      local realm, name = data.realm, data.name
      if not realm or not name then return end
      if E.global.TXUI.playedSeconds and E.global.TXUI.playedSeconds[realm] then E.global.TXUI.playedSeconds[realm][name] = nil end
      if E.global.TXUI.classMap and E.global.TXUI.classMap[realm] then E.global.TXUI.classMap[realm][name] = nil end
      if E.global.TXUI.sessionStartEpoch and E.global.TXUI.sessionStartEpoch[realm] then E.global.TXUI.sessionStartEpoch[realm][name] = nil end
      E.Libs.AceConfigRegistry:NotifyChange("ElvUI")
    end,
  }
end
