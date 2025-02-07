local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

local YES, NO = YES, NO

function TXUI:LoadStaticPopups()
  E.PopupDialogs.TXUI_RESET_TXUI_PROFILE = {
    text = "你确定要重置 "
      .. TXUI.Title
      .. "吗？\n\n这将重置所有来自 "
      .. TXUI.Title
      .. " 的设置，但 "
      .. F.String.Error("不会")
      .. " 重置你的 "
      .. F.String.ElvUI("ElvUI")
      .. " 配置文件！",
    button1 = F.String.Error(YES),
    button2 = F.String.Good(NO),
    hideOnEscape = 1,
    whileDead = 1,
    OnAccept = function()
      F.ResetTXUIProfile()
    end,
  }

  E.PopupDialogs.TXUI_RESET_MODULE_PROFILE = {
    text = "你确定要重置 " .. F.String.Error("%s") .. " 吗？",
    button1 = F.String.Error(YES),
    button2 = F.String.Good(NO),
    hideOnEscape = 1,
    whileDead = 1,
    OnAccept = function(_, profile)
      F.ResetModuleProfile(profile)
    end,
  }

  E.PopupDialogs.TXUI_RESET_MISC_PROFILE = {
    text = "你确定要重置 " .. F.String.Error("%s") .. " 吗？",
    button1 = F.String.Error(YES),
    button2 = F.String.Good(NO),
    hideOnEscape = 1,
    whileDead = 1,
    OnAccept = function(_, profile)
      F.ResetMiscProfile(profile)
    end,
  }
end
