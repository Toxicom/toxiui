local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
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

      -- Layout Page
      [3] = function()
        installFrame.SubTitle:SetText(F.String.ToxiUI("Core Settings"))

        installFrame.Desc1:SetText(
          "This will install " .. TXUI.Title .. " depending if you want a " .. F.String.ToxiUI("DPS/Tank") .. " or " .. F.String.Class("Healer", "MONK") .. " layout."
        )
        installFrame.Desc2:SetText("This will also enable core functions of ToxiUI.")
        installFrame.Desc3:SetText(F.String.Error("Important: ") .. F.String.Warning("Skipping this will result in an unfinished and broken UI!"))

        local function installElvUI(layout)
          if TXUI.PreventProfileUpdates then return end
          TXUI.PreventProfileUpdates = true

          E.db.TXUI.installer.layout = layout
          TXUI:GetModule("SplashScreen"):Wrap("Installing ...", function()
            self.reloadRequired = true

            self:ElvUI(function()
              installer:SetPage(4)
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
      [4] = function()
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
      [5] = function()
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
      [6] = function()
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
      [7] = function()
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
      end,

      -- Completed Page
      [8] = function()
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
      end,
    },

    -- Installation Steps
    StepTitles = {
      [1] = "Welcome",
      [2] = "Profile",
      [3] = "Core Settings",
      [4] = "Details",
      [5] = "Plater",
      [6] = "BigWigs",
      [7] = "WeakAuras",
      [8] = "Installation Complete",
    },

    -- Customize colors
    StepTitlesColor = { 1, 1, 1 },
    StepTitlesColorSelected = I.Strings.Branding.ColorRGB,
    StepTitleWidth = 200,
    StepTitleButtonWidth = 180,
    StepTitleTextJustification = "RIGHT",
  }
end
