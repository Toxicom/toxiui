local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")
local M = TXUI:GetModule("Misc")

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
          .. " best suited for 1440p resolution. \n\nIt is designed to be used along with "
          .. F.String.Luxthos("Luxthos")
          .. " WeakAuras.\n\n",
      },

      -- Status Report BUTTON
      ["generalStatusReport"] = {
        order = self:GetOrder(),
        type = "execute",
        name = F.String.Class("Status Report", "MONK"),
        desc = "Open the " .. TXUI.Title .. " Status Report window that shows necessary information for debugging. Post this when reporting bugs!",
        func = function()
          E:ToggleOptions()
          M:StatusReportShow()
        end,
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
          .. F.String.ToxiUI("Open Installer")
          .. " button below.\n\n",
      },

      -- Install BUTTON
      ["generalInstallButton"] = {
        order = self:GetOrder(),
        type = "execute",
        name = F.String.ToxiUI("Open Installer"),
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
  credits = credits .. F.String.ToxiUI("Legendary Supporter\n\n")

  if next(I.Data.Contributor[I.Enum.ContributorType.LEGENDARY]) ~= nil then
    -- The table has entries
    for name, _ in pairs(I.Data.Contributor[I.Enum.ContributorType.LEGENDARY]) do
      addToCredits(I.Enum.Colors.LEGENDARY, name)
    end
  else
    -- The table is empty
    addToCredits("ffffff", "No " .. F.String.Legendary("Legendary") .. " Supporters at the moment :(")
  end

  credits = credits .. F.String.ToxiUI("\n\nEpic Supporter\n\n")

  if next(I.Data.Contributor[I.Enum.ContributorType.EPIC]) ~= nil then
    -- The table has entries
    for name, _ in pairs(I.Data.Contributor[I.Enum.ContributorType.EPIC]) do
      addToCredits(I.Enum.Colors.EPIC, name)
    end
  else
    -- The table is empty
    addToCredits("ffffff", "No " .. F.String.Epic("Epic") .. " Supporters at the moment :(")
  end

  credits = credits .. F.String.ToxiUI("\n\nRare Supporter\n\n")

  if next(I.Data.Contributor[I.Enum.ContributorType.RARE]) ~= nil then
    -- The table has entries
    for name, _ in pairs(I.Data.Contributor[I.Enum.ContributorType.RARE]) do
      addToCredits(I.Enum.Colors.RARE, name)
    end
  else
    -- The table is empty
    addToCredits("ffffff", "No " .. F.String.Rare("Rare") .. " Supporters at the moment :(")
  end

  credits = credits .. F.String.ToxiUI("\n\nBeta Testers\n\n")

  for name, _ in pairs(I.Data.Contributor[I.Enum.ContributorType.BETA]) do
    addToCredits(I.Enum.Colors.BETA, name)
  end

  credits = credits .. F.String.ToxiUI("\n\nOthers\n\n")

  -- Add to credit
  addToCredits("f2d705", "Hekili")
  addToCredits("a96dad", "Rhapsody")
  addToCredits("0070de", "Jake")
  addToCredits("e6cc80", "Ryada")
  addToCredits("ff7c0a", "Releaf")
  addToCredits("e64337", "Redtuzk & his crew")
  addToCredits("5cfa4b", "Darth Predator & Repooc")
  addToCredits("cc0e00", "Gennoken")
  addToCredits("ffffff", F.String.ElvUI() .. " discord")
  addToCredits("ffffff", F.String.Eltreum())
  addToCredits("4beb2c", "Luckyone")

  local creditsGroup = self:AddInlineDesc(options, {
    name = "Credits",
  }, {
    name = "Special thanks goes to these " .. F.String.ToxiUI("amazing people") .. " for their help or inspiration!" .. F.String.Error(" <3\n\n"),
  }).args

  creditsGroup.credits = {
    order = self:GetOrder(),
    type = "description",
    name = credits,
  }
end

O:AddCallback("General")
