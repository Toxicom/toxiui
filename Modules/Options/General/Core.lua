local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")
local M = TXUI:GetModule("Misc")

function O:General()
  -- Reset order for new page
  self:ResetOrder()

  local pageOptions = self.options.general.args

  -- Welcome Description
  pageOptions["generalWelcome"] = {
    order = self:GetOrder(),
    inline = true,
    type = "group",
    name = "Description",
    args = {
      ["generalWelcomeDesc"] = {
        order = self:GetOrder(),
        type = "description",
        name = TXUI.Title .. " is a minimalistic " .. F.String.ElvUI("ElvUI") .. " edit by " .. F.String.Authors() .. " best suited for 1440p resolution.\n\n",
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
  self:AddSpacer(pageOptions)

  -- Installation guide
  pageOptions["generalInstall"] = {
    order = self:GetOrder(),
    inline = true,
    type = "group",
    name = "Installation guide",
    args = {
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

      -- Spacer
      ["generalInstallSpacer"] = {
        order = self:GetOrder(),
        type = "description",
        name = " ",
        width = 0.1,
      },

      -- Update BUTTON
      ["generalUpdateButton"] = {
        order = self:GetOrder(),
        type = "execute",
        name = F.String.Good("Profile Updater"),
        desc = "Selectively update specific profile sections without running the full installer.",
        hidden = function()
          return not F.IsTXUIProfile() or not E.db.TXUI.installer.layout
        end,
        func = function()
          TXUI:GetModule("ProfileUpdater"):Toggle()
          E:ToggleOptions()
        end,
      },
    },
  }

  -- Spacer
  self:AddSpacer(pageOptions)

  -- ==================
  -- Credits Tab
  -- ==================
  local creditsTab = self:AddGroup(pageOptions, { name = "Credits" }).args

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
    for name, _ in pairs(I.Data.Contributor[I.Enum.ContributorType.LEGENDARY]) do
      addToCredits(I.Enum.Colors.LEGENDARY, name)
    end
  else
    addToCredits("ffffff", "No " .. F.String.Legendary("Legendary") .. " Supporters at the moment :(")
  end

  credits = credits .. F.String.ToxiUI("\n\nEpic Supporter\n\n")

  if next(I.Data.Contributor[I.Enum.ContributorType.EPIC]) ~= nil then
    for name, _ in pairs(I.Data.Contributor[I.Enum.ContributorType.EPIC]) do
      addToCredits(I.Enum.Colors.EPIC, name)
    end
  else
    addToCredits("ffffff", "No " .. F.String.Epic("Epic") .. " Supporters at the moment :(")
  end

  credits = credits .. F.String.ToxiUI("\n\nRare Supporter\n\n")

  if next(I.Data.Contributor[I.Enum.ContributorType.RARE]) ~= nil then
    for name, _ in pairs(I.Data.Contributor[I.Enum.ContributorType.RARE]) do
      addToCredits(I.Enum.Colors.RARE, name)
    end
  else
    addToCredits("ffffff", "No " .. F.String.Rare("Rare") .. " Supporters at the moment :(")
  end

  credits = credits .. F.String.ToxiUI("\n\nBeta Testers\n\n")

  for name, _ in pairs(I.Data.Contributor[I.Enum.ContributorType.BETA]) do
    addToCredits(I.Enum.Colors.BETA, name)
  end

  credits = credits .. F.String.ToxiUI("\n\nOthers\n\n")

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

  local creditSection = self:AddInlineDesc(creditsTab, {
    name = "Credits",
  }, {
    name = "Special thanks goes to these " .. F.String.ToxiUI("amazing people") .. " for their help or inspiration!" .. F.String.Error(" <3\n\n"),
  }).args

  creditSection.credits = {
    order = self:GetOrder(),
    type = "description",
    name = credits,
  }

  -- ==================
  -- Commands Tab
  -- ==================
  local commandsTab = self:AddGroup(pageOptions, { name = "Commands " .. E.NewSign }).args

  local function cmd(slash, desc, shortcut)
    local line = F.String.ToxiUI(slash) .. " — " .. desc
    if shortcut then line = line .. " " .. F.String.Silver("(shortcut: " .. shortcut .. ")") end
    return line .. "\n"
  end

  local aliasText = F.String.ToxiUI("/tx")
    .. ", "
    .. F.String.ToxiUI("/toxi")
    .. ", "
    .. F.String.ToxiUI("/txui")
    .. " and "
    .. F.String.ToxiUI("/toxiui")
    .. " all do the same thing — use whichever you prefer.\n\n"

  self:AddInlineDesc(commandsTab, { name = "General" }, {
    name = aliasText .. cmd("/tx", "Open " .. TXUI.Title .. " settings") .. cmd("/tx changelog", "Open the changelog", "/tx cl") .. cmd(
      "/tx install",
      "Run the installer",
      "/tx i"
    ) .. cmd("/tx update", "Open the Profile Updater", "/tx u") .. cmd("/tx status", "Open the Status Report", "/tx info") .. cmd(
      "/tx wb",
      "Open WunderBar settings",
      "/tx wunderbar"
    ) .. cmd("/tx badge", "Toggle chat badge visibility") .. cmd("/tx reset", "Reset the " .. TXUI.Title .. " profile") .. cmd("/tx debug", "Toggle debug mode (on / off)"),
  })

  if TXUI.IsRetail then
    self:AddInlineDesc(commandsTab, { name = "Retail" }, {
      name = cmd("/cd", "Open Cooldown Manager settings", "/cdm, /wa") .. cmd("/em", "Open Edit Mode"),
    })
  end
end

O:AddCallback("General")
