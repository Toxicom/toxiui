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
      AddImageScripts { I.Media.Installer.PlaterNew, I.Media.Installer.PlaterOld }
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
    Title = TXUI.Title .. " Installation",
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
          installFrame.SubTitle:SetText(F.String.Warning("WARNING!"))

          installFrame.Desc1:SetText("Oops, looks like you have " .. F.String.ToxiUI("SharedMedia: ToxiUI") .. " installed!")
          installFrame.Desc2:SetText("Please disable " .. F.String.ToxiUI("SharedMedia: ToxiUI") .. " and reset the installation process!")
          installFrame.Desc3:SetText("If you don't disable " .. F.String.ToxiUI("SharedMedia: ToxiUI") .. " it will cause problems!")

          installFrame.Next:Disable()
        else
          installFrame.SubTitle:SetText(F.String.ToxiUI("Welcome") .. " to the installation for " .. TXUI.Title)
          installFrame.Desc1:SetText(
            "This installation process will guide you through a few steps and apply the "
              .. TXUI.Title
              .. " profile.\n\nPlease press the '"
              .. F.String.Class("Install", "ROGUE")
              .. "' button to begin the installation process."
          )
          installFrame.Desc2:SetText(
            F.String.Error("Important: ")
              .. "Most of the major "
              .. TXUI.Title
              .. " updates will require you to run the installation process again, meaning you will most likely lose your changes. Please make backups if necessary!"
          )
          installFrame.Desc3:SetText(
            F.String.ToxiUI("Information: ")
              .. "If you're having any issues at all, please join our "
              .. TXUI.Title
              .. F.String.ToxiUI(" Discord")
              .. " server! We will be happy to help you!"
          )

          installFrame.Option1:Show()
          installFrame.Option1:SetText("Install")
          installFrame.Option1:SetScript("OnClick", function()
            installFrame.Next:Click()
          end)
          installFrame.Option2:Show()
          installFrame.Option2:SetText("Skip Process")
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
        installFrame.SubTitle:SetText(F.String.ToxiUI("Profile"))

        installFrame.Desc1:SetText("You can either create a new profile for " .. TXUI.Title .. " or you can overwrite your current profile. We recommend creating a new one!")
        installFrame.Desc2:SetText("Importance: " .. F.String.ToxiUI("Medium"))

        installFrame.Option1:Show()
        installFrame.Option1:SetText("Create New")
        installFrame.Option1:SetScript("OnClick", function()
          self:ElvUIProfileDialog()
        end)

        if E.db.layoutSet ~= nil then
          installFrame.Desc3:SetText(F.String.Warning("Old ElvUI Layouts are not supported! Please create a new profile with the button below"))
          installFrame.Next:Disable()
        else
          installFrame.Desc3:SetText("Your currently active profile is: " .. F.String.ToxiUI(E.data:GetCurrentProfile()))
          installFrame.Next:Enable()

          -- We want to show this only when it's valid
          installFrame.Option2:Show()
          installFrame.Option2:SetText("Use current")
          installFrame.Option2:SetScript("OnClick", function()
            installFrame.Next:Click()
          end)
        end
      end,

      -- Layout Page
      [Pages.Core] = function()
        SetupCustomInstaller(Pages.Core)
        installFrame.SubTitle:SetText(F.String.ToxiUI("Core Settings"))

        installFrame.Desc1:SetText(
          "This will install "
            .. TXUI.Title
            .. " depending if you want a "
            .. F.String.ToxiUI("Vertical")
            .. " or "
            .. F.String.Class("Horizontal", "MONK")
            .. " layout. This will also enable core functions of ToxiUI."
        )
        installFrame.Desc2:SetText(F.String.Error("Important: ") .. F.String.Warning("Skipping this will result in an unfinished and broken UI!"))
        installFrame.Desc3:SetText(
          F.String.Error("Extremely important: ")
            .. "Applying our "
            .. TXUI.Title
            .. " profiles will, like in the majority of other UI plugins, "
            .. F.String.Error("overwrite")
            .. " your existing profile! Any previous changes you have made will most likely "
            .. F.String.Error("be lost!")
            .. " Please make backups if you're afraid to lose your current profile and proceed with caution! You have been warned."
        )

        local function installElvUI(layout)
          if TXUI.PreventProfileUpdates then return end
          TXUI.PreventProfileUpdates = true

          E.db.TXUI.installer.layout = layout

          TXUI:GetModule("SplashScreen"):Wrap("Installing ...", function()
            self.reloadRequired = true

            self:ElvUI(function()
              installer:SetPage(Pages.Core + 1)
            end)
          end, true)
        end

        installFrame.Option1:Show()
        installFrame.Option1:SetText(F.String.ToxiUI("Vertical"))
        installFrame.Option1:SetScript("OnClick", function()
          installElvUI(I.Enum.Layouts.VERTICAL)
        end)

        installFrame.Option2:Show()
        installFrame.Option2:SetText(F.String.Class("Horizontal", "MONK"))
        installFrame.Option2:SetScript("OnClick", function()
          installElvUI(I.Enum.Layouts.HORIZONTAL)
        end)
      end,

      -- Details Page
      [Pages.Details] = function()
        SetupCustomInstaller(Pages.Details)
        installFrame.SubTitle:SetText(F.String.ToxiUI("Details"))

        if F.IsAddOnEnabled("Details") then
          installFrame.Desc1:SetText(
            "Details is a versatile AddOn that offers a wide array of data, encompassing metrics for damage, healing, and various other performance indicators."
          )
          installFrame.Desc2:SetText("This is an optional AddOn requirement, but we highly recommend you install it.")
          installFrame.Desc3:SetText("Importance: " .. F.String.Error("High"))

          installFrame.Option1:Show()
          installFrame.Option1:SetText("One Window")
          installFrame.Option1:SetScript("OnClick", function()
            PF:Details(false)
            self.reloadRequired = true
            self:ShowStepComplete(F.String.ToxiUI("Details") .. " profile installed.")
            installFrame.Next:Click()
          end)

          installFrame.Option2:Show()
          installFrame.Option2:SetText("Two Windows")
          installFrame.Option2:SetScript("OnClick", function()
            PF:Details(true)
            self.reloadRequired = true
            self:ShowStepComplete(F.String.ToxiUI("Details") .. " profile installed.")
            installFrame.Next:Click()
          end)
        else
          installFrame.Desc1:SetText(F.String.Warning("Oops, looks like you don't have Details installed!"))
          installFrame.Desc2:SetText("Please install Details and restart the installer!")
        end
      end,

      -- Plater Page
      [Pages.Plater] = function()
        SetupCustomInstaller(Pages.Plater)
        installFrame.SubTitle:SetText(F.String.ToxiUI("Plater"))

        if F.IsAddOnEnabled("Plater") then
          installFrame.Desc1:SetText(
            "Plater is a nameplate addon with a extraordinary amount of settings, out of the box debuff tracking, threat coloring, support for scripting similar to WeakAuras and wago.io + the WeakAuras-Companion for Mod/Script/Profile updates."
          )
          installFrame.Desc2:SetText(
            F.String.Warning("Note: ")
              .. "The "
              .. F.String.Error("[OUTDATED]")
              .. " profile is from before "
              .. TXUI.Title
              .. " 6.9.0 and it will never be updated again. Use it with your own caution."
          )
          installFrame.Desc3:SetText("Importance: " .. F.String.Error("High"))

          installFrame.Option1:Show()
          installFrame.Option1:SetText("Plater")
          installFrame.Option1:SetScript("OnClick", function()
            PF:Plater("new")
            self.reloadRequired = true
            self:ShowStepComplete(F.String.ToxiUI("Plater") .. " profile installed.")
            installFrame.Next:Click()
          end)

          installFrame.Option2:Show()
          installFrame.Option2:SetText("Plater" .. F.String.Error(" [OUTDATED]"))
          installFrame.Option2:SetWidth(installFrame.Option2:GetWidth() * 1.5)
          installFrame.Option2:SetScript("OnClick", function()
            PF:Plater("old")
            self.reloadRequired = true
            self:ShowStepComplete(F.String.ToxiUI("Plater") .. F.String.Error(" [OUTDATED]") .. " profile installed.")
            installFrame.Next:Click()
          end)
        else
          installFrame.Desc1:SetText(F.String.Warning("Oops, looks like you don't have Plater installed!"))
          installFrame.Desc2:SetText("Please install Plater and restart the installer!")
        end
      end,

      -- Boss Mod Page
      [Pages.BigWigs] = function()
        SetupCustomInstaller(Pages.BigWigs)
        if F.IsAddOnEnabled("BigWigs") then
          installFrame.SubTitle:SetText(F.String.ToxiUI("BigWigs"))

          installFrame.Desc1:SetText(
            "BigWigs is a boss encounter AddOn. It consists of many individual encounter scripts, or boss modules; mini AddOns that are designed to trigger alert messages, timer bars, sounds, and so forth, for one specific raid encounter."
          )
          installFrame.Desc2:SetText("Importance: " .. F.String.Good("Low"))

          installFrame.Option1:Show()
          installFrame.Option1:SetText("BigWigs")
          installFrame.Option1:SetScript("OnClick", function()
            PF:BigWigs()
            self:ShowStepComplete(F.String.ToxiUI("BigWigs") .. " profile installed.")
            installFrame.Next:Click()
          end)
        elseif F.IsAddOnEnabled("DBM-Core") then
          installFrame.SubTitle:SetText(F.String.ToxiUI("Deadly Boss Mods"))

          installFrame.Desc1:SetText(F.String.Error("Important: ") .. "Deadly Boss Mods is no longer supported. We recommend migrating to " .. F.String.ToxiUI("BigWigs") .. ".")

          installFrame.Option1:Show()
          installFrame.Option1:SetText("Skip this step")
          installFrame.Option1:SetScript("OnClick", function()
            installFrame.Next:Click()
          end)
        else
          installFrame.SubTitle:SetText(F.String.ToxiUI("BigWigs"))

          installFrame.Desc1:SetText(F.String.Warning("Oops, looks like you don't have " .. F.String.ToxiUI("BigWigs") .. " installed!"))
          installFrame.Desc2:SetText("If you're a new player, we recommend installing " .. F.String.ToxiUI("BigWigs") .. "!")
        end
      end,

      -- WeakAuras recommendations
      [Pages.WeakAuras] = function()
        SetupCustomInstaller(Pages.WeakAuras)
        installFrame.SubTitle:SetText(F.String.ToxiUI("WeakAuras"))

        if F.IsAddOnEnabled("WeakAuras") then
          installFrame.Desc1:SetText("This will give you links to install important WeakAuras")
          installFrame.Desc2:SetText(
            F.String.Luxthos("Luxthos")
              .. " has WeakAuras packages for every single class and specialization combination making them very versatile and easy to use! They are also very helpful for new players!"
          )
          installFrame.Option1:Show()
          installFrame.Option1:SetText(F.String.Luxthos("Luxthos") .. " WA")
          installFrame.Option1:SetScript("OnClick", function()
            self:PopupWALink()
          end)
        else
          installFrame.Desc1:SetText(F.String.Warning("Oops, looks like you don't have WeakAuras installed!|r"))
          installFrame.Desc2:SetText("For full experience, we highly recommend having WeakAuras!")
        end

        installFrame.Desc3:SetText(
          F.String.Warning("Important: ")
            .. "Please note that the "
            .. F.String.Luxthos("Luxthos WeakAuras")
            .. " in the image are customised! Out of the box, they will look slightly different. Visit "
            .. F.String.ToxiUI(I.Strings.Branding.Links.WAGuide)
            .. " to find out how you can achieve a similar look."
        )

        -- If WeakAuras is disabled, show ToxiUI WA Guide as Option 1
        local buttonIndex = F.IsAddOnEnabled("WeakAuras") and 2 or 1

        installFrame["Option" .. buttonIndex]:Show()
        installFrame["Option" .. buttonIndex]:SetText(TXUI.Title .. " Guide")

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
              self:ShowStepComplete(F.String.ToxiUI(addonName) .. " profile installed.")
            end)
            AddImageScripts({ I.Media.Installer[addonName] }, buttonIndex)
            buttonIndex = buttonIndex + 1
          end
        end

        installFrame.SubTitle:SetText(F.String.ToxiUI("Additional AddOns"))

        installFrame.Desc1:SetText(TXUI.Title .. " offers extra profiles for commonly used AddOns.")
        installFrame.Desc2:SetText("Currently supported AddOns: " .. F.String.OmniCD() .. ", " .. F.String.WarpDeplete())

        if not F.IsAddOnEnabled("OmniCD") and not F.IsAddOnEnabled("WarpDeplete") then
          installFrame.Desc3:SetText(
            F.String.Warning("Warning: ") .. "Looks like you don't have any of the extra AddOns installed. Don't worry, you can still fully experience " .. TXUI.Title .. "!"
          )
        end

        if F.IsAddOnEnabled("OmniCD") then
          installFrame.Desc3:SetText(
            F.String.Warning("Warning: ")
              .. F.String.OmniCD()
              .. " has only the dungeons profile set up! Raid profile is default, you might wanna tweak it before going to a raid! If you have suggestions for a profile, please contact us on the "
              .. TXUI.Title
              .. " Discord!"
          )
        end

        InstallOptionalAddOn("OmniCD", F.String.OmniCD())
        InstallOptionalAddOn("WarpDeplete", F.String.WarpDeplete())
      end,

      -- Completed Page
      [Pages.Complete] = function()
        SetupCustomInstaller(Pages.Complete)
        installFrame.SubTitle:SetText(F.String.ToxiUI("Installation Complete"))

        installFrame.Desc1:SetText(F.String.Good("You have completed the installation process!"))
        installFrame.Desc2:SetText(
          "Please click the button below in order to finalize the process and automatically reload your UI.\n\n"
            .. "If you have any questions/issues please join "
            .. F.String.ToxiUI("Discord")
            .. " for support!"
        )
        installFrame.Desc3:SetText(
          F.String.Error("Important: ")
            .. TXUI.Title
            .. " has a lot of settings for customisations. After you're done with the installation, please open the "
            .. TXUI.Title
            .. " settings and explore them! We guarantee you will find things you didn't know you were looking for!\n\n"
            .. "To open "
            .. TXUI.Title
            .. " settings, hit ESC and you will see the "
            .. TXUI.Title
            .. " button there!"
        )

        installFrame.Option1:Show()
        installFrame.Option1:SetText("Finish")
        installFrame.Option1:SetScript("OnClick", function()
          installFrame:Hide()
        end)

        installFrame.Option2:Show()
        installFrame.Option2:SetText("Discord")
        installFrame.Option2:SetScript("OnClick", function()
          self:PopupDiscordLink()
        end)

        installFrame.Option3:Show()
        installFrame.Option3:SetText(TXUI.Title .. " Web")
        installFrame.Option3:SetScript("OnClick", function()
          self:PopupWebsiteLink()
        end)
      end,
    },

    -- Installation Steps
    StepTitles = {
      [Pages.Welcome] = "Welcome -  " .. Pages.Welcome,
      [Pages.Profile] = "Profile - " .. Pages.Profile,
      [Pages.Core] = "Core Settings - " .. Pages.Core,
      [Pages.Details] = "Details - " .. Pages.Details,
      [Pages.Plater] = "Plater - " .. Pages.Plater,
      [Pages.BigWigs] = "BigWigs - " .. Pages.BigWigs,
      [Pages.WeakAuras] = "WeakAuras - " .. Pages.WeakAuras,
      [Pages.Additional] = "Add. AddOns - " .. Pages.Additional,
      [Pages.Complete] = "Complete - " .. Pages.Complete,
    },

    -- Customize colors
    StepTitlesColor = { 1, 1, 1 },
    StepTitlesColorSelected = I.Strings.Branding.ColorRGB,
    StepTitleWidth = 200,
    StepTitleButtonWidth = 200,
    StepTitleTextJustification = "RIGHT",
  }
end
