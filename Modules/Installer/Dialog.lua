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

-- Installer Dialog Table
function IS:Dialog()
  local installer = E:GetModule("PluginInstaller")
  local installFrame = _G["PluginInstallFrame"]

  local function SetupCustomInstaller(pageNumber)
    -- Increase size of installer frame
    installFrame:Size(825, 600)

    -- Custom tutorial image
    if pageNumber == 3 then
      installFrame.tutorialImage:SetTexture(I.Media.Installer.Layouts)
      installFrame.tutorialImage:Size(512, 256)
    elseif pageNumber == 5 then
      installFrame.tutorialImage:SetTexture(I.Media.Installer.Details)
      installFrame.tutorialImage:Size(512, 256)
    elseif pageNumber == 6 then
      installFrame.tutorialImage:SetTexture(I.Media.Installer.Plater)
      installFrame.tutorialImage:Size(512, 256)
    elseif pageNumber == 7 then
      installFrame.tutorialImage:SetTexture(I.Media.Installer.BigWigs)
      installFrame.tutorialImage:Size(512, 256)
    elseif pageNumber == 8 then
      installFrame.tutorialImage:SetTexture(I.Media.Installer.WeakAuras)
      installFrame.tutorialImage:Size(512, 256)
    elseif pageNumber == 9 then
      installFrame.tutorialImage:SetTexture(I.Media.Installer.WarpDeplete)
      installFrame.tutorialImage:Size(512, 256)
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

  -- force complete otherwise setup dosen't show
  E.private.install_complete = E.version

  -- return our Installer
  return {
    Title = TXUI.Title .. " Installation",
    Name = TXUI.Title,
    tutorialImage = I.Media.Logos.Logo,
    Pages = {
      -- Welcome Page or Shared Media warning
      [1] = function()
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

          installFrame.Desc1:SetText("This installation process will guide you through a few steps and apply the " .. TXUI.Title .. " profile.")
          installFrame.Desc2:SetText("Please press the " .. F.String.Class("'Install'", "ROGUE") .. " button to begin the installation process.")
          installFrame.Desc3:SetText(F.String.Warning("You will need to do this every time ToxiUI is updated."))

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
        end
      end,

      -- Profile Page
      [2] = function()
        SetupCustomInstaller()
        installFrame.SubTitle:SetText(F.String.ToxiUI("Profile"))

        installFrame.Desc1:SetText("You can either create a new profile for " .. TXUI.Title .. " or you can use your current profile")
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

      -- Style Selection Page
      [3] = function()
        SetupCustomInstaller(3)
        installFrame.SubTitle:SetText(F.String.ToxiUI("Style Selection"))

        installFrame.Desc1:SetText(
          "From "
            .. TXUI.Title
            .. " v6.3.0, we now offer a different style for UnitFrames! We know how some of you prefer to keep the old look and feel of "
            .. TXUI.Title
            .. " therefore we offer you a choice!"
        )
        installFrame.Desc2:SetText("Below you can see an image of the differences between the styles.")
        installFrame.Desc3:SetText(
          F.String.ToxiUI("Information: ")
            .. "This step is "
            .. F.String.Good("optional")
            .. ". If you do not select a style, the old one will be applied by default! This might change in the future."
        )

        local function applyStyle(style)
          E.db.TXUI.installer.layoutStyle = style
          local styleName = style == I.Enum.LayoutStyle.OLD and "Old" or "New"
          self:ShowStepComplete(F.String.ToxiUI(styleName) .. " UnitFrame style")
          installer:SetPage(4)
        end

        installFrame.Option1:Show()
        installFrame.Option1:SetText("Old style")
        installFrame.Option1:SetScript("OnClick", function()
          applyStyle(I.Enum.LayoutStyle.OLD)
        end)

        installFrame.Option2:Show()
        installFrame.Option2:SetText("New style")
        installFrame.Option2:SetScript("OnClick", function()
          applyStyle(I.Enum.LayoutStyle.NEW)
        end)
      end,

      -- Layout Page
      [4] = function()
        SetupCustomInstaller()
        installFrame.SubTitle:SetText(F.String.ToxiUI("Core Settings"))

        installFrame.Desc1:SetText(
          "This will install "
            .. TXUI.Title
            .. " depending if you want a "
            .. F.String.ToxiUI("DPS/Tank")
            .. " or "
            .. F.String.Class("Healer", "MONK")
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
              installer:SetPage(5)
            end)
          end, true)
        end

        installFrame.Option1:Show()
        installFrame.Option1:SetText(F.String.ToxiUI("DPS/Tank"))
        installFrame.Option1:SetScript("OnClick", function()
          installElvUI(I.Enum.Layouts.DPS)
        end)

        installFrame.Option2:Show()
        installFrame.Option2:SetText(F.String.Class("Healer", "MONK"))
        installFrame.Option2:SetScript("OnClick", function()
          installElvUI(I.Enum.Layouts.HEALER)
        end)
      end,

      -- Details Page
      [5] = function()
        SetupCustomInstaller(5)
        installFrame.SubTitle:SetText(F.String.ToxiUI("Details"))

        if F.IsAddOnEnabled("Details") then
          installFrame.Desc1:SetText("This will import Details profile.")
          installFrame.Desc2:SetText("Importance: " .. F.String.Error("High"))
          installFrame.Desc3:SetText("Details is an AddOn that displays information like damage & healing meters.")

          installFrame.Option1:Show()
          installFrame.Option1:SetText("Details")
          installFrame.Option1:SetScript("OnClick", function()
            PF:Details()
            self.reloadRequired = true
            self:ShowStepComplete("'Details' profile")
            installFrame.Next:Click()
          end)
        else
          installFrame.Desc1:SetText(F.String.Warning("Oops, looks like you don't have Details installed!"))
          installFrame.Desc2:SetText("Please install Details and restart the installer!")
        end
      end,

      -- Plater Page
      [6] = function()
        SetupCustomInstaller(6)
        installFrame.SubTitle:SetText(F.String.ToxiUI("Plater"))

        if F.IsAddOnEnabled("Plater") then
          installFrame.Desc1:SetText("This will import Plater profile.")
          installFrame.Desc2:SetText("Importance: " .. F.String.Error("High"))
          installFrame.Desc3:SetText("Plater is an AddOn responsible for Nameplates - the Health bars above your enemies.")

          installFrame.Option1:Show()
          installFrame.Option1:SetText("Plater")
          installFrame.Option1:SetScript("OnClick", function()
            PF:Plater()
            self.reloadRequired = true
            self:ShowStepComplete("'Plater' profile")
            installFrame.Next:Click()
          end)
        else
          installFrame.Desc1:SetText(F.String.Warning("Oops, looks like you don't have Plater installed!"))
          installFrame.Desc2:SetText("Please install Plater and restart the installer!")
        end
      end,

      -- Boss Mod Page
      [7] = function()
        SetupCustomInstaller(7)
        if F.IsAddOnEnabled("BigWigs") then
          installFrame.SubTitle:SetText(F.String.ToxiUI("BigWigs"))

          installFrame.Desc1:SetText("This will import BigWigs profile.")
          installFrame.Desc2:SetText(F.String.Warning("Currently supported resolutions: 2560x1440, 3440x1440, 1920x1080. For other resolutions, open a pull request on GitHub."))
          installFrame.Desc3:SetText("Importance: " .. F.String.Good("Low"))

          installFrame.Option1:Show()
          installFrame.Option1:SetText("BigWigs")
          installFrame.Option1:SetScript("OnClick", function()
            PF:MergeBigWigsProfile()
            self:ShowStepComplete("'BigWigs' profile")
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
      [8] = function()
        SetupCustomInstaller(8)
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

        installFrame.Option2:Show()
        installFrame.Option2:SetText(TXUI.Title .. " Guide")

        installFrame.Option2:SetScript("OnClick", function()
          self:PopupWAGuide()
        end)
      end,

      [9] = function()
        SetupCustomInstaller(9)
        installFrame.SubTitle:SetText(F.String.ToxiUI("Additional AddOns"))

        installFrame.Desc1:SetText(TXUI.Title .. " offers extra profiles for commonly used AddOns.")
        installFrame.Desc2:SetText("Currently supported AddOns: " .. F.String.ToxiUI("WarpDeplete") .. ", " .. F.String.ToxiUI("OmniCD"))

        if not F.IsAddOnEnabled("WarpDeplete") then
          installFrame.Desc3:SetText(
            F.String.Warning("Warning: ") .. "Looks like you don't have any of the extra AddOns installed. Don't worry, you can still fully experience " .. TXUI.Title .. "!"
          )
        end

        if F.IsAddOnEnabled("WarpDeplete") then
          installFrame.Option1:Show()
          installFrame.Option1:SetText("WarpDeplete")
          installFrame.Option1:SetScript("OnClick", function()
            PF:ApplyWarpDepleteProfile()
            self:ShowStepComplete("'WarpDeplete' profile")
            self.reloadRequired = true
          end)
        end

        if F.IsAddOnEnabled("OmniCD") then
          installFrame.Option2:Show()
          installFrame.Option2:SetText("OmniCD")
          installFrame.Option2:SetScript("OnClick", function()
            PF:ApplyOmniCDProfile()
            self:ShowStepComplete("'OmniCD' profile")
            self.reloadRequired = true
          end)
        end
      end,

      -- Completed Page
      [10] = function()
        SetupCustomInstaller()
        installFrame.SubTitle:SetText(F.String.ToxiUI("Installation Complete"))

        installFrame.Desc1:SetText(F.String.Good("You have completed the installation process!"))
        installFrame.Desc2:SetText("Please click the button below in order to finalize the process and automatically reload your UI.")
        installFrame.Desc3:SetText("If you have any questions/issues please join " .. F.String.ToxiUI("Discord") .. " for support!")

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
      [1] = "Welcome",
      [2] = "Profile",
      [3] = "Style Selection",
      [4] = "Core Settings",
      [5] = "Details",
      [6] = "Plater",
      [7] = "BigWigs",
      [8] = "WeakAuras",
      [9] = "Additional AddOns",
      [10] = "Installation Complete",
    },

    -- Customize colors
    StepTitlesColor = { 1, 1, 1 },
    StepTitlesColorSelected = I.Strings.Branding.ColorRGB,
    StepTitleWidth = 200,
    StepTitleButtonWidth = 180,
    StepTitleTextJustification = "RIGHT",
  }
end
