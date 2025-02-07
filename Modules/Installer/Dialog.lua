local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local IS = TXUI:GetModule("Installer")
local PF = TXUI:GetModule("Profiles")

local _G = _G

function IS:HideAnnoyances()
  -- if an elvui installation is up, hide it
  local ElvUIInstallFrame = _G["ElvUIInstallFrame"]
  if ElvUIInstallFrame and ElvUIInstallFrame:IsShown() then ElvUIInstallFrame:Hide() end

  -- Hide PLATER addon compatible popup
  E:StaticPopup_Hide("INCOMPATIBLE_ADDON")
  E:StaticPopup_Hide("DISABLE_INCOMPATIBLE_ADDON")
  E:StaticPopup_Hide("SCRIPT_PROFILE")
end

local Pages = {
  Welcome = 1,
  Profile = 2,
  Core = 3,
  Details = 4,
  Plater = 5,
  BigWigs = 6,
  WeakAuras = 7,
  Additional = 8,
  Complete = 9,
}

local function SetupAnimations(obj, duration)
  obj.FadeIn = obj.FadeIn or TXUI:CreateAnimationGroup(obj)

  obj.FadeIn.ResetFade = obj.FadeIn.ResetFade or obj.FadeIn:CreateAnimation("Fade")
  obj.FadeIn.ResetFade:SetDuration(0)
  obj.FadeIn.ResetFade:SetChange(0)
  obj.FadeIn.ResetFade:SetOrder(1)

  obj.FadeIn.Fade = obj.FadeIn.Fade or obj.FadeIn:CreateAnimation("Fade")
  obj.FadeIn.Fade:SetDuration(duration)
  obj.FadeIn.Fade:SetEasing("out-quadratic")
  obj.FadeIn.Fade:SetChange(1)
  obj.FadeIn.Fade:SetOrder(2)

  obj.FadeOut = obj.FadeOut or TXUI:CreateAnimationGroup(obj)

  obj.FadeOut.ResetFade = obj.FadeOut.ResetFade or obj.FadeOut:CreateAnimation("Fade")
  obj.FadeOut.ResetFade:SetDuration(0)
  obj.FadeOut.ResetFade:SetChange(1)
  obj.FadeOut.ResetFade:SetOrder(1)

  obj.FadeOut.Fade = obj.FadeOut.Fade or obj.FadeOut:CreateAnimation("Fade")
  obj.FadeOut.Fade:SetDuration(duration)
  obj.FadeOut.Fade:SetEasing("out-quadratic")
  obj.FadeOut.Fade:SetChange(0)
  obj.FadeOut.Fade:SetOrder(2)
end

-- Installer Dialog Table
function IS:Dialog()
  local installer = E:GetModule("PluginInstaller")
  local installFrame = _G["PluginInstallFrame"]

  if not installFrame.background then installFrame.background = installFrame:CreateTexture("ToxiUIInstallerBackground") end

  installFrame.background:SetAllPoints(installFrame)

  SetupAnimations(installFrame.background, 0.5)

  local installerElements = { "Title", "SubTitle", "Desc1", "Desc2", "Desc3", "tutorialImage" }
  for _, element in ipairs(installerElements) do
    SetupAnimations(installFrame[element], 0.3)
  end

  local function AddImageScripts(imageList, customIndex)
    for index, image in ipairs(imageList) do
      if image == "skip" then
        TXUI:LogDebug("Skipping image script")
      else
        if customIndex then index = customIndex end

        installFrame["Option" .. index]:SetScript("OnEnter", function()
          if installFrame.background.FadeOut:IsPlaying() then installFrame.background.FadeOut:Stop() end
          installFrame.background.FadeIn:Play()
          installFrame.background:SetTexture(image)

          for _, element in ipairs(installerElements) do
            if installFrame[element].FadeIn:IsPlaying() then installFrame[element].FadeIn:Stop() end
            installFrame[element].FadeOut:Play()
            installFrame[element].FadeOut:SetScript("OnFinished", function()
              installFrame[element]:Hide()
            end)
          end
        end)

        installFrame["Option" .. index]:SetScript("OnLeave", function()
          if installFrame.background.FadeIn:IsPlaying() then installFrame.background.FadeIn:Stop() end
          installFrame.background.FadeOut:Play()
          installFrame.background.FadeOut:SetScript("OnFinished", function()
            installFrame.background:SetTexture(nil)
          end)

          for _, element in ipairs(installerElements) do
            if installFrame[element].FadeOut:IsPlaying() then installFrame[element].FadeOut:Stop() end
            installFrame[element]:Show()
            installFrame[element].FadeIn:Play()
          end
        end)
      end
    end
  end

  local function SetupCustomInstaller(page)
    -- Increase size of installer frame
    installFrame:Size(1024, 512)

    -- Reset scripts on each page
    installFrame.Option1:SetScript("OnEnter", nil)
    installFrame.Option2:SetScript("OnEnter", nil)
    installFrame.Option3:SetScript("OnEnter", nil)
    installFrame.Option1:SetScript("OnLeave", nil)
    installFrame.Option2:SetScript("OnLeave", nil)
    installFrame.Option3:SetScript("OnLeave", nil)

    -- Custom handling for each page
    if page == Pages.Welcome then
      AddImageScripts { "skip", "skip", I.Media.Installer.DiscordBanner }
    elseif page == Pages.Core then
      AddImageScripts { I.Media.Installer.Vertical, I.Media.Installer.Horizontal }
    elseif page == Pages.Details then
      AddImageScripts { I.Media.Installer.DetailsOne, I.Media.Installer.DetailsTwo }
    elseif page == Pages.Plater then
      AddImageScripts { I.Media.Installer.Plater }
    elseif page == Pages.BigWigs then
      AddImageScripts { I.Media.Installer.BigWigs }
    elseif page == Pages.WeakAuras then
      AddImageScripts { I.Media.Installer.WeakAuras, I.Media.Installer.WAGuide }
    elseif page == Pages.Complete then
      AddImageScripts { "skip", I.Media.Installer.DiscordBanner, I.Media.Installer.WebPreview }
    end

    -- Center description
    installFrame.Desc1:ClearAllPoints()
    installFrame.Desc1:Point("TOP", 0, -75)

    -- Reposition tutorial image
    installFrame.tutorialImage:ClearAllPoints()
    installFrame.tutorialImage:Point("BOTTOM", 0, 100)
  end

  -- force complete otherwise setup doesn't show
  E.private.install_complete = E.version

  -- return our Installer
  return {
    Title = TXUI.Title .. " 安装",
    Name = TXUI.Title,
    tutorialImage = I.Media.Logos.Logo,
    Pages = {
      -- Welcome Page or Shared Media warning
      [Pages.Welcome] = function()
        self.installerOpen = true
        self:HideAnnoyances()
        SetupCustomInstaller(Pages.Welcome)

        -- Custom close frame handler
        installFrame:SetScript("OnHide", function()
          if self.reloadRequired or F.IsTXUIProfile() then
            IS:Complete(not self.reloadRequired)
          else
            installer:CloseInstall()
          end

          self.installerOpen = false
        end)

        if F.IsAddOnEnabled("SharedMedia_ToxiUI") then
          installFrame.SubTitle:SetText(F.String.Warning("警告!"))

          installFrame.Desc1:SetText("哎呀，看起来你安装了 " .. F.String.ToxiUI("SharedMedia: ToxiUI") .. "!")
          installFrame.Desc2:SetText("请禁用 " .. F.String.ToxiUI("SharedMedia: ToxiUI") .. " 并重置安装过程!")
          installFrame.Desc3:SetText("如果你不禁用 " .. F.String.ToxiUI("SharedMedia: ToxiUI") .. " 会导致问题!")

          installFrame.Next:Disable()
        else
          installFrame.SubTitle:SetText(F.String.ToxiUI("欢迎") .. " 使用 " .. TXUI.Title .. " 安装程序")
          installFrame.Desc1:SetText(
            "这个安装过程将引导你完成几个步骤并应用 "
              .. TXUI.Title
              .. " 配置文件。\n\n请按 '"
              .. F.String.Class("安装", "ROGUE")
              .. "' 按钮开始安装过程。"
          )
          installFrame.Desc2:SetText(
            F.String.Error("重要: ")
              .. "大多数主要的 "
              .. TXUI.Title
              .. " 更新将需要你重新运行安装过程，这意味着你很可能会丢失你的更改。请根据需要进行备份!"
          )
          installFrame.Desc3:SetText(
            F.String.ToxiUI("信息: ") .. "如果你有任何问题，请加入我们的 " .. TXUI.Title .. F.String.ToxiUI(" Discord") .. " 服务器! 我们很乐意帮助你!"
          )

          installFrame.Option1:Show()
          installFrame.Option1:SetText("安装")
          installFrame.Option1:SetScript("OnClick", function()
            installFrame.Next:Click()
          end)
          installFrame.Option2:Show()
          installFrame.Option2:SetText("跳过过程")
          installFrame.Option2:SetScript("OnClick", function()
            installFrame:Hide()
          end)
          installFrame.Option3:Show()
          installFrame.Option3:SetText("Discord")
          installFrame.Option3:SetScript("OnClick", function()
            self:PopupDiscordLink()
          end)
        end
      end,

      -- Profile Page
      [Pages.Profile] = function()
        SetupCustomInstaller(Pages.Profile)
        installFrame.SubTitle:SetText(F.String.ToxiUI("配置文件"))

        installFrame.Desc1:SetText("你可以为 " .. TXUI.Title .. " 创建一个新配置文件，或者覆盖你当前的配置文件。我们建议创建一个新的!")
        installFrame.Desc2:SetText("重要性: " .. F.String.ToxiUI("中等"))

        installFrame.Option1:Show()
        installFrame.Option1:SetText("创建新的")
        installFrame.Option1:SetScript("OnClick", function()
          self:ElvUIProfileDialog()
        end)

        if E.db.layoutSet ~= nil then
          installFrame.Desc3:SetText(F.String.Warning("不支持旧的 ElvUI 布局! 请使用下面的按钮创建一个新配置文件"))
          installFrame.Next:Disable()
        else
          installFrame.Desc3:SetText("你当前激活的配置文件是: " .. F.String.ToxiUI(E.data:GetCurrentProfile()))
          installFrame.Next:Enable()

          -- We want to show this only when it's valid
          installFrame.Option2:Show()
          installFrame.Option2:SetText("使用当前")
          installFrame.Option2:SetScript("OnClick", function()
            installFrame.Next:Click()
          end)
        end
      end,

      -- Layout Page
      [Pages.Core] = function()
        SetupCustomInstaller(Pages.Core)
        installFrame.SubTitle:SetText(F.String.ToxiUI("核心设置"))

        installFrame.Desc1:SetText(
          "这将安装 "
            .. TXUI.Title
            .. " 取决于你想要一个 "
            .. F.String.ToxiUI("垂直")
            .. " 或 "
            .. F.String.Class("水平", "MONK")
            .. " 布局。这也将启用 ToxiUI 的核心功能。"
        )
        installFrame.Desc2:SetText(F.String.Error("重要: ") .. F.String.Warning("跳过这一步将导致未完成和破损的 UI!"))
        installFrame.Desc3:SetText(
          F.String.Error("极其重要: ")
            .. "应用我们的 "
            .. TXUI.Title
            .. " 配置文件将像大多数其他 UI 插件一样，"
            .. F.String.Error("覆盖")
            .. " 你现有的配置文件! 你之前所做的任何更改很可能会 "
            .. F.String.Error("丢失!")
            .. " 如果你担心丢失当前配置文件，请进行备份并谨慎操作! 你已被警告。"
        )

        local function installElvUI(layout)
          if TXUI.PreventProfileUpdates then return end
          TXUI.PreventProfileUpdates = true

          E.db.TXUI.installer.layout = layout

          TXUI:GetModule("SplashScreen"):Wrap("正在安装 ...", function()
            self.reloadRequired = true

            self:ElvUI(function()
              installer:SetPage(Pages.Core + 1)
            end)
          end, true)
        end

        installFrame.Option1:Show()
        installFrame.Option1:SetText(F.String.ToxiUI("垂直"))
        installFrame.Option1:SetScript("OnClick", function()
          installElvUI(I.Enum.Layouts.VERTICAL)
        end)

        installFrame.Option2:Show()
        installFrame.Option2:SetText(F.String.Class("水平", "MONK"))
        installFrame.Option2:SetScript("OnClick", function()
          installElvUI(I.Enum.Layouts.HORIZONTAL)
        end)
      end,

      -- Details Page
      [Pages.Details] = function()
        SetupCustomInstaller(Pages.Details)
        installFrame.SubTitle:SetText(F.String.ToxiUI("Details"))

        if F.IsAddOnEnabled("Details") then
          installFrame.Desc1:SetText("Details 是一个多功能插件，提供广泛的数据，包括伤害、治疗和各种其他性能指标。")
          installFrame.Desc2:SetText("这是一个可选的插件要求，但我们强烈建议你安装它。")
          installFrame.Desc3:SetText("重要性: " .. F.String.Error("高"))

          installFrame.Option1:Show()
          installFrame.Option1:SetText("一个窗口")
          installFrame.Option1:SetScript("OnClick", function()
            PF:Details(false)
            self.reloadRequired = true
            self:ShowStepComplete(F.String.ToxiUI("Details") .. " 配置文件已安装。")
            installFrame.Next:Click()
          end)

          installFrame.Option2:Show()
          installFrame.Option2:SetText("两个窗口")
          installFrame.Option2:SetScript("OnClick", function()
            PF:Details(true)
            self.reloadRequired = true
            self:ShowStepComplete(F.String.ToxiUI("Details") .. " 配置文件已安装。")
            installFrame.Next:Click()
          end)
        else
          installFrame.Desc1:SetText(F.String.Warning("哎呀，看起来你没有安装 Details!"))
          installFrame.Desc2:SetText("请安装 Details 并重新启动安装程序!")
        end
      end,

      -- Plater Page
      [Pages.Plater] = function()
        SetupCustomInstaller(Pages.Plater)
        installFrame.SubTitle:SetText(F.String.ToxiUI("Plater"))

        if F.IsAddOnEnabled("Plater") then
          installFrame.Desc1:SetText(
            "Plater 是一个名条插件，具有大量设置，开箱即用的减益追踪，威胁着色，支持类似 WeakAuras 和 wago.io 的脚本，以及 WeakAuras-Companion 用于 Mod/Script/配置文件更新。"
          )
          installFrame.Desc2:SetText("这是一个可选的插件要求，但我们强烈建议你安装它。")
          installFrame.Desc3:SetText("重要性: " .. F.String.Error("高"))

          installFrame.Option1:Show()
          installFrame.Option1:SetText("Plater")
          installFrame.Option1:SetScript("OnClick", function()
            PF:Plater()
            self.reloadRequired = true
            self:ShowStepComplete(F.String.ToxiUI("Plater") .. " 配置文件已安装。")
            installFrame.Next:Click()
          end)
        else
          installFrame.Desc1:SetText(F.String.Warning("哎呀，看起来你没有安装 Plater!"))
          installFrame.Desc2:SetText("请安装 Plater 并重新启动安装程序!")
        end
      end,

      -- Boss Mod Page
      [Pages.BigWigs] = function()
        SetupCustomInstaller(Pages.BigWigs)
        if F.IsAddOnEnabled("BigWigs") then
          installFrame.SubTitle:SetText(F.String.ToxiUI("BigWigs"))

          installFrame.Desc1:SetText(
            "BigWigs 是一个首领战插件。它由许多单独的战斗脚本或首领模块组成；迷你插件，旨在为一个特定的团队战斗触发警报消息、计时条、声音等。"
          )
          installFrame.Desc2:SetText("重要性: " .. F.String.Good("低"))

          installFrame.Option1:Show()
          installFrame.Option1:SetText("BigWigs")
          installFrame.Option1:SetScript("OnClick", function()
            PF:BigWigs()
            self:ShowStepComplete(F.String.ToxiUI("BigWigs") .. " 配置文件已安装。")
            installFrame.Next:Click()
          end)
        elseif F.IsAddOnEnabled("DBM-Core") then
          installFrame.SubTitle:SetText(F.String.ToxiUI("Deadly Boss Mods"))

          installFrame.Desc1:SetText(F.String.Error("重要: ") .. "Deadly Boss Mods 不再支持。我们建议迁移到 " .. F.String.ToxiUI("BigWigs") .. ".")

          installFrame.Option1:Show()
          installFrame.Option1:SetText("跳过这一步")
          installFrame.Option1:SetScript("OnClick", function()
            installFrame.Next:Click()
          end)
        else
          installFrame.SubTitle:SetText(F.String.ToxiUI("BigWigs"))

          installFrame.Desc1:SetText(F.String.Warning("哎呀，看起来你没有安装 " .. F.String.ToxiUI("BigWigs") .. "!"))
          installFrame.Desc2:SetText("如果你是新玩家，我们建议安装 " .. F.String.ToxiUI("BigWigs") .. "!")
        end
      end,

      -- WeakAuras recommendations
      [Pages.WeakAuras] = function()
        SetupCustomInstaller(Pages.WeakAuras)
        installFrame.SubTitle:SetText(F.String.ToxiUI("WeakAuras"))

        if F.IsAddOnEnabled("WeakAuras") then
          installFrame.Desc1:SetText("这将为你提供安装重要 WeakAuras 的链接")
          installFrame.Desc2:SetText(
            F.String.Luxthos("Luxthos") .. " 有每个职业和专精组合的 WeakAuras 包，使它们非常通用且易于使用! 它们对新玩家也非常有帮助!"
          )
          installFrame.Option1:Show()
          installFrame.Option1:SetText(F.String.Luxthos("Luxthos") .. " WA")
          installFrame.Option1:SetScript("OnClick", function()
            self:PopupWALink()
          end)
        else
          installFrame.Desc1:SetText(F.String.Warning("哎呀，看起来你没有安装 WeakAuras!|r"))
          installFrame.Desc2:SetText("为了获得完整体验，我们强烈建议安装 WeakAuras!")
        end

        installFrame.Desc3:SetText(
          F.String.Warning("重要: ")
            .. "请注意，图像中的 "
            .. F.String.Luxthos("Luxthos WeakAuras")
            .. " 是定制的! 开箱即用，它们看起来会略有不同。访问 "
            .. F.String.ToxiUI(I.Strings.Branding.Links.WAGuide)
            .. " 了解如何实现类似的外观。"
        )

        -- If WeakAuras is disabled, show ToxiUI WA Guide as Option 1
        local buttonIndex = F.IsAddOnEnabled("WeakAuras") and 2 or 1

        installFrame["Option" .. buttonIndex]:Show()
        installFrame["Option" .. buttonIndex]:SetText(TXUI.Title .. " 指南")

        installFrame["Option" .. buttonIndex]:SetScript("OnClick", function()
          self:PopupWAGuide()
        end)
      end,

      [Pages.Additional] = function()
        SetupCustomInstaller(Pages.Additional)

        -- Initialize the button index
        local buttonIndex = 1

        -- Helper function to set the position of the button based on availability
        local function InstallOptionalAddOn(addonName, buttonText)
          local button = installFrame["Option" .. buttonIndex]
          if F.IsAddOnEnabled(addonName) then
            button:Show()
            button:SetText(buttonText or addonName)
            button:SetScript("OnClick", function()
              PF["Apply" .. addonName .. "Profile"]()
              self:ShowStepComplete(F.String.ToxiUI(addonName) .. " 配置文件已安装。")
            end)
            AddImageScripts({ I.Media.Installer[addonName] }, buttonIndex)
            buttonIndex = buttonIndex + 1
          end
        end

        installFrame.SubTitle:SetText(F.String.ToxiUI("额外插件"))

        installFrame.Desc1:SetText(TXUI.Title .. " 提供常用插件的额外配置文件。")
        installFrame.Desc2:SetText("当前支持的插件: " .. F.String.OmniCD() .. ", " .. F.String.WarpDeplete())

        if not F.IsAddOnEnabled("OmniCD") and not F.IsAddOnEnabled("WarpDeplete") then
          installFrame.Desc3:SetText(F.String.Warning("警告: ") .. "看起来你没有安装任何额外插件。别担心，你仍然可以完全体验 " .. TXUI.Title .. "!")
        end

        if F.IsAddOnEnabled("OmniCD") then
          installFrame.Desc3:SetText(
            F.String.Warning("警告: ")
              .. F.String.OmniCD()
              .. " 只有地下城配置文件设置好了! 团队配置文件是默认的，你可能需要在进入团队之前调整它! 如果你有配置文件的建议，请在 "
              .. TXUI.Title
              .. " Discord 上联系我们!"
          )
        end

        InstallOptionalAddOn("OmniCD", F.String.OmniCD())
        InstallOptionalAddOn("WarpDeplete", F.String.WarpDeplete())
      end,

      -- Completed Page
      [Pages.Complete] = function()
        SetupCustomInstaller(Pages.Complete)
        installFrame.SubTitle:SetText(F.String.ToxiUI("安装完成"))

        installFrame.Desc1:SetText(F.String.Good("你已完成安装过程!"))
        installFrame.Desc2:SetText(
          "请点击下面的按钮以完成过程并自动重新加载你的 UI。\n\n"
            .. "如果你有任何问题，请加入 "
            .. F.String.ToxiUI("Discord")
            .. " 获取支持!"
        )
        installFrame.Desc3:SetText(
          F.String.Error("重要: ")
            .. TXUI.Title
            .. " 有很多设置用于自定义。完成安装后，请打开 "
            .. TXUI.Title
            .. " 设置并探索它们! 我们保证你会发现你不知道自己在寻找的东西!\n\n"
            .. "要打开 "
            .. TXUI.Title
            .. " 设置，按 ESC，你会看到 "
            .. TXUI.Title
            .. " 按钮!"
        )

        installFrame.Option1:Show()
        installFrame.Option1:SetText("完成")
        installFrame.Option1:SetScript("OnClick", function()
          installFrame:Hide()
        end)

        installFrame.Option2:Show()
        installFrame.Option2:SetText("Discord")
        installFrame.Option2:SetScript("OnClick", function()
          self:PopupDiscordLink()
        end)

        installFrame.Option3:Show()
        installFrame.Option3:SetText(TXUI.Title .. " 网站")
        installFrame.Option3:SetScript("OnClick", function()
          self:PopupWebsiteLink()
        end)
      end,
    },

    -- Installation Steps
    StepTitles = {
      [Pages.Welcome] = "欢迎 -  " .. Pages.Welcome,
      [Pages.Profile] = "配置文件 - " .. Pages.Profile,
      [Pages.Core] = "核心设置 - " .. Pages.Core,
      [Pages.Details] = "Details - " .. Pages.Details,
      [Pages.Plater] = "Plater - " .. Pages.Plater,
      [Pages.BigWigs] = "BigWigs - " .. Pages.BigWigs,
      [Pages.WeakAuras] = "WeakAuras - " .. Pages.WeakAuras,
      [Pages.Additional] = "额外插件 - " .. Pages.Additional,
      [Pages.Complete] = "完成 - " .. Pages.Complete,
    },

    -- Customize colors
    StepTitlesColor = { 1, 1, 1 },
    StepTitlesColorSelected = I.Strings.Branding.ColorRGB,
    StepTitleWidth = 200,
    StepTitleButtonWidth = 200,
    StepTitleTextJustification = "RIGHT",
  }
end
