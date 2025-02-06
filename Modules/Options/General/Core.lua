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
    name = "描述",
    args = {
      ["generalWelcomeDesc"] = {
        order = self:GetOrder(),
        type = "description",
        name = TXUI.Title
          .. " 是一个极简主义的 "
          .. F.String.ElvUI("ElvUI")
          .. " 修改版，由 "
          .. F.String.Authors("Toxi")
          .. " 制作，最适合 1440p 分辨率。\n\n它设计用于与 "
          .. F.String.Luxthos("Luxthos")
          .. " WeakAuras 一起使用。\n\n"
          .. "由 "
          .. F.String.ElvUI("乳酸菌")
          .. " 汉化支持。\n\n",
      },

      -- Status Report BUTTON
      -- 状态报告按钮
      ["generalStatusReport"] = {
        order = self:GetOrder(),
        type = "execute",
        name = F.String.Class("状态报告", "MONK"),
        desc = "打开 " .. TXUI.Title .. " 状态报告窗口，显示调试所需的信息。报告错误时请发布此信息！",
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
    name = "安装指南",
    args = {
      -- Welcome Description
      ["generalInstallDesc"] = {
        order = self:GetOrder(),
        type = "description",
        name = "安装指南应在您登录后自动弹出。"
          .. " \n如果您希望重新运行安装过程以更新某些设置，请点击下面的 "
          .. F.String.ToxiUI("打开安装程序")
          .. " 按钮。\n\n",
      },

      -- Install BUTTON
      ["generalInstallButton"] = {
        order = self:GetOrder(),
        type = "execute",
        name = F.String.ToxiUI("打开安装程序"),
        desc = "运行安装/更新过程。",
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
    name = "致谢",
  }, {
    name = "特别感谢这些 " .. F.String.ToxiUI("了不起的人") .. " 他们的帮助或灵感！" .. F.String.Error(" <3\n\n"),
  }).args
  
  creditsGroup.credits = {
    order = self:GetOrder(),
    type = "description",
    name = credits,
  }
end

O:AddCallback("General")
