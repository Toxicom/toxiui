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
end
