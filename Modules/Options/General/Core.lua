local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local O = TXUI:GetModule("Options")

function O:General()
  -- Reset order for new page
  self:ResetOrder()

  local options = self.options.general.args

  -- Welcome Description
  options["generalWelcome"] = {
    order = self:GetOrder(),
    inline = true,
    type = "group",
    name = "Description",
    args = {
      ["generalWelcomeDesc"] = {
        order = self:GetOrder(),
        type = "description",
        name = TXUI.Title
          .. " is a minimalistic "
          .. F.String.ElvUI("ElvUI")
          .. " edit by "
          .. F.String.Authors()
          .. " best suited for 1440p resolution. \nIt is designed to be used along with "
          .. F.String.Luxthos("Luxthos")
          .. " WeakAuras.",
      },
    },
  }

  -- Spacer
  self:AddSpacer(options)

  -- Welcome Description
  options["generalInstall"] = {
    order = self:GetOrder(),
    inline = true,
    type = "group",
    name = "Installation guide",
    args = {
      -- Welcome Description
      ["generalInstallDesc"] = {
        order = self:GetOrder(),
        type = "description",
        name = "The installation guide should pop up automatically after you login."
          .. " \nIf you wish to re-run the installation process to update some settings please click the "
          .. F.String.ToxiUI("INSTALL/UPDATE")
          .. " button below.\n\n",
      },

      -- Install BUTTON
      ["generalInstallButton"] = {
        order = self:GetOrder(),
        type = "execute",
        name = F.String.ToxiUI("INSTALL/UPDATE"),
        desc = "Run the installation/update process.",
        func = function()
          E:GetModule("PluginInstaller"):Queue(TXUI:GetModule("Installer"):Dialog())
          E:ToggleOptions()
        end,
      },
    },
  }

  -- Spacer
  self:AddSpacer(options)

  -- Credits
  local credits = ""

  -- Credits helpers
  local addToCredits = function(color, name)
    if type(color) == "string" then
      credits = credits .. "|cff" .. color .. name .. "|r\n"
    else
      credits = credits .. F.String.FastGradientHex(name, I.Strings.Colors[color]) .. "\n"
    end
  end

  -- Add Contributors to credit
  credits = credits .. "Legendary Supporter\n\n"

  for name, _ in pairs(I.Data.Contributor[I.Enum.ContributorType.LEGENDARY]) do
    addToCredits(I.Strings.Colors[I.Enum.Colors.LEGENDARY], name)
  end

  credits = credits .. "\nEpic Supporter\n\n"

  for name, _ in pairs(I.Data.Contributor[I.Enum.ContributorType.EPIC]) do
    addToCredits(I.Enum.Colors.EPIC, name)
  end

  credits = credits .. "\nRare Supporter\n\n"

  for name, _ in pairs(I.Data.Contributor[I.Enum.ContributorType.RARE]) do
    addToCredits(I.Enum.Colors.RARE, name)
  end

  credits = credits .. "\nBeta Testers\n\n"

  for name, _ in pairs(I.Data.Contributor[I.Enum.ContributorType.BETA]) do
    addToCredits(I.Enum.Colors.BETA, name)
  end

  credits = credits .. "\nOthers\n\n"

  -- Add to credit
  addToCredits("f2d705", "Hekili")
  addToCredits("a96dad", "Rhapsody")
  addToCredits("0070de", "Jake")
  addToCredits("ff7c0a", "Releaf")
  addToCredits("e64337", "Redtuzk & his crew")
  addToCredits("5cfa4b", "Darth Predator & Repooc")
  addToCredits("cc0e00", "Gennoken")

  local creditsGroup = self:AddInlineDesc(options, {
    name = "Credits",
  }, {
    name = "Special thanks goes to these amazing people for their help or inspiration.\n\n",
  }).args

  creditsGroup.credits = {
    order = self:GetOrder(),
    type = "description",
    name = credits,
  }
end

O:AddCallback("General")
