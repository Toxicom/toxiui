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

-- Installer Dialog Table
function IS:Dialog()
  local installer = E:GetModule("PluginInstaller")
  local installFrame = _G["PluginInstallFrame"]

  local timer
  local currentImageIndex

  -- Helper function to cycle to the next image in a list
  local function ChangeImage(imageList)
    -- Set the texture to the next image in the list
    installFrame.tutorialImage:SetTexture(imageList[currentImageIndex])
    installFrame.tutorialImage:Size(512, 256)

    -- Increment the current index or loop back to the beginning
    currentImageIndex = currentImageIndex + 1
    if currentImageIndex > #imageList then currentImageIndex = 1 end
  end

  local function SetupCustomInstaller(page)
    -- Stop the timer on each page
    if timer then timer:Cancel() end

    -- Reset current image index to 1 so it starts from beginning each time
    currentImageIndex = 1

    -- Increase size of installer frame
    installFrame:Size(825, 600)

    -- Increase installer scale for first time installations, since the fonts are small
    if not F.IsTXUIProfile() then installFrame:SetScale(1.35) end

    -- Custom tutorial image
    if page == Pages.Core then
      -- List of images to cycle through
      local imageList = {
        I.Media.Installer.Horizontal,
        I.Media.Installer.Vertical,
      }

      -- Set initial texture to last image of the list, since it will start from the first one
      installFrame.tutorialImage:SetTexture(imageList[#imageList])
      installFrame.tutorialImage:Size(512, 256)

      -- Start the timer
      timer = C_Timer.NewTicker(5, function()
        ChangeImage(imageList)
      end)
    elseif page == Pages.Details then
      installFrame.tutorialImage:SetTexture(I.Media.Installer.Details)
      installFrame.tutorialImage:Size(512, 256)
    elseif page == Pages.Plater then
      installFrame.tutorialImage:SetTexture(I.Media.Installer.Plater)
      installFrame.tutorialImage:Size(512, 256)
    elseif page == Pages.BigWigs then
      installFrame.tutorialImage:SetTexture(I.Media.Installer.BigWigs)
      installFrame.tutorialImage:Size(512, 256)
    elseif page == Pages.WeakAuras then
      installFrame.tutorialImage:SetTexture(I.Media.Installer.WeakAuras)
      installFrame.tutorialImage:Size(512, 256)
    elseif page == Pages.Additional then
      local imageList = {}
      local addOns = {
        OmniCD = I.Media.Installer.OmniCD,
        WarpDeplete = I.Media.Installer.WarpDeplete,
      }

      for addOnName, imagePath in pairs(addOns) do
        if F.IsAddOnEnabled(addOnName) then tinsert(imageList, imagePath) end
      end

      if not F.Table.IsEmpty(imageList) then
        -- Set initial texture to last image of the list, since it will start from the first one
        installFrame.tutorialImage:SetTexture(imageList[#imageList])
        installFrame.tutorialImage:Size(512, 256)

        -- Start the timer
        timer = C_Timer.NewTicker(3, function()
          ChangeImage(imageList)
        end)
      end
    else
      -- Reset to defaults
      installFrame.tutorialImage:SetTexture(I.Media.Logos.Logo)
      installFrame.tutorialImage:Size(256, 128)
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
        SetupCustomInstaller()

        -- Custom close frame handler
        installFrame:SetScript("OnHide", function()
          if self.reloadRequired or F.IsTXUIProfile() then
            IS:Complete(not self.reloadRequired)
          else
            installer:CloseInstall()
          end

          if timer then timer:Cancel() end

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
        SetupCustomInstaller()
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
          installElvUI(I.Enum.Layouts.DPS)
        end)

        installFrame.Option2:Show()
        installFrame.Option2:SetText(F.String.Class("Horizontal", "MONK"))
        installFrame.Option2:SetScript("OnClick", function()
          installElvUI(I.Enum.Layouts.HEALER)
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
          installFrame.Desc2:SetText("This is an optional AddOn requirement, but we highly recommend you install it.")
          installFrame.Desc3:SetText("Importance: " .. F.String.Error("High"))

          installFrame.Option1:Show()
          installFrame.Option1:SetText("Plater")
          installFrame.Option1:SetScript("OnClick", function()
            PF:Plater()
            self.reloadRequired = true
            self:ShowStepComplete(F.String.ToxiUI("Plater") .. " profile installed.")
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
          installFrame.Desc2:SetText(
            "Currently supported resolutions: "
              .. F.String.Good("2560x1440")
              .. ", "
              .. F.String.Good("3440x1440")
              .. ", "
              .. F.String.Good("1920x1080")
              .. ". For other resolutions, open a pull request on GitHub."
          )
          installFrame.Desc3:SetText("Importance: " .. F.String.Good("Low"))

          installFrame.Option1:Show()
          installFrame.Option1:SetText("BigWigs")
          installFrame.Option1:SetScript("OnClick", function()
            PF:MergeBigWigsProfile()
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
          if TXUI.IsClassic then
            installFrame.Desc2:SetText(
              "Unfortunately "
                .. F.String.Luxthos("Luxthos")
                .. " does not have Classic Era WeakAuras packages, so below is a link that will take you to the classic era Wago page. We highly recommend using a WeakAuras package with "
                .. F.String.ToxiUI("ToxiUI")
                .. "."
            )
          else
            installFrame.Desc2:SetText(
              F.String.Luxthos("Luxthos")
                .. " has WeakAuras packages for every single class and specialization combination making them very versatile and easy to use! They are also very helpful for new players!"
            )
          end
          installFrame.Option1:Show()
          if TXUI.IsClassic then
            installFrame.Option1:SetText("Wago.io Classic")
          else
            installFrame.Option1:SetText(F.String.Luxthos("Luxthos") .. " WA")
          end
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
            .. F.String.ToxiUI("toxiui.com/wa")
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
        SetupCustomInstaller()
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
      [Pages.Welcome] = "Welcome",
      [Pages.Profile] = "Profile",
      [Pages.Core] = "Core Settings",
      [Pages.Details] = "Details",
      [Pages.Plater] = "Plater",
      [Pages.BigWigs] = "BigWigs",
      [Pages.WeakAuras] = "WeakAuras",
      [Pages.Additional] = "Additional AddOns",
      [Pages.Complete] = "Installation Complete",
    },

    -- Customize colors
    StepTitlesColor = { 1, 1, 1 },
    StepTitlesColorSelected = I.Strings.Branding.ColorRGB,
    StepTitleWidth = 200,
    StepTitleButtonWidth = 180,
    StepTitleTextJustification = "RIGHT",
  }
end
